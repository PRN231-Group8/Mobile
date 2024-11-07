import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/booking_controller.dart';
import 'booking_history_detail.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingHistoryController()..fetchBookingHistory(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lịch sử Đặt Chỗ'),
        ),
        body: Consumer<BookingHistoryController>(
          builder: (context, controller, child) {
            if (controller.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.errorMessage != null) {
              return Center(child: Text(controller.errorMessage!));
            } else if (controller.bookingHistory.isEmpty) {
              return const Center(child: Text('Không có đặt chỗ nào.'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.bookingHistory.length,
                itemBuilder: (context, index) {
                  final booking = controller.bookingHistory[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingDetailScreen(booking: booking),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(booking.totalPrice)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ngày Kết Thúc: ${DateFormat('dd/MM/yyyy').format(booking.endDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
