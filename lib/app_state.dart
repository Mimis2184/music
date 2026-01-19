import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool initialized = false;

  String? lastMood;

  // Voice memory
  String lastVoiceText = '';
  String lastDetectedMood = '';

  String get lastVoiceMood => lastDetectedMood;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    lastMood = prefs.getString('lastMood');
    lastVoiceText = prefs.getString('lastVoiceText') ?? '';
    lastDetectedMood = prefs.getString('lastDetectedMood') ?? '';

    initialized = true;
    notifyListeners();
  }

  Future<void> setMood(String? mood) async {
    lastMood = mood;
    final prefs = await SharedPreferences.getInstance();

    if (mood == null) {
      await prefs.remove('lastMood');
    } else {
      await prefs.setString('lastMood', mood);
    }

    notifyListeners();
  }

  Future<void> setVoiceResult({
    required String text,
    required String mood,
  }) async {
    lastVoiceText = text;
    lastDetectedMood = mood;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastVoiceText', text);
    await prefs.setString('lastDetectedMood', mood);

    notifyListeners();
  }

  Future<void> clearAll() async {
    lastMood = null;
    lastVoiceText = '';
    lastDetectedMood = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastMood');
    await prefs.remove('lastVoiceText');
    await prefs.remove('lastDetectedMood');

    notifyListeners();
  }
}
