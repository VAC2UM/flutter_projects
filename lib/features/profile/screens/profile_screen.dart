import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/profile/models/user.dart';
import 'package:flutter_projects/shared/data/data_source.dart';
import 'package:flutter_projects/shared/di/service_locator.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    if (locator.isRegistered<AppData>()) {
      final appData = locator<AppData>();
      setState(() {
        _currentUser = appData.currentUser;
      });
    }
  }

  void _editProfile() {
    context.push('/profile/edit');
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
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildProfileHeader(themeState),
            const SizedBox(height: 32),

            _buildActionButtons(themeState),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeState themeState) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: themeState.currentTheme.colorScheme.primaryContainer,
          backgroundImage: _currentUser!.avatarUrl != null
              ? NetworkImage(_currentUser!.avatarUrl!)
              : null,
          child: _currentUser!.avatarUrl == null
              ? Icon(
            Icons.person,
            size: 50,
            color: themeState.currentTheme.colorScheme.onPrimaryContainer,
          )
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          _currentUser!.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _currentUser!.email,
          style: TextStyle(
            fontSize: 16,
            color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _editProfile,
          child: const Text('Редактировать профиль'),
        ),
      ],
    );
  }

  Widget _buildStatItem(ThemeState themeState, String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeState.currentTheme.colorScheme.onSurface,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeState themeState) {
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
}