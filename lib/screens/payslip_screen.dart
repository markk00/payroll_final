import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/employee_provider.dart';
import '../models/attendance_provider.dart';
import '../models/payroll_provider.dart';

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key});

  @override
  _PayslipScreenState createState() => _PayslipScreenState();
}

class _PayslipScreenState extends State<PayslipScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployeeId;
  DateTime _payPeriodStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime _payPeriodEnd = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);
    final payrollProvider = Provider.of<PayrollProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generate Pay Slip',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildEmployeeDropdown(employeeProvider),
                          const SizedBox(height: 16),
                          _buildDateRangePicker(context),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _generatePayslip(
                                  employeeProvider,
                                  attendanceProvider,
                                  payrollProvider),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Generate Payslip',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Pay Slips',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                ),
                const SizedBox(height: 16),
                _buildPayslipList(payrollProvider, employeeProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeDropdown(EmployeeProvider employeeProvider) {
    return DropdownButtonFormField<String>(
      value: _selectedEmployeeId,
      decoration: InputDecoration(
        labelText: 'Select Employee',
        prefixIcon: const Icon(Icons.person, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      items: employeeProvider.employees.map((employee) {
        return DropdownMenuItem<String>(
          value: employee.id,
          child: Text(employee.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedEmployeeId = value;
        });
      },
      validator: (value) => value == null ? 'Please select an employee' : null,
    );
  }

  Widget _buildDateRangePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDateRange:
              DateTimeRange(start: _payPeriodStart, end: _payPeriodEnd),
        );
        if (picked != null) {
          setState(() {
            _payPeriodStart = picked.start;
            _payPeriodEnd = picked.end;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Pay Period',
          prefixIcon: const Icon(Icons.date_range, color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        child: Text(
          '${DateFormat('yyyy-MM-dd').format(_payPeriodStart)} to ${DateFormat('yyyy-MM-dd').format(_payPeriodEnd)}',
        ),
      ),
    );
  }

  Widget _buildPayslipList(
      PayrollProvider payrollProvider, EmployeeProvider employeeProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: payrollProvider.payslips.length,
      itemBuilder: (context, index) {
        final payslip = payrollProvider.payslips[index];
        final employee = employeeProvider.getEmployee(payslip.employeeId);
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(employee.name[0]),
            ),
            title: Text(employee.name),
            subtitle: Text(
                '${DateFormat('yyyy-MM-dd').format(payslip.payPeriodStart)} to ${DateFormat('yyyy-MM-dd').format(payslip.payPeriodEnd)}'),
            trailing: Text('\$${payslip.totalPay.toStringAsFixed(2)}'),
            onTap: () => _showPayslipDetails(context, payslip, employee),
          ),
        );
      },
    );
  }

  void _generatePayslip(EmployeeProvider employeeProvider,
      AttendanceProvider attendanceProvider, PayrollProvider payrollProvider) {
    if (_formKey.currentState!.validate()) {
      final employee = employeeProvider.getEmployee(_selectedEmployeeId!);
      final attendanceRecords = attendanceProvider
          .getEmployeeAttendance(_selectedEmployeeId!)
          .where((a) =>
              a.date.isAfter(_payPeriodStart) && a.date.isBefore(_payPeriodEnd))
          .toList();

      double totalHoursWorked =
          attendanceRecords.fold(0, (sum, a) => sum + a.hoursWorked);
      double overtimeHours =
          totalHoursWorked > 160 ? totalHoursWorked - 160 : 0;
      double overtimePay = overtimeHours * (employee.baseSalary / 160) * 1.5;
      double deductions =
          employee.baseSalary * 0.1; // Assuming 10% deductions for taxes, etc.
      double incentives = totalHoursWorked > 180 ? 100 : 0; // Example incentive

      Payslip payslip = Payslip(
        employeeId: employee.id,
        payPeriodStart: _payPeriodStart,
        payPeriodEnd: _payPeriodEnd,
        baseSalary: employee.baseSalary,
        overtimePay: overtimePay,
        deductions: deductions,
        incentives: incentives,
        totalPay: employee.baseSalary + overtimePay - deductions + incentives,
      );

      payrollProvider.generatePayslip(payslip);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payslip generated successfully')),
      );
    }
  }

  void _showPayslipDetails(
      BuildContext context, Payslip payslip, Employee employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payslip Details',
            style: TextStyle(
                color: Colors.blue[800], fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPayslipDetailItem('Employee', employee.name),
              _buildPayslipDetailItem('Period',
                  '${DateFormat('yyyy-MM-dd').format(payslip.payPeriodStart)} to ${DateFormat('yyyy-MM-dd').format(payslip.payPeriodEnd)}'),
              const Divider(),
              _buildPayslipDetailItem(
                  'Base Salary', '₱${payslip.baseSalary.toStringAsFixed(2)}'),
              _buildPayslipDetailItem(
                  'Overtime Pay', '₱${payslip.overtimePay.toStringAsFixed(2)}'),
              _buildPayslipDetailItem(
                  'Deductions', '₱${payslip.deductions.toStringAsFixed(2)}'),
              _buildPayslipDetailItem(
                  'Incentives', '₱${payslip.incentives.toStringAsFixed(2)}'),
              const Divider(),
              _buildPayslipDetailItem(
                  'Total Pay', '₱${payslip.totalPay.toStringAsFixed(2)}',
                  isTotal: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipDetailItem(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
