import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sages/pages/login_page.dart';
import 'package:sages/pages/signup_page.dart';
import 'package:sages/pages/home_page.dart';
import 'package:sages/pages/inventory_page.dart';
import 'package:sages/pages/splash_srceen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBMC7VmervoVSdi5iunTLlnRobuPwaf9q0",
    appId: "1:136129608536:ios:7a5f672839e7382590432d",
    messagingSenderId: "136129608536",
    projectId: "sages-79fb7",
  ));
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
                // child: InventoryPage(),
              ),
          '/login': (context) => const LoginPage(),
          '/signUp': (context) => const SignupPage(),
          '/home': (context) => HomePage(),
          '/inventory': (context) => InventoryPage(),
        });
  }
}
