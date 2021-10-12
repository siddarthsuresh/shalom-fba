import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance {
  String _uid;
  String _name;
  DateTime _date;

  Attendance(this._uid, this._name, this._date);


  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  Attendance.fromMap(DocumentSnapshot snapshot, String id, String date)
      : _uid = id,
        _name = snapshot['name'],
        _date = DateTime(
            int.parse(date.substring(0, 4)),
            int.parse(date.substring(5, 7)),
            int.parse(date.substring(8, 10)));

  toJson() {
    return {
      "name": _name,
      "uid": _uid,
      "date": "${_date.toLocal()}".split(' ')[0]
    };
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }
}
