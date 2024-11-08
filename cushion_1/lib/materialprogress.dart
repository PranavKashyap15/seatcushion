import 'dart:async';
import 'package:cushion_1/adduser.dart';
import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/bluettoth_data.dart';
import 'package:cushion_1/changeuser.dart';
import 'package:cushion_1/communicationhandler.dart';
import 'package:cushion_1/generatestats.dart';
import 'package:cushion_1/heatmap_generate.dart';
import 'package:cushion_1/hexcolor.dart';
import 'package:cushion_1/home_screen.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:cushion_1/pdfviewer.dart';
import 'package:cushion_1/pressurelistwidget.dart';
import 'package:cushion_1/seat_functions_fragment.dart';
import 'package:cushion_1/statslocalstorage.dart';
import 'package:cushion_1/usercontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/controllers/flip_card_controllers.dart';
import 'package:flutter_flip_card/flipcard/flip_card.dart';
import 'package:flutter_flip_card/modal/flip_side.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:getwidget/types/gf_progress_type.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:toastification/toastification.dart';

class MaterialProgressWidget extends StatefulWidget {
  const MaterialProgressWidget({super.key});

  @override
  MaterialProgressWidgetState createState() => MaterialProgressWidgetState();
}

enum Position { left, right, back, forward,leftreposition,forwardreposition,backreposition,rightreposition}

class MaterialProgressWidgetState extends State<MaterialProgressWidget>
    with SingleTickerProviderStateMixin {
      final Statslocalstorage statsController = Get.put(Statslocalstorage()); 
       static MaterialProgressWidgetState get to => Get.find(); 

  int selectedDuration = 1; 
      bool isDialogOpen = false;
  Timer? reminderTimer;    
  final FlipCardController _flipCardController = FlipCardController();
  late Interpreter _interpreter;
  bool _isModelLoaded = false;
  Map<int, double> cellPressures = {};
   int misclassifiedSeconds = 0;
  // Variable to track accuracy for each reposition
// Make positionAccuracy observable
var positionAccuracy = {
  "leftreposition": 0.0,
  "rightreposition": 0.0,
  "forwardreposition": 0.0,
  "backreposition": 0.0,
}.obs;

  StreamSubscription<Map<int, double>>? cellPressureSubscription;
  final Statslocalstorage lc = Get.put(Statslocalstorage());
  DateTime? lastUpdateTime;
  late AnimationController _controller;
  bool isRepositioningActive = false;
  bool isRepositioningRestartRequired = false;
   final ProgressController progressController = Get.put(ProgressController());
  final Map<String, Color> positionColors = {
  "leftreposition": HexColor('#F56E98'),
  "rightreposition":  HexColor('#87A0E5'),
  "backreposition": HexColor('#F1B440'),
  "forwardreposition": HexColor('#A4DC63'),
};

  String currentImagePath = 'assets/nopicture.png';
  String currentPositionText = 'BLE NOT CONNECTED';
  Position? selectedPosition;
  final List<Position> sequence = [
    Position.leftreposition,
    Position.rightreposition,
     Position.forwardreposition,
    Position.backreposition
  ];
  int countermisclassified =0;
  int sequenceIndex = 0;
  int _selectedIndex = 0;
  final Localstoragefunctions localStorageFunctions = Localstoragefunctions();
  late int animationDurationInSeconds;
  Timer? positionCheckTimer;
  List<String> currentposition  = [];
  List<String> detectedPositions = [];
  List<String> undetectedPositions = ["leftreposition", "rightreposition", "forwardreposition", "backreposition"];
    String? currentUserEmail;
  String? currentUserName;
   final UserController userController = Get.find<UserController>(); 
   @override

@override
void initState() {
  super.initState();

  // Initialize the animation controller with a default duration
  animationDurationInSeconds = localStorageFunctions.getDuration();
  _controller = AnimationController(
    vsync: this,
    duration: Duration(seconds: animationDurationInSeconds),
  )..addListener(() {
      setState(() {});
    });

  // Listen for changes in the user email and name
  ever(userController.userEmail, (_) {
    onUserChange();
  });

  ever(userController.userName, (_) {
    onUserChange();
  });

  // Fetch the current user details when the widget is first created
  loadUserDetails();
  loadModel();
  setupDataListener();
}

void onUserChange() {
  // Ensure the controller is initialized before using it
  if (_controller != null) {
    // Reload the user-specific animation details whenever the user changes
   // print('User changed to: ${userController.getUserEmail}, ${userController.getUserName}');

    setState(() {
      animationDurationInSeconds = localStorageFunctions.getDuration();
      _controller.duration = Duration(seconds: animationDurationInSeconds);

      // Restart the controller if it's animating
      if (_controller.isAnimating) {
        _controller.reset();
        _controller.forward();
      }
    });

    // Reload the reminder timer and other user-specific settings
    restartReminderTimer();
  }
}


  void loadUserDetails() {
      final GetStorage storage = GetStorage();
  // Retrieve the current user details from GetStorage
  String? email = storage.read('currentUserEmail');
  String? name = storage.read('currentUserName');
  
  if (email != null && name != null) {
    // Set the current user in the UserController
    userController.setUserEmailAndName(email, name);
    // Initialize data for the current user (e.g., stats, times, etc.)
    statsController.setUserEmail(email);
    statsController.initializeUserData();
  } else {
   // print('No user found in storage.');
  }
}
  //  void startReminderTimer() {
  //   int intervalInSeconds = localStorageFunctions.getReminderInterval();
  //   if (intervalInSeconds > 0) {
  //     reminderTimer = Timer.periodic(Duration(seconds: intervalInSeconds), (timer) {
  //       showReminderDialog();
  //     });
  //   }
  // }
void startReminderTimer() {
  // Ensure the reminder interval is fetched based on the selected user
  String currentUserName = userController.getUserName;
  
  if (currentUserName.isNotEmpty) {
    // Get the reminder interval for the selected user
    int intervalInSeconds = localStorageFunctions.getReminderInterval();
    
    // If the interval is valid (greater than 0), start the reminder timer
    if (intervalInSeconds > 0) {
      reminderTimer = Timer.periodic(Duration(seconds: intervalInSeconds), (timer) {
        showReminderDialog();
      });
   //   print('Reminder timer started for user: $currentUserName with interval: $intervalInSeconds seconds');
    } else {
     // print('No valid reminder interval found for user: $currentUserName');
    }
  } else {
   // print('No user selected for reminders.');
  }
}

  void showReminderDialog() {
    if (isDialogOpen) return; // Prevent opening another dialog if one is already open
  isDialogOpen = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reminder'),
          content: const Text('It\'s time to adjust your posture!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                restartReminderTimer();
              },
            ),
            TextButton(
              child: const Text('Snooze'),
              onPressed: () {
                Navigator.of(context).pop();
                restartReminderTimer();
              },
            ),
          ],
        );
      },
    );
  }

 void restartReminderTimer() {
    reminderTimer?.cancel();
     isDialogOpen = false;
    startReminderTimer();
  }

