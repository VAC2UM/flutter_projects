import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _favoriteActors = [];

  void _addActor() {
    final actor = _controller.text.trim();
    if (actor.isNotEmpty) {
      setState(() {
        _favoriteActors.add(actor);
      });
      _controller.clear();
    }
  }

  void _removeActor(int index) {
    setState(() {
      _favoriteActors.removeAt(index);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Любимые актёры')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите имя актёра',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addActor,
              child: const Text('Добавить актёра'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _favoriteActors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final actor = entry.value;
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              actor,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeActor(index),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
