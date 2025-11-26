import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeInfo extends StatelessWidget {
  final String name;
  final String category;
  final String youtubeLink;

  const RecipeInfo({
    super.key,
    required this.name,
    required this.category,
    required this.youtubeLink,
  });

  Future<void> _openYoutube() async {
    final uri = Uri.parse(youtubeLink);

    const mode = LaunchMode.platformDefault;

    if (await canLaunchUrl(uri)) {
      if (await launchUrl(uri, mode: mode)) {
        return; // Success
      }
    }

    print('Could not launch $youtubeLink');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "Category: $category",
          style: const TextStyle(fontSize: 16),
        ),

        const SizedBox(height: 12),

        if (youtubeLink.trim().isNotEmpty)
          ElevatedButton(
            onPressed: _openYoutube,
            child: const Text("Watch on YouTube"),
          ),
      ],
    );
  }
}
