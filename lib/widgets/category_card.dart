import 'package:flutter/material.dart';
import '../models/categories.dart';

class CategoryCard extends StatelessWidget{
  final Category category;

  const CategoryCard({super.key,required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, "/recipes",arguments:category.name);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.green, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 280,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: Image.network(
                    category.img,
                    fit: BoxFit.cover,
                  ),
                ),
                Divider(),
                Text(category.name, style: TextStyle(fontSize: 20)),
                Text(category.descr, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ),
      ),
    );
  }
}