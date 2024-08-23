import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/pages/home/home.dart';
import 'package:smart_home101/pages/settings/list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Navbar extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final String titleMenu;
  final bool backStep;
  final bool showAppBar;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final bool showNavbar;
  final bool isEditing;
  final String editingText;

  const Navbar(
      {super.key,
      this.titleMenu = "",
      this.backStep = false,
      required this.body,
      required this.currentIndex,
      this.showAppBar = true,
      this.leftIcon,
      this.rightIcon,
      this.isEditing = false,
      this.editingText = "",
      this.showNavbar = true});

  @override
  // ignore: library_private_types_in_public_api
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.titleMenu;
  }

  @override
  void didUpdateWidget(covariant Navbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.titleMenu != oldWidget.titleMenu) {
      _titleController.text = widget.titleMenu;
    }
  }

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
              leading: widget.leftIcon,
              backgroundColor: Colors.white,
              title: widget.isEditing
                  ? SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromARGB(255, 240, 240, 240),
                          hintText: widget.editingText,
                          contentPadding: const EdgeInsets.only(
                              left: 0, right: 10, top: 0, bottom: 0),
                          prefixIcon: const HeroIcon(
                            HeroIcons.mapPin,
                            size: 22,
                            style: HeroIconStyle.solid,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              width: 0,
                              color: Color.fromARGB(255, 226, 226, 226),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                            borderSide: const BorderSide(
                              width: 0,
                              color: Color.fromARGB(255, 226, 226, 226),
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.white),
                        readOnly: true,
                      ),
                    )
                  : Text(
                      widget.titleMenu,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              actions: widget.rightIcon != null
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: widget.rightIcon!,
                      ),
                    ]
                  : null,
              centerTitle: true,
              elevation: 0,
            )
          : null,
      body: SafeArea(
        top: true,
        child: widget.body,
      ),
      bottomNavigationBar: widget.showNavbar
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const HeroIcon(
                    HeroIcons.home,
                    style: HeroIconStyle.solid,
                    size: 22,
                  ),
                  label: AppLocalizations.of(context)!.navBarHome,
                ),
                BottomNavigationBarItem(
                  icon: const HeroIcon(
                    HeroIcons.star,
                    style: HeroIconStyle.outline,
                    size: 22,
                  ),
                  label: AppLocalizations.of(context)!.navBarFavorites,
                ),
                BottomNavigationBarItem(
                  icon: const HeroIcon(
                    HeroIcons.userCircle,
                    style: HeroIconStyle.outline,
                    size: 22,
                  ),
                  label: AppLocalizations.of(context)!.navBarProfile,
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
            )
          : null,
      backgroundColor: widget.showNavbar ? null : Colors.white,
    );
  }
}
