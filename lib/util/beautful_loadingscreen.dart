import 'package:flutter/material.dart';
import 'package:teraflow/util/threedots.dart';

class BeautifulLoadingScreen extends StatelessWidget {
  final String message;
  final Color textColor;
  final Color dotsColor;

  const BeautifulLoadingScreen({
    Key? key,
    this.message = 'Loading',
    this.textColor = Colors.white,
    this.dotsColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              AnimatedDots(color: dotsColor, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}

