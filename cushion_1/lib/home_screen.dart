// home_screen.dart
import 'package:cushion_1/materialprogress.dart';
import 'package:flutter/material.dart';
import 'package:cushion_1/bluettoth_data.dart';
import 'package:cushion_1/communicationhandler.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_logger/simple_logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SimpleLogger logger = SimpleLogger();
  final TextEditingController dataController = TextEditingController();
  late final CommunicationHandler communicationHandler;

  @override
  void initState() {
    super.initState();
    communicationHandler = CommunicationHandler.getInstance();
    communicationHandler.connectionUpdates.listen((isConnected) {
      if (!mounted) return;
      var provider = Provider.of<BluetoothData>(context, listen: false);
      provider.setConnectionStatus(isConnected);
      if (!isConnected) {
        provider.clearAllData();
      }
    });
    checkPermissions();
  }

  void checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
      Permission.bluetoothAdvertise,
    ].request();
    logger.info("PermissionStatus -- $statuses");
  }

  void startScan() {
    var provider = Provider.of<BluetoothData>(context, listen: false);
    provider.clearDevices();
    provider.setIsScanning(true);
    communicationHandler.startScan((device) {
      if (!mounted) return;
      provider.addDevice(device);
    });
  }

  Future<void> stopScan() async {
    await communicationHandler.stopScan();
    if (!mounted) return;
    Provider.of<BluetoothData>(context, listen: false).setIsScanning(false);
  }

  Future<void> connectToDevice(DiscoveredDevice selectedDevice) async {
    await stopScan();
    communicationHandler.connectToDevice(selectedDevice, (isConnected) {
      if (!mounted) return;
      var provider = Provider.of<BluetoothData>(context, listen: false);
      provider.setConnectionStatus(isConnected);
      provider
          .setConnectedDeviceDetails(isConnected ? selectedDevice.name : "");
      if (isConnected) {
        communicationHandler.subscribeToMeasurement(
          CommunicationHandler.espServiceUUID,
          CommunicationHandler.espCharacteristicUUID,
          (String data) {
            if (!mounted) return;
            provider.addData(data);
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
  return PopScope(
    canPop: false,
    onPopInvoked: (didPop) {
      // Navigate back to MaterialProgressWidget
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MaterialProgressWidget(),
        ),
      );
    },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("BLE CONNECTION"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton.icon(
                      icon: Icon(Provider.of<BluetoothData>(context).isScanning
                          ? Icons.stop
                          : Icons.search),
                      label: Text(Provider.of<BluetoothData>(context).isScanning
                          ? "Stop Scanning"
                          : "Start Scanning Devices"),
                      onPressed: Provider.of<BluetoothData>(context).isScanning
                          ? stopScan
                          : startScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Provider.of<BluetoothData>(context).isScanning
                                ? Colors.red
                                : Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(50, 50),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Consumer<BluetoothData>(
                      builder: (context, bluetoothData, child) => TextField(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: bluetoothData.isConnected
                              ? bluetoothData.connectedDeviceDetails
                              : 'No device connected',
                        ),
                        readOnly: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Consumer<BluetoothData>(
                builder: (context, bluetoothData, child) => ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: bluetoothData.devices.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.lightBlueAccent,
                      elevation: 4,
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                        title: Text(
                          bluetoothData.devices[index].name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () =>
                            connectToDevice(bluetoothData.devices[index]),
                        trailing:
                            const Icon(Icons.bluetooth, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<BluetoothData>(
                builder: (context, bluetoothData, child) => ListView.builder(
                  itemCount: bluetoothData.dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        bluetoothData.dataList[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<BluetoothData>(context, listen: false)
                      .clearData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(100, 50),
                ),
                child: const Text('Clear'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: dataController,
                      decoration: const InputDecoration(
                        labelText: "Enter Data",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.send),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (Provider.of<BluetoothData>(context, listen: false)
                              .isConnected &&
                          dataController.text.isNotEmpty) {
                        String dataToSend = dataController.text;
                        communicationHandler.writeData(dataToSend);
                        dataController
                            .clear(); // Optionally clear the controller after sending.
                      } else {
                        logger.info("No device connected or no data to send");
                      }
                    },
                    child: const Text("Send Data"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
