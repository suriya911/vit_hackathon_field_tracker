import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_maps/location_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineIdCounter = 1;

  static final CameraPosition per1 = CameraPosition(
    target: LatLng(13.101876, 80.194460),
    zoom: 18,
  );

  @override
  void initState() {
    super.initState();

    _setMarker(LatLng(13.101876, 80.194460));
  }

  static final Marker _loc1 = Marker(
    markerId: MarkerId('per1'),
    infoWindow: InfoWindow(title: 'person 1'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    position: LatLng(13.101876, 80.194460),
  );

  static final CameraPosition per2 = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(13.102525, 80.204437),
      zoom: 18);

  static final Marker _loc2 = Marker(
    markerId: MarkerId('per2'),
    infoWindow: InfoWindow(title: 'person 2'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    position: LatLng(13.102525, 80.204437),
  );

  static final CameraPosition per3 = CameraPosition(
    target: LatLng(13.103775, 80.214449),
    zoom: 18,
  );

  static final Marker _loc3 = Marker(
    markerId: MarkerId('per3'),
    infoWindow: InfoWindow(title: 'person 3'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    position: LatLng(13.103775, 80.214449),
  );

  static final CameraPosition per4 = CameraPosition(
    target: LatLng(13.098141, 80.195408),
    zoom: 18,
  );

  static final Marker _loc4 = Marker(
    markerId: MarkerId('per4'),
    infoWindow: InfoWindow(title: 'person 4'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    position: LatLng(13.098141, 80.195408),
  );

  static final CameraPosition per5 = CameraPosition(
    target: LatLng(13.104642, 80.208947),
    zoom: 18,
  );

  static final Marker _loc5 = Marker(
    markerId: MarkerId('per5'),
    infoWindow: InfoWindow(title: 'person 5'),
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    position: LatLng(13.104642, 80.208947),
  );

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygons.add(
      Polygon(
        polygonId: PolygonId(polygonIdVal),
        points: polygonLatLngs,
        strokeWidth: 2,
        fillColor: Colors.transparent,
      ),
    );
  }

  void _set   

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Maps'),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: _searchController,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(hintText: 'Search By Location'),
                  onChanged: ((value) {
                    print(value);
                  }),
                )),
                IconButton(
                  onPressed: () async {
                    var direction = await LocationService().getDirections(
                        _originController.text, _destinationController.text);
                    _goToPlace(direction['start_location']['lat'],
                        direction['end_location']['lng']);
                  },
                  icon: Icon(Icons.search),
                ),
              ],
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                markers: {
                  _loc1,
                  _loc2,
                  _loc3,
                  _loc4,
                  _loc5,
                },
                initialCameraPosition: per1,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ));
  }

  Future<void> _goToPlace(
    // Map<String, dynamic> place,
    double lat,
    double lng,
  ) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 17),
      ),
    );

    _setMarker(LatLng(lat, lng));
  }
}
