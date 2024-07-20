import 'package:flutter/foundation.dart';

// Class representing an employee's details.
class Employee {
  final String id; // Unique identifier for the employee.
  final String name; // Name of the employee.
  final String jobRole; // Job role or title of the employee.
  final String email; // Email address of the employee.
  final String gender; // Gender of the employee.
  final DateTime dateOfBirth; // Date of birth of the employee.
  final String mobileNumber; // Mobile number of the employee.
  final double baseSalary; // Base salary of the employee.

  // Constructor to initialize all fields of the Employee class.
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

// Provider class for managing employee data.
class EmployeeProvider with ChangeNotifier {
  final List<Employee> _employees = []; // List to hold all employees.

  // Getter for the list of employees.
  List<Employee> get employees => _employees;

  // Method to add a new employee to the list.
  void addEmployee(Employee employee) {
    _employees.add(employee); // Add the employee to the list.
    notifyListeners(); // Notify listeners about the change.
  }

  // Method to get a specific employee by their ID.
  Employee getEmployee(String id) {
    return _employees.firstWhere((employee) =>
        employee.id == id); // Find and return the employee with the given ID.
  }
}
