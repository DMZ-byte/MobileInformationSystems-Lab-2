import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}
class _RecipePageState extends State<RecipePage> {
  int? id;
  File? pickedImage;
  String? name;
  String? instructions;
  String? ytlink;
  List<String>? ingredients;

  @override
  void initState(){
    super.initState();
  }
  Future<void> pickImage() async {
    final picker = ImagePicker();
  }
}