import 'package:flutter/material.dart';

void main() {
  runApp(const VigiaPlantaSite());
}

class VigiaPlantaSite extends StatelessWidget {
  const VigiaPlantaSite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              color: Colors.green,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🌱 Vigia Planta',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cuidado inteligente para suas plantas com IoT, sensores e sustentabilidade.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Sobre o Projeto',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'O Vigia Planta é um projeto de TCC desenvolvido para facilitar o cuidado de plantas em residências. O sistema utiliza Arduino Nano RP2040 Connect, sensores de umidade, temperatura e luminosidade, além de aplicativo mobile e dashboard web.',
                style: TextStyle(fontSize: 18, height: 1.6),
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Funcionalidades',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: const [
                  FeatureCard(
                    icon: '💧',
                    title: 'Monitoramento de Umidade',
                    description: 'Acompanha a umidade do solo e alerta quando precisa regar.',
                  ),
                  FeatureCard(
                    icon: '🌡',
                    title: 'Temperatura',
                    description: 'Mostra a temperatura ideal para a planta.',
                  ),
                  FeatureCard(
                    icon: '☀',
                    title: 'Luminosidade',
                    description: 'Controla a incidência de luz solar recebida.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              color: Colors.green.shade100,
              padding: const EdgeInsets.all(24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tecnologias',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text('• Flutter'),
                  Text('• Arduino'),
                  Text('• JavaScript API'),
                  Text('• Dashboard Web'),
                  Text('• Sensores IoT'),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.green,
              child: const Center(
                child: Text(
                  'Projeto acadêmico • Vigia Planta • TCC 2026',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
