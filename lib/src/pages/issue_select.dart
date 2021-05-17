import 'package:flutter/material.dart';
import 'package:my_city/src/screens/main_screen.dart';
import 'package:my_city/src/widgets/page_background.dart';
import 'package:my_city/src/widgets/page_title.dart';

import '../widgets/issue_type_card.dart';

class IssueSelect extends StatefulWidget {
  final String roadType;
  const IssueSelect({
    Key key,
    @required this.roadType,
  }) : super(key: key);

  @override
  _IssueSelectState createState() => _IssueSelectState();
}

class _IssueSelectState extends State<IssueSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: Stack(
        children: <Widget>[
          PageBackground(
              height: MediaQuery.of(context).size.height / 3.2,
              width: MediaQuery.of(context).size.width),
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.2,
              ),
              PageTitle(title: "Select Issue Type", fontSize: 36.0),
              SizedBox(
                height: 40,
              ),
              Row(
                children: <Widget>[
                  IssueTypeCard(
                    id: 1,
                    roadType: widget.roadType,
                  ),
                  IssueTypeCard(
                    id: 2,
                    roadType: widget.roadType,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IssueTypeCard(
                    id: 3,
                    roadType: widget.roadType,
                  ),
                  IssueTypeCard(
                    id: 4,
                    roadType: widget.roadType,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => MainScreen(),
                    ),
                    (route) => false,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "back to home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          )
        ],
      ),
    );
  }
}
