import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_projects/features/settings/cubit/settings_cubit.dart';
import 'package:flutter_projects/features/settings/state/settings_state.dart';
import 'package:flutter_projects/shared/theme/theme_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit(),
      child: const SettingsView(),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'reset') {
                context.read<SettingsCubit>().resetToDefaults();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.restore, size: 20),
                    SizedBox(width: 8),
                    Text('Сбросить настройки'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listener: (context, state) {
          // Синхронизируем тему приложения с состоянием Cubit
          if (state.isDarkMode != themeState.isDarkMode) {
            themeState.toggleTheme();
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: themeState.currentTheme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeState.currentTheme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<SettingsCubit>().clearError(),
                    child: const Text('ОК'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(themeState),
                const SizedBox(height: 32),
                _buildThemeSection(context, themeState, state),
                const SizedBox(height: 16),
                _buildNotificationsSection(context, themeState, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(ThemeState themeState) {
    return Container(
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
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeState themeState, SettingsState state) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text(
              'Тёмная тема',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              state.isDarkMode ? 'Тёмная тема активна' : 'Светлая тема активна',
              style: TextStyle(
                color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            value: state.isDarkMode,
            onChanged: (value) {
              context.read<SettingsCubit>().setDarkMode(value);
            },
            secondary: Icon(
              state.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: themeState.currentTheme.colorScheme.primary,
            ),
          ),
          if (state.isDarkMode != themeState.isDarkMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Изменение вступит в силу после перезагрузки',
                style: TextStyle(
                  fontSize: 12,
                  color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(BuildContext context, ThemeState themeState, SettingsState state) {
    return Card(
      elevation: 2,
      child: SwitchListTile(
        title: const Text(
          'Уведомления',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          state.notificationsEnabled ? 'Уведомления включены' : 'Уведомления выключены',
          style: TextStyle(
            color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        value: state.notificationsEnabled,
        onChanged: (value) {
          context.read<SettingsCubit>().setNotifications(value);
        },
        secondary: Icon(
          state.notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
          color: themeState.currentTheme.colorScheme.primary,
        ),
      ),
    );
  }
}