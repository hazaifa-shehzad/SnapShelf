import '../models/album_model.dart';

class DummyAlbums {
  DummyAlbums._();

  static final List<AlbumModel> albums = [
    AlbumModel(
      id: 'album_001',
      title: 'Family',
      coverImageUrl:
          'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=900',
      photoCount: 8,
      createdAt: DateTime(2026, 2, 3),
    ),
    AlbumModel(
      id: 'album_002',
      title: 'Travel',
      coverImageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
      photoCount: 12,
      createdAt: DateTime(2026, 2, 18),
    ),
    AlbumModel(
      id: 'album_003',
      title: 'Work',
      coverImageUrl:
          'https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=900',
      photoCount: 5,
      createdAt: DateTime(2026, 3, 7),
    ),
    AlbumModel(
      id: 'album_004',
      title: 'Favorites',
      coverImageUrl:
          'https://images.unsplash.com/photo-1493612276216-ee3925520721?w=900',
      photoCount: 6,
      createdAt: DateTime(2026, 3, 22),
    ),
  ];
}
