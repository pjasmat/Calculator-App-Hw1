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
  String _display = '0';
  String _first = '';
  String _second = '';
  String _op = '';
  bool _justEvaluated = false;

  bool get _isEnteringFirst => _op.isEmpty;

  void _resetFields() {
    _display = '0';
    _first = '';
    _second = '';
    _op = '';
    _justEvaluated = false;
  }

  void _onDigit(String digit) {
    setState(() {
      if (_display == 'Error' || (_justEvaluated && _isEnteringFirst)) {
        _resetFields();
      }

      _justEvaluated = false;
      var current = _isEnteringFirst ? _first : _second;

      if (current == '0') {
        current = '';
      }

      current += digit;

      if (_isEnteringFirst) {
        _first = current;
      } else {
        _second = current;
      }

      _display = current;
    });
  }

  void _onDecimalPoint() {
    setState(() {
      if (_display == 'Error' || (_justEvaluated && _isEnteringFirst)) {
        _resetFields();
      }

      var current = _isEnteringFirst ? _first : _second;

      if (current.contains('.')) {
        return;
      }

      if (current.isEmpty) {
        current = '0.';
      } else {
        current += '.';
      }

      if (_isEnteringFirst) {
        _first = current;
      } else {
        _second = current;
      }

      _display = current;
      _justEvaluated = false;
    });
  }

  void _onOperator(String operatorSymbol) {
    setState(() {
      if (_display == 'Error') {
        _resetFields();
      }

      if (_op.isNotEmpty && _second.isNotEmpty) {
        if (!_evaluate()) {
          return;
        }
        _first = _display;
        _second = '';
      }

      if (_first.isEmpty) {
        _first = _display;
      }

      _op = operatorSymbol;
      _justEvaluated = false;
    });
  }

  void _onBackspace() {
    setState(() {
      if (_display == 'Error') {
        _resetFields();
        return;
      }

      if (_isEnteringFirst) {
        if (_first.isEmpty) {
          _display = '0';
        } else {
          _first = _first.substring(0, _first.length - 1);
          _display = _first.isEmpty ? '0' : _first;
        }
      } else {
        if (_second.isEmpty) {
          _op = '';
          _display = _first.isEmpty ? '0' : _first;
        } else {
          _second = _second.substring(0, _second.length - 1);
          _display = _second.isEmpty ? '0' : _second;
        }
      }

      _justEvaluated = false;
    });
  }

  void _onClear() {
    setState(_resetFields);
  }

  void _onEquals() {
    setState(() {
      if (_op.isEmpty || _second.isEmpty) {
        return;
      }

      if (!_evaluate()) {
        return;
      }

      _first = _display;
      _second = '';
      _op = '';
      _justEvaluated = true;
    });
  }


void _evaluateInternal() {
  if (_first.isEmpty || _op.isEmpty || _second.isEmpty) return;

  final a = double.tryParse(_first);
  final b = double.tryParse(_second);
  if (a == null || b == null) {
    _display = 'Error';
    return;
  }

  double? result;
  switch (_op) {
    case '+': result = a + b; break;
    case '-': result = a - b; break;
    case '×': result = a * b; break;
    case '÷':
      if (b == 0) { _display = 'Error'; return; }
      result = a / b;
      break;
  }

  if (result != null) {
    final text = result.toString();
    _display = text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
  } else {
    _display = 'Error';
  }
}

  bool _evaluate() {
    final left = double.tryParse(_first.isEmpty ? '0' : _first);
    final right = double.tryParse(_second.isEmpty ? '0' : _second);

    if (left == null || right == null) {
      _resetFields();
      _display = 'Error';
      return false;
    }

    double result;

    switch (_op) {
      case '+':
        result = left + right;
        break;
      case '-':
        result = left - right;
        break;
      case '×':
        result = left * right;
        break;
      case '÷':
        if (right == 0) {
          _resetFields();
          _display = 'Error';
          return false;
        }
        result = left / right;
        break;
      default:
        return false;
    }

    _display = _formatResult(result);
    return true;
  }

  String _formatResult(double value) {
    if (value.isNaN || value.isInfinite) {
      return 'Error';
    }

    final raw = value.toStringAsFixed(10);
    if (!raw.contains('.')) {
      return raw;
    }

    final trimmed = raw
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');

    return trimmed.isEmpty ? '0' : trimmed;
  }

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
        child: Padding(
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
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('C', onTap: _onClear),
                          _buildButton('⌫', onTap: _onBackspace),
                          _buildButton('÷', onTap: () => _onOperator('÷')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('7', onTap: () => _onDigit('7')),
                          _buildButton('8', onTap: () => _onDigit('8')),
                          _buildButton('9', onTap: () => _onDigit('9')),
                          _buildButton('×', onTap: () => _onOperator('×')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('4', onTap: () => _onDigit('4')),
                          _buildButton('5', onTap: () => _onDigit('5')),
                          _buildButton('6', onTap: () => _onDigit('6')),
                          _buildButton('-', onTap: () => _onOperator('-')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('1', onTap: () => _onDigit('1')),
                          _buildButton('2', onTap: () => _onDigit('2')),
                          _buildButton('3', onTap: () => _onDigit('3')),
                          _buildButton('+', onTap: () => _onOperator('+')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          _buildButton('0', onTap: () => _onDigit('0'), flex: 2),
                          _buildButton('.', onTap: _onDecimalPoint),
                          _buildButton('=', onTap: _onEquals),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, {VoidCallback? onTap, int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(6),
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
            child: Text(
              label,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