void showDurationDialog(BuildContext context) {
  // Generate a list of seconds from 1 to 60
  List<int> durations = List<int>.generate(60, (int index) => index + 1);
  int tempSelectedDuration = selectedDuration; // Use a temporary variable to handle selection within the dialog

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder( // Use StatefulBuilder to manage state inside the dialog
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/setduration.png', // Replace with your image path
                  width: 24, // Set the width of the image
                  height: 24, // Set the height of the image
                ),
                const SizedBox(width: 8), // Add some spacing between the icon and text
                const Text('Set Duration'),
              ],
            ),
            content: SizedBox(
              width: 100, // Set the width of the dropdown
              child: DropdownButton<int>(
                value: tempSelectedDuration,
                isExpanded: true, // Ensures the text is properly shown in the reduced width
                items: durations.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value seconds'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  if (newValue != null) {
                    // Call setState inside the StatefulBuilder to update the dropdown UI
                    setState(() {
                      tempSelectedDuration = newValue;
                    });
                  }
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog without saving
                },
              ),
              TextButton(
                child: const Text('Set'),
                onPressed: () {
                  // Close the dialog and pass the selected value back to the parent widget
                  Navigator.of(context).pop(tempSelectedDuration);
                },
              ),
            ],
          );
        },
      );
    },
  ).then((selectedValue) {
    // After dialog is dismissed, update the state in the parent widget
    if (selectedValue != null) {
      setState(() {
        selectedDuration = selectedValue;
        animationDurationInSeconds = selectedDuration;
        _controller.duration = Duration(seconds: animationDurationInSeconds);
        localStorageFunctions.saveDuration(animationDurationInSeconds);

        if (_controller.isAnimating) {
          _controller.reset();
          _controller.forward();
        }
      });
    }
  });
}

