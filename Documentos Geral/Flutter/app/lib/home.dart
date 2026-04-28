import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigia Planta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFE2EBD7),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFE2EBD7),
      drawer: _buildSidebar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeroCard(),
                    const SizedBox(height: 30),
                    _buildPlantsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Drawer(
      width: 280,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A472A),
              Color(0xFF0D2818),
            ],
          ),
        ),
        child: Column(
          children: [
            // Sidebar Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/favicon.png',
                    height: 30,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.eco,
                      color: Color(0xFF4CAF50),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Vigia Planta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Color(0x1AFFFFFF)),
            
            // Sidebar Navigation
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildSidebarItem(Icons.home, 'Início', isActive: true),
                  _buildSidebarItem(Icons.eco, 'Minhas Plantas'),
                  _buildSidebarItem(Icons.pie_chart, 'Estatísticas'),
                  _buildSidebarItem(Icons.credit_card, 'Assinatura'),
                  _buildSidebarItem(Icons.calendar_today, 'Calendário'),
                ],
              ),
            ),
            
            // Sidebar Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0x1AFFFFFF)),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF2E7D32),
                    child: Text(
                      'U',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Usuário',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF4CAF50) : Colors.white70,
          size: 20,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF4CAF50) : Colors.white70,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: isActive ? const Color(0x334CAF50) : null,
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFF333333)),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Color(0xFF555555)),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF5722),
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            radius: 21,
            backgroundColor: Color(0xFF4CAF50),
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B5E20),
            Color(0xFF2E7D32),
            Color(0xFF43A047),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Olá, Usuário! 🌿',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          _buildMetricsGrid(),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
        
        return Column(
          children: [
            for (int i = 0; i < 4; i += crossAxisCount)
              Row(
                children: [
                  for (int j = 0; j < crossAxisCount && (i + j) < 4; j++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: _getMetricCard(i + j),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _getMetricCard(int index) {
    switch (index) {
      case 0:
        return _buildMetricCard(
          icon: Icons.eco,
          value: '24',
          label: 'Plantas no total',
          gradient: const LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
          ),
        );
      case 1:
        return _buildMetricCard(
          icon: Icons.water_drop,
          value: '8',
          label: 'Precisam de água',
          gradient: const LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
          ),
        );
      case 2:
        return _buildMetricCard(
          icon: Icons.wb_sunny,
          value: '92%',
          label: 'Nível de luz solar',
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9800), Color(0xFFF57C00)],
          ),
        );
      case 3:
        return _buildMetricCard(
          icon: Icons.calendar_view_week,
          value: '15',
          label: 'Tarefas hoje',
          gradient: const LinearGradient(
            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String value,
    required String label,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '🌱 Atenção',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Row(
                children: [
                  Text(
                    'Ver todas',
                    style: TextStyle(color: Color(0xFF4CAF50)),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, color: Color(0xFF4CAF50), size: 16),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildPlantCard(
                name: 'Podo Carpus (Externo)',
                imageAsset: 'assets/images/podocarpo.jpg',
                waterLevel: 0.20,
                isUrgent: true,
              ),
              const SizedBox(width: 15),
              _buildPlantCard(
                name: 'Podo Carpus (Interno)',
                imageAsset: 'assets/images/podocarpo2.jpg',
                waterLevel: 0.45,
                isWarning: true,
              ),
              const SizedBox(width: 15),
              _buildPlantCard(
                name: 'Croton',
                imageAsset: 'assets/images/croton.jpg',
                waterLevel: 0.60,
              ),
              const SizedBox(width: 15),
              _buildPlantCard(
                name: 'Rosa',
                imageAsset: 'assets/images/rosa.jpg',
                waterLevel: 0.85,
              ),
              const SizedBox(width: 15),
              _buildPlantCard(
                name: 'Suculenta',
                imageAsset: 'assets/images/suculenta.jpg',
                waterLevel: 0.30,
                isUrgent: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlantCard({
    required String name,
    required String imageAsset,
    required double waterLevel,
    bool isUrgent = false,
    bool isWarning = false,
  }) {
    Color borderColor = Colors.transparent;
    Color bgColor = Colors.white;

    if (isUrgent) {
      borderColor = const Color(0xFFFF9800);
      bgColor = const Color(0xFFFFF8E1);
    } else if (isWarning) {
      borderColor = const Color(0xFFFFC107);
    }

    return Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
          width: isUrgent || isWarning ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 3),
              image: DecorationImage(
                image: AssetImage(imageAsset),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Nível de Umidade:',
            style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: waterLevel,
                backgroundColor: const Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  waterLevel < 0.3
                      ? const Color(0xFFFF5722)
                      : waterLevel < 0.5
                          ? const Color(0xFFFFC107)
                          : const Color(0xFF4CAF50),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${(waterLevel * 100).toInt()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: waterLevel < 0.3
                  ? const Color(0xFFFF5722)
                  : waterLevel < 0.5
                      ? const Color(0xFFFFC107)
                      : const Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }
}