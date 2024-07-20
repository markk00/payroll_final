import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/employee_provider.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key}); // Constructor with key.

  @override
  _EmployeeScreenState createState() =>
      _EmployeeScreenState(); // Create the state for the screen.
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final _formKey =
      GlobalKey<FormState>(); // Key for the form to manage its state.
  final TextEditingController _nameController =
      TextEditingController(); // Controller for name input.
  final TextEditingController _jobRoleController =
      TextEditingController(); // Controller for job role input.
  final TextEditingController _emailController =
      TextEditingController(); // Controller for email input.
  String? _gender; // Variable to store selected gender.
  DateTime? _dateOfBirth; // Variable to store selected date of birth.
  final TextEditingController _mobileNumberController =
      TextEditingController(); // Controller for mobile number input.
  final TextEditingController _baseSalaryController =
      TextEditingController(); // Controller for base salary input.

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(
        context); // Access the EmployeeProvider from the context.

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0), // Padding around the content.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, // Align children to the start of the column.
              children: [
                Text(
                  'Add New Employee', // Title for the screen.
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold, // Bold text.
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white // White text in dark mode.
                            : Colors.black87, // Dark text in light mode.
                      ),
                ),
                const SizedBox(height: 24), // Space between widgets.
                Card(
                  elevation: 0, // No elevation for the card.
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
                      key: _formKey, // Attach form key for validation.
                      child: Column(
                        children: [
                          _buildTextField(_nameController, 'Name',
                              Icons.person), // Build name text field.
                          const SizedBox(height: 16), // Space between fields.
                          _buildTextField(_jobRoleController, 'Job Role',
                              Icons.work), // Build job role text field.
                          const SizedBox(height: 16), // Space between fields.
                          _buildTextField(_emailController, 'Email',
                              Icons.email), // Build email text field.
                          const SizedBox(height: 16), // Space between fields.
                          _buildGenderDropdown(), // Build gender dropdown.
                          const SizedBox(height: 16), // Space between fields.
                          _buildDatePicker(context), // Build date picker.
                          const SizedBox(height: 16), // Space between fields.
                          _buildTextField(
                              _mobileNumberController,
                              'Mobile Number',
                              Icons.phone), // Build mobile number text field.
                          const SizedBox(height: 16), // Space between fields.
                          _buildTextField(_baseSalaryController, 'Base Salary',
                              Icons.attach_money,
                              isNumber:
                                  true), // Build base salary text field with number keyboard.
                          const SizedBox(
                              height: 24), // Space before the button.
                          SizedBox(
                            width: double.infinity, // Button takes full width.
                            child: ElevatedButton(
                              onPressed: () => _addEmployee(employeeProvider,
                                  context), // Add employee when button is pressed.
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Button color.
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16), // Padding inside the button.
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners for the button.
                                ),
                              ),
                              child: const Text('Add Employee',
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
                    height: 32), // Space before the employee list section.
                Text(
                  'Employee List', // Title for the employee list section.
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold, // Bold text.
                        color: Colors.blue[800], // Text color.
                      ),
                ),
                const SizedBox(height: 16), // Space between title and list.
                _buildEmployeeList(
                    employeeProvider), // Build the employee list.
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds a text field with optional number keyboard type.
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return TextFormField(
      controller: controller, // Controller for the text field.
      decoration: InputDecoration(
        labelText: label, // Label for the text field.
        prefixIcon:
            Icon(icon, color: Colors.grey), // Icon inside the text field.
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8), // Rounded corners for the border.
          borderSide: BorderSide(color: Colors.grey.shade300), // Border color.
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              8), // Rounded corners for the enabled border.
          borderSide: BorderSide(color: Colors.grey.shade300), // Border color.
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              8), // Rounded corners for the focused border.
          borderSide: const BorderSide(
              color: Colors.blue), // Border color when focused.
        ),
      ),
      keyboardType: isNumber
          ? TextInputType.number
          : TextInputType.text, // Keyboard type based on isNumber flag.
      validator: (value) => value!.isEmpty
          ? 'Please enter $label'
          : null, // Validation for empty value.
    );
  }

  // Builds a dropdown for gender selection.
  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _gender, // Current selected value.
      decoration: InputDecoration(
        labelText: 'Gender', // Label for the dropdown.
        prefixIcon: const Icon(Icons.people,
            color: Colors.grey), // Icon inside the dropdown.
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(8), // Rounded corners for the border.
          borderSide: BorderSide(color: Colors.grey.shade300), // Border color.
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              8), // Rounded corners for the enabled border.
          borderSide: BorderSide(color: Colors.grey.shade300), // Border color.
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
              8), // Rounded corners for the focused border.
          borderSide: const BorderSide(
              color: Colors.blue), // Border color when focused.
        ),
      ),
      items: ['Male', 'Female', 'Other'].map((String value) {
        return DropdownMenuItem<String>(
            value: value, child: Text(value)); // Dropdown items.
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          _gender = newValue; // Update the selected gender.
        });
      },
      validator: (value) => value == null
          ? 'Please select a gender'
          : null, // Validation for gender selection.
    );
  }

  // Builds a date picker for selecting the date of birth.
  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(), // Default date.
          firstDate: DateTime(1900), // Earliest selectable date.
          lastDate: DateTime.now(), // Latest selectable date.
        );
        if (picked != null) {
          setState(() {
            _dateOfBirth = picked; // Update the selected date of birth.
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth', // Label for the date picker.
          prefixIcon: const Icon(Icons.calendar_today,
              color: Colors.grey), // Icon inside the date picker.
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(8), // Rounded corners for the border.
            borderSide:
                BorderSide(color: Colors.grey.shade300), // Border color.
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                8), // Rounded corners for the enabled border.
            borderSide:
                BorderSide(color: Colors.grey.shade300), // Border color.
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                8), // Rounded corners for the focused border.
            borderSide: const BorderSide(
                color: Colors.blue), // Border color when focused.
          ),
        ),
        child: Text(
          _dateOfBirth == null
              ? 'Select Date' // Default text when no date is selected.
              : DateFormat('yyyy-MM-dd')
                  .format(_dateOfBirth!), // Display selected date.
        ),
      ),
    );
  }

  // Builds a list of employees.
  Widget _buildEmployeeList(EmployeeProvider employeeProvider) {
    return ListView.builder(
      shrinkWrap:
          true, // Make the list view take only as much vertical space as needed.
      physics:
          const NeverScrollableScrollPhysics(), // Disable scrolling in the list view.
      itemCount:
          employeeProvider.employees.length, // Number of items in the list.
      itemBuilder: (context, index) {
        final employee =
            employeeProvider.employees[index]; // Get employee data.
        return Card(
          elevation: 2, // Card elevation.
          margin: const EdgeInsets.symmetric(
              vertical: 8), // Margin around the card.
          child: ListTile(
            leading: CircleAvatar(
              child: Text(employee.name[0]), // Initial of the employee's name.
            ),
            title: Text(employee.name), // Employee name.
            subtitle: Text(employee.jobRole), // Employee job role.
            trailing: Text(
                '\$${employee.baseSalary.toStringAsFixed(2)}'), // Employee base salary.
            onTap: () {
              _showEmployeeDetails(
                  context, employee); // Show employee details on tap.
            },
          ),
        );
      },
    );
  }

  // Adds a new employee to the list.
  void _addEmployee(EmployeeProvider employeeProvider, BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Validate the form.
      employeeProvider.addEmployee(Employee(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(), // Generate unique ID.
        name: _nameController.text, // Get name from controller.
        jobRole: _jobRoleController.text, // Get job role from controller.
        email: _emailController.text, // Get email from controller.
        gender: _gender!, // Get gender.
        dateOfBirth: _dateOfBirth!, // Get date of birth.
        mobileNumber:
            _mobileNumberController.text, // Get mobile number from controller.
        baseSalary: double.parse(
            _baseSalaryController.text), // Get base salary from controller.
      ));
      _formKey.currentState!.reset(); // Reset the form.
      _gender = null; // Clear selected gender.
      _dateOfBirth = null; // Clear selected date of birth.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Employee added successfully')), // Show success message.
      );
    }
  }

  // Shows details of an employee in a dialog.
  void _showEmployeeDetails(BuildContext context, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(employee.name), // Title of the dialog.
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Job Role: ${employee.jobRole}'), // Display job role.
                Text('Email: ${employee.email}'), // Display email.
                Text('Gender: ${employee.gender}'), // Display gender.
                Text(
                    'Date of Birth: ${DateFormat('yyyy-MM-dd').format(employee.dateOfBirth)}'), // Display date of birth.
                Text(
                    'Mobile Number: ${employee.mobileNumber}'), // Display mobile number.
                Text(
                    'Base Salary: ₱${employee.baseSalary.toStringAsFixed(2)}'), // Display base salary.
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'), // Close button text.
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog.
              },
            ),
          ],
        );
      },
    );
  }
}
