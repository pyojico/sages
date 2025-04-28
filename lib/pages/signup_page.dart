import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/constants/text_styles.dart';
import 'package:sages/pages/phone_login_page.dart';
import 'package:sages/widgets/form_container_widget.dart';
import 'package:sages/services/FirebaseAuthService.dart';
import 'package:sages/widgets/custom_button.dart';
import 'profile_init_0.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _pwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '歡迎加入SAGES',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // -------- Error Message --------
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(
                      fontSize: AppTextSizes.bodySmall, color: AppColors.red),
                ),
              ],
              // -------- Input Field --------
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _emailController,
                hintText: "電郵",
                isPasswordField: false,
              ),
              const SizedBox(height: 10),
              FormContainerWidget(
                controller: _pwController,
                hintText: "密碼",
                isPasswordField: true,
              ),
              // -------- SignUp Button --------
              const SizedBox(height: 20),
              CustomButton(
                text: '註冊',
                onPressed: _signUp,
                backgroundColor: AppColors.green,
                textColor: Colors.black,
              ),
              // -------- Div SignIn --------
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "已有帳號?",
                    style: TextStyle(color: AppColors.gray500, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PhoneLoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "立即登入",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.greyBlue,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    final String email = _emailController.text;
    final String password = _pwController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      print('User is successfully created');
      Navigator.pushNamed(context, "/settingup");
    } else {
      print('Sign up failed');
      setState(() {
        _errorMessage = 'Sign up failed';
      });
    }
  }
}
