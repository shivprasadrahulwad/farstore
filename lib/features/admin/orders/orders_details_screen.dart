import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/constants/utils.dart';
import 'package:farstore/features/admin/orders/orders_services.dart';
import 'package:farstore/models/order.dart';
import 'package:farstore/models/orderHive.dart';
import 'package:farstore/providers/user_provider.dart';
import 'package:farstore/widgets/sign_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderDetailScreen extends StatefulWidget {
  static const String routeName = '/order-details';
  Order? order; // Made mutable

  OrderDetailScreen({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  int status = 0;
  int currentStep = 0;
  final OrderServices orderServices = OrderServices();
  // late Box<OrderHive> _orderHiveBox;

  // @override
  // void initState() {
  //   super.initState();
  //   _initHive();
  //   fetchCurrentOrderStatus();
  //   handleOrderStatusChange(status);
  //   if (widget.order != null) {
  //     currentStep = widget.order!.status;
  //   }
  // }

  @override
void initState() {
  super.initState();
  // _initHive().then((_) {
  //   fetchCurrentOrderStatus();
  //   handleOrderStatusChange(status);
  //   if (widget.order != null) {
  //     currentStep = widget.order!.status;
  //   }
  // });
}

  //   Future<void> _initHive() async {
  //   // Open Hive box for OrderHive
  //   _orderHiveBox = await Hive.openBox<OrderHive>('orderBox');
  // }

  // void continueStep() {
  //   if (currentStep < 3) {
  //     // Adjust this based on your number of steps
  //     setState(() {
  //       currentStep++;
  //     });
  //     handleOrderStatusChange(currentStep); // Update status in backend
  //   }
  // }

  // // Function to move to the previous step
  // void cancelStep() {
  //   if (currentStep > 0) {
  //     setState(() {
  //       currentStep--;
  //     });
  //   }
  // }

  // // Function to tap on a specific step
  // void onStepTapped(int value) {
  //   setState(() {
  //     currentStep = value;
  //   });
  // }

  // Function to handle order status change
  // void handleOrderStatusChange(int status) {
  //   if (widget.order != null) {
  //     final orderServices = OrderServices(); // Create an instance

  //     orderServices.changeOrderStatus(
  //       context: context,
  //       status: status,
  //       order: widget.order!,
  //       onSuccess: () {
  //         setState(() {
  //           widget.order!.status = status; // Update local order status
  //         });
  //       },
  //     );
  //   }
  // }



  // Future<void> _updateOrderStatusInHive(String orderId, int newStatus) async {
  //   final existingOrder = _orderHiveBox.get(orderId);
  //   if (existingOrder != null) {
  //     existingOrder.updateStatus(newStatus);
  //   }
  // }


//   void handleOrderStatusChange(int status) {
//   if (widget.order != null) {
//     final orderServices = OrderServices();

//     orderServices.changeOrderStatus(
//       context: context,
//       status: status,
//       order: widget.order!,
//       onSuccess: () async {
//         // Update local state
//         setState(() {
//           widget.order!.status = status;
//         });

//         // Update in Hive
//         try {
//           await _updateOrderStatusInHive(widget.order!.id, status);
//         } catch (e) {
//           print('Error updating Hive storage: $e');
//           showSnackBar(context, "Failed to update local storage");
//         }
//       },
//     );
//   }
// }

// // Update the _updateOrderStatusInHive function to be more robust
// Future<void> _updateOrderStatusInHive(String orderId, int newStatus) async {
//   try {
//     // Try to get existing order from Hive
//     final existingOrder = _orderHiveBox.get(orderId);
    
//     if (existingOrder != null) {
//       // Update existing order
//       existingOrder.updateStatus(newStatus);
//     } else {
//       // Create new OrderHive object if it doesn't exist
//       final newOrderHive = OrderHive(
//         orderId: orderId,
//         status: newStatus,
//       );
      
//       // Put new order in Hive box
//       await _orderHiveBox.put(orderId, newOrderHive);
//     }
//   } catch (e) {
//     print('Error in _updateOrderStatusInHive: $e');
//     throw Exception('Failed to update order status in Hive');
//   }
// }



//   Future<void> fetchCurrentOrderStatus() async {
//   setState(() {
//     // isLoading = true;
//   });

//   try {
//     final updatedStatus = await orderServices.fetchOrderStatus(
//       context: context,
//       orderId: widget.order!.id,
//     );

//     if (updatedStatus != -1) {
//       setState(() {
//         currentStep = updatedStatus;
//         widget.order!.status = updatedStatus;
//       });
//     } else {
//       // Handle error case
//       showSnackBar(context, "Failed to fetch order status");
//     }
//   } catch (e) {
//     print('Error fetching order status: $e');
//     showSnackBar(context, "An error occurred while fetching order status");
//   } finally {
//     setState(() {
//       // isLoading = false;
//     });
//   }
// }

  @override
  Widget build(BuildContext context) {
    String id = '${widget.order!.id}';
    String convertIdToOrderId(String id) {
      // Truncate the original ID or generate a hash/UUID for a unique order ID
      String shortId = id
          .substring(0, 6)
          .toUpperCase(); // Truncate to 6 characters and make uppercase
      return 'ORD-$shortId'; // Create user-friendly order ID
    }

    final formattedOrderId = convertIdToOrderId(widget.order!.id);
    final user = Provider.of<UserProvider>(context).user;
    int handelingCharge = 0;
    bool isAdmin = user.type == 'admin';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Colors.white,
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
          actions: const [
            Row(
              children: [],
            ),
          ],
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  'Order details',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Regular',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: widget.order == null
          ? const Center(
              child: Text(
                'NO Order yet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.motorcycle,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Details',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Regular'),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Details of current order',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontFamily: 'Regular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(color: Colors.grey),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.center, // Vertically centers the content
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.call,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                // Optional: To prevent text from overflowing
                                child: Text(
                                  "${widget.order!.name}, ${widget.order!.number}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // const Divider(color: Colors.grey),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Vertically centers the content
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              const Expanded(
                                // Optional: To handle text overflow
                                child: Text(
                                  'Shiv, Behind Apurv Hospital, Nanded',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // const Divider(color: Colors.grey),
                          const SizedBox(
                            height: 10,
                          ),
                          
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Vertically centers the icon and text
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                  color: GlobalVariables.blueBackground,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  '-${widget.order!.note}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontFamily: 'Regular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: [
                                  const Text(
                                    "Bill details",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SemiBold',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '-  ${DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.order!.orderedAt),
                                    )}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  Text(
                                    'ID: ${formattedOrderId}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(
                                            text: formattedOrderId));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'ID copied to clipboard')),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.copy,
                                        size: 12,
                                      )),
                                  const Spacer(),
                                  Text(
                                    'Time: ${DateFormat('hh:mm a').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          widget.order!.orderedAt),
                                    )}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Item',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  Text(
                                    'Price(1 Q.)',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: widget.order!.products.isEmpty
                                      ? [
                                          const Center(
                                            child: Text(
                                              'No products in this order.',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        ]
                                      : [
                                          const SizedBox(height: 10),
                                          Row(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: widget
                                                      .order!.products
                                                      .map((product) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        product.name,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'Regular',
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: widget
                                                      .order!.products
                                                      .map((product) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        (product.discountPrice)
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: 'Regular',
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: widget
                                                      .order!.products
                                                      .map((product) {
                                                    int index = widget
                                                        .order!.products
                                                        .indexOf(product);
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        '${widget.order!.quantity[index]}',
                                                        style: const TextStyle(
                                                          fontFamily: 'Regular',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                ),
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 20),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.event_note_sharp,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Text(
                                    "Sub Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  const Spacer(),
                                  // CartSubtotal(),
                                  Text('₹${widget.order!.totalPrice}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular',
                                          color:
                                              GlobalVariables.faintBlackColor))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.shopping_bag_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Handeling Charge",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular',
                                        color: GlobalVariables.faintBlackColor),
                                  ),
                                  Spacer(),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                10), // Adjust this value for spacing
                                        child: Text(
                                          '₹10  ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.greyTextColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                30), // Adjust this value for spacing
                                        child: Text(
                                          '  FREE',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.blueTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 15,
                                right: 15,
                                top: 10,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.motorcycle,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Delivery Charge",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: GlobalVariables.faintBlackColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Regular'),
                                  ),
                                  Spacer(),
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                10), // Adjust this value for spacing
                                        child: Text(
                                          '₹150  ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.greyTextColor,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                30), // Adjust this value for spacing
                                        child: Text(
                                          '  FREE',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Regular',
                                            fontWeight: FontWeight.bold,
                                            color:
                                                GlobalVariables.blueTextColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 20, bottom: 10),
                              child: Row(
                                children: [
                                  const Text("Grand Total",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular')),
                                  const Spacer(),
                                  // CartTotal(),
                                  Text(
                                      '₹${widget.order!.totalPrice + handelingCharge}',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Regular',
                                          color:
                                              GlobalVariables.faintBlackColor))
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                ClipPath(
                                  clipper: SineWaveClipper(
                                    amplitude: 3,
                                    frequency: 15,
                                  ),
                                  child: DecoratedBox(
                                    decoration: const BoxDecoration(),
                                    child: Container(
                                      width: double.infinity,
                                      height: 70, // Adjust the height as needed

                                      decoration: const BoxDecoration(
                                          color: GlobalVariables.savingColor,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight:
                                                  Radius.circular(15))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Positioned(
                                            top:
                                                19, // Adjust this value to position the text correctly
                                            left: 20,
                                            right: 10,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Total savings",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: GlobalVariables
                                                        .blueTextColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Regular',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top:
                                                35, // Adjust this value to position the text correctly
                                            left: 20,
                                            right: 10,
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Includes 10 savings through free delivery",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: GlobalVariables
                                                          .lightBlueTextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Text(
                                        '₹${widget.order!.totalSave + 10 + 150}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: GlobalVariables.blueTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
