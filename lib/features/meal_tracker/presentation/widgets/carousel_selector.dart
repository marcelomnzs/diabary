import 'package:diabary/features/meal_tracker/presentation/providers/meal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CarouselSelector extends StatefulWidget {
  const CarouselSelector({super.key});

  @override
  State<CarouselSelector> createState() => _CarouselSelectorState();
}

class _CarouselSelectorState extends State<CarouselSelector> {
  final List<Map<String, String>> _mealItems = const [
    {'image': 'assets/images/cafeDaManha.png', 'label': 'Café da manhã'},
    {'image': 'assets/images/almoco.png', 'label': 'Almoço'},
    {'image': 'assets/images/jantar.png', 'label': 'Jantar'},
  ];

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.watch<MealProvider>();
    return SizedBox(
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
                          color: const Color.fromRGBO(0, 0, 0, 0.15),
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
    );
  }
}
