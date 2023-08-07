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
