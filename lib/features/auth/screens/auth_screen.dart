import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../state/auth_state.dart';
import '../../../shared/theme/theme_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login == 'admin' && password == '12345') {
      AuthState.login(login);
      context.pushReplacement('/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Неверный логин или пароль'),
          backgroundColor: ThemeState.of(context).currentTheme.colorScheme.error,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _checkAuthStatus() {
    if (AuthState.isAuthenticated) {
      print('Пользователь уже авторизован: ${AuthState.currentUser}');
    } else {
      print('Пользователь не авторизован');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              themeState.currentTheme.colorScheme.primaryContainer,
              themeState.currentTheme.colorScheme.primary,
            ],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.movie_rounded,
                    size: 80,
                    color: themeState.currentTheme.colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Фильмотека',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: themeState.currentTheme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Войдите в свой аккаунт',
                    style: TextStyle(
                      fontSize: 16,
                      color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 30),

                  TextField(
                    controller: _loginController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Логин',
                      prefixIcon: Icon(Icons.person, color: themeState.currentTheme.colorScheme.primary),
                      hintText: 'Введите admin',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Пароль',
                      prefixIcon: Icon(Icons.lock, color: themeState.currentTheme.colorScheme.primary),
                      hintText: 'Введите 12345',
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Для теста: admin / 12345',
                    style: TextStyle(
                      fontSize: 12,
                      color: themeState.currentTheme.colorScheme.onSurface.withOpacity(0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeState.currentTheme.colorScheme.primary,
                        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
                      ),
                      child: const Text(
                        'Войти',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}