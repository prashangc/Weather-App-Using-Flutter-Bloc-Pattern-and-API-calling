import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app_using_bloc/WeatherModel.dart';

class WeatherRepo {
  Future<WeatherModel> getWeather(String city) async {
    final result = await http.Client().get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=5184e07c59f9fcb5aa01cb500d8c5746"));
    if (result.statusCode != 200) throw Exception();

    return parsedJson(result.body);
  }

  WeatherModel parsedJson(final response) {
    final jsonDecoded = json.decode(response);

    final jsonWeather = jsonDecoded["main"];

    return WeatherModel.fromJson(jsonWeather);
  }
}
