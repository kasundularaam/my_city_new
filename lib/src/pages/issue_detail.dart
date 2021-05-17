import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_city/src/models/issue_modal.dart';
import 'package:my_city/src/models/location_modal.dart';
import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/screens/main_screen.dart';
import 'package:my_city/src/services/issue_service.dart';
import 'package:my_city/src/services/user_service.dart';
import 'package:my_city/src/widgets/custom_alert.dart';
import 'package:my_city/src/widgets/custom_loading.dart';
import 'package:my_city/src/widgets/page_background.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:my_city/src/widgets/round_button.dart';
import 'package:my_city/src/widgets/select_admin_area_card.dart';
import 'package:my_city/src/widgets/select_image_card.dart';
import 'package:my_city/src/widgets/select_location_card.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IssueDetails extends StatefulWidget {
  final int issueType;
  final String roadType;
  const IssueDetails({
    Key key,
    @required this.issueType,
    @required this.roadType,
  }) : super(key: key);

  @override
  _IssueDetailsState createState() => _IssueDetailsState();
}

class _IssueDetailsState extends State<IssueDetails> {
  IssueService _issueService = IssueService();
  UserService _userService = UserService();
  File _issueImage;
  MyLocationData _myLocationData;
  String _adminArea = "Kottawa";

  Future<Issue> readyIssueToUpload() async {
    Issue thisIssue;

    final now = new DateTime.now();
    List<int> imageBytes = await _issueImage.readAsBytesSync();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("uid");
    User user = await _userService.getUserById(userId);

    thisIssue = Issue(
        image: base64Encode(imageBytes),
        lat: _myLocationData.Lat,
        long: _myLocationData.Long,
        postalCode: user.postalCode,
        location: _myLocationData.Address,
        status: "initial",
        date: DateFormat('y/d/M').format(now),
        roadType: widget.roadType,
        issueType: widget.issueType,
        adminArea: _adminArea,
        uid: userId);
    return thisIssue;
  }

  Future addNewIssue() async {
    try {
      CustomLoading.showLoadingDialog(
        context: context,
        message: "Reporting your issue...",
      );
      Issue myIssue = await readyIssueToUpload();
      _issueService.addIssue(myIssue).then((response) {
        if (response.statusCode == 201) {
          CustomLoading.closeLoading(context: context);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => MainScreen(),
            ),
            (route) => false,
          );
        } else {
          CustomLoading.closeLoading(context: context);
          CustomAlert.alertDialogBuilder(
            context: context,
            title: "Error",
            message: "error code: ${response.statusCode}",
            action: "Ok",
          );
        }
      });
    } catch (e) {
      CustomLoading.closeLoading(context: context);
      CustomAlert.alertDialogBuilder(
        context: context,
        title: "Error",
        message: "error code: $e",
        action: "Ok",
      );
    }
  }

  void submitForm() {
    if (_issueImage != null &&
        _myLocationData.Address != null &&
        _myLocationData.Lat != null &&
        _myLocationData.Long != null &&
        _adminArea != null &&
        widget.issueType != null &&
        widget.roadType != null) {
      addNewIssue();
    } else {
      CustomAlert.alertDialogBuilder(
        context: context,
        title: "Error",
        message: "Some inputs are empty please try again",
        action: "ok",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: Stack(
        children: [
          PageBackground(
            height: MediaQuery.of(context).size.height / 3.2,
            width: MediaQuery.of(context).size.height,
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.2,
              ),
              PageTitle(title: "Issue Detail", fontSize: 36.0),
              SizedBox(
                height: 40.0,
              ),
              SelectImageCard(
                getImageFile: (image) {
                  if (image != null) {
                    _issueImage = image;
                  } else {
                    print("failed to get the image...");
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              SelectLocationCard(
                getSelectedLocation: (location) {
                  if (location.Address != null) {
                    _myLocationData = location;
                  } else {
                    print("failed to get the location...");
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              SelectAdminAreaCard(
                getSelectedAdminArea: (area) {
                  if (area != null) {
                    _adminArea = area;
                  } else {
                    print("failed to get the admin area...");
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              RoundButton(
                text: "submit",
                onPressed: () {
                  submitForm();
                },
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
