import 'package:covidtracker/protrait_layout.dart';
import 'package:covidtracker/landscape_layout.dart';
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "India Covid-19 Tracker",
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: orientation == Orientation.portrait ? Protrait() : LandScape(),
    );
  }
}
