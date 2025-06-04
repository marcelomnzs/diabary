import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/core/theme/theme_provider.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      // AppBar personalizada com cor de fundo verde oliva
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A754E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  onTap: () => context.goNamed(AppRoutes.profilePage.name),
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
                  authProvider.user?.displayName ?? 'Usuário',
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
            onTap: () => context.goNamed(AppRoutes.changePassword.name),
          ),
          const Divider(),

          _buildSettingsOption(
            icon: Icons.person_outline,
            title: 'Editar Conta',
            onTap: () => context.goNamed(AppRoutes.editAccount.name),
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

          SwitchListTile(
            title: const Text('Modo Escuro'),
            secondary: Icon(Icons.nightlight_round, color: Colors.black87),
            value: context.watch<ThemeProvider>().themeMode == ThemeMode.dark,
            onChanged: (bool value) {
              context.read<ThemeProvider>().switchTheme(value);
            },
          ),

          const Divider(),

          _buildSettingsOption(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () => authProvider.signOut(),
          ),
        ],
      ),
    );
  }
}
