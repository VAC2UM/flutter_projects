import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _ageController = TextEditingController();
  String _message = "Введите ваш возраст и нажмите кнопку";

  void _showAge() {
    setState(() {
      final input = _ageController.text;
      if (input.isEmpty) {
        _message = "Вы не ввели возраст!";
      } else {
        final age = int.tryParse(input);
        if (age == null || age < 0) {
          _message = "Введите корректное число!";
        } else {
          _message = "Ваш возраст: $age лет";
        }
      }
    });
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileItems = const [
      'ФИО: Голованев Никита Алексеевич',
      'Группа: ИКБО-11-22',
      'Студенческий билет: 22И0575',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20.0),
        itemCount: profileItems.length + 1,
        separatorBuilder: (context, index) {
          if (index < profileItems.length - 1) {
            return const Divider(height: 24, thickness: 1);
          }
          return const Divider(height: 32);
        },
        itemBuilder: (context, index) {
          if (index < profileItems.length) {
            final text = profileItems[index];
            final style = index == 0
                ? const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)
                : index == 1
                ? const TextStyle(fontSize: 18, color: Colors.blue)
                : const TextStyle(fontSize: 18);
            return Text(text, style: style);
          } else {
            return Column(
              children: [
                const SizedBox(height: 20),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Введите ваш возраст',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showAge,
                  child: const Text('Показать возраст'),
                ),
                const SizedBox(height: 20),
                Text(
                  _message,
                  style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}