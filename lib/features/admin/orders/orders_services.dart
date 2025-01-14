import 'dart:convert';
import 'package:farstore/constants/error_handeling.dart';
import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/constants/utils.dart';
import 'package:farstore/models/order.dart';
import 'package:farstore/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderServices {
//admin fetch alll orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    List<Order> orderList = [];
    String shopId = adminProvider.admin.shopCode;

    print('Order services called: Starting the fetch process');
    print('Shop ID being used for fetching orders: $shopId');

    try {
      final uris = Uri.parse('$uri/admin/get-orders/$shopId');
      print('Constructed URI: $uris');

      final response = await http.get(
        uris,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': adminProvider.admin.token,
        },
      );

      print('HTTP response status code: ${response.statusCode}');
      print('HTTP response body: ${response.body}');

      if (response.statusCode == 200) {
        final ordersJson = jsonDecode(response.body) as List<dynamic>;
        orderList =
            ordersJson.map((orderJson) => Order.fromMap(orderJson)).toList();
        print('Successfully fetched ${orderList.length} orders');
      } else if (response.statusCode == 404) {
        print('No orders found for this shop');
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching orders: $e');
      rethrow; // Rethrow to handle in the UI
    }

    return orderList;
  }

  //admin change order status
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': adminProvider.admin.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );
      print(
          '---------------------------------------------order status changes ');

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<int> fetchOrderStatus({
    required BuildContext context,
    required String orderId,
  }) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/order-status/$orderId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': adminProvider.admin.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );

      var jsonResponse = jsonDecode(res.body);
      return jsonResponse['status'];
    } catch (e) {
      showSnackBar(context, e.toString());
      return -1; // Return an invalid status to indicate an error
    }
  }

  Future<List<Order>> fetchOrdersForToday(
      BuildContext context, String shopId) async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    List<Order> orderList = [];

    try {
      final String todayDate = DateTime.now().toIso8601String().split('T')[0];

      print("Fetching orders for Date: $todayDate and shop ID: $shopId");

      final url =
          Uri.parse('$uri/admin/get-orders?date=$todayDate&shopId=$shopId');
      print("Request URL: $url");

      http.Response res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': adminProvider.admin.token,
        },
      );

      print("Response Status Code: ${res.statusCode}");
      print("Response Body: ${res.body}");

      if (res.statusCode == 200) {
        List<dynamic> responseJson = jsonDecode(res.body);
        orderList = responseJson.map((json) => Order.fromMap(json)).toList();
        print("Fetched Orders: $orderList");
      } else {
        print(
            "Failed to fetch orders. Status Code: ${res.statusCode}"); // Debug statement
        throw Exception('Failed to fetch orders');
      }
    } catch (e) {
      print("Error fetching orders: $e");
      showSnackBar(context, 'Error fetching orders: $e');
    }

    return orderList;
  }
}
