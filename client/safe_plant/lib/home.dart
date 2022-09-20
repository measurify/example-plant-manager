import 'dart:collection';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:safe_plant/login_response_json.dart';
import 'package:safe_plant/api_service.dart';
import 'package:safe_plant/measurements_respose_json.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:safe_plant/second_screen.dart';
import 'package:safe_plant/info_plant.dart';
import 'package:draw_graph/models/feature.dart' as Feat;
import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:intl/intl.dart';

int number = 80;
int type = 1; //  1=Day, 2=Week, 3=Month
double last_sun = 0;
double last_moisture = 0;

var baseDate = DateTime.now();
var startDate = DateTime.now();
var endDate = DateTime(baseDate.year, baseDate.month, baseDate.day + 1);

final List<Feat.Feature> features = [
  Feat.Feature(
    title: "Soil Moisture",
    color: Colors.green.shade300,
    data: [],
  ),
  Feat.Feature(
    title: "Luminosity",
    color: Colors.limeAccent.shade200,
    data: [],
  ),
];

class Home extends StatefulWidget {
  const Home({
    Key? key,
    required this.token,
    required this.username,
    required this.password,
    required this.tenant,
  }) : super(key: key);
  final String token;
  final String username;
  final String password;
  final String tenant;

  @override
  _HomeState createState() => _HomeState(
      token: token, username: username, password: password, tenant: tenant);
}

class _HomeState extends State<Home> {
  String token;
  String username;
  String password;
  String tenant;

  _HomeState({
    required this.token,
    required this.username,
    required this.password,
    required this.tenant,
  });

  late List<String> labelX = [];
  late LoginResponse? _loginResponse = null;
  late MeasurementsResponse? _measurementsResponse = null;
  late MeasurementsResponse? _lastMeasurementsResponse = null;
  late List<double>? _soilMoisture = [];
  late List<double>? _lumonisity = [];

  @override
  void initState() {
    super.initState();
    _getMeasurements(token);
  }

  void setTypeDate() {
    if (type == 1) {
      startDate = baseDate;
      endDate = DateTime(baseDate.year, baseDate.month, baseDate.day + 1);
    } else if (type == 2) {
      startDate = DateTime(baseDate.year, baseDate.month, baseDate.day - 6);
      endDate = DateTime(baseDate.year, baseDate.month, baseDate.day + 1);
    } else if (type == 3) {
      //only month
      startDate = DateTime(baseDate.year, baseDate.month, 1);
      endDate = DateTime(baseDate.year, baseDate.month, baseDate.day + 1);
    }
  }

  void switchDate(bool button) {
// true=next false=back
    if (type == 1) {
      if (button == true) {
        startDate = endDate;
        endDate = DateTime(startDate.year, startDate.month, startDate.day + 1);
      } else {
        endDate = startDate;
        startDate = DateTime(endDate.year, endDate.month, endDate.day - 1);
      }
    } else if (type == 2) {
      if (button == true) {
        startDate = endDate;
        endDate = DateTime(startDate.year, startDate.month, startDate.day + 7);
      } else {
        endDate = startDate;
        startDate = DateTime(endDate.year, endDate.month, endDate.day - 7);
      }
    } else if (type == 3) {
      if (button == true) {
        startDate = DateTime(endDate.year, endDate.month + 1, 1);
        endDate = DateTime(startDate.year, startDate.month + 1, 0);
      } else {
        startDate = DateTime(endDate.year, endDate.month - 1, 1);
        endDate = DateTime(startDate.year, startDate.month + 1, 0);
      }
    }
  }

  Future<String> _getToken(
      String username, String password, String tenant) async {
    _loginResponse =
        (await ApiService().getLoginResponse(username, password, tenant))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
    return _loginResponse!.token;
  }

