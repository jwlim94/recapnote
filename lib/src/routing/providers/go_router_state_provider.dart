import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recapnote/src/features/authentication/data/auth_repository.dart';
import 'package:recapnote/src/features/note/presentation/note_screen.dart';
import 'package:recapnote/src/features/user/presentation/profile_screen.dart';
import 'package:recapnote/src/routing/app_startup.dart';
import 'package:recapnote/src/routing/providers/app_startup_state_provider.dart';
import 'package:recapnote/src/routing/utils/extra_codec.dart';
import 'package:recapnote/src/routing/utils/go_router_refresh_stream.dart';
import 'package:recapnote/src/routing/utils/scaffold_with_nested_navigation.dart';
import 'package:recapnote/src/shared/constants/enums.dart';
import 'package:recapnote/src/shared/constants/keys.dart';
import 'package:recapnote/src/shared/constants/strings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_state_provider.g.dart';

@riverpod
GoRouter goRouterState(Ref ref) {
  final appStartupState = ref.watch(appStartupStateProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: Strings.notePath,
    extraCodec: const ExtraCodec(),
    debugLogDiagnostics: true,
    navigatorKey: Keys.rootNavigatorKey,
    redirect: (context, state) {
      // Show splash screen while the app is initializing
      if (appStartupState.isLoading || appStartupState.hasError) {
        return Strings.startupPath;
      }

      // Add silently signin and signout redirects here...

      return null;
    },
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: Strings.startupPath,
        name: AppRoute.startup.name,
        pageBuilder:
            (context, state) => const NoTransitionPage(child: AppStartup()),
      ),
      // Add more routes here...
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: Keys.rootNavigatorKey,
        pageBuilder:
            (context, state, navigationShell) => NoTransitionPage(
              child: ScaffoldWithNestedNavigation(
                navigationShell: navigationShell,
              ),
            ),
        branches: [
          StatefulShellBranch(
            navigatorKey: Keys.homeNavigatorKey,
            routes: [
              GoRoute(
                path: Strings.notePath,
                name: AppRoute.note.name,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: NoteScreen());
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: Keys.profileNavigatorKey,
            routes: [
              GoRoute(
                path: Strings.profilePath,
                name: AppRoute.profile.name,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: ProfileScreen());
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
