import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_home101/components/Button.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/InputForm.dart';
import 'package:smart_home101/components/colors/AppColor.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isButtonDisabled = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isButtonDisabled =
          _emailController.text.isEmpty || _passwordController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          errorMessage = '';
        });

        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        print("ลงทะเบียนผู้ใช้: ${user.user?.email}");

        if (user.user != null) {
          // ย้ายไปยังหน้าหลัก
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        setState(() {
          errorMessage = "การลงทะเบียนล้มเหลว: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Font(
                            text: "สมัครสมาชิก",
                            fontSize: 30,
                          ),
                        ),
                        Image.asset(
                          'assets/images/logo/Smart_Living+_Logo_01.jpg',
                          width: 70,
                          height: 70,
                        )
                      ],
                    ),
                  ),
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  InputForm(
                    hintText: "อีเมล",
                    controller: _emailController,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่อีเมลของคุณ';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'กรุณาใส่อีเมลที่ถูกต้อง';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputForm(
                    controller: _passwordController,
                    hintText: 'รหัสผ่าน',
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'กรุณาใส่รหัสผ่านของคุณ';
                      }
                      if (value.length < 6) {
                        return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Button(
                    text: "สมัครสมาชิก",
                    onPressed: isButtonDisabled
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              _register();
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
