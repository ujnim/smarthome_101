import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/components/ListMenu.dart';
import 'package:smart_home101/components/Navbar.dart';
import 'package:smart_home101/controllers/FireBaseController.dart';
import 'package:smart_home101/pages/home/create.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:smart_home101/pages/home/detail.dart';
import 'package:smart_home101/utils/global.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeListScreen extends StatefulWidget {
  const HomeListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeListScreenState createState() => _HomeListScreenState();
}

class _HomeListScreenState extends State<HomeListScreen> {
  String? selectedValue;
  late Future<List<Map<String, dynamic>>> homesFuture;

  final userId = getCurrentUser();

  @override
  void initState() {
    super.initState();
    homesFuture = FireBaseController().home.getHomesByOwner(userId.toString());
  }

  List<Map<String, dynamic>> _getLocalizedItems() {
    return [
      {
        'name': AppLocalizations.of(context)!.homeListAddHome,
        'link': const HomeCreateScreen()
      },
    ];
  }

  void _handleMenuItemSelection(String name) {
    // No need to change this function
    final items = _getLocalizedItems();
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

  @override
  Widget build(BuildContext context) {
    final items = _getLocalizedItems();
    return Navbar(
      titleMenu: AppLocalizations.of(context)!.homeListTitle,
      body: Container(
        alignment: Alignment.topCenter,
        color: Colors.white,
        child: FutureBuilder(
          future: homesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No homes found.'));
            } else {
              List<Map<String, dynamic>> homes = snapshot.data!;
              return ListView.builder(
                itemCount: homes.length,
                itemBuilder: (context, index) {
                  final home = homes[index];
                  return ListMenu(
                    icon: HeroIcons.home,
                    menuName: home['name'],
                    title: home.containsKey('title') ? home['title'] : "",
                    subText: AppLocalizations.of(context)!.homeListTotal("2","3"
                    ),
                    fontSubSize: 10,
                    subColor: Colors.grey,
                    description: home.containsKey('description')
                        ? home['description']
                        : "",
                    border: home.containsKey('border') ? home['border'] : false,
                    bold: home.containsKey('bold') ? home['bold'] : true,
                    space: home.containsKey('space') ? home['space'] : false,
                    onTab: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeDetailScreen(homeData: home)),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      currentIndex: 2,
      showAppBar: true,
      backStep: true,
      showNavbar: false,
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
                        fontWeight: FontWeight.bold,
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
