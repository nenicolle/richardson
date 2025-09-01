// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/conquest.dart';
import '../widgets/conquest_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  List<Conquest> conquests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Carrega nome do usuário
    userName = prefs.getString('user_name') ?? "";

    // Carrega conquistas salvas ou usa as padrões
    final savedConquests = prefs.getString('conquests_data');

    if (savedConquests != null) {
      try {
        final List<dynamic> conquestsList = json.decode(savedConquests);
        conquests =
            conquestsList
                .map((json) => Conquest.fromJson(json as Map<String, dynamic>))
                .toList();
      } catch (e) {
        _initializeDefaultConquests();
      }
    } else {
      _initializeDefaultConquests();
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _initializeDefaultConquests() {
    conquests = [
      Conquest(name: "Compareceu", points: 100),
      Conquest(name: "Quis comparecer", points: 1),
      Conquest(name: "Veio de preto", points: 50),
      Conquest(name: "Trouxe uma bebida (escondida)", points: 150),
      Conquest(name: "Achou cadeira", points: 50),
      Conquest(name: "Arranjou briga com o aniversariante", points: 150),
      Conquest(name: "Comprou bebida de outro bar (safado)", points: 100),
      Conquest(name: "Não se chama Caio", points: 100),
      Conquest(name: "Trouxe um drinking game", points: -300),
      Conquest(name: "Foi cringe", points: -500),
      Conquest(name: "Vomitou (foi um erro honesto)", points: -500),
      Conquest(name: "Comprou algo no Agripino", points: 300),
      Conquest(name: "Apareceu sem saber do aniversário", points: 50),
      Conquest(name: "Compartilhou comida", points: 100),
      Conquest(name: "Veio do trabalho", points: 100),
      Conquest(name: "Comeu no madrugão", points: 250),
      Conquest(name: "Trouxe uma câmera fotográfica", points: 200),
      Conquest(name: "Trouxe uma Polaroid", points: 300),
      Conquest(name: "Trouxe 'brownie'", points: 420),
      Conquest(name: "Facetime com o aniversariante", points: 250),
      Conquest(name: "Bebeu em casa", points: 150),
      Conquest(name: "Devolveu algo pro aniversariante", points: 500),
      Conquest(name: "Saiu antes das 20h", points: -100),
      Conquest(name: "Pediu desconto pro garçom", points: 50),
      Conquest(name: "Pagou os 10% da mesa toda", points: 500),
      Conquest(name: "Foi com segundas intenções", points: -999),
      Conquest(name: "Venceu uma partida de Valorant", points: 450),
      Conquest(name: "Trouxe o filho/filha", points: -100),
      Conquest(name: "Ganhou uma queda de braço", points: 200),
      Conquest(name: "Falou mal do Diego", points: 50),
      Conquest(name: "Foi preso", points: 9999),
      Conquest(name: "Foi para outro aniversário", points: 100, multiple: true),
      Conquest(
        name: "Trouxe um job pro aniversariante",
        points: 777,
        multiple: true,
      ),
      Conquest(
        name: "Tem intriga com alguém no local",
        points: 150,
        multiple: true,
      ),
      Conquest(name: "Tomou um shot de saquê", points: 100, multiple: true),
      Conquest(name: "Tomou um copo de cerveja", points: 40, multiple: true),
      Conquest(name: "Tomou uma caipirinha", points: 40, multiple: true),
      Conquest(name: "Fumou um cigarro", points: -10, multiple: true),
      Conquest(name: "Trouxe um convidado", points: 100, multiple: true),
      Conquest(name: "Comeu macaxeira", points: 99, multiple: true),
      Conquest(name: "Arranjou briga", points: 50, multiple: true),
      Conquest(name: "Beijou alguém", points: -50, multiple: true),
    ];
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final conquestsJson = conquests.map((c) => c.toJson()).toList();
    await prefs.setString('conquests_data', json.encode(conquestsJson));
  }

  int get totalScore => conquests.fold(0, (sum, c) => sum + c.total);

  void reset() {
    setState(() {
      for (var c in conquests) {
        c.quantity = 0;
      }
    });
    _saveData();
  }

  void _onConquestChanged(int index, int quantity) {
    setState(() {
      conquests[index].quantity = quantity;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1a5a54),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFebd71b)),
          ),
        ),
      );
    }

    // Conquistas pendentes: as que não foram feitas OU as que são múltiplas (sempre aparecem)
    List<Conquest> pending =
        conquests.where((c) => c.quantity == 0 || c.multiple == true).toList();
    // Conquistas concluídas: apenas as que têm quantidade > 0
    List<Conquest> completed = conquests.where((c) => c.quantity > 0).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(71, 26, 90, 84),
      body: Stack(
        children: [
          // Imagem de fundo
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),
          // Sobreposição semitransparente para manter legibilidade
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(106, 26, 90, 84).withOpacity(0.7),
            ),
          ),
          // Conteúdo principal
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromARGB(75, 45, 122, 110),
              border: Border.all(color: const Color(0xFFebd71b), width: 4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                // Header com nome e score estilizado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),

                  child: Column(
                    children: [
                      if (userName.isNotEmpty)
                        Text(
                          userName.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'PlanetOpt',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFebd71b),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      if (userName.isNotEmpty) const SizedBox(height: 8),
                      Text(
                        "SCORE: $totalScore",
                        style: const TextStyle(
                          fontFamily: 'PlanetOpt',
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFebd71b),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Conteúdo principal com tabs
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          // TabBar estilizada
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TabBar(
                              indicator: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  112,
                                  102,
                                  14,
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              indicatorPadding: const EdgeInsets.all(4),
                              labelColor: const Color(0xFFebd71b),
                              unselectedLabelColor: const Color(
                                0xFFebd71b,
                              ).withOpacity(0.7),
                              tabs: const [
                                Tab(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      "MISSÕES",
                                      style: TextStyle(
                                        fontFamily: 'PlanetOpt',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      "CONCLUÍDAS",
                                      style: TextStyle(
                                        fontFamily: 'PlanetOpt',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Conteúdo das tabs
                          Expanded(
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(
                              //     color: const Color(0xFFebd71b),
                              //     width: 2,
                              //   ),
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: TabBarView(
                                  children: [
                                    // Tab Conquistas
                                    Container(
                                      color: const Color(
                                        0xFF1a5a54,
                                      ).withOpacity(0.3),
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(8),
                                        itemCount: pending.length,
                                        itemBuilder: (context, index) {
                                          final conquestIndex = conquests
                                              .indexWhere(
                                                (c) =>
                                                    c.name ==
                                                    pending[index].name,
                                              );
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: ConquestTile(
                                              conquest: pending[index],
                                              onChanged: (qtd) {
                                                _onConquestChanged(
                                                  conquestIndex,
                                                  qtd,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Tab Concluídas
                                    Container(
                                      color: const Color(
                                        0xFF1a5a54,
                                      ).withOpacity(0.0),
                                      child:
                                          completed.isEmpty
                                              ? const Center(
                                                child: Text(
                                                  "NENHUMA CONQUISTA\nCONCLUÍDA AINDA",
                                                  style: TextStyle(
                                                    fontFamily: 'PlanetOpt',
                                                    fontSize: 18,
                                                    color: Color(0xFFebd71b),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              )
                                              : ListView.builder(
                                                padding: const EdgeInsets.all(
                                                  8,
                                                ),
                                                itemCount: completed.length,
                                                itemBuilder: (context, index) {
                                                  final conquestIndex =
                                                      conquests.indexWhere(
                                                        (c) =>
                                                            c.name ==
                                                            completed[index]
                                                                .name,
                                                      );
                                                  return Container(
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                        ),
                                                    child: ConquestTile(
                                                      conquest:
                                                          completed[index],
                                                      onChanged: (qtd) {
                                                        _onConquestChanged(
                                                          conquestIndex,
                                                          qtd,
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Botão resetar estilizado
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFebd71b),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: const Color.fromARGB(
                                  111,
                                  45,
                                  122,
                                  110,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xFFebd71b),
                                    width: 2,
                                  ),
                                ),
                                title: const Text(
                                  "TEM CERTEZA?",
                                  style: TextStyle(
                                    fontFamily: 'PlanetOpt',
                                    fontSize: 25,
                                    color: Color(0xFFebd71b),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    child: const Text(
                                      "NÃO",
                                      style: TextStyle(
                                        fontFamily: 'PlanetOpt',
                                        fontSize: 25,
                                        color: Color(0xFFebd71b),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      reset();
                                    },
                                    child: const Text(
                                      "SIM",
                                      style: TextStyle(
                                        fontFamily: 'PlanetOpt',
                                        color: Color(0xFFebd71b),
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1a5a54),
                          foregroundColor: const Color(0xFFebd71b),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          "R E S E T A R",
                          style: TextStyle(
                            fontFamily: 'PlanetOpt',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFebd71b),
                          ),
                        ),
                      ),
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
