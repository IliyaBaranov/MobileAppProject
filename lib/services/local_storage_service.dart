import 'package:flutter/services.dart' show rootBundle;

class LocalStorageService {
  Future<List<String>> loadQuotesFromAssets() async {
    final fileContent = await rootBundle.loadString('assets/files/quotes.txt');
    return fileContent.split('\n').where((q) => q.trim().isNotEmpty).toList();
  }
}
