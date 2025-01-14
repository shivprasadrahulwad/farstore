import 'package:farstore/features/admin/orders/orders_screen.dart';
import 'package:farstore/features/user/home_screen.dart';
import 'package:farstore/sales/sales_home_screen.dart';
import 'package:farstore/shop_setup/shop_setup_screen.dart';
import 'package:flutter/material.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  // Add your screens here
  final List<Widget> _screens = [
    const HomeScreen(shopCode: '234567'),
    OrdersScreen(),
    const SalesScreen(
      shopCode: '123456',
    ),
    ShopSetupScreen(
      onChargesUpdated: (charges) {},
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Theme(
         data: Theme.of(context).copyWith(
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: Colors.white, // Background of the NavigationBar
            indicatorColor: Colors.teal, // Color of the selected indicator
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Colors.teal,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: MaterialStateProperty.resolveWith(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return const IconThemeData(color: Colors.teal);
                }
                return const IconThemeData(color: Colors.grey);
              },
            ),
          ),
         ),
        child: NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Image.asset(
                'assets/images/store-alt.png',
                width: 24,
                height: 24,
              ),
              label: 'Store',
            ),
            NavigationDestination(
              icon: Image.asset(
                'assets/images/orders.png',
                width: 24,
                height: 24,
              ),
              label: 'Orders',
            ),
            NavigationDestination(
              icon: Image.asset(
                'assets/images/chart-histogram.png',
                width: 24,
                height: 24,
              ),
              label: 'Analytics',
            ),
            NavigationDestination(
              icon: Image.asset(
                'assets/images/settings.png',
                width: 24,
                height: 24,
              ),
              label: 'setting',
            ),
          ],
        ),
      ),
    );
  }
}
