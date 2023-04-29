import 'package:flutter/material.dart';

import '../utils/alarm_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List alarms = [];

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

  Future<void> _selectTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeOfDay != null) {
      final DateTime now = DateTime.now();
      DateTime alarm = DateTime(
        now.year,
        now.month,
        now.day,
        timeOfDay.hour,
        timeOfDay.minute,
      );

      if (alarm.isBefore(now)) {
        alarm = DateTime(
            now.year, now.month, now.day + 1, timeOfDay.hour, timeOfDay.minute);
      }

      await AlarmManager.setAlarm(alarm, alarms.length);

      await _getAlarms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Alarms')),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: alarms.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              child: ExpansionTile(
                tilePadding: const EdgeInsets.only(
                    left: 32, right: 32, top: 8, bottom: 8),
                title: Text(
                    '${DateTime.parse(alarms[index]).hour}:${DateTime.parse(alarms[index]).minute}',
                    style: Theme.of(context).textTheme.headlineMedium),
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                        left: 32, right: 32, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            await AlarmManager.removeAlarm(index);
                            await _getAlarms();
                          },
                          label: const Text('Delete'),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
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
          _selectTime();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
