import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final oliveColor = const Color(0xFF7A754E);

  // Lista de anotações simulada
  List<Map<String, String>> notes = [
    {
      'title': 'Mudar o tipo de pão',
      'content': 'Pão integral tem menos glicose.',
    },
    {'title': 'Próxima consulta', 'content': 'Dia 20 deste mês.'},
    {
      'title': 'Malhação 💪',
      'content': 'Academia toda terça e quinta das 15:30 às 17h!',
    },
  ];

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7A754E),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context); // volta à tela de configurações
                  },
                ), // inativo, se desejar
              ),
            ),
            Text(
              'Perfil',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(child: SizedBox()), // equilíbrio do layout
          ],
        ),
      ),

      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nome
            Text(
              'Ricardo',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: oliveColor,
              ),
            ),
            const SizedBox(height: 12),

            // Avatar
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 60, color: oliveColor),
            ),
            const SizedBox(height: 20),

            // Bio Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bio',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: oliveColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Tenho 36 anos, sou professor.\n',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: 'Diabético Tipo 2.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Anotações Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cabeçalho com "Anotações" e botão +
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Anotações',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: oliveColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          color: oliveColor,
                          onPressed: () {
                            // Pode implementar função para adicionar nota depois
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Adicionar anotação não implementado.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Lista de notas
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notes.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Texto da anotação
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '${note['title']}\n',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(text: note['content']),
                                    ],
                                  ),
                                ),
                              ),

                              // Ícone de lixeira
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: oliveColor,
                                onPressed: () => _deleteNote(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
