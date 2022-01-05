import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_using_bloc/WeatherRepo.dart';

import 'WeatherBloc.dart';
import 'WeatherModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // is not restarted.S
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: BlocProvider(
          create: (context) => WeatherBloc(WeatherRepo()),
          child: SearchPage(),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weatherBloc = BlocProvider.of<WeatherBloc>(context);

    var cityController = TextEditingController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherIntial)
              return Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      "Search Weather",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Instantly",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey[100],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white70,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.white70,
                                style: BorderStyle.solid)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(
                                color: Colors.blue, style: BorderStyle.solid)),
                        hintText: "City Name",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      // ignore: deprecated_member_use
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        onPressed: () {
                          weatherBloc.add(FetchWeather(cityController.text));
                        },
                        color: Colors.lightBlue,
                        child: Text(
                          "Search",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              );
            else if (state is WeatherIsLoading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if (state is WeatherIsLoaded)
              return ShowWeather(state.getWeather, cityController.text);
            else
              return Text(
                "Error",
                style: TextStyle(color: Colors.white),
              );
          },
        ),
      ],
    );
  }
}

class ShowWeather extends StatelessWidget {
  WeatherModel weather;
  final city;

  ShowWeather(this.weather, this.city);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 32, left: 32, top: 10),
        child: Column(
          children: <Widget>[
 	              city,
              style: TextStyle(
                  color: Colors.white70,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              weather.getT	emp.round().toString() + "C",
              style: TextStyle(color: Colors.white70, fontSize: 50),
            ),
            Text(
              "Temprature",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      weather.getMinTemp.round().toString() + "C",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Min Temprature",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      weather.getMaxTemp.round().toString() + "C",
                      style: TextStyle(color: Colors.white70, fontSize: 30),
                    ),
                    Text(
                      "Max Temprature",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              height: 50,
              // ignore: deprecated_member_use
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                onPressed: () {
                  BlocProvider.of<WeatherBloc>(context).add(ResetWeather());
                },
                color: Colors.lightBlue,
                child: Text(
                  "Search",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
            )
          ],
        ));
  }
}
