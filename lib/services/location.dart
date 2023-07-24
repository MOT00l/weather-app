import 'package:geolocator/geolocator.dart';

/// Location Class
///
/// By this class developer can get user current latitude and logitude.
class Location {
  double? latitude, longitude;

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    latitude = position.latitude;
    longitude = position.longitude;
  }
}
