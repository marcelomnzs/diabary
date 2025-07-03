import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/core/theme/text_theme.dart';
import 'package:diabary/core/theme/theme.dart';
import 'package:diabary/core/theme/theme_provider.dart';
import 'package:diabary/data/auth_service.dart';
import 'package:diabary/data/notifications_service.dart';
import 'package:diabary/domain/repositories/user_repository.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:diabary/features/auth/presentation/providers/user_data_provider.dart';
import 'package:diabary/features/medications/presentation/providers/calendar_provider.dart';
import 'package:diabary/features/medications/presentation/providers/medications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/notifications_provider.dart';
import 'package:diabary/features/medications/presentation/providers/week_days_provider.dart';
import 'package:diabary/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('pt_BR', null);

  final authService = AuthService();
  final userRepository = UserRepository();
  final notificationsService = NotificationsService();
  await notificationsService.initNotification();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<UserRepository>.value(value: userRepository),
        Provider<NotificationsService>.value(value: notificationsService),

        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService, userRepository),
        ),
        ChangeNotifierProvider<NotificationsProvider>(
          create:
              (_) =>
                  NotificationsProvider(notificationsService)
                    ..loadNotifications(),
        ),
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<AuthProvider, MedicationsProvider>(
          create: (_) => MedicationsProvider(),
          update: (_, authProvider, medicationsProvider) {
            medicationsProvider ??= MedicationsProvider();
            medicationsProvider.setUserId(authProvider.user?.uid);
            return medicationsProvider;
          },
        ),
        ChangeNotifierProvider<UserDataProvider>(
          create: (_) => UserDataProvider(userRepository),
        ),
        ChangeNotifierProvider<CalendarProvider>(
          create: (_) => CalendarProvider(),
        ),
        ChangeNotifierProvider(create: (_) => WeekDaysProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(context.read<AuthProvider>());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
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
    );
  }
}
