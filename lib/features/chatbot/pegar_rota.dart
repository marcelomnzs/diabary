import 'dart:convert';
import 'package:http/http.dart' as http;

class NutricionistaService {
  // Troque pelo IP da sua máquina se for testar em emulador/dispositivo físico.
  // Para Flutter web na mesma máquina, pode usar 'http://localhost:8000'.
  static const String baseUrl = 'http://localhost:8000';

  Future<String> enviarMensagem(String mensagem) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/conversa'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mensagem': mensagem}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['resposta'] ?? 'Sem resposta do agente.';
      } else {
        throw Exception('Falha ao enviar mensagem: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na conexão: $e');
    }
  }
}

void main() async {
  final service = NutricionistaService();
  final resposta = await service.enviarMensagem(
    'Olá, preciso de um plano alimentar no almoço.',
  );
  print(resposta);
}
