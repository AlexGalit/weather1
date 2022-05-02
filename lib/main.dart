
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


void main() => runApp(WeatherApp());


class WeatherApp extends StatefulWidget {
  const WeatherApp({Key? key}) : super(key: key);

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {

  dynamic temperature = 0;

  String weat = 'clear';
  String location = 'San Francisco';
  String abrev = '';
  String errorMessage = '';
  List<int> maxTemperatureForecast = [];
  List<int> minTemperatureForecast = [];
  List<int> abrevForecast = [];


  initState(){
    super.initState();
    fetchLocation();
    fetchLocationDay();
  }

   void fetchSearch( String input) async {
    try {
      print('start fetch');
      final searchResult = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=' + input +
              '&appid=8ca060fa79da0dbfafb1d6080ceb51df'));
      print('searchResult $searchResult');
      var result = json.decode(searchResult.body);
      print('result $result');

      setState(() {
        location = result["name"];
        temperature = (result["main"]["temp"] - 273.17).round();
        print('setState by fetch');
        weat = result["weather"][0]["main"].replaceAll(' ', '').toLowerCase();
        abrev = result["weather"][0]["icon"].toString();
        errorMessage = '';
        // print('result $weat');
      });
    }
    catch (error){
      setState(() {
        errorMessage = "Sorry, an error occurred, please try again!";
      });
    }
  }
  void fetchLocation() async {
    final locationResult = await http.get(Uri.parse ('https://api.openweathermap.org/data/2.5/weather?q=san francisco&appid=8ca060fa79da0dbfafb1d6080ceb51df'));
    var result = json.decode(locationResult.body);
    setState(() {
      //id = result["sys"]["id"];
      location = result["name"];
      temperature = (result["main"]["temp"]-273.17).round();
      print('setState by fetch');
      weat = result["weather"][0]["main"].replaceAll(' ','').toLowerCase();
      abrev = result["weather"][0]["icon"];
    });



  }
  void fetchLocationDay() async {

  var today = new DateTime.now();
  for (var i=0; i<7; i++){
   final locationDayResult = await http.get(Uri.parse ('https://api.openweathermap.org/data/2.5/weather?q=san francisco&appid=8ca060fa79da0dbfafb1d6080ceb51df'
       + new DateFormat('y/M/d').format.toString()+today.add(new Duration(days: i+1)).toString()));
   var result = json.decode(locationDayResult.body);
   abrev = result["weather"]["icon"];
   // minTemperature = result["list"]["temp_min"];
   // maxTemperature = result["list"]["temp_max"];

   setState(() {

     minTemperatureForecast[i] = (result["weather"]["main"]["temp_min"]-273.17).round();
     maxTemperatureForecast[i] = (result["weather"]["main"]["temp_max"]-273.17).round();
     abrevForecast[i] = result["weather"]["icon"];
   });
  }


  }


    void onTextFieldSubmited(String input)  {
          fetchSearch(input);
         fetchLocation();
          fetchLocationDay();
     }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/$weat.png'),
                fit: BoxFit.cover,
              )

          ),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Center(
                        child: Image.network(
                          'http://openweathermap.org/img/wn/'+abrev+'.png', width: 100,
                        ),
                        )
]
                    ),
                      Center(
                      child: Text(
                          temperature.toString() + ' °C',
                              style: TextStyle(color: Colors.white, fontSize: 60.0),
                      ),
                    ),
                    Center(
                      child: Text(
                        location,
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    Row(

                      children:<Widget>[
                       forecastElement(1, abrevForecast[0]), //minTemperatureForecast[0], maxTemperatureForecast[0]),
                       //forecastElement(2, abrevForecast[1], minTemperatureForecast[1], maxTemperatureForecast[1]),
                        ]
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                            width: 300,
                            child: TextField(
                              onSubmitted: (String input){
                                onTextFieldSubmited(input);
                              },
                                style: TextStyle(color: Colors.white, fontSize: 25.0),
                                decoration: InputDecoration(
                                  hintText: 'Пошук міста...',
                                  hintStyle: TextStyle(color: Colors.white, fontSize: 18),
                                  prefixIcon: Icon(Icons.search,
                                      color: Colors.white),
                                )
                            )
                        ),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.redAccent, fontSize: 20.0),
                        )
                      ],
                    )
                      ],
              ),

          )
      ),
    );
  }
}
Widget forecastElement(daysFromNow, abrev){ //minTemperature, maxTemperature){
  var now = new DateTime.now();
  var oneDayFromNow = now.add(new Duration(days: daysFromNow));

  return Container(
    decoration: BoxDecoration(
      color: Color.fromRGBO(205, 212, 228, 0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(new DateFormat.E().format(oneDayFromNow),
                    style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    Text(
                        new DateFormat.MMMd().format(oneDayFromNow),
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    Image.network('http://openweathermap.org/img/wn/' +
                        abrev + '.png', width: 20),
                   // Text('hight:' + maxTemperature.toString() + ' °C',
                 // style: TextStyle(color: Colors.white, fontSize: 30.0)),
                 //   Text('low:' + minTemperature.toString() + ' °C',
                //  style: TextStyle(color: Colors.white, fontSize: 30.0),
                 // ),
  ],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

