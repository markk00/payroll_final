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
  final _formKey = GlobalKey<FormState>();
  String? _selectedEmployeeId;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _hoursWorkedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          _buildDatePicker(context),
                          const SizedBox(height: 16),
                          _buildHoursWorkedField(),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _recordAttendance(
                                  attendanceProvider, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Record Attendance',
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
                  'Attendance Records',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                ),
                const SizedBox(height: 16),
                _buildAttendanceList(attendanceProvider, employeeProvider),
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

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
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
        child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
      ),
    );
  }

  Widget _buildHoursWorkedField() {
    return TextFormField(
      controller: _hoursWorkedController,
      decoration: InputDecoration(
        labelText: 'Hours Worked',
        prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
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
      keyboardType: TextInputType.number,
      validator: (value) => value!.isEmpty ? 'Please enter hours worked' : null,
    );
  }

  Widget _buildAttendanceList(AttendanceProvider attendanceProvider,
      EmployeeProvider employeeProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: attendanceProvider.attendanceRecords.length,
      itemBuilder: (context, index) {
        final attendance = attendanceProvider.attendanceRecords[index];
        final employee = employeeProvider.getEmployee(attendance.employeeId);
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(employee.name[0]),
            ),
            title: Text(employee.name),
            subtitle: Text(DateFormat('yyyy-MM-dd').format(attendance.date)),
            trailing: Text('${attendance.hoursWorked} hours'),
          ),
        );
      },
    );
  }

  void _recordAttendance(
      AttendanceProvider attendanceProvider, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      attendanceProvider.addAttendance(Attendance(
        employeeId: _selectedEmployeeId!,
        date: _selectedDate,
        hoursWorked: double.parse(_hoursWorkedController.text),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance recorded successfully')),
      );
      _formKey.currentState!.reset();
      _hoursWorkedController.clear();
    }
  }
}
