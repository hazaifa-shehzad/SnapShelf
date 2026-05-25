import 'package:flutter/material.dart';

import '../data/dummy/dummy_photos.dart';
import '../data/models/photo_model.dart';
import '../data/services/share_service.dart';

class PhotoProvider extends ChangeNotifier {
  final List<PhotoModel> _photos = List<PhotoModel>.from(DummyPhotos.photos);
  String _searchQuery = '';
  PhotoModel? _selectedPhoto;

  List<PhotoModel> get photos => List.unmodifiable(_photos);
  String get searchQuery => _searchQuery;
  PhotoModel? get selectedPhoto => _selectedPhoto;

  List<PhotoModel> get recentPhotos {
    final list = List<PhotoModel>.from(_photos)
      ..sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
    return list.take(6).toList();
  }

  List<PhotoModel> get favoritePhotos {
    return _photos.where((photo) => photo.isFavorite).toList();
  }

  List<PhotoModel> get filteredPhotos {
    if (_searchQuery.trim().isEmpty) return photos;
    final query = _searchQuery.toLowerCase();
    return _photos
        .where((photo) => photo.title.toLowerCase().contains(query))
        .toList();
  }

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  List<PhotoModel> photosByAlbum(String albumId) {
    return _photos.where((photo) => photo.albumId == albumId).toList();
  }

  PhotoModel? getPhotoById(String id) {
    for (final photo in _photos) {
      if (photo.id == id) return photo;
    }
    return null;
  }

  void selectPhoto(PhotoModel photo) {
    _selectedPhoto = photo;
    notifyListeners();
  }

  void addPhoto(PhotoModel photo) {
    _photos.insert(0, photo);
    notifyListeners();
  }

  void updatePhoto(PhotoModel photo) {
    final index = _photos.indexWhere((item) => item.id == photo.id);
    if (index == -1) return;
    _photos[index] = photo;
    notifyListeners();
  }

  void deletePhoto(String id) {
    _photos.removeWhere((photo) => photo.id == id);
    if (_selectedPhoto?.id == id) _selectedPhoto = null;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    final index = _photos.indexWhere((photo) => photo.id == id);
    if (index == -1) return;

    final photo = _photos[index];
    _photos[index] = photo.copyWith(isFavorite: !photo.isFavorite);

    if (_selectedPhoto?.id == id) {
      _selectedPhoto = _photos[index];
    }
    notifyListeners();
  }

  Future<void> sharePhoto(PhotoModel photo) {
    return ShareService.sharePhotoUrl(title: photo.title, imageUrl: photo.imageUrl);
  }
}
