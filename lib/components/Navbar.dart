import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/pages/home/home.dart';
import 'package:smart_home101/pages/settings/list.dart';

class Navbar extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final String titleMenu;
  final bool backStep;
  final bool showAppBar;

  const Navbar({
    super.key,
    this.titleMenu = "",
    this.backStep = false,
    required this.body,
    required this.currentIndex,
    this.showAppBar = true,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              automaticallyImplyLeading: widget.backStep,
              title: Text(
                widget.titleMenu,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              actions: <Widget>[
                IconButton(
                    onPressed: () {
                      print("asdasd");
                    },
                    icon: const HeroIcon(
                      HeroIcons.qrCode,
                      size: 28,
                    ))
              ],
            )
          : null,
      body: SafeArea(
        top: true,
        child: widget.body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.home,
              style: HeroIconStyle.solid,
              size: 22,
            ),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.star,
              style: HeroIconStyle.outline,
              size: 22,
            ),
            label: 'รายการโปรด',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.userCircle,
              style: HeroIconStyle.outline,
              size: 22,
            ),
            label: 'โปรไฟล์',
          ),
        ],
        backgroundColor: Colors.white,
        currentIndex: widget.currentIndex,
        selectedItemColor: const Color.fromRGBO(44, 131, 181, 1),
        unselectedItemColor: Colors.grey,
        selectedIconTheme:
            const IconThemeData(color: Color.fromRGBO(44, 131, 181, 1)),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        onTap: _onItemTapped,
      ),
    );
  }
}
