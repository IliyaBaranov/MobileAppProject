import 'dart:math';
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class QuoteController with ChangeNotifier {
  final LocalStorageService _storageService;
  List<String> _quotes = [];
  final List<String> _usedQuotes = [];
  String _currentQuote = '';

  QuoteController(this._storageService);

  String get currentQuote => _currentQuote;

  Future<void> initialize() async {
    _quotes = await _storageService.loadQuotesFromAssets();
    _getDailyQuote();
  }

  void _getDailyQuote() {
    if (_quotes.isEmpty) return;

    final random = Random();
    final availableQuotes = _quotes.where((q) => !_usedQuotes.contains(q)).toList();

    if (availableQuotes.isEmpty) {
      _usedQuotes.clear();
      _getDailyQuote();
      return;
    }

    _currentQuote = availableQuotes[random.nextInt(availableQuotes.length)];
    _usedQuotes.add(_currentQuote);
    notifyListeners();
  }

  void getNewQuote() {
    _getDailyQuote();
  }
}
