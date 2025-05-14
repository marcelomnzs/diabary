import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0; // Índice do botão selecionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
