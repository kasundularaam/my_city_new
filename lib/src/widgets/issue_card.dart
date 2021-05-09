import 'dart:convert';

import 'package:flutter/material.dart';

class IssueItemCard extends StatefulWidget {
  final String location;
  final String image;
  final String date;
  final int issueType;
  final String roadType;
  const IssueItemCard({
    Key key,
    @required this.location,
    @required this.image,
    @required this.date,
    @required this.issueType,
    @required this.roadType,
  }) : super(key: key);

  @override
  _IssueItemCardState createState() => _IssueItemCardState();
}

class _IssueItemCardState extends State<IssueItemCard> {
  bool _liked = false;

  String getIssueType({int id}) {
    String issueType = "";
    switch (id) {
      case 1:
        {
          issueType = "Pothole";
        }
        break;
      case 2:
        {
          issueType = "Broken Street Lights";
        }
        break;
      case 3:
        {
          issueType = "Drain Line Block";
        }
        break;
      case 4:
        {
          issueType = "Under Construction";
        }
        break;
      default:
        {
          issueType = "";
        }
    }
    return issueType;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(
              10.0,
            ),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                blurRadius: 5.0,
                offset: Offset(0, 0.3),
                color: Colors.black38,
              )
            ]),
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        base64Decode(widget.image),
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Text(
                                widget.location ?? "location is null",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.alt_route,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Text(
                                widget.roadType ?? "road type is null",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.settings,
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Text(
                                getIssueType(id: widget.issueType) ??
                                    "issue type is null",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w400,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.purple,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.date ?? "date is null",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_liked) {
                            _liked = false;
                          } else {
                            _liked = true;
                          }
                        });
                        print(_liked);
                      },
                      child: Container(
                        padding: EdgeInsets.all(0.0),
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: _liked ? Colors.green : Colors.black,
                          size: 35.0,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }
}
