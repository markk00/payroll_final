import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/employee_provider.dart';
import '../models/attendance_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _formKey = GlobalKey<FormState>(); // Key for the form.
  String? _selectedEmployeeId; // Selected employee ID.
  DateTime _selectedDate = DateTime.now(); // Default to current date.
  final TextEditingController _hoursWorkedController =
      TextEditingController(); // Controller for hours worked input.

  @override
  Widget build(BuildContext context) {
    final employeeProvider =
        Provider.of<EmployeeProvider>(context); // Get employee provider.
    final attendanceProvider =
        Provider.of<AttendanceProvider>(context); // Get attendance provider.

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Padding around the content.
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align children to start.
              children: [
                Text(
                  'Record Attendance',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black87,
                      ),
                ),
                const SizedBox(height: 24), // Space between title and form.
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for the card.
                    side: BorderSide(
                        color: Colors.grey.shade300), // Border color.
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(24), // Padding inside the card.
                    child: Form(
                      key: _formKey, // Form key for validation.
                      child: Column(
                        children: [
                          _buildEmployeeDropdown(
                              employeeProvider), // Employee dropdown.
                          const SizedBox(
                              height:
                                  16), // Space between dropdown and date picker.
                          _buildDatePicker(context), // Date picker.
                          const SizedBox(
                              height:
                                  16), // Space between date picker and hours field.
                          _buildHoursWorkedField(), // Hours worked input field.
                          const SizedBox(
                              height:
                                  24), // Space between hours field and button.
                          SizedBox(
                            width: double.infinity, // Button takes full width.
                            child: ElevatedButton(
                              onPressed: () => _recordAttendance(
                                  attendanceProvider,
                                  context), // Record attendance on press.
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Button color.
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16), // Button padding.
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners for the button.
                                ),
                              ),
                              child: const Text('Record Attendance',
                                  style:
                                      TextStyle(fontSize: 16)), // Button text.
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    height:
                        32), // Space between form and attendance records title.
                Text(
                  'Attendance Records',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800], // Color for the title.
                      ),
                ),
                const SizedBox(
                    height: 16), // Space between title and records list.
                _buildAttendanceList(attendanceProvider,
                    employeeProvider), // List of attendance records.
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeDropdown(EmployeeProvider employeeProvider) {
    return DropdownButtonFormField<String>(
      value: _selectedEmployeeId, // Current selected value.
      decoration: InputDecoration(
        labelText: 'Select Employee', // Label for the dropdown.
        prefixIcon: const Icon(Icons.person,
            color: Colors.grey), // Icon inside the dropdown.
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8), // Rounded corners for the border.
          borderSide: BorderSide(color: Colors.grey.shade300), // Border color.
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Colors.grey.shade300), // Enabled border color.
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Colors.blue), // Focused border color.
        ),
      ),
      items: employeeProvider.employees.map((employee) {
        return DropdownMenuItem<String>(
          value: employee.id, // Value for each dropdown item.
          child: Text(employee.name), // Display employee name.
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedEmployeeId = value; // Update selected employee ID.
        });
      },
      validator: (value) => value == null
          ? 'Please select an employee'
          : null, // Validation message.
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate, // Initial date for the picker.
          firstDate: DateTime(2000), // Earliest selectable date.
          lastDate: DateTime.now(), // Latest selectable date.
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked; // Update selected date.
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date', // Label for the date picker.
          prefixIcon: const Icon(Icons.calendar_today,
              color: Colors.grey), // Icon inside the date picker.
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8), // Rounded corners for the border.
            borderSide:
                BorderSide(color: Colors.grey.shade300), // Border color.
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: Colors.grey.shade300), // Enabled border color.
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Colors.blue), // Focused border color.
          ),
        ),
        child: Text(DateFormat('yyyy-MM-dd')
            .format(_selectedDate)), // Display selected date.
      ),
    );
  }

  Widget _buildHoursWorkedField() {
    return TextFormField(
      controller: _hoursWorkedController, // Controller for hours worked input.
      decoration: InputDecoration(
        labelText: 'Hours Worked', // Label for the input field.
        prefixIcon: const Icon(Icons.access_time,
            color: Colors.grey), // Icon inside the input field.
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8), // Rounded corners for the border.
          borderSide: BorderSide(color: Colors.grey.shade300), // Border color.
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: Colors.grey.shade300), // Enabled border color.
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              const BorderSide(color: Colors.blue), // Focused border color.
        ),
      ),
      keyboardType: TextInputType.number, // Numeric keyboard for hours input.
      validator: (value) => value!.isEmpty
          ? 'Please enter hours worked'
          : null, // Validation message.
    );
  }

  Widget _buildAttendanceList(AttendanceProvider attendanceProvider,
      EmployeeProvider employeeProvider) {
    return ListView.builder(
      shrinkWrap: true, // Allow the list to take only the required space.
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling for the list.
      itemCount: attendanceProvider
          .attendanceRecords.length, // Number of items in the list.
      itemBuilder: (context, index) {
        final attendance = attendanceProvider.attendanceRecords[index];
        final employee = employeeProvider
            .getEmployee(attendance.employeeId); // Get employee details.
        return Card(
          elevation: 2, // Card elevation.
          margin:
              const EdgeInsets.symmetric(vertical: 8), // Margin between cards.
          child: ListTile(
            leading: CircleAvatar(
              child: Text(
                  employee.name[0]), // Display first letter of employee name.
            ),
            title: Text(employee.name), // Display employee name.
            subtitle: Text(DateFormat('yyyy-MM-dd')
                .format(attendance.date)), // Display attendance date.
            trailing: Text(
                '${attendance.hoursWorked} hours'), // Display hours worked.
          ),
        );
      },
    );
  }

  void _recordAttendance(
      AttendanceProvider attendanceProvider, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Validate the form.
      attendanceProvider.addAttendance(Attendance(
        employeeId: _selectedEmployeeId!,
        date: _selectedDate,
        hoursWorked: double.parse(_hoursWorkedController.text),
      )); // Add attendance record.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Attendance recorded successfully')), // Show success message.
      );
      _formKey.currentState!.reset(); // Reset the form.
      _hoursWorkedController.clear(); // Clear hours worked input.
    }
  }
}
