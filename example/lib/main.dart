import 'package:flutter/material.dart';
import 'package:flutter_aaos_car_property/flutter_aaos_car_property.dart';

void main() {
  runApp(const MyApp());
}

// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Car Night Mode & Cabin Lights Control'),
    );
  }
}

// Main page of the application
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isNightMode = false; // Tracks night mode status
  int _cabinLightState = 0; // Tracks cabin light status
  bool _initialized = false; // Tracks initialization status
  final FlutterAaosCarProperty _carProperty =
      FlutterAaosCarProperty(); // CarPropertyManager instance

  @override
  void initState() {
    super.initState();
    _initializeCarManager(); // Initialize CarPropertyManager when the widget is loaded
  }

  // Initializes the CarPropertyManager and retrieves initial night mode status
  Future<void> _initializeCarManager() async {
    await _carProperty.initializeCarManager();
    setState(() {
      _initialized = true; // Update UI after initialization
    });
    _getNightModeStatus(); // Retrieve night mode status after initialization
  }

  // Retrieves the current night mode status from the car property
  Future<void> _getNightModeStatus() async {
    final bool? value =
        await _carProperty.getCarProperty(0x11200407, 0) as bool?;
    if (value != null) {
      setState(() {
        debugPrint(
            value.toString()); // Output the night mode status for debugging
        _isNightMode = value; // Update UI with the night mode status
      });
    }
  }

  // Sets the cabin light state based on user selection
  Future<void> _setCabinLight(int state) async {
    await _carProperty.setCarProperty(0x11400f02, 0, state);
    setState(() {
      _cabinLightState = state; // Update UI with the new cabin light state
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isNightMode
          ? ThemeData.dark() // Apply dark theme if night mode is enabled
          : ThemeData.light(), // Apply light theme if night mode is disabled
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: _initialized
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Car Night Mode Status:'),
                    Text(
                      _isNightMode
                          ? "Night Mode ON"
                          : "Night Mode OFF", // Display current night mode status
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed:
                          _getNightModeStatus, // Button to refresh night mode status
                      child: const Text('Get Night Mode Status'),
                    ),
                    const SizedBox(height: 20),
                    const Text('Cabin Lights:'),
                    DropdownButton<int>(
                      value: _cabinLightState, // Current cabin light status
                      items: const [
                        DropdownMenuItem(
                          value: 0,
                          child: Text('OFF'),
                        ),
                        DropdownMenuItem(
                          value: 1,
                          child: Text('ON'),
                        ),
                        DropdownMenuItem(
                          value: 2,
                          child: Text('Daytime Running'),
                        ),
                        DropdownMenuItem(
                          value: 0x100,
                          child: Text('Automatic'),
                        ),
                      ],
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          _setCabinLight(
                              newValue); // Set new cabin light status
                        }
                      },
                    ),
                    Text(
                      _cabinLightState == 0
                          ? "Cabin Light OFF"
                          : _cabinLightState == 1
                              ? "Cabin Light ON"
                              : _cabinLightState == 2
                                  ? "Daytime Running"
                                  : "Automatic", // Display current cabin light status
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                )
              : const CircularProgressIndicator(), // Show loading indicator during initialization
        ),
      ),
    );
  }
}
