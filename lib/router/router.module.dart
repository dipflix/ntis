import 'package:injectable/injectable.dart';


import 'router.gr.dart';

@module
abstract class NavigationModule {
  @lazySingleton
  AppRouter get router => AppRouter();
}