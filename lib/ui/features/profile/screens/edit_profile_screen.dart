import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/profile_cubit.dart';
import 'package:flutter_projects/domain/models/user.dart';
import '../delegates/profile_state.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditProfileView();
  }
}

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
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
    _avatarController = TextEditingController(
      text: widget.user.avatarUrl ?? '',
    );
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
    final themeState = ThemeState.of(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Имя',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.person,
                color: themeState.currentTheme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.email,
                color: themeState.currentTheme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _avatarController,
            decoration: InputDecoration(
              labelText: 'URL аватара (опционально)',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(
                Icons.link,
                color: themeState.currentTheme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _saveProfile(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: themeState.currentTheme.colorScheme.primary,
              foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('Сохранить изменения'),
          ),
        ],
      ),
    );
  }
}
