import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/employee_provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _jobRoleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _gender;
  DateTime? _dateOfBirth;
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _baseSalaryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add New Employee',
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
                          _buildTextField(
                              _nameController, 'Name', Icons.person),
                          const SizedBox(height: 16),
                          _buildTextField(
                              _jobRoleController, 'Job Role', Icons.work),
                          const SizedBox(height: 16),
                          _buildTextField(
                              _emailController, 'Email', Icons.email),
                          const SizedBox(height: 16),
                          _buildGenderDropdown(),
                          const SizedBox(height: 16),
                          _buildDatePicker(context),
                          const SizedBox(height: 16),
                          _buildTextField(_mobileNumberController,
                              'Mobile Number', Icons.phone),
                          const SizedBox(height: 16),
                          _buildTextField(_baseSalaryController, 'Base Salary',
                              Icons.attach_money,
                              isNumber: true),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () =>
                                  _addEmployee(employeeProvider, context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Add Employee',
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
                  'Employee List',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                ),
                const SizedBox(height: 16),
                _buildEmployeeList(employeeProvider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
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
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: (value) => value!.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender,
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: const Icon(Icons.people, color: Colors.grey),
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
      items: ['Male', 'Female', 'Other'].map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _gender = newValue;
        });
      },
      validator: (value) => value == null ? 'Please select a gender' : null,
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _dateOfBirth = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
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
        child: Text(
          _dateOfBirth == null
              ? 'Select Date'
              : DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
        ),
      ),
    );
  }

  Widget _buildEmployeeList(EmployeeProvider employeeProvider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employeeProvider.employees.length,
      itemBuilder: (context, index) {
        final employee = employeeProvider.employees[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(employee.name[0]),
            ),
            title: Text(employee.name),
            subtitle: Text(employee.jobRole),
            trailing: Text('\$${employee.baseSalary.toStringAsFixed(2)}'),
            onTap: () {
              _showEmployeeDetails(context, employee);
            },
          ),
        );
      },
    );
  }

  void _addEmployee(EmployeeProvider employeeProvider, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      employeeProvider.addEmployee(Employee(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        jobRole: _jobRoleController.text,
        email: _emailController.text,
        gender: _gender!,
        dateOfBirth: _dateOfBirth!,
        mobileNumber: _mobileNumberController.text,
        baseSalary: double.parse(_baseSalaryController.text),
      ));
      _formKey.currentState!.reset();
      _gender = null;
      _dateOfBirth = null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee added successfully')),
      );
    }
  }

  void _showEmployeeDetails(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(employee.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Job Role: ${employee.jobRole}'),
                Text('Email: ${employee.email}'),
                Text('Gender: ${employee.gender}'),
                Text(
                    'Date of Birth: ${DateFormat('yyyy-MM-dd').format(employee.dateOfBirth)}'),
                Text('Mobile Number: ${employee.mobileNumber}'),
                Text('Base Salary: ₱${employee.baseSalary.toStringAsFixed(2)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
