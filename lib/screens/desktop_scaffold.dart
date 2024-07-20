import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dashboard_screen.dart';
import 'employee_screen.dart';
import 'attendance_screen.dart';
import 'payslip_screen.dart';
import '../main.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key}); // Constructor with key.

  @override
  _DesktopScaffoldState createState() =>
      _DesktopScaffoldState(); // Create the state for the widget.
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  int _selectedIndex = 0; // Index of the currently selected screen.
  bool _isExpanded = true; // Determines if the side menu is expanded or not.

  final List<Widget> _screens = [
    // List of screens to be displayed.
    const DashboardScreen(), // Dashboard screen.
    const EmployeeScreen(), // Employee screen.
    const AttendanceScreen(), // Attendance screen.
    const PayslipScreen(), // Payslip screen.
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
        context); // Access the ThemeProvider from the context.

    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(
                milliseconds:
                    200), // Duration of the animation for expanding/collapsing.
            width: _isExpanded
                ? 250
                : 70, // Width of the side menu based on expansion state.
            color: Theme.of(context)
                .scaffoldBackgroundColor, // Background color of the side menu.
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Padding around the menu icon.
                  child: IconButton(
                    icon: Icon(_isExpanded
                        ? Icons.menu_open
                        : Icons
                            .menu), // Menu icon changes based on expansion state.
                    onPressed: () {
                      setState(() {
                        _isExpanded =
                            !_isExpanded; // Toggle the expansion state.
                      });
                    },
                  ),
                ),
                if (_isExpanded) ...[
                  // Conditionally display the content when expanded.
                  Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Padding inside the side menu.
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_police,
                          color: Colors.blue[800], // Icon color.
                          size: 50.0, // Icon size.
                        ),
                        const SizedBox(
                            height: 8.0), // Space between icon and text.
                        Text(
                          'Police Hotline Movement Incorporated', // Title text.
                          style: TextStyle(
                            fontSize: 15, // Font size of the title text.
                            fontWeight: FontWeight
                                .w900, // Font weight of the title text.
                            color: Colors.blue[800], // Color of the title text.
                          ),
                          textAlign: TextAlign.center, // Center-align the text.
                        ),
                      ],
                    ),
                  ),
                  const Divider(), // Divider line.
                  Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Padding inside the side menu.
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20, // Radius of the circle avatar.
                          backgroundColor:
                              Colors.blue, // Background color of the avatar.
                          child: Icon(Icons.person,
                              size: 20,
                              color: Colors.white), // Icon inside the avatar.
                        ),
                        const SizedBox(
                            width: 12), // Space between the avatar and text.
                        Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align text to the start.
                          children: [
                            const Text(
                              'Juan Dela Cruz', // Name text.
                              style: TextStyle(
                                fontSize: 18, // Font size of the name text.
                                fontWeight: FontWeight
                                    .bold, // Font weight of the name text.
                              ),
                            ),
                            Text(
                              'Accountant', // Job title text.
                              style: TextStyle(
                                fontSize:
                                    14, // Font size of the job title text.
                                color: Colors
                                    .grey[600], // Color of the job title text.
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(), // Divider line.
                ],
                Expanded(
                  child: ListView(
                    children: [
                      _buildNavItem(0, 'Dashboard',
                          Icons.dashboard), // Navigation item for Dashboard.
                      _buildNavItem(1, 'Employees',
                          Icons.people), // Navigation item for Employees.
                      _buildNavItem(2, 'Attendance',
                          Icons.timer), // Navigation item for Attendance.
                      _buildNavItem(3, 'Payslips',
                          Icons.receipt), // Navigation item for Payslips.
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      5.0), // Padding inside the side menu.
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Space items evenly.
                    children: [
                      if (_isExpanded)
                        const Text(
                            'Dark Mode'), // Label for dark mode switch when expanded.
                      Transform.scale(
                        scale: 0.75, // Scale factor to adjust the switch size.
                        child: Switch(
                          value: themeProvider.themeMode ==
                              ThemeMode
                                  .dark, // Switch state based on theme mode.
                          onChanged: (_) {
                            themeProvider
                                .toggleTheme(); // Toggle theme mode on switch change.
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      5.0), // Padding inside the side menu.
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // Space items evenly.
                    children: [
                      if (_isExpanded)
                        const Text(
                            'Logout'), // Label for logout button when expanded.
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: Colors.grey), // Logout icon.
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/'); // Navigate to the root route.
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(
              thickness: 1,
              width: 1), // Vertical divider between menu and main content.
          Expanded(
            child: _screens[
                _selectedIndex], // Display the currently selected screen.
          ),
        ],
      ),
    );
  }

  // Builds a navigation item in the side menu.
  Widget _buildNavItem(int index, String title, IconData icon) {
    final isSelected =
        _selectedIndex == index; // Check if the item is selected.
    return InkWell(
      onTap: () => setState(
          () => _selectedIndex = index), // Update selected index on tap.
      child: AnimatedContainer(
        duration: const Duration(
            milliseconds: 200), // Duration of the animation for item selection.
        padding: EdgeInsets.symmetric(
            horizontal: _isExpanded ? 16 : 0,
            vertical: 12), // Padding inside the item.
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withOpacity(0.1)
              : Colors.transparent, // Background color based on selection.
          borderRadius:
              BorderRadius.circular(8), // Rounded corners for the item.
        ),
        child: Row(
          mainAxisAlignment: _isExpanded
              ? MainAxisAlignment.start
              : MainAxisAlignment
                  .center, // Align children based on expansion state.
          children: [
            Icon(icon,
                color: isSelected
                    ? Colors.blue
                    : Colors.grey), // Icon color based on selection.
            if (_isExpanded) ...[
              // Conditionally display text when expanded.
              const SizedBox(width: 12), // Space between icon and text.
              Text(
                title, // Navigation item title.
                style: TextStyle(
                  color: isSelected
                      ? Colors.blue
                      : Colors.grey[800], // Text color based on selection.
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : FontWeight.normal, // Font weight based on selection.
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
