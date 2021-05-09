import 'package:flutter/material.dart';

import 'package:my_city/src/models/user_modal.dart';
import 'package:my_city/src/pages/homepage.dart';
import 'package:my_city/src/pages/profile_page.dart';
import 'package:my_city/src/pages/report_issue.dart';

class MainScreen extends StatefulWidget {
  final User currentUser;
  const MainScreen({
    Key key,
    @required this.currentUser,
  }) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTabIndex = 0;
  User _currentUser;

  List<Widget> pages;
  Widget currentpage;

  HomePage homePage;
  ReportIssue reportIssuePage;
  ProfilePage profilePage;

  @override
  void initState() {
    _currentUser = widget.currentUser;
    super.initState();
    homePage = HomePage(currentUser: _currentUser);
    reportIssuePage = ReportIssue(currentUser: _currentUser);
    profilePage = ProfilePage();

    pages = [homePage, reportIssuePage, profilePage];

    currentpage = homePage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.pink,
        backgroundColor: Color.fromRGBO(49, 39, 79, 1),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentpage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "report",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
      ),
      body: currentpage,
    );
  }
}
