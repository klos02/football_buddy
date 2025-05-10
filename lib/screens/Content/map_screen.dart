import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  late MapController _mapController;

  @override
  void initState() {
    super.initState();

    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final userLocation = locationProvider.currentLocation;
    final nearbyPointsProvider = Provider.of<NearbyPointsProvider>(context);

    if (userLocation != null) {
      nearbyPointsProvider.fetchNearbyPoints(userLocation);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Football Buddy')),
      body: Stack(
        children: [
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
                    markers:
                        context.watch<NearbyPointsProvider>().nearbyPoints.map((
                          point,
                        ) {
                          final pos = point['location'];
                          return Marker(
                            point: LatLng(pos.latitude, pos.longitude),
                            child: const Icon(
                              Icons.sports_soccer_outlined,
                              color: Colors.green,
                              size: 30,
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
          Positioned(
            top: 20,
            left: 20,
            //right: 20,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      Icons.sports_soccer_outlined,
                      color: Colors.green,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      nearbyPointsProvider.getNearbyPointsCount().toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      //floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,

        children: [
          SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                label: 'Zgłoś chęć grania',

                child: const Icon(Icons.sports_soccer_outlined),

                onTap: () {
                  //final location = context.read<LocationProvider>();
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder: (context) {
                      return AddLocationSheet(
                        lat: userLocation!.latitude,
                        lng: userLocation.longitude,
                      );
                    },
                  );
                },
              ),
              SpeedDialChild(
                label: 'Zaproponuj mecz',
                child: const Icon(Icons.sports_soccer_sharp),
                onTap: () {
                  
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            heroTag: 'locate',
            shape: const CircleBorder(),
            onPressed: () {
              _mapController.move(userLocation!, 16);
            },
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}
