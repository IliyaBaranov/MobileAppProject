import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/firestore_service.dart';

class FavoritesController extends ChangeNotifier {
  final FirestoreService _firestoreService;

  FavoritesController(this._firestoreService);

  Stream<List<Quote>> getFavoriteQuotes() {
    return _firestoreService.getFavoriteQuotes();
  }

  Future<bool> isCurrentQuoteFavorite(String quoteText) async {
    final favorites = await getFavoriteQuotes().first;
    return favorites.any((q) => q.text == quoteText);
  }

  Future<bool> addQuoteToFavorites(String quoteText) async {
    try {
      final exists = await _firestoreService.isQuoteAlreadyFavorite(quoteText);
      if (exists) return false;

      final quote = Quote(id: '', text: quoteText);
      await _firestoreService.addQuoteToFavorites(quote);
      notifyListeners(); // Уведомляем слушателей об изменении
      return true;
    } catch (e) {
      debugPrint('Error adding favorite: $e');
      return false;
    }
  }

  Future<void> removeQuoteFromFavorites(String quoteId) async {
    try {
      await _firestoreService.deleteFavoriteQuote(quoteId);
      notifyListeners(); // Уведомляем слушателей об изменении
    } catch (e) {
      debugPrint('Error removing favorite: $e');
    }
  }
}