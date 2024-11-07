import 'package:explore_now/common/widgets/appbar/home_app_bar.dart';
import 'package:explore_now/features/home_screens/screens/home/widgets/home_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: const HAppBar(
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
      body: HomePage(),
    );
  }
}
