import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'About Us'.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Team Lead: Rohit Gupta'),
            subtitle: Text(
              'App Developer, ML Enthusiast',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: Text('Developer: Harshit Vijay'),
            subtitle: Text(
              'App Developer, Open Source Contributor',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: Text('Designer: Anmol Verma'),
            subtitle: Text(
              'Figma Designer, Song Writer',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
          ListTile(
            title: Text('Supervisor: Dr. Varun Shrivastav'),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About Our App',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  'This app is designed to help scrap dealers and users looking to sell scrap by enabling them to find scrap dealers at the right time. Oftentimes, scrap dealers may not be present in the right place at the right time, causing inconvenience for both parties. Our app aims to bridge this gap by providing a platform where users can easily locate nearby scrap dealers and dealers can optimize their presence to reach potential customers efficiently.',
                ),
                SizedBox(height: 16.0),
                Text(
                  'Version 1.0.0',
                ),
                SizedBox(height: 16.0),
                Text(
                  'Copyright © 2024 ScrapConnect',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
