import 'package:flutter/material.dart';

void main() {
  runApp(const VigiaPlantaApp());
}

class VigiaPlantaApp extends StatelessWidget {
  const VigiaPlantaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vigia Planta',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          primary: const Color(0xFF1A472A),
          secondary: const Color(0xFF4CAF50),
        ),
        fontFamily: 'Inter',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8F0),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/cadastro': (context) => const CadastroScreen(),
        '/busca': (context) => const BuscaScreen(),
        '/descricao': (context) => const DescricaoProjetoScreen(),
        '/sobre': (context) => SobreScreen(),
        '/dashboard-home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args != null && args is String) {
            return DashboardHomeScreen(usuarioNome: args);
          }
          return const DashboardHomeScreen(usuarioNome: 'Usuário');
        },
        '/minhas-plantas': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args != null && args is Map) {
            return MinhasPlantasScreen(
              usuarioNome: args['nome'] as String,
              plantas: args['plantas'] as List<Map<String, dynamic>>,
            );
          }
          return const MinhasPlantasScreen(usuarioNome: 'Usuário', plantas: []);
        },
        '/detalhes-planta': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args != null && args is Map) {
            return DetalhesPlantaScreen(
              planta: args['planta'] as Map<String, dynamic>,
              usuarioNome: args['nome'] as String,
            );
          }
          return const DetalhesPlantaScreen(planta: {}, usuarioNome: 'Usuário');
        },
        '/calendario': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args != null && args is String) {
            return CalendarioScreen(usuarioNome: args);
          }
          return const CalendarioScreen(usuarioNome: 'Usuário');
        },
      },
    );
  }
}

// ==================== MODELO DE USUÁRIO ====================
class Usuario {
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  final bool aceitaTermos;

  Usuario({
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.aceitaTermos,
  });
}

// ==================== GERENCIADOR DE USUÁRIOS ====================
class UserManager {
  static final List<Usuario> _usuarios = [];

  static List<Usuario> get usuarios => List.unmodifiable(_usuarios);

  static void adicionarUsuario(Usuario usuario) {
    _usuarios.add(usuario);
  }

  static Usuario? buscarUsuario(String email, String senha) {
    try {
      return _usuarios.firstWhere((u) => u.email == email && u.senha == senha);
    } catch (e) {
      return null;
    }
  }

  static List<Usuario> buscarPorTermo(String termo, String tipoBusca) {
    if (termo.isEmpty) return [];

    final termoLower = termo.toLowerCase();
    return _usuarios.where((usuario) {
      if (tipoBusca == 'nome') {
        return usuario.nome.toLowerCase().contains(termoLower);
      } else {
        return usuario.email.toLowerCase().contains(termoLower);
      }
    }).toList();
  }
}

