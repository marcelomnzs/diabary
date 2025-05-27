import 'package:diabary/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:diabary/features/auth/presentation/screens/register_screen.dart';
import 'package:diabary/features/home/presentation/screens/home_screen.dart';
import 'package:diabary/features/medications/presentation/screens/medications_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:diabary/features/chatbot/presentation/screens/chatbot_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/chatbot',
      routes: {
        '/login': (context) => LoginScreen(),
        '/cadastro': (context) => RegisterScreen(),
        '/home': (context) => HomeView(),
        '/medicamentos': (context) => MedicationsScreen(),
        '/chatbot': (context) => ChatbotScreen(),
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
