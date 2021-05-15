import 'package:flutter/material.dart';

import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:my_city/src/widgets/road_type_card.dart';

class ReportIssue extends StatefulWidget {
  @override
  _ReportIssueState createState() => _ReportIssueState();
}

class _ReportIssueState extends State<ReportIssue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: 50.0),
          PageTitle(title: "Report Issue", fontSize: 38.0),
          SizedBox(
            height: 40.0,
          ),
          RoadTypeCard(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.width / 2) * 1.2,
            roadType: "normal road",
          ),
          SizedBox(
            height: 20.0,
          ),
          RoadTypeCard(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.width / 2) * 1.2,
            roadType: "highway",
          ),
        ],
      ),
    );
  }
}
