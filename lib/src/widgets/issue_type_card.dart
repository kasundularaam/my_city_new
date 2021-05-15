import 'package:flutter/material.dart';

import 'package:my_city/src/pages/issue_detail.dart';

class IssueTypeCard extends StatefulWidget {
  final int id;
  final String roadType;
  const IssueTypeCard({
    Key key,
    @required this.id,
    @required this.roadType,
  }) : super(key: key);

  @override
  _IssueTypeCardState createState() => _IssueTypeCardState();
}

class MyIssueType {
  String IssueImage;
  String IssueName;
  MyIssueType({
    this.IssueImage,
    this.IssueName,
  });
}

class _IssueTypeCardState extends State<IssueTypeCard> {
  MyIssueType getIssueType({int id}) {
    MyIssueType myIssueType = MyIssueType();
    switch (id) {
      case 1:
        {
          myIssueType.IssueName = "Pothole";
          myIssueType.IssueImage = "assets/images/potholes.jpg";
        }
        break;
      case 2:
        {
          myIssueType.IssueName = "Broken Street Lights";
          myIssueType.IssueImage = "assets/images/lights-and-signs.jpg";
        }
        break;
      case 3:
        {
          myIssueType.IssueName = "Drain Line Block";
          myIssueType.IssueImage = "assets/images/floding.jpg";
        }
        break;
      case 4:
        {
          myIssueType.IssueName = "Under Construction";
          myIssueType.IssueImage = "assets/images/roadworks.jpg";
        }
        break;
      default:
        {
          myIssueType.IssueName = "";
          myIssueType.IssueImage = "";
        }
    }
    return myIssueType;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: (MediaQuery.of(context).size.width - 40) / 2,
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                getIssueType(id: widget.id).IssueImage,
                height: MediaQuery.of(context).size.width / 3,
                width: ((MediaQuery.of(context).size.width - 40) / 2) * 0.9,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              getIssueType(id: widget.id).IssueName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => IssueDetails(
              issueType: widget.id,
              roadType: widget.roadType,
            ),
          ),
        );
      },
    );
  }
}
