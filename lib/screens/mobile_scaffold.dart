import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart'; // Import the dashboard screen.
import 'employee_screen.dart'; // Import the employee screen.
import 'attendance_screen.dart'; // Import the attendance screen.
import 'payslip_screen.dart'; // Import the payslip screen.
import '../main.dart'; // Import the main file for accessing the theme provider.

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({super.key}); // Constructor for MobileScaffold widget.

  @override
  _MobileScaffoldState createState() =>
      _MobileScaffoldState(); // Create state for MobileScaffold.
}

class _MobileScaffoldState extends State<MobileScaffold> {
  int _selectedIndex = 0; // Index of the selected bottom navigation item.

  final List<Widget> _screens = [
    const DashboardScreen(), // Dashboard screen widget.
    const EmployeeScreen(), // Employee screen widget.
    const AttendanceScreen(), // Attendance screen widget.
    const PayslipScreen(), // Payslip screen widget.
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context); // Access ThemeProvider.

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80.0, // Height of the AppBar.
        backgroundColor: Colors.blue, // Background color of the AppBar.
        title: Row(
          children: [
            Icon(
              Icons.local_police,
              color: themeProvider.themeMode == ThemeMode.light
                  ? Colors.white
                  : Colors.white, // Icon color based on the theme.
              size: 36.0, // Size of the icon.
            ),
            const SizedBox(width: 12), // Spacing between icon and text.
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Police Hotline',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Movement Incorporated',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.brightness_3
                  : Icons.wb_sunny, // Icon based on the theme.
              color: Colors.white, // Icon color.
            ),
            onPressed: () {
              themeProvider.toggleTheme(); // Toggle the theme on button press.
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex, // Index of the selected screen.
        children: _screens, // List of screen widgets.
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Animation duration.
        height: 60, // Height of the bottom navigation bar.
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard'), // Dashboard tab.
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Employees'), // Employees tab.
            BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                label: 'Attendance'), // Attendance tab.
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), label: 'Payslips'), // Payslips tab.
          ],
          currentIndex: _selectedIndex, // Currently selected index.
          onTap: _onItemTapped, // Function to handle item tap.
          type: BottomNavigationBarType
              .fixed, // Type of the bottom navigation bar.
          selectedItemColor: Colors.blue, // Color of the selected item.
          unselectedItemColor: Colors.grey, // Color of the unselected items.
          showUnselectedLabels: true, // Show labels for unselected items.
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index on tap.
    });
  }
}
