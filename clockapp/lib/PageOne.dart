// ignore: file_names
// ignore_for_file: use_key_in_widget_constructors, use_super_parameters

import 'package:flutter/material.dart';
import 'dart:math';

class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView(
        children: <Widget>[
          _buildSectionTitle('Categories'),
          _buildCategoryList(),
          _buildSectionTitle('Featured Items'),
          _buildFeaturedItemList(),
          _buildSectionTitle('Additional Section'),
          _buildAdditionalSection(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildCategoryItem('Electronics', Icons.devices),
          _buildCategoryItem('Clothing', Icons.accessibility),
          _buildCategoryItem('Books', Icons.book),
          _buildCategoryItem('Sports', Icons.sports),
          _buildCategoryItem('Home', Icons.home),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 100,
      child: Card(
        child: ListTile(
          // title: Text(title),
          leading: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildFeaturedItemList() {
    return SizedBox(
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildFeaturedItem('AVG BPM', Icons.phone),
          _buildFeaturedItem('AVG Sleep', Icons.laptop),
          _buildFeaturedItem('Streak', Icons.directions_run),
          _buildFeaturedItem('asd', Icons.menu_book),
          _buildFeaturedItem('wasd', Icons.weekend),
        ],
      ),
    );
  }

  Widget _buildFeaturedItem(String title, IconData icon) {
    double progressValue = 0.7; // Set your progress value here
    Color gaugeColor = _getGaugeColor(progressValue);

    return Container(
      margin: const EdgeInsets.all(8),
      width: 200, // Adjust the width to scale up the size
      child: Card(
        child: Stack(
          children: [
            Center(
              child: CustomSemiCircularGauge(
                progressValue: progressValue,
                gaugeColor: gaugeColor,
              ),
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Adjust text color as needed
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGaugeColor(double progressValue) {
    if (progressValue >= 0.7) {
      return Colors.green; // Good
    } else if (progressValue >= 0.4) {
      return Colors.yellow; // Ok
    } else {
      return Colors.red; // Bad
    }
  }

  Widget _buildAdditionalSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome to Our App!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Explore the latest trends and discover amazing products.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }
}

class CustomSemiCircularGauge extends StatelessWidget {
  final double progressValue;
  final Color gaugeColor;

  const CustomSemiCircularGauge({
    required this.progressValue,
    required this.gaugeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500, // Adjust the width to scale up the size
      height: 100, // Adjust the height to control the size of the semi-circle
      child: CustomPaint(
        painter: SemiCircularGaugePainter(
          progressValue: progressValue,
          gaugeColor: gaugeColor,
        ),
      ),
    );
  }
}

class SemiCircularGaugePainter extends CustomPainter {
  final double progressValue;
  final Color gaugeColor;

  SemiCircularGaugePainter({
    required this.progressValue,
    required this.gaugeColor,
  });

  double degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0 // Adjust the stroke width to control the size
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    paint.color = gaugeColor;
    final double sweepAngle = 180 * progressValue;
    final Rect rect = Rect.fromCircle(
        center: Offset(centerX, centerY), radius: min(centerX, centerY));
    canvas.drawArc(rect, pi, degreesToRadians(sweepAngle), false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
