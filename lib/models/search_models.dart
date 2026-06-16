class SearchModel {
  String? location, description, icon, winddir;
  dynamic temperatur,
      feelslike,
      humidity,
      wind,
      tempmin,
      tempmax,
      pressure,
      uv,
      chanceofrain;
  double? lat, lon;

  SearchModel(
      {this.location,
      this.description,
      this.icon,
      this.tempmin,
      this.tempmax,
      this.pressure,
      this.temperatur,
      this.feelslike,
      this.humidity,
      this.wind,
      this.lat,
      this.lon,
      this.uv,
      this.winddir,
      this.chanceofrain});
}
