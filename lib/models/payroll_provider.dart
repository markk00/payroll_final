import 'package:flutter/foundation.dart';

class Payslip {
  final String employeeId;
  final DateTime payPeriodStart;
  final DateTime payPeriodEnd;
  final double baseSalary;
  final double overtimePay;
  final double deductions;
  final double incentives;
  final double totalPay;

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

class PayrollProvider with ChangeNotifier {
  final List<Payslip> _payslips = [];

  List<Payslip> get payslips => _payslips;

  void generatePayslip(Payslip payslip) {
    _payslips.add(payslip);
    notifyListeners();
  }

  List<Payslip> getEmployeePayslips(String employeeId) {
    return _payslips
        .where((payslip) => payslip.employeeId == employeeId)
        .toList();
  }
}
