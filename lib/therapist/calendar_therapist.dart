import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTherapist extends StatefulWidget {
  @override
  _CalendarTherapistState createState() => _CalendarTherapistState();
}

class _CalendarTherapistState extends State<CalendarTherapist> {
  Map<DateTime, List<Map<String, dynamic>>> appointments = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  TextEditingController _timeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FormatException("No user is logged in.");
      }

      String therapistEmail = user.email!;

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('appointments')
          .where("therapistEmail", isEqualTo: therapistEmail)
          .get();

      setState(() {
        appointments = {};
        for (var doc in querySnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          DateTime appointmentDateTime = data['appointmentDateTime'].toDate();
          DateTime normalizedDate = DateTime(appointmentDateTime.year,
              appointmentDateTime.month, appointmentDateTime.day);

          if (appointments[normalizedDate] == null) {
            appointments[normalizedDate] = [];
          }

          appointments[normalizedDate]?.add({
            "time": DateFormat('hh:mm a').format(appointmentDateTime),
            "customerEmail": data['customerEmail'],
            "docId": doc.id,
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching appointments: $e")));
    }
  }

  void _addAppointment() async {
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select a date")));
      return;
    }

    if (_timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter the appointment time")));
      return;
    }

    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter the customer's email")));
      return;
    }

    try {
      String time = _timeController.text.trim();
      String email = _emailController.text.trim();

      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FormatException("No user is logged in.");
      }
      String therapistEmail = user.email!;

      String dateTimeString =
          "${_selectedDay!.toIso8601String().split("T")[0]} ${_timeController.text.trim()}";
      DateTime appointmentDateTime =
          DateFormat("yyyy-MM-dd hh:mm a").parse(dateTimeString, true).toUtc();

      Map<String, dynamic> appointmentData = {
        "customerEmail": email,
        "appointmentDateTime": appointmentDateTime,
        "therapistEmail": therapistEmail,
      };

      await FirebaseFirestore.instance
          .collection('appointments')
          .add(appointmentData);

      await _fetchAppointments();

      _timeController.clear();
      _emailController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointment added successfully!")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _showCancelConfirmationDialog(String docId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Cancel Appointment"),
          content: Text("Are you sure you want to cancel this appointment?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
                await _cancelAppointment(docId);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cancelAppointment(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(docId)
          .delete();
      await _fetchAppointments();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointment canceled successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error canceling appointment: $e")));
    }
  }

  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _timeController,
                  decoration: InputDecoration(
                      labelText: 'Appointment Time (e.g., 10:30 AM)'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Customer Email'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _addAppointment,
              child: Text('Add Appointment'),
            ),
          ],
        );
      },
    );
  }

  List<Map<String, dynamic>> _getAppointmentsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return appointments[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime(2020),
                      lastDay: DateTime(2030),
                      calendarFormat: _calendarFormat,
                      availableCalendarFormats: {
                        CalendarFormat.month: 'Month',
                        CalendarFormat.week: 'Week',
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _fetchAppointments();
                      },
                      eventLoader: (day) => _getAppointmentsForDay(day),
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Colors.deepPurple.shade200,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                        selectedTextStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children:
                          _getAppointmentsForDay(_selectedDay ?? _focusedDay)
                              .map((appointment) => Card(
                                    margin: EdgeInsets.symmetric(vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 3,
                                    child: ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      title: Text(
                                        "${appointment['time']} - ${appointment['customerEmail']}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.cancel,
                                            color: Colors.deepPurple.shade400),
                                        onPressed: () =>
                                            _showCancelConfirmationDialog(
                                                appointment['docId']),
                                      ),
                                    ),
                                  ))
                              .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddAppointmentDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.deepPurple),
              ),
              child: Text(
                'Add Appointment',
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
