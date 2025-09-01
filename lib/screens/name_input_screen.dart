// lib/screens/name_input_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class NameInputScreen extends StatefulWidget {
  const NameInputScreen({super.key});

  @override
  State<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;

  void _saveName() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, digite seu nome!',
            style: TextStyle(fontFamily: 'PlanetOpt'),
          ),
          backgroundColor: Color(0xFF2d7a6e),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a5a54),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1a5a54).withValues(alpha: 0.5),
            ),
          ),
          // Content
          Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2d7a6e).withValues(alpha: 0.9),
                border: Border.all(color: const Color(0xFFebd71b), width: 3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Título
                  Text(
                    "QUAL É SEU NOME?",
                    style: TextStyle(
                      fontFamily: 'PlanetOpt',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFebd71b),
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Campo de texto
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFebd71b),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(
                        fontFamily: 'PlanetOpt',
                        fontSize: 20,
                        color: Color(0xFFebd71b),
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Digite seu nome aqui...",
                        hintStyle: TextStyle(
                          fontFamily: 'PlanetOpt',
                          color: Color(0xFFebd71b),
                          fontSize: 16,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: Color(0xFF1a5a54),
                      ),
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _saveName(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botão continuar
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFebd71b),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1a5a54),
                        foregroundColor: const Color(0xFFebd71b),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFebd71b),
                                  ),
                                ),
                              )
                              : const Text(
                                "C O N T I N U A R",
                                style: TextStyle(
                                  fontFamily: 'PlanetOpt',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
