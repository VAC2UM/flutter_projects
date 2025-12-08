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
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 8),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: value.toString(),
          activeColor: Colors.deepPurple,
          inactiveColor: Colors.deepPurple[100],
          onChanged: (double newValue) {
            onChanged(newValue.round());
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('1', style: TextStyle(color: Colors.grey[600])),
            Text('10', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ],
    );
  }
}
