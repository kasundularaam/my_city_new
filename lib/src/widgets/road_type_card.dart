import 'package:flutter/material.dart';
import 'package:my_city/src/pages/issue_select.dart';

class RoadTypeCard extends StatefulWidget {
  final String roadType;
  final double height;
  final double width;
  const RoadTypeCard({
    Key key,
    @required this.roadType,
    @required this.height,
    @required this.width,
  }) : super(key: key);
  @override
  _RoadTypeCardState createState() => _RoadTypeCardState();
}

class _RoadTypeCardState extends State<RoadTypeCard> {
  String getImage(String roadType) {
    String image = "";
    if (roadType == "normal road") {
      image = "assets/images/normal.jpg";
    } else if (roadType == "highway") {
      image = "assets/images/highway.jpg";
    }
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IssueSelect(roadType: widget.roadType),
          ),
        );
      },
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              Image.asset(
                getImage(widget.roadType),
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
              ),
              Container(
                width: widget.width,
                height: widget.height,
                color: Colors.black.withOpacity(0.3),
              ),
              Center(
                child: Text(
                  widget.roadType,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset.fromDirection(1.0, 1.0),
                          blurRadius: 4.0,
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
