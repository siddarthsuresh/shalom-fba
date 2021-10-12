import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shalom_fba/model/Attendance.dart';
import 'package:shalom_fba/screens/loading.dart';
import 'package:shalom_fba/service/database_service.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatefulWidget {
  final String isAdmin;
  AttendanceCalendar({this.isAdmin});
  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState(isAdmin);
}

class _AttendanceCalendarState extends State<AttendanceCalendar>
    with TickerProviderStateMixin {
  final String _isAdmin;
  String currentUserId = FirebaseAuth.instance.currentUser.uid;
  _AttendanceCalendarState(this._isAdmin);
  Map<DateTime, List> _events = {};
  Map<DateTime, List> _eventsId = {};
  bool selectedDaysFlag = true;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  final _databaseService =
      DatabaseService(uid: FirebaseAuth.instance.currentUser.uid);

  final Map<DateTime, List> _holidays = {};

  setAttendance(List<Attendance> _attendanceList) {
    _events.clear();
    _eventsId.clear();
    print('Attendance List size inside calendar ${_attendanceList.length}');
    if (_attendanceList.isNotEmpty) {
      print('Inside Attendance List');
      _attendanceList.forEach((element) {
        if (_events.containsKey(element.date)) {
          print('events : ${element.date}, name: ${element.name}');
          if (!_events[element.date].contains(element.name)){
            _events[element.date].add(element.name);
            _eventsId[element.date].add(element.uid);
          }
        } else {
          List names = [];
          List ids = [];
          names.add(element.name);
          ids.add(element.uid);
          List name = names;
          List id = ids;
          print('added events : ${element.date}, name: ${element.name}');
          _events.addEntries({element.date: name}.entries);
          _eventsId.addEntries({element.date: id}.entries);
          print('First event : ${_events[element.date].toString()}');
        }
        print(
            'date : ${element.date} , name : ${element.name} , uid : ${element
                .uid}');
      });
      final _selectedDayExact = DateTime.now();
      final _selectedDay = DateTime(_selectedDayExact.year, _selectedDayExact.month, _selectedDayExact.day);
      _selectedEvents = selectedDaysFlag ? _events[_selectedDay] ?? [] : _selectedEvents;
      print('Selected day : $_selectedDay');
      selectedDaysFlag = false;
      print('Selected day events : ${_selectedEvents.toString()}');
    }
    else {
      _selectedEvents = [];
      print('Attendance list is empty');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Attendance>>(
      stream: Stream.fromFuture(_databaseService.getAttendanceDetails()),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          print('inside snapshot');
          setAttendance(snapshot.data);
          return buildScaffold();
        }
        else {
          return Loading();
        }
      }
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      startingDayOfWeek: StartingDayOfWeek.monday,
      calendarStyle: CalendarStyle(
        selectedColor: Colors.deepOrange[400],
        todayColor: Colors.deepOrange[200],
        markersColor: Colors.brown[700],
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events, holidays) {
        _onDaySelected(date, events, holidays);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _isAdmin.toLowerCase() == "true" ? _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400] :
        _eventsId[date].contains(currentUserId)
            ? Colors.green[500]
            : Colors.red[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          _isAdmin.toLowerCase() == "true" ?
          '${events.length}' : _eventsId[date].contains(currentUserId) ? "P" : "A",
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.circle,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
      final dateTime = DateTime.now();

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents != null && _isAdmin.toLowerCase() == "true" ? _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList() : []
    );
  }

  @override
  void initState() {
    super.initState();
    final _selectedDayExact = DateTime.now();
    final _selectedDay = DateTime(_selectedDayExact.year, _selectedDayExact.month, _selectedDayExact.day);
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  Widget buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed:
          (){
            setState(() {
              _events.clear();
            });
          }
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          // _buildTableCalendar(),
          _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          _buildButtons(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }
}
