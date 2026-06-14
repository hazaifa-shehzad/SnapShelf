import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../data/models/album_model.dart';

class AlbumProvider extends ChangeNotifier {
  final List<AlbumModel> _albums = <AlbumModel>[];
  String _searchQuery = '';
  String? _selectedAlbumId;
  bool _isLoading = false;
  String? _errorMessage;

  AlbumProvider({bool loadOnCreate = true}) {
    if (loadOnCreate) {
      refreshAlbums();
    }
  }

  List<AlbumModel> get albums => List.unmodifiable(_albums);
  String get searchQuery => _searchQuery;
  String? get selectedAlbumId => _selectedAlbumId;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<AlbumModel> get filteredAlbums {
    if (_searchQuery.trim().isEmpty) return albums;
    final query = _searchQuery.toLowerCase();
    return _albums
        .where((album) => album.title.toLowerCase().contains(query))
        .toList();
  }

  AlbumModel? get selectedAlbum {
    if (_selectedAlbumId == null) return null;
    return getAlbumById(_selectedAlbumId!);
  }

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void selectAlbum(String albumId) {
    _selectedAlbumId = albumId;
    notifyListeners();
  }

  AlbumModel? getAlbumById(String id) {
    for (final album in _albums) {
      if (album.id == id) return album;
    }
    return null;
  }

  Future<void> refreshAlbums() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      _albums.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('albums')
          .where('userId', isEqualTo: userId)
          .get();

      _albums
        ..clear()
        ..addAll(
          snapshot.docs.map((doc) {
            final data = doc.data();
            return AlbumModel.fromJson({...data, 'id': data['id'] ?? doc.id});
          }),
        )
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<AlbumModel?> addAlbum(String title) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return null;

    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
    final docRef = FirebaseFirestore.instance.collection('albums').doc();
    final now = DateTime.now();
    final album = AlbumModel(
      id: docRef.id,
      userId: userId,
      title: trimmedTitle,
      description: '',
      coverLocalPath: '',
      coverPhotoId: '',
      color: 'purple',
      photoCount: 0,
      createdAt: now,
      updatedAt: now,
    );

    await docRef.set({
      ...album.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _albums.insert(0, album);
    notifyListeners();
    return album;
  }

  Future<void> updateAlbum({required String id, required String title}) async {
    final index = _albums.indexWhere((album) => album.id == id);
    if (index == -1) return;

    final updatedAlbum = _albums[index].copyWith(
      title: title.trim(),
      updatedAt: DateTime.now(),
    );

    await FirebaseFirestore.instance.collection('albums').doc(id).update({
      'title': updatedAlbum.title,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _albums[index] = updatedAlbum;
    notifyListeners();
  }

  Future<void> deleteAlbum(String id) async {
    await FirebaseFirestore.instance.collection('albums').doc(id).delete();
    _albums.removeWhere((album) => album.id == id);
    if (_selectedAlbumId == id) _selectedAlbumId = null;
    notifyListeners();
  }

  void applyUploadedPhoto({
    required String albumId,
    required String photoId,
    required String localPath,
  }) {
    final index = _albums.indexWhere((album) => album.id == albumId);
    if (index == -1) return;

    final currentAlbum = _albums[index];
    _albums[index] = currentAlbum.copyWith(
      photoCount: currentAlbum.photoCount + 1,
      coverLocalPath: currentAlbum.coverLocalPath.isEmpty
          ? localPath
          : currentAlbum.coverLocalPath,
      coverPhotoId: currentAlbum.coverPhotoId.isEmpty
          ? photoId
          : currentAlbum.coverPhotoId,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }

  void syncAlbum(AlbumModel album) {
    final index = _albums.indexWhere((item) => item.id == album.id);
    if (index == -1) {
      _albums.insert(0, album);
    } else {
      _albums[index] = album;
    }
    notifyListeners();
  }

  Future<void> decrementPhotoCount(String albumId) async {
    final index = _albums.indexWhere((album) => album.id == albumId);
    if (index == -1) return;

    final currentAlbum = _albums[index];
    final nextCount = currentAlbum.photoCount > 0
        ? currentAlbum.photoCount - 1
        : 0;

    await FirebaseFirestore.instance.collection('albums').doc(albumId).update({
      'photoCount': nextCount,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    _albums[index] = currentAlbum.copyWith(
      photoCount: nextCount,
      updatedAt: DateTime.now(),
    );
    notifyListeners();
  }
}
