import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../widgets/DetailImage.dart';
import '../widgets/detaildata.dart';

class RecipeDetailScreen extends StatefulWidget {
  final int recipeId;

  const RecipeDetailScreen({super.key, required this.recipeId});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late Future<Recipe?> _recipeFuture;

  @override
  void initState() {
    super.initState();
    _recipeFuture = ApiService().recipeDetailLookup(widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Details"),
      ),
      body: FutureBuilder<Recipe?>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Recipe not found."));
          }

          final recipe = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DetailImage(image: recipe.img ?? 'https://via.placeholder.com/300x200?text=No+Image'),

                const SizedBox(height: 20),

                RecipeInfo(
                  name: recipe.name,
                  category: recipe.category ?? "unavailable",
                  youtubeLink: recipe.ytlink ?? "unavailable",
                ),

                const SizedBox(height: 20),

                _buildSectionTitle("Ingredients"),
                ...(recipe.ingredients ?? []).map((i) => Text("• $i")) ,

                const SizedBox(height: 20),

                _buildSectionTitle("Instructions"),
                Text(
                  recipe.instructions ?? "unavailable",
                  textAlign: TextAlign.justify,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
