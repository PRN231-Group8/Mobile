import 'package:flutter/material.dart';
import 'package:explore_now/utils/constants/image_strings.dart';
import 'package:explore_now/utils/constants/sizes.dart';

import '../../../../../common/widgets/images/t_rounded_image.dart';

class PopularDestinations extends StatelessWidget {
  const PopularDestinations({super.key});

  final List<Map<String, String>> popular = const [
    {'image': 'assets/images/home/home1.jpg', 'title': 'Wooden Path', 'location': 'Vientiane', 'price': '\$600'},
    {'image': 'assets/images/home/home1.jpg', 'title': 'Glencoe', 'location': 'Scotland', 'price': '\$800'},
    {'image': 'assets/images/home/home1.jpg', 'title': 'Lake Bled', 'location': 'Slovenia', 'price': '\$900'},
    {'image': 'assets/images/home/home1.jpg', 'title': 'Santorini', 'location': 'Greece', 'price': '\$1200'},
    {'image': 'assets/images/home/home1.jpg', 'title': 'Mount Fuji', 'location': 'Japan', 'price': '\$700'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250, // Set a height for the horizontal scroll area
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popular.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10), // Add space to the right of each card
            child: PopularCard(
              image: popular[index]['image']!,
              title: popular[index]['title']!,
              location: popular[index]['location']!,
              price: popular[index]['price']!,
            ),
          );
        },
      ),
    );
  }
}

class PopularCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String price;

  const PopularCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ensure a fixed height for the Stack
            Container(
              height: 170, // Fixed height for the container
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      image,
                      width: double.infinity,
                      height: double.infinity, // Ensure the image fills the container
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Favorite icon at the top right corner
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Title, location, and price details
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.black54,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text(
                  'Starting: ',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
