import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationSettingsPage extends StatefulWidget {
  @override
  _LocationSettingsPageState createState() => _LocationSettingsPageState();
}

class _LocationSettingsPageState extends State<LocationSettingsPage> {
  String status = '';

  @override
  void initState() {
    super.initState();
    updateLocationSettings();
  }

  Future<void> updateLocationSettings() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        status = 'Location permission denied.';
      });
      return;
    }

    final LocationAccuracy desiredAccuracy = LocationAccuracy.high;
    final int desiredInterval = 5000; // Update interval in milliseconds (5 seconds)

    final LocationOptions locationOptions =
        LocationOptions(accuracy: desiredAccuracy, distanceFilter: 0);

    await Geolocator.openLocationSettings()
        .timeout(Duration(seconds: 10), onTimeout: () {
      setState(() {
        status = 'Location settings update timed out.';
      });
    }).catchError((error) {
      setState(() {
        status = 'Error updating location settings: $error';
      });
    });

    if (status.isEmpty) {
      setState(() {
        status = 'Location settings updated successfully.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Settings'),
      ),
      body: Center(
        child: Text(status),
      ),
    );
  }
}