void showSetReminderDialog(BuildContext context) {
  // Variables to store selected hours, minutes, and seconds
  int selectedHours = 0;
  int selectedMinutes = 0;
  int selectedSeconds = 0;

  // Dropdown lists for hours, minutes, and seconds
  List<int> hoursList = List.generate(24, (index) => index); // 0 to 23 hours
  List<int> minutesList = List.generate(60, (index) => index); // 0 to 59 minutes
  List<int> secondsList = List.generate(60, (index) => index); // 0 to 59 seconds

  // Fetch current reminder interval from local storage (in seconds)
  int currentIntervalInSeconds = localStorageFunctions.getReminderInterval();

  // Convert current interval to hours, minutes, and seconds for display
  String getCurrentIntervalString(int seconds) {
    if (seconds >= 3600) {
      int hours = seconds ~/ 3600;
      return "$hours Hour${hours > 1 ? 's' : ''}";
    } else if (seconds >= 60) {
      int minutes = seconds ~/ 60;
      return "$minutes Minute${minutes > 1 ? 's' : ''}";
    } else {
      return "$seconds Second${seconds > 1 ? 's' : ''}";
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Center(child: Text('Set Reminder')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Present Reminder Frequency: ${getCurrentIntervalString(currentIntervalInSeconds)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButton<int>(
                      value: selectedHours,
                      items: hoursList.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Hours'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedHours = newValue ?? 0;
                        });
                      },
                    ),
                    const SizedBox(width: 30),
                    DropdownButton<int>(
                      value: selectedMinutes,
                      items: minutesList.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Minutes'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedMinutes = newValue ?? 0;
                        });
                      },
                    ),
                    const SizedBox(width: 30),

                    DropdownButton<int>(
                      value: selectedSeconds,
                      items: secondsList.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Seconds'),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedSeconds = newValue ?? 0;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Set'),
                onPressed: () {
                  int totalIntervalInSeconds = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds;
                  if (totalIntervalInSeconds > 0) {
                    localStorageFunctions.saveReminderInterval(totalIntervalInSeconds);
                    restartReminderTimer();  
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}


Future<void> loadModel() async {
    try {
       _interpreter = await Interpreter.fromAsset('assets/seatcushion_new_0008.tflite');
      setState(() {
        _isModelLoaded = true;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load the model: $e');
      }
    }
  }

// void setupDataListener() {
//   final communicationHandler = CommunicationHandler.getInstance();
//   cellPressureSubscription = communicationHandler.cellPressureUpdates.listen((cellPressures) {
//     if (mounted) {
//       print(cellPressures);
//       runInference(cellPressures);
//     }
//   });

//   startPositionCheckTimer();
// }

// void setupDataListener() {
//   final communicationHandler = CommunicationHandler.getInstance();
  
//   cellPressureSubscription = communicationHandler.cellPressureUpdates.listen((cellPressures) {
//     if (mounted) {
//       // Create a new map with the adjusted cell pressure values
//       Map<int, double> adjustedCellPressures = {};

//       // Loop through each cell pressure and divide by 6.89
//       cellPressures.forEach((cellIndex, pressureValue) {
//         adjustedCellPressures[cellIndex] = pressureValue / 6.89;
//       });
//       print(adjustedCellPressures);

//       // Pass the adjusted cell pressures to runInference
//       runInference(adjustedCellPressures);
//     }
//   });

//   startPositionCheckTimer();
// }
// void setupDataListener() {
//   final communicationHandler = CommunicationHandler.getInstance();

//   cellPressureSubscription = communicationHandler.cellPressureUpdates.listen((cellPressures) {
//     if (mounted) {
//       // Create a new map to store adjusted cell pressures
//       Map<int, double> adjustedCellPressures = {};

//       // Iterate over the first 48 cells (assuming cell numbers range from 1 to 48)
//       for (int i = 0; i < 48; i++) {
//         final cellNumber = i + 1; // Assuming cell numbers start from 1
//         final pressureValue = cellPressures[cellNumber] ?? 0.0; // Get pressure or 0 if not present
//         final convertedPressure = pressureValue / 6.89; // Convert the pressure value
//         adjustedCellPressures[cellNumber] = convertedPressure; // Store in the adjusted map
//       }
//       print(adjustedCellPressures);
//       // Pass the adjusted pressures to runInference
//       runInference(adjustedCellPressures);
//     }
//   });

//   startPositionCheckTimer();
// }
void setupDataListener() {
  final communicationHandler = CommunicationHandler.getInstance();

  cellPressureSubscription = communicationHandler.cellPressureUpdates.listen((cellPressures) {
    if (mounted) {
      // Create a new map to store adjusted cell pressures
      Map<int, double> adjustedCellPressures = {};

      // Iterate over the first 48 cells (assuming cell numbers range from 1 to 48)
      for (int i = 0; i < 48; i++) {
        final cellNumber = i + 1; // Assuming cell numbers start from 1
        final pressureValue = cellPressures[cellNumber] ?? 0.0; // Get pressure or 0 if not present
        final convertedPressure = (pressureValue / 6.89).toStringAsFixed(4); // Convert and round to 2 decimal places
       // adjustedCellPressures[cellNumber] = double.parse(convertedPressure); // Convert back to double
      }
    //  print("CELL PRESSURES FROM MP $cellPressures ");
      // Pass the adjusted pressures to runInference
      runInference(cellPressures);
    }
  });

  startPositionCheckTimer();
}

void showMaterialDialog(BuildContext context, {required String title, required String message, String? lottieAsset}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(const Duration(seconds: 6), () {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();}
          });
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: 300.0, // Set your desired width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16.0),
              if (lottieAsset != null)
                SizedBox(
                  width: 150, // Set the desired width
                  height: 150, // Set the desired height
                  child: Lottie.asset(
                    lottieAsset,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showMaterialDialogbroken(BuildContext context, {required String title, required String message, String? lottieAsset}) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
        Timer(const Duration(seconds: 6), () {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: 300.0, // Set your desired width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16.0),
              if (lottieAsset != null)
                SizedBox(
                  width: 150, // Set the desired width
                  height: 150, // Set the desired height
                  child: Lottie.asset(
                    lottieAsset,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
    
              IconsButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'OK',
                iconData: Icons.check,
                color: Colors.blue,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ],
          ),
        ),
      );
    },
  );
}
void showMaterialDialogrestart(BuildContext context, {required String title, required String message, String? lottieAsset}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(const Duration(seconds: 6), () {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: 300.0, // Set your desired width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16.0),
              if (lottieAsset != null)
                SizedBox(
                  width: 150, // Set the desired width
                  height: 150, // Set the desired height
                  child: Lottie.asset(
                    lottieAsset,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            
              // IconsButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   text: 'OK',
              //   iconData: Icons.check,
              //   color: Colors.blue,
              //   textStyle: const TextStyle(color: Colors.white),
              //   iconColor: Colors.white,
              // ),
            ],
          ),
        ),
      );
    },
  );
}
void showMaterialDialogNext(BuildContext context, {required String title, required String message, String? lottieAsset}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Timer(const Duration(seconds: 10), () {
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });

      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: 300.0, // Set your desired width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16.0),
              if (lottieAsset != null)
                SizedBox(
                  width: 150, // Set the desired width
                  height: 150, // Set the desired height
                  child: Lottie.asset(
                    lottieAsset,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            
              // IconsButton(
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              //   text: 'OK',
              //   iconData: Icons.check,
              //   color: Colors.blue,
              //   textStyle: const TextStyle(color: Colors.white),
              //   iconColor: Colors.white,
              // ),
            ],
          ),
        ),
      );
    },
  );
}
void showMaterialDialogDetection(BuildContext context, {required String title, required String message, String? lottieAsset}) {
  // Cancel any existing dialog before showing a new one
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }

  // Start the timer before showing the dialog
  Timer(const Duration(seconds: 1), () {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  });

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: 300.0, // Set your desired width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16.0),
              if (lottieAsset != null)
                SizedBox(
                  width: 150, // Set the desired width
                  height: 150, // Set the desired height
                  child: Lottie.asset(
                    lottieAsset,
                    fit: BoxFit.contain,
                  ),
                ),
              const SizedBox(height: 16.0),
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    },
  );
}

