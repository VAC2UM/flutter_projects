import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_projects/features/profile/models/user.dart';
import 'package:flutter_projects/features/profile/state/profile_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  void _editProfile(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    context.push(
      '/profile/edit',
      extra: profileCubit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<ProfileCubit>().loadUserData(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final user = state.user;
          if (user == null) {
            return const Center(child: Text('Пользователь не найден'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildProfileHeader(context, themeState, user),
                const SizedBox(height: 32),
                _buildActionButtons(context, themeState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ThemeState themeState, User user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: themeState.currentTheme.colorScheme.primaryContainer,
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
          child: user.avatarUrl == null
              ? Icon(
            Icons.person,
            size: 50,
            color: themeState.currentTheme.colorScheme.onPrimaryContainer,
          )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          user.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user.email,
          style: TextStyle(
            fontSize: 16,
            color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Участник с ${_formatDate(user.joinDate)}',
          style: TextStyle(
            fontSize: 14,
            color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => _editProfile(context),
          child: const Text('Редактировать профиль'),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeState themeState) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.settings, color: themeState.currentTheme.colorScheme.primary),
          title: const Text('Настройки'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/settings'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}