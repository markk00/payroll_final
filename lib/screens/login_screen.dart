import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController =
      TextEditingController(); // Controller for the email input field.
  final TextEditingController passwordController =
      TextEditingController(); // Controller for the password input field.

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 600) {
            return _buildDesktopLayout(
                context); // Use desktop layout for larger screens.
          } else {
            return _buildMobileLayout(
                context); // Use mobile layout for smaller screens.
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left side with the graphics and branding.
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.blue[800],
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.local_police,
                  size: 64,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'Police Hotline Movement Incorporated',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
        // Right side with the login form.
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildForm(context), // Call to the form widget.
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.local_police,
              size: 48,
              color: Colors.blue[800],
            ),
            const SizedBox(height: 16),
            Text(
              'Police Hotline Movement Incorporated',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Log In',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            const SizedBox(height: 24),
            _buildForm(context), // Call to the form widget.
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller:
              emailController, // Attach the controller to the email input field.
          decoration: InputDecoration(
            labelText: 'Email',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200], // Background color of the input field.
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller:
              passwordController, // Attach the controller to the password input field.
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200], // Background color of the input field.
          ),
          obscureText: true, // Hide the text being typed (for passwords).
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            final String email = emailController.text.trim();
            final String password = passwordController.text.trim();
            if (email == 'juandelacruz@phmi.com' &&
                password == 'juandelacruz') {
              // Successful login, navigate to the main app.
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // Handle invalid credentials.
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Login Failed'),
                  content: const Text('Invalid email or password.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Colors.blue[800], // Background color of the button.
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Login'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
