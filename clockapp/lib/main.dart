import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PageOne(),
    PageTwo(),
    PageThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Sensors',
          ),
        ],
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(),
    );
  }
}

class PageTwo extends StatefulWidget {
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
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      final InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      flutterLocalNotificationsPlugin!.initialize(initializationSettings,
          onSelectNotification: onSelectNotification);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildAlarmList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectTime(context);
        },
        child: Icon(Icons.alarm),
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

        return ListTile(
          title: Text(
            formatAlarmTime(alarmTime),
            style: TextStyle(fontSize: 18.0),
          ),
        );
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      print('Selected time: ${picked.format(context)}');
      // Schedule a notification for the selected time
      _scheduleNotification(picked);
    } else {
      print('Time selection canceled.');
      // Handle the case where the user canceled the time picker
    }
  }

  Future<void> _scheduleNotification(TimeOfDay pickedTime) async {
    DateTime now = DateTime.now();

    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
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
      await flutterLocalNotificationsPlugin!.showDailyAtTime(
        0,
        'Alarm',
        'Time to wake up!',
        Time(scheduledTime.hour, scheduledTime.minute),
        platformChannelSpecifics,
      );

      // Update the list of alarms
      setState(() {
        alarms.add(formatAlarmTime(pickedTime));
      });
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
}

//////////////////////////////////////////////////////////////////////////////
class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
    );
  }
}
