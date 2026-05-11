import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MapboxOptions.setAccessToken(
    "pk.eyJ1Ijoia2ltaXlhbmciLCJhIjoiY21wMGxhbHFpMWlzdjJ4b2ZzcWo3cjY5ZCJ9.kLYgUejkShnMvdT-K3NaWw",
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MapboxMap? mapboxMap;

  Future<void> _zoomIn() async {
    if (mapboxMap == null) return;

    final cameraState = await mapboxMap!.getCameraState();
    final newZoom = cameraState.zoom + 1;

    await mapboxMap!.flyTo(
      CameraOptions(
        zoom: newZoom,
      ),
      MapAnimationOptions(
        duration: 500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CameraOptions camera = CameraOptions(
      center: Point(coordinates: Position(-98.0, 39.5)),
      zoom: 2,
      bearing: 0,
      pitch: 0,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            MapWidget(
              cameraOptions: camera,
              styleUri: "mapbox://styles/kimiyang/cmp11y75m000b01s7fr3615v9",
              onMapCreated: (MapboxMap controller) {
                mapboxMap = controller;
              },
              onStyleLoadedListener: (StyleLoadedEventData data) {
                debugPrint("Map style loaded successfully");
              },
            ),

            Positioned(
              right: 16,
              bottom: 32,
              child: FloatingActionButton(
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }
}