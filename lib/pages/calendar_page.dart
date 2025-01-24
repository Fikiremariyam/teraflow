import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teraflow/pages/category_page.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Map<DateTime, List<String>> appointments = {};
  String? userEmail;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  /// Initialize user and load appointments
  Future<void> _initializeUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userEmail = user.email;
      });
      print("Logged-in user email: $userEmail");
      await _loadAppointments();
    } else {
      print("No user is logged in.");
    }
  }

  /// Load appointments from Firestore
  Future<void> _loadAppointments() async {
    if (userEmail == null) return;

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Queries for customer and therapist appointments
      QuerySnapshot customerSnapshot = await firestore
          .collection('appointments')
          .where('customerEmail', isEqualTo: userEmail)
          .get();

      QuerySnapshot therapistSnapshot = await firestore
          .collection('appointments')
          .where('therapistEmail', isEqualTo: userEmail)
          .get();

      print("Customer appointments: ${customerSnapshot.docs.length}");
      print("Therapist appointments: ${therapistSnapshot.docs.length}");

      Map<DateTime, List<String>> fetchedAppointments = {};

      _processAppointments(customerSnapshot, fetchedAppointments);
      _processAppointments(therapistSnapshot, fetchedAppointments);

      setState(() {
        appointments = fetchedAppointments;
      });

      print("Loaded appointments: $appointments");
    } catch (e) {
      print("Error loading appointments: $e");
    }
  }

  /// Process Firestore query snapshot into the appointments map
  void _processAppointments(
      QuerySnapshot snapshot, Map<DateTime, List<String>> fetchedAppointments) {
    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;

      // Convert timestamp to DateTime
      Timestamp timestamp = data['appointmentDateTime'];
      DateTime appointmentDate = timestamp.toDate();
      DateTime normalizedDate = DateTime(
          appointmentDate.year, appointmentDate.month, appointmentDate.day);

      // Format appointment details
      String appointmentDetails =
          "Time: ${DateFormat('hh:mm a').format(appointmentDate)} - Therapist: ${data['therapistEmail']}";

      // Add to fetchedAppointments
      fetchedAppointments.putIfAbsent(normalizedDate, () => []);
      fetchedAppointments[normalizedDate]?.add(appointmentDetails);
    }
  }

  /// Display appointments in a container below the calendar
  Widget _buildAppointmentsContainer() {
    if (_selectedDay == null) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "Select a date to view appointments.",
          style: TextStyle(fontSize: 16.0, color: Colors.black),
        ),
      );
    }

    DateTime normalizedDay =
        DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    List<String> appointmentsForDay = appointments[normalizedDay] ?? [];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6.0),
        ],
      ),
      child: appointmentsForDay.isEmpty
          ? Text(
              "No appointments scheduled for this day.",
              style: TextStyle(fontSize: 16.0, color: Colors.grey),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: appointmentsForDay
                  .map((appointment) => Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade100,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          appointment,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ))
                  .toList(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade300, // Set the main background color
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2), blurRadius: 8.0),
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
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _focusedDay = focusedDay;
                    _selectedDay = selectedDay;
                  });
                },
                eventLoader: (day) {
                  return appointments[DateTime(day.year, day.month, day.day)] ??
                      [];
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(color: Colors.white),
                  selectedTextStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            _buildAppointmentsContainer(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryPage()),
                ),
                child: Text("Book a Session"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
