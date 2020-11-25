import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/quick_link_model.dart';
import 'package:carePanda/services/questionnaire_provider.dart';
import 'package:carePanda/services/LocalStorageService.dart';
import 'package:carePanda/widgets/home_section_title.dart';
import 'package:carePanda/widgets/questionnaire.dart';
import 'package:carePanda/widgets/quick_link_card.dart';
import 'package:flutter/material.dart';
import 'package:carePanda/widgets/MsgForHRPopup.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  final _storageService = locator<LocalStorageService>();

  final List<QuickLinkModel> quickLinks = [
    QuickLinkModel(title: "Human Resources", image: "assets/images/hr.jpg"),
    QuickLinkModel(
        title: "Real Estate", image: "assets/images/real_estate.jpg"),
    QuickLinkModel(
        title: "occupational Health",
        image: "assets/images/occupational_health.jpg")
  ];

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuestionnairProvider(),
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 112.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      EdgeInsetsDirectional.only(start: 16, bottom: 16),
                  centerTitle: false,
                  title: Text(
                    getTranslated(context, 'home_title'),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            child: Container(
              color: Theme.of(context).cardColor,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Information card
                  Container(
                    padding:
                        EdgeInsets.only(top: 16.0, left: 16.0, right: 64.0),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hey there!",
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          "Wellcome to the Garage care App. You will answer daily survey that only takes less than a minute to answere. The answers will be also be used for improvement of your workplace. You can choose to submit your answeres completely anonymously.",
                          style: TextStyle(
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        )
                      ],
                    ),
                  ),
                  HomeSectionTitle(
                      "SURVEY (${_storageService.hasQuestionnaire ?? false ? 1 : 0})"),
                  // counter or answer questionnaire card
                  Container(
                    child: Questionnaire(),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  HomeSectionTitle("CONTACT"),
                  // contact HR card
                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).dialogBackgroundColor,
                            width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.0),
                          Container(
                            margin: EdgeInsets.only(top: 8.0, left: 16.0),
                            child: Text(
                              "Contact human resources.",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8.0, left: 16.0),
                            child: Text(
                              "You can send anonymous message to HR or include your personal details in them message to be contacted later.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 16.0, right: 16.0),
                                child: OutlinedButton(
                                  onPressed: _storageService.firstTimeStartUp ??
                                          true
                                      ? null
                                      : () {
                                          showDialog(
                                            barrierColor: _storageService
                                                    .darkTheme
                                                ? Colors.black.withOpacity(0.4)
                                                : null,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return MsgForHRPopup();
                                            },
                                          );
                                        },
                                  child: Text(
                                    "Send Message",
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(128, 36),
                                    side: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        style: BorderStyle.solid),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  HomeSectionTitle("QUICK LINKS"),
                  // Quick links list view
                  Container(
                    height: 184.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final link in quickLinks)
                          QuickLinkCard(link.title, link.image)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Container(
                    height: 124,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 8, right: 8),
                            child: Icon(
                              Icons.info_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "Some of the links in this application might not work while the app is in testing phase. Thanks for your understanding.",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
