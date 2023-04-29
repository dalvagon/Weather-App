import 'package:flutter/material.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/utils/theme.dart';

void main() {
  runApp(const WeatherAlarm());
}

class WeatherAlarm extends StatelessWidget {
  const WeatherAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather Alarm',
        initialRoute: '/',
        routes: routes,
        theme: theme);
  }
}
