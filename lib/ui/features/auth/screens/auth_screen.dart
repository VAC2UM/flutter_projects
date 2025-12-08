// features/auth/screens/auth_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/auth_cubit.dart';
import '../delegates/auth_state.dart';
import 'package:flutter_projects/ui/shared/theme_state.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated) {
          context.pushReplacement('/main');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurple[400]!, Colors.deepPurple[800]!],
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
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Фильмотека',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Войдите в свой аккаунт',
                      style: TextStyle(
                        fontSize: 16,
                        color: themeState.currentTheme.colorScheme.onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 30),

                    TextField(
                      controller: _loginController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Логин',
                        prefixIcon: Icon(
                          Icons.person,
                          color: themeState.currentTheme.colorScheme.primary,
                        ),
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
                        prefixIcon: Icon(
                          Icons.lock,
                          color: themeState.currentTheme.colorScheme.primary,
                        ),
                        hintText: 'Введите 12345',
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      'Для теста: admin / 12345',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeState.currentTheme.colorScheme.onSurface
                            .withOpacity(0.5),
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 20),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const CircularProgressIndicator();
                        }

                        if (state.error != null) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.error, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        state.error!,
                                        style: TextStyle(
                                          color: Colors.red[700],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close, size: 16),
                                      onPressed: () => context
                                          .read<AuthCubit>()
                                          .clearError(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                    // Кнопка входа
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () {
                                    final login = _loginController.text.trim();
                                    final password = _passwordController.text
                                        .trim();
                                    context.read<AuthCubit>().login(
                                      login,
                                      password,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  themeState.currentTheme.colorScheme.primary,
                              foregroundColor:
                                  themeState.currentTheme.colorScheme.onPrimary,
                            ),
                            child: const Text(
                              'Войти',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
