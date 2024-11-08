import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:simple_logger/simple_logger.dart';

class BluetoothData with ChangeNotifier {
  final List<String> _dataList = [];
  final List<DiscoveredDevice> _devices = [];
  String _connectedDeviceDetails = '';
  bool _isConnected = false;
  bool _isScanning = false; 
  final SimpleLogger logger = SimpleLogger(); 
  List<String> get dataList => _dataList;
  List<DiscoveredDevice> get devices => _devices;
  String get connectedDeviceDetails => _connectedDeviceDetails;
  bool get isConnected => _isConnected;
  bool get isScanning => _isScanning;
  double _normalizationFactor = 16.0;

  double get normalizationFactor => _normalizationFactor;

  void setNormalizationFactor(double factor) {
    _normalizationFactor = factor;
    notifyListeners();
  }


  void addData(String data) {
    _dataList.add(data);
    notifyListeners();
  }

  void clearAllData() {
    logger.info("Clearing all data due to disconnection");
    _dataList.clear();
    _devices.clear();
    _connectedDeviceDetails = '';
    _isConnected = false;
    notifyListeners();
  }

  void clearData() {
    _dataList.clear();
    notifyListeners();
  }

  void addDevice(DiscoveredDevice device) {
    if (!_devices.any((d) => d.id == device.id)) {
      _devices.add(device);
      notifyListeners();
    }
  }

  void clearDevices() {
    _devices.clear(); 
    notifyListeners();
  }

  void setConnectedDeviceDetails(String details) {
    _connectedDeviceDetails = details;
    notifyListeners();
  }

  void setConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }

  void setIsScanning(bool value) {
    _isScanning = value;
    notifyListeners();
  }
}
