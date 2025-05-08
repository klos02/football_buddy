import 'package:flutter/material.dart';
import 'package:football_buddy/providers/location_provider.dart';
import 'package:football_buddy/providers/nearby_points_provider.dart';
import 'package:provider/provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final nearbyPointsProvider = Provider.of<NearbyPointsProvider>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final userLocation = locationProvider.currentLocation;
    return Scaffold(
      body:
          nearbyPointsProvider.nearbyPoints.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: nearbyPointsProvider.getNearbyPointsCount(),
                itemBuilder: (context, index) {
                  final point = nearbyPointsProvider.nearbyPoints[index];
                  return ListTile(
                    title: Text(point['name']),
                    subtitle: Text(
                      '${locationProvider.calculateDistance(userLocation!, point['location']).toStringAsFixed(2)} m away',
                    ),
                  );
                },
              ),
    );
  }
}
