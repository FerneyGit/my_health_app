import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/app_drawer.dart';

class BmiScreen extends StatefulWidget {
  const BmiScreen({super.key});

  @override
  State<BmiScreen> createState() => _BmiScreenState();
}

class _BmiScreenState extends State<BmiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  double? _bmi;
  String? _category;
  Color? _categoryColor;
  String? _categoryDescription;
  bool _calculated = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateBMI() {
    if (_formKey.currentState!.validate()) {
      final double weight = double.parse(
        _weightController.text.replaceAll(',', '.'),
      );
      final double heightCm = double.parse(
        _heightController.text.replaceAll(',', '.'),
      );
      final double heightM = heightCm / 100;

      final double bmi = weight / (heightM * heightM);

      String category;
      Color color;
      String description;

      if (bmi < 18.5) {
        category = 'Bajo peso';
        color = const Color(0xFF039BE5);
        description =
            'Tu peso es menor al recomendado para tu estatura. Consulta con un médico o nutricionista para alcanzar un peso saludable.';
      } else if (bmi < 25.0) {
        category = 'Peso normal';
        color = const Color(0xFF43A047);
        description =
            '¡Excelente! Tu peso está dentro del rango saludable para tu estatura. Mantén tus hábitos de alimentación y ejercicio.';
      } else if (bmi < 30.0) {
        category = 'Sobrepeso';
        color = const Color(0xFFFFA000);
        description =
            'Tu peso está ligeramente por encima del rango saludable. Se recomienda mejorar la alimentación y aumentar la actividad física.';
      } else if (bmi < 35.0) {
        category = 'Obesidad Grado I';
        color = const Color(0xFFE64A19);
        description =
            'Presentas obesidad de grado I. Es importante consultar con un médico para establecer un plan de salud adecuado.';
      } else if (bmi < 40.0) {
        category = 'Obesidad Grado II';
        color = const Color(0xFFD32F2F);
        description =
            'Presentas obesidad de grado II. Se recomienda atención médica inmediata y seguimiento profesional.';
      } else {
        category = 'Obesidad Mórbida';
        color = const Color(0xFFB71C1C);
        description =
            'Obesidad mórbida o de grado III. Requiere atención médica urgente y supervisión profesional continua.';
      }

      setState(() {
        _bmi = bmi;
        _category = category;
        _categoryColor = color;
        _categoryDescription = description;
        _calculated = true;
      });
    }
  }

  void _reset() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _bmi = null;
      _category = null;
      _categoryColor = null;
      _categoryDescription = null;
      _calculated = false;
    });
  }

  double _getBmiIndicatorPosition() {
    if (_bmi == null) return 0;
    // Map BMI 10-50 to 0.0-1.0
    final clamped = _bmi!.clamp(10.0, 50.0);
    return (clamped - 10) / 40;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora BMI')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE65100).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE65100).withOpacity(0.3),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.monitor_weight,
                        size: 50,
                        color: Color(0xFFE65100),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Calculadora de BMI',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE65100),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Calcula tu Índice de Masa Corporal (IMC)',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Weight Field
                const Text(
                  'Peso (kg)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Ej: 70.5',
                    prefixIcon: const Icon(
                      Icons.fitness_center,
                      color: Color(0xFFE65100),
                    ),
                    suffixText: 'kg',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE65100),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu peso';
                    }
                    final v = value.replaceAll(',', '.');
                    final weight = double.tryParse(v);
                    if (weight == null) {
                      return 'Ingresa un número válido';
                    }
                    if (weight <= 0 || weight > 300) {
                      return 'Ingresa un peso válido (1-300 kg)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Height Field
                const Text(
                  'Estatura (cm)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Ej: 170',
                    prefixIcon: const Icon(
                      Icons.height,
                      color: Color(0xFFE65100),
                    ),
                    suffixText: 'cm',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFE65100),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu estatura';
                    }
                    final v = value.replaceAll(',', '.');
                    final height = double.tryParse(v);
                    if (height == null) {
                      return 'Ingresa un número válido';
                    }
                    if (height <= 0 || height > 250) {
                      return 'Ingresa una estatura válida (1-250 cm)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _calculateBMI,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Calcular BMI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE65100),
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
                        foregroundColor: const Color(0xFFE65100),
                        side: const BorderSide(color: Color(0xFFE65100)),
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
                if (_calculated && _bmi != null) ...[
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // BMI Value
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _categoryColor!.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _categoryColor!,
                                width: 3,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _bmi!.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: _categoryColor,
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'BMI',
                                  style: TextStyle(
                                    color: _categoryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Category Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _categoryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _category!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // BMI Scale Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              height: 12,
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 18,
                                        child: Container(
                                          color: const Color(0xFF039BE5),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 13,
                                        child: Container(
                                          color: const Color(0xFF43A047),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: const Color(0xFFFFA000),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: Container(
                                          color: const Color(0xFFE64A19),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 9,
                                        child: Container(
                                          color: const Color(0xFFB71C1C),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '10',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '18.5',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '25',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '30',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '35',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '50+',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Description
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _categoryDescription!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Weight/Height info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildInfoChip(
                                Icons.fitness_center,
                                '${_weightController.text} kg',
                                'Peso',
                              ),
                              _buildInfoChip(
                                Icons.height,
                                '${_heightController.text} cm',
                                'Estatura',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // BMI Reference Table
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tabla de referencia BMI',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildTableRow(
                            '< 18.5',
                            'Bajo peso',
                            const Color(0xFF039BE5),
                          ),
                          _buildTableRow(
                            '18.5 - 24.9',
                            'Peso normal',
                            const Color(0xFF43A047),
                          ),
                          _buildTableRow(
                            '25.0 - 29.9',
                            'Sobrepeso',
                            const Color(0xFFFFA000),
                          ),
                          _buildTableRow(
                            '30.0 - 34.9',
                            'Obesidad Grado I',
                            const Color(0xFFE64A19),
                          ),
                          _buildTableRow(
                            '35.0 - 39.9',
                            'Obesidad Grado II',
                            const Color(0xFFD32F2F),
                          ),
                          _buildTableRow(
                            '≥ 40.0',
                            'Obesidad Mórbida',
                            const Color(0xFFB71C1C),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE65100).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE65100), size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE65100),
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String range, String category, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text(
              range,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          Text(
            category,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
