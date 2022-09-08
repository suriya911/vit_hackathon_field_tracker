import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyBe9nXp8uvXoyvOcNMRNSlWbUTHc9N_MAE';              

  Future<String> getPlaceID(String input) async {
    final String url = 'https://maps.googleapis.com/maps';

    var response = await http.get(Uri.parse(url));

    var json = convert.jsonDecode(response.body);

    var placeId = json['candidates'][0]['place_id'] as String;

    print(PlaceId);

    return placeId;
  }

  Future<Map<String,dynamic>> getPlace(String input) async{
    final placeId = await getPlaceID(input);

    final String url = 
           'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key'
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String,dynamic>;

    print(results);
    return results;  
  }

  Future<void> getDirections(String origin,String destination) async {
    final String url = 
                'https://maps.googleapis.com/maps/api/directions/json?porigin=$origin&destination=$destination&key=$key'
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);

    var results={
      'bounds_ne': json['routes'] [0] ['bounds'] ['northest'],
      'bounds_sw': json['routes'] [0] ['bounds'] ['southwest'],
      'start_location': json['routes'] [0] ['legs'] ['start_location'],
      'end_location': json['routes'] [0] ['legs'] ['end_location'],
      'polyline':json['routes'] [0] ['overview_polyline'] ['points'],
      'poyline_decoded': PolylinePoints()
              .decodePolyline(json['routes'][0]['overview_polyline']['points']),
              

    };

    print(results);
    print(json);
  }
}
