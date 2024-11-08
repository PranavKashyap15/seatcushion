import 'package:cushion_1/adherencecard.dart';
import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/chartdata.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:cushion_1/overview.dart';
import 'package:cushion_1/repositioninglinechart.dart';
import 'package:cushion_1/statscard.dart';
import 'package:cushion_1/statslocalstorage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
const gapH4 = SizedBox(height: 4);
const gapH8 = SizedBox(height: 8);
const gapH16 = SizedBox(height: 16);
const gapH20 = SizedBox(height: 20);
const gapH24 = SizedBox(height: 24);
const gapW4 = SizedBox(width: 4);
const gapW8 = SizedBox(width: 8);
const gapW16 = SizedBox(width: 16);
const gapW20 = SizedBox(width: 20);
const gapW24 = SizedBox(width: 24);

class DashboardPage extends StatefulWidget {
  final GetStorage storage = GetStorage();
  DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  final Localstoragefunctions local = Localstoragefunctions();
  final Statslocalstorage statsController = Get.put(Statslocalstorage());

  @override
  Widget build(BuildContext context) {
    final Localstoragefunctions local = Localstoragefunctions();
     final Map<String, double> positionTimesInHours = {
      'back': local.getTime('back').toDouble() / 3600,
      'forward': local.getTime('forward').toDouble() / 3600,
      'left': local.getTime('left').toDouble() / 3600,
      'right': local.getTime('right').toDouble() / 3600,
    };
    final List<ChartData> chartData = positionTimesInHours.entries
        .map((e) => ChartData(e.key, e.value))
        .toList();
  
  final Statslocalstorage statsController = Get.put(Statslocalstorage());
 // final double totalTimeSeatedInHours = positionTimesInHours.values.fold(0, (sum, value) => sum + value);
      statsController.fetchRepositionCount();


    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right:12),
                        child: Overview(chartData: chartData),
                      ),
                       Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 20, 0, 5),
                              child: Row(
                                children: [
                                   SizedBox(
                                    width: 350,
                                    height: 205,
                                    child: CenteredCard(
                                      assetPath: 'assets/approved.png',
                                     value: "${statsController.repositionCount.value}",
                                      label: "Total No of Repositioning Completed \n \t\t\t\t\t\t\t\t\t\t\t\t\t\t\t in this Month",
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                   SizedBox(
                                  
              width: 660,
              height: 205,
              child:Container(
  decoration: BoxDecoration(
    color: AppColors.bgSecondayLight, // Set the background color
    borderRadius: BorderRadius.circular(22), // Set rounded corners
  ),
  child: const ClipRRect(
    // Same rounded corners for clipping
    child: SizedBox(
  
      child: Repositioninglinechart(),
    ),
  ),
)
                                  ),
                                
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                gapW16,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18, 18, 18),
                    child: Column(
                      children: [
                        const Expanded(
                          child: AccuracyCard(), // The newly created card
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Obx(() => CenteredCard(
                            assetPath: 'assets/clock.png',
                            value: "${statsController.totalTimeSeatedHours.value} hrs ${statsController.totalTimeSeatedMinutes.value} min",
                            label: "Total Time Seated",
                            color: Colors.lightGreenAccent,
                          )),
                        ),
                        const SizedBox(height: 20),
                        const Expanded(
                          child: CenteredCard(
                            assetPath: 'assets/badge.png',
                            value: "7",
                            label: "Achievements",
                            color: Colors.pinkAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class PieData {
  PieData(this.value, this.color, this.category);
  final double value;
  final Color color;
  final String category;
}
