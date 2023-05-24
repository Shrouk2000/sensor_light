import 'package:flutter/material.dart';
import 'dart:async';
import 'package:light/light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: SensorScreen() ,
    );
  }
}

class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  State<SensorScreen> createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  String _luxString = 'Unknown';
  late Light _light; //object from class light
  late StreamSubscription _subscription; 

  void onData(int luxValue) async {  //Function that reads the sensor
    print("Lux value: $luxValue");
    setState(() {  //refresh page
      _luxString = "$luxValue";
    });
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: int.parse(_luxString)> 25 ? Colors.white : Colors.black,
      appBar: AppBar(
        title: Text("Sensor Screen"),
      ),
      body: Center(child: Text("Sensor Value $_luxString" ,
      style: TextStyle(fontSize: 40 ,
      color: int.parse(_luxString)> 25 ? Colors.black : Colors.white),
      ),
      ),
    );
  }
}