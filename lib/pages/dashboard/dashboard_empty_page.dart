import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:flutter/material.dart';

class DasboardEmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.width * 0.6,
            width: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(locator<LocalStorageService>().darkTheme
                        ? "assets/images/dark_empty.png"
                        : "assets/images/light_empty.png"))),
          ),
          SizedBox(
            height: 60.0,
          ),
          Text(getTranslated(context, "graph_notEnoughData"),
              style: TextStyle(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
