import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:labs/router/router.gr.dart';

class AppNavigationWrapper extends StatelessWidget {
  const AppNavigationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      homeIndex: 0,
      routes: [
        const AutoassociativeRouter(),
        HomeRouter(),

      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: (index) => tabsRouter.setActiveIndex(index),
            items: const [
              BottomNavigationBarItem(
                label: "Autoassociative",
                icon: Icon(Icons.smart_toy_outlined),
              ),
              BottomNavigationBarItem(
                label: "Base neural",
                icon: Icon(Icons.smart_toy),
              ),

            ]);
      },
    );
  }
}
