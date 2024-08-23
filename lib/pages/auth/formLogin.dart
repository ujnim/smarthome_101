import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_home101/pages/auth/login.dart';
import 'package:smart_home101/pages/auth/register.dart';
import 'package:smart_home101/components/BottomSheet.dart';
import 'package:smart_home101/components/Button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smart_home101/providers/user_profile_provider.dart';
import 'package:provider/provider.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FormLogin();
  }
}

class _FormLogin extends State<FormLogin> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final url = Uri.parse('https://asddsa.com');
    final header = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'username': _usernameController.text,
      'password': _passwordController.text,
    });

    final response = await http.post(url, headers: header, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      _showSnackbar(jsonResponse['message']);

      final userId =
          jsonResponse['userId']; // ปรับให้ตรงกับข้อมูลที่ส่งกลับจาก API
      await Provider.of<UserProfileProvider>(context, listen: false)
          .fetchUserProfile(userId);

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  void _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo/Smart_Living+_Logo_01.jpg',
                width: 150,
                height: 150,
              ),
              Button(
                text: AppLocalizations.of(context)!.register,
                onPressed: () {
                  Bottomsheet(
                    body: Container(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _registerFormKey,
                        child: const RegisterScreen(),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ).show(context);
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Button(
                text: AppLocalizations.of(context)!.login,
                onPressed: () {
                  Bottomsheet(
                    body: Container(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: _loginFormKey,
                        child: const LoginScreen(),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ).show(context);
                },
                bgColor: Colors.white,
                textColor: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
