import 'package:flutter/material.dart';

class TimeSavedDisplay extends StatelessWidget {
  final double hours;

  TimeSavedDisplay({required this.hours});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${hours.toStringAsFixed(1)} hours",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          "Time saved",
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
