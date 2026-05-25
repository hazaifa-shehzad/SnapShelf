import '../models/photo_model.dart';

class DummyPhotos {
  DummyPhotos._();

  static final List<PhotoModel> photos = [
    PhotoModel(
      id: 'photo_001',
      albumId: 'album_001',
      title: 'Family dinner',
      imageUrl:
          'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=900',
      size: '2.4 MB',
      isFavorite: true,
      uploadedAt: DateTime(2026, 4, 1),
    ),
    PhotoModel(
      id: 'photo_002',
      albumId: 'album_001',
      title: 'Weekend moment',
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900',
      size: '1.8 MB',
      uploadedAt: DateTime(2026, 4, 4),
    ),
    PhotoModel(
      id: 'photo_003',
      albumId: 'album_002',
      title: 'Mountain trip',
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=900',
      size: '3.1 MB',
      isFavorite: true,
      uploadedAt: DateTime(2026, 4, 8),
    ),
    PhotoModel(
      id: 'photo_004',
      albumId: 'album_002',
      title: 'City walk',
      imageUrl:
          'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=900',
      size: '2.0 MB',
      uploadedAt: DateTime(2026, 4, 12),
    ),
    PhotoModel(
      id: 'photo_005',
      albumId: 'album_003',
      title: 'Workspace',
      imageUrl:
          'https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=900',
      size: '1.6 MB',
      uploadedAt: DateTime(2026, 4, 15),
    ),
    PhotoModel(
      id: 'photo_006',
      albumId: 'album_004',
      title: 'Golden memory',
      imageUrl:
          'https://images.unsplash.com/photo-1493612276216-ee3925520721?w=900',
      size: '2.9 MB',
      isFavorite: true,
      uploadedAt: DateTime(2026, 4, 20),
    ),
  ];
}
