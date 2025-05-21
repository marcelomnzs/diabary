import 'package:flutter/material.dart';
import 'package:diabary/login/login.view.dart';
import 'package:diabary/cadastro/cadastro.view.dart';
import 'package:diabary/home/home.view.dart';
import 'package:diabary/lembrete_medicamentos/medicamentos.view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/medicamentos',
      routes: {
        '/login': (context) => LoginView(),
        '/cadastro': (context) => CadastroView(),
        '/home': (context) => HomeView(),
        '/medicamentos': (context) => MedicamentosView(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
    );
  }
}
