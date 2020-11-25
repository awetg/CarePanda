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

  Widget build(BuildContext context) {
    final List<QuickLinkModel> quickLinks = [
      QuickLinkModel(
          title: getTranslated(context, "home_hrTitle"),
          image: "assets/images/hr.jpg"),
      QuickLinkModel(
          title: getTranslated(context, "home_realEstateTitle"),
          image: "assets/images/real_estate.jpg"),
      QuickLinkModel(
          title: getTranslated(context, "home_occupationalHealthTitle"),
          image: "assets/images/occupational_health.jpg")
    ];
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
                    "Garage care app",
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
              color: Theme.of(context).canvasColor,
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
                          getTranslated(context, "home_heyThere"),
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 16.0,
                        ),
                        Text(
                          getTranslated(context, "home_welcomeText"),
                          style: TextStyle(
                            color: Colors.grey,
                            height: 1.4,
                          ),
                        )
                      ],
                    ),
                  ),
                  HomeSectionTitle(getTranslated(context, "home_surveyTitle")),
                  // counter or answer questionnaire card
                  Container(
                    child: Questionnaire(),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  HomeSectionTitle(getTranslated(context, "home_contactTitle")),
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
                              getTranslated(context, "home_contactCardTitle"),
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 8.0, left: 16.0),
                            child: Text(
                              getTranslated(context, "home_contactHrText"),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: 16.0, right: 16.0),
                                child: OutlineButton(
                                  child: Text(
                                    getTranslated(context, "home_sendMsgBtn"),
                                  ),
                                  textColor: Theme.of(context).accentColor,
                                  borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                  ),
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
                  HomeSectionTitle(
                      getTranslated(context, "home_quickLinksTitle")),
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
                              getTranslated(context, "home_wipInfo"),
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
