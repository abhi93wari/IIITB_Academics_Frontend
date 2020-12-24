
import 'dart:collection';
import 'dart:html';
import 'dart:math';
///Dart imports
import 'dart:async';
import 'dart:convert';
//ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:ui';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;




import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iiitb_academics/models/Courses.dart';
import 'package:iiitb_academics/models/DaysList.dart';
import 'package:iiitb_academics/models/Meeting.dart';
import 'package:iiitb_academics/models/MeetingDataSource.dart';
import 'package:iiitb_academics/services/CommonData.dart';
import 'package:iiitb_academics/services/router_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class TimeTableView extends StatefulWidget {
  @override
  _TimeTableViewState createState() => _TimeTableViewState();
}

class _TimeTableViewState extends State<TimeTableView> {


  List<Appointment> _appointments;
  List<Color> colorCollection;
  CalendarController calendarController;
  var scr= new GlobalKey();

  final List<CalendarView> _allowedViews = <CalendarView>[
    // CalendarView.day,
    // CalendarView.week,
    // CalendarView.workWeek,
    // CalendarView.month,
    // //CalendarView.schedule
  ];

  ScrollController controller;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  GlobalKey _globalKey;
  CalendarView _view;

  @override
  void initState() {
    _globalKey = GlobalKey();
    controller = ScrollController();
    calendarController = CalendarController();
    calendarController.view = CalendarView.week;
    _view = CalendarView.week;
    _appointments = <Appointment>[];
    _addColorCollection();
    _createRecursiveAppointments();
    super.initState();
  }


  Widget scheduleViewBuilder(
      BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
    final String monthName = _getMonthDate(details.date.month);
    return SizedBox(height:0,width:0);
  }



  @override
  Widget build(BuildContext context) {
    final Widget _calendar = Theme(
      /// The key set here to maintain the state, when we change
      /// the parent of the widget
        key: _globalKey,
        data: Theme.of(context).copyWith(accentColor: Color(0xFF3D4FB5)),
        child: _getRecurrenceCalendar(
            calendarController,
            _AppointmentDataSource(_appointments),
            _onViewChanged,
            scheduleViewBuilder,_onCalendarTapped));

    final double _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title:   ListTile(
          title: Text(
            "Time-Table", textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ),
          ),
          trailing: InkWell(
            onTap: logout,
            child: Text(
              "Logout", textAlign: TextAlign.right,
              style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black
              ),
            ),
          ),
        ),

        backgroundColor: Color(0xfff6fbff),
        elevation: 2,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
      Expanded(
        flex: 1,
        child: Card(
            elevation: 2,
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
    ),
    color: Colors.blueAccent,
    //margin: EdgeInsets.symmetric(vertical: 37.0,horizontal: 26.0),
    child: Padding(
    padding: const EdgeInsets.all(18.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children :[ Text(
    "Name- ${CommonData.currentModel.firstName} ${CommonData.currentModel.lastName}\nRoll No- ${CommonData.currentModel.rollNo}\nEmail - ${CommonData.currentModel.email}\nDomain-${CommonData.currentModel.domain}\nSpec.-${CommonData.currentModel.specCode}-${CommonData.currentModel.specName} ",
    style: GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: Colors.white
    ),
    ),
      RaisedButton.icon(onPressed: generatePDF,
          hoverColor: Colors.lightGreenAccent,
          disabledColor: Colors.deepPurple,

          padding: const EdgeInsets.all(10.0),
          icon: Icon(
            Icons.download_rounded,
            color: Colors.blueAccent,
            size: 30,
          ),
          label: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Download Time Table",
              style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent
              ),
            ),
          )
      ),
     Text(
        getCourses(),
        style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w600,
              color: Colors.white
        ),
      ),
      ]
    ),
    ),

    ),
      ),
              ],
            ),
          ),

          Expanded(
            flex:8,
            child: Row(children: <Widget>[
              Expanded(
              child: calendarController.view == CalendarView.month &&
              true &&
              _screenHeight < 800
              ? Scrollbar(
              isAlwaysShown: true,
              controller: controller,
              child: ListView(
                controller: controller,
                children: <Widget>[
                  Container(
                    color: Colors.amber,
                    height: 600,
                    child: _calendar,
                  )
                ],
              ))
              : Container(color: Colors.amber, child: _calendar),
    )
    ]),
          ),
        ],
      )
    );
  }


  /// The method called whenever the calendar view navigated to previous/next
  /// view or switched to different calendar view.
  void _onViewChanged(ViewChangedDetails visibleDatesChangedDetails) {
    if (_view == calendarController.view ||
        !true ||
        (_view != CalendarView.month &&
            calendarController.view != CalendarView.month)) {
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _view = calendarController.view;

        /// Update the current view when the calendar view changed to
        /// month view or from month view.
      });
    });
  }

  // Future<dynamic> takescrshot() async {
  //   RenderRepaintBoundary boundary = scr.currentContext.findRenderObject();
  //   var image = await boundary.toImage();
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   var byteData = await image.toByteData(format: ImageByteFormat.png);
  //   var pngBytes = byteData.buffer.asUint8List();
  //   print(pngBytes);
  //   File imgFile =new File(pngBytes,'$directory/screenshot.png');
  //   return pngBytes;
  // }



  Future<List<int>> _readImageData() async {
    final ByteData data = await rootBundle.load('images/iiitb_logo.png');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> generatePDF() async {

    PdfDocument document = PdfDocument();

    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();

    // page.graphics.drawImage(PdfBitmap(await _readImageData()),
    //     Rect.fromLTWH(0, 0, pageSize.width, pageSize.height));


    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215, 255)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width, 90));
    //Draw string
    page.graphics.drawString(
        "Time Table", PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(pageSize.width/3, 0, pageSize.width, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));



