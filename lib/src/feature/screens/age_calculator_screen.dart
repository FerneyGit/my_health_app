import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';

class AgeCalculatorScreen extends StatefulWidget {
  const AgeCalculatorScreen({super.key});

  @override
  State<AgeCalculatorScreen> createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime? _selectedDate;
  int? _years;
  int? _months;
  int? _days;
  bool _calculated = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7B1FA2),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _calculated = false;
        _years = null;
        _months = null;
        _days = null;
      });
    }
  }

  void _calculateAge() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona tu fecha de nacimiento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final DateTime now = DateTime.now();
    final DateTime birth = _selectedDate!;

    if (birth.isAfter(now)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha no puede ser en el futuro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int years = now.year - birth.year;
    int months = now.month - birth.month;
    int days = now.day - birth.day;

    if (days < 0) {
      months--;
      final lastMonth = DateTime(now.year, now.month, 0);
      days += lastMonth.day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    setState(() {
      _years = years;
      _months = months;
      _days = days;
      _calculated = true;
    });
  }

  void _reset() {
    setState(() {
      _selectedDate = null;
      _years = null;
      _months = null;
      _days = null;
      _calculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Edad')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF7B1FA2).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF7B1FA2).withOpacity(0.3),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.cake, size: 50, color: Color(0xFF7B1FA2)),
                    SizedBox(height: 10),
                    Text(
                      'Calculadora de Edad',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B1FA2),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Ingresa tu fecha de nacimiento para calcular tu edad exacta',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Date Picker Field
              const Text(
                'Fecha de Nacimiento',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF7B1FA2)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF7B1FA2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate == null
                            ? 'Seleccionar fecha'
                            : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null
                              ? Colors.grey[500]
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculateAge,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calcular Edad'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B1FA2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Limpiar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF7B1FA2),
                      side: const BorderSide(color: Color(0xFF7B1FA2)),
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Result Card
              if (_calculated && _years != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text(
                            'Tu edad es:',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildAgeUnit('$_years', 'Años'),
                              _buildDivider(),
                              _buildAgeUnit('$_months', 'Meses'),
                              _buildDivider(),
                              _buildAgeUnit('$_days', 'Días'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Naciste el ${DateFormat('dd \'de\' MMMM \'de\' yyyy', 'es').format(_selectedDate!)}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgeUnit(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 50, width: 1, color: Colors.white30);
  }
}
