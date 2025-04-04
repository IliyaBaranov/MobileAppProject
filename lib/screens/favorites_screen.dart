import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<String> favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes = prefs.getStringList('favorites') ?? [];
    });
  }

  void _deleteQuote(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteQuotes.removeAt(index);
    });
    await prefs.setStringList('favorites', favoriteQuotes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes'),
      ),
      body: favoriteQuotes.isEmpty
          ? Center(child: Text('No favorite quotes yet.'))
          : ListView.builder(
        itemCount: favoriteQuotes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(favoriteQuotes[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteQuote(index),
            ),
          );
        },
      ),
    );
  }
}
