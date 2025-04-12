import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_map_marker_layer/flutter_map_marker_layer.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../providers/location_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final userLocation = locationProvider.currentLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('Football Buddy')),
      body:
          userLocation == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                mapController: MapController(),
                options: MapOptions(
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                  initialCenter: userLocation,
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                    retinaMode: RetinaMode.isHighDensity(context),
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: userLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
    );
  }
}
