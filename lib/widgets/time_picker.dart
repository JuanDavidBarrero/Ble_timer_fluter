import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import 'package:ble_app_timer/provider/ble_provider.dart';

import 'package:ble_app_timer/widgets/custom_button.dart';
import 'package:ble_app_timer/widgets/custom_switch.dart';
import 'package:ble_app_timer/widgets/date_piker.dart';

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late TimeOfDay timeFrom;
  late TimeOfDay timeTo;
  bool datesMatch = false;
  String warningText = '';
  String warningDevice = '';
  String warningRele = '';
  String successmesage = '';
  String response = '';
  String response2 = '';
  String response3 = '';
  bool isFeatureEnabled = false;
  bool isFeatureEnabled1 = false;
  bool isFeatureEnabled2 = false;
  Guid uuidWrite = Guid("d8520577-81ed-478c-a3ad-a810d65c064a");

  @override
  void initState() {
    super.initState();
    timeFrom = TimeOfDay.now();
    timeTo = TimeOfDay.now();
  }

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
        rowOfSwitch(),
        rowOfDates(),
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
            onPressed: sendata),
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

  Row rowOfSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSwitch(
          topText: 'Rele 1',
          bottomText: isFeatureEnabled ? response : '',
          value: isFeatureEnabled,
          onChanged: (newValue) => onSwitchChanged(newValue, 0),
        ),
        const SizedBox(width: 30),
        CustomSwitch(
          topText: 'Rele 2',
          bottomText: isFeatureEnabled1 ? response2 : '',
          value: isFeatureEnabled1,
          onChanged: (newValue) => onSwitchChanged(newValue, 1),
        ),
        const SizedBox(width: 30),
        CustomSwitch(
          topText: 'Rele 3',
          bottomText: isFeatureEnabled2 ? response3 : '',
          value: isFeatureEnabled2,
          onChanged: (newValue) => onSwitchChanged(newValue, 2),
        ),
      ],
    );
  }

  Row rowOfDates() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DatePicker(
          selectedTime: timeTo,
          text: 'to',
          onPressed: () async {
            await _showTimePicker((newTime) {
              setState(() {
                timeTo = newTime;
                if ((timeTo.hour > timeFrom.hour ||
                    (timeTo.hour == timeFrom.hour &&
                        timeTo.minute > timeFrom.minute))) {
                  timeFrom =
                      TimeOfDay(hour: timeTo.hour, minute: timeTo.minute + 1);
                }
              });
            });
          },
        ),
        const SizedBox(
          width: 20,
        ),
        DatePicker(
          selectedTime: timeFrom,
          text: 'from',
          onPressed: () async {
            await _showTimePicker((newTime) {
              setState(() {
                timeFrom = newTime;
              });
            });
          },
        ),
      ],
    );
  }

  Future<void> _showTimePicker(void Function(TimeOfDay) onTimePicked) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      onTimePicked(pickedTime);
    }
  }

  void onSwitchChanged(bool newValue, int switchIndex) {
    final bleprovider = Provider.of<BleProvider>(context, listen: false);

    response = "";
    response2 = "";
    response3 = "";

    setState(() {
      isFeatureEnabled = switchIndex == 0 && newValue;
      isFeatureEnabled1 = switchIndex == 1 && newValue;
      isFeatureEnabled2 = switchIndex == 2 && newValue;
    });

    if (bleprovider.selectedDevice == null) {
      return;
    }

    List<int> data = [];

    data.add(100);

    if (isFeatureEnabled) data.add(2);
    if (isFeatureEnabled1) data.add(15);
    if (isFeatureEnabled2) data.add(18);

    bleprovider.writeCharacteristic(uuidWrite, data);

    if (newValue) {
      bleprovider.readCharacteristic(uuidWrite);
      switch (switchIndex) {
        case 0:
          response = bleprovider.readResponse;
          break;
        case 1:
          response2 = bleprovider.readResponse;
          break;
        case 2:
          response3 = bleprovider.readResponse;
        default:
          break;
      }
    
    }
  }

  void sendata() {
    final bleprovider = Provider.of<BleProvider>(context, listen: false);

    if (bleprovider.selectedDevice == null ||
        !bleprovider.selectedDevice!.isConnected) {
      warningDevice = "The device is not connected.";
      setState(() {});
      return;
    }

    if (timeFrom.hour >= timeTo.hour && timeFrom.minute <= timeTo.minute) {
      datesMatch = true;
      warningDevice = "";
      warningText = "The start time cannot be less than the end time";
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

    data.add(timeTo.hour);
    data.add(timeTo.minute);
    data.add(timeFrom.hour);
    data.add(timeFrom.minute);

    bleprovider.writeCharacteristic(uuidWrite, data);

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
