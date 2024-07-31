import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_home101/Components/Button.dart';
import 'package:smart_home101/components/Font.dart';
import 'package:smart_home101/components/ListMenu.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:heroicons/heroicons.dart';

const List<Map<String, dynamic>> menuItems = [
  {
    'icon': HeroIcons.home,
    'menuName': 'จัดการบ้านและสมาชิก',
  },
  {
    'icon': HeroIcons.language,
    'menuName': 'ภาษา',
    'description': 'ภาษาไทย',
    'title': 'การตั้งค่า',
    'space': true,
    'border': true,
  },
  {
    'icon': HeroIcons.bellAlert,
    'menuName': 'การแจ้งเตือน',
  },
  {
    'icon': HeroIcons.document,
    'menuName': 'ข้อกำหนดและเงื่อนไขการให้บริการ',
    'title': 'ข้อกำหนดและนโยบาย',
    'space': true,
    'border': true,
  },
  {
    'icon': HeroIcons.documentText,
    'menuName': 'นโยบายการคุ้มครองข้อมูลส่วนบุคคล',
  },
  {
    'icon': HeroIcons.deviceTablet,
    'menuName': 'เกี่ยวกับแอปพลิเคชัน',
    'title': 'แอปพลิเคชัน',
    'space': true,
  },
  {
    'icon': HeroIcons.chatBubbleBottomCenterText,
    'menuName': 'แจ้งปัญหา และขอความช่วยเหลือ',
    'title': 'ความช่วยเหลือ',
    'space': true,
  },
];

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListMenu(
                icon: HeroIcons.user,
                menuName: "Fullname",
                subText: "Mobile number",
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...menuItems.map(
                    (item) {
                      return ListMenu(
                        icon: item['icon'],
                        menuName: item['menuName'],
                        title: item.containsKey('title') ? item['title'] : "",
                        subText:
                            item.containsKey('subText') ? item['subText'] : "",
                        description: item.containsKey('description')
                            ? item['description']
                            : "",
                        border:
                            item.containsKey('border') ? item['border'] : false,
                        bold: item.containsKey('bold') ? item['bold'] : true,
                        space:
                            item.containsKey('space') ? item['space'] : false,
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Button(
                      text: "ออกจากระบบ",
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        } catch (e) {
                          print('Logout failed: $e');
                        }
                      },
                      bgColor: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      currentIndex: 2,
      titleMenu: AppLocalizations.of(context)!.profile_title,
      backStep: false,
    );
  }
}
