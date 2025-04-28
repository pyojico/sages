import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sages/constants/colors.dart';
import 'package:sages/constants/text_styles.dart';
import 'package:sages/widgets/form_container_widget.dart';
import 'package:sages/widgets/custom_button.dart';
import 'package:sages/pages/signup_page.dart';
import 'package:sages/pages/verify_phone_page.dart';
import 'package:sages/services/FirebaseAuthService.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  _PhoneLoginPageState createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;

  final bool _isPhoneLoginEnabled = false;

  @override
  void initState() {
    super.initState();
    // _phoneController.text = '+852';
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _signInWithEmail() {
    Navigator.pushNamed(context, '/email-login');
  }

  void _signIn() async {
    if (!_isPhoneLoginEnabled) {
      setState(() {
        _errorMessage =
            'Phone login is temporarily disabled. Please use email login.';
      });
      return;
    }

    final String phone = _phoneController.text.trim();
    if (phone == '+852') {
      print('請輸入電話號碼');
      setState(() {
        _errorMessage = 'Please enter a phone number';
      });
      return;
    }

    if (!phone.startsWith('+852')) {
      setState(() {
        _errorMessage = 'Phone number must start with +852';
      });
      return;
    }

    // 檢查電話號碼長度（香港電話號碼通常係 8 位）
    if (phone.length != 12) {
      // +852 加上 8 位 = 12 位
      setState(() {
        _errorMessage = 'Hong Kong phone number should be 8 digits';
      });
      return;
    }

    print('Sending OTP to: $phone');
    // 發送 OTP，加強錯誤處理
    try {
      await _auth.sendOtp(
        phoneNumber: phone,
        onCodeSent: (String verificationId) {
          print('OTP sent, verificationId: $verificationId');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyPhonePage(
                verificationId: verificationId,
                phoneNumber: phone,
              ),
            ),
          );
        },
        onVerificationFailed: (String error) {
          print('Verification failed: $error');
          setState(() {
            _errorMessage = 'Failed to send OTP: $error';
          });
        },
      );
    } catch (e) {
      print('Unexpected error sending OTP: $e');
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  void _forgotPassword() {
    // direct to ForgetPasswordScreen
    Navigator.pushNamed(context, '/forget-password');
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
              // -------- Headline --------
              const Text(
                '歡迎來到 Sages',
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
                controller: _phoneController,
                hintText: '電話',
                inputType: TextInputType.phone,
                prefix: const Text('+852 '), // 顯示前綴
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                  _PrefixPreservingFormatter(), // 自訂 Formatter 確保 +852 唔會被刪
                ],
              ),
              // -------- SignIn Button --------
              const SizedBox(height: 10),
              CustomButton(
                text: '登入',
                onPressed: _signIn,
                backgroundColor: AppColors.green,
                textColor: Colors.black,
              ),
              // -------- Divider --------
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      '或',
                      style: TextStyle(color: AppColors.gray300, fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              // -------- Login with Phone --------
              const SizedBox(height: 20),
              CustomButton(
                text: '使用電郵登入',
                onPressed: _signInWithEmail,
              ),
              // -------- SignUp --------
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "沒有帳號?",
                    style: TextStyle(color: AppColors.gray500, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "立即註冊",
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
}

class _PrefixPreservingFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    const prefix = '+852';
    if (!newValue.text.startsWith(prefix)) {
      return oldValue;
    }
    return newValue;
  }
}
