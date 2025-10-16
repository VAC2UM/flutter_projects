import 'package:flutter/material.dart';

class RatingSlider extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const RatingSlider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Рейтинг: $value/10',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: value.toString(),
          onChanged: (double newValue) {
            onChanged(newValue.round());
          },
        ),
      ],
    );
  }
}
