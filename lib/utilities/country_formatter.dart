const Map<String, String> countryAliases = {
  "United States of America": "USA",
  "United Kingdom": "UK",
  "United Arab Emirates": "UAE",
};

String formatCountry(String country) {
  return countryAliases[country] ?? country;
}
