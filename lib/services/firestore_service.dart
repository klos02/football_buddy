import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _locations = FirebaseFirestore.instance.collection('locations');

  Future<void> addLocation({
    required String name,
    required GeoPoint location,
    required String userId,
    required String userName,
    required String userPosition
    
  }) async {
    await _locations.add({
      'name': name,
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
      'userId': userId,
      'userName': userName,
      'userPosition': userPosition,
    });
  }

  Future<String> getUserName(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data()?['name'] ?? 'Unknown User';
  }

  
}