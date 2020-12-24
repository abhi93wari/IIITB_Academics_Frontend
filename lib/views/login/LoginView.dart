import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iiitb_academics/models/TimeTableModel.dart';
import 'package:iiitb_academics/services/CommonData.dart';
import 'package:iiitb_academics/services/Networks.dart';
import 'package:iiitb_academics/services/router_constants.dart';
import 'package:iiitb_academics/views/timetable/timeTableView.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  TextStyle style = GoogleFonts.nunito(
    //textStyle: Theme.of(context).textTheme.display1,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    //fontStyle: FontStyle.italic,
  );

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  void showSnackBar(String msg) {
    final snackbar = new SnackBar(
      content: new Text(msg,
        style: GoogleFonts.nunito(
          //textStyle: Theme.of(context).textTheme.display1,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          //fontStyle: FontStyle.italic,
        ),
      ),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }



  final formKeyemail = new GlobalKey<FormState>();
  static String email;
  final TextEditingController t2 = new TextEditingController(text: "");
  // String emailText = "";

  void login() async{
    final emailkey = formKeyemail.currentState;
    if(!emailkey.validate()){
      return;
    }
    else{
      emailkey.save();
    }

    setState(() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent[200]),

                    ),
                    SizedBox(width: 30),
                    new Text("Please wait",
                      style: style,
                    ),
                  ],
                ),
              ),
            );

            //CommonData.isLoading=true;
          });
    });
    try {
      String apiurl ="http://localhost:8080/api/Students/";
      print("email is "+email);
      http.Response response = await http.get(apiurl+email);
      if(response.statusCode==200) {
        print(response.body);
        print("found data");
        var data = response.body;
        print(data);
        var myjson = jsonDecode(data);
        print(myjson);

        //var timeTable = TimeTableModel.fromJson({"student_id":1,"first_name":"SANDEEP","last_name":"KUMAR JHA","roll_no":"MT2020087","email":"sandeep.jha@iiitb.org","courses":[{"course_id":1,"course_code":"AI511","name":"Machine Learning","faculty":0,"faculty_name":"G Srinivasana","ta_name":"Tejas Kotha","daysList":[{"time":"16:00-18:00","day":"MON","room":"R302"},{"time":"11:00-13:00","day":"TUE","room":"R302"},{"time":"11:00-13:00","day":"FRI","room":"R302"}]},{"course_id":2,"course_code":"AI512","name":"MML","faculty":0,"faculty_name":"V Ram","ta_name":null,"daysList":[{"time":"11:00-13:00","day":"MON","room":"R302"},{"time":"11:00-13:00","day":"THU","room":"R305"}]},{"course_id":3,"course_code":"CS511","name":"ALGO","faculty":0,"faculty_name":"V Murli","ta_name":null,"daysList":[{"time":"09:00-11:00","day":"WED","room":"R302"},{"time":"09:00-11:00","day":"SAT","room":"R308"}]},{"course_id":4,"course_code":"CS512","name":"SS","faculty":0,"faculty_name":"R ChandraShekhar","ta_name":"Shubham Aggarwal","daysList":[{"time":"16:00-18:00","day":"WED","room":"R302"},{"time":"14:00-16:00","day":"FRI","room":"R307"}]}]});
        var timeTable = TimeTableModel.fromJson(myjson);
        CommonData.currentModel = timeTable;
      }
      else{
        print("error");
        Navigator.of(context).pop();
        showSnackBar("Invalid user");

      }
    } on Exception catch (e) {
      // TODO

      print("Exception "+e.toString());
      Navigator.of(context).pop();
      showSnackBar("Something went wrong");


      // var timeTable = TimeTableModel.fromJson({"student_id":1,"first_name":"SANDEEP","last_name":"KUMAR JHA","roll_no":"MT2020087","email":"sandeep.jha@iiitb.org","courses":[{"course_id":1,"course_code":"AI511","name":"Machine Learning","faculty":0,"faculty_name":"G Srinivasana","ta_name":"Tejas Kotha","daysList":[{"time":"16:00-18:00","day":"MON","room":"R302"},{"time":"11:00-13:00","day":"TUE","room":"R302"},{"time":"11:00-13:00","day":"FRI","room":"R302"}]},{"course_id":2,"course_code":"AI512","name":"MML","faculty":0,"faculty_name":"V Ram","ta_name":null,"daysList":[{"time":"11:00-13:00","day":"MON","room":"R302"},{"time":"11:00-13:00","day":"THU","room":"R305"}]},{"course_id":3,"course_code":"CS511","name":"ALGO","faculty":0,"faculty_name":"V Murli","ta_name":null,"daysList":[{"time":"09:00-11:00","day":"WED","room":"R302"},{"time":"09:00-11:00","day":"SAT","room":"R308"}]},{"course_id":4,"course_code":"CS512","name":"SS","faculty":0,"faculty_name":"R ChandraShekhar","ta_name":"Shubham Aggarwal","daysList":[{"time":"16:00-18:00","day":"WED","room":"R302"},{"time":"14:00-16:00","day":"FRI","room":"R307"}]}]});
      // CommonData.currentModel = timeTable;
    }


    Future.delayed(Duration(seconds: 0),()  async {
      //bool val = await Networks.loginandgetUserData(email);
      if(true){
        // setState(() {
        //   Navigator.pop(context); //for dialog
        //   Navigator.pop(context); //for login page
        //   Navigator.pushNamed(context, TimeTableViewRoute);
        // });
      }
      else{
        setState(() {

        });
      }


    });



  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
        Image.asset(
        "images/iiitb_main.jpg",
        fit: BoxFit.fill,
        width: width,
        height: height,
      ),
          Container(
            alignment: Alignment.center,
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 20,
              shadowColor: Colors.blueAccent,
              margin: EdgeInsets.symmetric(vertical: 37.0,horizontal: 26.0),
              child: Container(
                height: 500,
                width: 400,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[800],
                      Colors.blue[400],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 8, 28, 28),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,


                    children: [
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 24.0, horizontal: 24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image(
                                  width: 100,
                                  height:100,
                                  image: AssetImage('images/iiitb_logo_white.png'),
                                  //fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                "IIITB Academia",
                                style: GoogleFonts.nunito(
                                  //textStyle: Theme.of(context).textTheme.headline5,
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w600,
                                ),

                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "Login",
                                style: GoogleFonts.nunito(
                                  //textStyle: Theme.of(context).textTheme.headline5,
                                  color: Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Form(
                                  key: formKeyemail,
                                  //autovalidate: true,
                                  child: TextFormField(
                                    // focusNode: emailFocus,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    style: GoogleFonts.nunito(
                                      //textStyle: Theme.of(context).textTheme.display1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300,
                                      //fontStyle: FontStyle.italic,
                                    ),
                                    controller: t2,
                                    // onFieldSubmitted: (val){
                                    //   emailFocus.unfocus();
                                    // },
                                    onEditingComplete: (){
                                      //emailFocus.unfocus();
                                    },
                                    /* onChanged: (String value){
                        //save to backend
                        print("new value is $value");
                        Networks.saveField("email", value);


                      },*/
                                    decoration: InputDecoration(
                                       // suffixText: emailText,
                                        contentPadding:
                                        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//            hintText: "Email",
                                        labelText: "Email",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0))),
                                    validator: (val) {
                                      if(!val.contains('@')) {
                                        return 'Invalid Email';
                                      } else{
                                        return null;
                                      }

                                    },
                                    onSaved: (val) => email = val,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),

                                Container(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    onPressed: login,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    color: Colors.blue[600],
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(vertical: 15.0),
                                      child: Text(
                                        "Login",
                                        style: GoogleFonts.nunito(
                                          //textStyle: Theme.of(context).textTheme.headline5,
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ),
        ],
      )
    );
  }
}
