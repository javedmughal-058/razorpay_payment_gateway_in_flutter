import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class PaymentUtils{
  static Razorpay razorpay = Razorpay();
  static var orderNumber = "";
  static var razorPayKeyId = "rzp_test_fG5sjTD7oGwxH2";


  static Future<String> getOrderNumber() async {
    var username = "rzp_test_fG5sjTD7oGwxH2";
    var password = "v8lyU51hmOPHdha4l7iUm1Sn";
    int randomNumber = 1 + Random().nextInt(100 - 1 + 1);
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
    final url = Uri.parse('https://api.razorpay.com/v1/orders');
    var response = await http.post(url, body: {
      "amount": "100",
      "currency": "INR",
      "receipt": "receipt_$randomNumber"
    }, headers: {
      'Authorization': basicAuth,
      // 'Content-Type' : "application/json"
    });
    if(response.statusCode == 200){
      var data = jsonDecode(response.body);
      orderNumber = data["id"];
      return orderNumber;
    }
    else{
      return orderNumber;
    }

  }

  static paymentInitialize() {
    var options = {
      'key': razorPayKeyId,
      'amount': 100, //in the smallest currency sub-unit.
      'name': 'Javed Mughal Solution',
      'order_id': orderNumber, // Generate order_id using Orders API
      'description': 'T-Shirt',
      'timeout': 120, // in seconds
      'prefill': {
        'contact': '923024716341',
        'email': 'javedmughal609@gmail.com'
      },
      "theme": {
        "color": "#431c53"
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  static void handlePaymentErrorResponse(PaymentFailureResponse response, context){
    showAlertDialog(
        context,
        "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  static void handlePaymentSuccessResponse(PaymentSuccessResponse response, context){
    showAlertDialog(
        context, "Payment Successful",
        "Payment ID: ${response.paymentId}");
  }

  static void handleExternalWalletSelected(ExternalWalletResponse response, context){
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  static void showAlertDialog(BuildContext context, String title, String message){
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  ()=> Navigator.of(context).pop(),
    );
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



}