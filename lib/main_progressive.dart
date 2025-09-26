import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ProgressiveTestApp());
}

class ProgressiveTestApp extends StatelessWidget {
  const ProgressiveTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver App - Progressive Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProgressiveTestPage(),
    );
  }
}

class ProgressiveTestPage extends StatefulWidget {
  const ProgressiveTestPage({super.key});

  @override
  State<ProgressiveTestPage> createState() => _ProgressiveTestPageState();
}

class _ProgressiveTestPageState extends State<ProgressiveTestPage> {
  int _currentStep = 0;
  final List<String> _steps = [
    'Basic App Structure',
    'Provider State Management',
    'Notification Service',
    'API Service',
    'Google Maps',
    'File Picker',
    'Full App'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progressive Test'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Step: ${_steps[_currentStep]}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            
            const SizedBox(height: 20),
            
            // Test results
            Expanded(
              child: ListView.builder(
                itemCount: _steps.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      index <= _currentStep ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: index <= _currentStep ? Colors.green : Colors.grey,
                    ),
                    title: Text(_steps[index]),
                    subtitle: Text(
                      index <= _currentStep ? 'Tested ✓' : 'Pending',
                      style: TextStyle(
                        color: index <= _currentStep ? Colors.green : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _currentStep > 0 ? () {
                    setState(() {
                      _currentStep--;
                    });
                  } : null,
                  child: const Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _currentStep < _steps.length - 1 ? () {
                    setState(() {
                      _currentStep++;
                    });
                  } : null,
                  child: const Text('Next'),
                ),
              ],
            ),
            
            const SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () {
                _testCurrentStep();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Test Current Step'),
            ),
          ],
        ),
      ),
    );
  }

  void _testCurrentStep() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Testing: ${_steps[_currentStep]}'),
        content: Text('This would test ${_steps[_currentStep].toLowerCase()} functionality.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

