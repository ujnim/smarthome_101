import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  _AboutScreen createState() => _AboutScreen();
}

class _AboutScreen extends State<AboutScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  String _getUserDataAsJson(User user) {
    Map<String, dynamic> userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'phoneNumber': user.phoneNumber,
      'photoURL': user.photoURL,
    };
    return jsonEncode(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo/Smart_Living+_Logo_01.jpg',
                          width: 70,
                          height: 70,
                        ),
                        Font(
                          text: AppLocalizations.of(context)!
                              .aboutCompany,
                          fontSize: 12,
                          fontWeight: true,
                        ),
                        Font(
                          text: AppLocalizations.of(context)!
                              .aboutVersion,
                          fontSize: 10,
                          textColor: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Font(
                          text: AppLocalizations.of(context)!
                              .about1,
                          overflow: TextOverflow.visible,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 20),
                        Font(
                          text: AppLocalizations.of(context)!
                              .about2,
                          overflow: TextOverflow.visible,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 20),
                        Font(
                          text: AppLocalizations.of(context)!
                              .about3,
                          overflow: TextOverflow.visible,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 20),
                        Font(
                          text: AppLocalizations.of(context)!
                              .about4,
                          overflow: TextOverflow.visible,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 20),
                        Font(
                          text: AppLocalizations.of(context)!
                              .about5,
                          overflow: TextOverflow.visible,
                          fontSize: 12,
                        ),
                        const SizedBox(height: 20),
                        Font(
                          text: AppLocalizations.of(context)!
                              .about6,
                          overflow: TextOverflow.visible,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      titleMenu: AppLocalizations.of(context)!.settingsAboutTheApplication,
    );
  }
}
