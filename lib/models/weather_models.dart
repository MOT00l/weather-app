class WeatherModel {
  String? location, description, icon;
  dynamic temperatur, feelslike, humidity, wind;
  double? lat, lon;

  WeatherModel({
    this.location,
    this.description,
    this.icon,
    this.temperatur,
    this.feelslike,
    this.humidity,
    this.wind,
    this.lat,
    this.lon,
  });
}

// class WeatherModel {
//   final String location;
//   final String description;
//   final String icon;
//
//   final double temperatur;
//   final double feelslike;
//   final int humidity;
//   final double wind;
//
//   final double? lat;
//   final double? lon;
//
//   WeatherModel({
//     required this.location,
//     required this.description,
//     required this.icon,
//     required this.temperatur,
//     required this.feelslike,
//     required this.humidity,
//     required this.wind,
//     this.lat,
//     this.lon,
//   });
// }
