import 'package:flutter/material.dart'; // Import Flutter material design package.
import 'package:provider/provider.dart'; // Import Provider package for state management.
import 'package:intl/intl.dart'; // Import Intl package for date formatting.
import '../models/employee_provider.dart'; // Import EmployeeProvider model.
import '../models/attendance_provider.dart'; // Import AttendanceProvider model.
import '../models/payroll_provider.dart'; // Import PayrollProvider model.

class PayslipScreen extends StatefulWidget {
  const PayslipScreen({super.key}); // Constructor for PayslipScreen widget.

  @override
  _PayslipScreenState createState() =>
      _PayslipScreenState(); // Create state for PayslipScreen.
}

class _PayslipScreenState extends State<PayslipScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form.
  String? _selectedEmployeeId; // Selected employee ID.
  DateTime _payPeriodStart = DateTime.now()
      .subtract(const Duration(days: 30)); // Start date of the pay period.
  DateTime _payPeriodEnd = DateTime.now(); // End date of the pay period.

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<EmployeeProvider>(context); // Access EmployeeProvider.
    final attendanceProvider =
        Provider.of<AttendanceProvider>(context); // Access AttendanceProvider.
    final payrollProvider =
        Provider.of<PayrollProvider>(context); // Access PayrollProvider.

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Padding around the content.
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
                const SizedBox(height: 24), // Spacing between elements.
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(24), // Padding inside the card.
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildEmployeeDropdown(
                              employeeProvider), // Employee dropdown widget.
                          const SizedBox(
                              height: 16), // Spacing between elements.
                          _buildDateRangePicker(
                              context), // Date range picker widget.
                          const SizedBox(
                              height: 24), // Spacing between elements.
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _generatePayslip(
                                  employeeProvider,
                                  attendanceProvider,
                                  payrollProvider), // Generate payslip on button press.
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Generate Payslip',
                                  style:
                                      TextStyle(fontSize: 16)), // Button text.
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32), // Spacing between elements.
                Text(
                  'Pay Slips',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                ),
                const SizedBox(height: 16), // Spacing between elements.
                _buildPayslipList(
                    payrollProvider, employeeProvider), // Payslip list widget.
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
        prefixIcon: const Icon(Icons.person,
            color: Colors.grey), // Icon for the dropdown.
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
          child: Text(employee.name), // Dropdown menu item text.
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedEmployeeId = value; // Update selected employee ID.
        });
      },
      validator: (value) => value == null
          ? 'Please select an employee'
          : null, // Validation for the dropdown.
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
            _payPeriodStart = picked.start; // Update start date.
            _payPeriodEnd = picked.end; // Update end date.
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Pay Period',
          prefixIcon: const Icon(Icons.date_range,
              color: Colors.grey), // Icon for the date range picker.
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
          '${DateFormat('yyyy-MM-dd').format(_payPeriodStart)} to ${DateFormat('yyyy-MM-dd').format(_payPeriodEnd)}', // Display selected date range.
        ),
      ),
    );
  }

  Widget _buildPayslipList(
      PayrollProvider payrollProvider, EmployeeProvider employeeProvider) {
    return ListView.builder(
      shrinkWrap: true, // Prevents ListView from expanding infinitely.
      physics:
          const NeverScrollableScrollPhysics(), // Disables scrolling for ListView.
      itemCount: payrollProvider.payslips.length, // Number of payslips.
      itemBuilder: (context, index) {
        final payslip =
            payrollProvider.payslips[index]; // Get payslip at index.
        final employee = employeeProvider
            .getEmployee(payslip.employeeId); // Get employee details.
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(
              vertical: 8), // Margin around the card.
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                  employee.name[0]), // Display first letter of employee name.
            ),
            title: Text(employee.name), // Employee name.
            subtitle: Text(
                '${DateFormat('yyyy-MM-dd').format(payslip.payPeriodStart)} to ${DateFormat('yyyy-MM-dd').format(payslip.payPeriodEnd)}'), // Pay period.
            trailing:
                Text('\$${payslip.totalPay.toStringAsFixed(2)}'), // Total pay.
            onTap: () => _showPayslipDetails(
                context, payslip, employee), // Show payslip details on tap.
          ),
        );
      },
    );
  }

  void _generatePayslip(EmployeeProvider employeeProvider,
      AttendanceProvider attendanceProvider, PayrollProvider payrollProvider) {
    if (_formKey.currentState!.validate()) {
      // Validate form.
      final employee = employeeProvider
          .getEmployee(_selectedEmployeeId!); // Get selected employee.
      final attendanceRecords = attendanceProvider
          .getEmployeeAttendance(_selectedEmployeeId!)
          .where((a) =>
              a.date.isAfter(_payPeriodStart) && a.date.isBefore(_payPeriodEnd))
          .toList(); // Get attendance records within the pay period.

      double totalHoursWorked = attendanceRecords.fold(
          0, (sum, a) => sum + a.hoursWorked); // Calculate total hours worked.
      double overtimeHours = totalHoursWorked > 160
          ? totalHoursWorked - 160
          : 0; // Calculate overtime hours.
      double overtimePay = overtimeHours *
          (employee.baseSalary / 160) *
          1.5; // Calculate overtime pay.
      double deductions =
          employee.baseSalary * 0.1; // Assuming 10% deductions for taxes, etc.
      double incentives =
          totalHoursWorked > 180 ? 100 : 0; // Example incentive.

      Payslip payslip = Payslip(
        employeeId: employee.id,
        payPeriodStart: _payPeriodStart,
        payPeriodEnd: _payPeriodEnd,
        baseSalary: employee.baseSalary,
        overtimePay: overtimePay,
        deductions: deductions,
        incentives: incentives,
        totalPay: employee.baseSalary +
            overtimePay -
            deductions +
            incentives, // Calculate total pay.
      );

      payrollProvider.generatePayslip(payslip); // Generate payslip.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Payslip generated successfully')), // Show success message.
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
                color: Colors.blue[800],
                fontWeight: FontWeight.bold)), // Dialog title.
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPayslipDetailItem(
                  'Employee', employee.name), // Employee name.
              _buildPayslipDetailItem('Period',
                  '${DateFormat('yyyy-MM-dd').format(payslip.payPeriodStart)} to ${DateFormat('yyyy-MM-dd').format(payslip.payPeriodEnd)}'), // Pay period.
              const Divider(),
              _buildPayslipDetailItem('Base Salary',
                  '₱${payslip.baseSalary.toStringAsFixed(2)}'), // Base salary.
              _buildPayslipDetailItem('Overtime Pay',
                  '₱${payslip.overtimePay.toStringAsFixed(2)}'), // Overtime pay.
              _buildPayslipDetailItem('Deductions',
                  '₱${payslip.deductions.toStringAsFixed(2)}'), // Deductions.
              _buildPayslipDetailItem('Incentives',
                  '₱${payslip.incentives.toStringAsFixed(2)}'), // Incentives.
              const Divider(),
              _buildPayslipDetailItem(
                  'Total Pay', '₱${payslip.totalPay.toStringAsFixed(2)}',
                  isTotal: true), // Total pay.
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'), // Close button.
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipDetailItem(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 4), // Padding around the item.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal
                      ? FontWeight.bold
                      : FontWeight.normal)), // Label text.
          Text(value,
              style: TextStyle(
                  fontWeight: isTotal
                      ? FontWeight.bold
                      : FontWeight.normal)), // Value text.
        ],
      ),
    );
  }
}
