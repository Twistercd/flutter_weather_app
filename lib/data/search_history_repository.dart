import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryRepository {
  Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('history');
    return saved ?? [];
  }
}
