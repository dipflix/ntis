import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:labs/app_navigation.wrapper.dart';
import 'package:labs/screens/home/home.screen.dart';

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
      ],
    ),
  ],
)
class $AppRouter {}
