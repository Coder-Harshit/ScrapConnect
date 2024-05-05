import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'rate_list.dart';
import 'about_screen.dart';
import 'user_screen.dart';
import 'dealers_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.username}) : super(key: key);

  final String username;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context)!.welcomeMessage(widget.username)),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          RateListPage(),
          DealersListPage(username: widget.username),
          AboutPage(),
          UserPage(username: widget.username),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Market Price',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Dealers List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'About Us',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'You',
          ),
        ],
      ),
    );
  }
}
