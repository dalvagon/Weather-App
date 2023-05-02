import 'dart:convert';

class AlarmModel {
  final int id;
  DateTime time;
  bool isOn;
  String label;

  AlarmModel(
      {required this.id,
      required this.time,
      required this.isOn,
      this.label = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time.toIso8601String(),
      'isOn': isOn,
      'label': label,
    };
  }

  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
        id: map['id'],
        time: DateTime.parse(map['time']),
        isOn: map['isOn'],
        label: map['label']);
  }

  factory AlarmModel.fromJson(String source) =>
      AlarmModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Alarm{id: $id, time: $time, isOn: $isOn, label: $label}';
  }
}
