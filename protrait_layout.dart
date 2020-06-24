import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_widgets/responsive_widgets.dart';
import 'package:covidtracker/about.dart';

const textColor = Colors.white;
const stateColor = Colors.black;
const textSize = 18.0;

class Protrait extends StatefulWidget {
  @override
  _ProtraitState createState() => _ProtraitState();
}

class _ProtraitState extends State<Protrait> {
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
      var parseData = dataRefreshed.replaceAll('Z', ' ');
      refreshedTime = parseData;
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
      allowFontScaling: true, // Optional
    );

    return Scaffold(
      appBar: AppBar(
        title: TextResponsive(
          "India Covid-19 Tracker",
          style: TextStyle(
            fontSize: 60.0,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: textColor,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return About();
              }));
            },
          ),
        ],
        bottom: PreferredSize(
          child: Container(
            height: 160.0,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      totalCases == null
                          ? Expanded(
                              child: TextResponsive(
                                "Fetching Data Please Wait",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            )
                          : Expanded(
                              child: TextResponsive(
                                'Total Cases\n$totalCases',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            ),
                      activeCases == null
                          ? Expanded(
                              child: TextResponsive(
                                "Fetching Data Please Wait",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            )
                          : Expanded(
                              child: TextResponsive(
                                'Active Cases\n$activeCases',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      totalRecoveries == null
                          ? Expanded(
                              child: TextResponsive(
                                "Fetching Data Please Wait",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            )
                          : Expanded(
                              child: TextResponsive(
                                'Recovered Cases\n$totalRecoveries',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            ),
                      totalDeaths == null
                          ? Expanded(
                              child: TextResponsive(
                                "Fetching Data Please Wait",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            )
                          : Expanded(
                              child: TextResponsive(
                                'Deaths Cases\n$totalDeaths',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 50.0, color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(150),
        ),
      ),
      body: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 100,
        showChildOpacityTransition: false,
        onRefresh: () {
          _snackBar(context);
          return _getList();
        },
        child: ListView.separated(
          padding: EdgeInsets.only(left: 60.0, right: 60.0),
          separatorBuilder: (context, index) => Divider(
            color: stateColor,
          ),
          itemCount: statesLength == null ? 1 : statesLength,
          itemBuilder: (BuildContext context, index) {
            return statesLength == null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextResponsive(
                        "Fetching Data Please Wait",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50.0),
                      ),
                    ),
                  )
                : ListTile(
                    title: Center(
                      child: TextResponsive(
                        "\n${index + 1}.${parsedData['data']['statewise'][index]['state']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: stateColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 60.0),
                      ),
                    ),
                    subtitle: Center(
                      child: TextResponsive(
                        "\nConfirmed Cases: ${parsedData['data']['statewise'][index]['confirmed']}\n"
                        "Active Cases: ${parsedData['data']['statewise'][index]['active']}\n"
                        "Recovered Cases:  ${parsedData['data']['statewise'][index]['recovered']}\n"
                        "Deaths: ${parsedData['data']['statewise'][index]['deaths']}\n",
                        style: TextStyle(
                          color: stateColor,
                          fontSize: 50.0,
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
