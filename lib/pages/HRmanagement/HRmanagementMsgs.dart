import 'package:carePanda/localization/localization.dart';
import 'package:carePanda/model/building.dart';
import 'package:carePanda/model/hr_message.dart';
import 'package:carePanda/services/ServiceLocator.dart';
import 'package:carePanda/services/firestore_service.dart';
import 'package:carePanda/widgets/SimplePopupTwoButtons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var _msgData;
  var _expandedOnesList = [];
  var _shouldExpand;

  // Expanding card
  // Inserts into empty list all the indexes that should be expanded and use the list to determine which to expand
  _expandItem(int data) {
    setState(() {
      if (_expandedOnesList.contains(data)) {
        _expandedOnesList.remove(data);
      } else {
        _expandedOnesList.add(data);
      }
    });
  }

  _deleteMsg(data) async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimplePopUp(
            cancelBtnName: getTranslated(context, "cancelBtn"),
            confirmBtnName: getTranslated(context, "confirmBtn"),
            title: getTranslated(context, "hr_msgDeleteMsg"),
          );
        });
    if (result ?? false) {
      _expandedOnesList = [];
      locator<FirestoreService>().deleteHrMessage(data.id);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // list of genders
    Map<String, String> _genderList = {
      "-1": getTranslated(context, "userData_dontWnaTell"),
      "0": getTranslated(context, "userData_male"),
      "1": getTranslated(context, "userData_female"),
      "2": getTranslated(context, "userData_other")
    };

    // list of available options for building or workplace
    Map<String, Building> _buildingList = {
      "-1": Building(
          name: getTranslated(context, "userData_dontWnaTell"), floors: -1),
      "0": Building(
          name: getTranslated(context, "userData_workFromHome"), floors: -1),
      "1": Building(name: "Karaportti 4", floors: 6),
      "2": Building(name: "Karaportti 8", floors: 2),
      "3": Building(name: "KaraEast (Building 12)", floors: 5),
      "4": Building(name: "Mid Point 7A", floors: 8),
      "5": Building(name: "Mid Point 7B", floors: 6),
      "6": Building(name: "Mid Point 7C", floors: 5)
    };
    return StreamBuilder<List<HRMessage>>(
      stream: locator<FirestoreService>().getAllHrMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.isNotEmpty) {
          // Sets data to variable and sorts it by date
          _msgData = snapshot.data;
          _msgData.sort((a, b) => b.date.compareTo(a.date) as int);

          return Container(
            child: Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _msgData.length,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  // Boolean that determines is the card expanded or not
                  _shouldExpand = _expandedOnesList.contains(index);
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Card(
                      // Dismissible - slide left or right to delete
                      child: Dismissible(
                        key: UniqueKey(),
                        // Background - slide right
                        background: DeleteCardBackground(
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),

                        // Secondary background - slide left
                        secondaryBackground: DeleteCardBackground(
                          mainAxisAlignment: MainAxisAlignment.end,
                        ),

                        // On slide function
                        confirmDismiss: (direction) async {
                          return await _deleteMsg(_msgData[index]);
                        },

                        child: ListTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 6),

                                    // Name and last name
                                    Text(
                                        '${_msgData[index].name == "" ? getTranslated(context, "hr_msgNoName") : _msgData[index].name}  ${_msgData[index].lastName}',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 6),
                                    // Limits the message size (max 2 lines), when opened show's the entire message
                                    Text(
                                      _msgData[index].message,
                                      overflow: _shouldExpand ?? false
                                          ? null
                                          : TextOverflow.ellipsis,
                                      maxLines:
                                          _shouldExpand ?? false ? null : 2,
                                    ),
                                    SizedBox(height: 10),

                                    // Date
                                    Text(
                                        DateFormat("d.M.y H:m:s").format(
                                            DateTime.parse(
                                                _msgData[index].date)),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline2
                                                .color)),

                                    // Free space
                                    // _shouldExpand ?? false
                                    //     ? SizedBox(height: 10)
                                    //     : Container(),
                                    // SizedBox(height: 10),

                                    // Building
                                    if (_msgData[index].building != null)
                                      Row(
                                        children: [
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(context,
                                                      "hr_msgBuilding"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    _buildingList[snapshot
                                                            .data[index]
                                                            .building]
                                                        .name,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),

                                    // Free space
                                    if (_msgData[index].floor != null)
                                      _shouldExpand ?? false
                                          ? SizedBox(height: 8)
                                          : Container(),

                                    // Floor
                                    if (_msgData[index].floor != null)
                                      Row(
                                        children: [
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(
                                                      context, "hr_msgFloor"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    (_msgData[index].floor == 0)
                                                        ? getTranslated(context,
                                                            "userData_dontWnaTell")
                                                        : snapshot
                                                            .data[index].floor
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),

                                    // Free space
                                    if (_msgData[index].birthYear != null &&
                                            _msgData[index].building != null ||
                                        _msgData[index].gender != null &&
                                            _msgData[index].building != null)
                                      _shouldExpand ?? false
                                          ? SizedBox(height: 8)
                                          : Container(),

                                    // Age
                                    Row(
                                      children: [
                                        if (_msgData[index].birthYear != null)
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(
                                                      context, "hr_msgAge"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),

                                        if (_msgData[index].birthYear != null)
                                          Flexible(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    (_msgData[index]
                                                                .birthYear ==
                                                            0)
                                                        ? getTranslated(context,
                                                            "userData_notSelected")
                                                        : snapshot.data[index]
                                                            .birthYear
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                          ),

                                        // Free space between
                                        if (_msgData[index].birthYear != null)
                                          _shouldExpand ?? false
                                              ? SizedBox(width: 10)
                                              : Container(),

                                        // gender
                                        if (_msgData[index].gender != null)
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(
                                                      context, "hr_msgGender"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),

                                        if (_msgData[index].gender != null)
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    _genderList[snapshot
                                                        .data[index].gender],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  )
                                                : Container(),
                                          ),
                                      ],
                                    ),

                                    // Free space between
                                    if (snapshot.data[index].yearsWorked !=
                                                null &&
                                            _msgData[index].building != null &&
                                            _msgData[index].birthYear != null ||
                                        snapshot.data[index].yearsWorked !=
                                                null &&
                                            _msgData[index].building != null &&
                                            _msgData[index].gender != null)
                                      _shouldExpand ?? false
                                          ? SizedBox(height: 8)
                                          : Container(),

                                    // Years in nokia
                                    if (_msgData[index].yearsWorked != null)
                                      Row(
                                        children: [
                                          _shouldExpand ?? false
                                              ? Text(
                                                  getTranslated(context,
                                                      "hr_msgYearsWorkedNokia"),
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .accentColor))
                                              : Container(),
                                          Expanded(
                                            child: _expandedOnesList
                                                        .contains(index) ??
                                                    false
                                                ? Text(
                                                    (_msgData[index]
                                                                .yearsWorked ==
                                                            0)
                                                        ? getTranslated(context,
                                                            "userData_notSelected")
                                                        : _msgData[index]
                                                            .yearsWorked
                                                            .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),

                                    SizedBox(height: 6),
                                  ],
                                ),
                              ),

                              // Icon
                              _shouldExpand ?? false
                                  ? Icon(Icons.expand_less, size: 28)
                                  : Icon(Icons.expand_more, size: 28),
                            ],
                          ),

                          // On tap expands card to show more data of message
                          onTap: () {
                            _expandItem(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
          // Loading indicator when getting data
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: CircularProgressIndicator());
        } else {
          return Container(
              padding: EdgeInsets.only(top: 50),
              child: Text(getTranslated(context, "hr_msgNoMsgs"),
                  style: TextStyle(fontSize: 24)));
        }
      },
    );
  }
}

class DeleteCardBackground extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  const DeleteCardBackground({this.mainAxisAlignment});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.only(left: 8),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          Text(getTranslated(context, "hr_msgsDelete"),
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Icon(Icons.delete, size: 28, color: Colors.white),
        ],
      ),
    );
  }
}
