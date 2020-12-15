import 'package:flutter/material.dart';
import 'package:iiitb_academics/services/router_constants.dart';
import 'package:iiitb_academics/views/login/LoginView.dart';
import 'package:iiitb_academics/views/timetable/timeTableView.dart';
import 'package:iiitb_academics/views/undefined/UndefinedView.dart';



Route<dynamic> generateRoute(RouteSettings settings) {
  // Here we'll handle all the routing
  switch (settings.name) {
    case LoginViewRoute:
      return MaterialPageRoute(builder: (context) =>LoginView());
    case TimeTableViewRoute:
      return MaterialPageRoute(builder: (context) =>TimeTableView());
    default:
      return MaterialPageRoute(builder: (context) => UndefinedView(name: settings.name,));
  }
}
