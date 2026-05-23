import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/app_drawer.dart';

class ZodiacScreen extends StatefulWidget {
  const ZodiacScreen({super.key});

  @override
  State<ZodiacScreen> createState() => _ZodiacScreenState();
}

class _ZodiacScreenState extends State<ZodiacScreen> {
  DateTime? _selectedDate;
  String? _zodiacSign;
  String? _zodiacEmoji;
  String? _zodiacDescription;
  Color? _zodiacColor;
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
              primary: Color(0xFF00838F),
              onPrimary: Colors.white,
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
        _zodiacSign = null;
      });
    }
  }

  void _getZodiacSign() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona tu fecha de nacimiento'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int day = _selectedDate!.day;
    final int month = _selectedDate!.month;

    String sign;
    String emoji;
    String description;
    Color color;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      sign = 'Aries';
      emoji = '♈';
      description = 'Valiente, determinado, confiado, entusiasta e impaciente.';
      color = const Color(0xFFE53935);
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      sign = 'Tauro';
      emoji = '♉';
      description = 'Fiable, paciente, práctico, devoto y responsable.';
      color = const Color(0xFF43A047);
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      sign = 'Géminis';
      emoji = '♊';
      description = 'Versátil, curioso, afectuoso, adaptable y comunicativo.';
      color = const Color(0xFFFDD835);
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      sign = 'Cáncer';
      emoji = '♋';
      description = 'Tenaz, muy imaginativo, leal, emotivo y persuasivo.';
      color = const Color(0xFF039BE5);
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      sign = 'Leo';
      emoji = '♌';
      description = 'Creativo, apasionado, generoso, cálido y alegre.';
      color = const Color(0xFFFF8F00);
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      sign = 'Virgo';
      emoji = '♍';
      description = 'Leal, analítico, amable, trabajador y práctico.';
      color = const Color(0xFF8BC34A);
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      sign = 'Libra';
      emoji = '♎';
      description = 'Cooperativo, diplomático, gracioso, justo y social.';
      color = const Color(0xFFE91E63);
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      sign = 'Escorpio';
      emoji = '♏';
      description = 'Decidido, valiente, apasionado, leal y obstinado.';
      color = const Color(0xFF6A1B9A);
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      sign = 'Sagitario';
      emoji = '♐';
      description = 'Generoso, idealista, gran sentido del humor y curioso.';
      color = const Color(0xFFFF5722);
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      sign = 'Capricornio';
      emoji = '♑';
      description = 'Responsable, disciplinado, autodidacta y buena gestión.';
      color = const Color(0xFF546E7A);
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      sign = 'Acuario';
      emoji = '♒';
      description = 'Progresista, original, independiente, humanitario.';
      color = const Color(0xFF00ACC1);
    } else {
      sign = 'Piscis';
      emoji = '♓';
      description = 'Compasivo, artístico, intuitivo, amable y sabio.';
      color = const Color(0xFF3949AB);
    }

    setState(() {
      _zodiacSign = sign;
      _zodiacEmoji = emoji;
      _zodiacDescription = description;
      _zodiacColor = color;
      _calculated = true;
    });
  }

  void _reset() {
    setState(() {
      _selectedDate = null;
      _zodiacSign = null;
      _zodiacEmoji = null;
      _zodiacDescription = null;
      _zodiacColor = null;
      _calculated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signo Zodiacal')),
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
                  color: const Color(0xFF00838F).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF00838F).withOpacity(0.3),
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.stars, size: 50, color: Color(0xFF00838F)),
                    SizedBox(height: 10),
                    Text(
                      'Signo Zodiacal',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00838F),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Ingresa tu fecha de nacimiento para conocer tu signo del zodiaco',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Date Picker
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
                    border: Border.all(color: const Color(0xFF00838F)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF00838F),
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

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _getZodiacSign,
                      icon: const Icon(Icons.search),
                      label: const Text('Ver mi Signo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00838F),
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
                      foregroundColor: const Color(0xFF00838F),
                      side: const BorderSide(color: Color(0xFF00838F)),
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

              // Result
              if (_calculated && _zodiacSign != null)
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [_zodiacColor!, _zodiacColor!.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        Text(
                          _zodiacEmoji!,
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _zodiacSign!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _zodiacDescription!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
