import 'package:flutter/material.dart';

import '../models/location_model.dart';

class TrendingDestinations extends StatelessWidget {
  final List<Location> trendingLocations;
  final Function(Location) onLocationTap;

  const TrendingDestinations({
    Key? key,
    required this.trendingLocations,
    required this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingLocations.length,
        itemBuilder: (context, index) {
          final location = trendingLocations[index];
          return GestureDetector(
            onTap: () => onLocationTap(location),
            child: TrendingCard(
              image: location.photos.isNotEmpty
                  ? location.photos.first.url
                  : 'assets/images/home/home2.jpg',
              title: location.name,
            ),
          );
        },
      ),
    );
  }
}

class TrendingCard extends StatelessWidget {
  final String image;
  final String title;

  const TrendingCard({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: image.startsWith('http')
                      ? NetworkImage(image)
                      : AssetImage(image) as ImageProvider,
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
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
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
