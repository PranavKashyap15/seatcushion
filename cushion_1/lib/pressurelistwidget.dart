import 'dart:async';
import 'package:cushion_1/communicationhandler.dart';
import 'package:flutter/material.dart';
class PressureListWidget extends StatefulWidget {
  const PressureListWidget({super.key});

  @override
  PressureListWidgetState createState() => PressureListWidgetState();
}

class PressureListWidgetState extends State<PressureListWidget> {
  late StreamSubscription<Map<int, double>> cellPressureSubscription;
  Map<int, double> cellPressures = {};

  @override
  void initState() {
    super.initState();
    final communicationHandler = CommunicationHandler.getInstance();
    cellPressureSubscription = communicationHandler.cellPressureUpdates.listen(
      (Map<int, double> pressures) {
        setState(() {
          cellPressures.clear();
          cellPressures.addAll(pressures);
        });
      },
    );
  }
  @override
  void dispose() {
    cellPressureSubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.width >= 600;
    int crossAxisCount = isTablet ? 6 : 3;
    return SizedBox(
      height: 600,
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 100),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 2,
        ),
        itemCount: 48,
        itemBuilder: (context, index) {
          double pressure =
              cellPressures[index + 1] ?? 0.0;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Cell ${index + 1}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(pressure.toStringAsFixed(2),
                    style: const TextStyle(fontSize: 14))
              ],
            ),
          );
        },
      ),
    );
  }
}