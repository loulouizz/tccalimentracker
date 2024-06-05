class FoodModel {
  String name;
  double kcal;
  double protein;
  double carbohydrate;
  double fat;
  double fiber;
  double sodium;

  FoodModel({
    required this.name,
    required this.kcal,
    required this.protein,
    required this.carbohydrate,
    required this.fat,
    required this.fiber,
    required this.sodium,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'kcal': kcal,
      'protein': protein,
      'carbohydrate': carbohydrate,
      'fat': fat,
      'fiber': fiber,
      'sodium': sodium,
    };
  }

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      name: json['name'],
      kcal: json['kcal'],
      protein: json['protein'],
      carbohydrate: json['carbohydrate'],
      fat: json['fat'],
      fiber: json['fiber'],
      sodium: json['sodium'],
    );
  }
}