//Create a PdfGrid class
    PdfGrid grid = PdfGrid();

//Add the columns to the grid
    grid.columns.add(count: 7);

//Add header to the grid
    grid.headers.add(1);

//Add the rows to the grid
    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Day/Time';
    header.cells[1].value = 'MON';
    header.cells[2].value = 'TUE';
    header.cells[3].value = 'WED';
    header.cells[4].value = 'THU';
    header.cells[5].value = 'FRI';
    header.cells[6].value = 'SAT';
//Add rows to grid
    List<Courses> courseList  = CommonData.currentModel.courses;

    PdfGridRow row0 = grid.rows.add();
    row0.cells[0].value = '9AM-11AM';

    PdfGridRow row1 = grid.rows.add();
    row1.cells[0].value = '11AM-1PM';


    PdfGridRow row2 = grid.rows.add();
    row2.cells[0].value = '1PM-3PM';

    PdfGridRow row3 = grid.rows.add();
    row3.cells[0].value = '3PM-5PM';



    HashMap map = new HashMap<String, int>();
    map["MON"]  = 1;
    map["TUE"]  = 2;
    map["WED"]  = 3;
    map["THU"]  = 4;
    map["FRI"]  = 5;
    map["SAT"]  = 6;






    for(Courses c in courseList){
      for(DaysList d in c.daysList) {

        String duration = d.time; //16:00-18:00
        String day = d.day;
        
        if(duration.startsWith('09')){
          int i = map[day];
          row0.cells[i].value = c.name;
        }
        if(duration.startsWith('11')){
          int i = map[day];
          row1.cells[i].value = c.name;
        }
        if(duration.startsWith('13')){
          int i = map[day];
          row2.cells[i].value = c.name;
        }
        if(duration.startsWith('15')){
          int i = map[day];
          row3.cells[i].value = c.name;
        }

      }
    }




//Set the grid style
    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 12));

//Draw the grid
    grid.draw(
        page: page, bounds:  Rect.fromLTWH(0, 90, 0,0));

