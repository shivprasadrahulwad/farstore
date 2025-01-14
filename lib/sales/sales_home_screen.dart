// ignore_for_file: dead_code

import 'dart:async';

import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/admin/orders/orders_services.dart';
import 'package:farstore/models/order.dart';
import 'package:farstore/providers/user_provider.dart';
import 'package:farstore/sales/bar_graph/bar_chart_helper.dart';
import 'package:farstore/sales/radial_graph/radial_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  static const String routeName = '/sales';
  final String shopCode;
  const SalesScreen({Key? key, required this.shopCode}) : super(key: key);

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String currentHint = 'Search Fruits';
  bool _isFloatingContainerOpen = false;
  List<Map<String, dynamic>> carts = [];
  int ordersStatus0Today = 0;
  int ordersStatus1Today = 0;
  int ordersStatus2Today = 0;
  int ordersStatus3Today = 0;
  int totalOrdersCurrentWeek = 0;
  int ordersStatus0CurrentWeek = 0;
  int ordersStatus1CurrentWeek = 0;
  int ordersStatus2CurrentWeek = 0;
  int ordersStatus3CurrentWeek = 0;
  int ordersStatus0CurrentWeekTotal = 0;
  int ordersStatus1CurrentWeekTotal = 0;
  int ordersStatus2CurrentWeekTotal = 0;
  int ordersStatus3CurrentWeekTotal = 0;

  List<Order>? orders;
  double todayCostumerGrowth = 0;
  double totayRevenueGrowth = 0;
  double todayOrderGrowth = 0;
  double totalRevenueToday = 0;
  double weeklyGrowth = 0;
  int totalOrdersToday = 0;
  int uniqueCustomersToday = 0;
  int totalOrdersYesterday = 0;
  double totalRevenueYesterday = 0;
  int uniqueCustomersYesterday = 0;
  List<int> weeklyOrders = List<int>.filled(7, 0); // Initialize with zeros
  int totalWeeklyOrders = 0;
  int selectedIndex = 0;

  //-----------------
  DateTime? startDate;
  DateTime? endDate;
  int totalOrders = 0;
  int ordersStatus0 = 0;
  int ordersStatus1 = 0;
  int ordersStatus2 = 0;
  int ordersStatus3 = 0;
  double totalRevenueCustom = 0.0;

  @override
  void initState() {
    super.initState();
    fetchOrdersForToday(
        widget.shopCode); // Replace '1234' with your actual shopId
  }

  fetchOrdersForToday(String shopId) async {
    OrderServices orderServices = OrderServices();
    orders = await orderServices.fetchOrdersForToday(context, shopId);
    calculateRevenueAndOrders();
    calculateWeeklyOrders();
    setState(() {});
  }

  ////------------------------------------

