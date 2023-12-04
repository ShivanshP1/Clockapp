// ignore: file_names
// ignore_for_file: use_key_in_widget_constructors, use_super_parameters
// pages/page_one.dart
// ignore_for_file: use_build_context_synchronously

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
          _buildSectionTitle('Future Features'),
          _buildCategoryList(),
          _buildSectionTitle('Your Sleep'),
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
      height: 165,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildCategoryItem('Accounts', Icons.account_circle),
          _buildCategoryItem('Events', Icons.event),
          _buildCategoryItem('Custom Sounds', Icons.book),
          _buildCategoryItem('Backups', Icons.restore),
          _buildCategoryItem('Device', Icons.important_devices),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 100,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon at the top, taking most of the space
            Container(
              height: 80,
              child: Icon(icon, size: 40),
            ),
            // Text at the bottom with limited height
            Container(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
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
          _buildFeaturedItem('AVG BPM', Icons.phone, 0.7),
          _buildFeaturedItem('AVG Sleep', Icons.laptop, 0.5),
          _buildFeaturedItem('Streak', Icons.directions_run, 0.3),
          _buildFeaturedItem('REM Sleep', Icons.menu_book, 0.9),
          _buildFeaturedItem('Sleep quality', Icons.weekend, 0.2),
        ],
      ),
    );
  }

  Widget _buildFeaturedItem(String title, IconData icon, double progressValue) {
    // Color gaugeColor = _getGaugeColor(progressValue);

    return Container(
      margin: const EdgeInsets.all(8),
      width: 200,
      child: Card(
        child: Stack(
          children: [
            Center(
              child: CustomSemiCircularGauge(
                percentage: (progressValue * 100).toInt(),
              ),
            ),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
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
            'Give us Feed back and let us know how we did, Click the button below and do our survey',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            child: const Text('Survey'),
          ),
        ],
      ),
    );
  }
}

// ... (existing code)

class CustomSemiCircularGauge extends StatelessWidget {
  final int percentage; // Input percentage value (1 to 100)

  const CustomSemiCircularGauge({
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 100,
      child: CustomPaint(
        painter: SemiCircularGaugePainter(
          percentage: percentage,
        ),
      ),
    );
  }
}

class SemiCircularGaugePainter extends CustomPainter {
  final int percentage;

  SemiCircularGaugePainter({
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    paint.color = _getGaugeColor();
    final double sweepAngle = (3 / 2) * pi * (percentage / 100);
    final Rect rect = Rect.fromCircle(
        center: Offset(centerX, centerY), radius: min(centerX, centerY));
    canvas.drawArc(rect, pi, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Color _getGaugeColor() {
    // Logic for determining the gauge color based on the percentage
    // You can customize this logic based on your color preferences
    if (percentage >= 70) {
      return Colors.green; // Good
    } else if (percentage >= 40) {
      return Colors.yellow; // Ok
    } else {
      return Colors.red; // Bad
    }
  }
}
