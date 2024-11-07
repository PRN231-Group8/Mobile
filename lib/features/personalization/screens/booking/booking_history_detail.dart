import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/booking_history.dart';

class BookingDetailScreen extends StatelessWidget {
  final TourPackageHistory booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(booking.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour Image
            if (booking.tourTimestamps.isNotEmpty &&
                booking.tourTimestamps[0].location?.photos.isNotEmpty == true)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  booking.tourTimestamps[0].location!.photos[0].url,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            // Tour Title and Description
            Text(
              booking.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              booking.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // Price and Status
            Text(
              'Total Price: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(booking.totalPrice)}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Status: ${booking.status}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // Schedule (Tour Timestamps)
            if (booking.tourTimestamps.isNotEmpty) ...[
              const Text(
                'Schedule:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              for (var timestamp in booking.tourTimestamps)
                ListTile(
                  title: Text(timestamp.title),
                  subtitle: Text(
                    '${timestamp.description}\nTime: ${timestamp.preferredTimeSlot?.startTime} - ${timestamp.preferredTimeSlot?.endTime}',
                  ),
                ),
            ],

            const SizedBox(height: 16),

            // Trips
            if (booking.tourTrips.isNotEmpty) ...[
              const Text(
                'Trips:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              for (var trip in booking.tourTrips)
                ListTile(
                  title: Text(
                      'Trip Date: ${DateFormat('dd/MM/yyyy, hh:mm a').format(trip.tripDate.toLocal())}'),
                  subtitle: Text(
                    'Status: ${trip.tripStatus}\nPrice: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(trip.price)}\nBooked Seats: ${trip.bookedSeats}, Total Seats: ${trip.totalSeats}',
                  ),
                ),
            ],
            const SizedBox(height: 16),

            // Transportation
            if (booking.transportations.isNotEmpty) ...[
              const Text(
                'Transportation:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              for (var transport in booking.transportations)
                ListTile(
                  title: Text('Type: ${transport.type}'),
                  subtitle: Text(
                      'Price: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(transport.price)}\nCapacity: ${transport.capacity}'),
                ),
            ],
            const SizedBox(height: 16),

            // Transactions
            if (booking.transactions.isNotEmpty) ...[
              const Text(
                'Transactions:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              for (var transaction in booking.transactions)
                ListTile(
                  title: Text(
                    'Amount: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(transaction.amount)}',
                  ),
                  subtitle: Text(
                    'Status: ${transaction.status}\nDate: ${DateFormat('dd/MM/yyyy, hh:mm a').format(transaction.createDate.toLocal())}',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
