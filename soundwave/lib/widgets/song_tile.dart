import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../providers/player_provider.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap;
  final bool showDownloadBadge;

  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.showDownloadBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final music = context.watch<MusicProvider>();
    final isPlaying = player.isCurrentSong(song.id);
    final isDownloading = music.isDownloading(song.id);
    final progress = music.getProgress(song.id);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: song.albumArt,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: AppTheme.surfaceLight,
            child: const Icon(Icons.music_note, color: AppTheme.textMuted),
          ),
          errorWidget: (_, __, ___) => Container(
            color: AppTheme.surfaceLight,
            child: const Icon(Icons.music_note, color: AppTheme.textMuted),
          ),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              song.title,
              style: TextStyle(
                color: isPlaying ? AppTheme.primary : AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isPlaying)
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: _PlayingAnimation(),
            ),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              song.artist,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showDownloadBadge && song.isDownloaded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '✓ offline',
                style: TextStyle(
                  color: AppTheme.success,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            song.durationFormatted,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          const SizedBox(width: 8),
          if (isDownloading)
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 2,
                color: AppTheme.primary,
              ),
            )
          else
            _MoreButton(song: song),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _PlayingAnimation extends StatefulWidget {
  const _PlayingAnimation();

  @override
  State<_PlayingAnimation> createState() => _PlayingAnimationState();
}

class _PlayingAnimationState extends State<_PlayingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primary.withOpacity(0.4 + 0.6 * _controller.value),
        ),
      ),
    );
  }
}

class _MoreButton extends StatelessWidget {
  final Song song;
  const _MoreButton({required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: const Icon(Icons.more_vert, color: AppTheme.textMuted, size: 20),
    );
  }

  void _showOptions(BuildContext context) {
    final music = context.read<MusicProvider>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(
                music.isFavorite(song.id) ? Icons.favorite : Icons.favorite_border,
                color: music.isFavorite(song.id) ? AppTheme.accent : AppTheme.textSecondary,
              ),
              title: Text(
                music.isFavorite(song.id) ? 'Retirer des favoris' : 'Ajouter aux favoris',
                style: const TextStyle(color: AppTheme.textPrimary),
              ),
              onTap: () {
                music.toggleFavorite(song);
                Navigator.pop(context);
              },
            ),
            if (!song.isDownloaded)
              ListTile(
                leading: const Icon(Icons.download_outlined, color: AppTheme.primary),
                title: const Text('Télécharger', style: TextStyle(color: AppTheme.textPrimary)),
                onTap: () {
                  music.downloadSong(song);
                  Navigator.pop(context);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: const Text('Supprimer le téléchargement',
                    style: TextStyle(color: AppTheme.textPrimary)),
                onTap: () {
                  music.deleteDownload(song);
                  Navigator.pop(context);
                },
              ),
            ListTile(
              leading: const Icon(Icons.queue_music, color: AppTheme.textSecondary),
              title: const Text('Ajouter à la file', style: TextStyle(color: AppTheme.textPrimary)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
