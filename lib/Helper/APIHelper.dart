import 'dart:convert';

import 'package:http/http.dart' as http;

class APIHelper {
  APIHelper._();
  static APIHelper apiHelper = APIHelper._();

  Future<Map?> Weather({required String Search}) async {
    String WeatherAPI =
        "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/$Search?unitGroup=metric&key=VUSDSK54DV5RS5L52K2VNCRT8&contentType=json";
    http.Response response = await http.get(Uri.parse(WeatherAPI));

    if (response.statusCode == 200) {
      Map? WeatherMap = jsonDecode(response.body);

      return WeatherMap;
    }
    return null;
  }
}
