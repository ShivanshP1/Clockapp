import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottom Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PageOne(),
    const PageTwo(),
    const PageThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Navigation Example'),
      ),
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
  const PageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors'),
      ),
      body: Container(
        color: Colors.white,
        child: const Center(),
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  const PageTwo({super.key});

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // List to store alarms
  List<String> alarms = [];

  _PageTwoState() {
    // Initialize the notification plugin
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm'),
      ),
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
        return ListTile(
          title: Text(alarms[index]),
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
    final DateTime now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledDateTime =
        tz.TZDateTime.from(scheduledTime, tz.local);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'alarm_channel',
      'Alarm notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      sound: RawResourceAndroidNotificationSound('your_custom_sound'),
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alarm',
      'Time to wake up!',
      scheduledDateTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    // Update the list of alarms
    setState(() {
      alarms.add('Alarm at ${pickedTime.format(context)}');
    });
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle when the user taps on the notification
    print('Notification tapped with payload: $payload');
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Container(
        color: Colors.white,
      ),
    );
  }
}
