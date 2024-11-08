//CHANGED 
import 'package:async/async.dart';
import 'package:cushion_1/appcolors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Repositioninglinechart extends StatelessWidget {
  const Repositioninglinechart({super.key});

  Stream<Map<String, int>> streamRepositionData(String email) async* {
  DateTime now = DateTime.now();
  Map<String, int> data = {};
 // print('Streaming reposition data for email: $email');
  List<Stream<DocumentSnapshot>> monthStreams = [];
  for (int i = 4; i >= 0; i--) {
    DateTime targetDate = DateTime(now.year, now.month - i, 1);
    String yearStr = targetDate.year.toString(); // Example: "2024"
    String monthStr = targetDate.month.toString().padLeft(2, '0'); // Example: "08"
  //  print('Fetching data for year: $yearStr, month: $monthStr');

    Stream<DocumentSnapshot> monthStream = FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .collection('reposition_completed')
        .doc(yearStr)
        .collection(monthStr)
        .doc('count')
        .snapshots();

    monthStreams.add(monthStream);
  }

  // Combine all month streams into a single stream
  await for (var snapshots in StreamZip(monthStreams)) {
    for (var snapshot in snapshots) {
      if (snapshot.exists) {
        var docData = snapshot.data() as Map<String, dynamic>;
        String monthStr = snapshot.reference.parent.id; // Extract month from document reference

        //print('Document data for $monthStr: $docData');

        // Safely extract the count as an int
        var count = docData['count'];
        if (count is int) {
          data[monthStr] = count;
         // print('Count for month $monthStr: $count');
        } else if (count is String) {
          // Try to parse the string to an int
          data[monthStr] = int.tryParse(count) ?? 0;
          //print('Count for month $monthStr (parsed from string): ${data[monthStr]}');
        } else {
          data[monthStr] = 0; // Default to 0 if the type is unexpected
          //print('Unexpected count type for month $monthStr. Defaulting to 0.');
        }
      } else {
        String monthStr = snapshot.reference.parent.id;
        data[monthStr] = 0;
       // print('No document found for month: $monthStr');
      }
    }

    // Yield the complete dataset after processing all months
    yield data;
  }
}


  @override
  Widget build(BuildContext context) {
    String email = 'pranavkashyap1506@gmail.com'; // Replace with actual email
    return Column(
      children: [

        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'No of Repositions Completed Over Last 5 Months',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<Map<String, int>>(
            stream: streamRepositionData(email),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
               // print(snapshot.error);
                return const Center(child: Text('Error fetching data'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data available'));
              } else {
                Map<String, int> data = snapshot.data!;
                List<String> months = data.keys.toList();
                List<int> counts = data.values.toList();
                int maxY = counts.reduce((a, b) => a > b ? a : b) +5; // Dynamic maxY with a buffer
          
                // Create a list of vertical lines for all data points
                final extraLines = List.generate(
                  counts.length,
                  (index) => VerticalLine(
                    x: index.toDouble(),
                    color: Colors.grey.withOpacity(0.5), // Customize line color
                    strokeWidth: 1.5, // Customize line width
                    dashArray: [5, 5], // Dash pattern for the line
                  ),
                );
          
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: LineChart(
                    LineChartData(
                      gridData: gridData,
                      titlesData: titlesData1(months),
                      borderData: borderData,
                      lineBarsData: [lineChartBarData(counts)],
                      minX: 0,
                      maxX: months.length.toDouble() - 1,
                      maxY: maxY.toDouble(),
                      minY: 0,
                      extraLinesData: ExtraLinesData(verticalLines: extraLines), // Add vertical lines
                      showingTooltipIndicators: List.generate(
                        counts.length,
                        (index) => ShowingTooltipIndicators([
                          LineBarSpot(
                            lineChartBarData(counts),
                            index,
                            FlSpot(index.toDouble(), counts[index].toDouble()),
                          ),
                        ]),
                      ),
                      lineTouchData: LineTouchData(
                        enabled: false, // Disable touch to make tooltips always visible
                        touchTooltipData: LineTouchTooltipData(
                          tooltipRoundedRadius: 8,
                          tooltipMargin: 8,
                          tooltipPadding: const EdgeInsets.all(8),
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((LineBarSpot touchedSpot) {
                              return LineTooltipItem(
                                '${touchedSpot.y.toInt()}', // Show the count number
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                    ),
                    duration: const Duration(milliseconds: 250),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  FlTitlesData titlesData1(List<String> months) => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (value, meta) {
          int index = value.toInt();
          if (index < 0 || index >= months.length) return Container();
          int monthNumber = int.tryParse(months[index]) ?? 1;
          DateTime monthDate = DateTime(0, monthNumber);
          String monthName = DateFormat.MMM().format(monthDate);
          return Text(monthName, style: const TextStyle());
        },
      ),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  SideTitles leftTitles() => SideTitles(
    showTitles: true,
    interval: 10, 
    reservedSize: 50, 
    getTitlesWidget: (value, meta) {
      return Text(
        value.toString(),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        maxLines: 1, 
        overflow: TextOverflow.ellipsis, 
      );
    },
  );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: AppColors.highlightLight, width: 1),
      left: BorderSide.none,
      right: BorderSide.none,
      top: BorderSide.none,
    ),
  );

  LineChartBarData lineChartBarData(List<int> counts) {
    return LineChartBarData(
      isCurved: true,
      color: AppColors.primary,
      barWidth: 4,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true), // Show dots at data points
      belowBarData: BarAreaData(show: true),
      spots: List.generate(
        counts.length,
        (index) => FlSpot(index.toDouble(), counts[index].toDouble()),
      ),
    );
  }
}