void startPositionCheckTimer() {
  // Cancel any existing timer to avoid overlap
  positionCheckTimer?.cancel();

  // Start a new timer
  positionCheckTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
    if (!mounted || !_controller.isAnimating || !isRepositioningActive) {
      timer.cancel();
      return;
    }

    // Check if the current position matches the expected position
    if (currentPositionText.toLowerCase() != sequence[sequenceIndex].toString().split('.').last.toLowerCase()) {
      if (kDebugMode) {
        print("Sequence broken in timer: Expected ${sequence[sequenceIndex]}, but detected $currentPositionText");
      }

      // Increment the misclassification counter
      countermisclassified++;

      // Display message after 3 misclassifications
      if (countermisclassified == 6 && isRepositioningActive) {
        String position = "";
        switch (sequence[sequenceIndex]) {
          case Position.left:
            position = "Left";
            break;
          case Position.right:
            position = "Right";
            break;
          case Position.back:
            position = "Back";
            break;
          case Position.forward:
            position = "Forward";
            break;
          case Position.leftreposition:
            position = "Left Reposition";
            break;
          case Position.forwardreposition:
            position = "Forward Reposition";
            break;
          case Position.backreposition:
            position = "Back Reposition";
            break;
          case Position.rightreposition:
            position = "Right Reposition";
            break;
        }
        if (kDebugMode) {
          print("$countermisclassified");
        }
        showMaterialDialogDetection(
          context,
          title: "PLEASE CHANGE TO POSITION $position",
          message: "POSITION DETECTED AS $currentPositionText",
          lottieAsset: 'assets/animation_no.json',
        );
      }

      if (countermisclassified == 400) {
        isRepositioningActive = false;
        sequenceBroken();
        timer.cancel();
      }
    } else {
      if (kDebugMode) {
        print("Position check passed in timer: ${sequence[sequenceIndex]} matched $currentPositionText");
      }
    }
  });
}
void _startOrResetTimer(Position position) {
   if (!isRepositioningActive) {
    // Do nothing if repositioning is not active
    return;
  }
  if (kDebugMode) {
    print('Current position: $position');
    print('Expected position: ${sequence[sequenceIndex]}');
    print('Sequence index: $sequenceIndex');
    print("UNDETECTED POSITIONS  $undetectedPositions");
    print("DETECTED POSITIONS  $detectedPositions");
  }

  if (position == sequence[sequenceIndex]) {
    if (_controller.isAnimating) {
      if (kDebugMode) {
        print('Timer is already running. Resetting timer.');
      }
      _controller.reset();
    } else {
      if (kDebugMode) {
        print('Starting timer.');
      }
      _controller.forward(from: 0.0);
    }

    _controller.removeStatusListener(_animationStatusListener);
    _controller.addStatusListener(_animationStatusListener);

    // Always reset the timer when a new position starts
    startPositionCheckTimer();
  } else {
    if (kDebugMode) {
      print("DID NOT MATCH THIS FROM STARTOR RESET FUNCTION");
    }
    sequenceBroken();
  }
}

void stopTimer() {
  if (kDebugMode) {
    print("Timer stopped called ");
  }
  _controller.stop();
  _controller.removeStatusListener(_animationStatusListener);
   positionCheckTimer?.cancel();
}



void runInference(Map<int, double> cellPressures) {
  if (!_isModelLoaded || cellPressures.isEmpty) return;

  List<double> input = [];
  for (int index = 0; index < 48; index++) {
    double pressureValue = cellPressures[index + 1] ?? 0.0;
    input.add(pressureValue);
  }
  var output = List.filled(1 * 10, 0.0).reshape([1, 10]);
  try {
   // print("input");
  //  print(input);
    _interpreter.run(input, output);
    updatePositionText(output[0]);
  } catch (e) {
    if (kDebugMode) {
      print('Failed to run the model: $e');
    }
  }
}

void updatePositionText(List<double> outputData) {
 // Class labels corresponding to the postures
      List<String> classLabels = [
        'Back', 'BackReposition', 'Forward', 'ForwardReposition', 'Left',
        'LeftReposition', 'NoPosture', 'Normal', 'Right', 'RightReposition'
      ];

      // Find the index with the maximum value (most confident prediction).
      int predictedIndex = 0;
      double maxScore = outputData[0];

      for (int i = 1; i < outputData.length; i++) {
        if (outputData[i] > maxScore) {
          maxScore = outputData[i];
          predictedIndex = i;
        }
      }

      String predictedClass = classLabels[predictedIndex];

     // print(predictedClass);
  setState(() {
    currentPositionText = predictedClass.toLowerCase(); // Ensure it's lowercase for comparison
    switch (predictedClass) {
      case "LeftReposition":
        currentImagePath = 'assets/left1.gif';
        break;
      case "RightReposition":
        currentImagePath = 'assets/right1.gif';
        break;
      case "BackReposition":
        currentImagePath = 'assets/back1.gif';
        break;
      case "ForwardReposition":
        currentImagePath = 'assets/forward1.gif';
        break;
      case "Right":
        currentImagePath = 'assets/rightrepo.png';
        break;
      case "Forward":
        currentImagePath = 'assets/forwardrepo.png';
        break;
      case "Back":
        currentImagePath = 'assets/backrepo.png';
        break;
      case "Left":
        currentImagePath = 'assets/leftrepo.png';
        break;
      case "NoPosture":
        currentImagePath = 'assets/White.png';
        break;
      default:
        currentImagePath = 'assets/normal1.png';
        break;
    }
  });
 DateTime currenttime = DateTime.now();
  if (lastUpdateTime == null || currenttime.difference(lastUpdateTime!) >= const Duration(seconds: 1)) {
    // Run the updatePosition in a separate microtask
    Future.microtask(() {
      try {
        lc.updatePosition(currentPositionText);
      } catch (e) {
    //    print('Failed to update position: $e');
      }
    });
    lastUpdateTime = currenttime;
  }
}


