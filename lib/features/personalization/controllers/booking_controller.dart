import 'package:flutter/cupertino.dart';

import '../../../data/services/booking/booking_service.dart';
import '../models/booking_history.dart';

class BookingHistoryController with ChangeNotifier {
  final BookingHistoryService _bookingHistoryService = BookingHistoryService();
  List<TourPackageHistory> bookingHistory = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchBookingHistory() async {
    isLoading = true;
    notifyListeners();

    try {
      bookingHistory = await _bookingHistoryService.fetchBookingHistory();
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load booking history';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}