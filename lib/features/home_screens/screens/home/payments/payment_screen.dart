import 'package:explore_now/features/home_screens/screens/home/controllers/tour_controller.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  VNPayPaymentScreen({required this.paymentUrl});

  @override
  _VNPayPaymentScreenState createState() => _VNPayPaymentScreenState();
}

class _VNPayPaymentScreenState extends State<VNPayPaymentScreen> {
  late final WebViewController _controller;
  final TourController _tourController = TourController();

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            _handleNavigationRequest(context, request);
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            print("Page finished loading: $url");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VNPay Payment'),
        backgroundColor: Colors.black,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }

  Future<void> _handleNavigationRequest(BuildContext context, NavigationRequest request) async {
    final Uri uri = Uri.parse(request.url);
    if (uri.toString().contains('https://explore-now-one.vercel.app/payment-result')) {
      final responseCode = uri.queryParameters['vnp_ResponseCode'];
      final queryParam = uri.queryParameters;
      String defaultMessage;
      switch (responseCode) {
        case '00':
          defaultMessage = 'Giao dịch thành công';
          break;
        case '07':
          defaultMessage = 'Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường).';
          break;
        case '09':
          defaultMessage = 'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng.';
          break;
        case '10':
          defaultMessage = 'Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần';
          break;
        case '11':
          defaultMessage = 'Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Vui lòng thực hiện lại giao dịch.';
          break;
        case '12':
          defaultMessage = 'Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa.';
          break;
        case '13':
          defaultMessage = 'Giao dịch không thành công do nhập sai mật khẩu xác thực giao dịch (OTP). Vui lòng thực hiện lại giao dịch.';
          break;
        case '24':
          defaultMessage = 'Giao dịch không thành công do: Khách hàng hủy giao dịch.';
          break;
        case '51':
          defaultMessage = 'Giao dịch không thành công do: Tài khoản của bạn không đủ số dư để thực hiện giao dịch.';
          break;
        case '65':
          defaultMessage = 'Giao dịch không thành công do: Tài khoản của bạn đã vượt quá hạn mức giao dịch trong ngày.';
          break;
        case '75':
          defaultMessage = 'Ngân hàng thanh toán đang bảo trì. Vui lòng thử lại sau.';
          break;
        case '79':
          defaultMessage = 'Giao dịch không thành công do: Sai mật khẩu thanh toán quá số lần quy định. Vui lòng thực hiện lại giao dịch.';
          break;
        case '99':
          defaultMessage = 'Giao dịch không thành công do lỗi khác.';
          break;
        default:
          defaultMessage = 'Lỗi không xác định.';
      }

      final result = await _tourController.handlePaymentCallback(queryParam);
      final isSuccess = result['success'];
      final message = result['message'] ?? defaultMessage;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }

      Navigator.pop(context);
    }
  }
}
