import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(
    "YOUR_MAPBOX_ACCESS_TOKEN",
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MapboxMap? map;

  geo.Position? userPosition;
  bool isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    try {
      bool serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }

      geo.LocationPermission permission =
          await geo.Geolocator.checkPermission();

      if (permission == geo.LocationPermission.denied) {
        permission = await geo.Geolocator.requestPermission();
      }

      if (permission == geo.LocationPermission.denied ||
          permission == geo.LocationPermission.deniedForever) {
        setState(() {
          isLoadingLocation = false;
        });
        return;
      }

      final position = await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
        ),
      );

      setState(() {
        userPosition = position;
        isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        isLoadingLocation = false;
      });
    }
  }

  Future<void> zoomIn() async {
    if (map == null) return;

    final camera = await map!.getCameraState();

    await map!.flyTo(
      CameraOptions(
        zoom: camera.zoom + 1,
      ),
      MapAnimationOptions(
        duration: 500,
      ),
    );
  }

  Future<void> zoomOut() async {
    if (map == null) return;

    final camera = await map!.getCameraState();

    await map!.flyTo(
      CameraOptions(
        zoom: camera.zoom - 1,
      ),
      MapAnimationOptions(
        duration: 500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingLocation) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    final double longitude = userPosition?.longitude ?? 103.7764;
    final double latitude = userPosition?.latitude ?? 1.2966;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            MapWidget(
              viewport: CameraViewportState(
                center: Point(
                  coordinates: Position(longitude, latitude),
                ),
                zoom: 15,
                bearing: 0,
                pitch: 0,
              ),
              styleUri: "mapbox://styles/kimiyang/cmp11y75m000b01s7fr3615v9",
              onMapCreated: (controller) async {
                map = controller;

                await map!.scaleBar.updateSettings(
                  ScaleBarSettings(enabled: false),
                );

                if (userPosition != null) {
                  await map!.location.updateSettings(
                    LocationComponentSettings(enabled: true),
                  );
                }
              },
            ),

            Positioned(
              right: 16,
              bottom: 32,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: "zoomIn",
                    onPressed: zoomIn,
                    child: const Icon(Icons.add),
                  ),

                  const SizedBox(height: 12),

                  FloatingActionButton(
                    heroTag: "zoomOut",
                    onPressed: zoomOut,
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}