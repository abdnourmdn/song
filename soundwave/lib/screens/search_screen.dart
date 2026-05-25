import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    context.read<MusicProvider>().setSearchQuery('');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    final hasQuery = music.searchQuery.isNotEmpty;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Recherche',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              controller: _controller,
              focusNode: _focus,
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
              onChanged: music.setSearchQuery,
              decoration: InputDecoration(
                hintText: 'Titres, artistes, albums...',
                hintStyle: const TextStyle(color: AppTheme.textMuted, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
                suffixIcon: hasQuery
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppTheme.textMuted),
                        onPressed: () {
                          _controller.clear();
                          music.setSearchQuery('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Results
        Expanded(
          child: hasQuery
              ? music.allSongs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off, color: AppTheme.textMuted, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            'Aucun résultat pour "${music.searchQuery}"',
                            style: const TextStyle(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: music.allSongs.length,
                      itemBuilder: (ctx, i) {
                        final song = music.allSongs[i];
                        return SongTile(
                          song: song,
                          onTap: () {
                            ctx.read<PlayerProvider>().playSong(
                              song,
                              queue: music.allSongs,
                            );
                          },
                        );
                      },
                    )
              : _BrowseCategories(),
        ),
      ],
    );
  }
}

class _BrowseCategories extends StatelessWidget {
  final categories = const [
    {'label': 'Chill', 'emoji': '🌿', 'color': Color(0xFF0D1F1A)},
    {'label': 'Hip-Hop', 'emoji': '🎤', 'color': Color(0xFF1F1A0D)},
    {'label': 'Electronic', 'emoji': '⚡', 'color': Color(0xFF0D1830)},
    {'label': 'Rock', 'emoji': '🎸', 'color': Color(0xFF1F0D0D)},
    {'label': 'Jazz', 'emoji': '🎷', 'color': Color(0xFF1A100D)},
    {'label': 'Classique', 'emoji': '🎻', 'color': Color(0xFF1A1030)},
    {'label': 'R&B', 'emoji': '🎵', 'color': Color(0xFF1F0D1A)},
    {'label': 'Ambient', 'emoji': '🌌', 'color': Color(0xFF0D0D1F)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parcourir par genre',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.4,
              ),
              itemCount: categories.length,
              itemBuilder: (_, i) {
                final cat = categories[i];
                return Container(
                  decoration: BoxDecoration(
                    color: cat['color'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cat['emoji'] as String, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        cat['label'] as String,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
