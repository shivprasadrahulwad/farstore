import 'package:farstore/shop_setup/hive_storage/store_hive_services.dart';
import 'package:farstore/widgets/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class LoadStoreDataScreen extends StatefulWidget {
  const LoadStoreDataScreen({Key? key}) : super(key: key);

  @override
  _LoadStoreDataScreenState createState() => _LoadStoreDataScreenState();
}

class _LoadStoreDataScreenState extends State<LoadStoreDataScreen> {
  bool _isLoading = true;
  String _loadingMessage = 'Initializing store data...';

  @override
  void initState() {
    super.initState();
    _initializeStoreData();
  }


Future<void> _initializeStoreData() async {
  try {
    // Create StoreHiveService with the current context
    final storeHiveService = StoreHiveService(context);

    // Update loading state
    setState(() {
      _loadingMessage = 'Initializing coupons...';
    });

    // Initialize coupons in Hive
    await storeHiveService.initCouponHive();

    // Update loading state
    setState(() {
      _loadingMessage = 'Initializing offer descriptions...';
    });

    // Initialize offer descriptions in Hive
    await storeHiveService.initOfferDesHive();

    // Update loading state for categories
    setState(() {
      _loadingMessage = 'Initializing categories...';
    });

    // Initialize categories in Hive
    await storeHiveService.initCategoryHive();

    setState(() {
      _loadingMessage = 'Initializing delivery charges...';
    });

    // Initialize charges in Hive
    await storeHiveService.initChargesHive();

    // Update loading state
    setState(() {
      _loadingMessage = 'Store data loaded successfully!';
      _isLoading = false;
    });

    // Navigate to the home screen
    _navigateToHomeScreen();
  } catch (e) {
    // Handle initialization errors
    setState(() {
      _loadingMessage = 'Error loading store data. Please try again.';
      _isLoading = false;
    });

    // Show error dialog or snackbar
    _showErrorDialog(e.toString());
  }
}

  void _navigateToHomeScreen() {
    // Replace with your actual navigation logic
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NavigationMenu()),
    );
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Optionally retry initialization
              _initializeStoreData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            
            // Loading message
            Text(
              _loadingMessage,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}