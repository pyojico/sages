import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/pages/login_page.dart';
import 'pages/phone_login_page.dart';
import '/pages/signup_page.dart';
import '/pages/home_page.dart';
import '/pages/scan_page.dart';
import '/pages/inventory_page.dart';
import '/pages/profile_page.dart';
import '/pages/splash_srceen.dart';
import '/pages/recipe_details_page.dart';
import 'constants/colors.dart';
import 'constants/text_styles.dart';
import 'pages/profile_init_0.dart';
import 'pages/setting-profile.dart';
import 'pages/setting-family.dart';
import 'pages/setting-device.dart';
import 'pages/setting-prefer.dart';

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
        theme: ThemeData(
          primaryColor: AppColors.green, // 主色綠色
          scaffoldBackgroundColor: Colors.white, // 背景白色

          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black, // AppBar文字顏色
            elevation: 0, // 去掉陰影
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontSize: AppTextSizes.displayLarge),
            headlineMedium: TextStyle(fontSize: AppTextSizes.displayMedium),
            bodyLarge: TextStyle(fontSize: AppTextSizes.bodyLarge),
            bodyMedium: TextStyle(fontSize: AppTextSizes.bodyMedium),
            labelSmall: TextStyle(fontSize: AppTextSizes.bodySmall),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(
                child: EmailLoginPage(),
              ),
          '/splash': (context) => const SplashScreen(
                child: EmailLoginPage(),
              ),
          '/email-login': (context) => const EmailLoginPage(),
          '/phone-login': (context) => const PhoneLoginPage(),
          '/signUp': (context) => SignupPage(),
          '/home': (context) => const HomePage(),
          '/scan': (context) => ScanPage(),
          '/inventory': (context) => InventoryPage(),
          '/profile': (context) => ProfilePage(),
          '/recipe_detail': (context) => const RecipeDetailPage(),
          '/settingup': (context) => ProfileInit0(),
          '/setting-profile': (context) => Setting1(),
          '/setting-family': (context) => Setting2(),
          '/setting-device': (context) => Setting3(),
          '/setting-prefer': (context) => Setting4(),
        });
  }
}
