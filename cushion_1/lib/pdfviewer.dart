
// // import 'dart:typed_data';
// // import 'package:cushion_1/appcolors.dart';
// // import 'package:cushion_1/hexcolor.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart' show rootBundle;
// // import 'package:pdf/pdf.dart';
// // import 'package:pdf/widgets.dart' as pw;
// // import 'package:printing/printing.dart';
// // import 'package:cushion_1/localstoragefunctions.dart';
// // import 'package:get/get.dart';
// // import 'package:intl/intl.dart';

// // class PDFViewerScreen extends StatefulWidget {
// //   const PDFViewerScreen({super.key});

// //   @override
// //   State<PDFViewerScreen> createState() => PDFViewerScreenState();
// // }

// // class PDFViewerScreenState extends State<PDFViewerScreen> {
// //   final Localstoragefunctions localStorageFunctions = Get.find<Localstoragefunctions>();

// //   String? userName;
// //   String? userEmail;
// //   List<Map<String, String>> positionData = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadData(); // Load the data when the screen is initialized
// //   }

// //   // Load data from local storage and update the screen
// //   void loadData() {
// //     setState(() {
// //       userName = localStorageFunctions.getUserDetails()['name'] ?? 'Unknown';
// //       userEmail = localStorageFunctions.getUserDetails()['email'] ?? 'Unknown';
// //       positionData = _getPositionData();
// //     });
// //   }
// // Future<void> _generateAndOpenPDF() async {
// //   // Load image from assets
// //   final image = await rootBundle.load('assets/logobg.png');
// //   final imageData = image.buffer.asUint8List();

// //   final pdf = pw.Document();

// //   // Get adherence data
// //   List<Map<String, String>> adherenceData = _getAdherenceData();

// //   // Add a page with position and adherence data in table format
// //   pdf.addPage(
// //     pw.MultiPage(
// //       build: (pw.Context context) => [
// //         _buildHeader(context, userName ?? 'Unknown', userEmail ?? 'Unknown', imageData), // Pass image data here
// //         pw.SizedBox(height: 40),
        
// //         // Add a label for the Pie Chart
// //         pw.Text(
// //           'Pie Chart',
// //           style: pw.TextStyle(
// //             fontSize: 18,
// //             fontWeight: pw.FontWeight.bold,
// //             color: PdfColors.black,
// //           ),
// //         ),
// //         pw.SizedBox(height: 10),
        
// //         // Render the Pie Chart
// //         _buildPieChart(positionData),
// //         pw.SizedBox(height: 20),
        
// //         // Add a label for the posture data table
// //         pw.Text(
// //           'Posture Data',
// //           style: pw.TextStyle(
// //             fontSize: 18,
// //             fontWeight: pw.FontWeight.bold,
// //             color: PdfColors.black,
// //           ),
// //         ),
// //         pw.SizedBox(height: 10),
        
// //         // Render the table with posture data
// //         _buildPositionTable(positionData),
        
// //         pw.SizedBox(height: 30),

// //         // Add a label for the adherence (accuracy) table
// //         pw.Text(
// //           'Reposition Accuracy',
// //           style: pw.TextStyle(
// //             fontSize: 18,
// //             fontWeight: pw.FontWeight.bold,
// //             color: PdfColors.black,
// //           ),
// //         ),
// //         pw.SizedBox(height: 15),
        
// //         // Render the adherence table
// //         _buildAdherenceTable(adherenceData),
        
// //         pw.SizedBox(height: 10),
// //         _buildFooter(),
// //       ],
// //     ),
// //   );

// //   // Save the PDF and open it
// //   await Printing.sharePdf(bytes: await pdf.save(), filename: 'user_position_and_adherence_data.pdf');
// // }
// // // Display the adherence table on the screen
// // Widget _buildOnScreenAdherenceTable() {
// //   return Table(
// //     border: TableBorder.all(color: const Color.fromARGB(255, 89, 188, 231)), // Same as PDF table border
// //     children: [
// //       const TableRow(
// //         decoration: BoxDecoration(color: Color.fromARGB(255, 89, 188, 231)), // Header color same as PDF
// //         children: [
// //           Padding(
// //             padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //             child: Text(
// //               'Position',
// //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //             ),
// //           ),
// //           Padding(
// //             padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //             child: Text(
// //               'Accuracy',
// //               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //             ),
// //           ),
// //         ],
// //       ),
// //       ..._getAdherenceData().map((data) {
// //         return TableRow(
// //           children: [
// //             Padding(
// //               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //               child: Text(
// //                 data['position']!,
// //                 style: const TextStyle(fontSize: 16),
// //               ),
// //             ),
// //             Padding(
// //               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //               child: Text(
// //                 data['accuracy']!,
// //                 style: const TextStyle(fontSize: 16),
// //               ),
// //             ),
// //           ],
// //         );
// //       }).toList(),
// //     ],
// //   );
// // }

// // // Future<void> _generateAndOpenPDF() async {
// // //   // Load image from assets
// // //   final image = await rootBundle.load('assets/logobg.png');
// // //   final imageData = image.buffer.asUint8List();

// // //   final pdf = pw.Document();

// // //   // Add a page with position data in table format
// // //   pdf.addPage(
// // //     pw.MultiPage(
// // //       build: (pw.Context context) => [
// // //         _buildHeader(context, userName ?? 'Unknown', userEmail ?? 'Unknown', imageData), // Pass image data here
// // //         pw.SizedBox(height: 40),
        
// // //         // Add a label for the Pie Chart
// // //         pw.Text(
// // //           'Pie Chart',
// // //           style: pw.TextStyle(
// // //             fontSize: 18,
// // //             fontWeight: pw.FontWeight.bold,
// // //             color: PdfColors.black,
// // //           ),
// // //         ),
// // //         pw.SizedBox(height: 10),
        
