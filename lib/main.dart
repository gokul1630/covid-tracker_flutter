import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import './about.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const textColor = Colors.white;
const stateColor = Colors.black;

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "India Covid-19 Tracker",
        theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Color(0xFFFFFFFF)),
        home: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var activeCases;
  var totalRecoveries;
  var totalDeaths;
  var totalCases;
  var parsedData;
  var noResponse;

  final String url = 'https://covid19-mohfw.herokuapp.com/';

  Future<String> getList() async {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
    Map map = json.decode(response.body) as Map;

    if (response.statusCode == 200) {
      print("ok");
    } else {
      setState(() {
        noResponse = "Please Turn On Data";
      });
    }
    setState(() {
      parsedData = map;
    });
    var data = map['totals'];
    setState(() {
      totalCases = data['total'];
      totalRecoveries = data['recoveries'];
      totalDeaths = data['deaths'];
      activeCases = data['cases'];
    });
  }

  @override
  // ignore: must_call_super
  void initState() {
    this.getList();
  }

  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text("India Covid-19 Tracker"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: textColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return about();
              }));
            },
          ),
        ],
        bottom: PreferredSize(
          child: Container(
            height: 95.0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    totalCases == null
                        ? Expanded(
                            child: Text(
                              "Fetching Data Please Wait",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, color: textColor),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              'Total Cases\n$totalCases',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          ),
                    activeCases == null
                        ? Expanded(
                            child: Text(
                              "Fetching Data Please Wait",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              'Active Cases\n$activeCases',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    totalRecoveries == null
                        ? Expanded(
                            child: Text(
                              "Fetching Data Please Wait",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              'Recovered Cases\n$totalRecoveries',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          ),
                    totalDeaths == null
                        ? Expanded(
                            child: Text(
                              "Fetching Data Please Wait",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          )
                        : Expanded(
                            child: Text(
                              'Deaths Cases\n$totalDeaths',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 18.0, color: textColor),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(95.0),
        ),
      ),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: false,
        animSpeedFactor: 100.0,
        onRefresh: getList,
        child: ListView.separated(
          padding: EdgeInsets.only(left: 60.0, right: 60.0),
          separatorBuilder: (context, index) => Divider(
            color: stateColor,
          ),
          itemCount: 35,
          itemBuilder: (BuildContext context, index) {
            return parsedData == null
                ? Center(
                    child: Center(
                      child: Text(
                        "Fetching Data Please Wait",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  )
                : ListTile(
                    title: Center(
                      child: Text(
                        "\n${parsedData['states'][index]['state']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: stateColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0),
                      ),
                    ),
                    subtitle: Center(
                      child: Text(
                        "\nConfirmed Cases: ${parsedData['states'][index]['total']}\n"
                        "Active Cases: ${parsedData['states'][index]['cases']}\n"
                        "Recovered Cases:  ${parsedData['states'][index]['recoveries']}\n"
                        "Deaths: ${parsedData['states'][index]['deaths']}\n",
                        style: TextStyle(
                          color: stateColor,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
