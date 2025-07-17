import 'package:diabary/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OnboardingStep1 extends StatefulWidget {
  const OnboardingStep1({super.key});

  @override
  State<OnboardingStep1> createState() => _OnboardingStep1State();
}

class _OnboardingStep1State extends State<OnboardingStep1> {
  final _weightCtrl = TextEditingController();

  @override
  void dispose() {
    _weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboarding = context.watch<OnboardingProvider>();

    if (onboarding.weight != null && _weightCtrl.text.isEmpty) {
      _weightCtrl.text = onboarding.weight.toString();
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/step1.svg', height: 240),
              const SizedBox(height: 30),
              Text(
                'Insira as informações nos campos abaixo:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text:
                      onboarding.birthDate != null
                          ? '${onboarding.birthDate!.day.toString().padLeft(2, '0')}/${onboarding.birthDate!.month.toString().padLeft(2, '0')}/${onboarding.birthDate!.year}'
                          : '',
                ),
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: onboarding.birthDate ?? DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    context.read<OnboardingProvider>().setBirthDate(date);
                  }
                },
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<String>(
                value: onboarding.gender,
                items:
                    ['Masculino', 'Feminino', 'Outro']
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                onChanged: (v) {
                  if (v != null) {
                    context.read<OnboardingProvider>().setGender(v);
                  }
                },
                decoration: const InputDecoration(labelText: 'Gênero'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _weightCtrl,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final parsed = double.tryParse(value);
                  if (parsed != null) {
                    context.read<OnboardingProvider>().setWeight(parsed);
                  }
                },
              ),
              const SizedBox(height: 20),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final onboarding =
                                      context.read<OnboardingProvider>();
                                  if (onboarding.birthDate != null &&
                                      onboarding.gender != null &&
                                      onboarding.weight != null &&
                                      onboarding.weight! > 0) {
                                    onboarding.nextStep();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Preencha todos os campos corretamente.',
                                        ),
                                      ),
                                    );
                                  }
                                },
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
                                  'Próximo',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
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
                        backgroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
