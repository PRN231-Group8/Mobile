import 'package:explore_now/common/widgets/appbar/appbar.dart';
import 'package:explore_now/features/home_screens/screens/home/widgets/home_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: const TAppBar(
        title: Text(
          'Explore Now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
        showBackArrow: false,
      ),
      body: const HomePage(),
    );
  }
}
