import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:labs/router/router.gr.dart';

class AppNavigationWrapper extends StatelessWidget {
  const AppNavigationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      homeIndex: 0,
      routes: [
        HomeRouter(),
      ],
    );
  }
}