Future<void> _selectDateRange(BuildContext context) async {
  final picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.teal, // Custom primary color
          colorScheme: const ColorScheme.light(
            primary: Colors.teal, // Header and selected dates
            onPrimary: Colors.white, // Text color on header
            surface: Colors.tealAccent, // Header background
          ),
          scaffoldBackgroundColor: Colors.white, // Background color
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.black), // Text color
            bodyText2: TextStyle(color: Colors.black87),
            caption: TextStyle(color: Colors.grey),
          ),
          buttonTheme: const ButtonThemeData(
            textTheme: ButtonTextTheme.primary,
            buttonColor: Colors.teal, // Button color
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() {
      startDate = picked.start;
      endDate = picked.end;
    });
    _calculateTotalsForDateRange();
  }
}



  void _calculateForPresetRange(int index) {
    DateTime today = DateTime.now();

    setState(() {
      if (index == 0) {
        // Today
        startDate = today;
        endDate = today;
      } else if (index == 1) {
        // Last 7 days
        startDate = today.subtract(const Duration(days: 7));
        endDate = today;
      } else if (index == 2) {
        // Last 30 days
        startDate = today.subtract(const Duration(days: 30));
        endDate = today;
      }
    });

    _calculateTotalsForDateRange();
  }

  void _calculateTotalsForDateRange() {
    if (startDate == null || endDate == null) return;

    // Simulate filtering orders (replace with your actual orders list and logic)
    List<Order> filteredOrders = orders!.where((order) {
      DateTime orderDate = DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
      return orderDate.isAfter(startDate!.subtract(const Duration(days: 1))) &&
          orderDate.isBefore(endDate!.add(const Duration(days: 1)));
    }).toList();

    setState(() {
      totalOrders = filteredOrders.length;
      totalRevenueCustom =
          filteredOrders.fold(0.0, (sum, order) => sum + order.totalPrice);
      ordersStatus0 = filteredOrders.where((order) => order.status == 0).length;
      ordersStatus1 = filteredOrders.where((order) => order.status == 1).length;
      ordersStatus2 = filteredOrders.where((order) => order.status == 2).length;
      ordersStatus3 = filteredOrders.where((order) => order.status == 3).length;
    });

    RadialBarChartWidget radialBarChartWidget = RadialBarChartWidget(
      status0Count: ordersStatus0,
      status1Count: ordersStatus1,
      status2Count: ordersStatus2,
      status3Count: ordersStatus3,
    );
  }

