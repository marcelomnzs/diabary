import 'package:flutter/material.dart';

class MealTrackerScreen extends StatefulWidget {
  const MealTrackerScreen({super.key});

  @override
  State<MealTrackerScreen> createState() => _MealTrackerScreenState();
}

class _MealTrackerScreenState extends State<MealTrackerScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, List<String>> _addedItems = {
    'Café da Manhã': [],
    'Almoço': [],
    'Janta': [],
  };
  String _selectedMeal = 'Almoço';

  void _addItem(String item) {
    if (_addedItems[_selectedMeal]!.length < 5) {
      setState(() {
        _addedItems[_selectedMeal]!.add(item);
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      _addedItems[_selectedMeal]!.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8EE),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {}, // Conexão futura com a tela Home
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Monte seu prato',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A5233),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ), // Para balancear o espaço do ícone de retorno
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children:
                    ['Café da Manhã', 'Almoço', 'Janta'].map((meal) {
                      final isSelected = _selectedMeal == meal;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedMeal = meal),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFDDD2B6)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          width: 100,
                          child: Center(
                            child: Text(
                              meal,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDD2B6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => _searchController.clear(),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onSubmitted: (value) => _addItem(value),
                                decoration: const InputDecoration(
                                  hintText: 'Digite um alimento...',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () => _searchController.clear(),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Itens adicionados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5A5233),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 250),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _addedItems[_selectedMeal]!.length,
                          itemBuilder: (context, index) {
                            final item = _addedItems[_selectedMeal]![index];
                            return Card(
                              color: const Color(0xFFDDD2B6),
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: ListTile(
                                title: Text(
                                  item,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: const Text(
                                  'Carboidratos: 3Mg\nProteínas: 5Mg',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _removeItem(index),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
