import 'package:flutter/foundation.dart';

// Class representing an attendance record.
class Attendance {
  final String employeeId; // Unique identifier for the employee.
  final DateTime date; // Date of the attendance record.
  final double hoursWorked; // Number of hours worked on that date.

  // Constructor to initialize all fields of the Attendance class.
  Attendance({
    required this.employeeId,
    required this.date,
    required this.hoursWorked,
  });
}

// Provider class for managing attendance records.
class AttendanceProvider with ChangeNotifier {
  final List<Attendance> _attendanceRecords =
      []; // List to hold all attendance records.

  // Getter for the list of attendance records.
  List<Attendance> get attendanceRecords => _attendanceRecords;

  // Method to add a new attendance record to the list.
  void addAttendance(Attendance attendance) {
    _attendanceRecords
        .add(attendance); // Add the attendance record to the list.
    notifyListeners(); // Notify listeners about the change.
  }

  // Method to get all attendance records for a specific employee by their ID.
  List<Attendance> getEmployeeAttendance(String employeeId) {
    return _attendanceRecords
        .where((attendance) =>
            attendance.employeeId ==
            employeeId) // Filter records by employee ID.
        .toList(); // Convert the filtered records to a list.
  }
}
