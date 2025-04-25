import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NearbyPointsProvider with ChangeNotifier {
  final _collection = FirebaseFirestore.instance.collection('locations');
  List<Map<String, dynamic>> _nearbyPoints = [];
  List<Map<String, dynamic>> _withinBoundsPoints = [];
  List<Map<String, dynamic>> get nearbyPoints => _nearbyPoints;
  List<Map<String, dynamic>> get withinBoundsPoints => _withinBoundsPoints;


  Future<void> fetchNearbyPoints(LatLng currentLocation) async {
    final snapshot = await _collection.get();
    final allPoints = snapshot.docs.map((doc) => doc.data()).toList();

    _nearbyPoints = allPoints.where((point) {
      final pointLocation = LatLng(point['location'].latitude, point['location'].longitude);
      return _isWithinRadius(currentLocation, pointLocation, 5000); // 5 km radius
    }).toList();

    notifyListeners();
  }
  bool _isWithinRadius(LatLng point1, LatLng point2, double radius) {
    final distance = Distance().as(LengthUnit.Meter, point1, point2);
    return distance <= radius;
  }

  Future<void> fetchWithingBounds(LatLngBounds bounds) async {
    final minLat = bounds.south;
    final maxLat = bounds.north;
    final minLng = bounds.west;
    final maxLng = bounds.east;

    _withinBoundsPoints = _nearbyPoints.where((point) {
      final pointLocation = LatLng(point['location'].latitude, point['location'].longitude);
      return pointLocation.latitude >= minLat &&
             pointLocation.latitude <= maxLat &&
             pointLocation.longitude >= minLng &&
             pointLocation.longitude <= maxLng;
    }).toList();
  }

  
}