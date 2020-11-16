import 'package:carePanda/main.dart';
import 'package:carePanda/model/slider_item.dart';
import 'package:carePanda/pages/userboarding/slider_dot.dart';
import 'package:carePanda/pages/userboarding/slider_page.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/services/ServiceLocator.dart';

class UserBoarding extends StatefulWidget {
  @override
  _UserBoardingState createState() => _UserBoardingState();
}

class _UserBoardingState extends State<UserBoarding> {
  // required property of the PageView
  PageController _pageController;
  // current index of page
  int currentIndex = 0;
  // duration of animation to change to next page
  static const animation_duration = const Duration(milliseconds: 300);
  // type of animation to change to next page
  static const animation_type = Curves.ease;

  // Slider items to be shown each slide page, containing image, heading and bodytext
  static const _sliderItems = [
    SliderItem("assets/images/safe.png", "Secure And Private!",
        "Your personal data is securely stored on your device. Only none identifying data information is sent, unless you expelectly choose otherwise."),
    SliderItem("assets/images/yoga.png", "Track Your Wellbeing!",
        "Track your wellbeing state over time."),
    SliderItem("assets/images/anonymous.png", "Give Anonymous Feedback!",
        "Give anonymous feedback on your general wellbeing to improve your workspace.")
  ];

  var _storageService = locator<LocalStorageService>();

  // handle next page of PageContorller
  nextPage() async {
    if (currentIndex < (_sliderItems.length - 1))
      _pageController.nextPage(
          duration: animation_duration, curve: animation_type);
    else {
      _storageService.showBoarding = false;
      // Pushes to home and removes history, which makes it unable to move back with back button
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyStatefulWidget()),
          (Route<dynamic> route) => false).then(
        (value) {
          setState(() {});
        },
      );
    }
  }

  //  pop userboarding page
  skipAllPages() async {
    _storageService.showBoarding = false;
    // Pushes to home and removes history, which makes it unable to move back with back button
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyStatefulWidget()),
        (Route<dynamic> route) => false).then(
      (value) {
        setState(() {});
      },
    );
  }

  // initialize pageContorller
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  // dispose pageContorller
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // handle onchanged funtion of PageView widget
  onChangedFunction(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: _pageController,
          onPageChanged: onChangedFunction,
          itemCount: _sliderItems.length,
          itemBuilder: (context, i) => SliderPage(_sliderItems[i]),
        ),
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
                child: InkWell(
                  onTap: () => nextPage(),
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                child: InkWell(
                  onTap: () => skipAllPages(),
                  child: Text(
                    "Skip",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.bottomCenter,
              margin: EdgeInsets.only(bottom: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < _sliderItems.length; i++)
                    SliderDot(positionIndex: i, currentIndex: currentIndex)
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
