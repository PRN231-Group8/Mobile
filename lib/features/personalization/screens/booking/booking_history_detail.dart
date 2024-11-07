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
        title: Text('Chi Tiết Đặt Chỗ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng Giá: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(booking.totalPrice)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Ngày Kết Thúc: ${DateFormat('dd/MM/yyyy').format(booking.endDate)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),

            // Transactions
            const Text(
              'Giao Dịch:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (var transaction in booking.transactions)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trạng Thái: ${transaction.status}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Số Tiền: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(transaction.amount)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Ngày: ${DateFormat('dd/MM/yyyy, hh:mm a').format(transaction.createDate)}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
