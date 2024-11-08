import 'package:cushion_1/chartdata.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// class Barchartoverview extends StatelessWidget {
//   const Barchartoverview({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final Localstoragefunctions local = Localstoragefunctions();
//     final Map<String, double> positionTimesInHours = {
//       'Back': local.getTime('back').toDouble() / 3600,
//       'Forward': local.getTime('forward').toDouble() / 3600,
//       'Left': local.getTime('left').toDouble() / 3600,
//       'Right': local.getTime('right').toDouble() / 3600,
//       'Normal': local.getTime('normal').toDouble() / 3600,
//       'Right\nReposition': local.getTime('rightreposition').toDouble() / 3600,
//       'Left\nReposition': local.getTime('leftreposition').toDouble() / 3600,
//       'Back\nReposition': local.getTime('backreposition').toDouble() / 3600,
//       'Forward\nReposition': local.getTime('forwardreposition').toDouble() / 3600,
//     };
//     final List<ChartData> chartData = positionTimesInHours.entries
//         .map((e) => ChartData(e.key, e.value))
//         .toList();

//     TooltipBehavior tooltipBehavior = TooltipBehavior(
//       enable: true,
//       builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
//         final chartData = data as ChartData;
//         return Container(
            
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             '${chartData.x} : ${chartData.formattedTime}',
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 12,
//             ),
//           ),
//         );
//       },
//     );

//     return Scaffold(
//       body: SizedBox(
//         height: 240,
//         child: Center(
//           child: SfCartesianChart(
//             backgroundColor: Colors.white,
//             tooltipBehavior: tooltipBehavior,
//             primaryXAxis: const CategoryAxis(
//               labelStyle: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             primaryYAxis: const NumericAxis(
//               labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               title: AxisTitle(text: 'Time In Hours',textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
//             ),
//             series: <CartesianSeries>[
//               ColumnSeries<ChartData, String>(
//                 dataSource: chartData,
//                 xValueMapper: (ChartData data, _) => data.x,
//                 yValueMapper: (ChartData data, _) => data.hours + data.minutes / 60,
//                 dataLabelMapper: (ChartData data, _) => data.formattedTime,
//                 borderRadius: const BorderRadius.all(Radius.circular(15)),
//                 width: 0.6,
//                 color: Colors.blueAccent,
//                 dataLabelSettings: const DataLabelSettings(
//                   isVisible: true,
//                   labelPosition: ChartDataLabelPosition.outside,
//                   textStyle: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class Barchartoverview extends StatelessWidget {
  const Barchartoverview({super.key});

  @override
  Widget build(BuildContext context) {
    final Localstoragefunctions local = Localstoragefunctions();
    final Map<String, double> positionTimesInHours = {
      'Back': local.getTime('back').toDouble() / 3600,
      'Forward': local.getTime('forward').toDouble() / 3600,
      'Left': local.getTime('left').toDouble() / 3600,
      'Right': local.getTime('right').toDouble() / 3600,
      'Normal': local.getTime('normal').toDouble() / 3600,
      'Right\nReposition': local.getTime('rightreposition').toDouble() / 3600,
      'Left\nReposition': local.getTime('leftreposition').toDouble() / 3600,
      'Back\nReposition': local.getTime('backreposition').toDouble() / 3600,
      'Forward\nReposition': local.getTime('forwardreposition').toDouble() / 3600,
    };

    final List<ChartData> chartData = positionTimesInHours.entries
        .map((e) => ChartData(e.key, e.value))
        .toList();

    TooltipBehavior tooltipBehavior = TooltipBehavior(
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
        final chartData = data as ChartData;
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${chartData.x} : ${chartData.formattedTime}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        );
      },
    );

    return Scaffold(
      body: SizedBox(
        height: 240,
        child: Center(
          child: SfCartesianChart(
            backgroundColor: Colors.white,
            tooltipBehavior: tooltipBehavior,
            primaryXAxis: const CategoryAxis(
              labelStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            primaryYAxis: const NumericAxis(
              labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              title: AxisTitle(
                text: 'Time In Hours',
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            series: <CartesianSeries>[
              ColumnSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.hours + data.minutes / 60,
                dataLabelMapper: (ChartData data, _) => data.formattedTime,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                width: 0.6,
                color: Colors.blueAccent,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
