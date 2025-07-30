import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:diabary/features/auth/presentation/providers/user_data_provider.dart';
import 'package:diabary/features/medications/presentation/providers/notifications_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final userProvider = context.read<UserDataProvider>();

      final user = authProvider.user;

      if (user != null) {
        userProvider.loadUserData(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = context.watch<UserDataProvider>();
    final notificationProvider = context.watch<NotificationsProvider>();
    final user = userDataProvider.userData;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                        child: Text(
                          'Olá, ${user?.name ?? 'Usuário'}',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          top: 8.0,
                        ), // Espaçamento consistente
                        child: Text(
                          'Como você se sente hoje?',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary,
                            ),

                            child: IconButton(
                              onPressed: () {
                                // Ação ao pressionar o botão
                              },
                              icon: Icon(
                                Icons.notifications,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              iconSize: 20.0,
                            ),
                          ),

                          SizedBox(width: 5),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary,
                            ),

                            child: IconButton(
                              onPressed:
                                  () => context.pushNamed(
                                    AppRoutes.settings.name,
                                  ),
                              icon: Icon(
                                Icons.settings,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                              iconSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 30),

              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Centraliza os botões
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 81,
                            width: 83,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.surfaceTint,
                            ),
                            child: IconButton(
                              onPressed:
                                  () => context.pushNamed(
                                    AppRoutes.mealTracker.name,
                                  ),
                              icon: Icon(
                                Icons.food_bank,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              iconSize: 20.0,
                            ),
                          ),
                          Text(
                            'Monte seu prato',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 10),

                      Column(
                        children: [
                          Container(
                            height: 81,
                            width: 83,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.surfaceTint,
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.food_bank,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              iconSize: 20.0,
                            ),
                          ),
                          Text(
                            'Minhas métricas',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 10),

                      Column(
                        children: [
                          Container(
                            height: 81,
                            width: 83,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.surfaceTint,
                            ),
                            child: IconButton(
                              onPressed:
                                  () => context.pushNamed(
                                    AppRoutes.medications.name,
                                  ),
                              icon: Icon(
                                Icons.food_bank,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              iconSize: 20.0,
                            ),
                          ),
                          Text(
                            'Medicamentos',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 10),

                      Column(
                        children: [
                          Container(
                            height: 81,
                            width: 83,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.surfaceTint,
                            ),
                            child: IconButton(
                              onPressed:
                                  () =>
                                      context.pushNamed(AppRoutes.chatbot.name),
                              icon: Icon(
                                Icons.food_bank,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              iconSize: 20.0,
                            ),
                          ),
                          Text(
                            'Assistente de IA',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surfaceTint,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assine já o \nplano premium',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'R\$ 49,99',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  Text(
                                    'R\$ 39,99',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 15),

                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Text(
                                  'Assine já',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 319,
                          bottom: 150,
                          child: Container(
                            width: 95,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                              ),
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.tertiaryContainer,
                            ),
                            child: Center(
                              child: Text(
                                '50% off',
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 245,
                          top: 40,
                          child: Image.asset(
                            'assets/images/premium.png',
                            height: 115,
                            width: 115,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.alarm,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Próxima Medicação:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (notificationProvider.notifications.isNotEmpty)
                                Text(
                                  '${notificationProvider.notifications[1].title} - ${notificationProvider.notifications[1].body}',
                                )
                              else
                                Text('Nenhuma medicação para hoje!'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed:
                          () => context.pushNamed(AppRoutes.medications.name),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  Text(
                    ' Relatório de Alimentação',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Container(
                width: 450,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.surfaceTint,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Baixar Relatório',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.download_for_offline,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      onPressed: () {
                        // ação ao clicar no botão
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
