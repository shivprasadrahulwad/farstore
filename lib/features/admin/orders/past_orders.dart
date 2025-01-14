import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/orders/orders_details_screen.dart';
import 'package:farstore/features/admin/orders/orders_services.dart';
import 'package:farstore/models/order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastOrdersScreen extends StatefulWidget {
  static const String routeName = '/history';
  @override
  _PastOrdersScreenState createState() => _PastOrdersScreenState();
}

class _PastOrdersScreenState extends State<PastOrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;
  final OrderServices orderServices = OrderServices();

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch all orders
      List<Order> allOrders = await orderServices.fetchAllOrders(context);

      // Filter orders where status is less than 3
      _orders = allOrders.where((order) => order.status == 3).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String formatOrderDate(DateTime orderDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    // Check if the order date is today
    if (orderDate.isAfter(today)) {
      return 'Today, ${DateFormat('hh.mm a').format(orderDate)}';
    }
    // Check if the order date is yesterday
    else if (orderDate.isAfter(yesterday)) {
      return 'Yesterday, ${DateFormat('hh.mm a').format(orderDate)}';
    }
    // If the order date is older than yesterday
    else {
      return DateFormat('dd MMM yyyy, hh.mm a').format(orderDate);
    }
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Accepted';
      case 1:
        return 'Preparing';
      case 2:
        return 'Ready';
      case 3:
        return 'Delivered';
      default:
        return 'Unknown'; // Fallback text for any undefined status
    }
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.red; // Status 0 - Red
      case 1:
        return Colors.orange; // Status 1 - Orange
      case 2:
        return Colors.yellow; // Status 2 - Yellow
      case 3:
        return Colors.green; // Status 3 - Green
      default:
        return Colors.black; // Fallback color for any undefined status
    }
  }

  String convertIdToOrderId(String id) {
    String shortId = id.substring(0, 8);
    return 'ORD-$shortId';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/orders');
          },
        ),
        title: const Text(
          'Past Orders',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Regular',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: ListView.builder(
                        itemCount: _orders.length,
                        itemBuilder: (context, index) {
                          final orderData = _orders[index];
                          final orderDates =
                              DateTime.fromMillisecondsSinceEpoch(
                                  orderData.orderedAt);
                          final formattedDate = formatOrderDate(orderDates);
                          final formattedOrderId =
                              convertIdToOrderId(orderData.id);

                          return Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  margin: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: const BoxDecoration(
                                              color: GlobalVariables
                                                  .blueBackground,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                                Icons.shopping_bag,
                                                color: GlobalVariables
                                                    .blueTextColor),
                                          ),
                                          const SizedBox(width: 12.0),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Order is ${getStatusText(orderData.status)}',
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontFamily: 'SemiBold',
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '₹${orderData.totalPrice}',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Regular',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Center(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      child: const SizedBox(
                                                        height: 5,
                                                        width: 5,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    '$formattedDate',
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: 'Regular',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          // Container(
                                          //   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                                          //   decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.circular(10),
                                          //     border: Border.all(
                                          //       color: orderData.status == 3 ? Colors.green : Colors.blue,
                                          //     ),
                                          //     color: Colors.white,
                                          //   ),
                                          //   child: Text(
                                          //     orderData.status == 0 ? 'Active' : 'Completed',
                                          //     style: TextStyle(
                                          //       color: orderData.status == 3 ? Colors.green : Colors.blue,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              SizedBox(width: 8.0),
                                              Expanded(
                                                child: Divider(
                                                  color: Colors.grey,
                                                  thickness: 1.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    height:
                                                        8, // Set the height of the circle
                                                    width:
                                                        8, // Set the width of the circle
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: getStatusColor(
                                                          orderData
                                                              .status), // Use the status color for the circle
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          4), // Space between the circle and text
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 3.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors
                                                          .white, // White background without a border
                                                    ),
                                                    child: Text(
                                                      getStatusText(orderData
                                                          .status), // Call to get the status text based on the current status
                                                      style: TextStyle(
                                                        fontFamily: 'Regular',
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: getStatusColor(
                                                            orderData
                                                                .status), // Call to get the text color based on the current status
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    OrderDetailScreen.routeName,
                                                    arguments: orderData,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    const Text(
                                                      'View details',
                                                      style: TextStyle(
                                                        color: GlobalVariables
                                                            .greenColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Transform.rotate(
                                                      angle: 270 *
                                                          (3.14159265359 / 180),
                                                      child: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: GlobalVariables
                                                            .greenColor,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
    );
  }
}
