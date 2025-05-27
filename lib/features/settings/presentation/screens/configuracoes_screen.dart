import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'change_password_screen.dart';
import 'account_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Método para criar um item da lista com ícone, texto e ação
  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: TextStyle(fontSize: 16)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar personalizada com cor de fundo verde oliva
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A754E),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back, color: Colors.white), // sem ação
              ),
            ),
            const Text(
              'Configuração',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Expanded(child: SizedBox()), // espaço direito
          ],
        ),
      ),

      body: Column(
        children: [
          // Seção do usuário
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ), // Vou supor que a tela se chama ProfileScreen
                    );
                  },
                  child: CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.green[700],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Ricardo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7A754E),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),

          // Opções de configuração
          _buildSettingsOption(
            icon: Icons.lock_outline,
            title: 'Mudar Senha',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          const Divider(),

          _buildSettingsOption(
            icon: Icons.person_outline,
            title: 'Editar Conta',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditAccountScreen(),
                ),
              );
            },
          ),
          const Divider(),

          _buildSettingsOption(
            icon: Icons.notifications_none,
            title: 'Notificações',
            onTap: () {
              print('Notificações');
            },
          ),
          const Divider(),

          _buildSettingsOption(
            icon: Icons.brightness_6_outlined,
            title: 'Modo Claro/Escuro',
            onTap: () {
              print('Modo Claro/Escuro');
            },
          ),
          const Divider(),

          _buildSettingsOption(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              print('Logout');
            },
          ),
        ],
      ),
    );
  }
}
