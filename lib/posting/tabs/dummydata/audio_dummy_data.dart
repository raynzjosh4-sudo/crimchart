class AudioTrack {
  final String title;
  final String artist;
  final String duration;
  final String coverUrl;

  const AudioTrack({
    required this.title,
    required this.artist,
    required this.duration,
    required this.coverUrl,
  });
}

const List<AudioTrack> audioDummyData = [
  AudioTrack(
    title: 'Midnight City',
    artist: 'M83',
    duration: '4:03',
    coverUrl: 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?w=100',
  ),
  AudioTrack(
    title: 'Starboy',
    artist: 'The Weeknd',
    duration: '3:50',
    coverUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=100',
  ),
  AudioTrack(
    title: 'Blinding Lights',
    artist: 'The Weeknd',
    duration: '3:20',
    coverUrl: 'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?w=100',
  ),
  AudioTrack(
    title: 'Levitating',
    artist: 'Dua Lipa',
    duration: '3:23',
    coverUrl: 'https://images.unsplash.com/photo-1459749411177-042180ce673b?w=100',
  ),
];





























