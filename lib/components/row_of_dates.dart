import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ble_app_timer/provider/dates_provider.dart';
import 'package:ble_app_timer/widgets/date_piker.dart';

class RowOfDates extends StatelessWidget {
  const RowOfDates({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatesProvider>(
      builder: (context, dateProvider, _) {
        DateTime toDate = dateProvider.toDate;
        DateTime fromDate = dateProvider.fromDate;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DatePicker(
              selectedTime: fromDate,
              text: 'from',
              onPressedDate: () async {
                final newDate = await _showDatePicker(context, fromDate);
                if (newDate != null) {
                  dateProvider.fromDate = DateTime(
                    newDate.year,
                    newDate.month,
                    newDate.day,
                    fromDate.hour,
                    fromDate.minute,
                    fromDate.second,
                  );

                  dateProvider.toDate = dateProvider.fromDate.add(const Duration(minutes: 1));
                }
              },
              onPressed: () async {
                await _showTimePicker(context, (newTime) {
                  dateProvider.fromDate = DateTime(
                    fromDate.year,
                    fromDate.month,
                    fromDate.day,
                    newTime.hour,
                    newTime.minute,
                    fromDate.second,
                  );
                  dateProvider.toDate = dateProvider.fromDate.add(const Duration(minutes: 1));
                });
              },
            ),
            const SizedBox(width: 20),
            DatePicker(
              selectedTime: toDate,
              text: 'to',
              onPressedDate: () async {
                final newDate = await _showDatePicker(context, toDate);
                if (newDate != null) {
                  dateProvider.toDate = DateTime(
                    newDate.year,
                    newDate.month,
                    newDate.day,
                    toDate.hour,
                    toDate.minute,
                    toDate.second,
                  );
                }
              },
              onPressed: () async {
                await _showTimePicker(context, (newTime) {
                  dateProvider.toDate = DateTime(
                    toDate.year,
                    toDate.month,
                    toDate.day,
                    newTime.hour,
                    newTime.minute,
                    toDate.second,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<DateTime?> _showDatePicker(
      BuildContext context, DateTime initialDate) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
  }

  Future<void> _showTimePicker(BuildContext context, void Function(TimeOfDay) onTimePicked) async {
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
}
