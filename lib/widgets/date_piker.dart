import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final TimeOfDay selectedTime;
  final String text;
  final Function() onPressed;

  const DatePicker({
    super.key,
    required this.selectedTime,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text),
        Text(
          '${selectedTime.hour < 10 ? '0${selectedTime.hour}' : selectedTime.hour}:${selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute}',
          style: const TextStyle(fontSize: 20),
        ),
        ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(
            Icons.access_time,
            color: Colors.blue,
          ),
          label: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Pick Time',
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          ),
        ),
      ],
    );
  }
}
