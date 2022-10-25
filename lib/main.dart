import 'package:flutter/material.dart';
import 'package:labs/di/injector.dart';

import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const App());
}
