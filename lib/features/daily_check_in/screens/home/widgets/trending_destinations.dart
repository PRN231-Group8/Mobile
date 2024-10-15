import 'package:flutter/material.dart';
import 'package:explore_now/utils/constants/image_strings.dart';
import 'package:explore_now/utils/constants/sizes.dart';

class TrendingDestinations extends StatelessWidget {
  const TrendingDestinations({super.key});

  final List<Map<String, String>> trending = const [
    {'image': 'assets/images/home/home1.jpg', 'title': 'Hanoi'},
    {'image': 'assets/images/home/home1.jpg', 'title': 'New York City'},
    {'image': 'assets/images/home/home1.jpg', 'title': 'Oahu'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trending.length,
        itemBuilder: (context, index) {
          return TrendingCard(
            image: trending[index]['image']!,
            title: trending[index]['title']!,
          );
        },
      ),
    );
  }
}

class TrendingCard extends StatelessWidget {
  final String image;
  final String title;

  const TrendingCard({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image part
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.emoji_events, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Title part
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black26,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
