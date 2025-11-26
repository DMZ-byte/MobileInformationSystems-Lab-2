import 'package:flutter/material.dart';
import '../models/categories.dart';
import '../models/recipe.dart';
import '../screens/recipe.dart';
import '../screens/foodsfromcategories.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',

      routes: {
        '/': (context) => const MyHomePage(title: 'Food Categories - 196107'),

        '/recipes': (context) {
          final categoryName = ModalRoute.of(context)?.settings.arguments as String? ?? 'Seafood';
          print(categoryName);
          return FoodsFromCategories(category: categoryName);
        },

        '/recipe_detail': (context) {
          final recipeId = ModalRoute.of(context)?.settings.arguments as int;

          return RecipeDetailScreen(recipeId: recipeId);
        },

      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService apiService = ApiService();
  late Future<List<Category>> categoryFuture;
  late Future<Recipe> randomRecipe;
  late Future<List<Category>> filteredCategoryFuture;
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  @override
  void initState() {
    super.initState();
    categoryFuture = apiService.loadCategoryList().then((categories) {
      _allCategories = categories;
      _filteredCategories = categories;
      return categories;
    });
    _searchController.addListener(_filterCategories);
    randomRecipe = apiService.randomRecipe();

  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  void _filterCategories() {
    final query = _searchController.text.toLowerCase();

    if (!mounted) return;

    setState(() {
      if (query.isEmpty) {
        _filteredCategories = _allCategories;
      } else {
        _filteredCategories = _allCategories.where((category) {
          return category.name.toLowerCase().contains(query);
        }).toList();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
        hintText: 'Search categories... 196107',
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        suffixIcon: IconButton(
        icon: const Icon(Icons.clear, color: Colors.white70),
        // Clear button functionality
        onPressed: () {
        _searchController.clear();
        },
        ),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 18),
        cursorColor: Colors.white,
      ),
      ),

      body: FutureBuilder<List<Category>>(
        future: categoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final categories = _filteredCategories;
          if (categories.isEmpty && _searchController.text.isNotEmpty) {
            return const Center(child: Text("No matching categories found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryCard(category: categories[index]);
            },
          );
        },
      ),
        bottomNavigationBar: FutureBuilder<Recipe>(
          future: randomRecipe,
          builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                final Recipe completedRecipe = snapshot.data!;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom+13,
                  ),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) =>
                              RecipeDetailScreen(
                                recipeId: completedRecipe.id,
                              ),
                        ),
                      );
                    },
                    child: const Text('Random Recipe'),
                  ),
                );
              }
              else{
                return CircularProgressIndicator();
              }
          },
        ),
    );
  }
}
