import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_city/src/models/approve_model.dart';

import 'package:my_city/src/models/issue_modal.dart';
import 'package:my_city/src/services/approve_service.dart';
import 'package:my_city/src/services/issue_service.dart';

class IssueItemCard extends StatefulWidget {
  final Issue issue;
  final String userId;
  const IssueItemCard({
    Key key,
    @required this.issue,
    @required this.userId,
  }) : super(key: key);

  @override
  _IssueItemCardState createState() => _IssueItemCardState();
}

class _IssueItemCardState extends State<IssueItemCard> {
  Issue _issue;
  bool _liked = false;
  int _likeCount = 0;
  int _approveCount = 5;
  String _userId;
  ApproveService _approveService = ApproveService();
  IssueService _issueService = IssueService();

  Future<void> getLikeData() async {
    try {
      bool userLiked = await _approveService.isUserLiked(_userId, _issue.id);
      setState(() {
        if (userLiked) {
          _liked = true;
        } else {
          _liked = false;
        }
      });
      int likeCount = await _approveService.likeCountForIssue(_issue.id);
      setState(() {
        _likeCount = likeCount;
      });
    } catch (e) {
      print("$e");
    }
  }

  Future<void> updateStatus() async {
    try {
      int likeCount = await _approveService.likeCountForIssue(_issue.id);
      bool isApproved = await _issueService.isApproved(_issue.id);
      if (likeCount >= _approveCount) {
        if (!isApproved) {
          print("IsApproved false");
          bool updated = await _issueService.updateStatus(_issue.id, true);
          if (updated) {
            print("status updated Status = Approved");
          }
        }
      } else {
        if (isApproved) {
          print("IsApproved true");
          bool updated = await _issueService.updateStatus(_issue.id, false);
          if (updated) {
            print("status updated Status = Initial");
          }
        }
      }
    } catch (e) {
      print("$e");
    }
  }

  Future<void> likeProces(bool liked) async {
    Approve approve = Approve(userId: _userId, issueId: _issue.id);

    try {
      if (liked) {
        bool likeAdded = await _approveService.likeIssue(approve);
        if (likeAdded) {
          getLikeData();
          updateStatus();
        } else {
          print("like added false");
        }
      } else {
        bool likeRemoved =
            await _approveService.disLikeIssue(_userId, _issue.id);
        if (likeRemoved) {
          getLikeData();
          updateStatus();
        } else {
          print("like added false");
        }
      }
    } catch (e) {
      print("$e");
    }
  }

  @override
  void initState() {
    _issue = widget.issue;
    _userId = widget.userId;
    getLikeData();
    super.initState();
  }

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
                        base64Decode(_issue.image),
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
                                _issue.location ?? "location is null",
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
                                _issue.roadType ?? "road type is null",
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
                                getIssueType(id: _issue.issueType) ??
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
                      _issue.date ?? "date is null",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        buildApproved(),
                        SizedBox(
                          width: 10,
                        ),
                        buildLikeBtn(),
                      ],
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

  Widget buildApproved() {
    if (_likeCount >= _approveCount) {
      return Text(
        "Approved",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      );
    } else {
      return SizedBox();
    }
  }

  Widget buildLikeBtn() {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_liked) {
            likeProces(false);
          } else {
            likeProces(true);
          }
        });
      },
      child: Container(
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: _liked
              ? Colors.purple.withOpacity(0.2)
              : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${_likeCount}",
                style: TextStyle(
                  color: _liked ? Colors.purple : Colors.black,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_up,
                color: _liked ? Colors.purple : Colors.black,
                size: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
