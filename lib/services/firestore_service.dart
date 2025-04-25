import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _locations = FirebaseFirestore.instance.collection('locations');

  Future<void> addLocation({
    required String name,
    required GeoPoint location,
    
  }) async {
    await _locations.add({
      'name': name,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  
}