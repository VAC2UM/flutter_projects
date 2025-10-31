import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddActorScreen extends StatefulWidget {
  const AddActorScreen({super.key});

  @override
  State<AddActorScreen> createState() => _AddActorScreenState();
}

class _AddActorScreenState extends State<AddActorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveActor() {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      context.pop({
        'name': name,
        'imageUrl': _imageUrlController.text.trim(),
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите имя актера'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавить актера'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Имя актера *',
                  prefixIcon: Icon(Icons.person),
                  hintText: 'Введите полное имя актера',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'URL фото (опционально)',
                  prefixIcon: Icon(Icons.image),
                  hintText: 'https://example.com/photo.jpg',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveActor,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Сохранить актера'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}