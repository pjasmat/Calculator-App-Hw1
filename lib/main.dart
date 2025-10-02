import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CalculatorApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CalculatorApp'), centerTitle: true),
      body: const Center(child: Text('')),
    );
  }
}
String _display = '0';
String _first = '';
String _second = '';
String _op = '';
bool _justEvaluated = false;

bool get _isEnteringFirst => _op.isEmpty;

@override
Widget build(BuildContext context) {
  final opStyle = TextStyle(
    fontSize: 14,
    color: Theme.of(context).colorScheme.primary,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  return Scaffold(
    appBar: AppBar(title: const Text('CalculatorApp'), centerTitle: true),
    body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withOpacity(0.04),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_first.isEmpty ? '' : _first} ${_op.isEmpty ? '' : _op} ${_second.isEmpty ? '' : _second}',
                    style: opStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _display,
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    ),
  );
}
Widget _buildButton(String label, {VoidCallback? onTap, double flex = 1}) {
  return Expanded(
    flex: flex.toInt(),
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.indigo.withOpacity(0.08),
          ),
          alignment: Alignment.center,
          child: Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
        ),
      ),
    ),
  );
}
