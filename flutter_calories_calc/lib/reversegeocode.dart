import 'package:geocoding/geocoding.dart';

class ReverseGeocode {
  Future<Map<String, double>> getLatLongFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        return {
          'latitude': location.latitude,
          'longitude': location.longitude,
        };
      }
    } catch (e) {
      print('Error getting lat/long: $e');
    }
    return {
      'latitude': 0.0,
      'longitude': 0.0,
    }; // Return default values or handle errors
  }
}
