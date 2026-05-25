import 'package:flutter/foundation.dart';
import '../models/song.dart';
import '../models/playlist.dart';
import '../services/mock_data_service.dart';
import '../services/database_service.dart';
import '../services/download_service.dart';

class MusicProvider extends ChangeNotifier {
  List<Song> _allSongs = [];
  List<Song> _downloadedSongs = [];
  List<Song> _favorites = [];
  List<Playlist> _playlists = [];
  String _searchQuery = '';
  final Map<String, double> _downloadProgress = {};
  final Set<String> _downloadingIds = {};

  // Getters
  List<Song> get allSongs => _searchQuery.isEmpty
      ? _allSongs
      : _allSongs.where((s) =>
          s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.artist.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.album.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

  List<Song> get downloadedSongs => _downloadedSongs;
  List<Song> get favorites => _favorites;
  List<Playlist> get playlists => _playlists;
  String get searchQuery => _searchQuery;
  Map<String, double> get downloadProgress => _downloadProgress;
  Set<String> get downloadingIds => _downloadingIds;

  bool isDownloaded(String songId) =>
      _downloadedSongs.any((s) => s.id == songId);
  bool isFavorite(String songId) => _favorites.any((s) => s.id == songId);
  bool isDownloading(String songId) => _downloadingIds.contains(songId);
  double getProgress(String songId) => _downloadProgress[songId] ?? 0.0;

  Future<void> init() async {
    _allSongs = MockDataService.getSongs();
    _playlists = MockDataService.getPlaylists();
    _downloadedSongs = await DatabaseService.getDownloadedSongs();
    _favorites = await DatabaseService.getFavorites();

    // Sync downloaded state
    for (int i = 0; i < _allSongs.length; i++) {
      final downloaded = _downloadedSongs.firstWhere(
        (d) => d.id == _allSongs[i].id,
        orElse: () => _allSongs[i],
      );
      if (downloaded.isDownloaded) {
        _allSongs[i] = _allSongs[i].copyWith(
          isDownloaded: true,
          localPath: downloaded.localPath,
        );
      }
      if (isFavorite(_allSongs[i].id)) {
        _allSongs[i] = _allSongs[i].copyWith(isFavorite: true);
      }
    }

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> downloadSong(Song song) async {
    if (_downloadingIds.contains(song.id)) return;

    _downloadingIds.add(song.id);
    _downloadProgress[song.id] = 0.0;
    notifyListeners();

    try {
      final downloaded = await DownloadService.downloadSong(
        song,
        onProgress: (progress) {
          _downloadProgress[song.id] = progress;
          notifyListeners();
        },
      );

      _downloadedSongs.add(downloaded);
      _updateSongInList(downloaded);
    } catch (e) {
      debugPrint('Download failed: $e');
    } finally {
      _downloadingIds.remove(song.id);
      _downloadProgress.remove(song.id);
      notifyListeners();
    }
  }

  Future<void> deleteDownload(Song song) async {
    await DownloadService.deleteDownload(song);
    _downloadedSongs.removeWhere((s) => s.id == song.id);
    _updateSongInList(song.copyWith(isDownloaded: false, localPath: null));
    notifyListeners();
  }

  Future<void> toggleFavorite(Song song) async {
    if (isFavorite(song.id)) {
      await DatabaseService.removeFavorite(song.id);
      _favorites.removeWhere((s) => s.id == song.id);
      _updateSongInList(song.copyWith(isFavorite: false));
    } else {
      final favSong = song.copyWith(isFavorite: true);
      await DatabaseService.addFavorite(favSong);
      _favorites.add(favSong);
      _updateSongInList(favSong);
    }
    notifyListeners();
  }

  void _updateSongInList(Song updatedSong) {
    final idx = _allSongs.indexWhere((s) => s.id == updatedSong.id);
    if (idx != -1) {
      _allSongs[idx] = updatedSong;
    }
  }
}
