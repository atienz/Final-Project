import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mysample/welcome_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

//class for showing the Calendar. The Calendar will highlight the current date
//the user is able to click on and highlight other dates on the calendar
class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<CalendarPage> {
  //==initialize local variables ==

  //variable to hold the highlighted date, initialized to today's date
  DateTime _focusedDay = DateTime.now();
  //variable to hold the day the user taps on
  DateTime? _selectedDay;
  //variable to hold list of events
  late final ValueNotifier<List<Text>> _selectedEvents;
  //variable to hold range of selected dates
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date

  //variable to hold start of range of dates
  DateTime? _rangeStart;
  //variable to hold end of range of dates
  DateTime? _rangeEnd;

  //initialization class
  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; //set selected day as today's date
    //set events for today to be visible on opening of calendar
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  //method to dispose of viewed events
  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  //function to get list of events for today's date
  List<Text> _getEventsForDay(DateTime day) {
    final events = LinkedHashMap(
      equals: isSameDay,
    );
    return events[day] ?? [];
  }

//function to get events for a user selected day
  //accepts argument of a day to get events from and today's date
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  //class and variables for a timer

  static const timeout = Duration(seconds: 3);
  static const ms = Duration(milliseconds: 1);

  Timer startTimeout([int? milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return Timer(duration, handleTimeout);
  }

  void handleTimeout() {
    // callback function
  }

  //build the Calendar page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('TableCalendar - Events'),
          actions: <Widget>[
            IconButton( //logout button in AppBar.
              // When pressed it logs the user out and reloads the home page
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                Text('Logout');
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage();
                    },
                  ),
                );
              },
            ),
          ]),
      body: Column(
        children: [
          //Calendar code
          TableCalendar<Text>(
            //set the first date available in the calendar to 1/1/2020
            firstDay: DateTime.utc(2020, 01, 01),
            //set the last date available in the calendar to 11/1/2020
            lastDay: DateTime.utc(2030, 11, 01),
            //set the highlighted day to today
            focusedDay: _focusedDay,
            //highlights a day when a user taps a date
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            //set start of range of dates
            rangeStartDay: _rangeStart,
            //set end of range of dates
            rangeEndDay: _rangeEnd,
            //set range selection mode
            rangeSelectionMode: _rangeSelectionMode,
            //load events for the day
            eventLoader: _getEventsForDay,
            //set start of day of week to monday
            startingDayOfWeek: StartingDayOfWeek.monday,
            //set calendar style to customize ui
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
            //set days selected
            onDaySelected: _onDaySelected,
            // onRangeSelected: _onRangeSelected,
            //set the focus day to change when the page (month) is changed
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            //to build the list of events for the day
            child: ValueListenableBuilder<List<Text>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        // title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