// // //         // Render the Pie Chart
// // //         _buildPieChart(positionData),
// // //         pw.SizedBox(height: 20),
        
// // //         // Add a label for the posture data table
// // //         pw.Text(
// // //           'Posture Data',
// // //           style: pw.TextStyle(
// // //             fontSize: 18,
// // //             fontWeight: pw.FontWeight.bold,
// // //             color: PdfColors.black,
// // //           ),
// // //         ),
// // //         pw.SizedBox(height: 10),
        
// // //         // Render the table with posture data
// // //         _buildPositionTable(positionData),
        
// // //         pw.SizedBox(height: 10),
// // //         _buildFooter(),
// // //       ],
// // //     ),
// // //   );

// // //   // Save the PDF and open it
// // //   await Printing.sharePdf(bytes: await pdf.save(), filename: 'user_position_data.pdf');
// // // }


// //   // Build the header widget for PDF
// //   pw.Widget _buildHeader(pw.Context context, String userName, String userEmail, Uint8List imageData) {
// //     return pw.Row(
// //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
// //       crossAxisAlignment: pw.CrossAxisAlignment.start,
// //       children: [
// //         pw.Column(
// //           crossAxisAlignment: pw.CrossAxisAlignment.start,
// //           children: [
// //             pw.Text(
// //               'USER REPORT',
// //               style: pw.TextStyle(
// //                 color: const PdfColor.fromInt(0xFF59BCE7),
// //                 fontWeight: pw.FontWeight.bold,
// //                 fontSize: 25,
// //               ),
// //             ),
// //             pw.Text('User: $userName'),
// //             pw.Text('Email: $userEmail'),
// //            pw.Text(
// //               'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
// //               style: const pw.TextStyle(fontSize: 12),
// //             ),
// //           ],
// //         ),
// //         // Add the image to the right side
// //         pw.Container(
// //           width: 250,
// //           height: 95,
// //           child: pw.Image(
// //             pw.MemoryImage(imageData), // Use the loaded image
// //             fit: pw.BoxFit.fitWidth,
// //           ),
// //         ),
// //       ],
// //     );
// //   }

// //   // Method to retrieve position data from local storage
// //   List<Map<String, String>> _getPositionData() {
// //     List<String> positions = ['left', 'right', 'forward', 'back', 'leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
// //     List<Map<String, String>> positionData = [];

// //     for (String position in positions) {
// //       int time = localStorageFunctions.getTime(position);
// //       positionData.add({'position': position.toUpperCase(), 'time': '$time seconds'});
// //     }

// //     return positionData;
// //   }

// //   // Build the position table for PDF
// //   pw.Widget _buildPositionTable(List<Map<String, String>> positionData) {
// //     return pw.Table.fromTextArray(
// //       headerStyle: pw.TextStyle(
// //         color: PdfColors.white,
// //         fontWeight: pw.FontWeight.bold,
// //       ),
// //       headerDecoration: const pw.BoxDecoration(
// //         color: PdfColor.fromInt(0xFF59BCE7),
// //       ),
// //       headers: ['Posture', 'Duration'],
// //       data: positionData
// //           .map((data) => [data['position']!, data['time']!])
// //           .toList(),
// //     );
// //   }

// //   // // Build Pie Chart widget for PDF
// //   // pw.Widget _buildPieChart(List<Map<String, String>> positionData) {
// //   //   final totalSpent = positionData.fold<int>(0, (sum, data) {
// //   //     return sum + int.parse(data['time']!.replaceAll(' seconds', ''));
// //   //   });

// //   //   final chartColors = [
// //   //     PdfColors.blue,
// //   //     PdfColors.red,
// //   //     PdfColors.green,
// //   //     PdfColors.orange,
// //   //     PdfColors.purple,
// //   //     PdfColors.cyan,
// //   //     PdfColors.yellow,
// //   //     PdfColors.pink
// //   //   ];

// //   //   return pw.Chart(
// //   //     grid: pw.PieGrid(),
// //   //     datasets: List<pw.Dataset>.generate(positionData.length, (index) {
// //   //       final data = positionData[index];
// //   //       final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
// //   //       final color = chartColors[index % chartColors.length];
// //   //       final percentage = (timeSpent / totalSpent * 100).round();

// //   //       return pw.PieDataSet(
// //   //         value: timeSpent.toDouble(),
// //   //         legend: '${data['position']} - $percentage%',
// //   //         color: color,
// //   //         legendStyle: pw.TextStyle(fontSize: 6),
// //   //       );
// //   //     }),
// //   //   );
// //   // }


// // // Method to retrieve adherence data (accuracy) for the four repositioning positions
// // List<Map<String, String>> _getAdherenceData() {
// //   List<String> positions = ['leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
// //   List<Map<String, String>> adherenceData = [];

// //   for (String position in positions) {
// //     double accuracy = localStorageFunctions.getAccuracy(position) ?? 0.0; // Retrieve adherence (accuracy) value
// //     adherenceData.add({'position': position.toUpperCase(), 'accuracy': '${(accuracy * 100).toStringAsFixed(2)}%'}); // Convert to percentage
// //   }

// //   return adherenceData;
// // }
// // // Build the adherence table for PDF
// // pw.Widget _buildAdherenceTable(List<Map<String, String>> adherenceData) {
// //   return pw.Table.fromTextArray(
// //     headerStyle: pw.TextStyle(
// //       color: PdfColors.white,
// //       fontWeight: pw.FontWeight.bold,
// //     ),
// //     headerDecoration: const pw.BoxDecoration(
// //       color: PdfColor.fromInt(0xFF59BCE7),
// //     ),
// //     headers: ['Position', 'Accuracy'],
// //     data: adherenceData
// //         .map((data) => [data['position']!, data['accuracy']!])
// //         .toList(),
// //   );
// // }

