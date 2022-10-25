import 'package:flutter/material.dart';

import 'di/injector.dart';
import 'router/router.gr.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: router.delegate(),
      routeInformationParser: router.defaultRouteParser(),
    );
  }
}
