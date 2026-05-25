# 🎵 SoundWave — Application Flutter

Application mobile de streaming et téléchargement de musique, inspirée de Spotify.

---

## 📁 Structure du projet

```
soundwave/
├── lib/
│   ├── main.dart                    # Point d'entrée
│   ├── theme/
│   │   └── app_theme.dart           # Thème sombre global
│   ├── models/
│   │   ├── song.dart                # Modèle titre musical
│   │   └── playlist.dart            # Modèle playlist
│   ├── services/
│   │   ├── mock_data_service.dart   # Données fictives (remplacer par API)
│   │   ├── database_service.dart    # SQLite : favoris + téléchargements
│   │   └── download_service.dart    # Téléchargement MP3 via Dio
│   ├── providers/
│   │   ├── player_provider.dart     # État de lecture audio (just_audio)
│   │   └── music_provider.dart      # Chansons, favoris, téléchargements
│   ├── widgets/
│   │   ├── song_tile.dart           # Ligne chanson réutilisable
│   │   └── mini_player.dart         # Mini-player bas d'écran
│   └── screens/
│       ├── main_scaffold.dart       # Navigation principale
│       ├── home_screen.dart         # Accueil + recommandations
│       ├── search_screen.dart       # Recherche + catégories
│       ├── downloads_screen.dart    # Titres téléchargés
│       ├── playlists_screen.dart    # Liste des playlists
│       ├── playlist_screen.dart     # Détail playlist
│       ├── player_screen.dart       # Player plein écran
│       └── profile_screen.dart      # Profil utilisateur
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml      # Permissions + service audio
├── ios/
│   └── Runner/
│       └── Info.plist               # Background audio iOS
└── pubspec.yaml                     # Dépendances Flutter
```

---

## 🚀 Installation

### Prérequis
- Flutter SDK >= 3.0.0
- Android Studio ou Xcode
- Un émulateur ou appareil physique

### Étapes

```bash
# 1. Cloner / copier le projet
cd soundwave

# 2. Installer les dépendances
flutter pub get

# 3. Lancer sur un émulateur
flutter run

# 4. Build APK (Android)
flutter build apk --release

# 5. Build IPA (iOS)
flutter build ipa
```

---

## ✨ Fonctionnalités

| Fonctionnalité | Status |
|---|---|
| Lecture audio streaming | ✅ |
| Téléchargement hors-ligne | ✅ |
| Favoris (persistés SQLite) | ✅ |
| Playlists | ✅ |
| Recherche | ✅ |
| Mini-player | ✅ |
| Player plein écran | ✅ |
| Skip / Précédent | ✅ |
| Shuffle & Repeat | ✅ |
| Barre de progression | ✅ |
| Mode hors-ligne | ✅ |
| Background audio | ✅ |

---

## 🔌 Connecter une vraie API

Dans `lib/services/mock_data_service.dart`, remplace les données fictives par des appels HTTP :

```dart
// Exemple avec Dio
final response = await dio.get('https://api.monservice.com/songs');
final songs = (response.data as List).map((j) => Song.fromMap(j)).toList();
```

APIs gratuites compatibles :
- **Deezer API** — https://developers.deezer.com/api
- **Jamendo API** — https://developer.jamendo.com
- **Free Music Archive** — https://freemusicarchive.org/api

---

## 📦 Dépendances principales

| Package | Usage |
|---|---|
| `just_audio` | Lecture audio |
| `provider` | State management |
| `sqflite` | Base de données locale |
| `dio` | Téléchargements HTTP |
| `cached_network_image` | Images avec cache |
| `path_provider` | Dossiers système |
| `permission_handler` | Permissions Android/iOS |
