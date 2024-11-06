import 'package:explore_now/data/services/payment/payment_service.dart';
import 'package:explore_now/data/services/tour/tour_service.dart';
import 'package:flutter/material.dart';
import '../models/tour_model.dart';
import '../payments/payment_screen.dart';

class TourController with ChangeNotifier {
  final TourService _tourService = TourService();
  final PaymentService _paymentService = PaymentService();
  List<Tour> tours = [];
  Tour? tourDetail;
  bool isLoading = false;

  Future<void> fetch4Tours() async {
    isLoading = true;
    notifyListeners();
    try {
      tours = await _tourService.fetch4Tours();
      for (var tour in tours) {
        if (tour.locationInTours.isNotEmpty && tour.locationInTours[0].photos.isNotEmpty) {
          print("Tour ID: ${tour.id} - Image URL: ${tour.locationInTours[0].photos[0].url}");
        } else {
          print("Tour ID: ${tour.id} - No image available");
        }
      }
    } catch (e) {
      print('Error fetching tours: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllTours() async {
    isLoading = true;
    notifyListeners();
    try {
      tours = await _tourService.fetchAllTours();
      for (var tour in tours) {
        if (tour.locationInTours.isNotEmpty && tour.locationInTours[0].photos.isNotEmpty) {
          print("Tour ID: ${tour.id} - Image URL: ${tour.locationInTours[0].photos[0].url}");
        } else {
          print("Tour ID: ${tour.id} - No image available");
        }
      }
    } catch (e) {
      print('Error fetching tours: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTourById(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      tourDetail = await _tourService.fetchTourById(id);
      if (tourDetail != null) {
        if (tourDetail!.locationInTours.isNotEmpty) {
          if (tourDetail!.locationInTours[0].photos.isNotEmpty) {
            print("First Photo URL: ${tourDetail!.locationInTours[0].photos[0].url}");
          }
        }
      } else {
        print("tourDetail is null");
      }
    } catch (e) {
      print('Error fetching tour details: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> initiatePayment(BuildContext context, String tourTripId) async {
    final paymentUrl = await _paymentService.initiatePayment(tourTripId);

    if (paymentUrl != null && paymentUrl.isNotEmpty) {
      print("Navigating to Payment URL: $paymentUrl");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VNPayPaymentScreen(paymentUrl: paymentUrl),
        ),
      ).then((result) {
        // Handle payment result after returning from VNPay
        if (result == 'Thanh toán thành công') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thanh toán thành công!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Thanh toán thất bại!')),
          );
        }
      });
    } else {
      print("Payment URL is null or empty, unable to proceed.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tạo thanh toán')),
      );
    }
  }
}
