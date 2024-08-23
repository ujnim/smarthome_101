import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/components/ListMenu.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const List<Map<String, dynamic>> menuItems = [
  {
    'icon': HeroIcons.phone,
    'menuName': 'Call Center',
    'description': '080-076-6145',
    'space': true,
    'border': true,
  },
  {
    'icon': HeroIcons.phone,
    'image': 'assets/images/logo/LINE_Brand_icon.png',
    'menuName': 'Line',
  },
];

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreen createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
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
            ...menuItems.map(
              (item) {
                return ListMenu(
                  icon: item.containsKey('icon') ? item['icon'] : null,
                  image: item.containsKey('image') ? item['image'] : "",
                  menuName: item['menuName'],
                  title: item.containsKey('title') ? item['title'] : "",
                  subText: item.containsKey('subText') ? item['subText'] : "",
                  description: item.containsKey('description')
                      ? item['description']
                      : "",
                  border: item.containsKey('border') ? item['border'] : false,
                  bold: item.containsKey('bold') ? item['bold'] : true,
                  space: item.containsKey('space') ? item['space'] : false,
                  arrowStep: false,
                  onTab: item.containsKey('link')
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => item['link']),
                          );
                        }
                      : null,
                );
              },
            ),
          ],
        ),
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      titleMenu: AppLocalizations.of(context)!.settingsReport,
    );
  }
}