// // pw.Widget _buildPieChart(List<Map<String, String>> positionData) {
// //   final totalSpent = positionData.fold<int>(0, (sum, data) {
// //     return sum + int.parse(data['time']!.replaceAll(' seconds', ''));
// //   });

// //   // If totalSpent is 0, avoid division by zero by skipping the pie chart generation
// //   if (totalSpent == 0) {
// //     return pw.Text(
// //       'No data available for the pie chart.',
// //       style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
// //     );
// //   }

// //   final chartColors = [
// //     PdfColors.blue,
// //     PdfColors.red,
// //     PdfColors.green,
// //     PdfColors.orange,
// //     PdfColors.purple,
// //     PdfColors.cyan,
// //     PdfColors.yellow,
// //     PdfColors.pink
// //   ];

// //   final pieDatasets = List<pw.Dataset>.generate(positionData.length, (index) {
// //     final data = positionData[index];
// //     final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
// //     final color = chartColors[index % chartColors.length];
// //     final percentage = (timeSpent / totalSpent * 100).round(); // Calculate the percentage

// //     return pw.PieDataSet(
// //       value: timeSpent.toDouble(),
// //       color: color,
// //     );
// //   });

// //   // Pie chart with legends displayed separately
// //   return pw.Column(
// //     children: [
// //       // Render the pie chart
// //       pw.Container(
// //         width: 180,
// //         height: 180,
// //         child: pw.Chart(
// //           grid: pw.PieGrid(),
// //           datasets: pieDatasets,
// //         ),
// //       ),
// //       pw.SizedBox(height: 20),
// //       // Display legends in a column to avoid overlap
// //       pw.Wrap(
// //         spacing: 10,
// //         runSpacing: 10,
// //         children: List<pw.Widget>.generate(positionData.length, (index) {
// //           final data = positionData[index];
// //           final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
// //           final percentage = (timeSpent / totalSpent * 100).round();
// //           final color = chartColors[index % chartColors.length];

// //           return pw.Row(
// //             mainAxisSize: pw.MainAxisSize.min,
// //             children: [
// //               pw.Container(
// //                 width: 10,
// //                 height: 10,
// //                 color: color,
// //               ),
// //               pw.SizedBox(width: 5),
// //               pw.Text('${data['position']} ($percentage%)',
// //                   style: const pw.TextStyle(fontSize: 8)),
// //             ],
// //           );
// //         }),
// //       ),
// //       pw.SizedBox(height: 10),
// //       pw.Text(
// //         'Total time spent: $totalSpent seconds',
// //         style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
// //       ),
// //     ],
// //   );
// // }


// // // pw.Widget _buildPieChart(List<Map<String, String>> positionData) {
// // //   final totalSpent = positionData.fold<int>(0, (sum, data) {
// // //     return sum + int.parse(data['time']!.replaceAll(' seconds', ''));
// // //   });

// // //   final chartColors = [
// // //     PdfColors.blue,
// // //     PdfColors.red,
// // //     PdfColors.green,
// // //     PdfColors.orange,
// // //     PdfColors.purple,
// // //     PdfColors.cyan,
// // //     PdfColors.yellow,
// // //     PdfColors.pink
// // //   ];

// // //   final pieDatasets = List<pw.Dataset>.generate(positionData.length, (index) {
// // //     final data = positionData[index];
// // //     final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
// // //     final color = chartColors[index % chartColors.length];
// // //     final percentage = (timeSpent / totalSpent * 100).round();

// // //     return pw.PieDataSet(
// // //       value: timeSpent.toDouble(),
// // //       color: color,
// // //     );
// // //   });

// // //   // Pie chart with legends displayed separately
// // //   return pw.Column(
// // //     children: [
// // //       // Render the pie chart
// // //       pw.Container(
// // //         width: 180,
// // //         height: 180,
// // //         child: pw.Chart(
// // //           grid: pw.PieGrid(),
// // //           datasets: pieDatasets,
// // //         ),
// // //       ),
// // //       pw.SizedBox(height: 20),
// // //       // Display legends in a column to avoid overlap
// // //       pw.Wrap(
// // //         spacing: 10,
// // //         runSpacing: 10,
// // //         children: List<pw.Widget>.generate(positionData.length, (index) {
// // //           final data = positionData[index];
// // //           final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
// // //           final percentage = (timeSpent / totalSpent * 100).round();
// // //           final color = chartColors[index % chartColors.length];

// // //           return pw.Row(
// // //             mainAxisSize: pw.MainAxisSize.min,
// // //             children: [
// // //               pw.Container(
// // //                 width: 10,
// // //                 height: 10,
// // //                 color: color,
// // //               ),
// // //               pw.SizedBox(width: 5),
// // //               pw.Text('${data['position']} ($percentage%)',
// // //                   style: const pw.TextStyle(fontSize: 8)),
// // //             ],
// // //           );
// // //         }),
// // //       ),
// // //       pw.SizedBox(height: 10),
// // //       pw.Text(
// // //         'Total time spent: $totalSpent seconds',
// // //         style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
// // //       ),
// // //     ],
// // //   );
// // // }

// //   // Build the footer in PDF
// //   pw.Widget _buildFooter() {
// //     return pw.Text(
// //       'Generated by Utari',
// //       style: const pw.TextStyle(fontSize: 10),
// //     );
// //   }

