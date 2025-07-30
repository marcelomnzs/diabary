import 'package:diabary/core/routes/app_router.dart';
import 'package:diabary/domain/models/user_model.dart';
import 'package:diabary/features/auth/presentation/providers/auth_provider.dart';
import 'package:diabary/features/auth/presentation/providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  bool _isPasswordVisible2 = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
                      children: [
                        const SizedBox(height: 50),
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.healing_rounded, size: 65),
                                Text(
                                  'Diabary',
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.w900,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Digite Seu Nome',
                            labelText: 'Nome',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Informe seu email',
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Digite sua senha',
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
                        const SizedBox(height: 10),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isPasswordVisible2,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Senha',
                            labelText: 'Confirme sua senha',
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible2 = !_isPasswordVisible2;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Número de Telefone',
                            labelText: 'Informe seu Número de Telefone',
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: const [
                            Expanded(
                              child: Divider(
                                color: Color.fromARGB(255, 150, 149, 149),
                                thickness: 1,
                                endIndent: 10,
                              ),
                            ),
                            Text(
                              'Ou cadastre-se com:',
                              style: TextStyle(
                                fontFamily: 'SourceSans3',
                                fontSize: 15,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            Expanded(
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
                            ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 20.0,
                                ),
                              ),
                              icon: const Icon(
                                Icons.g_mobiledata,
                                color: Colors.red,
                              ),
                              label: const Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 20.0,
                                ),
                              ),
                              icon: const Icon(
                                Icons.apple,
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
                            ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFFFFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 20.0,
                                ),
                              ),
                              icon: const Icon(
                                Icons.facebook,
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
                            onPressed:
                                () => _handleSignUp(authProvider, context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              'Cadastre-se',
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
                                'Já possui conta?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap:
                                    () => context.goNamed(AppRoutes.login.name),
                                child: const Text(
                                  'Login',
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

  Future<void> _handleSignUp(
    AuthProvider authProvider,
    BuildContext context,
  ) async {
    final userDataProvider = context.read<UserDataProvider>();

    if (_passwordController.text != _confirmPasswordController.text) {
      authProvider.setError('As senhas não coincidem');
      return;
    }

    await authProvider.createAccount(
      _emailController.text,
      _passwordController.text,
    );

    final user = authProvider.user;

    if (user != null && authProvider.error == null) {
      await authProvider.updateUsername(_nameController.text);

      final userModel = UserModel(
        id: user.uid,
        email: user.email!,
        name: _nameController.text,
      );

      await userDataProvider.saveUserData(userModel);

      if (context.mounted) {
        context.goNamed(AppRoutes.home.name);
      }
    }
  }
}
