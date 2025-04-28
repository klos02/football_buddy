import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:football_buddy/providers/auth_provider.dart';
import 'package:football_buddy/providers/location_provider.dart';
import 'package:football_buddy/services/firestore_service.dart';

class LocationFormProvider with ChangeNotifier {
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthProvider _authProvider = AuthProvider();
  
  bool isLoading = false;
  
  String _selectedCard = '';

  String get selectedCard => _selectedCard;
  //late String userName;

  

  void setSelectedCard(String card) {
    _selectedCard = card;
    notifyListeners();
  }

  Future<void> addLocation(double lat, double lng, BuildContext context) async {
    if (formKey.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      try {
        await _firestoreService.addLocation(
          name: nameController.text,
          location: GeoPoint(lat, lng),
          userId: _authProvider.userId,
          userName: await _firestoreService.getUserName(_authProvider.userId),
          userPosition: _selectedCard,
          
          
        );
        Navigator.of(context).pop(); 
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding location: $e')));
      }
      finally {
        isLoading = false;
        notifyListeners();
      }
      
  
    }
  }
  void disposeFields() {
    nameController.dispose();
  }
}