// //   // Display the same content on the screen
// //   Widget _buildOnScreenHeader(String userName, String userEmail) {
// //     return Row(
// //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //       children: [
// //         Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const Text(
// //               'REPORT',
// //               style: TextStyle(
// //                 color: Color.fromARGB(255, 89, 188, 231),
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 25,
// //               ),
// //             ),
// //             Text('User: $userName', style: const TextStyle(fontSize: 16)),
// //             Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),
      
// //             Text(
// //               'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
// //               style: const TextStyle(fontSize: 16),
// //             ),
// //           ],
// //         ),
// //         // Show image (if you want it on the UI as well)
// //         Image.asset(
// //           'assets/logobg.png',
// //           width: 350,
// //           height: 150,
// //           fit: BoxFit.fitWidth,
// //         ),
// //       ],
// //     );
// //   }

// //   // Display the position table on the screen
// //   Widget _buildOnScreenPositionTable() {
// //     return Table(
      
// //       border: TableBorder.all(color: const Color.fromARGB(255, 89, 188, 231)), // Same as PDF table border
// //       children: [
// //         const TableRow(
// //           decoration: BoxDecoration(color: Color.fromARGB(255, 89, 188, 231)), // Header color same as PDF
// //           children: [
// //             Padding(
// //               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //               child: Text(
// //                 'Position',
// //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //             Padding(
// //               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //               child: Text(
// //                 'Time Spent',
// //                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //           ],
// //         ),
// //         ...positionData.map((data) {
// //           return TableRow(
// //             children: [
// //               Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //                 child: Text(
// //                   data['position']!,
// //                   style: const TextStyle(fontSize: 16),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0), 
// //                 child: Text(
// //                   data['time']!,
// //                   style: const TextStyle(fontSize: 16),
// //                 ),
// //               ),
// //             ],
// //           );
// //         }).toList(),
// //       ],
// //     );
// //   }

// //   // Display footer
// //   Widget _buildOnScreenFooter() {
// //     return const Text(
// //       'Generated by UTARI',
// //       style: TextStyle(fontSize: 10),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: AppColors.bgLight,
    
// //       body: Padding(
// //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               _buildOnScreenHeader(userName ?? 'Unknown', userEmail ?? 'Unknown'), // Display the header
// //               const SizedBox(height: 20),
// //               _buildOnScreenPositionTable(), // Display the position table
// //               const SizedBox(height: 20),
// //               _buildOnScreenFooter(), // Display footer
// //         Center(
// //   child: GestureDetector(
// //     onTap: () {
// //       _generateAndOpenPDF(); // Trigger the PDF generation when the button is tapped
// //     },
// //     child: Container(
// //       width: 250,
// //       height: 70,
// //       decoration: BoxDecoration(
// //         gradient: LinearGradient(
// //           colors: [
// //             HexColor('#87d9f7'),
// //             HexColor('#87d9f7')
// //           ],
// //           begin: Alignment.topLeft,
// //           end: Alignment.bottomRight,
// //         ),
// //         borderRadius: BorderRadius.circular(20),
// //         boxShadow: const [
// //           // Add shadow if needed
// //         ],
// //       ),
// //       child: const Center(
// //         child: Text(
// //           'Generate Detailed Report',
// //           textAlign: TextAlign.center,
// //           style: TextStyle(fontWeight: FontWeight.w600),
// //         ),
// //       ),
// //     ),
// //   ),
// // ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'dart:typed_data';
// import 'package:cushion_1/appcolors.dart';
// import 'package:cushion_1/hexcolor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:cushion_1/localstoragefunctions.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class PDFViewerScreen extends StatefulWidget {
//   const PDFViewerScreen({super.key});

//   @override
//   State<PDFViewerScreen> createState() => PDFViewerScreenState();
// }

// class PDFViewerScreenState extends State<PDFViewerScreen> {
//   final Localstoragefunctions localStorageFunctions = Get.find<Localstoragefunctions>();

//   String? userName;
//   String? userEmail;
//   List<Map<String, String>> positionData = [];

//   @override
//   void initState() {
//     super.initState();
//     // Use WidgetsBinding to call loadData after the widget is mounted
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadData();
//     });
//   }

//   // Load data from local storage and update the screen
//   void loadData() {
//     setState(() {
//       userName = localStorageFunctions.getUserDetails()['name'] ?? 'Unknown';
//       userEmail = localStorageFunctions.getUserDetails()['email'] ?? 'Unknown';
//       positionData = _getPositionData();
//     });
//   }

//   Future<void> _generateAndOpenPDF() async {
//     // Load image from assets
//     final image = await rootBundle.load('assets/logobg.png');
//     final imageData = image.buffer.asUint8List();

//     final pdf = pw.Document();

//     // Get adherence data
//     List<Map<String, String>> adherenceData = _getAdherenceData();

//     // Add a page with position and adherence data in table format
//     pdf.addPage(
//       pw.MultiPage(
//         build: (pw.Context context) => [
//           _buildHeader(context, userName ?? 'Unknown', userEmail ?? 'Unknown', imageData), // Pass image data here
//           pw.SizedBox(height: 40),

//           // Add a label for the Pie Chart
//           pw.Text(
//             'Pie Chart',
//             style: pw.TextStyle(
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//               color: PdfColors.black,
//             ),
//           ),
//           pw.SizedBox(height: 10),

//           // Render the Pie Chart
//           _buildPieChart(positionData),
//           pw.SizedBox(height: 20),

//           // Add a label for the posture data table
//           pw.Text(
//             'Posture Data',
//             style: pw.TextStyle(
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//               color: PdfColors.black,
//             ),
//           ),
//           pw.SizedBox(height: 10),

//           // Render the table with posture data
//           _buildPositionTable(positionData),

//           pw.SizedBox(height: 30),

