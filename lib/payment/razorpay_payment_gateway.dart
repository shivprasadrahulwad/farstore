// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class RazorPaymentScreen extends StatefulWidget {
//   const RazorPaymentScreen({super.key});

//   @override
//   State<RazorPaymentScreen> createState() => _RazorPaymentScreenState();
// }

// class _RazorPaymentScreenState extends State<RazorPaymentScreen> {

//   late Razorpay _razorpay;
//   TextEditingController amtController = TextEditingController();

//   void openCheckout(amount) async{
//     amount = amount * 100;
//     var options = {
//       'key': 'rzp_text_1DP5mm0lF5Gag',
//       'amount':amount,
//       'name':'shopEz',
//       'prefill':{
//         'contact':'8830031264',
//         'email': 'text@gmail.com',
//       },
//       'external':{
//         'wallets':['paytm'],
//       }
//     };

//     try{
//       _razorpay.open(options);
//     }catch(e){
//       debugPrint('Error: e');
//     }
//   }

//   void handelPaymentSuccess(PaymentSuccessResponse response)
//   {
//     Fluttertoast.showToast(msg: 'Payment Successful' + response.paymentId!,toastLength: Toast.LENGTH_SHORT);
//   }

//   void handelPaymentError(PaymentFailureResponse response)
//   {
//     Fluttertoast.showToast(msg: 'Payment Fail' + response.message!,toastLength: Toast.LENGTH_SHORT);
//   }

//   void handelExternalWallet(ExternalWalletResponse response)
//   {
//     Fluttertoast.showToast(msg: 'External Wallet' + response.walletName!,toastLength: Toast.LENGTH_SHORT);
//   }

//   @override
//   void dispose(){
//     super.dispose();
//     _razorpay.clear();
//   }

//   @override
//   void initState(){
//     super.initState();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,handelPaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,handelPaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,handelExternalWallet);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 100,),
//             Text('Welcome to Razor-Payment'),
//             TextFormField(
//               decoration: InputDecoration(
//                 labelText: 'Enter amount',
//               ),
//             ),
//             ElevatedButton(onPressed: (){
//               setState(() {
//                 int amount = int.parse(amtController.text.toString());
//                 openCheckout(amount);
//               });
//             }, child: Text('pay'))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RazorPaymentScreen extends StatefulWidget {
  const RazorPaymentScreen({Key? key}) : super(key: key);

  @override
  _RazorPaymentScreenState createState() => _RazorPaymentScreenState();
}

class _RazorPaymentScreenState extends State<RazorPaymentScreen> {
  late Razorpay _razorpay;
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _startPayment() {
    // Validate amount
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    // Convert amount to paisa (smallest currency unit)
    double amount = double.parse(_amountController.text) * 100;

    var options = {
      'key': 'rzp_test_wuqtPuR3S7duHZ', // Razorpay's standard test key
      'amount': amount.toStringAsFixed(0), // in paisa, no decimal
      'name': 'shopEz', // Your app name
      'description': 'Payment for services',
      'prefill': {
        'contact': '8830031264', // Razorpay test contact number
        'email': 'work.shivprasadrahulwad@gmail.com' // Razorpay test email
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: 'Payment Success: ${response.paymentId}',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   Fluttertoast.showToast(
  //     msg: 'Payment Error: ${response.message}',
  //     toastLength: Toast.LENGTH_SHORT,
  //   );
  // }

  void _handlePaymentError(PaymentFailureResponse response) {
  // Enhanced error logging
  debugPrint('Payment Error Code: ${response.code}');
  debugPrint('Payment Error Message: ${response.message}');
  
  Fluttertoast.showToast(
    msg: 'Payment Failed. Please try again.',
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.red,
  );

  // Optional: More detailed error handling
  switch (response.code) {
    case 1:
      // General error
      _showErrorDialog('Payment could not be processed. Please check your payment details.');
      break;
    case 2:
      // Network error
      _showErrorDialog('Network error. Please check your internet connection.');
      break;
    default:
      _showErrorDialog('An unexpected error occurred. Please try again.');
  }
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Payment Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
        ),
      ],
    ),
  );
}

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: 'External Wallet: ${response.walletName}',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Razorpay Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startPayment,
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}
