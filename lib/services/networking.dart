import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {
  late String url;

  NetworkHelper(this.url);

  Future getData() async {
    http.Response response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
