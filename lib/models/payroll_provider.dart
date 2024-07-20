import 'package:flutter/foundation.dart';

// Class representing a payslip for an employee.
class Payslip {
  final String employeeId; // ID of the employee.
  final DateTime payPeriodStart; // Start date of the pay period.
  final DateTime payPeriodEnd; // End date of the pay period.
  final double baseSalary; // Base salary for the pay period.
  final double overtimePay; // Overtime pay for the pay period.
  final double deductions; // Deductions from the salary.
  final double incentives; // Incentives or bonuses.
  final double totalPay; // Total pay after calculations.

  // Constructor to initialize all fields of the Payslip.
  Payslip({
    required this.employeeId,
    required this.payPeriodStart,
    required this.payPeriodEnd,
    required this.baseSalary,
    required this.overtimePay,
    required this.deductions,
    required this.incentives,
    required this.totalPay,
  });
}

// Provider class for managing payslips.
class PayrollProvider with ChangeNotifier {
  final List<Payslip> _payslips = []; // List to hold all payslips.

  // Getter for the list of payslips.
  List<Payslip> get payslips => _payslips;

  // Method to generate and add a new payslip.
  void generatePayslip(Payslip payslip) {
    _payslips.add(payslip); // Add the payslip to the list.
    notifyListeners(); // Notify listeners about the change.
  }

  // Method to get all payslips for a specific employee.
  List<Payslip> getEmployeePayslips(String employeeId) {
    return _payslips
        .where((payslip) =>
            payslip.employeeId == employeeId) // Filter payslips by employee ID.
        .toList(); // Convert the result to a list.
  }
}
