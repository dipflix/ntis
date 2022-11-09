import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:labs/app_navigation.wrapper.dart';

import '../screens/screens.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    AutoRoute(
      path: '/',
      page: AppNavigationWrapper,
      children: [
        AutoRoute(
          name: "HomeRouter",
          path: '',
          page: HomeScreen,
        ),
        AutoRoute(
          name: "AutoassociativeRouter",
          path: '',
          initial: true,
          page: AutoassociativeScreen,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
