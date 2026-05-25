import 'song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String coverUrl;
  final List<Song> songs;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverUrl,
    this.songs = const [],
  });

  int get totalDuration => songs.fold(0, (sum, s) => sum + s.duration);

  String get totalDurationFormatted {
    final total = totalDuration;
    final h = total ~/ 3600;
    final m = (total % 3600) ~/ 60;
    if (h > 0) return '${h}h ${m}min';
    return '${m} min';
  }
}