//Save and dispose the PDF document
    final List<int> bytes = document.save();
    document.dispose();
    await saveAndLaunchFile(bytes, 'timetable.pdf');

  }

  Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    js.context['pdfdata'] = base64.encode(bytes);
    js.context['filename'] = fileName;
    Timer.run(() {
      js.context.callMethod('download');
    });
  }


  String getCourses(){
    String s = "Courses Enrolled in \n";
    for(Courses c in CommonData.currentModel.courses){
      s+="${c.courseCode} - ${c.name} \n";
    }
    return s;
  }

  WeekDays getDay(String day){
    switch (day){
      case "MON":
        return WeekDays.monday;
        break;
      case "TUE":
        return WeekDays.tuesday;
        break;
      case "WED":
        return WeekDays.wednesday;
        break;
      case "FRI":
        return WeekDays.friday;
        break;
      case "SAT":
        return WeekDays.saturday;
        break;
      case "THU":
        return WeekDays.thursday;
        break;
      default:
        return WeekDays.sunday;
    }

  }

  void _createRecursiveAppointments() {
    final Random random = Random();

    List<Courses> courseList  = CommonData.currentModel.courses;

    for(Courses c in courseList){
      for(DaysList d in c.daysList) {
        final Appointment weeklyAppointment = Appointment();
        String duration = d.time; //16:00-18:00
        List<String> times = duration.split("-");
        String start = times.first;//16:00
        String end = times.last;//18:00

        List<String> start1 = start.split(":");//16:00
        String starthour = start1.first;//16
        String startmin = start1.last;//00

        List<String> end1 = end.split(":");
        String endhour = end1.first;
        String endmin = end1.last;

        final DateTime currentDate = DateTime.now();
        final DateTime startTime =
        DateTime(currentDate.year, currentDate.month-1, currentDate.day, int.parse(starthour), int.parse(startmin), 0);
        final DateTime endTime = DateTime(
            currentDate.year, currentDate.month, currentDate.day, int.parse(endhour), int.parse(endmin), 0);

        weeklyAppointment.startTime = startTime;
        weeklyAppointment.endTime = startTime.add(Duration(hours: 2));

        weeklyAppointment.color = colorCollection[random.nextInt(9)];
        weeklyAppointment.subject = "Subject-${c.courseCode} - ${c.name}\nRoom - ${d.room}";
        weeklyAppointment.notes = "Teacher-${c.facultyName}\n\nTA - ${c.taName ?? "No TA"}";


        DateTime termstart =
        DateTime(currentDate.year, currentDate.month-1, currentDate.day, int.parse(starthour), int.parse(startmin), 0);
        DateTime termend = DateTime(
            currentDate.year, currentDate.month+1, currentDate.day, int.parse(endhour), int.parse(endmin), 0);

       // print("termstart day is "+termstart.toString());


        DateTime.parse('2020-12-28');

        RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
        RecurrenceProperties();
        recurrencePropertiesForWeeklyAppointment.recurrenceType =
            RecurrenceType.weekly;
        recurrencePropertiesForWeeklyAppointment.startDate = termstart;
        recurrencePropertiesForWeeklyAppointment.endDate = termend;
        recurrencePropertiesForWeeklyAppointment.recurrenceRange =
            RecurrenceRange.endDate;

        recurrencePropertiesForWeeklyAppointment.interval =1;
        recurrencePropertiesForWeeklyAppointment.weekDays = <WeekDays>[]
          ..add(getDay(d.day));
        //recurrencePropertiesForWeeklyAppointment.recurrenceCount = 200;
        weeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
            recurrencePropertiesForWeeklyAppointment,
            weeklyAppointment.startTime,
            weeklyAppointment.endTime);
        _appointments.add(weeklyAppointment);





      }

    }

  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.appointments == null ||
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }
    Appointment appointmentDetails = calendarTapDetails.appointments[0];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(appointmentDetails.notes,
            style:  GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black
            ),
          ),
          //content: new Text("TA- Abhinav The Boss"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close",
                style:GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  /// Adds the collection of color in a list for the appointment data source for
  /// calendar.
  void _addColorCollection() {
    colorCollection = <Color>[];
    colorCollection.add(const Color(0xFF0F8644));
    colorCollection.add(const Color(0xFF8B1FA9));
    colorCollection.add(const Color(0xFFD20100));
    colorCollection.add(const Color(0xFFFC571D));
    colorCollection.add(const Color(0xFF36B37B));
    colorCollection.add(const Color(0xFF01A1EF));
    colorCollection.add(const Color(0xFF3D4FB5));
    colorCollection.add(Colors.cyan);
     colorCollection.add(Colors.deepPurpleAccent);
    colorCollection.add(const Color(0xFF0A8043));
  }

  /// Returns the calendar widget based on the properties passed
  SfCalendar _getRecurrenceCalendar(
      [CalendarController _calendarController,
        CalendarDataSource _calendarDataSource,
        dynamic onViewChanged,
        dynamic scheduleViewBuilder,dynamic calendarTapCallback]) {
    return SfCalendar(
      onTap: calendarTapCallback,
      showNavigationArrow:false,
      view: CalendarView.workWeek,
      timeSlotViewSettings:
      TimeSlotViewSettings(startHour: 8,
          endHour: 20,
          timeIntervalHeight: -1,
          dateFormat: 'd',
          dayFormat: 'EEE',
          // timeInterval: Duration(hours: 2),
          nonWorkingDays: <int>[DateTime.sunday]),
      appointmentTextStyle:  GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white
      ),
      showDatePickerButton:false,
      allowViewNavigation:false,
      firstDayOfWeek: 1,
      controller: _calendarController,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      onViewChanged: onViewChanged,
      dataSource: _calendarDataSource,
      monthViewSettings: MonthViewSettings(
        dayFormat: 'EEEE',
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          appointmentDisplayCount: 4),
    );
  }

  /// Returns the month name based on the month value passed from date.
  String _getMonthDate(int month) {
    if (month == 01) {
      return 'January';
    } else if (month == 02) {
      return 'February';
    } else if (month == 03) {
      return 'March';
    } else if (month == 04) {
      return 'April';
    } else if (month == 05) {
      return 'May';
    } else if (month == 06) {
      return 'June';
    } else if (month == 07) {
      return 'July';
    } else if (month == 08) {
      return 'August';
    } else if (month == 09) {
      return 'September';
    } else if (month == 10) {
      return 'October';
    } else if (month == 11) {
      return 'November';
    } else {
      return 'December';
    }
  }


  void logout() {
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
                      style: GoogleFonts.nunito(
                        //textStyle: Theme.of(context).textTheme.display1,
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        //fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            );

            //CommonData.isLoading=true;
          });
    });
    Future.delayed(Duration(seconds: 1),()  async {
      //bool val = await Networks.loginandgetUserData(email);
      if(true){
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context); //for login page
          Navigator.pushNamed(context, HomePage);
        });
      }
      else{
        setState(() {

        });
      }


    });

  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}