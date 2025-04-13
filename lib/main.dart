import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/quote_controller.dart';
import 'services/firestore_service.dart';
import 'services/local_storage_service.dart';
import 'views/screens/home_screen.dart';
import 'views/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localStorageService = LocalStorageService();
  final firestoreService = FirestoreService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => QuoteController(localStorageService)..initialize()),
        Provider(create: (_) => FavoritesController(firestoreService)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
