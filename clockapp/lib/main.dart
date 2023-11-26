import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('Bottom Navigation Example'),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
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

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, 0),
          tileMode: TileMode.clamp,
          radius: 0.7,
          stops: <double>[0.1, 0.25],
          colors: [
            Color.fromARGB(255, 69, 169, 201),
            Color.fromARGB(255, 251, 255, 255),
          ],
        ),
      ),
      child: Center(
        child: AnalogClock(
          decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            color: Colors.white70,
            shape: BoxShape.circle,
          ),
          width: 250.0,
          isLive: true,
          hourHandColor: Colors.black,
          minuteHandColor: Colors.black,
          secondHandColor: Colors.red,
          numberColor: Colors.black87,
          showNumbers: true,
          showTicks: true,
          textScaleFactor: 1.7,
          showDigitalClock: false,
          digitalClockColor: Colors.black,
        ),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(),
    );
  }
}

class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 3, // Set the number of columns to 3 for a 3x3 grid
        children: [
          _buildGridItem(['Item 1']),
          _buildGridItem(['Item 2']),
          _buildGridItem(['Item 3']),
          _buildGridItem(['Item 4']),
          _buildGridItem(['Item 5']),
          _buildGridItem(['Item 6']),
          _buildGridItem(['Item 7']),
          _buildGridItem(['Item 8']),
          _buildGridItem(['Item 9']),
        ],
      ),
    );
  }
}

Widget _buildGridItem(List<String> texts) {
  return Card(
    margin: EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: texts.map((text) {
        return Text(
          text,
          style: TextStyle(fontSize: 20.0),
        );
      }).toList(),
    ),
  );
}
