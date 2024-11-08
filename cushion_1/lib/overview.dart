import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/appdefaults.dart';
import 'package:cushion_1/barchart_generatestats.dart';
import 'package:cushion_1/chartdata.dart';
import 'package:cushion_1/statslocalstorage.dart';
import 'package:cushion_1/statscard.dart' as stats_card;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class Overview extends StatelessWidget {
  final List<ChartData> chartData;

  const Overview({super.key, required this.chartData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      padding: const EdgeInsets.fromLTRB(16, 1, 16, 1),
      decoration: BoxDecoration(
        color: AppColors.bgSecondayLight,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: const Column(
        children: [
          SizedBox(height: 14),
          OverviewTabs(),
        ],
      ),
    );
  }
}

class OverviewTabs extends StatefulWidget {
  const OverviewTabs({super.key});

  @override
  State<OverviewTabs> createState() => _OverviewTabsState();
}

class _OverviewTabsState extends State<OverviewTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
         if (_tabController.index == 0) {
          _fetchRepositioningData();
        }
        setState(() {
        });
      });
    super.initState();
  }
   void _fetchRepositioningData() {
    final Statslocalstorage statsController = Get.find<Statslocalstorage>();
    statsController.fetchLastWeekRepositionData();
  }

  @override
  Widget build(BuildContext context) {
    final Statslocalstorage statsController = Get.find<Statslocalstorage>();

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: AppColors.bgLight,
            borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
          ),
          child: TabBar(
            controller: _tabController,
            dividerHeight: 0,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: AppDefaults.padding),
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
              color: AppColors.bgSecondayLight,
            ),
            indicatorColor: Colors.transparent,
            indicatorWeight: 0.0,
            tabs: const [
              TabWithGrowth(
                assetPath: 'assets/pie_chart.png',
                amount: "Repositioning Overview",
                growthPercentage: "2.7%",
                isPositiveGrowth: false,
              ),
              TabWithGrowth(
                assetPath: 'assets/bargraph.png',
                amount: "Position Overview",
                growthPercentage: "20%",
              ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Display the doughnut chart with reposition data
              Center(
                child: Obx(() {
                  final List<stats_card.PieData> repositionData = [
  stats_card.PieData('Left Reposition', statsController.avgLeftReposition.value, Colors.red), // Add color
  stats_card.PieData('Right Reposition', statsController.avgRightReposition.value, Colors.green), // Add color
  stats_card.PieData('Forward Reposition', statsController.avgForwardReposition.value, Colors.blue), // Add color
  stats_card.PieData('Back Reposition', statsController.avgBackReposition.value, const Color.fromRGBO(240, 168, 61, 0.938)), // Add color
];
                  return stats_card.StatsCard(
                    value: "",
                    label: " Reposition Times (Last 7 Days)",
                    color: Colors.lightBlueAccent,
                    showChart: true,
                    pieData: repositionData,
                  );
                }),
              ),
              // Bar chart tab
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Barchartoverview(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TabWithGrowth extends StatelessWidget {
  const TabWithGrowth({
    super.key,
    required this.amount,
    required this.growthPercentage,
    this.assetPath,
    this.icon,
    this.isPositiveGrowth = true,
  });

  final String amount, growthPercentage;
  final bool isPositiveGrowth;
  final String? assetPath;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 12.0),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 185, 207, 224),
            radius: 20,
            child: assetPath != null
                ? Image.asset(
                    assetPath!,
                    height: 24,
                  )
                : Icon(
                    icon,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(amount, style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
