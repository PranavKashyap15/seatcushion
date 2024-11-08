import 'dart:async';
import 'dart:convert';
import 'package:cushion_1/bleconnectionhandler.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:simple_logger/simple_logger.dart';

class CommunicationHandler {
  static CommunicationHandler? _instance;
  SimpleLogger logger = SimpleLogger();
  late final BleConnectionHandler bleConnectionHandler;
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  final StreamController<Map<int, double>> _cellPressureController =
      StreamController<Map<int, double>>.broadcast();
  DiscoveredDevice? _connectedDevice;
  DiscoveredDevice? get connectedDevice => _connectedDevice;

  List<String> dataBuffer = [];
  static final Uuid espServiceUUID =
      Uuid.parse("7b43687c-b94c-4811-8fe7-0167d803b4bd");
  static final Uuid espCharacteristicUUID =
      Uuid.parse("c5c3cae5-f26f-407e-9068-c44a7d7bbee5");
  String deviceId = "";
  static CommunicationHandler getInstance() {
    _instance ??= CommunicationHandler._internal();
    return _instance!;
  }
  CommunicationHandler._internal() {
    bleConnectionHandler = BleConnectionHandler();
  }
  Stream<bool> get connectionUpdates => _connectionStatusController.stream;
  Stream<Map<int, double>> get cellPressureUpdates =>
      _cellPressureController.stream;
  void startScan(Function(DiscoveredDevice) scanDevice) {
    bleConnectionHandler
        .startBluetoothScan((discoveredDevice) => scanDevice(discoveredDevice));
  }
  Future<void> stopScan() async {
    await bleConnectionHandler.stopScan();
  }
  void connectToDevice(
      DiscoveredDevice discoveredDevice, Function(bool) connectionStatus) {
    bleConnectionHandler.connectToDevice(discoveredDevice, (isConnected) async {
      deviceId = discoveredDevice.id;
      connectionStatus(isConnected);
      if (isConnected) {
        // Request a larger MTU size
        await bleConnectionHandler.flutterReactiveBle
            .requestMtu(deviceId: deviceId, mtu: 517)
            .then((mtuSize) {
          logger.info("Requested MTU size of $mtuSize");
        }).catchError((e) {
          logger.info("Error requesting MTU size: $e");
        });
        await subscribeToMeasurement(espServiceUUID, espCharacteristicUUID,
            (String data) {
          processData(data);
        });
      } else {
        // Notify about disconnection
        _connectionStatusController.add(isConnected);
      }
    });
  }
  Future<void> subscribeToMeasurement(Uuid service, Uuid characteristicToNotify,
      Function(String) onDataReceived) async {
    final characteristic = QualifiedCharacteristic(
        serviceId: service,
        characteristicId: characteristicToNotify,
        deviceId: deviceId);
    bleConnectionHandler.flutterReactiveBle
        .subscribeToCharacteristic(characteristic)
        .listen((data) {
      if (data.isNotEmpty) {
        String receivedData = utf8.decode(data);
        //logger.info('Received data: $receivedData'); // Print received data
        onDataReceived(receivedData);
      }
    }, onError: (dynamic error) {
      logger.info('Error subscribing to characteristic: $error');
    });
  }
  void writeData(String data) {
    if (deviceId.isEmpty) {
      logger.info("No device connected or device ID is not set.");
      return;
    }
    final characteristic = QualifiedCharacteristic(
        serviceId: espServiceUUID,
        characteristicId: espCharacteristicUUID,
        deviceId: deviceId);
    List<int> bytes = utf8.encode(data);
    bleConnectionHandler.flutterReactiveBle
        .writeCharacteristicWithResponse(characteristic, value: bytes)
        .then((value) => logger.info("Successfully written data: $data"),
            onError: (e) => logger.info("Failed to write data: $e"));
  }
  void processData(String data) {
    // Append new data to buffer
    dataBuffer.add(data);

    // Check if buffer contains a complete message
    String accumulatedData = dataBuffer.join('');
    while (accumulatedData.contains('a') && accumulatedData.contains('z')) {
      int startIndex = accumulatedData.indexOf('a');
      int endIndex = accumulatedData.indexOf('z', startIndex);

      if (endIndex != -1) {
        // Extract the complete message
        String completeMessage =
            accumulatedData.substring(startIndex, endIndex + 1);
        //logger.info('Processing data: $completeMessage');
        processReceivedData(completeMessage);

        // Remove processed message from buffer
        accumulatedData = accumulatedData.substring(endIndex + 1);
        dataBuffer = [accumulatedData];
      } else {
        break;
      }
    }
  }
  void processReceivedData(String data) {
    final regex = RegExp(r'a([\d.,-]+)z');
    final match = regex.firstMatch(data);

    if (match != null) {
      String valuesStr =
          match.group(1)!.replaceAll(' ', ''); // Remove any spaces
      List<String> valuesList = valuesStr.split(',');
      Map<int, double> cellPressures = {};

      for (int i = 0; i < valuesList.length && i < 48; i++) {
        double value = double.tryParse(valuesList[i]) ?? 0.0;
        cellPressures[i + 1] = value; // Cell numbers start at 1
      }
   //   print("CELLPRESUURES FROM CH$cellPressures");
      // Notify listeners with the new cell pressures
      _cellPressureController.add(cellPressures);
      //print(cellPressures);
    } else {
      logger.info('Invalid data format');
    }
  }
}
