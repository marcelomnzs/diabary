import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/core/theme/text_theme.dart';
import 'package:diabary/core/theme/theme.dart';
import 'package:diabary/core/theme/theme_provider.dart';
import 'package:diabary/data/auth_service.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:diabary/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AuthService _authService;
  late final AuthProvider _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _authProvider = AuthProvider(_authService);
    _router = createRouter(_authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: _authService),
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          final textTheme = createTextTheme(context, 'Inter', 'Inter');
          final materialTheme = MaterialTheme(textTheme);

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: _router,
            theme: materialTheme.light(),
            darkTheme: materialTheme.dark(),
            themeMode: themeProvider.themeMode,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pt', 'BR')],
          );
        },
      ),
    );
  }
}
