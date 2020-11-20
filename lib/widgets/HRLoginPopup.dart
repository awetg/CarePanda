import 'package:carePanda/localization/localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HRLoginPopup extends StatefulWidget {
  @override
  _HRLoginPopupState createState() => _HRLoginPopupState();
}

class _HRLoginPopupState extends State<HRLoginPopup> {
  var _email;
  var _password;
  bool _hasTriedLogin = false;
  bool _validEmail = false;
  bool _validPassword = false;
  bool _invalidUser = false;
  bool _loadingIndicator = false;
  bool _tooManyRequests = false;
  Pattern _emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  login() async {
    setState(() {
      _hasTriedLogin = true;
    });

    if (_validEmail && _validPassword) {
      try {
        _loadingIndicator = true;
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        _loadingIndicator = false;
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print("FireBaseAuth: " + 'No user found for that email.');
          setState(() {
            _invalidUser = true;
            _loadingIndicator = false;
          });
        } else if (e.code == 'wrong-password') {
          print("FireBaseAuth: " + 'Wrong password provided for that user.');
          setState(() {
            _invalidUser = true;
            _loadingIndicator = false;
          });
        } else if (e.code == 'too-many-requests') {
          setState(() {
            _tooManyRequests = true;
            _loadingIndicator = false;
          });
        } else {
          print("FireBaseAuth: " + e.message + " " + e.code);
        }
      } on PlatformException catch (e) {
        print("PlatformException: " + e.message);
      } catch (e) {
        print("Error: " + e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(top: 26, left: 10, right: 10, bottom: 14),
      title: Center(
          child: Text(getTranslated(context, "hrLogin_title"),
              style: TextStyle(color: Theme.of(context).accentColor))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Username
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  RegExp regex = new RegExp(_emailPattern);
                  if (_hasTriedLogin) {
                    if (value.isEmpty) {
                      _validEmail = false;
                      return getTranslated(context, "hrLogin_emptyEmail");
                    }
                    if (!(regex.hasMatch(value)) && value.isNotEmpty) {
                      _validEmail = false;
                      return getTranslated(context, "hrLogin_invalidEmail");
                    } else {
                      _validEmail = true;
                      return null;
                    }
                  }
                  if ((regex.hasMatch(value)) && value.isNotEmpty) {
                    _validEmail = true;
                  }
                  return null;
                },
                onChanged: (email) {
                  setState(() {
                    _invalidUser = false;
                  });
                  _email = email;
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  labelText: getTranslated(context, "hrLogin_emailTxtfield"),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 14,
          ),

          // Password
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: Color(0xff027DC5)),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (_hasTriedLogin) {
                    if (value.isEmpty) {
                      _validPassword = false;
                      return getTranslated(context, "hrLogin_emptyPass");
                    } else {
                      _validPassword = true;
                      return null;
                    }
                  }
                  if (value.isNotEmpty) {
                    _validPassword = true;
                  }
                  return null;
                },
                onChanged: (password) {
                  setState(() {
                    _invalidUser = false;
                  });
                  _password = password;
                },
                obscureText: true,
                decoration: new InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  labelText: getTranslated(context, "hrLogin_passwordTxtfield"),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                ),
              ),
            ),
          ),

          if (_loadingIndicator)
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: CircularProgressIndicator(),
            ),

          if (_invalidUser)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(getTranslated(context, "hrLogin_wrongEmailPass"),
                  style: TextStyle(color: Colors.red, fontSize: 14)),
            ),

          if (_tooManyRequests)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(getTranslated(context, "hrLogin_tooManyRequests"),
                    style: TextStyle(color: Colors.red, fontSize: 14)),
              ),
            ),
        ],
      ),

      // Buttons
      actions: [
        FlatButton(
          child: Text(getTranslated(context, "cancelBtn"),
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).accentColor)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        RaisedButton(
          child: Text(getTranslated(context, "hrLogin_loginBtn"),
              style: TextStyle(fontSize: 18)),
          onPressed: () {
            login();
          },
        ),
      ],
    );
  }
}
