import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  // List to store alarms
  List<String> alarms = [];

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Check if flutterLocalNotificationsPlugin is not null before using it
    if (flutterLocalNotificationsPlugin != null) {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin!.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
    }

    // Load saved alarms from SharedPreferences
    _loadAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAlarmList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectTime(context);
        },
        child: const Icon(Icons.alarm),
      ),
    );
  }

  Widget _buildAlarmList() {
    return ListView.builder(
      itemCount: alarms.length,
      itemBuilder: (context, index) {
        // Convert the formatted string back to TimeOfDay for display
        TimeOfDay alarmTime = TimeOfDay.fromDateTime(
          DateFormat.jm().parse(alarms[index]),
        );

        return _buildAlarmCard(alarmTime, index);
      },
    );
  }

  Widget _buildAlarmCard(TimeOfDay alarmTime, int index) {
    DateTime now = DateTime.now();
    DateTime alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarmTime.hour,
      alarmTime.minute,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Alarm Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteAlarm(index);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              formatAlarmTime(alarmTime),
              style: const TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 8),
            Text(
              'Remaining time: ${_calculateRemainingTime(alarmDateTime)}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateRemainingTime(DateTime alarmDateTime) {
    Duration remainingTime = alarmDateTime.difference(DateTime.now());
    int hours = remainingTime.inHours;
    int minutes = (remainingTime.inMinutes % 60);

    if (hours > 0) {
      return '$hours ${hours == 1 ? 'hour' : 'hours'} and $minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    } else {
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime initialDateTime = now.add(const Duration(
        minutes: 1)); // Set an initial time (e.g., one minute from now)

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(
          now.year + 1), // Allow choosing dates up to 1 year in the future
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
      );

      if (pickedTime != null) {
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        print('Selected date and time: ${pickedDateTime.toString()}');
        // Schedule a notification for the selected date and time
        _scheduleNotification(pickedDateTime);
      } else {
        print('Time selection canceled.');
        // Handle the case where the user canceled the time picker
      }
    } else {
      print('Date selection canceled.');
      // Handle the case where the user canceled the date picker
    }
  }

  Future<void> _scheduleNotification(DateTime pickedDateTime) async {
    DateTime now = DateTime.now();

    if (pickedDateTime.isBefore(now)) {
      print('Selected date and time are in the past.');
      // Handle the case where the selected date and time are in the past
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel',
      'Alarm notifications',
      'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound('your_custom_sound'),
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Check if flutterLocalNotificationsPlugin is not null before using it
    if (flutterLocalNotificationsPlugin != null) {
      await flutterLocalNotificationsPlugin!.schedule(
        0,
        'Alarm',
        'Time to wake up!',
        pickedDateTime,
        platformChannelSpecifics,
      );

      // Update the list of alarms and save to SharedPreferences
      setState(() {
        alarms.add(formatAlarmTime(TimeOfDay.fromDateTime(pickedDateTime)));
      });
      _saveAlarms();
    }
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle when the user taps on the notification
    print('Notification tapped with payload: $payload');
  }

  // Format the alarm time to a user-friendly string
  String formatAlarmTime(TimeOfDay time) {
    DateTime now = DateTime.now();
    DateTime alarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    return DateFormat.jm().format(alarmTime);
  }

  // Load saved alarms from SharedPreferences
  Future<void> _loadAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      alarms = prefs.getStringList('alarms') ?? [];
    });
  }

  // Save alarms to SharedPreferences
  Future<void> _saveAlarms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('alarms', alarms);
  }

  // Delete an alarm
  void _deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
      _saveAlarms();
    });
  }
}
