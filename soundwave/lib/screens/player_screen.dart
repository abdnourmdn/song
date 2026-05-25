import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final music = context.read<MusicProvider>();
    final song = player.currentSong;

    if (song == null) {
      return const Scaffold(
        body: Center(child: Text('Aucun titre en cours', style: TextStyle(color: AppTheme.textSecondary))),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32),
          color: AppTheme.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('En cours de lecture',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Album art
            Hero(
              tag: 'album-art-${song.id}',
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.3),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(
                    imageUrl: song.albumArt,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: AppTheme.surfaceLight,
                      child: const Icon(Icons.music_note, size: 80, color: AppTheme.textMuted),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Song info + favorite
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song.artist,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer<MusicProvider>(
                  builder: (ctx, m, _) => GestureDetector(
                    onTap: () => m.toggleFavorite(song),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        m.isFavorite(song.id) ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey(m.isFavorite(song.id)),
                        color: m.isFavorite(song.id) ? AppTheme.accent : AppTheme.textMuted,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Progress slider
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    trackHeight: 3,
                  ),
                  child: Slider(
                    value: player.progress.clamp(0.0, 1.0),
                    onChanged: (v) => player.seekTo(v),
                    activeColor: AppTheme.primary,
                    inactiveColor: AppTheme.surfaceLight,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(player.position),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                      Text(
                        _formatDuration(player.duration),
                        style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Main controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Shuffle
                IconButton(
                  icon: Icon(
                    Icons.shuffle_rounded,
                    color: player.isShuffled ? AppTheme.primary : AppTheme.textMuted,
                  ),
                  onPressed: player.toggleShuffle,
                ),
                // Skip back
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 36,
                  color: AppTheme.textPrimary,
                  onPressed: player.skipPrevious,
                ),
                // Play / Pause
                GestureDetector(
                  onTap: player.togglePlayPause,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: player.isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(18),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            player.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                  ),
                ),
                // Skip next
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 36,
                  color: AppTheme.textPrimary,
                  onPressed: player.skipNext,
                ),
                // Repeat
                IconButton(
                  icon: Icon(
                    player.repeatMode == RepeatMode.one
                        ? Icons.repeat_one_rounded
                        : Icons.repeat_rounded,
                    color: player.repeatMode != RepeatMode.none
                        ? AppTheme.primary
                        : AppTheme.textMuted,
                  ),
                  onPressed: player.toggleRepeat,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Extra actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<MusicProvider>(
                  builder: (ctx, m, _) => TextButton.icon(
                    onPressed: () => m.downloadSong(song),
                    icon: Icon(
                      song.isDownloaded
                          ? Icons.download_done_rounded
                          : Icons.download_outlined,
                      size: 18,
                      color: song.isDownloaded ? AppTheme.success : AppTheme.textSecondary,
                    ),
                    label: Text(
                      song.isDownloaded ? 'Téléchargé' : 'Télécharger',
                      style: TextStyle(
                        fontSize: 12,
                        color: song.isDownloaded ? AppTheme.success : AppTheme.textSecondary,
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.queue_music, size: 18, color: AppTheme.textSecondary),
                  label: const Text(
                    'File d\'attente',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share_outlined, size: 18, color: AppTheme.textSecondary),
                  label: const Text(
                    'Partager',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
