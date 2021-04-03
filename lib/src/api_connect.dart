import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/src/models.dart';

class DataService{

  Future<WeatherResponse> getWeather(String city) async{
    //api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
    //Connection to API

    final queryParam={'q':city,'appid':'645df917d3052f689a854060fc3b7d9b','units':'metric'};

    final uri=Uri.https('api.openweathermap.org', '/data/2.5/weather',queryParam);

    final response=await http.get(uri);

    print(response.body);
    final json=jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}