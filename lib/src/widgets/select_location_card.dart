import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'package:my_city/src/models/location_modal.dart';
import 'package:my_city/src/pages/google_map.dart';

class SelectLocationCard extends StatefulWidget {
  final Function(MyLocationData) getSelectedLocation;
  const SelectLocationCard({
    Key key,
    @required this.getSelectedLocation,
  }) : super(key: key);
  @override
  _SelectLocationCardState createState() => _SelectLocationCardState();
}

class _SelectLocationCardState extends State<SelectLocationCard> {
  LocationData _currentPosition;
  Location location = Location();
  String _address, _latLong;

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();

    if (_currentPosition != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GooMap(
            location: _currentPosition,
            getDataFromMap: (myLocationData) {
              setState(() {
                _latLong =
                    "latitude: ${myLocationData.Lat}\nlongitude: ${myLocationData.Long}";
                _address = myLocationData.Address;
                widget.getSelectedLocation(myLocationData);
              });
            },
          ),
        ),
      );
    }
  }

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
                "Location",
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
              _currentPosition != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _address ?? "null",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          _latLong ?? "null",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Divider(
                          color: Colors.purple,
                        ),
                        GestureDetector(
                          onTap: () {
                            getLoc();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Refresh location",
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () {
                        getLoc();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on),
                            Text(
                              "add location",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
