import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

class PoliciesScreen extends StatefulWidget {
  const PoliciesScreen({super.key});

  @override
  _PoliciesScreen createState() => _PoliciesScreen();
}

class _PoliciesScreen extends State<PoliciesScreen> {
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
    final policyData = [
      AppLocalizations.of(context)!.policyParagraph1,
      AppLocalizations.of(context)!.policy1,
      AppLocalizations.of(context)!.policy2,
      AppLocalizations.of(context)!.policy3,
      AppLocalizations.of(context)!.policy4,
      AppLocalizations.of(context)!.policy5,
      AppLocalizations.of(context)!.policy6,
      AppLocalizations.of(context)!.policy7,
      AppLocalizations.of(context)!.policy8,
      AppLocalizations.of(context)!.policy9,
      AppLocalizations.of(context)!.policy10,
      AppLocalizations.of(context)!.policy11,
      AppLocalizations.of(context)!.policy12,
      AppLocalizations.of(context)!.policy13,
    ];

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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Font(
                        text: AppLocalizations.of(context)!.policyDataStart,
                        fontSize: 14,
                        textColor: Colors.red,
                        fontWeight: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(policyData.length, (index) {
                      return Html(
                        data: policyData[index],
                        style: {
                          "pre": Style(
                            display: Display.inline,
                          ),
                          "*": Style(
                            fontSize: FontSize(10),
                          ),
                        },
                      );
                    }),
                  ),
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
      titleMenu: AppLocalizations.of(context)!.settingsPrivacyPolicy,
    );
  }
}
