import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/orders/order_settings_screen.dart';
import 'package:farstore/features/admin/orders/orders_details_screen.dart';
import 'package:farstore/features/admin/orders/orders_services.dart';
import 'package:farstore/models/bestProducts.dart';
import 'package:farstore/models/order.dart';
import 'package:farstore/models/orderHive.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> _orders = [];
  bool _isLoading = true;
  String? _error;
  final OrderServices orderServices = OrderServices();
  late Box<OrderHive> _orderHiveBox;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    try {
      // Open Hive box for OrderHive
      _orderHiveBox = await Hive.openBox<OrderHive>('orderBox');
      // After initializing Hive, fetch orders
      await fetchOrders();
    } catch (e) {
      print('Error initializing Hive: $e');
      setState(() {
        _error = 'Failed to initialize local storage';
      });
    }
  }

  Future<void> fetchOrders() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Fetch orders from the server
      List<Order> allOrders = await orderServices.fetchAllOrders(context);

      // Filter orders where status < 3
      _orders = allOrders.where((order) => order.status < 3).toList();

      // Store orders in Hive
      await _storeOrdersInHive(_orders);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching orders: $e');
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }

      // If server fetch fails, try to load from Hive
      await _loadOrdersFromHive();
    }
  }

  Future<void> _storeOrdersInHive(List<Order> orders) async {
    try {
      for (var order in orders) {
        // Check if the order already exists in Hive
        if (!_orderHiveBox.containsKey(order.id)) {
          final hiveOrder = OrderHive(
            orderId: order.id,
            status: order.status,
          );
          await _orderHiveBox.put(order.id, hiveOrder);
          print(
              'Stored in Hive: Order ID - ${order.id}, Status - ${order.status}');
        } else {
          print('Order ${order.id} already exists in Hive. Skipping storage.');
        }
      }
    } catch (e) {
      print('Error storing orders in Hive: $e');
    }
  }

  Future<void> _loadOrdersFromHive() async {
    try {
      final hiveOrders = _orderHiveBox.values.toList();
      print('Loaded ${hiveOrders.length} orders from Hive');

      // Update the UI with orders from Hive
      if (mounted && _orders.isEmpty) {
        setState(() {
          // You might need to convert OrderHive back to Order here
          // depending on your UI requirements
        });
      }
    } catch (e) {
      print('Error loading orders from Hive: $e');
    }
  }

  Future<void> _updateOrderStatusInHive(String orderId, int newStatus) async {
    try {
      final existingOrder = _orderHiveBox.get(orderId);
      if (existingOrder != null) {
        existingOrder.updateStatus(newStatus);
        await existingOrder.save();
        print('Updated order status in Hive: $orderId -> $newStatus');
      }
    } catch (e) {
      print('Error updating order status in Hive: $e');
    }
  }

  Future<void> _handleOrderStatusUpdate(Order order, int newStatus) async {
    try {
      // Update order status in Hive
      await _updateOrderStatusInHive(order.id, newStatus);

      // Optionally, you might want to refresh the orders or update the UI
      setState(() {
        // Find and update the order in the _orders list
        final index = _orders.indexWhere((o) => o.id == order.id);
        if (index != -1) {
          _orders[index] = order.copyWith(status: newStatus);
        }
      });

      // Optional: Show a snackbar to confirm status update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order status updated to ${getStatusText(newStatus)}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error updating order status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order status: $e'),
          backgroundColor: Colors.red,
        ),
      );
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


  Future<void> updateBestProductInHive(BestProduct bestProduct) async {
  var box = await Hive.openBox<BestProduct>('bestProductsBox');

  // Check if the product already exists
  var existingBestProduct = box.values.firstWhere(
    (p) => p.name == bestProduct.name,
    orElse: () => BestProduct(
      name: bestProduct.name,
      quantity: 0,
      basePrice: null,
      sellingPrice: null,
      discountPrice: null,
    ),
  );

  if (existingBestProduct.name == bestProduct.name) {
    // If product exists, update quantity
    existingBestProduct.quantity += bestProduct.quantity;

    // Update the sum fields
    existingBestProduct.basePrice = (existingBestProduct.basePrice ?? 0) + (bestProduct.basePrice ?? 0);
    existingBestProduct.sellingPrice = (existingBestProduct.sellingPrice ?? 0) + (bestProduct.sellingPrice ?? 0);
    existingBestProduct.discountPrice = (existingBestProduct.discountPrice ?? 0) + (bestProduct.discountPrice ?? 0);

    // Update the product in the box with put
    await box.put(existingBestProduct.name, existingBestProduct);
  } else {
    // If product doesn't exist, add a new product
    await box.put(bestProduct.name, bestProduct);
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

  Future<void> syncOrderStatusesWithServer() async {
    try {
      // Get all modified orders from Hive
      final modifiedOrders = _orderHiveBox.values.toList();

      // Check if there are any orders to sync
      if (modifiedOrders.isEmpty) {
        print('No orders to sync');
        return;
      }

      // Track sync results
      int successCount = 0;
      int failureCount = 0;

      // Use Future.wait to synchronize server updates
      await Future.wait(modifiedOrders.map((hiveOrder) async {
        // Find the corresponding Order object from _orders
        final orderToUpdate = _orders.firstWhere(
          (order) => order.id == hiveOrder.orderId,
          // orElse: () => null,
        );

        if (orderToUpdate != null) {
          try {
            // Await server status update for each order
            orderServices.changeOrderStatus(
              context: context,
              status: hiveOrder.status,
              order: orderToUpdate,
              onSuccess: () {},
            );

            successCount++;
            print(
                'Synced order ${orderToUpdate.id} with status ${hiveOrder.status}');
          } catch (e) {
            failureCount++;
            print('Failed to sync order ${orderToUpdate.id}: $e');
          }
        }
      }));

      // Show summary of sync operation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Order Sync Complete: $successCount successful, $failureCount failed'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      print('Error syncing order statuses: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sync order statuses: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Close the Hive box when disposing
    _orderHiveBox.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Orders',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Regular',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSettingsScreen(
                    onSave: (settings) {
                      // Handle saved settings
                    },
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black),
            onPressed: () {
              // Add your history button functionality here
              Navigator.pushNamed(
                  context, '/history'); // Example route to history screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.sync, color: Colors.black),
            onPressed: syncOrderStatusesWithServer,
          ),
        ],
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
                          final orderProducts = orderData.products;
                          final orderDates =
                              DateTime.fromMillisecondsSinceEpoch(
                                  orderData.orderedAt);
                          final formattedDate = formatOrderDate(orderDates);
                          final formattedOrderId =
                              convertIdToOrderId(orderData.id);
                          for (var product in orderProducts) {
                            final bestProductToUpdate = BestProduct(
                              name: product.name,
                              quantity: orderData.quantity[0],
                              discountPrice: product.discountPrice!.toDouble(),
                              basePrice: product.price.toDouble(),
                              sellingPrice: 0
                            );
                            debugPrint(
                                "---Updating BestProduct: ${bestProductToUpdate.name}, Quantity: ${bestProductToUpdate.quantity}, Total Amount: ${bestProductToUpdate.discountPrice}");
                            updateBestProductInHive(bestProductToUpdate);
                          }

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
                                          PopupMenuButton<int>(
                                            icon: const Icon(Icons.more_vert),
                                            itemBuilder: (context) => [
                                              // Only show status options that are different from current status
                                              if (orderData.status != 0)
                                                PopupMenuItem(
                                                  value: 0,
                                                  child: Text(getStatusText(0)),
                                                ),
                                              if (orderData.status != 1)
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Text(getStatusText(1)),
                                                ),
                                              if (orderData.status != 2)
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Text(getStatusText(2)),
                                                ),
                                              if (orderData.status != 3)
                                                PopupMenuItem(
                                                  value: 3,
                                                  child: Text(getStatusText(3)),
                                                ),
                                            ],
                                            onSelected: (int newStatus) {
                                              // Handle status update
                                              _handleOrderStatusUpdate(
                                                  orderData, newStatus);
                                              syncOrderStatusesWithServer();
                                            },
                                          ),
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
                                                  ValueListenableBuilder(
                                                    valueListenable:
                                                        _orderHiveBox
                                                            .listenable(),
                                                    builder: (context,
                                                        Box<OrderHive> box, _) {
                                                      final hiveOrder =
                                                          box.get(orderData.id);
                                                      if (hiveOrder != null) {
                                                        final hiveStatus =
                                                            hiveOrder.status;
                                                        return Row(
                                                          children: [
                                                            Container(
                                                              height: 8,
                                                              width: 8,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: getStatusColor(
                                                                    hiveStatus),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 3.0,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Text(
                                                                getStatusText(
                                                                    hiveStatus),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Regular',
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: getStatusColor(
                                                                      hiveStatus),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      } else {
                                                        // Fallback to show default status if Hive data is not available
                                                        return Row(
                                                          children: [
                                                            Container(
                                                              height: 8,
                                                              width: 8,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: getStatusColor(
                                                                    orderData
                                                                        .status),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 3.0,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              child: Text(
                                                                getStatusText(
                                                                    orderData
                                                                        .status),
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Regular',
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: getStatusColor(
                                                                      orderData
                                                                          .status),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () async {
                                                  // await _updateOrderStatusInHive(
                                                  //   orderData.id,
                                                  //   orderData.status,
                                                  // );
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
                                              ),
                                            ],
                                          )
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
