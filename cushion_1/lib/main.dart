import 'package:cushion_1/localstoragefunctions.dart';
import 'package:cushion_1/materialprogress.dart';
import 'package:cushion_1/normalization_provider.dart';
import 'package:cushion_1/bluettoth_data.dart';
import 'package:cushion_1/pdfviewer.dart';
import 'package:cushion_1/usercontroller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';  
void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    await GetStorage.init();
    Get.put(UserController());
    Get.put(MaterialProgressWidgetState());
    Get.put(Localstoragefunctions());
     Get.put(PDFViewerScreenState());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NormalizationProvider()),
        ChangeNotifierProvider(create: (context) => BluetoothData()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      title: 'Flutter BLE Application',
      home: MaterialProgressWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
