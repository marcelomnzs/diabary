import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // volta à tela de configurações
                  },
                ),
              ),
            ),
            const Text(
              'Mudar Senha',
              style: TextStyle(
                color: Color(0xFF7A754E),
                fontWeight: FontWeight.bold,
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Senha atual
            const Text(
              'Senha atual:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              _currentPasswordController,
              _obscureCurrent,
              () {
                setState(() {
                  _obscureCurrent = !_obscureCurrent;
                });
              },
            ),

            const SizedBox(height: 20),

            // Nova senha
            const Text(
              'Nova senha:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(_newPasswordController, _obscureNew, () {
              setState(() {
                _obscureNew = !_obscureNew;
              });
            }, hintText: 'Insira a nova senha'),

            const SizedBox(height: 20),

            // Confirmar senha
            const Text(
              'Confirme a senha',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPasswordField(
              _confirmPasswordController,
              _obscureConfirm,
              () {
                setState(() {
                  _obscureConfirm = !_obscureConfirm;
                });
              },
              hintText: 'Confirme a nova senha',
            ),

            const SizedBox(height: 40),

            // Botão cadastrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você pode implementar a lógica de validação
                  print('Senha atual: ${_currentPasswordController.text}');
                  print('Nova senha: ${_newPasswordController.text}');
                  print('Confirmar senha: ${_confirmPasswordController.text}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4C471F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Cadastrar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    bool obscure,
    VoidCallback toggleVisibility, {
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hintText ?? '',
        filled: true,
        fillColor: Colors.grey[100],
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
