import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/widgets/CardWidget.dart';
import 'package:flutter/material.dart';

class HRmanagementInfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(getTranslated(context, "hr_infoTitle"),
              style: TextStyle(color: Theme.of(context).accentColor)),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 10.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CardWidget(widget: QuestionnaireInfo()),
                SizedBox(height: 4),
                CardWidget(widget: MessageInfo()),
                SizedBox(height: 6),
              ]),
        ));
  }
}

class QuestionnaireInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headlineTextColor = theme.accentColor;
    final basicTextColor = theme.textTheme.bodyText1.color;
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          // Questionnaire title
          Text(
            getTranslated(context, "hr_infoQstTitle"),
            style: TextStyle(
                color: headlineTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          SizedBox(height: 16),

          // Questionnaire adding
          FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              getTranslated(context, "hr_infoQstAddingTitle"),
              style: TextStyle(
                color: headlineTextColor,
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 4),
          Text(
            getTranslated(context, "hr_infoQstAddingText"),
            style: TextStyle(color: basicTextColor, fontSize: 16),
          ),
          SizedBox(height: 16),

          // Questionnaire editing and deliting
          FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              getTranslated(context, "hr_infoQstEditDeleteTitle"),
              style: TextStyle(
                color: headlineTextColor,
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 4),
          Text(
            getTranslated(context, "hr_infoQstEditDeleteText"),
            style: TextStyle(color: basicTextColor, fontSize: 16),
          ),
          SizedBox(height: 16),

          // Extra info of questionnaires
          FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              getTranslated(context, "hr_infoQstExtraTitle"),
              style: TextStyle(
                color: headlineTextColor,
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 4),
          Text(
            getTranslated(context, "hr_infoQstExtraText"),
            style: TextStyle(color: basicTextColor, fontSize: 16),
          ),
          SizedBox(height: 2),
        ],
      ),
    );
  }
}

class MessageInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headlineTextColor = theme.accentColor;
    final basicTextColor = theme.textTheme.bodyText1.color;
    return Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          // Messages title
          Text(
            getTranslated(context, "hr_infoMsgsTitle"),
            style: TextStyle(
                color: headlineTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
          SizedBox(height: 16),

          // Message's information
          FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              getTranslated(context, "hr_infoMsgsInfoTitle"),
              style: TextStyle(
                color: headlineTextColor,
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 4),
          Text(
            getTranslated(context, "hr_infoMsgsInfoText"),
            style: TextStyle(color: basicTextColor, fontSize: 16),
          ),
          SizedBox(height: 16),

          // Message deleting
          FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              getTranslated(context, "hr_infoMsgDeletingTitle"),
              style: TextStyle(
                color: headlineTextColor,
                fontSize: 18,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 4),
          Text(
            getTranslated(context, "hr_infoMsgDeletingText"),
            style: TextStyle(color: basicTextColor, fontSize: 16),
          ),
          SizedBox(height: 2),
        ],
      ),
    );
  }
}
