
class DaysList {
  String _time;
  String _day;
  String _room;

  DaysList({String time, String day, String room}) {
    this._time = time;
    this._day = day;
    this._room = room;
  }

  String get time => _time;
  set time(String time) => _time = time;
  String get day => _day;
  set day(String day) => _day = day;
  String get room => _room;
  set room(String room) => _room = room;

  DaysList.fromJson(Map<String, dynamic> json) {
    _time = json['time'];
    _day = json['day'];
    _room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this._time;
    data['day'] = this._day;
    data['room'] = this._room;
    return data;
  }
}
