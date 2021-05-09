import 'package:flutter/material.dart';

class SelectAdminAreaCard extends StatefulWidget {
  final Function(String) getSelectedAdminArea;
  const SelectAdminAreaCard({
    Key key,
    @required this.getSelectedAdminArea,
  }) : super(key: key);
  @override
  _SelectAdminAreaCardState createState() => _SelectAdminAreaCardState();
}

class _SelectAdminAreaCardState extends State<SelectAdminAreaCard> {
  String _adminArea = "Kottawa";

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                "Admin area",
                style: TextStyle(color: Colors.black, fontSize: 25.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                color: Colors.purple,
              ),
              SizedBox(
                height: 10.0,
              ),
              DropdownButton(
                value: _adminArea,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
                dropdownColor: Colors.white,
                items: <DropdownMenuItem<String>>[
                  new DropdownMenuItem(
                    child: new Text('Kottawa'),
                    value: "Kottawa",
                  ),
                  new DropdownMenuItem(
                    child: new Text('Homagama'),
                    value: "Homagama",
                  ),
                  new DropdownMenuItem(
                    child: new Text('Maharagama'),
                    value: "Maharagama",
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _adminArea = value;
                    widget.getSelectedAdminArea(value);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
