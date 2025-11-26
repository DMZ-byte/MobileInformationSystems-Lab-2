import 'package:flutter/material.dart';

class DetailImage extends StatelessWidget{
  final String image;
  
  const DetailImage({super.key, required this.image});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Padding(
          padding: const EdgeInsets.all(20.0),
        child: Image.network(image, fit: BoxFit.contain,),
      ),
    );
  }
  
}