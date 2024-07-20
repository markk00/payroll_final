import 'package:flutter/foundation.dart';

class Employee {
  final String id;
  final String name;
  final String jobRole;
  final String email;
  final String gender;
  final DateTime dateOfBirth;
  final String mobileNumber;
  final double baseSalary;

  Employee({
    required this.id,
    required this.name,
    required this.jobRole,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
    required this.mobileNumber,
    required this.baseSalary,
  });
}

class EmployeeProvider with ChangeNotifier {
  final List<Employee> _employees = [];

  List<Employee> get employees => _employees;

  void addEmployee(Employee employee) {
    _employees.add(employee);
    notifyListeners();
  }

  Employee getEmployee(String id) {
    return _employees.firstWhere((employee) => employee.id == id);
  }
}
