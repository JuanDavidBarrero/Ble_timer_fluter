import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final String topText;
  final String bottomText;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const CustomSwitch({
    super.key,
    required this.topText,
    required this.bottomText,
    required this.value,
    this.onChanged,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.topText,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        Transform.scale(
          scale: 1.5,
          child: Switch(
            value: widget.value,
            onChanged: widget.onChanged,
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue.withOpacity(0.5),
          ),
        ),
        Text(
          widget.bottomText,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
