import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Weather Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/icons/bg2.jpg'),
          fit: BoxFit.fill
          )
        ),
        child: PageView(
            children: [
              WeatherPage('dar'),
              WeatherPage('arusha'),
              WeatherPage('tanga'),
            ],
          ),
      )
    );
  }
}

class WeatherPage extends StatefulWidget{
  String city;

  WeatherPage(String city){
    this.city = city;
  }

  @override
  State<StatefulWidget> createState() {
    return new WeatherPageState(this.city);
  }
  
}

class WeatherPageState extends State<WeatherPage>{

  WeatherPageState(String city){
    this.city = city;
    debugPrint('$city');
    print('$city');
    if(city == "dar"){
      this.fullName = "Dar es salaam";
    }else if(city == "arusha"){
      this.fullName = "Arusha";
    }else if(city == "tanga"){
      this.fullName = "Tanga";
    }
  }

  String city = "dar";
  String fullName = "Dar es salaam";
  var temp = 0.0;
  var humidity = 0;
  var pressure = 0;
  var wind = 0.0;
  var weather = "";

  Future<String> _loadWeatherDate() async{
    var response = await http.get(Uri.encodeFull("http://api.openweathermap.org/data/2.5/weather?q=$city&appid=dec4fa76ff428e8c3a0a6a6152d352cd"),headers: {"Accept":"application/json"});

    setState((){
      var body = json.decode(response.body);
      var fahr = body['main']['temp'];
      var tempDouble = (fahr - 32)*(5/9);
      temp = double.parse(tempDouble.toStringAsFixed(0));
      humidity = body['main']['humidity'];
      pressure = body['main']['pressure'];
      wind = body['wind']['speed'];
      List li = body['weather'];
      weather = li[0]['main'];
    });
    return "success";
  }

  @override
  void initState() {
    super.initState();
    this._loadWeatherDate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(1.0),
      child: Stack(
        children: [
          topLeft(),
          Positioned(
            bottom: 20,
            child: bottom()
          )
        ],
        ),
    );
  }

  Widget topLeft(){
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.only(top:45.0,left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$temp C",style: TextStyle(fontSize: 34,color: Colors.white)),
            Text("$weather",style: TextStyle(fontSize: 14,color: Colors.white)),
            Text("$fullName",style: TextStyle(fontSize: 14,color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget bottom(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(1.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            weatherData('assets/icons/wind.png','Wind','$wind km/h'),
            weatherData('assets/icons/humidity.png','Humidity','$humidity %'),
            weatherData('assets/icons/pressure.png','Pressure','$pressure hmps')
          ],
        ),
      ),
    );
  }

  Widget weatherData(String icon,String type,var value){
    return Container(
      width: 115,
      height: 200,
      child: Card(
        elevation: 1.0,
        color: Colors.transparent,
        child: Container(color: Colors.transparent,
          // decoration: BoxDecoration(
          //   color: Colors.purple,backgroundBlendMode: BlendMode.darken,
          //   borderRadius: BorderRadius.circular(10),
          //   image: DecorationImage(image: AssetImage('assets/icons/bottom.jpg'),
          //   fit: BoxFit.fill)
          // ),
          child: Stack(
          children: [
            Positioned.fill(
              top: 25,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 40,
                  width: 40,
                  child: Image.asset(icon),
                ),
              )
            ),
            Positioned.fill(
              top: 95,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text('$value',style: TextStyle(color: Colors.white),),
              )
            ),
            Positioned.fill(
              top: 150,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text('$type',style: TextStyle(color: Colors.white54),),
              )
            ),
          ],
        ),
        ),
      ),
    );
  }
  
}
