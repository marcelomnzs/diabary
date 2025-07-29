import 'package:diabary/domain/models/meal.dart';
import 'package:diabary/features/meal_tracker/presentation/providers/meal_provider.dart';
import 'package:diabary/features/meal_tracker/presentation/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MealTracker extends StatefulWidget {
  const MealTracker({super.key});

  @override
  State<MealTracker> createState() => _MealTrackerState();
}

class _MealTrackerState extends State<MealTracker> {
  final List<Map<String, String>> _mealItems = const [
    {'image': 'assets/images/cafeDaManha.png', 'label': 'Café da manhã'},
    {'image': 'assets/images/almoco.png', 'label': 'Almoço'},
    {'image': 'assets/images/jantar.png', 'label': 'Jantar'},
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.watch<MealProvider>();
    final searchProvider = context.watch<SearchProvider>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        searchProvider.clearSuggestions();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Monte seu prato',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          centerTitle: true,
          toolbarHeight: 90,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 200,
                  child: Row(
                    children: List.generate(_mealItems.length, (index) {
                      final isSelected = mealProvider.selectedIndex == index;

                      return Expanded(
                        flex: isSelected ? 5 : 1,
                        child: GestureDetector(
                          onTap: () {
                            mealProvider.updateSelectedIndex(index);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 2000),
                            curve: Curves.easeIn,
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: AssetImage(_mealItems[index]['image']!),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: const Color.fromRGBO(
                                        0,
                                        0,
                                        0,
                                        0.15,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 12,
                                  bottom: 12,
                                  child: Text(
                                    _mealItems[index]['label']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black45,
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Buscar alimento',
                    hintText: 'Ex: Arroz, banana...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                searchProvider.clearSuggestions();
                              },
                            )
                            : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onSubmitted:
                      (value) => searchProvider.fetchSuggestions(
                        _searchController.text,
                      ),
                ),
              ),

              if (searchProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

              if (searchProvider.suggestions.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: searchProvider.suggestions.length,
                    itemBuilder: (context, index) {
                      final item = searchProvider.suggestions[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.fastfood_outlined),
                          title: Text(item.description),
                          subtitle: Text('${item.portion} - ${item.calories}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              mealProvider.addFoodItem(item);
                              searchProvider.removeSuggestion(item);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              else if (mealProvider.mealItems.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      children: [
                        Text(
                          'Alimentos adicionados:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...mealProvider.mealItems.map((item) {
                          return Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.check_circle_outline),
                                title: Text(item.description),
                                subtitle: Text(
                                  '${item.portion} - ${item.calories}',
                                ),
                                trailing: IconButton(
                                  onPressed:
                                      () => mealProvider.removeFoodItem(item),
                                  icon: Icon(Icons.delete, size: 20),
                                ),
                              ),
                              const Divider(height: 1),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed:
                        mealProvider.mealItems.isEmpty
                            ? null
                            : () {
                              final meal = Meal(
                                items: mealProvider.mealItems,
                                category: mealProvider.selectedMealLabel,
                                date: DateTime.now(),
                              );

                              mealProvider.saveMeal(meal);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Refeição salva com sucesso!'),
                                ),
                              );

                              mealProvider.clearMeal();
                              _searchController.clear();
                              searchProvider.clearSuggestions();
                            },
                    icon: const Icon(Icons.save_alt),
                    label: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12.0,
                      ),
                      child: Text(
                        'Registrar Refeição',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
