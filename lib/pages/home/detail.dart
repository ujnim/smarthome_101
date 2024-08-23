import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/components/ListMenu.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/pages/home/create.dart';
import 'package:smart_home101/pages/home/formCreate.dart';

class HomeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> homeData;

  const HomeDetailScreen({super.key, required this.homeData});

  @override
  _HomeDetailScreen createState() => _HomeDetailScreen();
}

class _HomeDetailScreen extends State<HomeDetailScreen> {
  LatLng? currentPosition;
  String? address;

  late Map<String, dynamic> currentHome;

  @override
  void initState() {
    super.initState();
    currentHome = widget.homeData;
  }

  void updateHomeData(Map<String, dynamic> newHomeData) {
    setState(() {
      currentHome = newHomeData;
    });
  }

  final List<Map<String, dynamic>> items = [
    {'name': 'เพิ่มห้อง', 'link': const HomeCreateScreen()},
    {'name': 'เพิ่มสมาชิก', 'link': const HomeCreateScreen()},
  ];

  void _handleMenuItemSelection(String name) {
    final selectedItem =
        items.firstWhere((item) => item['name'] == name, orElse: () => {});
    final link = selectedItem['link'];
    if (link != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => link),
      );
    }
  }

  void _navigateToFormCreateScreen(LatLng position, String address) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormCreateScreen(
          lat: position.latitude,
          long: position.longitude,
          address: address,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navbar(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ListMenu(
                icon: HeroIcons.home,
                menuName: currentHome['name'] ?? 'No Name',
                subText:
                    '${currentHome['address'] ?? ''}, ${currentHome['subDistrict'] ?? ''}, ${currentHome['district'] ?? ''}, ${currentHome['province'] ?? ''}, ${currentHome['postalCode'] ?? ''}',
                subColor: Colors.grey,
                fontSubSize: 12,
              ),
            ],
          ),
        ],
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
      titleMenu: '',
      rightIcon: DropdownButtonHideUnderline(
        child: DropdownButton2(
          customButton: const HeroIcon(
            HeroIcons.plusCircle,
            size: 26,
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item['name'] as String,
                    child: Text(
                      item['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              _handleMenuItemSelection(value);
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
            ),
            elevation: 2,
          ),
          dropdownStyleData: DropdownStyleData(
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Colors.white,
            ),
            offset: const Offset(-130, -10),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      ),
    );
  }
}
