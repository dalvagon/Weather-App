import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/weather.dart';

import '../models/alarm_model.dart';
import '../services/geolocation.dart';

class AlarmManager {
  static const String _alarmsKey = 'weather_alarms';
  static const String _alarmIdKey = 'weather_alarm_id';
  static const String _weatherApiKey = "261802d1243adfe070f111bd55731039";

  static Future<List> getAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List alarms = prefs.getStringList(_alarmsKey) ?? [];

    alarms.sort((a, b) {
      final aAlarm = AlarmModel.fromJson(a);
      final bAlarm = AlarmModel.fromJson(b);

      return aAlarm.time.compareTo(bAlarm.time);
    });

    return alarms.map((e) => AlarmModel.fromJson(e)).toList();
  }

  static Future<void> createAlarm(TimeOfDay time) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List alarms = prefs.getStringList(_alarmsKey) ?? [];
    final int alarmId = prefs.getInt(_alarmIdKey) ?? 0;

    AlarmModel alarm = AlarmModel(
      id: alarmId,
      time: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        time.hour,
        time.minute,
      ),
      label: 'Later today',
      isOn: true,
    );
    _updateAlarm(alarm);

    await _setAlarm(alarm);
    alarms.add(alarm.toJson());
    prefs.setStringList(_alarmsKey, alarms.map((e) => e.toString()).toList());
    prefs.setInt(_alarmIdKey, alarmId + 1);
  }

  static Future<void> switchOnOrOff(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List alarms = prefs.getStringList(_alarmsKey) ?? [];

    for (var alarm in alarms) {
      if (AlarmModel.fromJson(alarm).id == id) {
        final AlarmModel newAlarm = AlarmModel.fromJson(alarm);
        newAlarm.isOn = !newAlarm.isOn;
        if (newAlarm.isOn) {
          _updateAlarm(newAlarm);
          await _setAlarm(newAlarm);
        } else {
          await _cancelAlarm(newAlarm.id);
        }
        alarms[alarms.indexOf(alarm)] = newAlarm.toJson();
        break;
      }
    }

    prefs.setStringList(_alarmsKey, alarms.map((e) => e.toString()).toList());
  }

  static Future<void> removeAlarm(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List alarms = prefs.getStringList(_alarmsKey) ?? [];

    alarms.removeWhere((alarm) => AlarmModel.fromJson(alarm).id == id);
    await _cancelAlarm(id);
    prefs.setStringList(_alarmsKey, alarms.map((e) => e.toString()).toList());
  }

  static Future<void> _cancelAlarm(int id) async {
    await AndroidAlarmManager.cancel(id);
  }

  static Future<void> _setAlarm(AlarmModel alarm) async {
    await AndroidAlarmManager.oneShotAt(
      alarm.time,
      alarm.id,
      _alarmCallback,
      exact: true,
      wakeup: true,
      alarmClock: true,
    );
  }

  static Future<void> _alarmCallback(int id) async {
    Position position = await GeolocationService().getLocation();

    WeatherFactory wf = WeatherFactory(_weatherApiKey);
    Weather w = await wf.currentWeatherByLocation(
        position.latitude, position.longitude);

    print("Alarm $id fired! ${position.latitude}, ${position.longitude}");
    print(w);
    _speak(w);
  }

  static Future<void> _speak(Weather w) async {
    FlutterTts tts = FlutterTts();
    await tts.setLanguage("en-US");

    final text =
        """The weather conditions in ${w.areaName} at ${DateFormat('hh:mm a').format(w.date!)} is ${w.weatherDescription} with a temperature of ${w.temperature?.celsius?.round()} degrees Celsius.
        The wind speed is ${w.windSpeed?.round()} kilometers per hour and the humidity is ${w.humidity?.round()} percent.
        The maximum temperature for today is ${w.tempMax?.celsius?.round()} degrees Celsius and the minimum temperature is ${w.tempMin?.celsius?.round()} degrees Celsius.

        """;

    print(text);
    await tts.speak(text);
  }

  static void _updateAlarm(AlarmModel alarm) {
    DateTime now = DateTime.now();
    DateTime alarmTime = alarm.time;
    bool isTomorrow = alarmTime.isBefore(now) || alarmTime.day > now.day;
    if (isTomorrow) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }
    alarm.time = alarmTime;
    alarm.label = isTomorrow ? 'Tomorrow' : 'Later today';
  }
}
