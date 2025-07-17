import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/notifications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/week_days_provider.dart';
import 'package:diabary/features/medications/presentation/widgets/medications_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:diabary/features/onboarding/presentation/providers/onboarding_provider.dart';

class OnboardingStep3 extends StatefulWidget {
  const OnboardingStep3({super.key});

  @override
  State<OnboardingStep3> createState() => _OnboardingStep3State();
}

class _OnboardingStep3State extends State<OnboardingStep3> {
  bool _takesMedication = false;
  bool _optionTaken = false;
  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/svg/step3.svg', height: 240),
            const Text(
              'Você faz uso de medicação? Se sim, qual?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ChoiceChip(
              avatar: Icon(Icons.check),
              label: Text('Sim'),
              selected: _optionTaken && _takesMedication,
              onSelected: (selected) async {
                setState(() {
                  _takesMedication = true;
                  _optionTaken = true;
                });

                final result = await showModalBottomSheet<bool>(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  builder:
                      (_) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: MultiProvider(
                          providers: [
                            ChangeNotifierProvider.value(
                              value: context.read<MedicationsProvider>(),
                            ),
                            ChangeNotifierProvider.value(
                              value: context.read<WeekDaysProvider>(),
                            ),
                            ChangeNotifierProvider.value(
                              value: context.read<NotificationsProvider>(),
                            ),
                          ],
                          child: const MedicationsForm(),
                        ),
                      ),
                );

                if (result == true && mounted) {
                  context.read<OnboardingProvider>().nextStep();
                }
              },
            ),
            SizedBox(height: 5),
            ChoiceChip(
              avatar: Icon(Icons.close),
              label: Text('Não'),
              selected: _optionTaken && !_takesMedication,
              onSelected: (selected) {
                setState(() {
                  _takesMedication = false;
                  _optionTaken = true;
                });
              },
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: onboarding.previousStep,
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Anterior',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed:
                                      _optionTaken
                                          ? () => onboarding.nextStep()
                                          : null,
                                  style: ButtonStyle(
                                    elevation: WidgetStateProperty.all(0),
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          states,
                                        ) {
                                          return Colors.transparent;
                                        }),
                                    shadowColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          states,
                                        ) {
                                          return Colors.transparent;
                                        }),
                                    foregroundColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          states,
                                        ) {
                                          return Theme.of(
                                            context,
                                          ).colorScheme.primary;
                                        }),
                                    padding: WidgetStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Próximo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${onboarding.step}/4',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    LinearProgressIndicator(
                      value: onboarding.step / 4,
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
