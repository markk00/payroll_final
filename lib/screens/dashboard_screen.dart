import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/employee_provider.dart';
import '../models/attendance_provider.dart';
import '../models/payroll_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key}); // Constructor with key.

  @override
  Widget build(BuildContext context) {
    // Get providers from context.
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final payrollProvider = Provider.of<PayrollProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(
                fontWeight: FontWeight.w600)), // Title of the app bar.
        elevation: 0, // No elevation for the app bar.
        backgroundColor: Colors.transparent, // Transparent background.
        foregroundColor:
            Theme.of(context).textTheme.bodyLarge?.color, // App bar text color.
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Create a scrollable view.
          return SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Padding around the content.
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align children to start.
                children: [
                  _buildSummaryCards(employeeProvider, attendanceProvider,
                      payrollProvider, constraints), // Build summary cards.
                  const SizedBox(height: 24), // Space between sections.
                  _buildRecentActivityTable(context, attendanceProvider,
                      employeeProvider), // Build recent activity table.
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(
      EmployeeProvider employeeProvider,
      AttendanceProvider attendanceProvider,
      PayrollProvider payrollProvider,
      BoxConstraints constraints) {
    // Check if the screen width is small.
    final isSmallScreen = constraints.maxWidth <= 600;
    final cardList = [
      _buildSummaryCard(
          'Employees',
          employeeProvider.employees.length.toString(),
          Icons.people), // Card for employees.
      _buildSummaryCard(
          'Attendance',
          attendanceProvider.attendanceRecords.length.toString(),
          Icons.timer), // Card for attendance.
      _buildSummaryCard('Payslips', payrollProvider.payslips.length.toString(),
          Icons.receipt), // Card for payslips.
    ];

    // Build summary cards based on screen size.
    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxWidth: 1200), // Maximum width for the cards.
      child: isSmallScreen
          ? Column(
              children: cardList
                  .map((card) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: 16), // Space between cards.
                        child: SizedBox(
                          width: double.infinity, // Full width for each card.
                          child: card,
                        ),
                      ))
                  .toList())
          : Row(
              children: cardList
                  .map((card) => Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: card)))
                  .toList()),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Builder(builder: (context) {
      final isDarkMode = Theme.of(context).brightness ==
          Brightness.dark; // Check if dark mode is enabled.
      return Container(
        padding: const EdgeInsets.all(16), // Padding inside the card.
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[800]
              : Colors.white, // Background color based on theme.
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for the card.
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Shadow color.
              blurRadius: 5, // Blur radius for the shadow.
              offset: const Offset(0, 2), // Offset for the shadow.
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align children to start.
          mainAxisSize: MainAxisSize.min, // Minimum size for the card.
          children: [
            Icon(icon, size: 28, color: Colors.blue), // Icon inside the card.
            const SizedBox(height: 16), // Space between icon and text.
            Text(value,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)), // Value text.
            const SizedBox(height: 4), // Space between value and title.
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? Colors.grey[400]
                        : Colors.grey[600])), // Title text.
          ],
        ),
      );
    });
  }

  Widget _buildRecentActivityTable(
      BuildContext context,
      AttendanceProvider attendanceProvider,
      EmployeeProvider employeeProvider) {
    // Sort and limit the recent attendance records.
    final List<Attendance> recentAttendance = attendanceProvider
        .attendanceRecords
      ..sort((a, b) =>
          b.date.compareTo(a.date)); // Sort by date in descending order.
    final int activityCount = recentAttendance.length > 3
        ? 3
        : recentAttendance.length; // Limit to 3 recent activities.

    final isDarkMode = Theme.of(context).brightness ==
        Brightness.dark; // Check if dark mode is enabled.

    return Container(
      padding: const EdgeInsets.all(16), // Padding inside the container.
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]
            : Colors.white, // Background color based on theme.
        borderRadius:
            BorderRadius.circular(12), // Rounded corners for the container.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // Shadow color.
            blurRadius: 5, // Blur radius for the shadow.
            offset: const Offset(0, 2), // Offset for the shadow.
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align children to start.
        children: [
          const Text('Recent Activity',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold)), // Title for the activity table.
          const SizedBox(height: 16), // Space between title and table.
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2), // Width for the Date column.
              1: FlexColumnWidth(3), // Width for the Activity column.
              2: FlexColumnWidth(2), // Width for the Employee column.
            },
            children: [
              TableRow(
                children: ['Date', 'Activity', 'Employee']
                    .map((header) => TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical:
                                    8.0), // Padding inside the header cells.
                            child: Text(header,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600])), // Header text.
                          ),
                        ))
                    .toList(),
              ),
              ...List.generate(activityCount, (index) {
                final attendance = recentAttendance[index];
                final employee = employeeProvider.getEmployee(
                    attendance.employeeId); // Get employee details.
                return TableRow(
                  children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Padding inside the cells.
                      child: Text(DateFormat('yyyy-MM-dd')
                          .format(attendance.date)), // Format and display date.
                    )),
                    const TableCell(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 8.0), // Padding inside the cells.
                      child: Text(
                          'Attendance Recorded'), // Static text for activity.
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0), // Padding inside the cells.
                      child: Text(employee.name), // Display employee name.
                    )),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
