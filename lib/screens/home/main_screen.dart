import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shalom_fba/model/CommonBottomNavigationBar.dart';
import 'package:shalom_fba/screens/attendance_calendar.dart';
import 'package:shalom_fba/screens/home/about_us.dart';
import 'package:shalom_fba/screens/home/dashboard.dart';

import 'home.dart';

class MainScreen extends StatefulWidget {
  final String _isAdmin;
  MainScreen(this._isAdmin);
  @override
  _MainScreenState createState() => _MainScreenState(_isAdmin);
}

class _MainScreenState extends State<MainScreen> {
  final String _isAdmin;
  _MainScreenState(this._isAdmin);

  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        backgroundColor: Colors.white70,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.grey[500],
            ),
            label: 'Home',
            activeIcon: Icon(
              Icons.home,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.grey[500],
            ),
            label: 'Attendance',
            activeIcon: Icon(
              Icons.calendar_today,
              color: Colors.black,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.grey[500],
              size: 36,
            ),
            label: 'Profile',
            activeIcon: Icon(
              Icons.person,
              color: Colors.black,
              size: 36,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: CommonBottomNavigationBar(
        selectedIndex: _selectedIndex,
        navigatorKeys: _navigatorKeys,
        childrens: [
          AboutUs(),
          AttendanceCalendar(isAdmin: _isAdmin,),
          DashboardPage(
            admin: _admin,
          ),
        ],
      ),

    );
  }
  void _admin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AdminHome()));
  }
}