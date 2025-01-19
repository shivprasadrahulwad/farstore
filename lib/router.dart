import 'package:farstore/features/admin/account/screens/account_screen.dart';
import 'package:farstore/features/admin/orders/orders_details_screen.dart';
import 'package:farstore/features/admin/orders/orders_screen.dart';
import 'package:farstore/features/admin/orders/past_orders.dart';
import 'package:farstore/features/admin/screens/add_product_screen.dart';
import 'package:farstore/features/admin/screens/category_screen.dart';
import 'package:farstore/features/admin/screens/edit_info.dart';
import 'package:farstore/features/admin/screens/home_screen.dart';
import 'package:farstore/features/admin/screens/sales_screen.dart';
import 'package:farstore/features/auth/screens/sample.dart';
import 'package:farstore/features/auth/screens/signin_screeen.dart';
import 'package:farstore/features/auth/screens/signup_screen.dart';
import 'package:farstore/features/user/home_screen.dart';
import 'package:farstore/models/order.dart';
import 'package:farstore/models/product.dart';
import 'package:farstore/sales/sales_home_screen.dart';
import 'package:farstore/scanner/qr_create_screen.dart';
import 'package:farstore/shop_setup/categories_setup_screen.dart';
import 'package:farstore/shop_setup/charges_screen.dart';
import 'package:farstore/shop_setup/coupon/coupon_screen.dart';
import 'package:farstore/shop_setup/offers/offers_screen.dart';
import 'package:farstore/shop_setup/shop_setup_screen.dart';
import 'package:farstore/welcome/shop_details_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case SignInScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignInScreen(),
      );

    case SignUpScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen(),
      );

    case HomeScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(shopCode: '',),
      );

    case PastOrdersScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => PastOrdersScreen(),
      );  
  

    case OrdersScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrdersScreen(),
      );

    case ShopDetailsScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ShopDetailsScreen(),
      );

    case ShopSetupScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ShopSetupScreen(
      onChargesUpdated: (charges) {
        // Handle charges update here
      },
    ),
      );

    case OffersScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const OffersScreen(),
      );

    case ChargesScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ChargesScreen(),
      );  



    case CouponScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CouponScreen(),
      );    

    case CategoriesSetupScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const CategoriesSetupScreen(),
      );

    // case ShopInfoDisplay.routeName: // Use the static route name
    //   return MaterialPageRoute(
    //     settings: routeSettings,
    //     builder: (_) => ShopInfoDisplay(),
    //   );          

    case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(order: order),
      );
   

    case AddProductScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );

    case SalesScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SalesScreen(shopCode: '',),
      );

    case QRCreateScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => QRCreateScreen(),
      );  

    case AccountScreen.routeName: // Use the static route name
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AccountScreen(),
      );      

    case EditProductScreen.routeName: // Use the static route name
      final product = routeSettings.arguments
          as Product; // Cast the argument to your product class
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => EditProductScreen(product: product, onProductUpdated: (Product ) {  },),
      );

    case CategoryScreen.routeName:
      var args = routeSettings.arguments as Map<String, dynamic>?;
      if (args == null) {
        print('Error: Arguments are null for shopScreen');
        return _errorRoute('Arguments are null for shopScreen');
      }
      var category = args['category'];
      var shopCode = args['shopCode'];

      if (category == null || shopCode == null) {
        print('Error: Category or shopCode is null');
        return _errorRoute('Category or shopCode is null');
      }

      print(
          'Navigating to shopScreen with category: $category and userId: $shopCode');
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryScreen(category: category, shopCode: '',),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text("Screen doesn't exist!"),
          ),
        ),
      );
  }
}

Route<dynamic> _errorRoute(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Text('Error: $message'),
      ),
    ),
  );
}
