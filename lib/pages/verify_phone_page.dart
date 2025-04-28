import 'package:flutter/material.dart';
import 'package:sages/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sages/services/FirebaseAuthService.dart';

class VerifyPhonePage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyPhonePage({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
  });

  @override
  _VerifyPhonePageState createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  String? _errorMessage;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 4) {
      setState(() {
        _errorMessage = 'Invalid OTP';
      });
      return;
    }

    // 驗證 OTP
    User? user = await _auth.signInWithPhoneNumber(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    if (user != null) {
      Navigator.pushNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Verification failed';
      });
    }
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
              // 標題
              const Text(
                '認證號碼',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // OTP 輸入框
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 60,
                    child: TextField(
                      controller: _otpControllers[index],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              // 錯誤提示
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              ],
              // Verify 按鈕
              const SizedBox(height: 20),
              CustomButton(
                text: '確定',
                onPressed: _verifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
