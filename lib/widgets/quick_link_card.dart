import 'package:flutter/material.dart';

class QuickLinkCard extends StatelessWidget {
  final String _title;
  final String _image;
  const QuickLinkCard(this._title, this._image);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        width: 160.0,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {},
            highlightColor: Colors.transparent,
            splashColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Ink.image(
                          image: AssetImage(_image),
                          fit: BoxFit.cover,
                          child: Container(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                  child: Text(
                    _title,
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).dialogBackgroundColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
