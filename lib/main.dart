import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/utils/theme.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();

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
