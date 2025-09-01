// lib/screens/intro_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'name_input_screen.dart';
import 'home_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showPressStart = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward().then((_) {
      setState(() {
        _showPressStart = true;
      });
    });

    _checkExistingUser();
  }

  void _checkExistingUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name');

    if (userName != null && userName.isNotEmpty) {
      // Se já tem nome salvo, vai direto para home após animação
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return; // ⬅️ garante que o widget ainda está vivo
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      });
    }
  }

  void _navigateToNext() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return; // ⬅️ checa antes de usar o context

    final userName = prefs.getString('user_name');
    if (userName != null && userName.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NameInputScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título com animação
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            Text(
                              "RETORNO",
                              style: TextStyle(
                                fontFamily: 'PlanetOpt',
                                fontSize: 48,
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
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "DE SATURNO",
                              style: TextStyle(
                                fontFamily: 'PlanetOpt',
                                fontSize: 48,
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
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 100),

                // Press Start com animação piscante
                if (_showPressStart)
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 1000),
                    tween: Tween<double>(begin: 0.3, end: 1.0),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return AnimatedOpacity(
                        opacity: value,
                        duration: const Duration(milliseconds: 500),
                        child: GestureDetector(
                          onTap: _navigateToNext,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFebd71b),
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(
                                0xFF2d7a6e,
                              ).withValues(alpha: 0.5),
                            ),
                            child: Text(
                              "PRESS START",
                              style: TextStyle(
                                fontFamily: 'PlanetOpt',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFebd71b),
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    offset: const Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      // Reinicia a animação para criar efeito piscante
                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (mounted) {
                          setState(() {});
                        }
                      });
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
