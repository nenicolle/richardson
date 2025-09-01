// lib/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/conquest.dart';

class StorageService {
  static const String _userNameKey = 'user_name';
  static const String _conquestsKey = 'conquests_data';

  // Salva o nome do usuário
  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  // Carrega o nome do usuário
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Salva as conquistas
  static Future<void> saveConquests(List<Conquest> conquests) async {
    final prefs = await SharedPreferences.getInstance();
    final conquestsJson = conquests.map((c) => c.toJson()).toList();
    await prefs.setString(_conquestsKey, json.encode(conquestsJson));
  }

  // Carrega as conquistas
  static Future<List<Conquest>?> getConquests() async {
    final prefs = await SharedPreferences.getInstance();
    final savedConquests = prefs.getString(_conquestsKey);

    if (savedConquests != null) {
      try {
        final List<dynamic> conquestsList = json.decode(savedConquests);
        return conquestsList
            .map((json) => Conquest.fromJson(json as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Limpa todos os dados
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Verifica se é a primeira vez que o app é aberto
  static Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString(_userNameKey);
    return userName == null || userName.isEmpty;
  }
}
