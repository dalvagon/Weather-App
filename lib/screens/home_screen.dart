import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/alarm_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List alarms = [];
  List ringtones = [];

  @override
  void initState() {
    super.initState();
    _getAlarms();
  }

  Future<void> _getAlarms() async {
    final List alarms = await AlarmManager.getAlarms();
    setState(() {
      this.alarms = alarms;
    });
  }

  Future<TimeOfDay?> _selectTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    return timeOfDay;
  }

  Future<void> _createAlarm() async {
    final TimeOfDay? timeOfDay = await _selectTime();

    if (timeOfDay != null) {
      await AlarmManager.createAlarm(timeOfDay);
      await _getAlarms();
    }
  }

  Future<void> _switchOnOrOff(int id) async {
    await AlarmManager.switchOnOrOff(id);
    await _getAlarms();
  }

  Future<void> _removeAllarm(int id) async {
    await AlarmManager.removeAlarm(id);
    await _getAlarms();
  }

  Future<void> _setSpeakWeather(int id, bool value) async {
    await AlarmManager.setSpeakWeather(id, value);
    await _getAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MY ALARMS')),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 32, right: 32, top: 16, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Text(
                              DateFormat('HH:mm').format(alarms[index].time),
                              style: const TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold)),
                        ),
                        Switch(
                            value: alarms[index].isOn,
                            onChanged: (bool value) async {
                              _switchOnOrOff(alarms[index].id);
                            })
                      ],
                    ),
                  ),
                  ExpansionTile(
                    tilePadding: const EdgeInsets.only(
                        left: 32, right: 32, top: 8, bottom: 8),
                    title: Text(alarms[index].label),
                    textColor: Theme.of(context).primaryColorLight,
                    iconColor: Theme.of(context).primaryColorLight,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            left: 32, right: 32, top: 8, bottom: 8),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ToggleButtons(
                                isSelected: [
                                  alarms[index].speakWeather,
                                  !alarms[index].speakWeather
                                ],
                                onPressed: (int toggleButtonIndex) async {
                                  _setSpeakWeather(
                                      alarms[index].id, toggleButtonIndex == 0);
                                },
                                children: const [
                                  Icon(Icons.sunny),
                                  Icon(Icons.volume_off),
                                ]),
                            TextButton.icon(
                                onPressed: () async {
                                  _removeAllarm(alarms[index].id);
                                },
                                label: const Text('DELETE'),
                                icon: const Icon(Icons.delete_outline_sharp),
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(0),
                                    foregroundColor:
                                        Theme.of(context).primaryColorLight)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createAlarm();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
