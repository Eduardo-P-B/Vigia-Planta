import 'package:flutter/material.dart';

class NovaPlantaPage extends StatefulWidget {
  const NovaPlantaPage({super.key});

  @override
  State<NovaPlantaPage> createState() => _NovaPlantaPageState();
}

class _NovaPlantaPageState extends State<NovaPlantaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _especieController = TextEditingController();
  String? _imagemSelecionada;
  
  // Lista de imagens disponíveis (simulando seleção)
  final List<Map<String, String>> _imagensDisponiveis = [
    {
      'nome': 'Podocarpo',
      'path': 'assets/images/podocarpo.jpg',
    },
    {
      'nome': 'Croton',
      'path': 'assets/images/croton.jpg',
    },
    {
      'nome': 'Rosa',
      'path': 'assets/images/rosa.jpg',
    },
    {
      'nome': 'Costela de Adão',
      'path': 'assets/images/costela.jpg',
    },
    {
      'nome': 'Cacto',
      'path': 'assets/images/cacto.jpg',
    },
    {
      'nome': 'Lírio da Paz',
      'path': 'assets/images/lirio.jpg',
    },
    {
      'nome': 'Suculenta',
      'path': 'assets/images/suculenta.jpg',
    },
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _especieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2EBD7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nova Planta',
          style: TextStyle(
            color: Color(0xFF333333),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card principal
              Container(
                padding: const EdgeInsets.all(25),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    const Row(
                      children: [
                        Icon(Icons.eco, color: Color(0xFF4CAF50), size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Dados da Planta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    
                    // Campo Nome da Planta
                    _buildInputField(
                      controller: _nomeController,
                      label: 'Nome da Planta',
                      icon: Icons.spa,
                      placeholder: 'Ex: Minha Rosa Vermelha',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o nome da planta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Campo Espécie
                    _buildInputField(
                      controller: _especieController,
                      label: 'Espécie',
                      icon: Icons.science,
                      placeholder: 'Ex: Rosa rubiginosa',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a espécie da planta';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    
                    // Seção de Imagem
                    const Row(
                      children: [
                        Icon(Icons.image, color: Color(0xFF4CAF50), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Imagem da Planta',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    
                    // Preview da imagem selecionada
                    if (_imagemSelecionada != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF4CAF50),
                            width: 2,
                          ),
                          image: DecorationImage(
                            image: AssetImage(_imagemSelecionada!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _imagemSelecionada = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    // Grid de imagens disponíveis
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imagensDisponiveis.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final imagem = _imagensDisponiveis[index];
                          final isSelected = _imagemSelecionada == imagem['path'];
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _imagemSelecionada = imagem['path'];
                              });
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF4CAF50)
                                      : const Color(0xFFE0E0E0),
                                  width: isSelected ? 3 : 1,
                                ),
                                image: DecorationImage(
                                  image: AssetImage(imagem['path']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.bottomCenter,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  imagem['nome']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    // Botão para tirar foto
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Aqui você pode implementar a câmera
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Câmera será implementada em breve'),
                              backgroundColor: Color(0xFF4CAF50),
                            ),
                          );
                        },
                        icon: const Icon(Icons.camera_alt, color: Color(0xFF4CAF50)),
                        label: const Text(
                          'Tirar Foto',
                          style: TextStyle(
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF4CAF50)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 25),
              
              // Botão Salvar
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: _salvarPlanta,
                  icon: const Icon(Icons.check_circle, color: Colors.white, size: 22),
                  label: const Text(
                    'Salvar Planta',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              
              // Botão Cancelar
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Color(0xFF666666)),
                  label: const Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String placeholder,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF4CAF50), size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          validator: validator,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4CAF50),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
          ),
        ),
      ],
    );
  }

  void _salvarPlanta() {
    if (_formKey.currentState!.validate()) {
      if (_imagemSelecionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione uma imagem para a planta'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      // Aqui você salva a planta
      final novaPlanta = {
        'nome': _nomeController.text,
        'especie': _especieController.text,
        'imagem': _imagemSelecionada,
      };

      // Volta para a página anterior com os dados
      Navigator.pop(context, novaPlanta);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Planta salva com sucesso! 🌿'),
          backgroundColor: Color(0xFF4CAF50),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}