//           // Add a label for the adherence (accuracy) table
//           pw.Text(
//             'Reposition Accuracy',
//             style: pw.TextStyle(
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//               color: PdfColors.black,
//             ),
//           ),
//           pw.SizedBox(height: 15),

//           // Render the adherence table
//           _buildAdherenceTable(adherenceData),

//           pw.SizedBox(height: 10),
//           _buildFooter(),
//         ],
//       ),
//     );

//     // Save the PDF and open it
//     await Printing.sharePdf(bytes: await pdf.save(), filename: 'user_position_and_adherence_data.pdf');
//   }

//   // Method to retrieve position data from local storage
//   List<Map<String, String>> _getPositionData() {
//     List<String> positions = ['left', 'right', 'forward', 'back', 'leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
//     List<Map<String, String>> positionData = [];

//     for (String position in positions) {
//       int time = localStorageFunctions.getTime(position);
//       positionData.add({'position': position.toUpperCase(), 'time': '$time seconds'});
//     }

//     return positionData;
//   }

//   // Build the header widget for PDF
//   pw.Widget _buildHeader(pw.Context context, String userName, String userEmail, Uint8List imageData) {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'USER REPORT',
//               style: pw.TextStyle(
//                 color: const PdfColor.fromInt(0xFF59BCE7),
//                 fontWeight: pw.FontWeight.bold,
//                 fontSize: 25,
//               ),
//             ),
//             pw.Text('User: $userName'),
//             pw.Text('Email: $userEmail'),
//             pw.Text(
//               'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
//               style: const pw.TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//         // Add the image to the right side
//         pw.Container(
//           width: 250,
//           height: 95,
//           child: pw.Image(
//             pw.MemoryImage(imageData), // Use the loaded image
//             fit: pw.BoxFit.fitWidth,
//           ),
//         ),
//       ],
//     );
//   }

//   // Build the position table for PDF
//   pw.Widget _buildPositionTable(List<Map<String, String>> positionData) {
//     return pw.Table.fromTextArray(
//       headerStyle: pw.TextStyle(
//         color: PdfColors.white,
//         fontWeight: pw.FontWeight.bold,
//       ),
//       headerDecoration: const pw.BoxDecoration(
//         color: PdfColor.fromInt(0xFF59BCE7),
//       ),
//       headers: ['Posture', 'Duration'],
//       data: positionData.map((data) => [data['position']!, data['time']!]).toList(),
//     );
//   }


//   // Build the adherence table for PDF
//   pw.Widget _buildAdherenceTable(List<Map<String, String>> adherenceData) {
//     return pw.Table.fromTextArray(
//       headerStyle: pw.TextStyle(
//         color: PdfColors.white,
//         fontWeight: pw.FontWeight.bold,
//       ),
//       headerDecoration: const pw.BoxDecoration(
//         color: PdfColor.fromInt(0xFF59BCE7),
//       ),
//       headers: ['Position', 'Accuracy'],
//       data: adherenceData.map((data) => [data['position']!, data['accuracy']!]).toList(),
//     );
//   }

//   // Build Pie Chart for PDF
//   pw.Widget _buildPieChart(List<Map<String, String>> positionData) {
//     final totalSpent = positionData.fold<int>(0, (sum, data) {
//       return sum + int.parse(data['time']!.replaceAll(' seconds', ''));
//     });

//     // If totalSpent is 0, avoid division by zero by skipping the pie chart generation
//     if (totalSpent == 0) {
//       return pw.Text(
//         'No data available for the pie chart.',
//         style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//       );
//     }

//     final chartColors = [
//       PdfColors.blue,
//       PdfColors.red,
//       PdfColors.green,
//       PdfColors.orange,
//       PdfColors.purple,
//       PdfColors.cyan,
//       PdfColors.yellow,
//       PdfColors.pink
//     ];

//     final pieDatasets = List<pw.Dataset>.generate(positionData.length, (index) {
//       final data = positionData[index];
//       final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
//       final color = chartColors[index % chartColors.length];
//       final percentage = (timeSpent / totalSpent * 100).round(); // Calculate the percentage

//       return pw.PieDataSet(
//         value: timeSpent.toDouble(),
//         color: color,
//       );
//     });

//     // Pie chart with legends displayed separately
//     return pw.Column(
//       children: [
//         // Render the pie chart
//         pw.Container(
//           width: 180,
//           height: 180,
//           child: pw.Chart(
//             grid: pw.PieGrid(),
//             datasets: pieDatasets,
//           ),
//         ),
//         pw.SizedBox(height: 20),
//         // Display legends in a column to avoid overlap
//         pw.Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: List<pw.Widget>.generate(positionData.length, (index) {
//             final data = positionData[index];
//             final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
//             final percentage = (timeSpent / totalSpent * 100).round();
//             final color = chartColors[index % chartColors.length];

//             return pw.Row(
//               mainAxisSize: pw.MainAxisSize.min,
//               children: [
//                 pw.Container(
//                   width: 10,
//                   height: 10,
//                   color: color,
//                 ),
//                 pw.SizedBox(width: 5),
//                 pw.Text('${data['position']} ($percentage%)',
//                     style: const pw.TextStyle(fontSize: 8)),
//               ],
//             );
//           }),
//         ),
//         pw.SizedBox(height: 10),
//         pw.Text(
//           'Total time spent: $totalSpent seconds',
//           style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   // Build the footer in PDF
//   pw.Widget _buildFooter() {
//     return pw.Text(
//       'Generated by Utari',
//       style: const pw.TextStyle(fontSize: 10),
//     );
//   }

//   // Display the same content on the screen
//   Widget _buildOnScreenHeader(String userName, String userEmail) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'REPORT',
//               style: TextStyle(
//                 color: Color.fromARGB(255, 89, 188, 231),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 25,
//               ),
//             ),
//             Text('User: $userName', style: const TextStyle(fontSize: 16)),
//             Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),

