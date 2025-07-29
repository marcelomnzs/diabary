class FoodItem {
  final Map<String, dynamic> id;
  final String description;
  final String portion;
  final String calories;

  FoodItem({
    required this.id,
    required this.description,
    required this.portion,
    required this.calories,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? {},
      description: json['descricao'] ?? '',
      portion: json['quantidade'] ?? '',
      calories: json['calorias'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'portion': portion,
      'calories': calories,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: Map<String, dynamic>.from(map['id']),
      description: map['description'] ?? '',
      portion: map['portion'] ?? '',
      calories: map['calories'] ?? '',
    );
  }
}
