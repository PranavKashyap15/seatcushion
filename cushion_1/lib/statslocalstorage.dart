import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class Statslocalstorage extends GetxController {
  var currentPosition = ''.obs;
  var totalTimeSeatedHours = 0.obs;
  var totalTimeSeatedMinutes = 0.obs;
  var repositionCount = 0.obs;
  var avgLeftReposition = 0.0.obs;
  var avgRightReposition = 0.0.obs;
  var avgForwardReposition = 0.0.obs;
  var avgBackReposition = 0.0.obs;
  var avgLeftAcc = 0.0.obs;
  var avgRightAcc = 0.0.obs;
  var avgForwardAcc = 0.0.obs;
  var avgBackAcc = 0.0.obs;
  
  String userEmail = ''; // User email to store the current user email
  var positionTimes = <String, int>{
    'back': 0,
    'forward': 0,
    'left': 0,
    'normal': 0,
    'right': 0,
    'leftreposition': 0,
    'rightreposition': 0,
    'forwardreposition': 0,
    'backreposition': 0
  }.obs;

  Timer? firestoreTimer;
  DateTime? lastUpdateTime;
  final Localstoragefunctions local = Localstoragefunctions();
  final throttleDuration = const Duration(seconds: 1);

  @override
  void onInit() {
    super.onInit();
    // print("🟢 Initializing Statslocalstorage");
     initializeUserData();

  }
  void initializeUserData() {

     // Fetch the current user email and name from Localstoragefunctions
  Map<String, String?> userDetails = local.getUserDetails();
  userEmail = userDetails['email'] ?? '';  // Set the current user email
  String currentUserName = userDetails['name'] ?? '';  // Set the current user name

//print("🔵 Current user: $currentUserName, Email: $userEmail");
    loadTimes(); // Load times from local storage based on the current user

    checkAndStoreValuesInFirestore();
   // retryFailedUploads(); 
    fetchLastWeekRepositionData();
    loadAccuracies(); // Load accuracies for the current user
  }
  // Method to load accuracies based on the current user
  void loadAccuracies() {
    avgLeftAcc.value = local.getAccuracy("leftreposition") ?? 0.0;
    avgRightAcc.value = local.getAccuracy("rightreposition") ?? 0.0;
    avgForwardAcc.value = local.getAccuracy("forwardreposition") ?? 0.0;
    avgBackAcc.value = local.getAccuracy("backreposition") ?? 0.0;
  }

  // Method to set the user email and store it in Localstoragefunctions
  void setUserEmail(String email) {
    userEmail = email;
    local.setUserEmail(email); // Store it in local storage
  }
Future<void> storeRepositionCompletionInFirestore() async {
  try {
    String email = 'pranavkashyap1506@gmail.com';
    DateTime now = DateTime.now();
    String yearStr = now.year.toString(); // Year (e.g., "2024")
    String monthStr = now.month.toString().padLeft(2, '0'); // Month with leading zero (e.g., "09")

    // Path: users -> email -> reposition_completed -> year -> month
    DocumentReference yearDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('reposition_completed')
        .doc(yearStr);

    DocumentReference monthDoc = yearDoc.collection(monthStr).doc('count');

    // Check if the month document exists
    DocumentSnapshot monthDocSnapshot = await monthDoc.get();

    int currentCount = 0;
    if (monthDocSnapshot.exists) {
      var data = monthDocSnapshot.data() as Map<String, dynamic>; // Cast to Map<String, dynamic>
      currentCount = data['count'] ?? 0;
    }

    int updatedCount = currentCount + 1;

    // Update Firestore with the new count
    await monthDoc.set({'count': updatedCount});

    if (kDebugMode) {
      print("Reposition completion recorded successfully for month $monthStr of year $yearStr.");
    }
  } catch (e) {
    if (kDebugMode) {
      print('Failed to store reposition completion in Firestore: $e');
    }
  }
}
  // Store average accuracy for the current user
  Future<void> storeAvgAccuracy(Map<String, double> newAccuracies) async {
    for (String position in newAccuracies.keys) {
      double existingAccuracy = local.getAccuracy(position) ?? 0.0;
      double newAccuracy = newAccuracies[position]!;
      double avgAccuracy = (existingAccuracy + newAccuracy) / 2;
      local.saveAccuracy(position, avgAccuracy); // Save in local storage

      // Update the observable values
      if (position == 'leftreposition') {
        avgLeftAcc.value = avgAccuracy;
      } else if (position == 'rightreposition') {
        avgRightAcc.value = avgAccuracy;
      } else if (position == 'forwardreposition') {
        avgForwardAcc.value = avgAccuracy;
      } else if (position == 'backreposition') {
        avgBackAcc.value = avgAccuracy;
      }
    }
  }

  // Fetch reposition count for the current user
  Future<void> fetchRepositionCount() async {
    try {
      String email = userEmail; // Use current user email
      DateTime now = DateTime.now();
      String yearStr = now.year.toString();
      String monthStr = now.month.toString().padLeft(2, '0');

      // Path: users -> email -> reposition_completed -> year -> month
      DocumentReference monthDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection('reposition_completed')
          .doc(yearStr)
          .collection(monthStr)
          .doc('count');

      DocumentSnapshot monthDocSnapshot = await monthDoc.get();

      if (monthDocSnapshot.exists) {
        var data = monthDocSnapshot.data() as Map<String, dynamic>;
        var countData = data['count'];
        if (countData is String) {
          repositionCount.value = int.tryParse(countData) ?? 0;
        } else if (countData is int) {
          repositionCount.value = countData;
        } else {
          repositionCount.value = 0;
        }
      } else {
        repositionCount.value = 0;
      }
    } catch (e) {
      if (kDebugMode) {
     //   print('Failed to fetch reposition count: $e');
      }
    }
  }

  // Update total time seated based on the current user's position times
  void updateTotalTimeSeated() {
    int totalTimeInSeconds = positionTimes.entries
        .where((entry) => entry.key != 'noposture')
        .fold(0, (acc, entry) => acc + entry.value);

    totalTimeSeatedHours.value = totalTimeInSeconds ~/ 3600;
    totalTimeSeatedMinutes.value = (totalTimeInSeconds % 3600) ~/ 60;
  }

  // // Load position times based on the current user
  // void loadTimes() {
  //   for (var position in positionTimes.keys) {
  //     positionTimes[position] = local.getTime(position); 
  //     print("position times ${  positionTimes[position]}");// Load user-specific time
  //   }
  // }
// void loadTimes() {
//   for (var position in positionTimes.keys) {
//     positionTimes[position] = local.getTime(position);
//     print("Loaded position $position: ${positionTimes[position]}"); // Debugging statement
//   }
// }

 void loadTimes() {
    //print("🟡 Loading position times from storage for user: $userEmail");

    for (var position in positionTimes.keys) {
      int loadedTime = local.getTime(position);
      positionTimes[position] = loadedTime;
   //   print("🔸 Loaded $position time: $loadedTime"); // Debugging statement
    }
  }
  // Update position time based on the current user
  // void updatePosition(String position) {
  //   DateTime now = DateTime.now();

  //   if ((currentPosition.value.isEmpty || currentPosition.value != position) && position != 'noposture') {
  //     if (currentPosition.value.isNotEmpty) {
  //       if (positionTimes.containsKey(currentPosition.value)) {
  //         positionTimes[currentPosition.value] = positionTimes[currentPosition.value]! + 1;
  //       } else {
  //         positionTimes[currentPosition.value] = 1;
  //       }
  //       local.saveTime(currentPosition.value, positionTimes[currentPosition.value]!); // Save user-specific time
  //     }
  //     currentPosition.value = position;
  //   } else {
  //     if (currentPosition.value.isNotEmpty) {
  //       positionTimes[currentPosition.value] = positionTimes[currentPosition.value]! + 1;
  //     }
  //   }

  //   lastUpdateTime ??= now;

  //   if (now.difference(lastUpdateTime!) >= throttleDuration) {
  //     updateTimeSpent();
  //     lastUpdateTime = now;
  //   }

  //   updateTotalTimeSeated();
  //   checkAndStoreValuesInFirestore();
  // }
 void updatePosition(String position) {
    DateTime now = DateTime.now();

   // print("🔄 Updating position: $position, Current Position: ${currentPosition.value}");

    if ((currentPosition.value.isEmpty || currentPosition.value != position) && position != 'noposture') {
      if (currentPosition.value.isNotEmpty) {
        positionTimes[currentPosition.value] = positionTimes[currentPosition.value]! + 1;
        local.saveTime(currentPosition.value, positionTimes[currentPosition.value]!); // Save user-specific time
      }
      currentPosition.value = position;
    } else {
      if (currentPosition.value.isNotEmpty) {
        positionTimes[currentPosition.value] = positionTimes[currentPosition.value]! + 1;
        local.saveTime(currentPosition.value, positionTimes[currentPosition.value]!);
      }
    }

   // print("✅ Position times after update: ${positionTimes.toString()}");

  lastUpdateTime ??= now;

  if (now.difference(lastUpdateTime!) >= throttleDuration) {
    updateTimeSpent();
    lastUpdateTime = now;
  }

  updateTotalTimeSeated();
  checkAndStoreValuesInFirestore(); // This handles storing in Firestore
}

  // Retry failed Firestore uploads based on the current user
  void retryFailedUploads() async {
    Map<String, Map<String, int>> failedData = local.getFailedData();
    if (failedData.isNotEmpty) {
      for (var date in failedData.keys) {
        positionTimes.assignAll(failedData[date]!);

        bool success = await storeValuesInFirestore(date);
        if (success) {
          failedData.remove(date);
        }
      }
      local.saveFailedData(failedData);
    }
  }

  // Reset reposition averages for the current user
  void resetAvgRepositionTimes() {
    avgLeftAcc.value = 0.0;
    avgRightAcc.value = 0.0;
    avgForwardAcc.value = 0.0;
    avgBackAcc.value = 0.0;
  //  print("Average Reposition times reset to zero.");
  }

  // Check and store values in Firestore based on the current user
  Future<void> checkAndStoreValuesInFirestore() async {
    String currentDateStr = DateTime.now().toLocal().toString().split(' ')[0];
    String? lastUpdatedDateStr = local.getLastUpdatedDate();

    if (lastUpdatedDateStr == null || currentDateStr != lastUpdatedDateStr) {
      resetAvgRepositionTimes();
      bool success = await storeValuesInFirestore(currentDateStr);
      if (success) {
        local.saveLastUpdatedDate(currentDateStr);
      //  resetValues();
      }
    }
  }

  // Store values in Firestore based on the current user
  Future<bool> storeValuesInFirestore(String dateStr) async {
    try {
      String email = userEmail; // Use the current user's email
      DateTime updateDateTime = lastUpdateTime ?? DateTime.now();
      
      String yearStr = updateDateTime.year.toString();
      String monthStr = updateDateTime.month.toString().padLeft(2, '0');
      String dayStr = updateDateTime.day.toString().padLeft(2, '0');

      DocumentReference userDoc = FirebaseFirestore.instance.collection('users').doc(email);
      DocumentReference yearDoc = userDoc.collection('positiondata').doc(yearStr);
      DocumentReference monthDoc = yearDoc.collection(monthStr).doc(dayStr);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var position in positionTimes.keys) {
        DocumentReference positionDoc = monthDoc.collection('positions').doc(position);
        batch.set(positionDoc, {'time': positionTimes[position]});
      }

      await batch.commit();
      //resetValues(); // Reset times for each position
      local.saveFailedData({}); // Clear failed data after successful upload

      return true;
    } catch (e) {
     // print('Failed to store values in Firestore: $e');
      Map<String, Map<String, int>> failedData = local.getFailedData();
      failedData[dateStr] = Map<String, int>.from(positionTimes); // Save current data
      local.saveFailedData(failedData); // Save to local storage
   //   resetValues(); // Reset locally even if the upload failed
      return false;
    }
  }

  // Reset all position values for the current user
  void resetValues() {
    for (var position in positionTimes.keys) {
  local.saveTime(position, positionTimes[position]!); // Save user-specific time
    positionTimes[position] = 0; // Reset to zeroe
    }
  }

  // Update time spent in the current position for the current user
  void updateTimeSpent() {
    if (currentPosition.value.isEmpty) {
      return;
    }
    local.saveTime(currentPosition.value, positionTimes[currentPosition.value]!); // Save user-specific time
  }

  @override
  void onClose() {
    firestoreTimer?.cancel();
     //   print("🔴 Saving position times on close.");
    for (var position in positionTimes.keys) {
        local.saveTime(position, positionTimes[position]!); // Save user-specific time
    }
    super.onClose();
  }

  // Fetch last week's reposition data for the current user
  Future<void> fetchLastWeekRepositionData() async {
    try {
      String email = userEmail; // Use the current user's email
      DateTime now = DateTime.now();
      DateTime oneWeekAgo = now.subtract(const Duration(days: 7));

      var totalTimes = <String, num>{
        'leftreposition': 0,
        'rightreposition': 0,
        'forwardreposition': 0,
        'backreposition': 0,
      };

      int daysFetched = 0;

      for (int i = 0; i < 7; i++) {
        DateTime day = oneWeekAgo.add(Duration(days: i));
        String yearStr = day.year.toString();
        String monthStr = day.month.toString().padLeft(2, '0');
        String dayStr = day.day.toString().padLeft(2, '0');

        DocumentReference monthDoc = FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .collection('positiondata')
            .doc(yearStr)
            .collection(monthStr)
            .doc(dayStr);

        for (var position in totalTimes.keys) {
          DocumentReference positionDoc = monthDoc.collection('positions').doc(position);
          DocumentSnapshot positionSnapshot = await positionDoc.get();

          if (positionSnapshot.exists) {
            var data = positionSnapshot.data() as Map<String, dynamic>;
            totalTimes[position] = totalTimes[position]! + (data['time'] ?? 0);
          }
        }

        daysFetched++;
      }

      // Calculate average time in hours
      if (daysFetched > 0) {
        avgLeftReposition.value = (totalTimes['leftreposition']! / daysFetched) / 3600;
        avgRightReposition.value = (totalTimes['rightreposition']! / daysFetched) / 3600;
        avgForwardReposition.value = (totalTimes['forwardreposition']! / daysFetched) / 3600;
        avgBackReposition.value = (totalTimes['backreposition']! / daysFetched) / 3600;
      }

    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch last week reposition data: $e');
      }
    }
  }
}
