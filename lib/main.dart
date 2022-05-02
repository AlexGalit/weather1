
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/src/painting/_network_image_io.dart';



void main() => runApp(const WeatherApp());


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
  List maxTemperatureForecast = [0];
  List minTemperatureForecast = [0];
  List abrevForecast = [0];

  String maxTemperature = '';
 String minTemperature = '';
 //dynamic abrevForecast = [1];

@override
  initState(){
    super.initState();
    fetchLocation();
    fetchLocationDay();
  }

   void fetchSearch( String input) async {
    try {
      //print('start fetch');
      final searchResult = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=' + input +
              '&appid=8ca060fa79da0dbfafb1d6080ceb51df'));
      print('searchResult $searchResult');
      var result = json.decode(searchResult.body);
      print('result $result');

      setState(() {
        location = result["name"];
        temperature = (result["main"]["temp"] - 273.17).round();
        //print('setState by fetch');
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
      //print('setState by fetch');
      weat = result["weather"][0]["main"].replaceAll(' ','').toLowerCase();
      abrev = result["weather"][0]["icon"];
    });



  }
  void fetchLocationDay() async {

  var today = DateTime.now();

  for (var i=0; i<7; i++){
   final locationDayResult = await http.get(Uri.parse ('https://api.openweathermap.org/data/2.5/weather?q=san francisco&appid=8ca060fa79da0dbfafb1d6080ceb51df'.toString()
       + DateFormat('y/M/d').format.toString()+today.add(Duration(days: i+1)).toString()));
   var result = json.decode(locationDayResult.body);
   print('result $result');
   //abrev = result["weather"][0]["icon"].toString();
   //minTemperature =((result["main"]["temp_min"]-273.17).round());
   //maxTemperature =((result["main"]["temp_max"]-273.17).round());

   setState(() {

     minTemperatureForecast[i]=((result["main"]["temp_min"]-273.17).round());
     maxTemperatureForecast[i]=((result["main"]["temp_max"]-273.17).round());
     abrevForecast[i]=(result["weather"][0]["icon"]);
     minTemperature =((result["main"]["temp_min"]-273.17).round());
     maxTemperature =((result["main"]["temp_max"]-273.17).round());
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
                              style: const TextStyle(color: Colors.white, fontSize: 60.0),
                      ),
                    ),
                    Center(
                      child: Text(
                        location,
                        style: const TextStyle(color: Colors.white, fontSize: 40),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                    child: Row(

                      children:<Widget>[
                       forecastElement(1, abrevForecast[0], minTemperature[0], maxTemperature[0]),
                        forecastElement(2, abrev, minTemperature, maxTemperature),
                        forecastElement(3, abrev, minTemperature, maxTemperature),
                       //forecastElement(2, abrevForecast[1], minTemperatureForecast[1], maxTemperatureForecast[1]),
                        ]
                    ),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(
                            width: 300,
                            child: TextField(
                              onSubmitted: (String input){
                                onTextFieldSubmited(input);
                              },
                                style: const TextStyle(color: Colors.white, fontSize: 25.0),
                                decoration: const InputDecoration(
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
                          style: const TextStyle(
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
Widget forecastElement(daysFromNow, abrev, minTemperature, maxTemperature){
  dynamic now = DateTime.now();
  dynamic oneDayFromNow = now.add(Duration(days: daysFromNow));

  return Padding(
    padding: const EdgeInsets.only(left: 16.0),
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(205, 212, 228, 0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(DateFormat.E().format(oneDayFromNow),
                      style: const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Text(
                          DateFormat.MMMd().format(oneDayFromNow),
                          style: const TextStyle(color: Colors.white, fontSize: 20)),
                      Image.network('http://openweathermap.org/img/wn/' +
                          abrev.toString() + '.png', width: 20),
                      Text('hight:' + maxTemperature.toString() + ' °C',
                    style: const TextStyle(color: Colors.white, fontSize: 30.0)),
                      Text('low:' + minTemperature.toString() + ' °C',
                    style: const TextStyle(color: Colors.white, fontSize: 30.0),
                   // ),
                      )],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

