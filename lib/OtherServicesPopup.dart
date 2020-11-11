import 'package:flutter/material.dart';

class OtherServicesPopup extends StatefulWidget {
  @override
  _OtherServicesPopupState createState() => _OtherServicesPopupState();
}

class _OtherServicesPopupState extends State<OtherServicesPopup> {
  final List<String> otherServices = [
    "Human resources",
    "Real estate",
    "Occupational health"
  ];

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return AlertDialog(
      contentPadding: EdgeInsets.all(10.0),
      title: Text("Other services",
          style: TextStyle(color: Theme.of(context).accentColor)),
      content: Container(
        width: width - 100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: otherServices.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      setState(() {});
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(otherServices[index]),
                        Icon(Icons.navigate_next, size: 28),
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, top: 4),
              child: Text(
                "* Links for other services are not implemented in test verison",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 13),
              ),
            )
          ],
        ),
      ),
      actions: [
        Container(
          width: width - 100,
          child: RaisedButton(
            child: Text("Close", style: TextStyle(fontSize: 18)),
            textColor: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
