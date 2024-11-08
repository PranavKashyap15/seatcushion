//bleconnectionhandler.dart

import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:simple_logger/simple_logger.dart';

class BleConnectionHandler {
  SimpleLogger logger = SimpleLogger();

  final flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription? streamSubscription;
  StreamSubscription<ConnectionStateUpdate>? connection;

  BleConnectionHandler() {
    flutterReactiveBle.statusStream.listen((status) {
      if (status == BleStatus.ready) {
        logger.info("BLE is ready for communication.");
      } else {
        logger.info("BLE is not available: $status");
      }
    });
  }

  String? _deviceId; 
  String get deviceId => _deviceId ?? '';

  void startBluetoothScan(Function(DiscoveredDevice) discoveredDevice) async {
    if (flutterReactiveBle.status == BleStatus.ready) {
      logger.info("Start BLE discovery");
      streamSubscription =
          flutterReactiveBle.scanForDevices(withServices: []).listen((device) {
        if (device.name.isNotEmpty) {
          _deviceId = device.id;
          discoveredDevice(device);
        }
      }, onError: (Object e) {
        logger.info('Device scan fails with error: $e');
      });
    } else {
      logger.info("BLE is not ready for communication.");
    }
  }

  void connectToDevice(
      DiscoveredDevice discoveredDevice, Function(bool) connectionStatus) {
    connection = flutterReactiveBle
        .connectToDevice(id: discoveredDevice.id)
        .listen((connectionState) {
      logger.info(
          "ConnectionState for device ${discoveredDevice.name}: ${connectionState.connectionState}");
      if (connectionState.connectionState == DeviceConnectionState.connected) {
        connectionStatus(true);
      } else if (connectionState.connectionState ==
          DeviceConnectionState.disconnected) {
        connectionStatus(false);
      }
    }, onError: (Object error) {
      logger.info("Connecting to device resulted in error: $error");
      connectionStatus(false);
    });
  }

  Future<void> closeConnection() async {
    logger.info("Closing connection");
    await connection?.cancel();
    connection = null;
  }

  Future<void> stopScan() async {
    logger.info("Stopping BLE discovery");
    await streamSubscription?.cancel();
    streamSubscription = null;
  }
}
