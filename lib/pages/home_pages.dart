import 'package:ble_app_timer/provider/ble_provider.dart';
import 'package:ble_app_timer/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:ble_app_timer/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isConnected = false;
  late BluetoothDevice myDevice;
  String deviceName = "";
  Guid uuidWrite = Guid("d8520577-81ed-478c-a3ad-a810d65c064a");


  @override
  Widget build(BuildContext context) {
    final bleprovider = Provider.of<BleProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    statusText(),
                    const SizedBox(height: 16),
                    title(),
                    Text(
                      deviceName,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    deviceMenu(bleprovider),
                    const SizedBox(height: 10),
                    buttonConecction(bleprovider),
                  ],
                ),
              ),
              const TimePicker(),
            ],
          ),
        ),
      ),
    );
  }

  Container deviceMenu(BleProvider bleProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12.0), // Ajusta el padding según tus preferencias
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0), // Bordes semi circulares
      ),
      child: DropdownButton(
        hint: const Text(
          "Select a device",
          style: TextStyle(color: Colors.black),
        ),
        value: bleProvider.selectedDevice,
        onChanged: (BluetoothDevice? newDevice) {
          if (newDevice != null) {
            myDevice = newDevice;
            deviceName = myDevice.platformName;
            setState(() {});
          }
        },
        items: bleProvider.devices.map<DropdownMenuItem<BluetoothDevice>>((BluetoothDevice device) {
          return DropdownMenuItem<BluetoothDevice>(
            value: device,
            child: Text(
              device.platformName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
              style: const TextStyle(color: Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  Padding buttonConecction(BleProvider bleProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomButton(
        icon: Icons.power_settings_new,
        text: isConnected ? "Disconnect" : "Connect",
        onPressed: () async {
          if (!isConnected) {
            await bleProvider.connectToDevice(myDevice);
            await bleProvider.subscribeToNotifications(uuidWrite);
          } else {
            bleProvider.forgetNotifications();
            await bleProvider.disconnectToDevice(myDevice);
            bleProvider.startScanning();
            deviceName = "";
          }
          isConnected = myDevice.isConnected;
          setState(() {});
        },
      ),
    );
  }

  Center title() {
    return const Center(
      child: Text(
        "Timer ESP32",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Container statusText() {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.all(8.0),
      child: Text(
        isConnected ? "Connected" : "Disconnected",
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
