
import 'package:cushion_1/usercontroller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Localstoragefunctions {
  final GetStorage storage = GetStorage();
  final UserController userController = Get.find<UserController>(); // Retrieve the UserController


  // Save user details (both email and name)
  void setUserEmailAndName(String email, String name) {
    userController.setUserEmailAndName(email, name); // Update in the UserController
    saveUserDetails(email, name); // Save email and name in storage
    saveCurrentUser(email, name); // Save the current selected user details in separate keys
  }

  // Save the current user's email and name for easy retrieval
  void saveCurrentUser(String email, String name) {
    storage.write('currentUserEmail', email);
    storage.write('currentUserName', name);

    // Debugging: Print values to ensure they are being saved
  //  print('Saved current user - Email: $email, Name: $name');
  }

  void setUserEmail(String email) {
    userController.setUserEmail(email); // Update in the UserController
  }

  // Save user-specific reminder interval
  void saveReminderInterval(int interval) {
    storage.write(generateKey('reminderInterval'), interval);
  }

  // Retrieve user-specific reminder interval
  int getReminderInterval() {
    return storage.read(generateKey('reminderInterval')) ?? 0;
  }

  // Save user-specific animation duration
  void saveDuration(int duration) {
    storage.write(generateKey('animationDuration'), duration);
  }

  // Retrieve user-specific animation duration
  int getDuration() {
    return storage.read(generateKey('animationDuration')) ?? 15;
  }
  String generateKey(String key) {
    return '${userController.userName.value}_$key'; // Use the observable userName from the controller
  }

  // Save user-specific position data
  void saveTime(String position, int time) {
    String key = generateKey(position);
    storage.write(key, time);
 //   print("🔹Saved time for position '$position' with key '$key' and value '$time'");
  }

  // Retrieve user-specific position data
  int getTime(String position) {
    String key = generateKey(position);
    int time = storage.read(key) ?? 0;
   // print("🔹Retrieved time for position '$position' with key '$key': $time");
    return time;
  }

  // Save user-specific failed data
  void saveFailedData(Map<String, Map<String, int>> failedData) {
    storage.write(generateKey('failedData'), failedData);
  }

  // Retrieve user-specific failed data
  Map<String, Map<String, int>> getFailedData() {
    // return Map<String, Map<String, int>>.from(storage.read(generateKey('failedData')) ?? {});
    Map<String, dynamic> rawFailedData = storage.read(generateKey('failedData')) ?? {};
Map<String, Map<String, int>> failedData = {};

rawFailedData.forEach((key, value) {
  failedData[key] = Map<String, int>.from(
    value.map((k, v) => MapEntry(k as String, v is int ? v : int.tryParse(v.toString()) ?? 0))
  );
});

return failedData;

  }

  // Clear user-specific failed data
  void clearFailedData() {
    storage.remove(generateKey('failedData'));
  }

  // Save user-specific last updated date
  void saveLastUpdatedDate(String date) {
    storage.write(generateKey('lastUpdatedDate'), date);
  }

  // Retrieve user-specific last updated date
  String? getLastUpdatedDate() {
    return storage.read(generateKey('lastUpdatedDate'));
  }

  // Save user-specific accuracy
  void saveAccuracy(String position, double accuracy) {
    storage.write(generateKey("accuracy_$position"), accuracy);
  }

  // Retrieve user-specific accuracy
  double? getAccuracy(String position) {
    return storage.read(generateKey("accuracy_$position"));
  }

  // Save user-specific details (email and username)
  void saveUserDetails(String email, String name) {
    storage.write('userEmail_$name', email);

    // Ensure usernames are stored as a list of strings
    List<String> usernames = List<String>.from(storage.read<List<dynamic>>('allUsernames') ?? []);
    if (!usernames.contains(name)) {
      usernames.add(name); // Add if it's not already in the list
      storage.write('allUsernames', usernames); // Save updated list
    }
  }

  // Retrieve current user details from storage
  Map<String, String?> getUserDetails() {
    String? email = storage.read('currentUserEmail');
    String? name = storage.read('currentUserName');

    // Debugging: Print the values to verify correct retrieval
  //  print('Retrieved from storage - Email: $email, Name: $name');

    return {'email': email, 'name': name};
  }

  // Get all usernames
  List<String> getAllUsernames() {
    return List<String>.from(storage.read<List<dynamic>>('allUsernames') ?? []);
  }

  // Retrieve email using username
  String? getUserEmailFromUsername(String username) {
    return storage.read('userEmail_$username');
  }

  // Retrieve username using email
  String? getUsernameFromEmail(String email) {
    List<String> allUsernames = getAllUsernames();
    for (String username in allUsernames) {
      if (getUserEmailFromUsername(username) == email) {
        return username;
      }
    }
    return null;
  }

  // Clear stored user details
  void clearUserDetails() {
    storage.remove('currentUserEmail');
    storage.remove('currentUserName');
  }

   void deleteUser(String username) {
    // Remove user-specific data
    String? email = getUserEmailFromUsername(username);
    if (email != null) {
      storage.remove('userEmail_$username'); // Remove the email stored for this user
      storage.remove('reminderInterval_$username'); // Remove user-specific reminder interval
      storage.remove('animationDuration_$username'); // Remove user-specific animation duration
      storage.remove('failedData_$username'); // Remove failed data for the user
      storage.remove('lastUpdatedDate_$username'); // Remove the last updated date for the user
      storage.remove('currentUserEmail'); // Remove current user email
      storage.remove('currentUserName'); // Remove current user name
    }

    // Remove from the usernames list
    List<String> usernames = getAllUsernames();
    usernames.remove(username); // Remove the username from the list
    storage.write('allUsernames', usernames); // Save the updated usernames list

    // Debugging: Print the remaining users after deletion
   // print('User $username deleted. Remaining users: $usernames');
  }
}
