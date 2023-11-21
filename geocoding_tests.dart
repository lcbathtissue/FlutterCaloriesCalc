
  ReverseGeocode reverseGeocode = ReverseGeocode();
  Map<String, double> latLong = await reverseGeocode.getLatLongFromAddress('2000 Simcoe St N, Oshawa, ON L1G 0C5, Canada');
  print('Latitude: ${latLong['latitude']}');
  print('Longitude: ${latLong['longitude']}');