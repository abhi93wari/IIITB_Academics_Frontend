import 'package:flutter/material.dart';
import 'package:iiitb_academics/services/router.dart' as router;
import 'package:iiitb_academics/services/router_constants.dart';
import 'package:iiitb_academics/views/undefined/UndefinedView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: 'IIITB Academics',
        debugShowCheckedModeBanner: false,

        onGenerateRoute: router.generateRoute,
        initialRoute: LoginViewRoute,
        onUnknownRoute: (settings) =>
            MaterialPageRoute(
                builder: (context) =>
                    UndefinedView(
                      name: settings.name,
                    )),

      );
    }
  }

