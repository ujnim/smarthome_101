import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/components/Font.dart';

class ListMenu extends StatelessWidget {
  final HeroIcons icon;
  final String title;
  final String menuName;
  final String subText;
  final String description;
  final bool border;
  final double fontSize;
  final bool bold;
  final bool space;

  const ListMenu({
    super.key,
    required this.icon,
    required this.menuName,
    this.title = "",
    this.subText = "",
    this.description = "",
    this.border = false,
    this.fontSize = 14,
    this.bold = true,
    this.space = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (space) const Padding(padding: EdgeInsets.all(5)),
        if (title != "")
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10 ,left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Font(text: title, fontSize: 13,)],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            border: border
                ? const Border(
                    bottom: BorderSide(
                      color: Color.fromRGBO(233, 233, 233, 1),
                      width: 1,
                    ),
                  )
                : null,
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color.fromARGB(255, 202, 229, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),
                child: Center(
                  // child: icon,
                  child: HeroIcon(
                    icon,
                    size: 20,
                    color: const Color.fromRGBO(44, 131, 181, 1),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(left: 12)),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Font(text: menuName, fontSize: fontSize, fontWeight: bold),
                  if(subText != "")
                    Font(text: subText, fontSize: fontSize)
                ],
              ),
              const Spacer(),
              if (description.isNotEmpty)
                Font(
                  text: description,
                  fontSize: 12,
                ),
              const Padding(padding: EdgeInsets.all(4)),
              const HeroIcon(HeroIcons.chevronRight, size: 18)
            ],
          ),
        ),
      ],
    );
  }
}
