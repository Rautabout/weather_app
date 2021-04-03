import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/api_connect.dart';
import 'package:weather_app/src/models.dart';
import 'package:flutter/services.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class TextBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: TextField(
        decoration:
        InputDecoration(border: InputBorder.none, hintText: 'Search'),
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  final _cityTextController=TextEditingController();
  final _dataService=DataService();
  bool isSwitched=false;
  Icon customIcon=Icon(Icons.search);
  Widget customSearchBar=Text("Enter City Name");
  WeatherResponse _response;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(

        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.white70,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Switch(
            value: isSwitched,
            onChanged: (value){
              setState(() {
                isSwitched=value;
                print(isSwitched);
              });
            },
            activeColor: Colors.black12,
            inactiveThumbColor: Colors.black12,
          ),
          centerTitle: true,
          title: SizedBox(
            width: 150,
            child: TextField(
                textInputAction: TextInputAction.search,
                onSubmitted: (String value){
                  _search();
                },
                controller: _cityTextController,
                decoration: InputDecoration(
                    hintText: "City Name",
                    hintStyle: TextStyle(
                      color: Colors.black87,
                    ),
                ),
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center),
          ),
          actions: [
            IconButton(icon: Icon(Icons.search),onPressed: _search)
          ],
        ),

        body: Center(
          child: Column(
          children: <Widget>[
            Visibility(
              visible: isSwitched==false, //second view is set to invisible, by pressing the switch it activates
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if(_response!=null) ...[
                      Container(
                      margin: EdgeInsets.all(25.0)
                      ),
                      Text(_response.cityName+', '+_response.sysInfo.country,
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(new DateFormat.E('en_US').format(_response.date)+', '+new DateFormat.MMMMd('en_US').format(_response.date)+' '+new DateFormat.Hm().format(_response.date),
                        style: TextStyle(
                            fontSize: 18
                        ),),
                      Image.network(_response.iconUrl,scale: .55,),
                      Text(_response.weatherInfo.description, style: TextStyle(fontSize: 15)),
                      Text(
                        '${_response.tempInfo.temperature.round()}°C',
                        style: TextStyle(fontSize: 80),
                      ),
                      Container(
                        margin: EdgeInsets.all(25.0),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87,width: 0.25),
                          color: Color(0xFFBDBDBD),


                        ),
                        padding: EdgeInsets.fromLTRB(30, 25, 30, 25),
                        margin: EdgeInsets.fromLTRB(15, 0, 15, 0),

                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(new DateFormat.Hm().format(_response.sysInfo.sunrise),textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                                Text('Sunrise',textAlign: TextAlign.center,style: TextStyle(fontSize: 14)),
                                Divider(
                                  height: 50,
                                ),
                                Text('${_response.tempInfo.pressure} hPa',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                                Text('Pressure',textAlign: TextAlign.center,style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Container(margin: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(new DateFormat.Hm().format(_response.sysInfo.sunset),textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                                Text('Sunset',textAlign: TextAlign.center,style: TextStyle(fontSize: 14)),
                                Divider(
                                  height: 50,
                                ),
                                Text('${_response.tempInfo.humidity}%',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                                Text('Humidity',textAlign: TextAlign.center,style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Container(margin: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${(_response.windInfo.windSpeed*18)~/5} km/h', textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                                Text('Wind Speed', textAlign: TextAlign.center,style: TextStyle(fontSize: 14)),
                                Divider(
                                  height: 50,
                                ),
                                Text('${_response.tempInfo.feels_like.round()}°C',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                                Text('Feels Like',textAlign: TextAlign.center,style: TextStyle(fontSize: 14)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
            ),


            Visibility(
              visible: isSwitched==true,
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if(_response!=null) ...[
                  Text(_response.cityName+', '+_response.sysInfo.country,
                    style: TextStyle(fontSize: 40),
                  ),
                  Container(margin: EdgeInsets.all(8.0)),
                  Text(new DateFormat.E('en_US').format(_response.date)+', '+new DateFormat.MMMMd('en_US').format(_response.date)+' '+new DateFormat.Hm().format(_response.date),
                      style: TextStyle(
                          fontSize: 22
                      )
                  ),
                  Container(margin: EdgeInsets.all(5.0)),

                  Text(_response.weatherInfo.description, style: TextStyle(fontSize: 22)),

                  Image.network(_response.iconUrl,scale: .55,),
                  Text(
                    '${_response.tempInfo.temperature.round()}°C',
                    style: TextStyle(fontSize: 95),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87,width: 0.25),
                      color: Color(0xFFBDBDBD),


                    ),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    margin: EdgeInsets.fromLTRB(15, 0, 15, 0),

                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(new DateFormat.Hm().format(_response.sysInfo.sunrise),textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                            Text('Sunrise',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                            Divider(
                              height: 30,
                            ),
                            Text('${_response.tempInfo.pressure} hPa',textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                            Text('Pressure',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                            Divider(
                              height: 30,
                            ),
                            Text('${_response.tempInfo.humidity}%',textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                            Text('Humidity',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                          ],
                        ),
                        Container(margin: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(new DateFormat.Hm().format(_response.sysInfo.sunset),textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                            Text('Sunset',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                            Divider(
                              height: 30,
                            ),
                            Text('${(_response.windInfo.windSpeed*18)~/5} km/h', textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                            Text('Wind Speed', textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                            Divider(
                              height: 30,
                            ),
                            Text('${_response.tempInfo.feels_like.round()}°C',textAlign: TextAlign.center,style: TextStyle(fontSize: 20)),
                            Text('Feels Like',textAlign: TextAlign.center,style: TextStyle(fontSize: 17)),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ],
            ))
            ,
          ],
        ),

      ),
      ),
    );
  }
  void _search() async{
    final response=await _dataService.getWeather(_cityTextController.text);
    print(response);
    setState(() => _response=response);
  }
}

