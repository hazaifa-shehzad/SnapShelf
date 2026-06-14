import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/photo_model.dart';
import '../data/services/share_service.dart';

class PhotoProvider extends ChangeNotifier {
  final List<PhotoModel> _photos = <PhotoModel>[];
  String _searchQuery = '';
  PhotoModel? _selectedPhoto;
  bool _isLoading = false;
  String? _errorMessage;

  PhotoProvider({bool loadOnCreate = true}) {
    if (loadOnCreate) {
      refreshPhotos();
    }
  }

  List<PhotoModel> get photos => List.unmodifiable(_photos);
  String get searchQuery => _searchQuery;
  PhotoModel? get selectedPhoto => _selectedPhoto;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<PhotoModel> get recentPhotos {
    final list = List<PhotoModel>.from(_photos)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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

  Future<void> refreshPhotos() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _photos.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('photos')
          .where('userId', isEqualTo: userId)
          .get();

      _photos
        ..clear()
        ..addAll(
          snapshot.docs.map((doc) {
            final data = doc.data();
            return PhotoModel.fromJson({...data, 'id': data['id'] ?? doc.id});
          }),
        )
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void addPhoto(PhotoModel photo) {
    _photos.removeWhere((item) => item.id == photo.id);
    _photos.insert(0, photo);
    notifyListeners();
  }

  void updatePhoto(PhotoModel photo) {
    final index = _photos.indexWhere((item) => item.id == photo.id);
    if (index == -1) return;
    _photos[index] = photo;
    notifyListeners();
  }

  Future<void> deletePhoto(String id) async {
    await FirebaseFirestore.instance.collection('photos').doc(id).delete();
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
    return ShareService.sharePhoto(
      title: photo.title,
      localPath: photo.localPath,
    );
  }
}
