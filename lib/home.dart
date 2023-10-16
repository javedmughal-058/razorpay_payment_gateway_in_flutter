import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:razorpay_payment_gateway_in_flutter/razor_payment_utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Pay with Razorpay',
            ),
            ElevatedButton(
                onPressed: () async {
                  EasyLoading.show(status: 'Please wait...!');
                  var orderNumber = await PaymentUtils.getOrderNumber();
                  debugPrint("Order Number $orderNumber");
                  EasyLoading.dismiss();
                  if(orderNumber == ""){
                    EasyLoading.showError('Order Not Generated. Try Again');
                  }
                  else{
                   PaymentUtils.paymentInitialize();
                  }

              },
                child: const Text("Pay with Razorpay")),
          ],
        ),
      ),
    );
  }
}