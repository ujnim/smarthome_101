import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_home101/components/Button.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/InputForm.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        setState(() {
          errorMessage = '';
        });

        UserCredential user = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        print("ล็อกอินผู้ใช้: ${user.user?.email}");

        if (user.user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        setState(() {
          errorMessage = "การล็อกอินล้มเหลว: $e";
          print("รายละเอียดข้อผิดพลาด: ${e.toString()}");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Font(
                      text: AppLocalizations.of(context)!.loginSubmit,
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  InputForm(
                    hintText: AppLocalizations.of(context)!.email,
                    controller: _emailController,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .emailValidationIsNull;
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return AppLocalizations.of(context)!.emailValidation;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  InputForm(
                    controller: _passwordController,
                    isObscured: true,
                    hintText: AppLocalizations.of(context)!.password,
                    isRequired: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!
                            .passwordValidationIsNull;
                      }
                      if (value.length < 6) {
                        return AppLocalizations.of(context)!.emailValidation;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  Button(
                    text: AppLocalizations.of(context)!.loginSubmit,
                    onPressed: isButtonDisabled ? null : _login,
                  ),
                ],
              ),
            ),
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
