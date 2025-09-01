// lib/models/conquest.dart
class Conquest {
  final String name;
  final int points;
  final bool multiple;
  int quantity;

  Conquest({
    required this.name,
    required this.points,
    this.multiple = false,
    this.quantity = 0,
  });

  int get total => points * quantity;

  // Converte para Map para salvar no SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'points': points,
      'multiple': multiple,
      'quantity': quantity,
    };
  }

  // Cria Conquest a partir de Map do SharedPreferences
  factory Conquest.fromJson(Map<String, dynamic> json) {
    return Conquest(
      name: json['name'] as String,
      points: json['points'] as int,
      multiple: json['multiple'] as bool? ?? false,
      quantity: json['quantity'] as int? ?? 0,
    );
  }

  // Copia conquest com novos valores
  Conquest copyWith({
    String? name,
    int? points,
    bool? multiple,
    int? quantity,
  }) {
    return Conquest(
      name: name ?? this.name,
      points: points ?? this.points,
      multiple: multiple ?? this.multiple,
      quantity: quantity ?? this.quantity,
    );
  }
}
