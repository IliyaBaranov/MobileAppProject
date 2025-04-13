import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../controllers/auth_controller.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signIn(BuildContext context, Future<void> Function() signInMethod) async {
    try {
      await signInMethod();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = AuthController();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Jason Stathem quotes', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 40),
              if (user != null) ...[
                Text('Signed in as: ${user.isAnonymous ? 'Anonymous' : user.email ?? 'User'}'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('Sign out'),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await GoogleSignIn().signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.arrow_forward),
                  label: Text('Continue'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                    );
                  },
                ),
              ] else ...[
                ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  label: Text('Sign in with Google'),
                  onPressed: () => _signIn(context, authController.signInWithGoogle),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.person_outline),
                  label: Text('Continue Anonymously'),
                  onPressed: () => _signIn(context, authController.signInAnonymously),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