void checkCurrentPosition() {
  if (!isRepositioningActive || sequenceIndex >= sequence.length) {
    return;
  }

  Position expectedPosition = sequence[sequenceIndex];
  String expectedPositionText = expectedPosition.toString().split('.').last.toLowerCase();
  if (kDebugMode) {
    print('Checking position: $currentPositionText, Expected: $expectedPositionText');
  }

  if (currentPositionText.toLowerCase() != expectedPositionText) {
    if (kDebugMode) {
      print("Sequence  broken: Expected $expectedPositionText, but detected $currentPositionText");
    }
    stopTimer();  // Stop the timer if the sequence is broken
    sequenceBroken();
  } else {
    // If the position matches, you can either continue the timer or proceed to the next step.
    if (kDebugMode) {
      print("Position matched: $currentPositionText");
    }
  }
}
void _animationStatusListener(AnimationStatus status) {
  if (status == AnimationStatus.completed) {
    // Calculate accuracy for the current position
    String position = sequence[sequenceIndex].toString().split('.').last.toLowerCase();
    double accuracy = ((animationDurationInSeconds - countermisclassified) / animationDurationInSeconds) * 100;
    positionAccuracy[position] = accuracy;

    // Reset misclassification counter for the next position
    countermisclassified = 0;

    sequenceIndex++;

    if (sequenceIndex >= sequence.length) {
        bool allAbove95 = positionAccuracy.values.every((accuracy) => accuracy >= 0.0);

      if (allAbove95) {
      
      //  print("storing");
        lc.storeRepositionCompletionInFirestore();

        Map<String, double> accuracies = {
        "leftreposition": positionAccuracy["leftreposition"] ?? 0.0,
        "rightreposition": positionAccuracy["rightreposition"] ?? 0.0,
        "forwardreposition": positionAccuracy["forwardreposition"] ?? 0.0,
        "backreposition": positionAccuracy["backreposition"] ?? 0.0,
      };
      lc.storeAvgAccuracy(accuracies);
      }
      showMaterialDialog(
        context,
        title: "WELL DONE",
        message: "You have successfully completed the entire sequence.",
        lottieAsset: 'assets/animation_done.json',
      );
      _flipCardController.flipcard();
      sequenceIndex = 0;
      _controller.reset();
      positionCheckTimer?.cancel();
      isRepositioningActive = false;
      isRepositioningRestartRequired = true;
    } else {
      positionCheckTimer?.cancel(); 
      Future.delayed(const Duration(seconds: 10), () {
        Position expectedPosition = sequence[sequenceIndex];
        String expectedPositionText = expectedPosition.toString().split('.').last.toLowerCase();
        setState(() {
          detectedPositions.add(expectedPositionText);
          undetectedPositions.remove(expectedPositionText);
        });
        countermisclassified = 0;
        _startOrResetTimer(sequence[sequenceIndex]);
        if (kDebugMode) {
          print("CHECKING AFTER INCREMENTING ");
        }
        startPositionCheckTimer();
      });
      showMaterialDialogNext(
        context,
        message: "${sequence[sequenceIndex - 1].toString().split('.').last} position completed",
        title: "Move to  ${sequence[sequenceIndex].toString().split('.').last} position in ",
        lottieAsset: 'assets/animation_next.json',
      );
    }
    _controller.removeStatusListener(_animationStatusListener);
  }
}
void startRepositioning() {
  progressController.resetProgressValues();
  _flipCardController.flipcard();

  positionAccuracy.updateAll((key, value) => 0.0);

  if (isRepositioningRestartRequired) {
    isRepositioningRestartRequired = false; 
  } else if (isRepositioningActive) {
    
    return;
  }

  isRepositioningActive = true;  
  sequenceIndex = 0; 
  countermisclassified=0;
  // Reset the detected and undetected positions at the start of repositioning
  resetLists();
  
  showMaterialDialog(
    context,
    title: "GET READY!",
    message: "Repositioning will start in",
    lottieAsset: 'assets/animation_start.json',
  );

  // Provide a 5-second buffer time
  Future.delayed(const Duration(seconds: 7), () {
    if (kDebugMode) {
      print('Buffer time completed');
    }
    String expectedPositionText = sequence[sequenceIndex].toString().split('.').last.toLowerCase();
    if (detectedPositions.contains(currentPositionText.toLowerCase())) {
      if (kDebugMode) {
        print('Position already detected, restarting sequence');
      }
      sequenceBroken();
    } else {
      if (undetectedPositions.contains(expectedPositionText)) {
        if (kDebugMode) {
          print('Moving position from undetected to detected');
        }
        setState(() {
          detectedPositions.add(expectedPositionText);
          undetectedPositions.remove(expectedPositionText);
        });

        if (kDebugMode) {
          print('Starting timer for position: $expectedPositionText');
        }
        _startOrResetTimer(sequence[sequenceIndex]);
      } else {
        if (kDebugMode) {
          print('Error: Position not found in undetectedPositions');
        }
      }
    }
  });
}


void resetLists() {
  setState(() {
    detectedPositions.clear();
    undetectedPositions = ["leftreposition", "rightreposition", "forwardreposition", "backreposition"];
  });
  if (kDebugMode) {
    print("Reset detected and undetected positions lists");
  }
}

void sequenceBroken() {
//print("SEQUNECE BROKEN IS CALLED ");
  _flipCardController.flipcard();
  sequenceIndex = 0;
  countermisclassified=0;
  _controller.reset();
  positionCheckTimer?.cancel();
  isRepositioningActive = false;
  isRepositioningRestartRequired = true; 
  resetLists();

  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }


  showMaterialDialogbroken(
      context,
      title: "Sequence Restarted",
      message: "The sequence was broken. Please start from the beginning.",
      lottieAsset: 'assets/animation_restart.json',
    );


}

  

  void showToastification(BuildContext context,
      {required Widget title,
      required Widget description,
      Color primaryColor = Colors.green}) {
    final toastification = Toastification();

    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 5),
      title: title,
      description: description,
      alignment: Alignment.bottomCenter,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: const Icon(Icons.check),
      primaryColor: primaryColor,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      foregroundColor: const Color.fromARGB(255, 0, 0, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  @override
  void dispose() {
    reminderTimer?.cancel();
     positionCheckTimer?.cancel(); 
    cellPressureSubscription?.cancel();
    _controller.dispose();
      saveCurrentUserData();
    _interpreter.close();
    super.dispose();
  }
  void saveCurrentUserData() {
    //print("THIS METHOD IS CALLED WHEN YOU CLOSE THE APP ");
      localStorageFunctions.saveUserDetails(userController.getUserEmail, userController.getUserName);
 
}
Widget buildDetectedPositionCard(String currentImagePath, String positionText) {
  return Container(
    height: MediaQuery.of(context).size.width > 600 
      ? 260
      : MediaQuery.of(context).size.height * 0.2,
    margin: const EdgeInsets.fromLTRB(25, 25, 25, 15),
    decoration: BoxDecoration(
      color: AppColors.bgSecondayLight,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8.0),
        bottomLeft: Radius.circular(68.0),
        bottomRight: Radius.circular(8.0),
        topRight: Radius.circular(68.0)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          offset: const Offset(1.1, 1.1),
          blurRadius: 10.0),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
                    Expanded(
            flex: 2,
            child: Container(
              height: 290, // Adjust the height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(currentImagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: buildPositionText(positionText),
          ),
        ],
      ),
    ),
  );
}

  Widget buildPositionText(String positionText) {
    // print('Current positionText: $positionText');
    return Center(
      child: Column(
       // mainAxisSize: MainAxisSize.min,

        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Detected Position',
            style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold,color:Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            // child: Text(
            //   positionText.toUpperCase(),
            //   style: const TextStyle(fontSize: 28, fontStyle: FontStyle.italic,fontWeight:FontWeight.bold,color: Color.fromARGB(255, 19, 2, 253)),
            // ),
           
            child: Text(
        positionText == "noposture" ? '' : positionText.toUpperCase(),
        style: const TextStyle(
          fontSize: 28,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 19, 2, 253),
        ),
      ),
          ),
        ],
      ),
    );
  }

  Widget buildPositionIndicator() {

   return GestureDetector(
      onTap: () {
         _flipCardController.flipcard(); // Flip the card manually
         if (isRepositioningActive) {
          sequenceBroken();
          stopTimer();
          if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Ensure any active dialogs are closed when flipping the card
        }
        }

      },
      child: FlipCard(
        controller: _flipCardController,
        frontWidget: buildFrontWidget(),
        backWidget: buildBackWidget(),
        axis: FlipAxis.vertical,
        rotateSide: RotateSide.right,
      ),
    );
  
  

}
Widget buildBackWidget() {
   List<String> allPositions = ["LEFTREPOSITION", "RIGHTREPOSITION", "FORWARDREPOSITION", "BACKREPOSITION"];
       return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgSecondayLight,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(68.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(left: 40, right: 24, top: 8, bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: allPositions
                    .map((position) => buildPositionBar(position))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
}

  Widget buildTimeIndicator(AnimationController controller) {
    return SizedBox(
      height: 300,
      child: Card(
        margin: const EdgeInsets.all(30),
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Expanded(
                child: Text(
                  "Time",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: buildCircularPercentIndicator(controller),
              ),
            ],
          ),
        ),
      ),
    );
  }


