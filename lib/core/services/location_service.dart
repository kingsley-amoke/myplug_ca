import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Request permission & get current position
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get position
    return await Geolocator.getCurrentPosition();
  }

  /// Get full location info from coordinates
  static Future<Map<String, String>?> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return {
          "street": place.street ?? "",
          "locality": place.locality ?? "",
          "subLocality": place.subLocality ?? "",
          "administrativeArea": place.administrativeArea ?? "",
          "country": place.country ?? "",
          "postalCode": place.postalCode ?? "",
        };
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  /// Get user's location & full address in one go
  static Future<Map<String, dynamic>?> getUserLocationInfo() async {
    Position? position = await getCurrentPosition();
    if (position == null) return null;

    final address =
        await getAddressFromLatLng(position.latitude, position.longitude);

    return {
      "latitude": position.latitude,
      "longitude": position.longitude,
      "address": address,
    };
  }
}
