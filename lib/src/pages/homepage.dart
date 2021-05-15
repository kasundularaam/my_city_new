import 'package:flutter/material.dart';

import 'package:my_city/src/models/issue_modal.dart';
import 'package:my_city/src/socpe%20model/issue_model.dart';
import 'package:my_city/src/widgets/issue_card.dart';
import 'package:my_city/src/widgets/page_title.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IssueModel _issueModel = IssueModel();

  Future<List<Issue>> getIssuesForUser() async {
    List<Issue> issueList;
    //   String adminArea = widget.currentUser.AdminArea;
    try {
      issueList = await _issueModel.getIssuesByAdminArea("Kottawa");
      //     issueList = await _issueModel.getIssuesByAdminArea(adminArea);
    } catch (e) {
      print("error: $e");
    }
    return issueList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          PageTitle(title: "Near By Issues", fontSize: 38.0),
          SizedBox(
            height: 40.0,
          ),
          FutureBuilder<List<Issue>>(
            future: getIssuesForUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "something went wrong",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<Issue> issueList = snapshot.data;
                  if (issueList.isNotEmpty) {
                    return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: issueList.length,
                        itemBuilder: (context, index) {
                          Issue issue = issueList[index];

                          return IssueItemCard(
                            location: issue.Location,
                            image: issue.Image,
                            date: issue.Date,
                            issueType: issue.IssueType,
                            roadType: issue.RoadType,
                          );
                        });
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "No issues available in your area",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                }
              }
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
