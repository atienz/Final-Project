import 'dart:async';
import 'dart:collection';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mysample/welcome_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final ValueNotifier<List<Text>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Text> _getEventsForDay(DateTime day) {
    final events = LinkedHashMap(
      equals: isSameDay,
    );
    return events[day] ?? [];
  }

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);
  //
  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }

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

  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   });
  //
  //   // `start` or `end` could be null
  //   // if (start != null && end != null) {
  //   //   _selectedEvents.value = _getEventsForRange(start, end);
  //    else if (start != null) {
  //     _selectedEvents.value = _getEventsForDay(start);
  //   } else if (end != null) {
  //     _selectedEvents.value = _getEventsForDay(end);
  //   }
  // }

  static const timeout = Duration(seconds: 3);
  static const ms = Duration(milliseconds: 1);

  Timer startTimeout([int? milliseconds]) {
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return Timer(duration, handleTimeout);
  }
  void handleTimeout() {  // callback function

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('TableCalendar - Events'),
actions: <Widget>[
      IconButton(
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
    ]
          ),
      body: Column(
        children: [

          TableCalendar<Text>(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            // onRangeSelected: _onRangeSelected,
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
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
