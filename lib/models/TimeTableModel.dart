import 'Courses.dart';

class TimeTableModel {
  int _studentId;
  String _firstName;
  String _lastName;
  String _rollNo;
  String _email;
  List<Courses> _courses;

  TimeTableModel(
      {int studentId,
        String firstName,
        String lastName,
        String rollNo,
        String email,
        List<Courses> courses}) {
    this._studentId = studentId;
    this._firstName = firstName;
    this._lastName = lastName;
    this._rollNo = rollNo;
    this._email = email;
    this._courses = courses;
  }

  int get studentId => _studentId;
  set studentId(int studentId) => _studentId = studentId;
  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get rollNo => _rollNo;
  set rollNo(String rollNo) => _rollNo = rollNo;
  String get email => _email;
  set email(String email) => _email = email;
  List<Courses> get courses => _courses;
  set courses(List<Courses> courses) => _courses = courses;

  TimeTableModel.fromJson(Map<String, dynamic> json) {
    _studentId = json['student_id'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _rollNo = json['roll_no'];
    _email = json['email'];
    if (json['courses'] != null) {
      _courses = new List<Courses>();
      json['courses'].forEach((v) {
        _courses.add(new Courses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_id'] = this._studentId;
    data['first_name'] = this._firstName;
    data['last_name'] = this._lastName;
    data['roll_no'] = this._rollNo;
    data['email'] = this._email;
    if (this._courses != null) {
      data['courses'] = this._courses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
