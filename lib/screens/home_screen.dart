import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> quotes = [];
  String currentQuote = "";
  List<String> usedQuotes = [];

  @override
  void initState() {
    super.initState();
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    try {
      String fileContent = await rootBundle.loadString('assets/files/quotes.txt');
      setState(() {
        quotes = fileContent.split('\n').where((q) => q.trim().isNotEmpty).toList();
      });
      _getDailyQuote();
    } catch (e) {
      print("Ошибка загрузки цитат: $e");
    }
  }

  void _getDailyQuote() {
    if (quotes.isEmpty) return;

    final random = Random();
    final availableQuotes = quotes.where((q) => !usedQuotes.contains(q)).toList();

    if (availableQuotes.isNotEmpty) {
      final newQuote = availableQuotes[random.nextInt(availableQuotes.length)];
      setState(() {
        currentQuote = newQuote;
        usedQuotes.add(newQuote);
      });
    } else {
      setState(() {
        usedQuotes = [];
        _getDailyQuote();
      });
    }
  }

  void _saveQuoteToFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteQuotes = prefs.getStringList('favorites') ?? [];
    if (!favoriteQuotes.contains(currentQuote)) {
      favoriteQuotes.add(currentQuote);
      await prefs.setStringList('favorites', favoriteQuotes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quote saved to favorites!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quote already in favorites!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes of Jason Statham'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentQuote,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getDailyQuote,
                child: Text('New Quote'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveQuoteToFavorites,
                child: Text('Save to Favorites'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
