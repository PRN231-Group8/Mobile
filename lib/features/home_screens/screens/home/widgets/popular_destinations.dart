import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/tour_controller.dart';
import '../models/tour_model.dart';

class TourDestinations extends StatelessWidget {
  final Function(Tour) onTourTap;

  const TourDestinations({
    Key? key,
    required this.onTourTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TourController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.tours.isEmpty) {
          return Center(child: Text('Không có tour nào có sẵn.'));
        } else {
          return SizedBox(
            height: 250, // Increased height to match the layout
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.tours.length,
              itemBuilder: (context, index) {
                final tour = controller.tours[index];
                return GestureDetector(
                  onTap: () => onTourTap(tour),
                  child: TourCard(
                    image: tour.locationInTours.isNotEmpty
                        ? tour.locationInTours[0].photos.isNotEmpty
                            ? tour.locationInTours[0].photos[0].url
                            : 'assets/images/home/home1.jpg'
                        : 'assets/images/home/home1.jpg',
                    title: tour.title ?? 'No title available',
                    location: tour.locationInTours.isNotEmpty
                        ? tour.locationInTours[0].name
                        : 'Unknown',
                    price: tour.totalPrice,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class TourCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final double price;

  const TourCard({
    Key? key,
    required this.image,
    required this.title,
    required this.location,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
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
          // Fixed height container for title and location to avoid overflow
          Container(
            height: 40,
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
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.black54,
                size: 14,
              ),
              const SizedBox(width: 4),
              Expanded(
                // Use Expanded to allow wrapping
                child: Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫', decimalDigits: 0).format(price)}',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