Widget buildFrontWidget() {
  
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        
         decoration: BoxDecoration(
       color: AppColors.bgSecondayLight,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(68.0),
            bottomRight: Radius.circular(8.0),
            topRight: Radius.circular(68.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(1.1, 1.1),
              blurRadius: 10.0),
        ],
      ),
        height: MediaQuery.of(context).size.width > 600 
  ? 285
  : MediaQuery.of(context).size.height * 0.2,
        width: 580,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          GestureDetector(
              onTap: () {
               
                 startRepositioning();
              },
              child: Container(
                width: 450,
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      //  HexColor('#62cff4'),
                      //   HexColor('#87d9f7'),
                      HexColor('#FFFFFF'),
                      HexColor('#FFFFFF')
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(5, 5),
                      blurRadius: 10,
                    )
                  ],
                ),
                child:  Center(
                  child:  Text(
            'Start Weight Shifting Protocol',
            textAlign: TextAlign.center,
           style: TextStyle(fontWeight: FontWeight.bold,color: HexColor('#000000'),fontSize: 28),
          
          ),
                ),
              ),
            ),
        
         
          ],
        ),
      ),
    ),
  );
}
  
Widget buildPositionBar(String position) {
  final ProgressController progressController = Get.find();

  bool isDetected = detectedPositions.contains(position.toLowerCase());
//  bool isCurrentPosition = position.toUpperCase() == currentPositionText.toUpperCase();
  bool isCurrentSequence = position.toUpperCase() == sequence[sequenceIndex].toString().split('.').last.toUpperCase();
  String positionTextUi = "";

  // Set position text based on the current position
  switch (position.toLowerCase()) {
    case "leftreposition":
      positionTextUi = "Left\nReposition";
      break;
    case "forwardreposition":
      positionTextUi = "Forward\nReposition";
      break;
    case "backreposition":
      positionTextUi = "Back\nReposition";
      break;
    case "rightreposition":
      positionTextUi = "Right\nReposition";
      break;
  }

  // Check if the position matches the current sequence and is detected
  if (isCurrentSequence && isDetected && isRepositioningActive) {
    // Calculate progress based on misclassifications and time
    double maxMisclassifications = animationDurationInSeconds - 0.08 ; // Maximum number of misclassifications
    //print("MAXIMUM MISCLASSIFICATIONS $maxMisclassifications");
    // Calculate progress based on misclassifications
    double misclassificationProgress = (maxMisclassifications - countermisclassified) / maxMisclassifications;

    // Calculate progress based on time
    double timeProgress = _controller.value; // Assuming _controller.value is 0.0 to 1.0 based on animation time

    // Combined progress: consider both time and misclassification
    double combinedProgress = misclassificationProgress * timeProgress;

    // Ensure the progress value is within the range of 0 to 1
    combinedProgress = combinedProgress.clamp(0.0, 1.0);
    //print(combinedProgress);
    //print("progress values ${progressController.progressValues}");

    // Update the progress controller for the current position only if not completed
    if (combinedProgress < 1.0) {
      progressController.updateProgressValue(position.toLowerCase(), combinedProgress);
      //print("updated less than 1");
    } else if (progressController.progressValues[position.toLowerCase()]! < 1.0) {
      // Once completed, set it to full progress
      progressController.updateProgressValue(position.toLowerCase(), 1.0);
    //  print("updated completed set to full");
    }
  }

  Color barColor = positionColors[position.toLowerCase()] ?? Colors.grey;

  return Obx(() {
    double currentProgressValue = progressController.progressValues[position.toLowerCase()]!;
    double accuracy = positionAccuracy[position.toLowerCase()] ?? 100.0;  // Get accuracy for the current position

    return SizedBox(
      height: 250, // Increase height to accommodate accuracy text
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            positionTextUi,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 50,
              height: 160,
              decoration: BoxDecoration(
                color: barColor.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 160 * currentProgressValue, // Fill based on current progress value
                  width: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      barColor,
                      barColor.withOpacity(0.5),
                    ]),
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),  // Add some space between bar and accuracy text
          Text(
            'Accuracy: ${accuracy.toStringAsFixed(1)}%',  // Display the accuracy
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  });
}



Widget buildCircularPercentIndicator(AnimationController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: CircularPercentIndicator(
      radius: 70.0,
      lineWidth: 10.0,
      percent: controller.value,
      center: Text(
        '${(animationDurationInSeconds * controller.value).toStringAsFixed(0)} sec',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      progressColor: (controller.value * animationDurationInSeconds) < (animationDurationInSeconds / 3)
          ? Colors.red
          : Colors.green,
      backgroundColor: Colors.grey.shade300,
      circularStrokeCap: CircularStrokeCap.round,
    ),
  );
}

