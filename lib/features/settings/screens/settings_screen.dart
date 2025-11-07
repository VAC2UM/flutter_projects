import 'package:flutter/material.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: themeState.currentTheme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.settings,
                size: 60,
                color: themeState.currentTheme.colorScheme.onPrimaryContainer,
              ),
            ),

            Card(
              elevation: 2,
              child: SwitchListTile(
                title: const Text(
                  'Тёмная тема',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  themeState.isDarkMode ? 'Тёмная тема активна' : 'Светлая тема активна',
                  style: TextStyle(
                    color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                value: themeState.isDarkMode,
                onChanged: (value) {
                  themeState.toggleTheme();
                },
                secondary: Icon(
                  themeState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: themeState.currentTheme.colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              elevation: 2,
              child: SwitchListTile(
                title: const Text(
                  'Уведомления',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  _notifications ? 'Уведомления включены' : 'Уведомления выключены',
                  style: TextStyle(
                    color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                value: _notifications,
                onChanged: (value) {
                  setState(() {
                    _notifications = value;
                  });
                },
                secondary: Icon(
                  _notifications ? Icons.notifications_active : Icons.notifications_off,
                  color: themeState.currentTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}