import 'dart:async';
import 'package:cushion_1/statslocalstorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class AccuracyCard extends StatefulWidget {
  const AccuracyCard({super.key});

  @override
  AccuracyCardState createState() => AccuracyCardState();
}

class AccuracyCardState extends State<AccuracyCard> {
  final Statslocalstorage statsController = Get.put(Statslocalstorage());
  List<String> positions = ['leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
  List<String> positionNames = ['Left Reposition', 'Right Reposition', 'Forward Reposition', 'Back Reposition'];
  List<double> accuracies = [];
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Initialize accuracies from observables
    accuracies = [
      statsController.avgLeftAcc.value,
      statsController.avgRightAcc.value,
      statsController.avgForwardAcc.value,
      statsController.avgBackAcc.value,
    ];

    // Start the timer to change the displayed accuracy every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % positions.length;
        accuracies = [
          statsController.avgLeftAcc.value,
          statsController.avgRightAcc.value,
          statsController.avgForwardAcc.value,
          statsController.avgBackAcc.value,
        ];
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 254),
        borderRadius: BorderRadius.circular(15),
       
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/response.png', // The respective position image
            width: 40,
            height: 40,
          ),
          const SizedBox(height: 10),
       Text(
            positionNames[currentIndex].replaceAll(' ', '\n'), // Replacing space with a new line
            textAlign: TextAlign.center, // Centering the text
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
//          Obx(() => Text(
//   'Accuracy: ${statsController.avgLeftAcc.value.toStringAsFixed(2)}%',
//   style: const TextStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//   ),
// )),
          Obx(() {
            double currentAccuracy;
            switch (currentIndex) {
              case 0:
                currentAccuracy = statsController.avgLeftAcc.value;
                break;
              case 1:
                currentAccuracy = statsController.avgRightAcc.value;
                break;
              case 2:
                currentAccuracy = statsController.avgForwardAcc.value;
                break;
              case 3:
                currentAccuracy = statsController.avgBackAcc.value;
                break;
              default:
                currentAccuracy = 0.0; // Fallback to 0 if index is out of range
            }
            return Text(
              'Adherence: ${currentAccuracy.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            );
          }),

        ],
      ),
    );
  }
}
