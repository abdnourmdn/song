import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

enum RepeatMode { none, one, all }

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  Song? _currentSong;
  List<Song> _queue = [];
  int _currentIndex = -1;
  bool _isPlaying = false;
  bool _isLoading = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  RepeatMode _repeatMode = RepeatMode.none;
  bool _isShuffled = false;

  // Getters
  Song? get currentSong => _currentSong;
  List<Song> get queue => _queue;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  Duration get position => _position;
  Duration get duration => _duration;
  RepeatMode get repeatMode => _repeatMode;
  bool get isShuffled => _isShuffled;

  double get progress {
    if (_duration.inSeconds == 0) return 0;
    return _position.inSeconds / _duration.inSeconds;
  }

  PlayerProvider() {
    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      _isLoading = state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;

      if (state.processingState == ProcessingState.completed) {
        _onSongCompleted();
      }
      notifyListeners();
    });

    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.durationStream.listen((dur) {
      if (dur != null) {
        _duration = dur;
        notifyListeners();
      }
    });
  }

  Future<void> playSong(Song song, {List<Song>? queue}) async {
    if (queue != null) {
      _queue = List.from(queue);
      _currentIndex = queue.indexWhere((s) => s.id == song.id);
      if (_currentIndex == -1) {
        _queue.insert(0, song);
        _currentIndex = 0;
      }
    } else if (_currentSong?.id != song.id) {
      _queue = [song];
      _currentIndex = 0;
    }

    _currentSong = song;
    _isLoading = true;
    notifyListeners();

    try {
      final url = song.localPath ?? song.audioUrl;
      if (song.localPath != null) {
        await _player.setFilePath(song.localPath!);
      } else {
        await _player.setUrl(url);
      }
      await _player.play();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error playing song: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> seekTo(double value) async {
    if (_duration == Duration.zero) return;
    final position = Duration(seconds: (value * _duration.inSeconds).round());
    await _player.seek(position);
  }

  Future<void> skipNext() async {
    if (_queue.isEmpty) return;
    int nextIndex;
    if (_isShuffled) {
      nextIndex = (List.generate(_queue.length, (i) => i)..shuffle()).first;
    } else {
      nextIndex = _currentIndex + 1;
      if (nextIndex >= _queue.length) {
        if (_repeatMode == RepeatMode.all) {
          nextIndex = 0;
        } else {
          return;
        }
      }
    }
    _currentIndex = nextIndex;
    await playSong(_queue[_currentIndex]);
  }

  Future<void> skipPrevious() async {
    if (_queue.isEmpty) return;
    if (_position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }
    int prevIndex = _currentIndex - 1;
    if (prevIndex < 0) {
      if (_repeatMode == RepeatMode.all) {
        prevIndex = _queue.length - 1;
      } else {
        await _player.seek(Duration.zero);
        return;
      }
    }
    _currentIndex = prevIndex;
    await playSong(_queue[_currentIndex]);
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.none:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.none;
        break;
    }
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  void _onSongCompleted() {
    switch (_repeatMode) {
      case RepeatMode.one:
        _player.seek(Duration.zero);
        _player.play();
        break;
      case RepeatMode.all:
      case RepeatMode.none:
        skipNext();
        break;
    }
  }

  bool isCurrentSong(String songId) => _currentSong?.id == songId;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
