import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iiitb_academics/models/Meeting.dart';
import 'package:iiitb_academics/models/MeetingDataSource.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeTableView extends StatefulWidget {
  @override
  _TimeTableViewState createState() => _TimeTableViewState();
}

class _TimeTableViewState extends State<TimeTableView> {


  List<Appointment> _appointments;
  List<Color> colorCollection;
  CalendarController calendarController;

  final List<CalendarView> _allowedViews = <CalendarView>[
    CalendarView.day,
    CalendarView.week,
    CalendarView.workWeek,
    CalendarView.month,
    CalendarView.schedule
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
    return Stack(
      children: [
        Image(
            image: ExactAssetImage('images/' + monthName + '.png'),
            fit: BoxFit.cover,
            width: details.bounds.width,
            height: details.bounds.height),
        Positioned(
          left: 55,
          right: 0,
          top: 20,
          bottom: 0,
          child: Text(
            monthName + ' ' + details.date.year.toString(),
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    );
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
          trailing: Text(
            "Logout", textAlign: TextAlign.right,
            style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black
            ),
          ),
        ),

        backgroundColor: Color(0xfff6fbff),
        elevation: 2,
      ),
      body: Row(children: <Widget>[
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
    ])
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

  void _createRecursiveAppointments() {
    final Random random = Random();

    final DateTime currentDate = DateTime.now();
    final DateTime startTime =
    DateTime(currentDate.year, currentDate.month, currentDate.day, 9, 0, 0);
    final DateTime endTime = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 11, 0, 0);


    //Recurrence Appointment 2
    final Appointment weeklyAppointment = Appointment();
    final DateTime startTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    final DateTime endTime1 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 15, 0, 0);
    weeklyAppointment.startTime = startTime1;
    weeklyAppointment.endTime = endTime1;
    weeklyAppointment.color = colorCollection[random.nextInt(9)];
    weeklyAppointment.subject = 'Algorithm';

    final RecurrenceProperties recurrencePropertiesForWeeklyAppointment =
    RecurrenceProperties();
    recurrencePropertiesForWeeklyAppointment.recurrenceType =
        RecurrenceType.weekly;
    recurrencePropertiesForWeeklyAppointment.recurrenceRange =
        RecurrenceRange.count;
    recurrencePropertiesForWeeklyAppointment.interval = 1;
    recurrencePropertiesForWeeklyAppointment.weekDays = <WeekDays>[]
      ..add(WeekDays.monday);
    recurrencePropertiesForWeeklyAppointment.recurrenceCount = 20;
    weeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForWeeklyAppointment,
        weeklyAppointment.startTime,
        weeklyAppointment.endTime);
    _appointments.add(weeklyAppointment);


    final Appointment customWeeklyAppointment = Appointment();
    final DateTime startTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 12, 0, 0);
    final DateTime endTime5 = DateTime(
        currentDate.year, currentDate.month, currentDate.day, 13, 0, 0);
    customWeeklyAppointment.startTime = startTime5;
    customWeeklyAppointment.endTime = endTime5;
    customWeeklyAppointment.color = colorCollection[random.nextInt(9)];
    customWeeklyAppointment.subject = 'Machine Learning';

    final RecurrenceProperties recurrencePropertiesForCustomWeeklyAppointment =
    RecurrenceProperties();
    recurrencePropertiesForCustomWeeklyAppointment.recurrenceType =
        RecurrenceType.weekly;
    recurrencePropertiesForCustomWeeklyAppointment.recurrenceRange =
        RecurrenceRange.endDate;
    recurrencePropertiesForCustomWeeklyAppointment.interval = 1;
    recurrencePropertiesForCustomWeeklyAppointment.weekDays = <WeekDays>[
      WeekDays.monday,
      WeekDays.friday
    ];
    recurrencePropertiesForCustomWeeklyAppointment.endDate =
        DateTime.now().add(const Duration(days: 14));
    customWeeklyAppointment.recurrenceRule = SfCalendar.generateRRule(
        recurrencePropertiesForCustomWeeklyAppointment,
        customWeeklyAppointment.startTime,
        customWeeklyAppointment.endTime);
    _appointments.add(customWeeklyAppointment);


  }

  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.appointments == null ||
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Teacher-Prof V Murli"),
          content: new Text("TA- Abhinav The Boss"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
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
    colorCollection.add(const Color(0xFFE47C73));
    colorCollection.add(const Color(0xFF636363));
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
      showNavigationArrow: true,
      controller: _calendarController,
      allowedViews: _allowedViews,
      scheduleViewMonthHeaderBuilder: scheduleViewBuilder,
      showDatePickerButton: true,
      onViewChanged: onViewChanged,
      dataSource: _calendarDataSource,
      monthViewSettings: MonthViewSettings(
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

}
/// An object to set the appointment collection data source to collection, and
/// allows to add, remove or reset the appointment collection.
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(this.source);

  List<Appointment> source;

  @override
  List<dynamic> get appointments => source;
}