import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:smart_home101/components/Font.dart';

class ListMenu extends StatelessWidget {
  final HeroIcons icon;
  final String title;
  final String menuName;
  final String subText;
  final String image;
  final String description;
  final bool border;
  final double fontSize;
  final double fontSubSize;
  final bool bold;
  final bool space;
  final Color subColor;
  final VoidCallback? onTab;
  final bool arrowStep;

  const ListMenu({
    super.key,
    required this.icon,
    required this.menuName,
    this.title = "",
    this.subText = "",
    this.image = "",
    this.description = "",
    this.border = false,
    this.fontSize = 14,
    this.fontSubSize = 14,
    this.bold = true,
    this.space = false,
    this.subColor = Colors.black,
    this.onTab,
    this.arrowStep = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (space) const Padding(padding: EdgeInsets.all(5)),
        if (title.isNotEmpty)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(top: 10, left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Font(
                  text: title,
                  fontSize: 13,
                )
              ],
            ),
          ),
        InkWell(
          onTap: onTab,
          child: Container(
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
                    child: image.isEmpty
                        ? HeroIcon(
                            icon,
                            size: 20,
                            color: const Color.fromRGBO(44, 131, 181, 1),
                          )
                        : Image.asset(
                            image,
                            width: 70,
                            height: 70,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Font(
                        text: menuName,
                        fontSize: fontSize,
                        fontWeight: bold,
                      ),
                      if (subText.isNotEmpty)
                        Text(
                          subText,
                          style: TextStyle(
                            fontSize: fontSubSize,
                            color: subColor,
                          ),
                          maxLines: null, // Allows text to wrap
                          overflow: TextOverflow.visible, // Ensures text wraps
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (description.isNotEmpty)
                  Font(
                    text: description,
                    fontSize: 12,
                    textColor: Colors.grey,
                  ),
                const SizedBox(width: 8),
                if (arrowStep) const HeroIcon(HeroIcons.chevronRight, size: 18)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
