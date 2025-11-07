import 'package:flutter/material.dart';
import 'app.dart';
import 'shared/di/service_locator.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}