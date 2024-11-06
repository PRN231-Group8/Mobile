import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../utils/constants/connection_strings.dart';

class VNPayPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  VNPayPaymentScreen({required this.paymentUrl});

  @override
  _VNPayPaymentScreenState createState() => _VNPayPaymentScreenState();
}

class _VNPayPaymentScreenState extends State<VNPayPaymentScreen> {
  late final WebViewController _controller;

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

  void _handleNavigationRequest(BuildContext context, NavigationRequest request) {
    final Uri uri = Uri.parse(request.url);

    // Check if the URL contains the callback URL with the expected scheme/host
    if (uri.toString().contains('https://localhost:7130/api/payments/callback')) {
      final responseCode = uri.queryParameters['vnp_ResponseCode'];
      if (responseCode == '00') {
        // Payment success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thanh toán thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thanh toán không thành công')),
        );
      }
      Navigator.pop(context); // Close the WebView screen
    }
  }
}
