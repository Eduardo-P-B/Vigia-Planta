import 'package:flutter/material.dart';

class Minha extends StatelessWidget {
  const Minha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigia Planta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFE2EBD7),
      ),
      home: const MinhasPlantasPage(),
    );
  }
}

class MinhasPlantasPage extends StatefulWidget {
  const MinhasPlantasPage({super.key});

  @override
  State<MinhasPlantasPage> createState() => _MinhasPlantasPageState();
}

class _MinhasPlantasPageState extends State<MinhasPlantasPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de plantas
  final List<Map<String, dynamic>> _plants = [
    {
      'name': 'Podo Carpus (Externo)',
      'image': 'assets/images/podocarpo.jpg',
      'waterLevel': 0.20,
      'sunLevel': 0.95,
      'isUrgent': true,
    },
    {
      'name': 'Podo Carpus (Interno)',
      'image': 'assets/images/podocarpo2.jpg',
      'waterLevel': 0.70,
      'sunLevel': 0.40,
      'isWarning': true,
    },
    {
      'name': 'Croton',
      'image': 'assets/images/croton.jpg',
      'waterLevel': 0.60,
      'sunLevel': 1.00,
    },
    {
      'name': 'Rosa',
      'image': 'assets/images/rosa.jpg',
      'waterLevel': 0.85,
      'sunLevel': 0.67,
    },
    {
      'name': 'Costela de Adão',
      'image': 'assets/images/costela.jpg',
      'waterLevel': 0.70,
      'sunLevel': 0.80,
    },
    {
      'name': 'Cacto',
      'image': 'assets/images/cacto.jpg',
      'waterLevel': 0.75,
      'sunLevel': 0.95,
    },
    {
      'name': 'Lírio da Paz',
      'image': 'assets/images/lirio.jpg',
      'waterLevel': 1.00,
      'sunLevel': 0.80,
    },
    {
      'name': 'Suculenta',
      'image': 'assets/images/suculenta.jpg',
      'waterLevel': 1.00,
      'sunLevel': 0.95,
    },
  ];

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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/favicom.png',
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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _buildSidebarItem(Icons.home, 'Início', onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePagePlaceholder()),
                    );
                  }),
                  _buildSidebarItem(Icons.eco, 'Minhas Plantas', isActive: true),
                  _buildSidebarItem(Icons.pie_chart, 'Estatísticas'),
                  _buildSidebarItem(Icons.credit_card, 'Assinatura'),
                  _buildSidebarItem(Icons.calendar_today, 'Calendário'),
                ],
              ),
            ),
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

  Widget _buildSidebarItem(IconData icon, String label, {bool isActive = false, VoidCallback? onTap}) {
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
          onTap?.call();
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
          // Header com título e botão
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Suas Plantas 🍂:',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Ação para adicionar nova planta
                },
                icon: const Icon(Icons.add_circle, color: Color(0xFF2E7D32)),
                label: const Text(
                  '',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Grid de plantas
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 600
                      ? 3
                      : 2;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.65,
                ),
                itemCount: _plants.length,
                itemBuilder: (context, index) {
                  return _buildPlantCard(_plants[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlantCard(Map<String, dynamic> plant) {
    bool isUrgent = plant['isUrgent'] ?? false;
    bool isWarning = plant['isWarning'] ?? false;
    double waterLevel = plant['waterLevel'];
    double sunLevel = plant['sunLevel'];

    Color borderColor = Colors.transparent;
    Color bgColor = Colors.white;

    if (isUrgent) {
      borderColor = const Color(0xFFFF9800);
      bgColor = const Color(0xFFFFF8E1);
    } else if (isWarning) {
      borderColor = const Color(0xFFFFC107);
    }

    return Container(
      padding: const EdgeInsets.all(15),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagem da planta
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 3),
              image: DecorationImage(
                image: AssetImage(plant['image']),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Nome
          Text(
            plant['name'],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          // Umidade
          const Text(
            'Nível de Umidade:',
            style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 5),
          _buildProgressBar(
            value: waterLevel,
            color: waterLevel < 0.3
                ? const Color(0xFFFF5722)
                : waterLevel < 0.5
                    ? const Color(0xFFFFC107)
                    : const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 8),
          // Luz solar
          const Text(
            'Nível de luz Solar:',
            style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
          ),
          const SizedBox(height: 5),
          _buildProgressBar(
            value: sunLevel,
            color: const Color(0xFFCDDC39),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({required double value, required Color color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SizedBox(
        height: 4,
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: const Color(0xFFE0E0E0),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}

// Placeholder para a HomePage (para navegação)
class HomePagePlaceholder extends StatelessWidget {
  const HomePagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2EBD7),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}