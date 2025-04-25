import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class NearbyPointsProvider with ChangeNotifier {
  final _collection = FirebaseFirestore.instance.collection('locations');
  List<Map<String, dynamic>> _nearbyPoints = [];

  List<Map<String, dynamic>> get nearbyPoints => _nearbyPoints;

  Future<void> fetchNearbyPoints(LatLng currentLocation) async {
    final radius = 0.1;
    final userLat = currentLocation.latitude;
    final userLng = currentLocation.longitude;

    _collection
        .where('location', isGreaterThanOrEqualTo: GeoPoint(userLat - radius, userLng - radius))
        .where('location', isLessThanOrEqualTo: GeoPoint(userLat + radius, userLng + radius))
        .snapshots()
        .listen((snapshot) {
          _nearbyPoints = snapshot.docs.map((doc) => doc.data()).toList();
          notifyListeners();
        });
  }

}
