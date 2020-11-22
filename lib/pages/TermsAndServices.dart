import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/widgets/UserDataPopup.dart';
import 'package:flutter/material.dart';

class TermsAndServices extends StatefulWidget {
  @override
  _TermsAndServicesState createState() => _TermsAndServicesState();
}

class _TermsAndServicesState extends State<TermsAndServices> {
  var _checkboxValue = false;

  // Changes checkbox value
  _onCheckBoxChange(value) {
    setState(() {
      _checkboxValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(getTranslated(context, "terms_Title"),
            style: TextStyle(color: Theme.of(context).accentColor)),
      ),
      body: Column(children: [
        SizedBox(height: 16),

        // Terms & Services scrollable text inside a card
        Flexible(
            child: FractionallySizedBox(
                heightFactor: 0.85,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Card(
                      child: Column(
                    children: [
                      SizedBox(height: 10),
                      // Terms & Service title
                      Text(
                        getTranslated(context, "terms_Title"),
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      SizedBox(height: 12),

                      // Scrolable view with outline
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).accentColor,
                                  width: 1),
                            ),
                            child: Scrollbar(
                              controller: ScrollController(),
                              isAlwaysShown: true,
                              child: SingleChildScrollView(
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 4, bottom: 4),
                                    child: Text(
                                      getTranslated(context, "terms_text"),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 2),

                      // Checkbox
                      ListTileTheme(
                        contentPadding: EdgeInsets.only(left: 18, right: 18),
                        child: CheckboxListTile(
                          title: Text(getTranslated(context, "terms_accept")),
                          value: _checkboxValue,
                          activeColor: Theme.of(context).accentColor,
                          onChanged: _onCheckBoxChange,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                    ],
                  )),
                ))),

        SizedBox(height: 8),

        // Confirm button - on press function is null until user accept's terms and services
        // Redirects to user data setting
        FractionallySizedBox(
          widthFactor: 0.95,
          child: RaisedButton(
            child: Text(getTranslated(context, "confirmBtn"),
                style: TextStyle(fontSize: 18)),
            textColor: Colors.white,
            onPressed: _checkboxValue
                ? () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => UserDataPopup()));
                  }
                : null,
          ),
        ),
      ]),
    );
  }
}
