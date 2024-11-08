// seat_functions_fragment.dart
import 'package:cushion_1/MaterialProgressController.dart';
import 'package:cushion_1/appcolors.dart';
import 'package:cushion_1/materialprogress.dart';
import 'package:cushion_1/normalization_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:cushion_1/bluettoth_data.dart';
import 'package:cushion_1/communicationhandler.dart';

class SeatFunctionsFragment extends StatelessWidget {
  
  const SeatFunctionsFragment({super.key});
  
  @override
  Widget build(BuildContext context) {
         final normalizationProvider = Provider.of<NormalizationProvider>(context, listen: false);
    // final MaterialProgressController materialProgressController = Get.find<MaterialProgressController>();
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          backgroundColor: AppColors.bgLight,
        body: TabBarView(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {  
              int crossAxisCount;
                if (constraints.maxWidth >= 1000) {
                  crossAxisCount = 3; 
                } else if (constraints.maxWidth >= 600) {
                  crossAxisCount = 3; 
                } else {
                  crossAxisCount = 2; 
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    
                    padding: EdgeInsets.fromLTRB(30, constraints.maxWidth >= 600 ? 88.0 : 16.0,0,0),
                    child: GridView.count(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 8.0,  
                      mainAxisSpacing: 8.0,   
                      children: List.generate(6, (index) {
                        return GestureDetector(
                          onTap: () {
                        
                            if (index == 0) {
                                
                              showInflateAlert(context);
                            }
                            if (index == 3) {  
                              showDeflateAlert(context);
                            }
                            if(index==1){
                           
                              showredistributeAlert(context);
                            }
                             if(index==5){
                              showrequalizeAlert(context);
                            }
                             if(index==4){
                          // materialProgressController.setIndex(7);
                          // print(materialProgressController.selectedIndex);
                            }
                          },
                            child: Card(
                              color: AppColors.bgSecondayLight,
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      _getIcon(index),
                                      width: index == 1 ? 50.0 : 40.0,  
                                      height: index == 1 ? 50.0 : 40.0, 
                                      fit: BoxFit.cover,
                                    ),
                                    if (index == 1)
                             const SizedBox(height: 0)  
                                     else
                                const SizedBox(height: 2.0),  
                                    Padding(
                                      padding: const EdgeInsets.all(24.0),  
                                      child: Center(
                                        child: Text(
                                          _getCardLabel(index),
                                          style:index == 1 ? const TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold):const TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold),  // Reduced font size
                                           textAlign: TextAlign.center,  
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  void showrequalizeAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 600,
          child: AlertDialog(
            
            title: const Text('Equalize',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            content: const Text('Are You Sure You Want To Equalize?',style: TextStyle(fontSize: 24)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No',style: TextStyle(fontSize: 20),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  sendEqualizeCommand(context);
                if (MediaQuery.of(context).size.width < 600) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaterialProgressWidget(),
                      ));
           }
                },
                child: const Text('Yes',style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        );
      },
    );
  }
 void sendEqualizeCommand(BuildContext context) {
     final bluetoothData = Provider.of<BluetoothData>(context, listen: false);
    final communicationHandler = CommunicationHandler.getInstance();

    if (bluetoothData.isConnected) {
      String deflateCommand =
          "br\n"; 
      communicationHandler.writeData(deflateCommand);
    } else {
      if (kDebugMode) {
        print("No device connected or unable to send data");
      }
    }
  }
  void showDeflateAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 600,
          child: AlertDialog(
            
            title: const Text('DEFLATE',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            content: const Text('Are You Sure You Want To Deflate?',style: TextStyle(fontSize: 24)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No',style: TextStyle(fontSize: 20),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  sendDeflateCommand(context);
                if (MediaQuery.of(context).size.width < 600) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaterialProgressWidget(),
                      ));
           }
                },
                child: const Text('Yes',style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        );
      },
    );
  }

   void showInflateAlert(BuildContext context) {
    showDialog(
      context: context,
    
      builder: (BuildContext context) {
        return SizedBox(
          height: 100,
          child: AlertDialog(
            title: const Text('INFLATE',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
            content: const Text('Are you sure you want to Inflate?',style: TextStyle(fontSize: 20)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No',style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  sendInflateCommand(context);
           if (MediaQuery.of(context).size.width < 600) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaterialProgressWidget(),
                      ));
           }
                },
                child: const Text('Yes',style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        );
      },
    );
  }

   void showredistributeAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height:200,
          child: AlertDialog(
            title: const Text('INITIATE REDISTRIBUTION',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            content: const Text('Are you sure you want to Initiate  Redistribution ?',style: TextStyle(fontSize: 20)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No',style: TextStyle(fontSize: 20)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  sendredistributeCommand(context);
          if (MediaQuery.of(context).size.width < 600) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MaterialProgressWidget(),
                      ));
           }
                },
                child: const Text('Yes',style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        );
      },
    );
  }
void sendInflateCommand(BuildContext content){
  // final normalizationProvider = Provider.of<NormalizationProvider>(content, listen: false); 
  // normalizationProvider.setNormalizationFactor(1.5); 

  final bluetoothDatai =Provider.of<BluetoothData>(content,listen:false);
  final communicationHandleri =CommunicationHandler.getInstance();
  if(bluetoothDatai.isConnected){
    String inflatecommand="bo11000\n";
    communicationHandleri.writeData(inflatecommand);

  }else{
    if(kDebugMode){
      print("NO DEVICE CONNECTED ");
    }
  }
}
void sendredistributeCommand(BuildContext content){
  //   final normalizationProvider = Provider.of<NormalizationProvider>(content, listen: false); 
  // normalizationProvider.setNormalizationFactor(2.0); 
  final bluetoothDatare =Provider.of<BluetoothData>(content,listen:false);
  final communicationHandlerre =CommunicationHandler.getInstance();
  if(bluetoothDatare.isConnected){
    String inflatecommand="br5000\n";
    communicationHandlerre.writeData(inflatecommand);

  }else{
    if(kDebugMode){
      print("NO DEVICE CONNECTED ");
    }
  }
}
  void sendDeflateCommand(BuildContext context) {
    final bluetoothData = Provider.of<BluetoothData>(context, listen: false);
    final communicationHandler = CommunicationHandler.getInstance();

    if (bluetoothData.isConnected) {
      String deflateCommand =
          "b-\n"; 
      communicationHandler.writeData(deflateCommand);
    } else {
      if (kDebugMode) {
        print("No device connected or unable to send data");
      }
    }
  }

  String _getIcon(int index) {
    switch (index) {
      case 0:
        return 'assets/INFLATE.png';
        case 1:
        return 'assets/REDISTRIBUTE.png';
      case 2:
        return 'assets/LOWER.png';
      
      case 3:
        return 'assets/deflate.png';
         case 4:
        return 'assets/offload.png';
        case 5:
        return 'assets/equalizer.png';
      default:
        return 'assets/circle.png';
    }
  }

  String _getCardLabel(int index) {
    switch (index) {
      case 0:
        return 'INFLATE';
         case 1:
        return 'INITIATE REDISTRIBUTION';
      case 2:
        return 'LOWER';
      case 3:
        return 'DEFLATE ';
      case 4:
        return 'INITIATE AUTO OFFLOAD';
      case 5:
        return 'EQUALIZE';
      default:
        return 'Unknown';
    }
  }
}
