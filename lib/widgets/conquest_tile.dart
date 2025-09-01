import 'package:flutter/material.dart';
import '../models/conquest.dart';

class ConquestTile extends StatefulWidget {
  final Conquest conquest;
  final Function(int) onChanged;

  const ConquestTile({
    super.key,
    required this.conquest,
    required this.onChanged,
  });

  @override
  State<ConquestTile> createState() => _ConquestTileState();
}

class _ConquestTileState extends State<ConquestTile> {
  double opacity = 1.0;

  void _handleChange(int newQuantity) async {
    setState(() => opacity = 0.0);
    await Future.delayed(const Duration(milliseconds: 300));
    widget.onChanged(newQuantity);
    setState(() => opacity = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final conquest = widget.conquest;

    Widget cardContent = Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color:
            conquest.quantity > 0
                ? const Color.fromARGB(104, 62, 142, 126)
                : const Color.fromARGB(113, 45, 122, 110),
        border: Border.all(color: const Color(0xFFebd71b), width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conquest.name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'PlanetOpt',
                      fontSize: 20,
                      color: Color(0xFFebd71b),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "PONTOS: ${conquest.points}".toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'PlanetOpt',
                      fontSize: 16,
                      color: Color(0xFFebd71b),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
            if (conquest.multiple)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFebd71b),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      onPressed:
                          conquest.quantity > 0
                              ? () => _handleChange(conquest.quantity - 1)
                              : null,
                      icon: const Icon(
                        Icons.remove,
                        color: Color(0xFFebd71b),
                        size: 16,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 32,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1a5a54),
                      border: Border.all(
                        color: const Color(0xFFebd71b),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        "${conquest.quantity}",
                        style: const TextStyle(
                          fontFamily: 'PlanetOpt',
                          fontSize: 14,
                          color: Color(0xFFebd71b),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFebd71b),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: IconButton(
                      onPressed: () => _handleChange(conquest.quantity + 1),
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFFebd71b),
                        size: 16,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );

    if (!conquest.multiple) {
      cardContent = GestureDetector(
        onTap: () => _handleChange(conquest.quantity > 0 ? 0 : 1),
        child: cardContent,
      );
    }

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      child: cardContent,
    );
  }
}
