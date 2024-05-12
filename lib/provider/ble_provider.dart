import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleProvider extends ChangeNotifier {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  String response = '';
  String readResponse = '';
  var subscription;

  BleProvider() {
    startScanning();
  }

  void startScanning() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        if (!devices.contains(result.device)) {
          devices.add(result.device);
          notifyListeners();
        }
      }
    });
  }

  void stopScanning() {
    FlutterBluePlus.stopScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    selectedDevice = device;
    await selectedDevice!.connect();
    notifyListeners();
  }

  Future<void> disconnectToDevice(BluetoothDevice device) async {
    await selectedDevice!.disconnect();
    selectedDevice = null;
    notifyListeners();
  }

  void writeCharacteristic(Guid characteristicId, List<int> data) async {
    List<BluetoothService> services = await selectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          await characteristic.write(data);
        }
      }
    }
  }

  void readCharacteristic(Guid characteristicId) async {
    List<BluetoothService> services = await selectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          List<int> value = await characteristic.read();
          readResponse = utf8.decode(value);
        }
      }
    }
  }

  void subscribeToNotifications(Guid characteristicId) async {
    List<BluetoothService> services = await selectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          await characteristic.setNotifyValue(true);
          subscription = characteristic.onValueReceived.listen((value) {
            response = utf8.decode(value);
          });
        }
      }
    }
  }

  void forgetNotifications() {
    selectedDevice!.cancelWhenDisconnected(subscription);
  }
}
