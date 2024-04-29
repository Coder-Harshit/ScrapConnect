import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Our App',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 16.0),
            Text(
              'This is a sample Flutter application that demonstrates the basic structure and functionality of a Flutter app.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 16.0),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16.0),
            Text(
              'Copyright © 2023 Your Company',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
