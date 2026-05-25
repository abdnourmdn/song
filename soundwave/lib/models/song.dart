class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String albumArt;      // URL or local path
  final String audioUrl;      // Streaming URL
  final int duration;         // in seconds
  final bool isDownloaded;
  final String? localPath;    // local file path if downloaded
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArt,
    required this.audioUrl,
    required this.duration,
    this.isDownloaded = false,
    this.localPath,
    this.isFavorite = false,
  });

  String get durationFormatted {
    final m = duration ~/ 60;
    final s = (duration % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? albumArt,
    String? audioUrl,
    int? duration,
    bool? isDownloaded,
    String? localPath,
    bool? isFavorite,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArt: albumArt ?? this.albumArt,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      localPath: localPath ?? this.localPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArt': albumArt,
      'audioUrl': audioUrl,
      'duration': duration,
      'isDownloaded': isDownloaded ? 1 : 0,
      'localPath': localPath,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      albumArt: map['albumArt'],
      audioUrl: map['audioUrl'],
      duration: map['duration'],
      isDownloaded: map['isDownloaded'] == 1,
      localPath: map['localPath'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
