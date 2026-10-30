import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'pages/onboarding/onboarding_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ButterAndCrumbApp());
}

class ButterAndCrumbApp extends StatelessWidget {
  const ButterAndCrumbApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butter & Crumb',

      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,

      home: const OnboardingPage(),
    );
  }
}