//             Text(
//               'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
//               style: const TextStyle(fontSize: 16),
//             ),
//           ],
//         ),
//         // Show image (if you want it on the UI as well)
//         Image.asset(
//           'assets/logobg.png',
//           width: 350,
//           height: 150,
//           fit: BoxFit.fitWidth,
//         ),
//       ],
//     );
//   }

//   // Display the position table on the screen
//   Widget _buildOnScreenPositionTable() {
//     return Table(
//       border: TableBorder.all(color: const Color.fromARGB(255, 89, 188, 231)), // Same as PDF table border
//       children: [
//         const TableRow(
//           decoration: BoxDecoration(color: Color.fromARGB(255, 89, 188, 231)), // Header color same as PDF
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//               child: Text(
//                 'Position',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//               child: Text(
//                 'Time Spent',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//         ...positionData.map((data) {
//           return TableRow(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//                 child: Text(
//                   data['position']!,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//                 child: Text(
//                   data['time']!,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ],
//     );
//   }

//   // Display footer
//   Widget _buildOnScreenFooter() {
//     return const Text(
//       'Generated by UTARI',
//       style: TextStyle(fontSize: 10),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgLight,

//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildOnScreenHeader(userName ?? 'Unknown', userEmail ?? 'Unknown'), // Display the header
//               const SizedBox(height: 20),
//               _buildOnScreenPositionTable(), // Display the position table
//               const SizedBox(height: 20),
//               _buildOnScreenFooter(), // Display footer
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     _generateAndOpenPDF(); // Trigger the PDF generation when the button is tapped
//                   },
//                   child: Container(
//                     width: 250,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           HexColor('#87d9f7'),
//                           HexColor('#87d9f7')
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: const [
//                         // Add shadow if needed
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Generate Detailed Report',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
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
// import 'dart:typed_data';
// import 'package:cushion_1/appcolors.dart';
// import 'package:cushion_1/hexcolor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:cushion_1/localstoragefunctions.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';

// class PDFViewerScreen extends StatefulWidget {
//   const PDFViewerScreen({super.key});

//   @override
//   State<PDFViewerScreen> createState() => PDFViewerScreenState();
// }

// class PDFViewerScreenState extends State<PDFViewerScreen> {
//   final Localstoragefunctions localStorageFunctions = Get.find<Localstoragefunctions>();

//   String? userName;
//   String? userEmail;
//   List<Map<String, String>> positionData = [];

//   @override
//   void initState() {
//   super.initState();
//     // Load data after the widget is mounted
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadData();  // This is now safe to call
//     });
//   }

//   // // Load data from local storage and update the screen
//   // void loadData() {
//   //   if (!mounted) return;  // Ensure that setState is only called if the widget is mounted
//   //   setState(() {
//   //     userName = localStorageFunctions.getUserDetails()['name'] ?? 'Unknown';
//   //     userEmail = localStorageFunctions.getUserDetails()['email'] ?? 'Unknown';
//   //     positionData = _getPositionData();
//   //   });
//   // }
//  // Load data from arguments or local storage
//   void loadData() {
//     // Retrieve the arguments passed during navigation
//     final arguments = Get.arguments;
//     if (arguments != null) {
//       userName = arguments['userName'] ?? 'Unknown';
//       userEmail = arguments['userEmail'] ?? 'Unknown';
//     } else {
//       // Fallback to local storage if arguments are not provided
//       userName = localStorageFunctions.getUserDetails()['name'] ?? 'Unknown';
//       userEmail = localStorageFunctions.getUserDetails()['email'] ?? 'Unknown';
//     }
    
//     // Fetch the position data
//     positionData = _getPositionData();

//     setState(() {});
//   }

//   // Method to retrieve position data from local storage
//   List<Map<String, String>> _getPositionData() {
//     List<String> positions = ['left', 'right', 'forward', 'back', 'leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
//     List<Map<String, String>> positionData = [];

//     for (String position in positions) {
//       int time = localStorageFunctions.getTime(position);
//       positionData.add({'position': position.toUpperCase(), 'time': '$time seconds'});
//     }

//     return positionData;
//   }

//   // Display the position table on the screen
//   Widget _buildOnScreenPositionTable() {
//     return Table(
//       border: TableBorder.all(color: const Color.fromARGB(255, 89, 188, 231)), // Same as PDF table border
//       children: [
//         const TableRow(
//           decoration: BoxDecoration(color: Color.fromARGB(255, 89, 188, 231)), // Header color same as PDF
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//               child: Text(
//                 'Position',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//               child: Text(
//                 'Time Spent',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//         ...positionData.map((data) {
//           return TableRow(
//             children: [
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//                 child: Text(
//                   data['position']!,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
//                 child: Text(
//                   data['time']!,
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//             ],
//           );
//         }).toList(),
//       ],
//     );
//   }

//   // Display footer
//   Widget _buildOnScreenFooter() {
//     return const Text(
//       'Generated by UTARI',
//       style: TextStyle(fontSize: 10),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgLight,

//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildOnScreenHeader(userName ?? 'Unknown', userEmail ?? 'Unknown'), // Display the header
//               const SizedBox(height: 20),
//               _buildOnScreenPositionTable(), // Display the position table
//               const SizedBox(height: 20),
//               _buildOnScreenFooter(), // Display footer
//               Center(
//                 child: GestureDetector(
//                   onTap: () {
//                     _generateAndOpenPDF(); // Trigger the PDF generation when the button is tapped
//                   },
//                   child: Container(
//                     width: 250,
//                     height: 70,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         colors: [
//                           HexColor('#87d9f7'),
//                           HexColor('#87d9f7')
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: const [
//                         // Add shadow if needed
//                       ],
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Generate Detailed Report',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// }
import 'dart:typed_data';
import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:cushion_1/localstoragefunctions.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cushion_1/usercontroller.dart'; // Ensure you import your UserController

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen({super.key});

  @override
  State<PDFViewerScreen> createState() => PDFViewerScreenState();
}

class PDFViewerScreenState extends State<PDFViewerScreen> {
  final Localstoragefunctions localStorageFunctions = Get.find<Localstoragefunctions>();
  final UserController userController = Get.find<UserController>(); // Get the UserController instance

  List<Map<String, String>> positionData = [];

  @override
  void initState() {
    super.initState();
    // Load data after the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(); // This is now safe to call
    });
  }

  // Load data from arguments or local storage
  void loadData() {
    // Fetch the position data
    positionData = _getPositionData();
    setState(() {});
  }
