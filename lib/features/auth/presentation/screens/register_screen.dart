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
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: const Color.fromARGB(156, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.login.name),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 50),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: SizedBox(width: 150, height: 150),
                ),
              ),

              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite Seu Nome',
                    labelText: 'Nome',
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Informe seu email',
                    labelText: 'Email',
                  ),
                ),
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isPasswordVisible2,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
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
              ),

              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Número de Telefone',
                    labelText: 'Informe seu Número de Telefone',
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
                      'Ou cadastre-se com',
                      style: TextStyle(
                        fontFamily: 'SourceSans3',
                        fontSize: 15,
                        color: Color.fromARGB(255, 0, 0, 0),
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
                        horizontal: 25.0,
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
                        horizontal: 25.0,
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
                        horizontal: 25.0,
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
                    onPressed: () => _handleSignUp(authProvider, context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(57, 55, 21, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
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
                      'Já possui conta?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => context.goNamed(AppRoutes.login.name),
                      child: Text(
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
