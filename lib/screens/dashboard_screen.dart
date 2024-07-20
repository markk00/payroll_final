import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/employee_provider.dart';
import '../models/attendance_provider.dart';
import '../models/payroll_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final payrollProvider = Provider.of<PayrollProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(fontWeight: FontWeight.w600)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCards(employeeProvider, attendanceProvider,
                      payrollProvider, constraints),
                  const SizedBox(height: 24),
                  _buildRecentActivityTable(
                      context, attendanceProvider, employeeProvider),
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
    final isSmallScreen = constraints.maxWidth <= 600;
    final cardList = [
      _buildSummaryCard('Employees',
          employeeProvider.employees.length.toString(), Icons.people),
      _buildSummaryCard('Attendance',
          attendanceProvider.attendanceRecords.length.toString(), Icons.timer),
      _buildSummaryCard('Payslips', payrollProvider.payslips.length.toString(),
          Icons.receipt),
    ];

    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxWidth: 1200), // Adjust this value as needed
      child: isSmallScreen
          ? Column(
              children: cardList
                  .map((card) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SizedBox(
                          width: double.infinity,
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
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.blue),
            const SizedBox(height: 16),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title,
                style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
          ],
        ),
      );
    });
  }

  Widget _buildRecentActivityTable(
      BuildContext context,
      AttendanceProvider attendanceProvider,
      EmployeeProvider employeeProvider) {
    final List<Attendance> recentAttendance = attendanceProvider
        .attendanceRecords
      ..sort((a, b) => b.date.compareTo(a.date));
    final int activityCount =
        recentAttendance.length > 3 ? 3 : recentAttendance.length;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recent Activity',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(3),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                children: ['Date', 'Activity', 'Employee']
                    .map((header) => TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(header,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600])),
                          ),
                        ))
                    .toList(),
              ),
              ...List.generate(activityCount, (index) {
                final attendance = recentAttendance[index];
                final employee =
                    employeeProvider.getEmployee(attendance.employeeId);
                return TableRow(
                  children: [
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                          DateFormat('yyyy-MM-dd').format(attendance.date)),
                    )),
                    const TableCell(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('Attendance Recorded'),
                    )),
                    TableCell(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(employee.name),
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