// Method to retrieve adherence data (accuracy) for the four repositioning positions
List<Map<String, String>> _getAdherenceData() {
  List<String> positions = ['leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
  List<Map<String, String>> adherenceData = [];

  for (String position in positions) {
    // Assuming `localStorageFunctions.getAccuracy(position)` returns a double value for accuracy
    double accuracy = localStorageFunctions.getAccuracy(position) ?? 0.0; // Retrieve adherence (accuracy) value
    adherenceData.add({
      'position': position.toUpperCase(),
      'accuracy': '${(accuracy * 100).toStringAsFixed(2)}%' // Convert to percentage
    });
  }

  return adherenceData;
}

Future<void> _generateAndOpenPDF() async {
  // Load image from assets
  final image = await rootBundle.load('assets/logobg.png');
  final imageData = image.buffer.asUint8List();

  final pdf = pw.Document();

  // Get adherence data
  List<Map<String, String>> adherenceData = _getAdherenceData();

  // Add a page with position and adherence data in table format
  pdf.addPage(
    pw.MultiPage(
      build: (pw.Context context) => [
        // Header Section
        _buildHeader(context, userController.userName.value, userController.userEmail.value, imageData),
        pw.SizedBox(height: 40),

        // Pie Chart Label
        pw.Text(
          'Pie Chart',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 10),

        // Render the Pie Chart
        _buildPieChart(positionData),
        pw.SizedBox(height: 20),

        // Posture Data Label
        pw.Text(
          'Posture Data',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 10),

        // Render the Position Table (Posture Data Table)
        _buildPositionTable(positionData),
        pw.SizedBox(height: 30),

        // Reposition Accuracy Label
        pw.Text(
          'Reposition Accuracy',
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.black,
          ),
        ),
        pw.SizedBox(height: 15),

        // Render the Adherence Table (Reposition Accuracy Table)
        _buildAdherenceTable(adherenceData),
        pw.SizedBox(height: 15),

        // Footer Section
        _buildFooter(),
      ],
    ),
  );

  // Save the PDF and open it
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'user_position_and_adherence_data.pdf');
}


  // Method to retrieve position data from local storage
  List<Map<String, String>> _getPositionData() {
    List<String> positions = ['left', 'right', 'forward', 'back', 'leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
    List<Map<String, String>> positionData = [];

    for (String position in positions) {
      int time = localStorageFunctions.getTime(position);
      positionData.add({'position': position.toUpperCase(), 'time': '$time seconds'});
    }

    return positionData;
  }

  // Build the header widget for PDF
  pw.Widget _buildHeader(pw.Context context, String userName, String userEmail, Uint8List imageData) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'USER REPORT',
              style: pw.TextStyle(
                color: const PdfColor.fromInt(0xFF59BCE7),
                fontWeight: pw.FontWeight.bold,
                fontSize: 25,
              ),
            ),
            pw.Text('User: $userName'),
            pw.Text('Email: $userEmail'),
            pw.Text(
              'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
        pw.Container(
          width: 250,
          height: 95,
          child: pw.Image(
            pw.MemoryImage(imageData), // Use the loaded image
            fit: pw.BoxFit.fitWidth,
          ),
        ),
      ],
    );
  }

  // Display the header on the screen using Obx to listen for changes
  Widget _buildOnScreenHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'REPORT',
              style: TextStyle(
                color: Color.fromARGB(255, 89, 188, 231),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            // Use Obx to dynamically update when userName changes
            Obx(() => Text('User: ${userController.userName.value}', style: const TextStyle(fontSize: 16))),
            // Use Obx to dynamically update when userEmail changes
            Obx(() => Text('Email: ${userController.userEmail.value}', style: const TextStyle(fontSize: 16))),
            Text(
              'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        // Show image (if you want it on the UI as well)
        Image.asset(
          'assets/logobg.png',
          width: 350,
          height: 150,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

 
  // Build the position table for PDF
  pw.Widget _buildPositionTable(List<Map<String, String>> positionData) {
    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF59BCE7),
      ),
      headers: ['Posture', 'Duration'],
      data: positionData.map((data) => [data['position']!, data['time']!]).toList(),
    );
  }

  // Method to retrieve adherence data (accuracy) for the four repositioning positions
  List<Map<String, String>> getAdherenceData() {
    List<String> positions = ['leftreposition', 'rightreposition', 'forwardreposition', 'backreposition'];
    List<Map<String, String>> adherenceData = [];

    for (String position in positions) {
      double accuracy = localStorageFunctions.getAccuracy(position) ?? 0.0; // Retrieve adherence (accuracy) value
      adherenceData.add({'position': position.toUpperCase(), 'accuracy': '${(accuracy * 100).toStringAsFixed(2)}%'}); // Convert to percentage
    }

    return adherenceData;
  }

  // Build the adherence table for PDF
  pw.Widget _buildAdherenceTable(List<Map<String, String>> adherenceData) {
    return pw.Table.fromTextArray(
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
      ),
      headerDecoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFF59BCE7),
      ),
      headers: ['Position', 'Accuracy'],
      data: adherenceData.map((data) => [data['position']!, data['accuracy']!]).toList(),
    );
  }

  // Build Pie Chart for PDF
  pw.Widget _buildPieChart(List<Map<String, String>> positionData) {
    final totalSpent = positionData.fold<int>(0, (sum, data) {
      return sum + int.parse(data['time']!.replaceAll(' seconds', ''));
    });

    // If totalSpent is 0, avoid division by zero by skipping the pie chart generation
    if (totalSpent == 0) {
      return pw.Text(
        'No data available for the pie chart.',
        style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      );
    }

    final chartColors = [
      PdfColors.blue,
      PdfColors.red,
      PdfColors.green,
      PdfColors.orange,
      PdfColors.purple,
      PdfColors.cyan,
      PdfColors.yellow,
      PdfColors.pink
    ];

    final pieDatasets = List<pw.Dataset>.generate(positionData.length, (index) {
      final data = positionData[index];
      final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
      final color = chartColors[index % chartColors.length];
      final percentage = (timeSpent / totalSpent * 100).round(); // Calculate the percentage

      return pw.PieDataSet(
        value: timeSpent.toDouble(),
        color: color,
      );
    });

    // Pie chart with legends displayed separately
    return pw.Column(
      children: [
        // Render the pie chart
        pw.Container(
          width: 180,
          height: 180,
          child: pw.Chart(
            grid: pw.PieGrid(),
            datasets: pieDatasets,
          ),
        ),
        pw.SizedBox(height: 20),
        // Display legends in a column to avoid overlap
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List<pw.Widget>.generate(positionData.length, (index) {
            final data = positionData[index];
            final timeSpent = int.parse(data['time']!.replaceAll(' seconds', ''));
            final percentage = (timeSpent / totalSpent * 100).round();
            final color = chartColors[index % chartColors.length];

            return pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Container(
                  width: 10,
                  height: 10,
                  color: color,
                ),
                pw.SizedBox(width: 5),
                pw.Text('${data['position']} ($percentage%)',
                    style: const pw.TextStyle(fontSize: 8)),
              ],
            );
          }),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Total time spent: $totalSpent seconds',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }
  Future<void> generateAndOpenPDF() async {
    // Load image from assets
    final image = await rootBundle.load('assets/logobg.png');
    final imageData = image.buffer.asUint8List();

    final pdf = pw.Document();

    // Get adherence data
    List<Map<String, String>> adherenceData = _getAdherenceData();

    // Add a page with position and adherence data in table format
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
       _buildHeader(context, userController.userName.value, userController.userEmail.value, imageData),


          pw.SizedBox(height: 40),

          // Add a label for the Pie Chart
          pw.Text(
            'Pie Chart',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 10),

          // Render the Pie Chart
          _buildPieChart(positionData),
          pw.SizedBox(height: 20),

          // Add a label for the posture data table
          pw.Text(
            'Posture Data',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 10),

          // Render the table with posture data
          _buildPositionTable(positionData),

          pw.SizedBox(height: 30),

          // Add a label for the adherence (accuracy) table
          pw.Text(
            'Reposition Accuracy',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
          pw.SizedBox(height: 15),

          // Render the adherence table
          _buildAdherenceTable(adherenceData),

          pw.SizedBox(height: 15),
          _buildFooter(),
        ],
      ),
    );

    // Save the PDF and open it
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'user_position_and_adherence_data.pdf');
  }

  // Build the footer in PDF
  pw.Widget _buildFooter() {
    return pw.Text(
      'Generated by Utari',
      style: const pw.TextStyle(fontSize: 10),
    );
  }

  // Display the same content on the screen
  Widget buildOnScreenHeader(String userName, String userEmail) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'REPORT',
              style: TextStyle(
                color: Color.fromARGB(255, 89, 188, 231),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            Text('User: $userName', style: const TextStyle(fontSize: 16)),
            Text('Email: $userEmail', style: const TextStyle(fontSize: 16)),

            Text(
              'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        // Show image (if you want it on the UI as well)
        Image.asset(
          'assets/logobg.png',
          width: 350,
          height: 150,
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

  // Build the position table on the screen
  Widget _buildOnScreenPositionTable() {
    return Table(
      border: TableBorder.all(color: const Color.fromARGB(255, 89, 188, 231)),
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color.fromARGB(255, 89, 188, 231)),
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Text(
                'Position',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
              child: Text(
                'Time Spent',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        ...positionData.map((data) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: Text(
                  data['position']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                child: Text(
                  data['time']!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Build the footer in PDF
  pw.Widget buildFooter() {
    return pw.Text(
      'Generated by Utari',
      style: const pw.TextStyle(fontSize: 10),
    );
  }

  // Display footer
  Widget _buildOnScreenFooter() {
    return const Text(
      'Generated by UTARI',
      style: TextStyle(fontSize: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOnScreenHeader(), // Use the dynamic header with GetX
              const SizedBox(height: 20),
              _buildOnScreenPositionTable(), // Display the position table
              const SizedBox(height: 20),
              _buildOnScreenFooter(), // Display footer
              Center(
                child: GestureDetector(
                  onTap: () {
                    _generateAndOpenPDF(); // Trigger the PDF generation when the button is tapped
                  },
                  child: Container(
                    width: 250,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          HexColor('#87d9f7'),
                          HexColor('#87d9f7')
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        // Add shadow if needed
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Generate Detailed Report',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
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
}
