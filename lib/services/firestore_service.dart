import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FirestoreService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  Future<void> addQuoteToFavorites(Quote quote) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('userFavorites')
        .doc(user.uid)
        .collection('quotes')
        .add({
      'quote': quote.text,
      'timestamp': FieldValue.serverTimestamp(), // **FIXED: Make sure timestamp is added**
    });
  }

  Future<bool> isQuoteAlreadyFavorite(String quoteText) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final query = await _firestore
        .collection('userFavorites')
        .doc(user.uid)
        .collection('quotes')
        .where('quote', isEqualTo: quoteText)
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  Stream<List<Quote>> getFavoriteQuotes() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.error('User not authenticated');
    }

    return _firestore
        .collection('userFavorites')
        .doc(user.uid)
        .collection('quotes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Quote(id: doc.id, text: doc['quote'])).toList());
  }

  Future<void> deleteFavoriteQuote(String quoteId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('userFavorites')
        .doc(user.uid)
        .collection('quotes')
        .doc(quoteId)
        .delete();
  }
}
