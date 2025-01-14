import 'dart:io';

import 'package:farstore/constants/global_variables.dart';
import 'package:farstore/features/auth/screens/signin_screeen.dart';
import 'package:farstore/features/auth/screens/signup_screen.dart';
import 'package:farstore/features/auth/services/auth_services.dart';
import 'package:farstore/features/user/home_screen.dart';
import 'package:farstore/models/bestProducts.dart';
import 'package:farstore/models/category.dart';
import 'package:farstore/models/charges.dart';
import 'package:farstore/models/coupon.dart';
import 'package:farstore/models/deliveryType.dart';
import 'package:farstore/models/offer.dart';
import 'package:farstore/models/offerDes.dart';
import 'package:farstore/models/offerImage.dart';
import 'package:farstore/models/orderHive.dart';
import 'package:farstore/models/orderSettings.dart';
import 'package:farstore/models/poll.dart';
import 'package:farstore/models/toggle_management.dart';
import 'package:farstore/providers/admin_provider.dart';
import 'package:farstore/providers/shopInfo_provider.dart';
import 'package:farstore/providers/user_provider.dart';
import 'package:farstore/router.dart';
import 'package:farstore/shop_setup/hive_storage/hive_service.dart';
import 'package:farstore/widgets/navigation_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid ? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDSy-X8GUznKqMf4KfACqjhUqIXMj62i2g', 
      appId: '1:94849961339:android:01cf29669e517d459681de', 
      messagingSenderId: '94849961339', 
      projectId: 'shopez-4f3ce'
    )
  ) : await Firebase.initializeApp();

    await Hive.initFlutter();
    
    // Register adapters
    // Hive.registerAdapter(CouponAdapter());
     if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(CouponAdapter());
  }
    Hive.registerAdapter(ShopInfoHiveAdapter());
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(HiveOfferAdapter());
    Hive.registerAdapter(offerDesAdapter());
    Hive.registerAdapter(OfferImageAdapter());
    if (!Hive.isAdapterRegistered(8)) { // Use your actual type ID
    Hive.registerAdapter(ChargesAdapter());
    Hive.registerAdapter(OrderHiveAdapter());
    Hive.registerAdapter(DeliveryTypeAdapter());
    if (!Hive.isAdapterRegistered(21)) {
    Hive.registerAdapter(OrderSettingsAdapter());
    Hive.registerAdapter(BestProductAdapter());
    if (!Hive.isAdapterRegistered(24)) {
    Hive.registerAdapter(PollAdapter());
  }
  }
    
  }
//     if (Hive.isAdapterRegistered(12)) {
//   print('TypeAdapter for typeId 12 is already registered.');
// } else {
//   Hive.registerAdapter(CouponAdapter());
// }
await ToggleManager.init();

    // Add any other adapters you need here
    
    // Open Hive boxes
    await Hive.openBox<ShopInfoHive>('shopInfo');
    await Hive.openBox<Map>('categoriesBox');
    await Hive.openBox<Coupon>('coupons');
    await Hive.openBox<HiveOffer>('offerImage');
    await Hive.openBox<offerDes>('offerDes');
    await Hive.openBox<HiveOffer>('charges');
    await Hive.openBox<Charges>(Charges.boxName);
    await Hive.openBox<OrderHive>('orderBox');
    await Hive.openBox<DeliveryType>('deliveryType');
    await Hive.openBox<OrderSettings>('orderSettings');
    await Hive.openBox<BestProduct>('bestProductsBox');
    await Hive.openBox<Poll>('polls');

    // await Charges.initHive();
    
    // Debug: Print the path where Hive stores data
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    print('Hive storage path: ${appDocumentDir.path}');

    // runApp(MyApp());
    
    
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserProvider()),
    ChangeNotifierProvider(create: (context) => AdminProvider()),
    ChangeNotifierProvider(create: (context) => ShopInfoProvider()),
    
  ], 

  child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

void initState() {
  super.initState();
  authService.getUserData(context);  // Just call the function, don't assign it to a variable.
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'clothez',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        fontFamily: 'Poppins', // Add the font family here
      ),
      // supportedLocales: localization.supportedLocales,
      // localizationsDelegates: localization.localizationsDelegates,
      onGenerateRoute: (settings) => generateRoute(settings),
      home:
          // MapPage(),
          // Provider.of<UserProvider>(context).user.token.isNotEmpty
          //     ? Provider.of<UserProvider>(context).user.type == 'user'
          //         ? const BottomBar()
          //         : const AdminScreen()

          //     : const AuthScreen(),

          Consumer<AdminProvider>(
        builder: (context, adminProvider, _) {
           print('User token: ${adminProvider.admin.token}');
          if (adminProvider.admin.token.isNotEmpty) {
            return adminProvider.admin.type == 'admin'
                ? const NavigationMenu()
                // HomeScreen(shopCode: '123456')
                : adminProvider.admin.type == 'admin'
                    ? const HomeScreen(shopCode: '23456')
                    // const CategoryDeals()
                    // : userProvider.user.type == 'rent'
                    //     ? const AdminAccommodationScreen()
                    : const SignUpScreen();
          } else {
            return const SignInScreen();
            // SplashScreen();
          }
        },
      ),
    );
  }

  // void configureLocalization() {
  //   localization.init(mapLocales: LOCALES, initLanguageCode: "en");
  //   localization.onTranslatedLanguage = onTranslatedLanguage;
  // }

  // void onTranslatedLanguage(Locale? locate) {
  //   setState(() {});
  // }
}
