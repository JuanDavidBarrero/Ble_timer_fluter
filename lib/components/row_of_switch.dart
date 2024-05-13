import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

import 'package:ble_app_timer/provider/ble_provider.dart';
import 'package:ble_app_timer/provider/switch_provider.dart';
import 'package:ble_app_timer/widgets/custom_switch.dart';

class RowOfSwitch extends StatefulWidget {
  const RowOfSwitch({super.key});

  @override
  State<RowOfSwitch> createState() => _RowOfSwitchState();
}

class _RowOfSwitchState extends State<RowOfSwitch> {
  Guid uuidWrite = Guid("d8520577-81ed-478c-a3ad-a810d65c064a");

  @override
  Widget build(BuildContext context) {
    return Consumer<SwitchProvider>(
      builder: (context, switchProvider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSwitch(
              topText: 'Rele 1',
              bottomText: switchProvider.isFeatureEnabled ? switchProvider.response : '',
              value: switchProvider.isFeatureEnabled,
              onChanged: (newValue) async {
                setState(() {
                  switchProvider.isFeatureEnabled = newValue;
                  switchProvider.isFeatureEnabled1 = false;
                  switchProvider.isFeatureEnabled2 = false;
                });
                if (newValue) {
                  await _updateResponse(context, switchProvider, 0);
                }
              },
            ),
            const SizedBox(width: 30),
            CustomSwitch(
              topText: 'Rele 2',
              bottomText: switchProvider.isFeatureEnabled1 ? switchProvider.response2 : '',
              value: switchProvider.isFeatureEnabled1,
              onChanged: (newValue) async {
                setState(() {
                  switchProvider.isFeatureEnabled1 = newValue;
                  switchProvider.isFeatureEnabled = false;
                  switchProvider.isFeatureEnabled2 = false;
                });
                if (newValue) {
                  await _updateResponse(context, switchProvider, 1);
                }
              },
            ),
            const SizedBox(width: 30),
            CustomSwitch(
              topText: 'Rele 3',
              bottomText: switchProvider.isFeatureEnabled2 ? switchProvider.response3 : '',
              value: switchProvider.isFeatureEnabled2,
              onChanged: (newValue) async {
                setState(() {
                  switchProvider.isFeatureEnabled2 = newValue;
                  switchProvider.isFeatureEnabled = false;
                  switchProvider.isFeatureEnabled1 = false;
                });
                if (newValue) {
                  await _updateResponse(context, switchProvider, 2);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateResponse(BuildContext context, SwitchProvider switchProvider, int switchIndex) async {
    final bleprovider = Provider.of<BleProvider>(context, listen: false);
    final uuidWrite = switchProvider.uuidWrite;

    List<int> data = [100];
    if (switchIndex == 0) {
      data.add(2);
    } else if (switchIndex == 1) {
      data.add(15);
    } else if (switchIndex == 2) {
      data.add(18);
    }

    if (bleprovider.selectedDevice != null) {
      await bleprovider.writeCharacteristic(uuidWrite, data);
      await bleprovider.readCharacteristic(uuidWrite);
      final response = bleprovider.readResponse;
      switch (switchIndex) {
        case 0:
          switchProvider.response = response;
          break;
        case 1:
          switchProvider.response2 = response;
          break;
        case 2:
          switchProvider.response3 = response;
          break;
        default:
          break;
      }
    }
  }
}
