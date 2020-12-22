import 'DaysList.dart';

class Courses {
  int _courseId;
  String _courseCode;
  String _name;
  int _faculty;
  String _facultyName;
  String _taName;
  List<DaysList> _daysList;

  Courses(
      {int courseId,
        String courseCode,
        String name,
        int faculty,
        String facultyName,
        String taName,
        List<DaysList> daysList}) {
    this._courseId = courseId;
    this._courseCode = courseCode;
    this._name = name;
    this._faculty = faculty;
    this._facultyName = facultyName;
    this._taName = taName;
    this._daysList = daysList;
  }

  int get courseId => _courseId;
  set courseId(int courseId) => _courseId = courseId;
  String get courseCode => _courseCode;
  set courseCode(String courseCode) => _courseCode = courseCode;
  String get name => _name;
  set name(String name) => _name = name;
  int get faculty => _faculty;
  set faculty(int faculty) => _faculty = faculty;
  String get facultyName => _facultyName;
  set facultyName(String facultyName) => _facultyName = facultyName;
  String get taName => _taName;
  set taName(String taName) => _taName = taName;
  List<DaysList> get daysList => _daysList;
  set daysList(List<DaysList> daysList) => _daysList = daysList;

  Courses.fromJson(Map<String, dynamic> json) {
    _courseId = json['course_id'];
    _courseCode = json['course_code'];
    _name = json['name'];
    _faculty = json['faculty'];
    _facultyName = json['faculty_name'];
    _taName = json['ta_name'];
    if (json['daysList'] != null) {
      _daysList = new List<DaysList>();
      json['daysList'].forEach((v) {
        _daysList.add(new DaysList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_id'] = this._courseId;
    data['course_code'] = this._courseCode;
    data['name'] = this._name;
    data['faculty'] = this._faculty;
    data['faculty_name'] = this._facultyName;
    data['ta_name'] = this._taName;
    if (this._daysList != null) {
      data['daysList'] = this._daysList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}