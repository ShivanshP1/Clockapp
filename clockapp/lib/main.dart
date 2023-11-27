import 'package:flutter/material.dart';
import 'package:timezone/standalone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await tz.initializeTimeZones();

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
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

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

    final tz.TZDateTime scheduledDateTime = tz.TZDateTime(
      tz.local,
      scheduledTime.year,
      scheduledTime.month,
      scheduledTime.day,
      scheduledTime.hour,
      scheduledTime.minute,
    );

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

    // Check if flutterLocalNotificationsPlugin is not null before using it
    if (flutterLocalNotificationsPlugin != null) {
      await flutterLocalNotificationsPlugin!.zonedSchedule(
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
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle when the user taps on the notification
    print('Notification tapped with payload: $payload');
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
    );
  }
}
