import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/song.dart';
import 'database_service.dart';

enum DownloadStatus { idle, downloading, completed, failed }

class DownloadProgress {
  final String songId;
  final double progress;
  final DownloadStatus status;

  DownloadProgress({
    required this.songId,
    required this.progress,
    required this.status,
  });
}

class DownloadService {
  static final Dio _dio = Dio();
  static final Map<String, CancelToken> _cancelTokens = {};

  static Future<String> _getDownloadDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory(path.join(dir.path, 'downloads'));
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }
    return downloadDir.path;
  }

  static Future<Song> downloadSong(
    Song song, {
    Function(double progress)? onProgress,
  }) async {
    final downloadDir = await _getDownloadDir();
    final fileName = '${song.id}_${song.title.replaceAll(' ', '_')}.mp3';
    final filePath = path.join(downloadDir, fileName);

    final cancelToken = CancelToken();
    _cancelTokens[song.id] = cancelToken;

    try {
      await _dio.download(
        song.audioUrl,
        filePath,
        cancelToken: cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress?.call(received / total);
          }
        },
      );

      final downloadedSong = song.copyWith(
        isDownloaded: true,
        localPath: filePath,
      );

      await DatabaseService.saveDownloadedSong(downloadedSong);
      _cancelTokens.remove(song.id);
      return downloadedSong;
    } catch (e) {
      // Clean up partial file
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      _cancelTokens.remove(song.id);
      rethrow;
    }
  }

  static void cancelDownload(String songId) {
    _cancelTokens[songId]?.cancel('User cancelled');
    _cancelTokens.remove(songId);
  }

  static Future<void> deleteDownload(Song song) async {
    if (song.localPath != null) {
      final file = File(song.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await DatabaseService.deleteDownloadedSong(song.id);
  }

  static Future<bool> fileExists(String? localPath) async {
    if (localPath == null) return false;
    return File(localPath).exists();
  }
}
