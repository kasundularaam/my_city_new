import 'package:flutter/material.dart';

import 'package:my_city/src/models/issue_modal.dart';
import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/services/issue_service.dart';
import 'package:my_city/src/services/user_service.dart';
import 'package:my_city/src/widgets/custom_alert.dart';
import 'package:my_city/src/widgets/custom_loading.dart';
import 'package:my_city/src/widgets/issue_card.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  IssueService _issueService = IssueService();
  UserService _userService = UserService();
  String _userId;
  User _user;
  List<Issue> _issueList;

  Future<void> deleteIssue(String issueId, int index) async {
    CustomLoading.showLoadingDialog(
      context: context,
      message: "Deleting...",
    );
    try {
      bool issueDeleted = await _issueService.deleteIssue(issueId);
      if (issueDeleted) {
        setState(() {
          _issueList.removeAt(index);
        });
        CustomLoading.closeLoading(context: context);
        CustomAlert.alertDialogBuilder(
          context: context,
          title: "Success",
          message: "Issue deleted successfully..",
          action: "Ok",
        );
      } else {
        CustomLoading.closeLoading(context: context);
        CustomAlert.alertDialogBuilder(
          context: context,
          title: "Error",
          message: "something went wrong..",
          action: "Ok",
        );
      }
    } catch (e) {
      CustomLoading.closeLoading(context: context);
      CustomAlert.alertDialogBuilder(
        context: context,
        title: "Error",
        message: "$e",
        action: "Ok",
      );
    }
  }

  showDelDialog(String issueId, int index) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Delete"),
            content: Text("are you sure you want to delete this issue?"),
            actions: [
              TextButton(
                child: Text(
                  "delete",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  deleteIssue(issueId, index);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(
                  "cancel",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<List<Issue>> getIssuesForUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString("uid");
      _user = await _userService.getUserById(_userId);
      String adminArea = _user.area;
      List<Issue> issueList =
          await _issueService.getIssuesByAdminArea(adminArea);
      List<Issue> filterdList = [];
      issueList.forEach((issue) {
        if (issue.status != "Approved") {
          filterdList.add(issue);
        }
      });
      return filterdList;
    } catch (e) {
      throw Exception("$e");
    }
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
                  _issueList = snapshot.data;
                  if (_issueList.isNotEmpty) {
                    return ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _issueList.length,
                        itemBuilder: (context, index) {
                          Issue issue = _issueList[index];
                          return GestureDetector(
                            onLongPress: () {
                              if (issue.uid == _user.id) {
                                showDelDialog(issue.id, index);
                              }
                            },
                            child: IssueItemCard(
                              issue: issue,
                              userId: _userId,
                            ),
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
