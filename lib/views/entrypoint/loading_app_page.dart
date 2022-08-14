import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/wp_config.dart';
import '../../core/app/core_provider.dart';
import '../auth/login_intro_page.dart';
import '../onboarding/onboarding_page.dart';
import 'components/loading_dependency.dart';
import 'entrypoint.dart';

class LoadingAppPage extends ConsumerWidget {
  const LoadingAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(coreAppStateProvider(context));
    return appState.map(
        data: (initialState) {
          switch (initialState.value) {
            case AppState.introNotDone:
              return const OnboardingPage();
            case AppState.loggedIn:
              return const EntryPointUI();
            case AppState.loggedOut:
              return WPConfig.forceUserToLoginEverytime
                  ? const LoginIntroPage()
                  : const EntryPointUI();
            default:
              return const EntryPointUI();
          }
        },
        error: (t) => const Text('Unknown Error'),
        loading: (t) => const LoadingDependencies());
  }
}
