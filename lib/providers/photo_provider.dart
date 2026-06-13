import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/photo_model.dart';
import '../data/services/share_service.dart';

class PhotoProvider extends ChangeNotifier {
  static const String _storageKey = 'photos';

  final List<PhotoModel> _photos = <PhotoModel>[];
  String _searchQuery = '';
  PhotoModel? _selectedPhoto;

  PhotoProvider() {
    _loadPhotos();
  }

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
    _savePhotos();
  }

  void updatePhoto(PhotoModel photo) {
    final index = _photos.indexWhere((item) => item.id == photo.id);
    if (index == -1) return;
    _photos[index] = photo;
    notifyListeners();
    _savePhotos();
  }

  void deletePhoto(String id) {
    _photos.removeWhere((photo) => photo.id == id);
    if (_selectedPhoto?.id == id) _selectedPhoto = null;
    notifyListeners();
    _savePhotos();
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
    _savePhotos();
  }

  Future<void> sharePhoto(PhotoModel photo) {
    return ShareService.sharePhotoUrl(
      title: photo.title,
      imageUrl: photo.imageUrl,
    );
  }

  Future<void> _loadPhotos() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedPhotos = preferences.getString(_storageKey);
    if (encodedPhotos == null || encodedPhotos.isEmpty || _photos.isNotEmpty) {
      return;
    }

    final Object? decodedPhotos;
    try {
      decodedPhotos = jsonDecode(encodedPhotos);
    } catch (_) {
      return;
    }

    if (decodedPhotos is! List) return;

    _photos
      ..clear()
      ..addAll(
        decodedPhotos.whereType<Map>().map(
          (json) => PhotoModel.fromJson(Map<String, dynamic>.from(json)),
        ),
      );
    notifyListeners();
  }

  Future<void> _savePhotos() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedPhotos = jsonEncode(
      _photos.map((photo) => photo.toJson()).toList(growable: false),
    );
    await preferences.setString(_storageKey, encodedPhotos);
  }
}
