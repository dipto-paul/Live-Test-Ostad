import 'package:flutter/material.dart';

void main() {
  runApp(const TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Converter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const ConverterScreen(),
    );
  }
}

enum ConversionType { celsiusToFahrenheit, fahrenheitToCelsius }

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  ConversionType _type = ConversionType.celsiusToFahrenheit;
  String _result = '--';

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {

      return 'Please enter a temperature value';
    }
    if (double.tryParse(value.trim()) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  void _calculate() {
    // Check whether the input is empty or invalid.
    if (!_formKey.currentState!.validate()) {
      setState(() => _result = '--');
      return;
    }

    final input = double.parse(_controller.text.trim());
    late final double output;
    late final String unit;

    if (_type == ConversionType.celsiusToFahrenheit) {
      output = (input * 9 / 5) + 32; // F = (C x 9/5) + 32
      unit = '°F';
    } else {
      output = (input - 32) * 5 / 9; // C = (F - 32) x 5/9
      unit = '°C';
    }

    setState(() => _result = '${output.toStringAsFixed(2)} $unit');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Temperature Converter')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Degree input
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Degree',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validate,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Conversion type dropdown
                    Expanded(
                      flex: 5,
                      child: DropdownButtonFormField<ConversionType>(
                        value: _type,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: ConversionType.celsiusToFahrenheit,
                            child: Text('Celsius to Fahrenheit (°C → °F)'),
                          ),
                          DropdownMenuItem(
                            value: ConversionType.fahrenheitToCelsius,
                            child: Text('Fahrenheit to Celsius (°F → °C)'),
                          ),
                        ],
                        selectedItemBuilder: (context) => const [
                          Text('°C → °F'),
                          Text('°F → °C'),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _type = value;
                              _result = '--';
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Result
                Text(
                  'Result',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                const SizedBox(height: 28),

                // Calculate button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _calculate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Convert',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
