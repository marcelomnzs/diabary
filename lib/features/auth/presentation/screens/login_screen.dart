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
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.healing_rounded, size: 70),
                                Text(
                                  'Diabary',
                                  style: TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Informe seu email',
                            labelText: 'Email',
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
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

                        const SizedBox(height: 30),

                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 150, 149, 149),
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            const Text(
                              'Faça o seu login com',
                              style: TextStyle(
                                fontFamily: 'SourceSans3',
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 150, 149, 149),
                                thickness: 1,
                                indent: 10,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                              icon: Icons.g_mobiledata,
                              color: Colors.red,
                              label: 'Google',
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            _buildSocialButton(
                              icon: Icons.apple,
                              color: Colors.black,
                              label: 'Apple',
                              onPressed: () {},
                            ),
                            const SizedBox(width: 8),
                            _buildSocialButton(
                              icon: Icons.facebook,
                              color: Colors.blue,
                              label: 'Facebook',
                              onPressed: () {},
                            ),
                          ],
                        ),

                        SizedBox(height: 30),
                        if (authProvider.error != null)
                          Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              authProvider.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        SizedBox(height: 5),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _handleLogin(authProvider, context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Não possui conta?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap:
                                    () =>
                                        context.goNamed(AppRoutes.signup.name),
                                child: const Text(
                                  'Registre-se',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
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
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      ),
      icon: Icon(icon, color: color),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
  }
}
