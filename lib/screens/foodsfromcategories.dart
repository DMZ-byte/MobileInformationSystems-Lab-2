import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../widgets/recipe_grid.dart';

class FoodsFromCategories extends StatefulWidget {
  final String category;

  const FoodsFromCategories({super.key, required this.category});

  @override
  State<FoodsFromCategories> createState() => _FoodsFromCategoriesState();
}

class _FoodsFromCategoriesState extends State<FoodsFromCategories> {
  final ApiService api = ApiService();
  late Future<List<Recipe>> recipeFuture;
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    recipeFuture = api.filterCategoryMeals(widget.category).then((recipes) {
      _allRecipes = recipes;
      _filteredRecipes = recipes;
      return recipes;
    });

    _searchController.addListener(_filterRecipes);
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();

    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredRecipes = _allRecipes;
      } else {
        _filteredRecipes = _allRecipes.where((recipe) {
          return recipe.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.category, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),

            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search recipe...',
                  hintStyle: const TextStyle(color: Colors.white54, fontSize: 16),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search, color: Colors.black, size: 20),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.black),
                    onPressed: () => _searchController.clear(),
                  )
                      : null,
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                cursorColor: Colors.black,
              ),
            ),
          ],
        ),
      ),


      body: FutureBuilder<List<Recipe>>(
        future: recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading recipes: ${snapshot.error}"));
          }

          final recipes = _filteredRecipes;

          if (recipes.isEmpty) {
            final message = _searchController.text.isNotEmpty
                ? "No recipes match your search in this category."
                : "No recipes found for this category.";
            return Center(child: Text(message));
          }

          return RecipeGrid(
            recipes: recipes,
            onTap: (recipe) {
              Navigator.pushNamed(
                context,
                "/recipe_detail",
                arguments: recipe.id,
              );
            },
          );
        },
      ),
    );
  }
}
