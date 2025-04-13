import 'package:cloud_firestore/cloud_firestore.dart';

class Quote {
  final String id;
  final String text;
  final DateTime? timestamp;

  Quote({
    required this.id,
    required this.text,
    this.timestamp,
  });

  factory Quote.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Quote(
      id: doc.id,
      text: data['quote'] ?? '',
      timestamp: data['timestamp']?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'quote': text,
      'timestamp': timestamp ?? FieldValue.serverTimestamp(),
    };
  }
}