import 'package:diabary/domain/models/food_item.dart';
import 'package:diabary/domain/models/meal.dart';
import 'package:diabary/features/meal_tracker/presentation/providers/meal_provider.dart';
import 'package:diabary/features/meal_tracker/presentation/providers/search_provider.dart';
import 'package:diabary/features/meal_tracker/presentation/widgets/carousel_selector.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MealTracker extends StatefulWidget {
  const MealTracker({super.key});

  @override
  State<MealTracker> createState() => _MealTrackerState();
}

class _MealTrackerState extends State<MealTracker> {
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final searchProvider = context.watch<SearchProvider>();
    final mealProvider = context.watch<MealProvider>();

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Monte seu prato")),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: CarouselSelector(),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(18),
                          labelText: "Buscar alimento",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              searchProvider.clearSuggestions();
                            },
                          ),
                        ),
                        onChanged: (value) {
                          if (value.length < 3) {
                            return;
                          }

                          searchProvider.fetchSuggestions(value);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (searchProvider.isLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (searchProvider.suggestions.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: searchProvider.suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = searchProvider.suggestions[index];
                          return ListTile(
                            title: Text(suggestion.description),
                            subtitle: Text(
                              "${suggestion.portion} - ${suggestion.calories}",
                            ),
                            onTap: () {
                              mealProvider.addFoodItem(
                                FoodItem(
                                  id: suggestion.id,
                                  description: suggestion.description,
                                  calories: suggestion.calories,
                                  portion: suggestion.portion,
                                ),
                              );
                              searchController.clear();
                              searchProvider.clearSuggestions();
                            },
                          );
                        },
                      ),
                    if (searchProvider.suggestions.isEmpty &&
                        mealProvider.mealItems.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            SizedBox(height: constraints.maxHeight * 0.2),
                            Icon(
                              Icons.restaurant_menu,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Nenhum alimento adicionado ainda',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Use a busca acima para adicionar itens à sua refeição',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    if (mealProvider.mealItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Text(
                              'Alimentos adicionados:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            ...mealProvider.mealItems.map(
                              (item) => Column(
                                children: [
                                  ListTile(
                                    title: Text(item.description),
                                    subtitle: Text(
                                      '${item.portion} - ${item.calories}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed:
                                          () =>
                                              mealProvider.removeFoodItem(item),
                                    ),
                                  ),
                                  const Divider(height: 1),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (mealProvider.mealItems.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.camera,
                              );

                              mealProvider.setMealPhoto(image);

                              if (image != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Foto registrada com sucesso!",
                                    ),
                                  ),
                                );
                                // Salvar imagem no banco de dados
                              }
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text("Tirar foto do prato"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                            ),
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed:
                              mealProvider.mealItems.isEmpty
                                  ? null
                                  : () async {
                                    final meal = Meal(
                                      items: mealProvider.mealItems,
                                      category: mealProvider.selectedMealLabel,
                                      date: DateTime.now(),
                                      photoBase64: mealProvider.mealPhotoBase64,
                                    );

                                    await mealProvider.saveMeal(meal);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Refeição salva com sucesso!',
                                        ),
                                      ),
                                    );

                                    mealProvider.clearMeal();
                                    searchController.clear();
                                    searchProvider.clearSuggestions();
                                  },
                          icon:
                              mealProvider.isLoading
                                  ? SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      strokeWidth: 3.0,
                                    ),
                                  )
                                  : Icon(
                                    Icons.save_alt,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 12.0,
                            ),
                            child: Text(
                              'Registrar Refeição',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
