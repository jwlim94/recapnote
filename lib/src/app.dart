import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recapnote/src/routing/providers/go_router_state_provider.dart';
import 'package:recapnote/src/shared/constants/app_colors.dart';
import 'package:recapnote/src/shared/constants/strings.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouterState = ref.watch(goRouterStateProvider);

    return MaterialApp.router(
      routerConfig: goRouterState,
      theme: ThemeData(
        fontFamily: Strings.roboto,
        scaffoldBackgroundColor: AppColors.appBlack,
      ),
    );
  }
}
