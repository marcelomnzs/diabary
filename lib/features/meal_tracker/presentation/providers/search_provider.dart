import 'dart:convert';
import 'package:diabary/domain/models/food_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  List<FoodItem> suggestions = [];
  bool isLoading = false;
  String? _error;

  get results => null;
  get error => _error;

  void setError(String error) {
    _error = error;
  }

  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final uri = Uri.parse(
        'https://caloriasporalimentoapi.herokuapp.com/api/calorias/?descricao=$query',
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        suggestions = data.map((json) => FoodItem.fromJson(json)).toList();
      } else {
        suggestions = [];
      }
    } catch (e) {
      debugPrint(e.toString());
      setError(e.toString());
      suggestions = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void removeSuggestion(FoodItem item) {
    suggestions.remove(item);
    notifyListeners();
  }

  void clearSuggestions() {
    suggestions = [];
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