  Future<void> _refresh() async {
    token = await _getToken(username, password, tenant);
    _getMeasurements(token);
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _getMeasurements(String token) async {
    _measurementsResponse = (await ApiService().getMeasurementsResponseFilter(
        token,
        number,
        DateFormat('yyyy-MM-dd').format(startDate),
        DateFormat('yyyy-MM-dd').format(endDate)))!;

    _lastMeasurementsResponse = (await ApiService()
        .getMeasurementsResponseFilter(
            token,
            1,
            DateFormat('yyyy-MM-dd').format(baseDate),
            DateFormat('yyyy-MM-dd').format(
                DateTime(baseDate.year, baseDate.month, baseDate.day + 1))))!;
    if (_measurementsResponse!.totalDocs == 0) {
      features[0].data = [];
      features[1].data = [];
    } else {
      _getSoilMoisture();
      _getLuminosity();
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  void _getSoilMoisture() {
    double value = 0;
    _soilMoisture = [];
    labelX = [];

    for (int i = _measurementsResponse!.totalDocs - 1; i >= 0; i--) {
      value = (_measurementsResponse!.docs[i].samples[0].values[1]).toDouble();
      value = getPercentageMoisture(value);
      _soilMoisture?.add(value);
      value = 0;
    }
    for (int y = 0; y < _soilMoisture!.length + 1; y++) {
      labelX.add("");
    }
    features[0].data = _soilMoisture!;
    last_moisture = getPercentageMoisture(
        _lastMeasurementsResponse!.docs[0].samples[0].values[1].toDouble());
  }

  double getPercentageMoisture(double value) {
    if (value >= 700) {
      value = 0;
    } else if (value <= 310) {
      value = 1; // 100
    } else if (value > 310 && value < 700) {
      value = ((700 - value) * 100 / 390);
      value = (roundDouble(value, 0)) / 100; // 0.6
    }

    return value;
  }

  void _getLuminosity() {
    double value = 0;
    _lumonisity = [];
    for (int i = _measurementsResponse!.totalDocs - 1; i >= 0; i--) {
      value = (_measurementsResponse!.docs[i].samples[0].values[0]).toDouble();
      value = getPercentageLuminosity(value);
      _lumonisity?.add(value);
      value = 0;
    }
    features[1].data = _lumonisity!;
    last_sun = getPercentageLuminosity(
        _lastMeasurementsResponse!.docs[0].samples[0].values[0].toDouble());
  }

  double getPercentageLuminosity(double value) {
    if (value >= 0 && value <= 10) {
      value = minMaxPercentage(value, 0, 10);
      value = roundDouble(value, 2);
    } else if (value >= 11 && value <= 50) {
      value = minMaxPercentage(value, 11, 50) + 0.1;
      value = roundDouble(value, 2);
    } else if (value >= 51 && value <= 200) {
      value = minMaxPercentage(value, 51, 200) + 0.2;
      value = roundDouble(value, 2);
    } else if (value >= 201 && value <= 400) {
      value = minMaxPercentage(value, 201, 400) + 0.3;
      value = roundDouble(value, 2);
    } else if (value >= 401 && value <= 1000) {
      value = minMaxPercentage(value, 401, 1000) + 0.4;
      value = roundDouble(value, 2);
    } else if (value >= 1001 && value <= 5000) {
      value = minMaxPercentage(value, 1001, 5000) + 0.5;
      value = roundDouble(value, 2);
    } else if (value >= 5001 && value <= 10000) {
      value = minMaxPercentage(value, 5001, 10000) + 0.6;
      value = roundDouble(value, 2);
    } else if (value >= 10001 && value <= 30000) {
      value = minMaxPercentage(value, 10001, 30000) + 0.7;
      value = roundDouble(value, 2);
    } else if (value >= 30001 && value <= 40000) {
      value = minMaxPercentage(value, 30001, 40000) + 0.8;
      value = roundDouble(value, 2);
    } else if (value >= 40001 && value <= 100000) {
      value = minMaxPercentage(value, 40001, 100000) + 0.9;
      value = roundDouble(value, 2);
    }

    return value;
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  double minMaxPercentage(value, min, max) {
    return (100 * (value - min) / (max - min)) / 1000;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color.fromARGB(255, 136, 219, 136),
              Color.fromARGB(255, 136, 219, 136)
            ])),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Home",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                letterSpacing: 7,
              ),
            ),
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: _measurementsResponse == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(),
                        // Padding(
                        //   padding: const EdgeInsets.all(5),
                        // ),
                        Card(
                          color: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.grey.shade200,
                          margin: EdgeInsets.all(10),
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(color: Colors.white)),
                          child: Column(children: [
                            Row(
                              children: [
                                Column(children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 80)),
                                  Text(
                                    "Last",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Text(
                                    " Measure:",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 80)),
                                  Row(children: [
                                    Column(children: [
                                      Card(
                                          color: Colors.grey.shade700,
                                          elevation: 1.5,
                                          shadowColor: Colors.grey.shade800,
                                          margin: EdgeInsets.only(
                                              left: 0,
                                              top: 5,
                                              right: 10,
                                              bottom: 5),
                                          shape: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade600)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            child: Image.asset(
                                              'assets/images/sun.png',
                                              width: 20,
                                              height: 20,
                                              alignment: Alignment.center,
                                            ),
                                          )),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 1, horizontal: 10)),
                                      Card(
                                          color: Colors.grey.shade700,
                                          elevation: 1.5,
                                          shadowColor: Colors.grey.shade800,
                                          margin: EdgeInsets.only(
                                              left: 0,
                                              top: 5,
                                              right: 10,
                                              bottom: 5),
                                          shape: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(
                                                  color: Colors.grey.shade600)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            child: Image.asset(
                                              'assets/images/drop.png',
                                              width: 20,
                                              height: 20,
                                              alignment: Alignment.center,
                                            ),
                                          )),
                                    ]),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 25)),
                                        Text(
                                          (last_sun * 100).toInt().toString() +
                                              "%",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Sun",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                            )),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 25)),
                                        Text(
                                          (last_moisture * 100)
                                                  .toInt()
                                                  .toString() +
                                              "%",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("Water",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400)),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 25)),
                                      ],
                                    )
                                  ]),
                                  Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 80)),
                                ]),
                                Column(
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: Image.asset(
                                          'assets/images/IMG_0500.jpg',
                                          width: 230,
                                          height: 180,
                                          alignment: Alignment.centerRight,
                                          fit: BoxFit.cover,
                                        )),
                                  ],
                                )
                              ],
                            )
                          ]),
                        ),
                        Container(),
                        Padding(
                          padding: const EdgeInsets.all(5),
                        ),
                        Card(
                            color: Colors.white,
                            elevation: 5,
                            shadowColor: Colors.grey.shade200,
                            margin: EdgeInsets.all(10),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white)),
                            child: Column(
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 80)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedButtonBar(
                                      radius: 32.0,
                                      padding: const EdgeInsets.all(5),
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          Color.fromARGB(255, 233, 237, 233),
                                      elevation: 5,
                                      borderColor: Colors.grey.shade100,
                                      borderWidth: 2,
                                      innerVerticalPadding: 15,
                                      children: [
                                        ButtonBarEntry(
                                            onTap: () {
                                              number = 80;
                                              type = 1;
                                              setTypeDate();
                                              _refresh();
                                            },
                                            child: Text('Day')),
                                        ButtonBarEntry(
                                            onTap: () {
                                              number = 550;
                                              type = 2;
                                              setTypeDate();
                                              _refresh();
                                            },
                                            child: Text('Week')),
                                        ButtonBarEntry(
                                            onTap: () {
                                              number = 2300;
                                              type = 3;
                                              setTypeDate();
                                              _refresh();
                                            },
                                            child: Text('Month')),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              switchDate(false);
                                              _refresh();
                                            },
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.grey,
                                              size: 24.0,
                                            )),
                                        Text(DateFormat('dd/MM/yy')
                                                .format(startDate) +
                                            " - " +
                                            DateFormat('dd/MM/yy')
                                                .format(endDate)),
                                        IconButton(
                                            onPressed: () {
                                              switchDate(true);
                                              _refresh();
                                            },
                                            icon: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey,
                                              size: 24.0,
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 80)),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: LineGraph(
                                      features: features,
                                      size: Size(450, 450),
                                      labelX: labelX,
                                      labelY: [
                                        '10%',
                                        '20%',
                                        '30%',
                                        '40%',
                                        '50%',
                                        '60%',
                                        '70%',
                                        '80%',
                                        '90%',
                                        '100%'
                                      ],
                                      showDescription: true,
                                      graphColor: Colors.black,
                                      graphOpacity: 0.3,
                                      verticalFeatureDirection: false,
                                      descriptionHeight: 100,
                                    )),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                              ],
                            )),
                        Card(
                            color: Colors.white,
                            elevation: 5,
                            shadowColor: Colors.grey.shade200,
                            margin: EdgeInsets.all(10),
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Colors.white)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 80)),
                                Text(
                                  "Discover More About:",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            child: Image.asset(
                                              'assets/images/sun3.png',
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey.shade100,
                                                fixedSize: const Size(40, 50),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1500))),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LuminosityInfo()),
                                              );
                                            },
                                          ),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5)),
                                          Text(
                                            'Luminosity',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 60),
                                        height: 100,
                                        width: 2,
                                      ),
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            child: Image.asset(
                                              'assets/images/plant3.png',
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey.shade100,
                                                fixedSize: const Size(40, 50),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1500))),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MoistureInfo()),
                                              );
                                            },
                                          ),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5)),
                                          Text(
                                            'Plant Healt',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5)),
                              ],
                            )),
                      ],
                    );
                  },
                ),
        ));
  }
}
