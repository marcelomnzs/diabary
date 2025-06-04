import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice do botão selecionado

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Alinha os textos à esquerda
                    children: [
                      SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          top: 8.0,
                        ), // Espaçamento apenas à esquerda e no topo
                        child:
                            authProvider.user != null
                                ? Text(
                                  'Olá, ${authProvider.user!.displayName}',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                )
                                : Text(
                                  'Olá, Usuário',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
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

                  SizedBox(width: 120),
                  // Espaçamento entre os textos e os botões
                  Column(
                    children: [
                      SizedBox(height: 40),
                      // Espaçamento acima dos botões
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
              SizedBox(height: 20), // Espaçamento entre os textos e os botões
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
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap:
                                  () => context.pushNamed(
                                    AppRoutes.mealTracker.name,
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'imagens/monte_seuparto.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
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
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .onSurface, // Cor de destaque para o valor promocional
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
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .onSurface, // Cor de destaque para o valor promocional
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
                            'Meu perfil ???',
                            style: TextStyle(
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .onSurface, // Cor de destaque para o valor promocional
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
              // Espaçamento entre os botões e o texto
              Container(
                width: 450,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.surfaceTint,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Sombra na parte inferior
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Assine já o plano premium',
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
                                    color: Colors.white.withOpacity(0.5),
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.white.withOpacity(
                                      0.5,
                                    ),
                                  ),
                                ),

                                SizedBox(width: 5),
                                Text(
                                  'R\$ 39,99', // Novo valor ao lado
                                  style: TextStyle(
                                    color:
                                        Theme.of(context)
                                            .colorScheme
                                            .surface, // Cor de destaque para o valor promocional
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),

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

                        SizedBox(width: 30),
                        // Espaçamento entre os textos
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: 450,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.22),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Sombra na parte inferior
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.alarm,
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Próxima Medicação',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed:
                          () => context.goNamed(AppRoutes.medications.name),
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
                      color: Colors.black.withOpacity(0.22),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // Sombra na parte inferior
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

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Configurações',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Sobre'),
        ],
        currentIndex: _selectedIndex, // Define o índice selecionado
        selectedItemColor: Colors.blue, // Cor do item selecionado
        unselectedItemColor: Colors.grey, // Cor dos itens não selecionados
        onTap: (int index) {
          setState(() {
            _selectedIndex = index; // Atualiza o índice selecionado
          });
        },
      ),
    );
  }
}
