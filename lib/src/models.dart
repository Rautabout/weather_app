/*
{
"coord":
  {
  "lon":18.6766,
  "lat":50.2976
  },
"weather":
  [
    {
      "id":500,
      "main":"Rain",
      "description":"light rain",
      "icon":"10d"
    }
  ],
"base":"stations",
"main":
  {
    "temp":288.37,
    "feels_like":285.45,
    "temp_min":288.15,
    "temp_max":288.71,
    "pressure":1018,
    "humidity":41
  },
"visibility":10000,
"wind":
  {
    "speed":1.79,
    "deg":332,
    "gust":1.79
  },
"rain":
  {
    "1h":0.11
  },
"clouds":
  {
    "all":19
  },
"dt":1616776031,
"sys":
  {
    "type":3,
    "id":2031990,
    "country":"PL",
    "sunrise":1616733283,
    "sunset":1616778419
  },
"timezone":3600,
"id":3099230,
"name":"Gliwice",
"cod":200
}
*/



import 'package:flutter/material.dart';
import 'package:weather_app/main.dart';

//Getting info from API and putting it into a constructor

class WindInfo{
  final double windSpeed;

  WindInfo({this.windSpeed});
  factory WindInfo.fromJson(Map<String,dynamic>json){
    final windSpeed=json['speed'];
    return WindInfo(windSpeed: windSpeed);
  }
}

class WeatherInfo{
  final String description;
  final String icon;

  WeatherInfo({this.description,this.icon});

  factory WeatherInfo.fromJson(Map<String,dynamic>json){
    final description=json['description'];
    final icon=json['icon'];
    return WeatherInfo(description: description,icon: icon);
  }
}

class TemperatureInfo{
  final double temperature;
  final double feels_like;
  final int pressure;
  final int humidity;
  TemperatureInfo({this.temperature,this.pressure,this.humidity,this.feels_like});

  factory TemperatureInfo.fromJson(Map<String,dynamic>json){
    final temperature=json['temp'];
    final pressure=json['pressure'];
    final humidity=json['humidity'];
    final feels_like=json['feels_like'];
    return TemperatureInfo(temperature: temperature,pressure: pressure,humidity: humidity,feels_like: feels_like);
  }
}

class SysInfo{
  final String country;
  final DateTime sunrise;
  final DateTime sunset;
  SysInfo({this.country,this.sunrise,this.sunset});

  factory SysInfo.fromJson(Map<String,dynamic>json){
    final country=json['country'];
    final sunrise=new DateTime.fromMillisecondsSinceEpoch(json['sunrise']*1000,isUtc: false);
    final sunset=new DateTime.fromMillisecondsSinceEpoch(json['sunset']*1000,isUtc: false);
    return SysInfo(country: country,sunrise: sunrise,sunset: sunset);
  }
}

class WeatherResponse{
  final String cityName;
  final DateTime date;
  final TemperatureInfo tempInfo;
  final WeatherInfo weatherInfo;
  final SysInfo sysInfo;
  final WindInfo windInfo;


  String get iconUrl{
    return 'https://openweathermap.org/img/wn/${weatherInfo.icon}@2x.png';
  }

  WeatherResponse({this.cityName,this.tempInfo,this.weatherInfo,this.windInfo,this.sysInfo,this.date});

  factory WeatherResponse.fromJson(Map<String, dynamic> json){
    final cityName=json['name'];
    final date=new DateTime.fromMillisecondsSinceEpoch(json['dt']*1000,isUtc: false);

    final mainJson=json['main'];
    final tempInfo=TemperatureInfo.fromJson(mainJson);

    final sysJson=json['sys'];
    final sysInfo=SysInfo.fromJson(sysJson);

    final windJson=json['wind'];
    final windInfo=WindInfo.fromJson(windJson);

    final weatherInfoJson=json['weather'][0];
    final weatherInfo=WeatherInfo.fromJson(weatherInfoJson);

    return WeatherResponse(cityName: cityName,tempInfo: tempInfo,weatherInfo:weatherInfo,windInfo: windInfo,sysInfo: sysInfo,date: date);
  }
}