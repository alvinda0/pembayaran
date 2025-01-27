import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
 @override
 _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
 int _selectedIndex = 0;

 final List<Widget> _pages = [
   HomePage(),
   AnalyticsPage(),
   NotificationPage(),
   ProfilePage(),
 ];

 void _onItemTapped(int index) {
   setState(() {
     _selectedIndex = index;
   });
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: _pages[_selectedIndex],
     bottomNavigationBar: BottomNavigationBar(
       items: const <BottomNavigationBarItem>[
         BottomNavigationBarItem(
           icon: Icon(Icons.home),
           label: 'Home',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.analytics),
           label: 'Analytics',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.notifications),
           label: 'Notifications',
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person),
           label: 'Profile',
         ),
       ],
       currentIndex: _selectedIndex,
       selectedItemColor: Colors.blue,
       unselectedItemColor: Colors.grey,
       onTap: _onItemTapped,
     ),
   );
 }
}

// Placeholder pages
class HomePage extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Home')),
     body: Center(child: Text('Home Page')),
   );
 }
}

class AnalyticsPage extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Analytics')),
     body: Center(child: Text('Analytics Page')),
   );
 }
}

class NotificationPage extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Notifications')),
     body: Center(child: Text('Notifications Page')),
   );
 }
}

class ProfilePage extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text('Profile')),
     body: Center(child: Text('Profile Page')),
   );
 }
}