//---------------------------

  void calculateRevenueAndOrders() {
    if (orders != null && orders!.isNotEmpty) {
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);
      DateTime endOfDay =
          DateTime(today.year, today.month, today.day, 23, 59, 59);

      List<Order> filteredOrdersToday = orders!.where((order) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
        return order.shopId == widget.shopCode &&
            orderDate.isAfter(startOfDay) &&
            orderDate.isBefore(endOfDay);
      }).toList();

      setState(() {
        ordersStatus0Today =
            filteredOrdersToday.where((order) => order.status == 0).length;
        ordersStatus1Today =
            filteredOrdersToday.where((order) => order.status == 1).length;
        ordersStatus2Today =
            filteredOrdersToday.where((order) => order.status == 2).length;
        ordersStatus3Today =
            filteredOrdersToday.where((order) => order.status == 3).length;
      });

      // if (selectedIndex == 0)
      //   RadialBarChartWidget radialBarChartWidget = RadialBarChartWidget(
      //     status0Count: ordersStatus0Today,
      //     status1Count: ordersStatus1Today,
      //     status2Count: ordersStatus2Today,
      //     status3Count: ordersStatus3Today,
      //   );

      totalOrdersToday = filteredOrdersToday.length;
      totalRevenueToday =
          filteredOrdersToday.fold(0, (sum, order) => sum + order.totalPrice);

      Set<String> uniqueUserIdsToday =
          filteredOrdersToday.map((order) => order.userId).toSet();
      uniqueCustomersToday = uniqueUserIdsToday.length;

      DateTime yesterday = today.subtract(const Duration(days: 1));
      startOfDay = DateTime(yesterday.year, yesterday.month, yesterday.day);
      endOfDay =
          DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);

      List<Order> filteredOrdersYesterday = orders!.where((order) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
        return order.shopId == widget.shopCode &&
            orderDate.isAfter(startOfDay) &&
            orderDate.isBefore(endOfDay);
      }).toList();

      totalOrdersYesterday = filteredOrdersYesterday.length;
      totalRevenueYesterday = filteredOrdersYesterday.fold(
          0, (sum, order) => sum + order.totalPrice);

      Set<String> uniqueUserIdsYesterday =
          filteredOrdersYesterday.map((order) => order.userId).toSet();
      uniqueCustomersYesterday = uniqueUserIdsYesterday.length;

      todayOrderGrowth = totalOrdersYesterday != 0
          ? ((totalOrdersToday - totalOrdersYesterday) / totalOrdersYesterday) *
              100
          : (totalOrdersToday > 0 ? 100 : 0);

      totayRevenueGrowth = totalRevenueYesterday != 0
          ? ((totalRevenueToday - totalRevenueYesterday) /
                  totalRevenueYesterday) *
              100
          : (totalRevenueToday > 0 ? 100 : 0);

      todayCostumerGrowth = uniqueCustomersYesterday != 0
          ? ((uniqueCustomersToday - uniqueCustomersYesterday) /
                  uniqueCustomersYesterday) *
              100
          : (uniqueCustomersToday > 0 ? 100 : 0);

      print(
          "Today's orders and revenue calculated successfully. ${totalOrdersToday}");
    } else {
      print("No orders found.");
    }
  }

  void calculateWeeklyOrders() {
    if (orders != null) {
      // Initialize lists to hold the count of orders for each day of the current and last week
      List<int> ordersPerDayCurrentWeek = List<int>.filled(7, 0);
      List<int> ordersPerDayLastWeek = List<int>.filled(7, 0);
      int totalOrdersCurrentWeek = 0;
      int totalOrdersLastWeek = 0;
      // Get today's date
      DateTime today = DateTime.now();

      // Calculate the start of the current week (Monday)
      DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
      // Calculate the start of the last week (Monday)
      DateTime startOfLastWeek = startOfWeek.subtract(const Duration(days: 7));

      // Filter orders by shopCode for the current week
      List<Order> filteredOrdersCurrentWeek = orders!.where((order) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
        return order.shopId == widget.shopCode &&
            orderDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
            orderDate.isBefore(today.add(const Duration(days: 1)));
      }).toList();

      // Filter orders by shopCode for the last week
      List<Order> filteredOrdersLastWeek = orders!.where((order) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
        return order.shopId == widget.shopCode &&
            orderDate
                .isAfter(startOfLastWeek.subtract(const Duration(days: 1))) &&
            orderDate.isBefore(startOfWeek);
      }).toList();

      // Count orders for each day in the current week
      for (var order in filteredOrdersCurrentWeek) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
        int dayIndex = (orderDate.weekday - 1) % 7;
        ordersPerDayCurrentWeek[dayIndex]++;
        totalOrdersCurrentWeek++;
      }

      // Count orders for each day in the last week
      for (var order in filteredOrdersLastWeek) {
        DateTime orderDate =
            DateTime.fromMillisecondsSinceEpoch(order.orderedAt);
        int dayIndex = (orderDate.weekday - 1) % 7;
        ordersPerDayLastWeek[dayIndex]++;
        totalOrdersLastWeek++;

        switch (order.status) {
          case 0:
            ordersStatus0CurrentWeek++;
            break;
          case 1:
            ordersStatus1CurrentWeek++;
            break;
          case 2:
            ordersStatus2CurrentWeek++;
            break;
          case 3:
            ordersStatus3CurrentWeek++;
            break;
        }
      }

      setState(() {
        weeklyOrders = ordersPerDayCurrentWeek;
        totalWeeklyOrders = totalOrdersCurrentWeek;
        totalOrdersLastWeek = totalOrdersLastWeek;
        weeklyGrowth = (totalOrdersCurrentWeek -
                totalOrdersLastWeek / totalOrdersLastWeek) *
            100;
        ordersStatus0CurrentWeekTotal = ordersStatus0CurrentWeek;
        ordersStatus1CurrentWeekTotal = ordersStatus1CurrentWeek;
        ordersStatus2CurrentWeekTotal = ordersStatus2CurrentWeek;
        ordersStatus3CurrentWeekTotal = ordersStatus3CurrentWeek;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    if (carts.isNotEmpty && !_isFloatingContainerOpen) {
      setState(() {
        _isFloatingContainerOpen = true;
      });
    }

    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color:
                        // Colors.grey.withOpacity(0.4), // Set background color here
                        Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.shopCode}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SemiBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                  // Text(context.formatString(LocalData.body, ["Shiv"]),),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                "8 minutes",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25,
                                                  fontFamily: 'SemiBold',
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 245, 255, 233),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Icon(
                                                  Icons.trending_up,
                                                  color: Colors
                                                      .green, // Icon color
                                                  size:
                                                      32.0, // Optional: size of the icon
                                                ),
                                              )
                                            ],
                                          ),
                                          const Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: ' SHOP - ',
                                                  style: TextStyle(
                                                    fontFamily: 'SemiBold',
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      'Shiv, Behind Apurv Hospital, Nanded',
                                                  style: TextStyle(
                                                    fontFamily: 'Medium',
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, '/account');
                                            },
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Icon(
                                                Icons.account_circle,
                                                color: Colors.black,
                                                size: 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            'https://res.cloudinary.com/dybzzlqhv/image/upload/v1720875098/vegetables/swya6iwpohlynuq1r9td.gif',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  // Container titles
                  final titles = ['Today', '7 Days', '30 Days', 'Custom'];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index; // Update selected index
                        });
                        if (index == 3) {
                          _selectDateRange(context);
                        } else {
                          _calculateForPresetRange(index);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          width: 70,
                          height: 40,
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Colors.grey
                                : Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              titles[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: GlobalVariables.blueBackground,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/indian-rupee-sign.png',
                                  width: 15,
                                  height: 15,
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Today Revenue",
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.greyTextColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      '${(totalRevenueCustom).toInt()}',
                                      style: const TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Container(
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF82D2BA),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.arrow_outward,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '25%',
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      // height: 450,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Task Progress',
                                  style: TextStyle(
                                      fontFamily: 'Regular',
                                      color: Colors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                RadialBarChartWidget(
                                  status0Count: ordersStatus0,
                                  status1Count: ordersStatus1,
                                  status2Count: ordersStatus2,
                                  status3Count: ordersStatus3,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 60,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Accepted',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${ordersStatus0}',
                                              style: const TextStyle(
                                                  fontFamily: 'Regular',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        width: 120,
                                        height: 60,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Ready',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${ordersStatus1}',
                                              style: const TextStyle(
                                                  fontFamily: 'Regular',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        width: 120,
                                        height: 60,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Delivered',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${ordersStatus2}',
                                              style: const TextStyle(
                                                  fontFamily: 'Regular',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        width: 120,
                                        height: 60,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Canceled',
                                              style: TextStyle(
                                                fontFamily: 'Regular',
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${ordersStatus3}',
                                              style: const TextStyle(
                                                  fontFamily: 'Regular',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 400,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              top: 20,
                              bottom: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   children: [
                                //     const Text(
                                //   'Total:',
                                //   style: TextStyle(
                                //     fontFamily: 'Regular',
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),

                                // Text(
                                //   ' ${totalWeeklyOrders}',
                                //   style: const TextStyle(
                                //     fontFamily: 'Regular',
                                //     fontSize: 20  ,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                //   ],
                                // ),
                                const SizedBox(height: 5),
                                Expanded(
                                  child: MyBargraph(
                                    weeklyOrders: weeklyOrders,
                                    totalWeeklyOrders: totalWeeklyOrders,
                                    weeklyGrowth: weeklyGrowth,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: GlobalVariables.blueBackground,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: const Icon(
                                Icons.shopping_bag_rounded,
                                size: 20,
                                color: GlobalVariables.blueTextColor,
                              ),
                            ),
                            const SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Total order",
                                  style: TextStyle(
                                    fontFamily: 'Regular',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: GlobalVariables.greyTextColor,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      totalOrders.toString(),
                                      style: const TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Container(
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF82D2BA),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.arrow_outward,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '98%',
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Row(children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: const BoxDecoration(
                                color: GlobalVariables.blueBackground,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/users.png',
                                  color: GlobalVariables.blueTextColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Customers",
                                  style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: GlobalVariables.greyTextColor),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      uniqueCustomersToday.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Regular',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 30),
                                    Container(
                                      height: 15,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xFF82D2BA),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Icon(
                                          Icons.arrow_outward,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      '100%',
                                      style: TextStyle(
                                        fontFamily: 'Regular',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
