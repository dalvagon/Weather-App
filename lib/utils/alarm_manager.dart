import 'package:shared_preferences/shared_preferences.dart';

class AlarmManager {
  static Future<List> getAlarms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List alarms = prefs.getStringList('alarms') ?? [];

    return alarms;
  }

  static Future<void> setAlarm(DateTime alarm, int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List alarms = prefs.getStringList('alarms') ?? [];

    alarms.add(alarm.toString());
    prefs.setStringList('alarms', alarms.map((e) => e.toString()).toList());
  }

  static Future<void> removeAlarm(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List alarms = prefs.getStringList('alarms') ?? [];

    alarms.removeAt(id);
    prefs.setStringList('alarms', alarms.map((e) => e.toString()).toList());
  }
}
