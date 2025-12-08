import 'package:flutter/material.dart';
import 'app.dart';
import 'shared/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}
