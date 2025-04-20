# Quote App

A Flutter-based quote app powered by Firebase that allows users to browse, save, and manage favorite Jason Statham quotes. The app supports anonymous and Google sign-in, making it easy for users to get started quickly.

## Tech Stack

**Frontend**
- Flutter
- Provider for state management

**Backend**
- Firebase Authentication
- Firebase Firestore
- Firebase Core

**Storage**
- Local storage using asset files for static quotes
- Cloud Firestore for dynamic user favorites

## Features

**Authentication**
- Anonymous sign-in
- Google Sign-In
- Authentication state persistence

**Quote Management**
- Random daily quotes
- Avoids repetition until all quotes are shown
- Fetches quotes from local asset file

**Favorites**
- Add or remove quotes from favorites
- Favorites stored per user in Firestore
- Real-time updates with StreamBuilder
- Dismissible list and delete options

**UI**
- Clean Material UI
- Quote cards with action buttons
- Snackbars for feedback
- Navigation between login home and favorites screens

## Folder Structure

- `controllers` contains app logic such as QuoteController and FavoritesController
- `services` contains integration logic for Firestore and local assets
- `views` contains all UI widgets and screens
- `models` contains Quote model for serialization and mapping

## Constants

Constants like messages titles and collection paths are centralized in `constants.dart`

## Authentication Logic

AuthController handles both anonymous and Google sign-in with FirebaseAuth and GoogleSignIn

## Firebase

Firestore is structured with the following path for storing user favorites:
