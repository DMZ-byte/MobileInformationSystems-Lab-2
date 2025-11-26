import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab2mis_196107/models/recipe.dart';
import '../models/categories.dart';


class ApiService {

  //category list loader
  Future<List<Category>> loadCategoryList() async  {
    List<Category> categoryList = [];
    final detailResponse = await http.get(
      Uri.parse("https://www.themealdb.com/api/json/v1/1/categories.php"),
    );
    if (detailResponse.statusCode == 200){
      final categoryData = json.decode(detailResponse.body);
      final List categories = categoryData["categories"];
      return categories.map((item) => Category.fromJson(item)).toList();
    }
    return [];
  }

  Future<List<Recipe>> filterCategoryMeals(String categoryname) async {
    List<Recipe> recipeList = [];
    final detailResponse = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryname'),
    );
    if (detailResponse.statusCode == 200){
      final recipeData = json.decode(detailResponse.body);
      final List recipes = recipeData['meals'];
      return recipes.map((item) => Recipe.frommJson(item)).toList();
    }
    return [];
  }

  Future<List<Recipe>> filterByQueryMeals(String query) async {
    List<Recipe> recipeList = [];
    final detailResponse = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$query'),
    );
    if (detailResponse.statusCode == 200){
      final recipeData = json.decode(detailResponse.body);
      final List recipes = recipeData['meals'];
      return recipes.map((item) => Recipe.fromJson(item)).toList();
    }
    return [];
  }

  Future<Recipe?> recipeDetailLookup(int id) async{
    Recipe recipe;
    final detailResponse = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );
    if (detailResponse.statusCode == 200){
      final recipeData = json.decode(detailResponse.body);

      final meals = recipeData['meals'];
      if(meals != null && meals.isNotEmpty){
        return Recipe.fromJson(meals[0]);
      }
    }
    return null;
  }

  Future<Recipe> randomRecipe() async{
    Recipe recipe;
    final detailResponse = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );

    final recipeData = json.decode(detailResponse.body);

    final meals = recipeData['meals'];
    if(meals != null && meals.isNotEmpty){
      return Recipe.fromJson(meals[0]);
    }
    else throw {
      http.RequestAbortedException()
    };

  }



}