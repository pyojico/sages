import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/pages/login_page.dart';
import '/pages/signup_page.dart';
import '/pages/home_page.dart';
import '/pages/scan_page.dart';
import '/pages/inventory_page.dart';
import '/pages/profile_page.dart';
import '/pages/splash_srceen.dart';
import '/pages/recipe_details_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBMC7VmervoVSdi5iunTLlnRobuPwaf9q0",
      appId: "1:136129608536:ios:7a5f672839e7382590432d",
      messagingSenderId: "136129608536",
      projectId: "sages-79fb7",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase',
        routes: {
          '/': (context) => SplashScreen(
                child: LoginPage(),
              ),
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignupPage(),
          '/home': (context) => const HomePage(),
          '/scan': (context) => ScanPage(),
          '/inventory': (context) => InventoryPage(),
          '/profile': (context) => ProfilePage(),
          '/recipe_detail': (context) => const RecipeDetailPage(),
        });
  }
}
