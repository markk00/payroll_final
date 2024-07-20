import 'package:flutter/foundation.dart';

class Attendance {
  final String employeeId;
  final DateTime date;
  final double hoursWorked;

  Attendance({
    required this.employeeId,
    required this.date,
    required this.hoursWorked,
  });
}

class AttendanceProvider with ChangeNotifier {
  final List<Attendance> _attendanceRecords = [];

  List<Attendance> get attendanceRecords => _attendanceRecords;

  void addAttendance(Attendance attendance) {
    _attendanceRecords.add(attendance);
    notifyListeners();
  }

  List<Attendance> getEmployeeAttendance(String employeeId) {
    return _attendanceRecords
        .where((attendance) => attendance.employeeId == employeeId)
        .toList();
  }
}
