import 'package:explore_now/features/daily_check_in/screens/home/widgets/popular_destinations.dart';
import 'package:explore_now/features/daily_check_in/screens/home/widgets/search_box.dart';
import 'package:explore_now/features/daily_check_in/screens/home/widgets/section_title.dart';
import 'package:explore_now/features/daily_check_in/screens/home/widgets/trending_destinations.dart';
import 'package:flutter/material.dart';
import 'package:explore_now/utils/constants/sizes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Personalized Greeting
          const Text(
            'Hey Shanto,',
            style: TextStyle(
              color: Colors.black38,
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Where to next?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          /// Search Box
          const SearchBox(),

          const SizedBox(height: 30),

          /// Trending Destinations Section
          const SectionTitle(title: 'Trending Destinations'),
          const SizedBox(height: 10),
          const TrendingDestinations(),

          const SizedBox(height: 30),

          /// Popular Destinations Section
          const SectionTitle(title: 'Popular Destinations'),
          const SizedBox(height: 10),
          const PopularDestinations(),
        ],
      ),
    );
  }
}