// ==================== TELA INICIAL (HOME) ====================
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildWelcomeSection()),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final menus = _getMenuItems();
                  return _buildElegantMenuItem(
                    context: context,
                    title: menus[index]['title'] as String,
                    description: menus[index]['description'] as String,
                    icon: menus[index]['icon'] as IconData,
                    gradient: menus[index]['gradient'] as List<Color>,
                    route: menus[index]['route'] as String,
                  );
                }, childCount: _getMenuItems().length),
              ),
            ),
            SliverToBoxAdapter(child: _buildFooter()),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMenuItems() {
    return [
      {
        'title': 'Acessar Conta',
        'description': 'Faça login no Vigia Planta',
        'icon': Icons.login_rounded,
        'gradient': [const Color(0xFF4CAF50), const Color(0xFF2E7D32)],
        'route': '/login',
      },
      {
        'title': 'Criar Conta',
        'description': 'Cadastre-se gratuitamente',
        'icon': Icons.app_registration_rounded,
        'gradient': [const Color(0xFF2196F3), const Color(0xFF1976D2)],
        'route': '/cadastro',
      },
      {
        'title': 'Buscar Usuários',
        'description': 'Encontre outros amantes de plantas',
        'icon': Icons.search_rounded,
        'gradient': [const Color(0xFFFF9800), const Color(0xFFF57C00)],
        'route': '/busca',
      },
      {
        'title': 'Sobre o Projeto',
        'description': 'Conheça nossa missão',
        'icon': Icons.description_rounded,
        'gradient': [const Color(0xFF9C27B0), const Color(0xFF7B1FA2)],
        'route': '/descricao',
      },
      {
        'title': 'Sobre Nós',
        'description': 'Conheça a equipe',
        'icon': Icons.people_rounded,
        'gradient': [const Color(0xFFE91E63), const Color(0xFFC2185B)],
        'route': '/sobre',
      },
    ];
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(30, 40, 30, 50),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, double value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo_sem_fundo_branca.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.eco, color: Colors.white, size: 60),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Vigia Planta',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '🌿 Cuide das suas plantas com inteligência 🌿',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🌱 Bem-vindo(a)!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Comece sua jornada no mundo das plantas. Escolha uma opção abaixo para continuar.',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF555555).withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_emotions,
              size: 35,
              color: Color(0xFF4CAF50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantMenuItem({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, size: 30, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: gradient.first.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: gradient.first,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF263238), Color(0xFF1A237E)],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.water_drop, size: 20, color: Colors.blue[300]),
              const SizedBox(width: 12),
              Icon(Icons.wb_sunny, size: 20, color: Colors.orange[300]),
              const SizedBox(width: 12),
              Icon(Icons.eco, size: 20, color: Colors.green[300]),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '🌱 Suas plantas merecem o melhor cuidado!',
            style: TextStyle(fontSize: 13, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '© 2026 Vigia Planta - Todos os direitos reservados',
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TELA DE LOGIN ====================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() => _isLoading = false);
        final usuario = UserManager.buscarUsuario(
          _emailController.text,
          _senhaController.text,
        );
        if (usuario != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bem-vindo(a), ${usuario.nome}! 🌿'),
              backgroundColor: const Color(0xFF4CAF50),
            ),
          );
          Navigator.pushReplacementNamed(
            context,
            '/dashboard-home',
            arguments: usuario.nome,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('E-mail ou senha inválidos!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 3, 87, 31),
            ),
          ),
        ),
        title: const Text(
          'Login',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logosemfundo.png',
                      width: 50,
                      height: 50,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Acesse sua conta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Informe seus dados para continuar',
                    style: TextStyle(color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Color(0xFF4CAF50),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Digite seu e-mail';
                            if (!value.contains('@')) return 'E-mail inválido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _senhaController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: Color(0xFF4CAF50),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Digite sua senha';
                            if (value.length < 6)
                              return 'Senha deve ter pelo menos 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Entrar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Não tem conta?'),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/cadastro'),
                        child: const Text(
                          'Cadastre-se',
                          style: TextStyle(color: Color(0xFF4CAF50)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== TELA DE CADASTRO ====================
class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _aceitaTermos = false;
  bool _obscureSenha = true;
  bool _obscureConfirmar = true;
  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Dados Pessoais',
      'icon': Icons.person_outline,
      'description': 'Vamos começar com suas informações básicas',
    },
    {
      'title': 'Segurança',
      'icon': Icons.lock_outline,
      'description': 'Crie uma senha segura para sua conta',
    },
    {
      'title': 'Preferências',
      'icon': Icons.notifications_active,
      'description': 'Configure suas preferências de notificação',
    },
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_nomeController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _emailController.text.contains('@') &&
          _telefoneController.text.isNotEmpty) {
        setState(() => _currentStep++);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha todos os campos corretamente!'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } else if (_currentStep == 1) {
      if (_senhaController.text.length >= 6 &&
          _confirmarSenhaController.text == _senhaController.text) {
        setState(() => _currentStep++);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Verifique se a senha tem pelo menos 6 caracteres e está correta!',
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _previousStep() {
    setState(() => _currentStep--);
  }

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      UserManager.adicionarUsuario(
        Usuario(
          nome: _nomeController.text,
          email: _emailController.text,
          senha: _senhaController.text,
          telefone: _telefoneController.text,
          aceitaTermos: _aceitaTermos,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso! 🎉'),
          backgroundColor: Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF2E7D32),
              size: 24,
            ),
          ),
        ),
        title: const Text(
          'Voltar',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header animado
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1B5E20),
                    Color(0xFF2E7D32),
                    Color(0xFF4CAF50),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: Column(
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, double value, child) =>
                        Transform.scale(scale: value, child: child),
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/Logo_Sem_Fundo_Branca.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.eco,
                                color: Colors.white,
                                size: 40,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Criar Conta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _steps[_currentStep]['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            // Step indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: List.generate(_steps.length, (index) {
                  bool isActive = index == _currentStep;
                  bool isCompleted = index < _currentStep;
                  return Expanded(
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 3,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color(0xFF4CAF50)
                                : isActive
                                ? const Color(0xFF4CAF50).withValues(alpha: 0.5)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 8),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? const Color(0xFF4CAF50)
                                : isActive
                                ? Colors.white
                                : Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCompleted || isActive
                                  ? const Color(0xFF4CAF50)
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            isCompleted ? Icons.check : _steps[index]['icon'],
                            size: 18,
                            color: isCompleted
                                ? Colors.white
                                : isActive
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _steps[index]['title'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isActive || isCompleted
                                ? const Color(0xFF4CAF50)
                                : Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            // Formulário
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Step 1: Dados Pessoais
                      if (_currentStep == 0) ...[
                        _buildAnimatedInput(
                          controller: _nomeController,
                          label: 'Nome Completo',
                          icon: Icons.person_outline,
                          hint: 'Digite seu nome completo',
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Digite seu nome' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedInput(
                          controller: _emailController,
                          label: 'E-mail',
                          icon: Icons.email_outlined,
                          hint: 'seu@email.com',
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Digite seu e-mail';
                            if (!v.contains('@')) return 'E-mail inválido';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedInput(
                          controller: _telefoneController,
                          label: 'Telefone',
                          icon: Icons.phone_outlined,
                          hint: '(11) 99999-9999',
                          keyboardType: TextInputType.phone,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Digite seu telefone'
                              : null,
                        ),
                      ],
                      // Step 2: Segurança
                      if (_currentStep == 1) ...[
                        _buildAnimatedPasswordField(
                          controller: _senhaController,
                          label: 'Senha',
                          icon: Icons.lock_outline,
                          hint: 'Mínimo 6 caracteres',
                          obscureText: _obscureSenha,
                          onToggle: () =>
                              setState(() => _obscureSenha = !_obscureSenha),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Digite sua senha';
                            if (v.length < 6) return 'Mínimo 6 caracteres';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedPasswordField(
                          controller: _confirmarSenhaController,
                          label: 'Confirmar Senha',
                          icon: Icons.lock_outline,
                          hint: 'Digite a senha novamente',
                          obscureText: _obscureConfirmar,
                          onToggle: () => setState(
                            () => _obscureConfirmar = !_obscureConfirmar,
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Confirme sua senha';
                            if (v != _senhaController.text)
                              return 'Senhas não conferem';
                            return null;
                          },
                        ),
                      ],
                      // Step 3: Preferências (Versão Simplificada)
                      if (_currentStep == 2) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Notificações
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF4CAF50,
                                          ).withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.notifications_active,
                                          color: Color(0xFF4CAF50),
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Receber lembretes de rega',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            'Receba notificações das plantas',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF888888),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: _aceitaTermos,
                                    onChanged: (value) =>
                                        setState(() => _aceitaTermos = value),
                                    activeColor: const Color(0xFF4CAF50),
                                    activeTrackColor: const Color(0xFF81C784),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.security,
                                color: Color(0xFF4CAF50),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Suas informações estão seguras e não serão compartilhadas com terceiros.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                      // Botões de navegação
                      Row(
                        children: [
                          if (_currentStep > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _previousStep,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF4CAF50),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                ),
                                child: const Text(
                                  'Voltar',
                                  style: TextStyle(color: Color(0xFF4CAF50)),
                                ),
                              ),
                            ),
                          if (_currentStep > 0) const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _currentStep < 2
                                  ? _nextStep
                                  : _cadastrar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4CAF50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _currentStep < 2
                                        ? 'Continuar'
                                        : 'Cadastrar',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (_currentStep < 2) ...[
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, double value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAnimatedPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 400),
      builder: (context, double value, child) => Transform.translate(
        offset: Offset(0, 20 * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF4CAF50)),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: onToggle,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}

// ==================== TELA DE BUSCA ====================
class BuscaScreen extends StatefulWidget {
  const BuscaScreen({super.key});

  @override
  State<BuscaScreen> createState() => _BuscaScreenState();
}

class _BuscaScreenState extends State<BuscaScreen> {
  final _searchController = TextEditingController();
  String _searchBy = 'nome';
  List<Usuario> _resultadosBusca = [];

  void _realizarBusca() {
    setState(
      () => _resultadosBusca = UserManager.buscarPorTermo(
        _searchController.text,
        _searchBy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF9800),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        title: const Text(
          'Buscar Usuários',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'nome',
                      label: Text('Por Nome'),
                      icon: Icon(Icons.person),
                    ),
                    ButtonSegment(
                      value: 'email',
                      label: Text('Por Email'),
                      icon: Icon(Icons.email),
                    ),
                  ],
                  selected: {_searchBy},
                  onSelectionChanged: (Set<String> newSelection) =>
                      setState(() => _searchBy = newSelection.first),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? const Color(0xFFFF9800)
                          : Colors.grey[200],
                    ),
                    foregroundColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.selected)
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Digite o termo para buscar...',
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Color(0xFFFF9800),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF9800),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F8F0),
                        ),
                        onSubmitted: (_) => _realizarBusca(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _realizarBusca,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9800),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Buscar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _resultadosBusca.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Digite um termo para buscar'
                              : 'Nenhum usuário encontrado',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _resultadosBusca.length,
                    itemBuilder: (context, index) {
                      final user = _resultadosBusca[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF4CAF50),
                            child: Text(
                              user.nome[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            user.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.email,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF4CAF50,
                                  ).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  '🌱 Amante de plantas',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () => _showUserDetails(user),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(Usuario user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: const Color(0xFF4CAF50),
              child: Text(
                user.nome[0].toUpperCase(),
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.nome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(user.email, style: const TextStyle(color: Color(0xFF666666))),
            const SizedBox(height: 8),
            Text(
              user.telefone,
              style: const TextStyle(color: Color(0xFF666666)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '🌱 Amante de plantas',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4CAF50)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Fechar',
                  style: TextStyle(color: Color(0xFF4CAF50)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TELA DESCRIÇÃO DO PROJETO ====================
class DescricaoProjetoScreen extends StatelessWidget {
  const DescricaoProjetoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF9C27B0),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: const Text(
          'Sobre o Projeto',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo_sem_fundo_branca.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.description,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Vigia Planta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Seu assistente pessoal para cuidar das plantas',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoCard(
                    title: '📱 Sobre o Aplicativo',
                    content:
                        'O Vigia Planta é um aplicativo desenvolvido para ajudar pessoas a cuidarem melhor de suas plantas, oferecendo lembretes de rega, dicas de cultivo e um diário de crescimento das plantas.',
                    icon: Icons.smartphone,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: '✨ Funcionalidades',
                    content:
                        '✅ Cadastro de usuários\n✅ Sistema de login seguro\n✅ Busca de usuários cadastrados\n✅ Dicas personalizadas para cada planta\n✅ Lembretes de rega e adubação\n✅ Galeria de plantas',
                    icon: Icons.star,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: '🌿 Benefícios',
                    content:
                        '• Plantas mais saudáveis\n• Economia com reposição de plantas\n• Aprendizado sobre jardinagem\n• Conexão com a natureza',
                    icon: Icons.emoji_nature,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: '🛠 Tecnologias Utilizadas',
                    content:
                        '• Flutter & Dart\n• Material Design 3\n• Stateful widgets para gerenciamento de estado\n• Navegação por rotas nomeadas\n• Validação de formulários',
                    icon: Icons.code,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF9C27B0), size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== TELA SOBRE NÓS ====================
class SobreScreen extends StatelessWidget {
  SobreScreen({super.key});

  final List<Map<String, dynamic>> desenvolvedores = [
    {
      'nome': 'Eduardo Batagliotti',
      'funcao': 'Desenvolvedor Back-End',
      'bio': 'Programador Back-End.',
      'imagem': 'assets/images/eduardo.jpg',
      'cor': Color.fromARGB(255, 20, 175, 26),
    },
    {
      'nome': 'Davi Marinho',
      'funcao': 'Banco de Dados',
      'bio': 'Pequenas ações, grandes impactos.',
      'imagem': 'assets/images/davi_marinho.jpg',
      'cor': Color.fromARGB(255, 10, 143, 148),
    },
    {
      'nome': 'Higor Nielsen Maciel',
      'funcao': 'Líder',
      'bio': 'Desenvolvedor Front-End.',
      'imagem': 'assets/images/higor.jpg',
      'cor': Color.fromARGB(255, 255, 30, 0),
    },
    {
      'nome': 'Davi Sachetti Puzoni',
      'funcao': 'Auxílio Geral',
      'bio': 'Garante que o produto atenda às necessidades dos usuários.',
      'imagem': 'assets/images/davi_puzoni.jpg',
      'cor': Color.fromARGB(255, 167, 43, 189),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        title: const Text(
          'Sobre Nós',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFFF5722)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/logo_sem_fundo_branca.png',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.people,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Equipe Vigia Planta',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Transformando o cuidado com plantas em algo simples e prazeroso',
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Conheça nossos desenvolvedores',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Um time apaixonado por tecnologia e natureza',
                    style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                  ),
                  const SizedBox(height: 24),
                  ...desenvolvedores.map((dev) => _buildDeveloperCard(dev)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperCard(Map<String, dynamic> dev) {
    final Color devColor = dev['cor'] as Color;
    final String imagemPath = dev['imagem'] as String;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: devColor, width: 3),
            ),
            child: ClipOval(
              child: Image.asset(
                imagemPath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [devColor, devColor.withValues(alpha: 0.7)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person, size: 35, color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dev['nome'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: devColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    dev['funcao'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: devColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dev['bio'] as String,
                  style: const TextStyle(
                    fontSize: 12,
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
}

// ==================== TELA DASHBOARD HOME (PÓS-LOGIN) ====================
class DashboardHomeScreen extends StatefulWidget {
  final String usuarioNome;
  const DashboardHomeScreen({super.key, required this.usuarioNome});

  @override
  State<DashboardHomeScreen> createState() => _DashboardHomeScreenState();
}

class _DashboardHomeScreenState extends State<DashboardHomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _todasPlantas = [
    {
      'name': 'Podo Carpus (Externo)',
      'image': 'assets/images/podocarpo.jpg',
      'waterLevel': 0.20,
      'sunLevel': 0.95,
      'status': 'urgent',
      'descricao': 'Planta que precisa de atenção urgente! Rega necessária.',
      'ultimaRega': 'Há 5 dias',
      'proximaRega': 'Hoje',
    },
    {
      'name': 'Podo Carpus (Interno)',
      'image': 'assets/images/podocarpo2.jpg',
      'waterLevel': 0.45,
      'sunLevel': 0.40,
      'status': 'warning',
      'descricao': 'Nível de água baixo, regar em breve.',
      'ultimaRega': 'Há 3 dias',
      'proximaRega': 'Amanhã',
    },
    {
      'name': 'Croton',
      'image': 'assets/images/croton.jpg',
      'waterLevel': 0.60,
      'sunLevel': 1.00,
      'status': 'normal',
      'descricao': 'Planta saudável, continue assim!',
      'ultimaRega': 'Há 2 dias',
      'proximaRega': 'Em 2 dias',
    },
    {
      'name': 'Rosa',
      'image': 'assets/images/rosa.jpg',
      'waterLevel': 0.85,
      'sunLevel': 0.67,
      'status': 'normal',
      'descricao': 'Linda e saudável!',
      'ultimaRega': 'Há 1 dia',
      'proximaRega': 'Em 3 dias',
    },
    {
      'name': 'Costela de Adão',
      'image': 'assets/images/costela.jpg',
      'waterLevel': 0.70,
      'sunLevel': 0.80,
      'status': 'normal',
      'descricao': 'Planta exuberante!',
      'ultimaRega': 'Há 2 dias',
      'proximaRega': 'Em 2 dias',
    },
    {
      'name': 'Cacto',
      'image': 'assets/images/cacto.jpg',
      'waterLevel': 0.75,
      'sunLevel': 0.95,
      'status': 'normal',
      'descricao': 'Resistente e forte!',
      'ultimaRega': 'Há 4 dias',
      'proximaRega': 'Em 5 dias',
    },
    {
      'name': 'Lírio da Paz',
      'image': 'assets/images/lirio.jpg',
      'waterLevel': 1.00,
      'sunLevel': 0.80,
      'status': 'normal',
      'descricao': 'Paz e harmonia no ambiente.',
      'ultimaRega': 'Hoje',
      'proximaRega': 'Em 3 dias',
    },
    {
      'name': 'Suculenta',
      'image': 'assets/images/suculenta.jpg',
      'waterLevel': 1.00,
      'sunLevel': 0.95,
      'status': 'normal',
      'descricao': 'Pequena mas cheia de vida!',
      'ultimaRega': 'Hoje',
      'proximaRega': 'Em 4 dias',
    },
  ];

  List<Map<String, dynamic>> _plantsAttention = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _plantsAttention = _todasPlantas
        .where((p) => p['status'] == 'urgent' || p['status'] == 'warning')
        .toList();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showDevelopmentMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade em desenvolvimento ✨'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do aplicativo?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMinhasPlantas() {
    Navigator.pushNamed(
      context,
      '/minhas-plantas',
      arguments: {'nome': widget.usuarioNome, 'plantas': _todasPlantas},
    );
  }

  void _navigateToCalendario() {
    Navigator.pushNamed(context, '/calendario', arguments: widget.usuarioNome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F8F0),
      drawer: _buildSidebar(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildHeroCard(),
                      const SizedBox(height: 24),
                      _buildPlantsAttentionSection(),
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

  Widget _buildSidebar() {
    return Drawer(
      width: 280,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A472A), Color(0xFF0D2818)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logosemfundo.png',
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
                  _buildSidebarItem(
                    Icons.home,
                    'Início',
                    isActive: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildSidebarItem(
                    Icons.eco,
                    'Minhas Plantas',
                    onTap: _navigateToMinhasPlantas,
                  ),
                  _buildSidebarItem(
                    Icons.pie_chart,
                    'Estatísticas',
                    onTap: _showDevelopmentMessage,
                  ),
                  _buildSidebarItem(
                    Icons.credit_card,
                    'Assinatura',
                    onTap: _showDevelopmentMessage,
                  ),
                  _buildSidebarItem(
                    Icons.calendar_today,
                    'Calendário',
                    onTap: _navigateToCalendario,
                  ),
                  const Divider(color: Color(0x1AFFFFFF)),
                  _buildSidebarItem(
                    Icons.logout,
                    'Sair',
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF2E7D32),
                    child: Text(
                      widget.usuarioNome.isNotEmpty
                          ? widget.usuarioNome[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.usuarioNome.isNotEmpty
                          ? widget.usuarioNome
                          : 'Usuário',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildSidebarItem(
    IconData icon,
    String label, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive ? const Color(0x334CAF50) : null,
        onTap: onTap,
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
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/logosemfundo.png',
            height: 45,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.eco, color: Color(0xFF4CAF50), size: 30),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF555555),
                ),
                onPressed: _showDevelopmentMessage,
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
          CircleAvatar(
            radius: 21,
            backgroundColor: const Color(0xFF4CAF50),
            child: Text(
              widget.usuarioNome.isNotEmpty
                  ? widget.usuarioNome[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    final List<Map<String, dynamic>> metrics = [
      {
        'icon': Icons.eco,
        'value': _todasPlantas.length.toString(),
        'label': 'Plantas no total',
        'color': const Color(0xFF4CAF50),
      },
      {
        'icon': Icons.water_drop,
        'value': _todasPlantas
            .where((p) => p['waterLevel'] < 0.5)
            .length
            .toString(),
        'label': 'Precisam de água',
        'color': const Color(0xFF2196F3),
      },
      {
        'icon': Icons.wb_sunny,
        'value': '92%',
        'label': 'Nível de luz solar',
        'color': const Color(0xFFFF9800),
      },
      {
        'icon': Icons.calendar_today,
        'value': '15',
        'label': 'Tarefas hoje',
        'color': const Color(0xFF9C27B0),
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Olá, ${widget.usuarioNome}! 🌿',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 700
                  ? 4
                  : constraints.maxWidth > 500
                  ? 2
                  : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: metrics.length,
                itemBuilder: (context, index) {
                  final metric = metrics[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: (metric['color'] as Color).withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            metric['icon'] as IconData,
                            size: 28,
                            color: metric['color'] as Color,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                metric['value'] as String,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF333333),
                                ),
                              ),
                              Text(
                                metric['label'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF666666),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlantsAttentionSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🌱 ATENÇÃO ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              TextButton(
                onPressed: _navigateToMinhasPlantas,
                child: const Row(
                  children: [
                    Text(
                      'Ver todas',
                      style: TextStyle(color: Color(0xFF4CAF50)),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Color(0xFF4CAF50),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_plantsAttention.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Todas as suas plantas estão saudáveis! 🌟',
                      style: TextStyle(fontSize: 14, color: Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
            )
          else
            SizedBox(
              height: 280,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _plantsAttention.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final plant = _plantsAttention[index];
                  String status = plant['status'] as String;
                  Color borderColor = status == 'urgent'
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFFFC107);
                  Color bgColor = status == 'urgent'
                      ? const Color(0xFFFFF8E1)
                      : Colors.white;
                  double waterLevel = plant['waterLevel'] as double;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/detalhes-planta',
                        arguments: {
                          'planta': plant,
                          'nome': widget.usuarioNome,
                        },
                      );
                    },
                    child: Container(
                      width: 180,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                                width: 3,
                              ),
                              image: DecorationImage(
                                image: AssetImage(plant['image'] as String),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {},
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            plant['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Nível de Umidade:',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF666666),
                            ),
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
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
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(waterLevel * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: waterLevel < 0.3
                                  ? const Color(0xFFFF5722)
                                  : waterLevel < 0.5
                                  ? const Color(0xFFFFC107)
                                  : const Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: borderColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status == 'urgent' ? '⚠️ Urgente' : '⚡ Atenção',
                              style: TextStyle(
                                fontSize: 10,
                                color: borderColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ==================== TELA MINHAS PLANTAS ====================
class MinhasPlantasScreen extends StatelessWidget {
  final String usuarioNome;
  final List<Map<String, dynamic>> plantas;

  const MinhasPlantasScreen({
    super.key,
    required this.usuarioNome,
    required this.plantas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Minhas Plantas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: plantas.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco, size: 80, color: Color(0xFF4CAF50)),
                  SizedBox(height: 16),
                  Text(
                    'Você ainda não tem plantas cadastradas',
                    style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Adicione sua primeira planta! 🌱',
                    style: TextStyle(fontSize: 14, color: Color(0xFF4CAF50)),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: plantas.length,
              itemBuilder: (context, index) {
                final plant = plantas[index];
                String status = plant['status'] as String;
                Color borderColor = status == 'urgent'
                    ? const Color(0xFFFF9800)
                    : status == 'warning'
                    ? const Color(0xFFFFC107)
                    : const Color(0xFF4CAF50);
                double waterLevel = plant['waterLevel'] as double;
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detalhes-planta',
                      arguments: {'planta': plant, 'nome': usuarioNome},
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: borderColor,
                        width: status != 'normal' ? 2 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                  width: 2,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(plant['image'] as String),
                                  fit: BoxFit.cover,
                                  onError: (exception, stackTrace) {},
                                ),
                              ),
                            ),
                            if (status == 'urgent')
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF9800),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.warning,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          plant['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Umidade:',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 2),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
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
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(waterLevel * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 10,
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
                  ),
                );
              },
            ),
    );
  }
}

// ==================== TELA DETALHES DA PLANTA ====================
class DetalhesPlantaScreen extends StatelessWidget {
  final Map<String, dynamic> planta;
  final String usuarioNome;

  const DetalhesPlantaScreen({
    super.key,
    required this.planta,
    required this.usuarioNome,
  });

  @override
  Widget build(BuildContext context) {
    String status = planta['status'] as String;
    Color statusColor = status == 'urgent'
        ? const Color(0xFFFF9800)
        : status == 'warning'
        ? const Color(0xFFFFC107)
        : const Color(0xFF4CAF50);
    double waterLevel = planta['waterLevel'] as double;
    double sunLevel = planta['sunLevel'] as double;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8F0),
      appBar: AppBar(
        backgroundColor: statusColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          planta['name'] as String,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      image: DecorationImage(
                        image: AssetImage(planta['image'] as String),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status == 'urgent'
                          ? '⚠️ Precisa de atenção urgente!'
                          : status == 'warning'
                          ? '⚡ Atenção necessária'
                          : '✅ Saudável',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoCard(
                    '📝 Sobre',
                    planta['descricao'] as String,
                    Icons.info,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    '💧 Nível de Umidade',
                    '${(waterLevel * 100).toInt()}%',
                    Icons.water_drop,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    '☀️ Nível de Luz Solar',
                    '${(sunLevel * 100).toInt()}%',
                    Icons.wb_sunny,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    '📅 Última Rega',
                    planta['ultimaRega'] as String,
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    '⏰ Próxima Rega',
                    planta['proximaRega'] as String,
                    Icons.schedule,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rega registrada! 🌊'),
                            backgroundColor: Color(0xFF4CAF50),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.water_drop, color: Colors.white),
                      label: const Text(
                        'Regar Agora',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
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

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, size: 24, color: const Color(0xFF4CAF50)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TELA CALENDÁRIO (PREVISÃO DO TEMPO) ====================
class CalendarioScreen extends StatefulWidget {
  final String usuarioNome;
  const CalendarioScreen({super.key, required this.usuarioNome});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _previsaoTempo = [
    {
      'dia': 'Segunda',
      'temp': '28°C',
      'clima': '☀️ Ensolarado',
      'umidade': '65%',
      'icon': Icons.wb_sunny,
      'color': const Color(0xFFFF9800),
    },
    {
      'dia': 'Terça',
      'temp': '26°C',
      'clima': '⛅ Parcialmente Nublado',
      'umidade': '70%',
      'icon': Icons.cloud,
      'color': const Color(0xFF9E9E9E),
    },
    {
      'dia': 'Quarta',
      'temp': '24°C',
      'clima': '🌧️ Chuvoso',
      'umidade': '85%',
      'icon': Icons.grain,
      'color': const Color(0xFF2196F3),
    },
    {
      'dia': 'Quinta',
      'temp': '25°C',
      'clima': '🌤️ Poucas Nuvens',
      'umidade': '68%',
      'icon': Icons.wb_cloudy,
      'color': const Color(0xFF4CAF50),
    },
    {
      'dia': 'Sexta',
      'temp': '29°C',
      'clima': '☀️ Ensolarado',
      'umidade': '60%',
      'icon': Icons.wb_sunny,
      'color': const Color(0xFFFF9800),
    },
    {
      'dia': 'Sábado',
      'temp': '27°C',
      'clima': '⛅ Parcialmente Nublado',
      'umidade': '72%',
      'icon': Icons.cloud,
      'color': const Color(0xFF9E9E9E),
    },
    {
      'dia': 'Domingo',
      'temp': '26°C',
      'clima': '🌧️ Chuvoso',
      'umidade': '80%',
      'icon': Icons.grain,
      'color': const Color(0xFF2196F3),
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showDevelopmentMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidade em desenvolvimento ✨'),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente sair do aplicativo?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Color(0xFF666666)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text(
              'Sair',
              style: TextStyle(color: Color(0xFF4CAF50)),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(
      context,
      '/dashboard-home',
      arguments: widget.usuarioNome,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F8F0),
      drawer: _buildSidebar(),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildWeatherHeader(),
                      const SizedBox(height: 24),
                      _buildWeatherForecast(),
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

  Widget _buildSidebar() {
    return Drawer(
      width: 280,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A472A), Color(0xFF0D2818)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logosemfundo.png',
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
                  _buildSidebarItem(
                    Icons.home,
                    'Início',
                    onTap: _navigateToHome,
                  ),
                  _buildSidebarItem(
                    Icons.eco,
                    'Minhas Plantas',
                    onTap: _showDevelopmentMessage,
                  ),
                  _buildSidebarItem(
                    Icons.pie_chart,
                    'Estatísticas',
                    onTap: _showDevelopmentMessage,
                  ),
                  _buildSidebarItem(
                    Icons.credit_card,
                    'Assinatura',
                    onTap: _showDevelopmentMessage,
                  ),
                  _buildSidebarItem(
                    Icons.calendar_today,
                    'Calendário',
                    isActive: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  const Divider(color: Color(0x1AFFFFFF)),
                  _buildSidebarItem(
                    Icons.logout,
                    'Sair',
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutDialog();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0x1AFFFFFF))),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF2E7D32),
                    child: Text(
                      widget.usuarioNome.isNotEmpty
                          ? widget.usuarioNome[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.usuarioNome.isNotEmpty
                          ? widget.usuarioNome
                          : 'Usuário',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildSidebarItem(
    IconData icon,
    String label, {
    bool isActive = false,
    VoidCallback? onTap,
  }) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isActive ? const Color(0x334CAF50) : null,
        onTap: onTap,
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
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
          ),
          const Spacer(),
          Image.asset(
            'assets/images/logosemfundo.png',
            height: 45,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.eco, color: Color(0xFF4CAF50), size: 30),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF555555),
                ),
                onPressed: _showDevelopmentMessage,
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
          CircleAvatar(
            radius: 21,
            backgroundColor: const Color(0xFF4CAF50),
            child: Text(
              widget.usuarioNome.isNotEmpty
                  ? widget.usuarioNome[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_queue, size: 40, color: Colors.white),
              const SizedBox(width: 12),
              Text(
                'Previsão do Tempo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '☁️ Essa será a previsão do tempo para os próximos dias ☀️',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  'Sua Região',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherForecast() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📅 Previsão para os próximos 7 dias',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _previsaoTempo.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final previsao = _previsaoTempo[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (previsao['color'] as Color).withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        previsao['icon'] as IconData,
                        size: 28,
                        color: previsao['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            previsao['dia'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            previsao['clima'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            previsao['temp'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.water_drop,
                                size: 12,
                                color: Colors.blue[400],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                previsao['umidade'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb, color: Color(0xFFFF9800), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '💡 Dica: Aproveite os dias ensolarados para regar suas plantas pela manhã!',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
