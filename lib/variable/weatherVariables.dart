class Weatherdata {
  String location;
  String tempraturecelsius;
  String windspeed;
  String precipitation;
  String feelslike;
  String weathercondition;
  String weatherImage;
  String date;
  String region;
  String Uv;
  String clouds;
  String visibility;
  String windDirection;
  String humidity;
  List<String> formaxtemp;
  List<String> formintemp;
  List<String> fordate;
  List<String> forday;

  Weatherdata({
    this.forday = const [],
    this.fordate = const [],
    this.formaxtemp = const [],
    this.formintemp = const [],
    this.location = "",
    this.feelslike = "",
    this.precipitation = "",
    this.tempraturecelsius = "",
    this.weathercondition = "",
    this.weatherImage = "",
    this.windspeed = "",
    this.date = "",
    this.region = "",
    this.Uv = "",
    this.clouds = "",
    this.visibility = "",
    this.windDirection = "",
    this.humidity = "",
  });
}

