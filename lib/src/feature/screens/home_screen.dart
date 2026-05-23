import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.flutter_dash, size: 50, color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        'Bienvenido a\nDevTygers App',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Proyecto Flutter - Serie Tutoriales\nFLUTTER_02 al FLUTTER_05',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Herramientas disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              const SizedBox(height: 16),

              // Feature Cards
              _buildFeatureCard(
                context,
                icon: Icons.cake,
                title: 'Calculadora de Edad',
                description:
                    'Calcula tu edad exacta en años, meses y días a partir de tu fecha de nacimiento.',
                route: '/age',
                color: const Color(0xFF7B1FA2),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                icon: Icons.stars,
                title: 'Signo Zodiacal',
                description:
                    'Descubre tu signo del zodiaco ingresando tu fecha de nacimiento.',
                route: '/zodiac',
                color: const Color(0xFF00838F),
              ),
              const SizedBox(height: 12),
              _buildFeatureCard(
                context,
                icon: Icons.monitor_weight,
                title: 'Calculadora BMI',
                description:
                    'Calcula tu Índice de Masa Corporal (IMC) y conoce tu estado de salud.',
                route: '/bmi',
                color: const Color(0xFFE65100),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String route,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushReplacementNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