Widget buildHorizontalProgressBar(AnimationController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: GFProgressBar(
            radius: 20,
            percentage: controller.value,
            lineHeight: 40,
            type: GFProgressType.linear,
            alignment: MainAxisAlignment.spaceBetween,
            backgroundColor: Colors.black12,
            progressBarColor: (controller.value * animationDurationInSeconds) < (animationDurationInSeconds / 3)
                ? const Color.fromARGB(255, 238, 47, 33)
                : (controller.value * animationDurationInSeconds) < (2 * animationDurationInSeconds / 3)
                    ? Colors.orange
                    : Colors.green,
            progressHeadType: GFProgressHeadType.circular,
            child: Center(
              child: Text(
                '${(animationDurationInSeconds * (1 - controller.value)).clamp(0, animationDurationInSeconds).toInt()} sec',
                textAlign: TextAlign.end,
                style: const TextStyle(fontSize: 28, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    ),
  );
}

// Function to display the Bluetooth turned off card
Widget buildBluetoothOffCard(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.7, // Adjust height as needed
    margin: const EdgeInsets.fromLTRB(25, 25, 25, 15),
    decoration: BoxDecoration(
      color: AppColors.bgSecondayLight,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8.0),
        bottomLeft: Radius.circular(68.0),
        bottomRight: Radius.circular(8.0),
        topRight: Radius.circular(68.0),
      ),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          offset: const Offset(1.1, 1.1),
          blurRadius: 10.0,
        ),
      ],
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/blediscon.png', // Path to your Bluetooth off image
            width: 150, // Adjust width
            height: 150, // Adjust height
          ),
          const SizedBox(height: 16),
          const Text(
            'Bluetooth is Not Connected',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
           const SizedBox(height: 16),
          const Text(
            'Please Connect to Bluetooth (Seat_Cushion_Ble)',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget buildPressureMapSection(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      height: screenSize.height * 0.64,
      width: screenSize.width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Real-Time Pressure Map",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Center(
            child: HeatmapWidget(),
              
            ),
          ),
        ],
      ),
    );
  }
    Future<bool> showReminderBeforeClosing(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reminder'),
        content: const Text('Are you sure you want to close this app?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false to prevent closing
            },
          ),
          TextButton(
            child: const Text('Exit'),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true to allow closing
            },
          ),
        ],
      ),
    ) ?? false; // Return false if the dialog is dismissed
  }


  @override
  Widget build(BuildContext context) {
    return
     PopScope(
    canPop: false,
    onPopInvoked: (didPop) async {
         // Show a confirmation dialog or reminder when trying to close
        bool shouldExit = await showReminderBeforeClosing(context);
        if (shouldExit) {
          Navigator.pop(context); // Close the app if the user confirms
        }
        return ; // Prevent exit if user cancels
    },
       child: Scaffold(
        backgroundColor: AppColors.bgLight,
        appBar: AppBar(
          title: const Text('Seat Cushion'),
         backgroundColor: AppColors.bgLight,
          centerTitle: true,
          actions: <Widget>[
            Consumer<BluetoothData>(
              builder: (context, bluetoothData, child) {
                return IconButton(
                  icon: Image.asset(
                    bluetoothData.isConnected
                        ? 'assets/bluetooth.png'
                        : 'assets/bluetooth_red.png',
                    width: 24,
                    height: 24,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isTab = constraints.maxWidth >= 600;
       
            if (isTab) {
              return IndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              currentPositionText == 'BLE NOT CONNECTED'
                        ? buildBluetoothOffCard(context)  // Function call
                        :  Column(
                            children: [
                              buildDetectedPositionCard(
                                  currentImagePath, currentPositionText),
                              buildPositionIndicator(),
                            ],
                          ),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: buildPressureMapSection(context),
                      // ),
                    Expanded(
         child: Padding(
           padding: const EdgeInsets.all(18.0),
           child: Column(
        children: [
          Row(
            children: [
              // Wrap the progress bar in Flexible with FlexFit.loose
              Flexible(
                fit: FlexFit.loose,
                child: buildHorizontalProgressBar(_controller),
              ),
              const SizedBox(width: 5),  // Add spacing between the progress bar and the GIF
              // Use a fixed-size Box for the GIF to prevent layout issues
              SizedBox(
        width: 50,  // Adjust width as needed
        height: 50, // Adjust height as needed
        child: isRepositioningActive
            ? Lottie.asset(
                'assets/live.json', // Active Lottie animation path
                fit: BoxFit.contain,
              )
            : Container(), // Empty container when inactive
           ),
            ],
          ),
          const SizedBox(height: 20),  // Add space between Row and map section
          Expanded(
            child: buildPressureMapSection(context),  // Existing map section
          ),
        ],
           ),
         ),
       ),
        
                    ],
                  ),
                  
                  Row(
                    children: [
                      const Expanded(
                        child: SeatFunctionsFragment(),
                      ),
                      Expanded(
                        child: buildPressureMapSection(context),
                      ),
                    ],
                  ),
                   Row(
                    children: [
                      Expanded(
                        child: DashboardPage(),
                      ),
                     
                    ],
                  ),
                Row(
                    children: [
                      const Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [PressureListWidget()],
                          ),
                        ),
                      ),
                      Expanded(
                        child: buildPressureMapSection(context),
                      ),
                    ],
                  ),
                   const Row(
          children: [
            Expanded(
              child:  UserAddPage(), // Replace with your AddUserPage widget
            ),
          ],
        ),
       
          const Row(
          children: [
            Expanded(
              child:  PDFViewerScreen(), // Replace with your AddUserPage widget
            ),
          ],
        ),
       
       
          const Row(
          children: [
            Expanded(
              child:  UserListPage(), // Replace with your AddUserPage widget
            ),
          ],
        ),
                ],
              );
            } else {
              return IndexedStack(
                index: _selectedIndex,
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        buildDetectedPositionCard(
                            currentImagePath, currentPositionText),
                        buildPositionIndicator(),
                        buildPressureMapSection(context),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        const PressureListWidget(),
                        buildPressureMapSection(context),
                      ],
                    ),
                  ),
                  const SeatFunctionsFragment(),
                   DashboardPage(),
                ],
              );
            }
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.bgSecondayLight,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: const Color.fromARGB(255, 255, 255, 255),
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.grey[100]!,
                color: Colors.black,
                tabs: [
                  GButton(
         leading: SizedBox(
           width: 26,
           height: 26,
           child: Image.asset('assets/heatmap_2.png'),
         ),
         text: 'MAP',
         icon: Icons.map,
         textStyle: const TextStyle(
           color: Color.fromARGB(255, 7, 7, 7), 
           fontSize: 16,
         
         ),
       ),
       
                  GButton(
                    leading: SizedBox(
                      width: 26,
                      height: 26,
                      child: Image.asset('assets/settings.png'),
                    ),
                    text: 'SEAT FUNCTIONS',
                    icon: Icons.adjust,
                     textStyle: const TextStyle(
           color: Color.fromARGB(255, 7, 7, 7), 
           fontSize: 16,
         
         ),
                  ),
                    GButton(
                    leading: SizedBox(
                      width: 26,
                      height: 26,
                      child: Image.asset('assets/analysis.png'),
                    ),
                    text: 'STATS',
                    icon: Icons.adjust,
                     textStyle: const TextStyle(
           color: Color.fromARGB(255, 7, 7, 7), 
           fontSize: 16,
         
         ),
                  ),
                  
                  GButton(
                    leading: SizedBox(
                      width: 26,
                      height: 26,
                      child: Image.asset('assets/dstats.png'),
                    ),
                    text: 'Detailed Info',
                    icon: Icons.adjust,
                     textStyle: const TextStyle(
           color: Color.fromARGB(255, 7, 7, 7), 
           fontSize: 16,
         
         ),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
           drawer: Drawer(
         child: Container(
       color: AppColors.bgLight,
           child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Custom Profile section
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color:  Color.fromARGB(255, 200, 233, 247),
            ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile_photo.jpg'),  // Add the path to your image
                ),
                const SizedBox(height: 10),  // Spacing between image and text
                 Obx(() {
              return Text(
                userController.getUserName.isEmpty ? 'Guest' : userController.getUserName, // Use getter method
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              );
            }),
       
                const SizedBox(height: 5),
               Obx(() {
              return Text(
                userController.getUserEmail.isEmpty ? 'Not logged in' : userController.getUserEmail, // Use getter method
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              );
            }),
              ],
            ),
          ),
          
          // List options with Cards
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                  color: AppColors.bgSecondayLight,
              child: ListTile(
            leading: Image.asset(
         'assets/posstats.png',  // Replace with your image path
         width: 24,  // Set the width of the image
         height: 24,  // Set the height of the image
       ),
                
                title: const Text('POS STATS'),
                onTap: () {
                  Navigator.pop(context);
                  showStatsDialog(context);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: AppColors.bgSecondayLight,
              child: ListTile(
               leading: Image.asset(
         'assets/notification.png',  // Replace with your image path
         width: 24,  // Set the width of the image
         height: 24,  // Set the height of the image
       ),
                title: const Text('Reminders'),
                onTap: () {
                  Navigator.pop(context);
                  showSetReminderDialog(context); 
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                  color: AppColors.bgSecondayLight,
              child: ListTile(
              leading: Image.asset(
         'assets/frequency.png',  // Replace with your image path
         width: 24,  // Set the width of the image
         height: 24,  // Set the height of the image
       ),
                title: const Text('Duration'),
                onTap: () {
                  Navigator.pop(context);
                  showDurationDialog(context); 
                  
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: AppColors.bgSecondayLight,
              child: ListTile(
               leading: Image.asset(
         'assets/adduser.png',  // Replace with your image path
         width: 24,  // Set the width of the image
         height: 24,  // Set the height of the image
       ),
                title: const Text('Add A User'),
                onTap: () {
                  Navigator.pop(context);
                 // showSetReminderDialog(context); 
                 setState(() {
        _selectedIndex = 4; // Index of your Add User fragment
           });
                },
              ),
            ),
          ),
              Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: AppColors.bgSecondayLight,
              child: ListTile(
         leading: Image.asset(
           'assets/changeuser.png',
           width: 24,
           height: 24,
         ),
         title: const Text('Switch User'),
         onTap: () {
           setState(() {
        _selectedIndex = 6; // Index of your Switch User fragment
           });
           Navigator.pop(context); // Close the drawer
         },
       ),
       
            ),
          ),
          Padding(
         padding: const EdgeInsets.all(8.0),
         child: Card(
           color: AppColors.bgSecondayLight,
           child: ListTile(
        leading: Image.asset(
          'assets/pdf.png',  // Replace with your image path for PDF icon
          width: 24,  // Set the width of the image
          height: 24,  // Set the height of the image
        ),
        title: const Text('View PDF'),
           
                onTap: () {
                Navigator.pop(context);
                 // showSetReminderDialog(context); 
                 setState(() {
        _selectedIndex = 5; // Index of your Add User fragment
           });
                },
           ),
         ),
       ),
       
        ],
           ),
         ),
       )
       ,
       
           
           ),
     );
  }
void showStatsDialog(BuildContext context) {
    final Statslocalstorage statsLocalStorage = Get.find<Statslocalstorage>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Position Stats'),
          content: Obx(() {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: statsLocalStorage.positionTimes.entries.map((entry) {
                  return ListTile(
                    title: Text(entry.key.toUpperCase()),
                    subtitle: Text('${entry.value} seconds'),
                  );
                }).toList(),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
class ProgressController extends GetxController {
  var progressValues = {
    "leftreposition": 0.0,
    "forwardreposition": 0.0,
    "backreposition": 0.0,
    "rightreposition": 0.0,
  }.obs;

  void resetProgressValues() {
    progressValues.updateAll((key, value) => 0.0);
  }

  void updateProgressValue(String position, double value) {
    progressValues[position] = value;
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Text(
          "Position",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Image.asset(
            'assets/chair.gif',
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}


