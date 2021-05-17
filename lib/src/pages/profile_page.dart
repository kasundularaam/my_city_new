import 'package:flutter/material.dart';
import 'package:my_city/src/models/issue_modal.dart';
import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/screens/landing_screen.dart';
import 'package:my_city/src/services/issue_service.dart';
import 'package:my_city/src/services/user_service.dart';
import 'package:my_city/src/widgets/custom_alert.dart';
import 'package:my_city/src/widgets/custom_loading.dart';
import 'package:my_city/src/widgets/issue_card.dart';
import 'package:my_city/src/widgets/page_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserService _userService = UserService();
  IssueService _issueService = IssueService();
  List<Issue> _issueList;

  Future<String> getUid() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("uid");
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<User> getUser() async {
    try {
      String uid = await getUid();
      User user = await _userService.getUserById(uid);
      return user;
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<List<Issue>> getIssuesForUser() async {
    try {
      String uid = await getUid();
      List<Issue> issueList = await _issueService.getIssuesByUid(uid);
      return issueList;
    } catch (e) {
      throw Exception("$e");
    }
  }

  logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("access", false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => LandingScreen(),
      ),
      (route) => false,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageTitle(title: "Profile", fontSize: 38),
              GestureDetector(
                onTap: () {
                  logOut();
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "log out",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 110,
                height: 110,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(65),
                      child: Container(
                        color: Colors.white,
                        width: 110,
                        height: 110,
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          "https://images.pexels.com/photos/2078265/pexels-photo-2078265.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260",
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              FutureBuilder(
                future: getUser(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Can not load...",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    User user = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          user.name,
                          style: TextStyle(
                              fontSize: 22.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          user.nic,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          user.area,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          FutureBuilder(
            future: getIssuesForUser(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text(
                  "you have not reported any issue yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ));
              }
              if (snapshot.hasData) {
                _issueList = snapshot.data;
                return ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _issueList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Issue issue = _issueList[index];
                    return GestureDetector(
                      onLongPress: () {
                        showDelDialog(issue.id, index);
                      },
                      child: IssueItemCard(issue: issue, userId: issue.uid),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
          SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }
}
