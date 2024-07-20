import 'package:flutter/material.dart'; // Import Flutter material design package.
import 'package:provider/provider.dart'; // Import Provider package for state management.
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package for custom fonts.
import 'models/employee_provider.dart'; // Import the EmployeeProvider model.
import 'models/attendance_provider.dart'; // Import the AttendanceProvider model.
import 'models/payroll_provider.dart'; // Import the PayrollProvider model.
import 'screens/desktop_scaffold.dart'; // Import the desktop scaffold screen.
import 'screens/mobile_scaffold.dart'; // Import the mobile scaffold screen.
import 'screens/login_screen.dart'; // Import the login screen.

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                EmployeeProvider()), // Register EmployeeProvider for state management.
        ChangeNotifierProvider(
            create: (_) =>
                AttendanceProvider()), // Register AttendanceProvider for state management.
        ChangeNotifierProvider(
            create: (_) =>
                PayrollProvider()), // Register PayrollProvider for state management.
        ChangeNotifierProvider(
            create: (_) =>
                ThemeProvider()), // Register ThemeProvider for theme state management.
      ],
      child:
          const PolicePayrollApp(), // Set the root widget of the app to PolicePayrollApp.
    ),
  );
} //

class PolicePayrollApp extends StatelessWidget {
  const PolicePayrollApp(
      {super.key}); // Constructor for PolicePayrollApp widget.

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(
        context); // Access the ThemeProvider from the widget tree.
    return MaterialApp(
      title:
          'Police Hotline Movement Incorporated', // Set the title of the app.
      themeMode:
          themeProvider.themeMode, // Set the theme mode based on ThemeProvider.
      theme: _buildLightTheme(
          context), // Set the light theme using _buildLightTheme method.
      darkTheme: _buildDarkTheme(
          context), // Set the dark theme using _buildDarkTheme method.
      initialRoute: '/', // Set the initial route to the login screen.
      routes: {
        '/': (context) =>
            LoginScreen(), // Define the route for the login screen.
        '/home': (context) => const ResponsiveLayout(
              mobileBody:
                  MobileScaffold(), // Define the route for the home screen with mobile layout.
              desktopBody:
                  DesktopScaffold(), // Define the route for the home screen with desktop layout.
            ),
      },
    );
  }

  ThemeData _buildLightTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue, // Set the primary color swatch to blue.
      brightness: Brightness.light, // Set the brightness to light.
      textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context)
          .textTheme), // Set the text theme using Google Fonts.
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                8)), // Set the default border for input fields.
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: Colors.blue,
              width: 2), // Set the border when input field is focused.
        ),
        filled: true, // Enable filling of input fields.
        fillColor: Colors.grey[200], // Set the fill color for input fields.
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.blue, // Set the background color for elevated buttons.
          foregroundColor:
              Colors.white, // Set the text color for elevated buttons.
          padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12), // Set the padding for elevated buttons.
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8)), // Set the shape of elevated buttons.
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme(BuildContext context) {
    return ThemeData(
      primarySwatch: Colors.blue, // Set the primary color swatch to blue.
      brightness: Brightness.dark, // Set the brightness to dark.
      textTheme: GoogleFonts.dmSansTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: Colors.white,
        displayColor: Colors.white, // Set the text color to white in dark mode.
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                8)), // Set the default border for input fields.
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
              color: Colors.blue,
              width: 2), // Set the border when input field is focused.
        ),
        filled: true, // Enable filling of input fields.
        fillColor: Colors.grey[800], // Set the fill color for input fields.
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.blue, // Set the background color for elevated buttons.
          foregroundColor:
              Colors.white, // Set the text color for elevated buttons.
          padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12), // Set the padding for elevated buttons.
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  8)), // Set the shape of elevated buttons.
        ),
      ),
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode =
      ThemeMode.light; // Set the initial theme mode to light.

  ThemeMode get themeMode => _themeMode; // Getter for the current theme mode.

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light; // Toggle between light and dark mode.
    notifyListeners(); // Notify listeners about the change in theme mode.
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody; // Widget to display for mobile layout.
  final Widget desktopBody; // Widget to display for desktop layout.

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return mobileBody; // Return mobile layout if width is less than 600.
        } else {
          return desktopBody; // Return desktop layout if width is 600 or more.
        }
      },
    );
  }
}
