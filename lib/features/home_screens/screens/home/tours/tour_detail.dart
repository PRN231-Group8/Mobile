import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../locations/widgets/location_detail.dart';
import '../controllers/tour_controller.dart';

class TourDetailScreen extends StatelessWidget {
  final String tourId;

  const TourDetailScreen({Key? key, required this.tourId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TourController()..fetchTourById(tourId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tour Details'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Consumer<TourController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final tour = controller.tourDetail;
            if (tour == null) {
              return const Center(child: Text('No tour details available.'));
            }

            return Stack(
              children: [
                // Main content
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tour Image
                      if (tour.locationInTours.isNotEmpty &&
                          tour.locationInTours[0].photos.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            tour.locationInTours[0].photos[0].url,
                            width: double.infinity,
                            height: 320,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Text('No Image Available'),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Title and Description
                      Text(
                        tour.title ?? 'No title available',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tour.description ?? 'No description available',
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      // Dates
                      Text(
                        'Duration: ${tour.startDate != null ? DateFormat('dd/MM/yyyy, hh:mm a').format(tour.startDate!) : 'N/A'} - ${tour.endDate != null ? DateFormat('dd/MM/yy, hh:mm a').format(tour.endDate!) : 'N/A'}',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Text(
                        'Price: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(tour.totalPrice)}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Locations in Tour
                      if (tour.locationInTours.isNotEmpty) ...[
                        const Text(
                          'Locations:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var location in tour.locationInTours)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LocationDetailScreen(location: location),
                                ),
                              );
                            },
                            child: ListTile(
                              leading: location.photos.isNotEmpty
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  location.photos[0].url,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : const Icon(Icons.location_on, color: Colors.blue),
                              title: Text(location.name),
                              subtitle: Text(location.address),
                            ),
                          ),
                      ],

                      const SizedBox(height: 24),

                      // Transportation Information
                      if (tour.transportations.isNotEmpty) ...[
                        const Text(
                          'Transportations:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var transportation in tour.transportations)
                          ListTile(
                            leading: const Icon(Icons.directions_bus, color: Colors.green),
                            title: Text(transportation.type),
                            subtitle: Text('Capacity: ${transportation.capacity}'),
                          ),
                      ],

                      const SizedBox(height: 24),

                      // Tour Timestamps (Schedule)
                      // Tour Timestamps (Schedule)
                      if (tour.tourTimestamps.isNotEmpty) ...[
                        const Text(
                          'Schedule:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var timestamp in tour.tourTimestamps)
                          ListTile(
                            title: Text(timestamp.title),
                            subtitle: Text(
                              '${timestamp.description} \nTime: ${timestamp.preferredTimeSlot?.startTime} - ${timestamp.preferredTimeSlot?.endTime}',
                            ),
                          ),
                      ] else ...[
                        const Text(
                          'No schedule available.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Tour Moods
                      if (tour.tourMoods.isNotEmpty) ...[
                        const Text(
                          'Moods:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: tour.tourMoods.map((mood) => Chip(label: Text(mood.moodTag))).toList(),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Tour Trips
                      if (tour.tourTrips.isNotEmpty) ...[
                        const Text(
                          'Trips:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var trip in tour.tourTrips)
                          ListTile(
                            title: Text('Trip Date: ${DateFormat('dd/MM/yyyy hh:mm a').format(trip.tripDate.toLocal())}'),
                            subtitle: Text(
                              'Status: ${trip.tripStatus}, '
                                  'Price: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(trip.price)}, '
                                  'Booked Seats: ${trip.bookedSeats}',
                            ),
                          )
                      ],
                      const SizedBox(height: 80), // Extra padding for button space
                    ],
                  ),
                ),

                // Book Now Button
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final tourTripId = tour.tourTrips[0].tourTripId;
                      controller.initiatePayment(context ,tourTripId);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      'Book Now',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
