import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onViewAllPressed;

  const SectionTitle({Key? key, required this.title, required this.onViewAllPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onViewAllPressed,
          child: const Text(
            'View All',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
