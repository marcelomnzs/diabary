import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 100),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(width: 150, height: 150),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(50.0),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Informe seu email',
                    labelText: 'Email',
                  ),
                ),
              ),

              SizedBox(height: 0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Informe sua senha',
                    labelText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: const Color.fromARGB(
                          255,
                          150,
                          149,
                          149,
                        ), // Cor do traço
                        thickness: 1, // Espessura do traço
                        endIndent: 10, // Espaçamento entre o traço e o texto
                      ),
                    ),

                    Text(
                      'Faça o seu login com',
                      style: TextStyle(
                        fontFamily: 'SourceSans3',
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(
                          255,
                          150,
                          149,
                          149,
                        ), // Cor do traço
                        thickness: 1, // Espessura do traço
                        indent: 10, // Espaçamento entre o traço e o texto
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Google login action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 35.0,
                      ),
                    ),
                    icon: const Icon(Icons.g_mobiledata, color: Colors.red),
                    label: const Text(
                      'Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  // Espaçamento entre os botões
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Apple login action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 35.0,
                      ),
                    ),

                    icon: const Icon(
                      Icons.apple, // Ícone da Apple
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Apple',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  // Espaçamento entre os botões
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Facebook login action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 35.0,
                      ),
                    ),
                    icon: const Icon(
                      Icons.facebook, // Ícone do Facebook
                      color: Colors.blue,
                    ),
                    label: const Text(
                      'Facebook',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(48.0),
                child: SizedBox(
                  width: 250,
                  height: 35,

                  child: ElevatedButton(
                    onPressed: () {
                      _handleLogin(authProvider, context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(57, 55, 21, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não possui conta?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.goNamed(AppRoutes.signup.name),
                      child: Text(
                        'Registre-se',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
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

  void _handleLogin(AuthProvider authProvider, BuildContext context) async {
    await authProvider.signIn(_emailController.text, _passwordController.text);

    if (authProvider.user != null && authProvider.error == null) {
      if (context.mounted) {
        context.goNamed(AppRoutes.home.name);
      }
    }
    authProvider.setError(null);
  }
}
