import 'package:ble_app_timer/provider/dates_provider.dart';
import 'package:ble_app_timer/provider/switch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:ble_app_timer/components/row_of_dates.dart';
import 'package:ble_app_timer/components/row_of_switch.dart';
import 'package:ble_app_timer/provider/ble_provider.dart';
import 'package:ble_app_timer/widgets/custom_button.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  bool datesMatch = false;
  String warningText = '';
  String warningDevice = '';
  String warningRele = '';
  String successmesage = '';

  Guid uuidWrite = Guid("d8520577-81ed-478c-a3ad-a810d65c064a");

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 30),
        Text(
          warningRele,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 15,
            fontFamily: 'Roboto', // Example font family
          ),
        ),
        const RowOfSwitch(),
        const RowOfDates(),
        datesMatch
            ? Text(
                warningText,
                style: const TextStyle(color: Colors.red),
              )
            : const Text(''),
        const SizedBox(height: 20),
        CustomButton(
          icon: Icons.send,
          text: 'Send data',
          width: MediaQuery.of(context).size.width * 0.8,
          onPressed: sendata,
        ),
        const SizedBox(height: 10),
        Text(
          warningDevice,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontFamily: 'Roboto',
          ),
        ),
        Text(
          successmesage,
          style: const TextStyle(
            color: Color.fromARGB(255, 35, 116, 37),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }

  Future<void> sendata() async {
    final bleprovider = Provider.of<BleProvider>(context, listen: false);
    final dateProvider = Provider.of<DatesProvider>(context, listen: false);
    final switchProvider = Provider.of<SwitchProvider>(context, listen: false);

    DateTime toDate = dateProvider.toDate;
    DateTime fromDate = dateProvider.fromDate;

    bool isFeatureEnabled = switchProvider.isFeatureEnabled;
    bool isFeatureEnabled1 = switchProvider.isFeatureEnabled1;
    bool isFeatureEnabled2 = switchProvider.isFeatureEnabled2;

    if (bleprovider.selectedDevice == null ||
        !bleprovider.selectedDevice!.isConnected) {
      warningDevice = "The device is not connected.";
      setState(() {});
      return;
    }

    DateTime now = DateTime.now();

    if (toDate.year < now.year ||
        (toDate.year == now.year && toDate.month < now.month) ||
        (toDate.year == now.year &&
            toDate.month == now.month &&
            toDate.day < now.day) ||
        (toDate.year == now.year &&
            toDate.month == now.month &&
            toDate.day == now.day &&
            (toDate.hour < now.hour ||
                (toDate.hour == now.hour && toDate.minute < now.minute)))) {
      datesMatch = true;
      warningDevice = "";
      warningText = "The end time cannot be earlier than the current time";
      setState(() {});
      return;
    }

    if (!(isFeatureEnabled || isFeatureEnabled1 || isFeatureEnabled2)) {
      warningDevice = "";
      datesMatch = false;
      warningRele = "Select one rele";
      setState(() {});
      return;
    }

    datesMatch = false;
    List<int> data = [];
    if (isFeatureEnabled) data.add(2);
    if (isFeatureEnabled1) data.add(15);
    if (isFeatureEnabled2) data.add(18);

    data.add(fromDate.year % 100);
    data.add(fromDate.month);
    data.add(fromDate.day);
    data.add(fromDate.hour);
    data.add(fromDate.minute);

    data.add(toDate.year % 100);
    data.add(toDate.month);
    data.add(toDate.day);
    data.add(toDate.hour);
    data.add(toDate.minute);

    await bleprovider.writeCharacteristic(uuidWrite, data);

    await Future.delayed(const Duration(milliseconds: 200));

    warningDevice = "";
    successmesage = bleprovider.response;
    warningRele = "";

    setState(() {});

    Timer(const Duration(seconds: 2), () {
      setState(() {
        successmesage = "";
      });
    });
  }
}
