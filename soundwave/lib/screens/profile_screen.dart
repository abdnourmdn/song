import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/music_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar
              CircleAvatar(
                radius: 44,
                backgroundColor: AppTheme.primary,
                child: const Text(
                  'A',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Ahmed',
                style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Text(
                'ahmed@email.com',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    _StatCard(label: 'Téléchargés', value: '${music.downloadedSongs.length}'),
                    const SizedBox(width: 12),
                    _StatCard(label: 'Favoris', value: '${music.favorites.length}'),
                    const SizedBox(width: 12),
                    _StatCard(label: 'Playlists', value: '${music.playlists.length}'),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Paramètres',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _SettingsTile(icon: Icons.wifi_off_rounded, title: 'Mode hors-ligne', trailing: Switch(value: false, onChanged: (_) {}, activeColor: AppTheme.primary)),
                _SettingsTile(icon: Icons.high_quality_rounded, title: 'Qualité audio', subtitle: 'Haute qualité'),
                _SettingsTile(icon: Icons.storage_rounded, title: 'Stockage utilisé', subtitle: '${(music.downloadedSongs.length * 4.2).toStringAsFixed(1)} MB'),
                const SizedBox(height: 20),
                const Text('Compte',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _SettingsTile(icon: Icons.notifications_outlined, title: 'Notifications'),
                _SettingsTile(icon: Icons.lock_outline, title: 'Confidentialité'),
                _SettingsTile(icon: Icons.help_outline, title: 'Aide & Support'),
                _SettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Se déconnecter',
                  iconColor: Colors.redAccent,
                  titleColor: Colors.redAccent,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? iconColor;
  final Color? titleColor;
  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppTheme.textSecondary, size: 20),
      ),
      title: Text(title,
          style: TextStyle(color: titleColor ?? AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppTheme.textMuted, size: 18),
      onTap: () {},
    );
  }
}
