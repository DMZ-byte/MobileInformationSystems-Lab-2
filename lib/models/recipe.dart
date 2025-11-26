import 'package:flutter/foundation.dart';

class Recipe{
  int id;
  String name;
  String? category;
  String? instructions;
  String img;
  String? ytlink;
  List<String>? ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.img,
    required this.ytlink,
    required this.ingredients,
    required this.category,


  });
  static List<String> extractIngredients(Map<String, dynamic> json) {
    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json["strIngredient$i"];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient.toString().trim());
      }
    }

    return ingredients;
  }
  Map<String, dynamic> toJson() => {

  };



  Recipe.fromJson(Map<String, dynamic> data):
        id = int.parse(data['idMeal']),
        name = data['strMeal'] as String,
        img = data['strMealThumb'] as String,
        instructions = data['strInstructions'],
        category = data['strCategory'],
        ingredients = extractIngredients(data),
        ytlink = data['strYoutube'] ?? "";


  Recipe.frommJson(Map<String, dynamic> data):
        id = int.parse(data['idMeal']),
        name = data['strMeal'] as String,
        img = data['strMealThumb'] as String;

}