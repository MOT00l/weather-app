class ForecastModel {
  dynamic date1, date2, date3;
  String? icon1, icon2, icon3, location;
  double? tempmax1,
      tempmax2,
      tempmax3,
      tempmin1,
      tempmin2,
      tempmin3,
      maxwind1,
      maxwind2,
      maxwind3;

  ForecastModel({
    this.date1,
    this.date2,
    this.date3,
    this.icon1,
    this.icon2,
    this.icon3,
    this.maxwind1,
    this.maxwind2,
    this.maxwind3,
    this.tempmax1,
    this.tempmax2,
    this.tempmax3,
    this.tempmin1,
    this.tempmin2,
    this.tempmin3,
    this.location,
  });
}
