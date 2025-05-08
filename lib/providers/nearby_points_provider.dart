import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class NearbyPointsProvider with ChangeNotifier {
  final _collection = FirebaseFirestore.instance.collection('locations');
  List<Map<String, dynamic>> _nearbyPoints = [];
  StreamSubscription? _subscription;
  bool _isListening = false;

  List<Map<String, dynamic>> get nearbyPoints => _nearbyPoints;

  Future<void> fetchNearbyPoints(LatLng currentLocation) async {

    if (_isListening) {
      return;
    }
    
    _isListening = true;

    final radius = 0.1;
    final userLat = currentLocation.latitude;
    final userLng = currentLocation.longitude;

    _subscription = _collection
        .where('location', isGreaterThanOrEqualTo: GeoPoint(userLat - radius, userLng - radius))
        .where('location', isLessThanOrEqualTo: GeoPoint(userLat + radius, userLng + radius))
        .snapshots()
        .listen((snapshot) {
          _nearbyPoints = snapshot.docs.map((doc) => doc.data()).toList(); 
          notifyListeners();
        });
        
  }

  int getNearbyPointsCount() {
    return _nearbyPoints.length;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _isListening = false;
    super.dispose();
  }


}
