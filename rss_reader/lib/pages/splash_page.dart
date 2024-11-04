import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Add a delay to the splash page
    Future.delayed(const Duration(seconds: 1), () {
      // Navigate to the home page
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // make a splash age
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // add a logo
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepOrange,
              child: FittedBox(
                child: Icon(
                  Icons.rss_feed,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Drsstiny',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
