import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:football_buddy/providers/nearby_points_provider.dart';
import 'package:football_buddy/widgets/add_location_sheet.dart';
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
  final _mapController = MapController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pointsProvider = context.read<NearbyPointsProvider>();
      final locationProvider = context.read<LocationProvider>();
      final location = await locationProvider.currentLocation!;
      await pointsProvider.fetchNearbyPoints(location);

      _mapController.mapEventStream.listen((event) {
        if (event is MapEventMove) {
          final bounds = _mapController.camera.visibleBounds;
          if (bounds != null) {
            pointsProvider.fetchWithinBounds(bounds);
          }
        }
      });
      
      
    });
  }

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
                mapController: _mapController,
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
                    markers: context
                        .watch<NearbyPointsProvider>()
                        .withinBoundsPoints.map((point){
                          final pos = point['location'];
                          return Marker(
                            point: LatLng(pos.latitude, pos.longitude),
                            child: const Icon(Icons.sports_soccer_outlined, color: Colors.green, size: 30),
                          );
                        }).toList(), 
                  ),
                ],
              ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'locate',
            onPressed: () {
              _mapController.move(userLocation!, 16);
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              final location = context.read<LocationProvider>();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) {
                  return AddLocationSheet(
                    lat: userLocation!.latitude,
                    lng: userLocation!.longitude,
                  );
                },
              );
            },
            heroTag: 'add',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
