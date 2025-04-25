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

  Future<List<Map<String, dynamic>>> getLocations() async {
    final snapshot = await _locations.orderBy('timestamp', descending: true).get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}