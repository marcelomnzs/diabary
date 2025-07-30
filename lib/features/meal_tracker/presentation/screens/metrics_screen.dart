import 'package:diabary/features/meal_tracker/presentation/providers/meal_provider.dart';
import 'package:diabary/features/meal_tracker/presentation/screens/meal_detail_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Metrics extends StatefulWidget {
  const Metrics({super.key});

  @override
  State<Metrics> createState() => _MetricsState();
}

class _MetricsState extends State<Metrics> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await context.read<MealProvider>().fetchUserMeals();
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = context.watch<MealProvider>();
    final meals = mealProvider.getMealsForLast30Days();
    final dailyCalories = mealProvider.getDailyCaloriesForChart();
    final sortedEntries = dailyCalories.entries.toList();

    final maxY =
        sortedEntries.isNotEmpty
            ? sortedEntries
                    .map((e) => e.value)
                    .reduce((a, b) => a > b ? a : b) +
                100
            : 200;

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Métricas da Refeição')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calorias nos últimos 30 dias',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  maxY: maxY.toDouble(),
                  minY: 0,
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  barGroups: List.generate(sortedEntries.length, (index) {
                    final value = sortedEntries[index].value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: value.toDouble(),
                          color: Colors.blue,
                          width: 12,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxY.toDouble(),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        reservedSize: 48,
                        getTitlesWidget:
                            (value, meta) => Text(
                              '${value.toInt()} kcal',
                              style: const TextStyle(fontSize: 10),
                              softWrap: false,
                              overflow: TextOverflow.visible,
                            ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 3,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < sortedEntries.length) {
                            final date = sortedEntries[value.toInt()].key;
                            return Text(
                              '${date.day}/${date.month}',
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                        reservedSize: 28,
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Refeições recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return ListTile(
                    title: Text(
                      'Dia ${meal.date.day}/${meal.date.month} - ${meal.totalCalories.toStringAsFixed(0)} kcal',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MealDetailScreen(meal: meal),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
