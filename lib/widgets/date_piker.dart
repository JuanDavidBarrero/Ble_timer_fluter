import 'package:flutter/material.dart';

class DatePicker extends StatelessWidget {
  final DateTime selectedTime;
  final String text;
  final Function() onPressed;
  final Function() onPressedDate;

  const DatePicker({
    super.key,
    required this.selectedTime,
    required this.onPressed,
    required this.onPressedDate,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text.toUpperCase(), style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),),
        
        Text(
          '${selectedTime.year}/${selectedTime.month}/${selectedTime.day} ${selectedTime.hour < 10 ? '0${selectedTime.hour}' : selectedTime.hour}:${selectedTime.minute < 10 ? '0${selectedTime.minute}' : selectedTime.minute}',
          style: const TextStyle(fontSize: 16),
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
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onPressedDate,
          icon: const Icon(
            Icons.date_range_outlined,
            color: Colors.blue,
          ),
          label: const Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'Pick date',
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
