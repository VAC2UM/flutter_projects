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
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                'ФИО: Голованев Никита Алексеевич',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Группа: ИКБО-11-22',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              const SizedBox(height: 10),
              const Text(
                'Студенческий билет: 22И0575',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
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
          ),
        ),
      ),
    );
  }
}
