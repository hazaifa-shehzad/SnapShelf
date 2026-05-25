import 'package:flutter/material.dart';

import '../data/dummy/dummy_albums.dart';
import '../data/models/album_model.dart';

class AlbumProvider extends ChangeNotifier {
  final List<AlbumModel> _albums = List<AlbumModel>.from(DummyAlbums.albums);
  String _searchQuery = '';
  String? _selectedAlbumId;

  List<AlbumModel> get albums => List.unmodifiable(_albums);
  String get searchQuery => _searchQuery;
  String? get selectedAlbumId => _selectedAlbumId;

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

  void addAlbum(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return;

    _albums.insert(
      0,
      AlbumModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: trimmedTitle,
        photoCount: 0,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateAlbum({required String id, required String title}) {
    final index = _albums.indexWhere((album) => album.id == id);
    if (index == -1) return;

    _albums[index] = _albums[index].copyWith(title: title.trim());
    notifyListeners();
  }

  void deleteAlbum(String id) {
    _albums.removeWhere((album) => album.id == id);
    if (_selectedAlbumId == id) _selectedAlbumId = null;
    notifyListeners();
  }

  void incrementPhotoCount(String albumId, {String? coverImageUrl}) {
    final index = _albums.indexWhere((album) => album.id == albumId);
    if (index == -1) return;

    final currentAlbum = _albums[index];
    _albums[index] = currentAlbum.copyWith(
      photoCount: currentAlbum.photoCount + 1,
      coverImageUrl: coverImageUrl ?? currentAlbum.coverImageUrl,
    );
    notifyListeners();
  }

  void decrementPhotoCount(String albumId) {
    final index = _albums.indexWhere((album) => album.id == albumId);
    if (index == -1) return;

    final currentAlbum = _albums[index];
    _albums[index] = currentAlbum.copyWith(
      photoCount: currentAlbum.photoCount > 0 ? currentAlbum.photoCount - 1 : 0,
    );
    notifyListeners();
  }
}
