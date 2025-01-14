import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:farstore/constants/global_variables.dart';

class AddPaymentOptionsScreen extends StatefulWidget {
  static const String routeName = '/payment-options';
  const AddPaymentOptionsScreen({super.key});

  @override
  State<AddPaymentOptionsScreen> createState() => _AddPaymentOptionsScreenState();
}

class _AddPaymentOptionsScreenState extends State<AddPaymentOptionsScreen> {
  String environment = 'SANDBOX';
  String appId = 'your_app_id_here'; // Replace with your actual app ID
  String merchantId = 'PGTESTPAYUAT86';
  bool enableLogging = true;
  String checksum = '';
  String saltKey = '96434309-7796-489d-8924-ab56988a6076';
  String saltIndex = '1';
  String callbackUrl =
      'https://webhook.site/f63d1195-f001-474d-acaa-f7bc4f3b20b1';
  String body = '';
  Object? result;
  String apiEndPoint = '/pg/v1/pay';

  // late int _amountInRupees;

  // @override
  // void initState() {
  //   super.initState();
  //   final userProvider = context.read<UserProvider>();
  //   _amountInRupees = userProvider.cartTotal;
  //   phonepeInit();
  // }

  // getChecksum() {
  //   final requestData = {
  //     "merchantId": merchantId,
  //     "merchantTransactionId": "MT${DateTime.now().millisecondsSinceEpoch}",
  //     "merchantUserId": "MUID${DateTime.now().millisecondsSinceEpoch}",
  //     "amount": _amountInRupees * 100, // Convert rupees to paise for PhonePe
  //     "mobileNumber": "9999999999",
  //     "callbackUrl": callbackUrl,
  //     "paymentInstrument": {
  //       "type": "PAY_PAGE",
  //     },
  //   };
  //   String base64Body = base64.encode(utf8.encode(json.encode(requestData)));
  //   checksum =
  //       '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
  //   return base64Body;
  // }

  // late int _amountInRupees;
  // final paymentItems = <PaymentItem>[];
  // PaymentConfiguration? _gpayConfig;
  // void initState() {
  //   paymentItems.add(PaymentItem(
  //       amount: '1',
  //       label: 'Sample payment',
  //       status: PaymentItemStatus.final_price));
  //   final userProvider = context.read<UserProvider>();
  //   _amountInRupees = userProvider.cartTotal;
  //   super.initState();
  //   _loadGooglePayConfiguration();
  // }

  // Future<void> _loadGooglePayConfiguration() async {
  //   final gpayConfig = await PaymentConfiguration.fromAsset('gpay.json');
  //   setState(() {
  //     _gpayConfig = gpayConfig;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 25,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                    'Bill total: ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontFamily: 'SemiBold',
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 30),
                //   child: Text(
                //     '₹${_amountInRupees.toInt()}',
                //     style: const TextStyle(
                //         fontSize: 16,
                //         color: Colors.black,
                //         fontFamily: 'SemiBold'),
                //   ),
                // ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: GlobalVariables.backgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white, // Set container color to white
                          borderRadius: BorderRadius.circular(
                              15), // Set outer container border radius to 15
                        ),
                        padding:
                            const EdgeInsets.all(16), // Add padding to the container
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Recommended',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SemiBold',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'https://via.placeholder.com/100',
                                      width: 50,
                                      height: 25,
                                      fit: BoxFit.cover, // Image fit
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    'Google Pay UPI',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // Text color
                                        fontFamily: 'Regular'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>UpiPayment()));
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>UpiPayment()));
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           UserCartProducts(
                                    //             totalPrice: 0,
                                    //             address: '',
                                    //             index: 0,
                                    //             tips: 0,
                                    //             instruction: const [],
                                    //             totalSave: '',
                                    //             shopCode: '',
                                    //             note: '',
                                    //             number: 0,
                                    //             name: '',
                                    //             paymentType: 1, location: {},
                                    //           )),
                                    // );
                                  },
                                  child:
                                      //   GooglePayButton(paymentConfigurationAsset: 'gpay.json', paymentItems: paymentItems, onPaymentResult: (data) {
                                      //   print(data);
                                      //  },
                                      //  width: 250,
                                      //  height: 60,
                                      //  )
                                      const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                ),
                                // if (_gpayConfig != null)
                                //   GooglePayButton(
                                //     paymentConfiguration: _gpayConfig!,
                                //     paymentItems: paymentItems,
                                //     onPaymentResult: (data) {
                                //       print(data);
                                //     },
                                //     width: 180, // Adjusted the width
                                //     height: 60,
                                //   ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      'https://via.placeholder.com/100',
                                      width: 50,
                                      height: 25,
                                      fit: BoxFit.cover, // Image fit
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  // Move Expanded here directly inside the Row
                                  child: Text(
                                    'Phonepe UPI',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Text color
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                              //  Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (context) =>
                              //                 UserCartProducts(
                              //                   totalPrice: 0,
                              //                   address: '',
                              //                   index: 0,
                              //                   tips: 0,
                              //                   instruction: const [],
                              //                   totalSave: '',
                              //                   shopCode: '',
                              //                   note: '',
                              //                   number: 0,
                              //                   name: '',
                              //                   paymentType: 2, location: {},
                              //                 )),
                              //       );
                                    // _showPaymentDialog();
                                  },
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cards',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SemiBold',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'https://via.placeholder.com/100',
                                    width: 50,
                                    height: 25,
                                    fit: BoxFit.cover, // Image fit
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Add credit or debit cards',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Regular'),
                                ),
                              ),
                              const Text(
                                'ADD',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables
                                        .greenColor, // Text color
                                    fontFamily: 'Regular'),
                              )
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PAY BY ANY UPI APP',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SemiBold',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'https://via.placeholder.com/100',
                                    width: 50,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Add new UPI ID',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black, // Text color
                                      fontFamily: 'Regular'),
                                ),
                              ),
                              const Text(
                                'ADD',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables
                                        .greenColor, // Text color
                                    fontFamily: 'Regular'),
                              )
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Netbanking',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SemiBold',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'https://via.placeholder.com/100',
                                    width: 50,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Netbanking',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontFamily: 'Regular'),
                                ),
                              ),
                              const Text(
                                'ADD',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.greenColor,
                                    fontFamily: 'Regular'),
                              )
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pay On Delivery',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SemiBold',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    'https://via.placeholder.com/100',
                                    width: 50,
                                    height: 25,
                                    fit: BoxFit.cover, // Image fit
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text(
                                  'Cash on Delivery',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontFamily: 'Regular'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color.fromARGB(255, 255, 241,
                                  240), // Background color of the container
                            ),
                            padding: const EdgeInsets.all(
                                8.0), // Add padding for spacing around the text
                            child: const Text(
                              'Cash on delivery is not applicable on first order with items total more than 300',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontFamily:
                                    'Regular', // Ensure 'Regular' font exists or remove this line if using system default font
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('PhonePe Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text(
              //   'Amount: ₹$_amountInRupees',
              //   style: const TextStyle(fontSize: 16),
              // ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Navigator.of(context).pop(); // Close the dialog
                  // await startPgTransaction(); // Start the payment
                },
                child: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text('Proceed with Payment')),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Button radius
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Result:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                result != null ? '$result' : '',
                style: TextStyle(
                  color: result != null && result.toString().contains('failed')
                      ? Colors.red
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
