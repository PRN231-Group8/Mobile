import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../controllers/tour_controller.dart';
import '../locations/widgets/location_detail.dart';

class TourDetailScreen extends StatefulWidget {
  final String tourId;

  const TourDetailScreen({Key? key, required this.tourId}) : super(key: key);

  @override
  _TourDetailScreenState createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  int? selectedPassengers;
  String? selectedTourTripId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      TourController()
        ..fetchTourById(widget.tourId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tour chi tiết'),
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
              return const Center(child: Text('Không có tour có sẵn.'));
            }

            return Stack(
              children: [
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
                            child: Text('Không có ảnh.'),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Title and Description
                      Text(
                        tour.title ?? 'không có tiêu đề',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tour.description ?? 'Không có chi tiết',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),

                      // Dates
                      Text(
                        'Lộ trình: ${tour.startDate != null
                            ? DateFormat('dd/MM/yyyy, hh:mm a').format(tour
                            .startDate!)
                            : 'N/A'} - ${tour.endDate != null
                            ? DateFormat('dd/MM/yy, hh:mm a').format(tour
                            .endDate!)
                            : 'N/A'}',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 16),

                      // Price
                      Text(
                        'Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫')
                            .format(tour.totalPrice)}',
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
                          'Địa điểm:',
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
                                  builder: (context) =>
                                      LocationDetailScreen(location: location),
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
                                  : const Icon(Icons.location_on,
                                  color: Colors.blue),
                              title: Text(location.name),
                              subtitle: Text(location.address),
                            ),
                          ),
                      ],
                      const SizedBox(height: 24),

                      // Tour Timestamps (Schedule)
                      if (tour.tourTimestamps.isNotEmpty) ...[
                        const Text(
                          'Lịch trình:',
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
                              '${timestamp.description}\nTime: ${timestamp
                                  .preferredTimeSlot?.startTime ??
                                  ''} - ${timestamp.preferredTimeSlot
                                  ?.endTime ?? ''}',
                            ),
                          ),
                      ] else
                        ...[
                          const Text(
                            'No schedule available.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      const SizedBox(height: 24),

                      // Tour Trips
                      if (tour.tourTrips.isNotEmpty) ...[
                        const Text(
                          'Chuyến đi:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var trip in tour.tourTrips)
                          ListTile(
                            title: Text(
                                'Ngày đi: ${DateFormat('dd/MM/yyyy hh:mm a')
                                    .format(trip.tripDate.toLocal())}'),
                            subtitle: Text(
                              'Trạng thái: ${trip.tripStatus}, '
                                  'Giá: ${NumberFormat.currency(
                                  locale: 'vi', symbol: '₫').format(
                                  trip.price)}, '
                                  'Số ghế đã đặt: ${trip.bookedSeats}, '
                                  'Tổng số ghế: ${trip.totalSeats}',
                            ),
                            onTap: () {
                              _showTourTripDetailDialog(context, trip);
                            },
                          ),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),

                // Book Now Button
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: ElevatedButton.icon(
                    onPressed:
                    selectedTourTripId != null && selectedPassengers != null
                        ? () {
                      controller.initiatePayment(
                        context,
                        selectedTourTripId!,
                        selectedPassengers!,
                      );
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.send, color: Colors.white),
                    label: const Text(
                      'Book Ngay',
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

  // Method to display tour trip detail dialog with passenger input
  Future<void> _showTourTripDetailDialog(BuildContext context,
      dynamic trip) async {
    final maxPassengers = trip.totalSeats - trip.bookedSeats;
    final passengerController = TextEditingController();

    // Clear previous selection
    setState(() {
      selectedTourTripId = null;
      selectedPassengers = null;
    });

    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Chi tiết chuyến đi'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    'Ngày: ${DateFormat('dd/MM/yyyy, hh:mm a').format(
                        trip.tripDate.toLocal())}'),
                Text(
                    'Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫')
                        .format(trip.price)}'),
                Text(
                    'Tổng số ghế: ${trip.totalSeats}, Đã đặt: ${trip
                        .bookedSeats}'),
                const SizedBox(height: 16),
                TextField(
                  controller: passengerController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Nhập số hành khách (Tối đa: $maxPassengers)',
                    labelText: 'Số lượng hành khách',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  final enteredPassengers =
                      int.tryParse(passengerController.text) ?? 0;
                  if (enteredPassengers > 0 &&
                      enteredPassengers <= maxPassengers) {
                    setState(() {
                      selectedTourTripId = trip.tourTripId;
                      selectedPassengers = enteredPassengers;
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                          Text(
                              'Số lượng hành khách không hợp lệ. Tối đa: $maxPassengers')),
                    );
                  }
                },
                child: const Text('Xác nhận'),
              ),
            ],
          ),
    );
  }
}

