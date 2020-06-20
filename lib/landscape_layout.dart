import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_widgets/responsive_widgets.dart';

const textColor = Colors.white;
const stateColor = Colors.black;

class LandScape extends StatefulWidget {
  @override
  _LandScapeState createState() => _LandScapeState();
}

class _LandScapeState extends State<LandScape> {
  var activeCases;
  var totalRecoveries;
  var totalDeaths;
  var totalCases;
  var parsedData;
  var refreshedTime;
  int statesLength;

  final String url =
      'https://api.rootnet.in/covid19-in/unofficial/covid19india.org/statewise';

  Future<String> _getList() async {
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
    Map map = json.decode(response.body) as Map;

    setState(() {
      parsedData = map;
    });

    var data = map['data']['total'];

    String refreshedData = map['lastRefreshed'];

    setState(() {
      totalCases = data['confirmed'];
      totalRecoveries = data['recovered'];
      totalDeaths = data['deaths'];
      activeCases = data['active'];
      statesLength = parsedData['data']['statewise'].length;
      var datetime = refreshedData.replaceAll('T', ' \nTime: ');
      var dataRefreshed = datetime.replaceAll('2020', 'Date: 2020');
      refreshedTime = dataRefreshed;
    });
    return "${response.statusCode}";
  }

  @override
  // ignore: must_call_super
  void initState() {
    this._getList();
  }

  void _snackBar(BuildContext context) {
    Flushbar(
      icon: Icon(
        Icons.access_time,
        color: textColor,
      ),
      message: "Last Updated Time\n$refreshedTime",
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(10.0),
      maxWidth: 200,
      borderRadius: 20,
      borderWidth: 5.0,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1920, // Optional
      width: 1080, // Optional
//      allowFontScaling: true, // Optional
    );

    return Scaffold(
      body: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 100,
        showChildOpacityTransition: false,
        onRefresh: () {
          _snackBar(context);
          return _getList();
        },
        child: statesLength == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextResponsive(
                    "Fetching Data Please Wait",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1),
                itemCount: statesLength,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white70,
                    child: GridTile(
                      child: Center(
                          child: Column(
                        children: [
                          Expanded(
                            child: Center(
                              child: TextResponsive(
                                "\n${index + 1}.${parsedData['data']['statewise'][index]['state']}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40.0),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: TextResponsive(
                                "Confirmed Cases: ${parsedData['data']['statewise'][index]['confirmed']}\n"
                                "Active Cases: ${parsedData['data']['statewise'][index]['active']}\n"
                                "Recovered Cases:  ${parsedData['data']['statewise'][index]['recovered']}\n"
                                "Deaths: ${parsedData['data']['statewise'][index]['deaths']}\n",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
