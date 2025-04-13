import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../controllers/favorites_controller.dart';
import '../../models/quote.dart';
import '../widgets/quote_card.dart';
import 'login_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = context.read<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Quote>>(
        stream: favoritesController.getFavoriteQuotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error loading favorites'));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final quotes = snapshot.data!;
          if (quotes.isEmpty) return Center(child: Text('No favorite quotes yet.'));

          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              final quote = quotes[index];
              return Dismissible(
                key: Key(quote.id),
                background: Container(color: Colors.red),
                onDismissed: (_) {
                  favoritesController.removeQuoteFromFavorites(quote.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Quote removed')),
                  );
                },
                child: QuoteCard(
                  text: quote.text,
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      favoritesController.removeQuoteFromFavorites(quote.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Quote removed')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      )
    );
  }
}
