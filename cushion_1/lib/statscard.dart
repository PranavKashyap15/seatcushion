import 'package:cushion_1/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatsCard extends StatelessWidget {
  final String? assetPath;
  final IconData? icon;
  final String value;
  final String label;
  final Color color;
  final bool showChart;
  final List<PieData>? pieData;

  const StatsCard({
    super.key,
    this.assetPath,
    this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.showChart = false,
    this.pieData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.bgSecondayLight,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart section (left side)
          if (showChart && pieData != null)
            Expanded(
              flex: 1, // Allow flexible space for the chart
              child: SizedBox(
                height: 250, // Adjust the height as needed
                child: SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<PieData, String>(
                      dataSource: pieData!,
                      xValueMapper: (PieData data, _) => data.category,
                      yValueMapper: (PieData data, _) => data.value,
                                            pointColorMapper: (PieData data, _) => data.color, // Map the color from PieData
                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                      innerRadius: '55%',
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(width: 16), // Space between chart and reposition times

          // Reposition data section (right side)
          Expanded(
            flex: 1, // Allow flexible space for the reposition times
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left side)
              children: [
                // Optional icon or asset at the top
                if (assetPath != null)
                  Image.asset(
                    assetPath!,
                    height: 36,
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    size: 36,
                  ),
              //  const SizedBox(height: 10),

                // Value text
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              //  const SizedBox(height: 4),

                // Label text
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),

                // Display reposition times with color indicators
                if (pieData != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: pieData!
                        .map(
                          (data) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                // Color indicator box
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: data.color, // Use the color from PieData
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(width: 8), // Space between color box and text
                                              Expanded(
                child: Text(
                  data.category,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),

              // Spacer between category and value
             const SizedBox(width: 38),

              // Value text aligned to the right side
              Expanded(
                child: Text(
                  '${data.value.toStringAsFixed(2)} hours',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),

                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Data model for the pie chart
class PieData {
  PieData(this.category, this.value, this.color);

  final String category;
  final double value;
  final Color color;
}



class CenteredCard extends StatelessWidget {
  final String? assetPath; 
  final IconData? icon; 
  final String value;
  final String label;
  final Color color;
  final bool showChart;
  final List<PieData>? pieData; 

  const CenteredCard({
    super.key,
    this.assetPath, 
    this.icon, 
    required this.value,
    required this.label,
    required this.color,
    this.showChart = false,
    this.pieData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondayLight,
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: showChart && pieData != null
          ? const Center(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 235,
                    width: 180,
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (assetPath != null)
                  Image.asset(
                    assetPath!,
                    height: 36,
                  )
                else if (icon != null)
                  Icon(
                    icon,
                    size: 36,
                  ),
                const SizedBox(height: 10),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                  
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
    );
  }

}
