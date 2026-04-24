import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationResult {
  final Position? data;
  final String? error;
  final bool isSuccess;

  LocationResult._({this.data, this.error, required this.isSuccess});

  factory LocationResult.success(Position data) => LocationResult._(data: data, isSuccess: true);
  factory LocationResult.failure(String error) => LocationResult._(error: error, isSuccess: false);
}

class LocationService {
  Future<LocationResult> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.failure('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.failure('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.failure('Location permission permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LocationResult.success(position);
    } catch (e) {
      return LocationResult.failure('Failed to get location: $e');
    }
  }

  Future<String?> getCityFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.locality ?? place.administrativeArea ?? place.country;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateDriverLocation(String driverId, double lat, double lng) async {
    // This would update Firestore - implemented in repository
  }
}