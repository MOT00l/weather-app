const kWeatherApiIcons = {
  // Clear / Clouds
  "1000": {"label": "sunny", "icon": "sunny"},
  "1003": {"label": "partly cloudy", "icon": "sunny-overcast"},
  "1006": {"label": "cloudy", "icon": "cloudy"},
  "1009": {"label": "overcast", "icon": "cloudy-high"},

  // Atmosphere
  "1012": {"label": "haze", "icon": "day-haze"},
  "1015": {"label": "dust haze", "icon": "dust"},
  "1018": {"label": "blowing dust", "icon": "sandstorm"},
  "1021": {"label": "dust storm", "icon": "cloudy-gusts"},
  "1024": {"label": "sandstorm", "icon": "sandstorm"},
  "1027": {"label": "severe sandstorm", "icon": "tornado"},

  "1030": {"label": "mist", "icon": "sprinkle"},
  "1033": {"label": "smoke", "icon": "smoke"},
  "1036": {"label": "smoky haze", "icon": "smoke"},
  "1039": {"label": "smog", "icon": "smog"},
  "1042": {"label": "severe smog", "icon": "smog"},
  "1045": {"label": "saharan dust", "icon": "dust"},
  "1048": {"label": "dust", "icon": "dust"},

  // Possible conditions
  "1063": {"label": "patchy rain possible", "icon": "rain"},
  "1066": {"label": "patchy snow possible", "icon": "snow"},
  "1069": {"label": "patchy sleet possible", "icon": "sleet"},
  "1072": {"label": "patchy freezing drizzle possible", "icon": "rain-mix"},
  "1087": {"label": "thundery outbreaks possible", "icon": "lightning"},

  // Snow
  "1114": {"label": "blowing snow", "icon": "snow-wind"},
  "1117": {"label": "blizzard", "icon": "snow-wind"},

  // Fog
  "1135": {"label": "fog", "icon": "fog"},
  "1147": {"label": "freezing fog", "icon": "fog"},

  // Drizzle
  "1150": {"label": "patchy light drizzle", "icon": "sprinkle"},
  "1153": {"label": "light drizzle", "icon": "sprinkle"},
  "1168": {"label": "freezing drizzle", "icon": "rain-mix"},
  "1171": {"label": "heavy freezing drizzle", "icon": "rain-mix"},

  // Rain
  "1180": {"label": "patchy light rain", "icon": "rain-mix"},
  "1183": {"label": "light rain", "icon": "rain"},
  "1186": {"label": "moderate rain at times", "icon": "showers"},
  "1189": {"label": "moderate rain", "icon": "showers"},
  "1192": {"label": "heavy rain at times", "icon": "rain-wind"},
  "1195": {"label": "heavy rain", "icon": "rain"},

  // Freezing Rain
  "1198": {"label": "light freezing rain", "icon": "rain-mix"},
  "1201": {"label": "moderate or heavy freezing rain", "icon": "rain-mix"},

  // Sleet
  "1204": {"label": "light sleet", "icon": "sleet"},
  "1207": {"label": "moderate or heavy sleet", "icon": "sleet"},

  // Snow
  "1210": {"label": "patchy light snow", "icon": "snowflake-cold"},
  "1213": {"label": "light snow", "icon": "snow"},
  "1216": {"label": "patchy moderate snow", "icon": "snow-wind"},
  "1219": {"label": "moderate snow", "icon": "snow"},
  "1222": {"label": "patchy heavy snow", "icon": "snow-wind"},
  "1225": {"label": "heavy snow", "icon": "snow"},

  // Ice
  "1237": {"label": "ice pellets", "icon": "hail"},

  // Rain Showers
  "1240": {"label": "light rain shower", "icon": "showers"},
  "1243": {"label": "moderate or heavy rain shower", "icon": "showers"},
  "1246": {"label": "torrential rain shower", "icon": "rain-wind"},

  // Sleet Showers
  "1249": {"label": "light sleet showers", "icon": "sleet"},
  "1252": {"label": "moderate or heavy sleet showers", "icon": "sleet"},

  // Snow Showers
  "1255": {"label": "light snow showers", "icon": "rain-mix"},
  "1258": {"label": "moderate or heavy snow showers", "icon": "rain-mix"},

  // Ice Pellet Showers
  "1261": {"label": "light showers of ice pellets", "icon": "hail"},
  "1264": {"label": "moderate or heavy showers of ice pellets", "icon": "hail"},

  // Thunder
  "1273": {"label": "patchy light rain with thunder", "icon": "storm-showers"},
  "1276": {
    "label": "moderate or heavy rain with thunder",
    "icon": "thunderstorm"
  },
  "1279": {"label": "patchy light snow with thunder", "icon": "snow-wind"},
  "1282": {
    "label": "moderate or heavy snow with thunder",
    "icon": "thunderstorm"
  },
};

String getWeatherApiPrefix(int code) {
  const wiPrefixCodes = {
    // Atmospheric conditions
    1012, // haze
    1015, // dust haze
    1018, // blowing dust
    1021, // dust storm
    1024, // sandstorm
    1027, // severe sandstorm
    1030, // mist
    1033, // smoke
    1036, // smoky haze
    1039, // smog
    1042, // severe smog
    1045, // saharan dust
    1048, // dust

    // Fog
    1135, // fog
    1147, // freezing fog
  };

  return wiPrefixCodes.contains(code) ? "wi-" : "wi-day-";
}
