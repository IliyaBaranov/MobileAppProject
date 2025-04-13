import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/quote_controller.dart';
import '../widgets/quote_card.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes of Jason Statham'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoritesScreen()),
            ),
          ),
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
      body: const _HomeScreenBody(),
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody();

  @override
  Widget build(BuildContext context) {
    final quoteController = context.watch<QuoteController>();
    final favoritesController = context.watch<FavoritesController>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QuoteCard(text: quoteController.currentQuote),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: quoteController.getNewQuote,
              child: const Text('New Quote'),
            ),
            const SizedBox(height: 20),
            _FavoriteButton(
              quote: quoteController.currentQuote,
              favoritesController: favoritesController,
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatefulWidget {
  final String quote;
  final FavoritesController favoritesController;

  const _FavoriteButton({
    required this.quote,
    required this.favoritesController,
  });

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {
  bool _isFavorite = false;
  bool _loading = true;
  String? _currentQuote; // Для отслеживания изменений цитаты

  @override
  void initState() {
    super.initState();
    _currentQuote = widget.quote;
    _checkIfFavorite();
    widget.favoritesController.addListener(_onFavoritesChanged);
  }

  @override
  void didUpdateWidget(_FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если цитата изменилась, сбрасываем состояние
    if (widget.quote != _currentQuote) {
      _currentQuote = widget.quote;
      _checkIfFavorite();
    }
  }

  @override
  void dispose() {
    widget.favoritesController.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    setState(() {
      _loading = true;
    });

    final isFav = await widget.favoritesController.isCurrentQuoteFavorite(widget.quote);

    if (mounted) {
      setState(() {
        _isFavorite = isFav;
        _loading = false;
      });
    }
  }

  Future<void> _handleFavoritePress() async {
    if (_isFavorite) {
      return;
    }

    final success = await widget.favoritesController.addQuoteToFavorites(widget.quote);

    if (success && mounted) {
      setState(() {
        _isFavorite = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote saved to favorites!')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save quote')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      onPressed: _isFavorite ? null : _handleFavoritePress,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isFavorite ? Colors.green : null,
        foregroundColor: _isFavorite ? Colors.white : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_isFavorite ? Icons.check : Icons.bookmark_add),
          const SizedBox(width: 8),
          Text(_isFavorite ? 'Saved' : 'Save to Favorites'),
        ],
      ),
    );
  }
}
