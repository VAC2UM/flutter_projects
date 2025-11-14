import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_projects/features/profile/models/user.dart';
import 'package:flutter_projects/features/profile/state/profile_state.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return const Center(child: Text('Пользователь не найден'));
          }

          return _EditProfileForm(user: user);
        },
      ),
    );
  }
}

class _EditProfileForm extends StatefulWidget {
  final User user;

  const _EditProfileForm({required this.user});

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _avatarController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _avatarController = TextEditingController(text: widget.user.avatarUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _saveProfile(BuildContext context) {
    context.read<ProfileCubit>().updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      avatarUrl: _avatarController.text.isEmpty ? null : _avatarController.text,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Имя',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _avatarController,
            decoration: const InputDecoration(
              labelText: 'URL аватара (опционально)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _saveProfile(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Сохранить изменения'),
          ),
        ],
      ),
    );
  }
}