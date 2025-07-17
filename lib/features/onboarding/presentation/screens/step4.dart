import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/domain/models/user_model.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:diabary/features/auth/presentation/providers/user_data_provider.dart';
import 'package:diabary/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingStep4 extends StatefulWidget {
  const OnboardingStep4({super.key});

  @override
  State<OnboardingStep4> createState() => _OnboardingStep4State();
}

class _OnboardingStep4State extends State<OnboardingStep4> {
  final _controller = TextEditingController();
  bool _hasCondition = false;
  bool _optionSelected = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (!_optionSelected) return false;
    if (_hasCondition && _controller.text.trim().isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Você possui alguma outra condição médica?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [
                ChoiceChip(
                  avatar: const Icon(Icons.check),
                  label: const Text('Sim'),
                  selected: _optionSelected && _hasCondition,
                  onSelected: (_) {
                    setState(() {
                      _optionSelected = true;
                      _hasCondition = true;
                    });
                  },
                ),
                ChoiceChip(
                  avatar: const Icon(Icons.close),
                  label: const Text('Não'),
                  selected: _optionSelected && !_hasCondition,
                  onSelected: (_) {
                    setState(() {
                      _optionSelected = true;
                      _hasCondition = false;
                      _controller.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // TextField aparece apenas se SIM for selecionado
            if (_hasCondition)
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Descreva sua condição médica',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                onChanged: (_) => setState(() {}),
              ),

            const SizedBox(height: 32),

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
                                  onPressed:
                                      context
                                          .read<OnboardingProvider>()
                                          .previousStep,
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
                                      _canSubmit
                                          ? () async {
                                            final onboarding =
                                                context
                                                    .read<OnboardingProvider>();
                                            final authProvider =
                                                context.read<AuthProvider>();
                                            final userDataProvider =
                                                context
                                                    .read<UserDataProvider>();

                                            onboarding.setOtherConditions(
                                              _hasCondition
                                                  ? _controller.text.trim()
                                                  : '',
                                            );

                                            final user = authProvider.user;
                                            final userId = user?.uid;
                                            final email = user?.email;

                                            if (userId == null ||
                                                email == null) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Erro: usuário não autenticado.',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            final userModel = UserModel(
                                              id: userId,
                                              email: email,
                                              name: user!.displayName,
                                              onboardingCompleted: true,
                                              birthDate: onboarding.birthDate,
                                              gender: onboarding.gender,
                                              weight: onboarding.weight,
                                              diabetesType:
                                                  onboarding.diabetesType,
                                              diabetesDuration:
                                                  onboarding.diabetesDuration,
                                              otherConditions:
                                                  onboarding.otherConditions,
                                              usesMedication:
                                                  onboarding.usesMedication,
                                            );

                                            try {
                                              await userDataProvider
                                                  .saveUserData(userModel);
                                              authProvider
                                                  .setOnboardingCompleted(true);
                                              onboarding.reset();
                                              appRouter.goNamed(
                                                AppRoutes.home.name,
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Erro ao salvar dados: $e',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
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
                                    'Finalizar',
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
