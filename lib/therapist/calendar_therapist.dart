import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teraflow/therapist/payment_page.dart';

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
  TextEditingController emailController =
      TextEditingController(); // Customer email
  TextEditingController priceController = TextEditingController();
  List<DateTime> selectedAppointments = []; // Store selected sessions

  String? customerEmail;
  double? totalAmount;

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

  void _addMultipleAppointments(
      List<Map<String, dynamic>> appointments, String email) async {
    if (appointments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select at least one date")));
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter the customer's email")));
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("No user logged in.")));
      return;
    }

    String therapistEmail = user.email!;

    try {
      for (var appointment in appointments) {
        DateTime date = appointment['date'];
        String time = appointment['timeController'].text.trim();

        if (time.isEmpty) continue; // Skip empty time slots

        String dateTimeString = "${date.toIso8601String().split("T")[0]} $time";
        DateTime appointmentDateTime = DateFormat("yyyy-MM-dd hh:mm a")
            .parse(dateTimeString, true)
            .toUtc();

        Map<String, dynamic> appointmentData = {
          "customerEmail": email,
          "appointmentDateTime": appointmentDateTime,
          "therapistEmail": therapistEmail,
        };

        await FirebaseFirestore.instance
            .collection('appointments')
            .add(appointmentData);
      }

      await _fetchAppointments();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointments added successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _showAddAppointmentDialog() async {
    List<Map<String, dynamic>> selectedAppointments = [];
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Multiple Appointments'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Customer Email',
                        hintText: 'Enter customer email',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Price per session (Birr)',
                        prefixText: 'ETB ',
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children:
                          selectedAppointments.asMap().entries.map((entry) {
                        int index = entry.key;
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${DateFormat('yyyy-MM-dd').format(entry.value['date'])}",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: entry.value['timeController'],
                                decoration: InputDecoration(
                                  labelText: 'Time (10:30 AM)',
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_circle,
                                  color: Colors.deepPurple),
                              onPressed: () {
                                setDialogState(() {
                                  selectedAppointments.removeAt(index);
                                });
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );

                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedAppointments.add({
                              "date": pickedDate,
                              "timeController": TextEditingController(),
                            });
                          });
                        }
                      },
                      child: Text("Add Another Date"),
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
                  onPressed: () async {
                    if (emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Please enter a customer email.")),
                      );
                      return;
                    }
                    if (priceController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Please enter the session price.")),
                      );
                      return;
                    }
                    if (selectedAppointments.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Please select at least one session date.")),
                      );
                      return;
                    }
                    double pricePerSession =
                        double.tryParse(priceController.text.trim()) ?? 0;
                    double totalAmount =
                        pricePerSession * selectedAppointments.length;

                    // Redirect to PaymentPage without passing email or total amount
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          email: emailController.text.trim(),
                          totalAmount: totalAmount.toString(),
                        ),
                      ),
                    );
                  },
                  child: Text('Add Appointments'),
                ),
              ],
            );
          },
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
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _showAddAppointmentDialog,
                    child: Text("Add Appointments"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}