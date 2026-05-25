import '../models/song.dart';
import '../models/playlist.dart';

class MockDataService {
  static List<Song> getSongs() {
    return [
      Song(
        id: '1',
        title: 'Midnight Drive',
        artist: 'Neon Pulse',
        album: 'Night Vibes',
        albumArt: 'https://picsum.photos/seed/song1/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        duration: 222,
        isFavorite: true,
      ),
      Song(
        id: '2',
        title: 'Forest Rain',
        artist: 'Ambient Echo',
        album: 'Chill Session',
        albumArt: 'https://picsum.photos/seed/song2/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
        duration: 318,
      ),
      Song(
        id: '3',
        title: 'Fire Starter',
        artist: 'The Blaze',
        album: 'Hot Hits',
        albumArt: 'https://picsum.photos/seed/song3/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
        duration: 245,
        isFavorite: true,
      ),
      Song(
        id: '4',
        title: 'Ocean Waves',
        artist: 'Blue Horizon',
        album: 'Deep Focus',
        albumArt: 'https://picsum.photos/seed/song4/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
        duration: 382,
      ),
      Song(
        id: '5',
        title: 'Electric Soul',
        artist: 'Static Flow',
        album: 'Hot Hits',
        albumArt: 'https://picsum.photos/seed/song5/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3',
        duration: 235,
      ),
      Song(
        id: '6',
        title: 'Golden Hour',
        artist: 'Sunset Collective',
        album: 'Afternoon Feels',
        albumArt: 'https://picsum.photos/seed/song6/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3',
        duration: 271,
        isFavorite: true,
      ),
      Song(
        id: '7',
        title: 'City Lights',
        artist: 'Urban Drift',
        album: 'Night Vibes',
        albumArt: 'https://picsum.photos/seed/song7/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3',
        duration: 198,
      ),
      Song(
        id: '8',
        title: 'Storm Season',
        artist: 'Thunder Road',
        album: 'Raw Energy',
        albumArt: 'https://picsum.photos/seed/song8/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3',
        duration: 304,
      ),
      Song(
        id: '9',
        title: 'Lunar Tides',
        artist: 'Neon Pulse',
        album: 'Night Vibes',
        albumArt: 'https://picsum.photos/seed/song9/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3',
        duration: 259,
      ),
      Song(
        id: '10',
        title: 'Desert Wind',
        artist: 'Sand & Sky',
        album: 'Chill Session',
        albumArt: 'https://picsum.photos/seed/song10/300/300',
        audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3',
        duration: 347,
      ),
    ];
  }

  static List<Playlist> getPlaylists() {
    final songs = getSongs();
    return [
      Playlist(
        id: 'p1',
        name: 'Night Vibes',
        description: 'Pour les nuits bien remplies',
        coverUrl: 'https://picsum.photos/seed/pl1/300/300',
        songs: [songs[0], songs[6], songs[8]],
      ),
      Playlist(
        id: 'p2',
        name: 'Chill Session',
        description: 'Détente absolue',
        coverUrl: 'https://picsum.photos/seed/pl2/300/300',
        songs: [songs[1], songs[9], songs[3]],
      ),
      Playlist(
        id: 'p3',
        name: 'Hot Hits',
        description: 'Les titres du moment',
        coverUrl: 'https://picsum.photos/seed/pl3/300/300',
        songs: [songs[2], songs[4], songs[7]],
      ),
      Playlist(
        id: 'p4',
        name: 'Deep Focus',
        description: 'Concentration maximale',
        coverUrl: 'https://picsum.photos/seed/pl4/300/300',
        songs: [songs[3], songs[1], songs[9], songs[5]],
      ),
    ];
  }
}
