import 'package:flutter/material.dart';

class TimeSavedDisplay extends StatelessWidget {
  final double hours;

  TimeSavedDisplay({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${hours.toStringAsFixed(2)} hours",
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Time saved",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
