import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:my_city/src/models/location_modal.dart';

class GooMap extends StatefulWidget {
  final LocationData location;
  final Function(MyLocationData) getDataFromMap;
  const GooMap({
    Key key,
    @required this.location,
    @required this.getDataFromMap,
  }) : super(key: key);

  @override
  _GooMapState createState() => _GooMapState();
}

class _GooMapState extends State<GooMap> {
  Set<Marker> _markers = HashSet<Marker>();
  LocationData _locationData;
  int _markerIdCounter = 1;
  String _address;

  Future<String> _getAddress(LatLng point) async {
    double modLat = double.parse(point.latitude.toStringAsFixed(4));
    double modLong = double.parse(point.longitude.toStringAsFixed(4));
    final coordinates = new Coordinates(modLat, modLong);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String address = addresses.first.addressLine;
    return address;
  }

  void _setMarkers(LatLng point) async {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId(markerIdVal),
            position: point,
            infoWindow: InfoWindow(
              title: _address ?? "Loading...",
            )),
      );
    });
  }

  void _getData(LatLng point) async {
    MyLocationData myLocationData;

    await _getAddress(point).then((value) {
      setState(() {
        _address = value;
      });
    });
    _markers.clear();
    _setMarkers(point);

    if (_address != null) {
      myLocationData = MyLocationData(
        Address: _address,
        Lat: point.latitude,
        Long: point.longitude,
      );
      widget.getDataFromMap(myLocationData);
    } else {
      print("address is null...");
    }
  }

  @override
  void initState() {
    super.initState();
    _locationData = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(_locationData.latitude, _locationData.longitude),
              zoom: 16,
            ),
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            markers: _markers,
            onTap: (point) {
              _getData(point);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: FloatingActionButton(
                  backgroundColor: Colors.purple,
                  elevation: 8,
                  child: Icon(Icons.check),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
