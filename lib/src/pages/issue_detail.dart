import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_city/src/models/issue_modal.dart';
import 'package:my_city/src/models/location_modal.dart';
import 'package:my_city/src/socpe%20model/issue_model.dart';
import 'package:my_city/src/widgets/custom_alert.dart';
import 'package:my_city/src/widgets/custom_loading.dart';
import 'package:my_city/src/widgets/page_background.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:my_city/src/widgets/round_button.dart';
import 'package:my_city/src/widgets/select_admin_area_card.dart';
import 'package:my_city/src/widgets/select_image_card.dart';
import 'package:my_city/src/widgets/select_location_card.dart';
import 'package:intl/intl.dart';

class IssueDetails extends StatefulWidget {
  final int issueType;
  final String roadType;
  final int postalCode;
  const IssueDetails({
    Key key,
    @required this.issueType,
    @required this.roadType,
    @required this.postalCode,
  }) : super(key: key);

  @override
  _IssueDetailsState createState() => _IssueDetailsState();
}

class _IssueDetailsState extends State<IssueDetails> {
  IssueModel _issueModel = IssueModel();
  File _issueImage;
  MyLocationData _myLocationData;
  String _adminArea;
  BuildContext _showLoadingDialogContext;

  Future<Issue> readyIssueToUpload() async {
    Issue thisIssue;

    String thisBase64Image;
    double thisLat;
    double thisLong;
    int thisPostalCode;
    String thisLocation;
    String thisStatus = "initial";
    String thisDate;
    String thisRoadType;
    int thisIssueType;
    String thisAdminArea;

    final now = new DateTime.now();
    List<int> imageBytes = await _issueImage.readAsBytesSync();

    thisDate = DateFormat('y/d/M').format(now);
    thisBase64Image = base64Encode(imageBytes);
    thisLocation = _myLocationData.Address;
    thisLat = _myLocationData.Lat;
    thisLong = _myLocationData.Long;
    thisAdminArea = _adminArea;
    thisIssueType = widget.issueType;
    thisRoadType = widget.roadType;
    thisPostalCode = widget.postalCode;

    thisIssue = Issue(
      Image: thisBase64Image,
      Lat: thisLat,
      Long: thisLong,
      PostalCode: thisPostalCode,
      Location: thisLocation,
      Status: thisStatus,
      Date: thisDate,
      RoadType: thisRoadType,
      IssueType: thisIssueType,
      AdminArea: thisAdminArea,
    );
    return thisIssue;
  }

  Future addNewIssue() async {
    try {
      Issue myIssue = await readyIssueToUpload();
      _issueModel.addIssue(myIssue).then((response) {
        if (response.statusCode == 201) {
          Issue newIssue = issueFromJson(response.body);
          Navigator.of(_showLoadingDialogContext, rootNavigator: true).pop();
          CustomAlert.alertDialogBuilder(
            context: context,
            title: "Success",
            message: "Your issue reported successfully",
            action: "ok",
          );
          print(newIssue.Id);
          print(newIssue.Location);
          print(newIssue.Image);
          Navigator.of(context).pop();
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
        widget.roadType != null &&
        widget.postalCode != null) {
      CustomLoading.showLoadingDialog(
        context: context,
        message: "Reporting your issue...",
      );
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
