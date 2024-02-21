import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../helper/apikey.dart';
import '../provider/provider.dart';
import '../variable/weatherVariables.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchconntroller = TextEditingController();
  Weatherdata weatherdata = Weatherdata();
  List<Weatherdata> forecast = [];
  late Stream<ConnectivityResult> streamconnectivity;

  @override
  void initState() {
    super.initState();
    fetchdata("Ahmedabad");
    Connectivity connectivity = Connectivity();
    streamconnectivity = connectivity.onConnectivityChanged;
  }

  Future<void> fetchdata(String cityname) async {
    Weatherdata data = await ApiHelper.apiHelper.fetchData(cityname);
    weatherdata = data;
    setState(() {});
  }

  String currentDay() {
    DateTime now = DateTime.now();
    const List<String> days = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[now.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<providers>(context);
    var isDarkMode = provider.themeDetails.isdark;
    return Scaffold(
      body: StreamBuilder(
        stream: streamconnectivity,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == ConnectivityResult.mobile) {
              return onlineContent(isDarkMode);
            } else if (snapshot.data == ConnectivityResult.wifi) {
              return onlineContent(isDarkMode);
            } else {
              return offlineContent();
            }
          } else {
            return Text("${snapshot.error}");
          }
        },
      ),
    );
  }

  Widget onlineContent(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.only(
        top: 40,
        left: 10,
        right: 20,
      ),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("https://i.stack.imgur.com/NO8hx.png"),
              fit: BoxFit.fill,
              opacity: 0.4)),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 0,
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_sharp,
                    color: Colors.white,
                  ),
                  Text(
                    weatherdata.location,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(",${weatherdata.region}",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Provider.of<providers>(context, listen: false)
                          .themeToggle();
                    },
                    icon: Provider.of<providers>(context).themeDetails.isdark
                        ? const Icon(
                            CupertinoIcons.moon,
                            color: Colors.white,
                          )
                        : const Icon(
                            CupertinoIcons.sun_max_fill,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 0,
                  child: SizedBox(
                    height: 50,
                    width: 350,
                    child: TextField(
                      cursorColor: Colors.white70,
                      controller: _searchconntroller,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        fetchdata(value);
                      },
                      decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(fontSize: 18, color: Colors.white),
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              width: 180,
              child: Image.network("http:${weatherdata.weatherImage}",
                  fit: BoxFit.fill),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: weatherdata.tempraturecelsius,
                    style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const TextSpan(
                    text: "°",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              weatherdata.weathercondition,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: 350,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDarkMode ? Colors.black45 : Colors.white54,
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  const Icon(
                    Icons.water_drop_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "${weatherdata.precipitation}mm",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.thermostat_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    "${weatherdata.feelslike}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    CupertinoIcons.wind,
                    color: Colors.white,
                  ),
                  Text(
                    "${weatherdata.windspeed}km/h",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                height: 270,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDarkMode ? Colors.black45 : Colors.white54,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentDay(),
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 21),
                        ),
                        const Spacer(),
                        Text(
                          "${weatherdata.date}",
                          style: TextStyle(
                            fontSize: 22,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "UV                                            ${weatherdata.Uv}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Clouds                                     ${weatherdata.clouds}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Visibilty                                   ${weatherdata.visibility} km",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Wind Force                             ${weatherdata.visibility}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text(
                                "Humidity                                 ${weatherdata.humidity}%",
                                style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 0,
              child: Container(
                  alignment: Alignment.center,
                  width: 350,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black45 : Colors.white54,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    "3 Days Forecast",
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 22),
                  )),
            ),
            Container(
              height: 220,
              width: 350,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black45 : Colors.white54,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) => Card(
                  color: isDarkMode ? Colors.white54 : Colors.black45,
                  child: ListTile(
                    title: Text("${weatherdata.fordate[index]}",
                        style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      "Maxminum Average Temprature : ${weatherdata.formaxtemp[index]}°C \nMaxminum Average Temprature : ${weatherdata.formintemp[index]}°C",
                      style: TextStyle(
                          color: isDarkMode ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                itemCount: weatherdata.formaxtemp.length,
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10, bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              height: 100,
              width: 400,
              child: Center(
                  child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: ('🌅 6:00'),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  TextSpan(
                      text: " Sunrise\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                  TextSpan(
                      text: "\n${('🌇 6:55')}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)),
                  TextSpan(
                      text: " Sunset",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white)),
                ]),
              )),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget offlineContent() {
    return const Scaffold(
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          "Check Your Internet Connection",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
