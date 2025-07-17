import 'package:diabary/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:diabary/features/onboarding/presentation/screens/onboarding_home.dart';
import 'package:diabary/features/onboarding/presentation/screens/step1.dart';
import 'package:diabary/features/onboarding/presentation/screens/step2.dart';
import 'package:diabary/features/onboarding/presentation/screens/step3.dart';
import 'package:diabary/features/onboarding/presentation/screens/step4.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    switch (onboarding.step) {
      case 1:
        return OnboardingStep1();
      case 2:
        return OnboardingStep2();
      case 3:
        return OnboardingStep3();
      case 4:
        return OnboardingStep4();
      default:
        return OnboardingHome();
    }
  }
}
