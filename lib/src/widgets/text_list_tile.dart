import 'package:flutter/material.dart';

class TextListTile extends StatefulWidget {
  final String title;
  final String subTitle;
  const TextListTile({
    Key key,
    @required this.title,
    @required this.subTitle,
  }) : super(key: key);
  @override
  _TextListTileState createState() => _TextListTileState();
}

class _TextListTileState extends State<TextListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.subTitle,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
