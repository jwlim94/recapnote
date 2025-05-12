import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recapnote/src/shared/constants/app_colors.dart';
import 'package:recapnote/src/shared/constants/strings.dart';
import 'package:recapnote/src/shared/constants/text_styles.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.appBlack, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.history_rounded),
                label: Strings.history,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.note_add_outlined),
                label: Strings.note,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_2_outlined),
                label: Strings.profile,
              ),
            ],
            currentIndex: navigationShell.currentIndex,
            enableFeedback: false,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyles.bodyExtraSmall,
            unselectedLabelStyle: TextStyles.bodyExtraSmall,
            selectedItemColor: AppColors.appBlue,
            unselectedItemColor: AppColors.appBlack,
            backgroundColor: AppColors.appWhite,
            onTap: _goBranch,
          ),
        ),
      ),
    );
  }
}
