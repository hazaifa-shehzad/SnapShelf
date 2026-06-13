import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/album_model.dart';

class AlbumProvider extends ChangeNotifier {
  static const String _storageKey = 'albums';

  final List<AlbumModel> _albums = <AlbumModel>[];
  String _searchQuery = '';
  String? _selectedAlbumId;

  AlbumProvider() {
    _loadAlbums();
  }

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

  AlbumModel? addAlbum(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return null;

    final album = AlbumModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: trimmedTitle,
      photoCount: 0,
      createdAt: DateTime.now(),
    );
    _albums.insert(0, album);
    notifyListeners();
    _saveAlbums();
    return album;
  }

  void updateAlbum({required String id, required String title}) {
    final index = _albums.indexWhere((album) => album.id == id);
    if (index == -1) return;

    _albums[index] = _albums[index].copyWith(title: title.trim());
    notifyListeners();
    _saveAlbums();
  }

  void deleteAlbum(String id) {
    _albums.removeWhere((album) => album.id == id);
    if (_selectedAlbumId == id) _selectedAlbumId = null;
    notifyListeners();
    _saveAlbums();
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
    _saveAlbums();
  }

  void decrementPhotoCount(String albumId) {
    final index = _albums.indexWhere((album) => album.id == albumId);
    if (index == -1) return;

    final currentAlbum = _albums[index];
    _albums[index] = currentAlbum.copyWith(
      photoCount: currentAlbum.photoCount > 0 ? currentAlbum.photoCount - 1 : 0,
    );
    notifyListeners();
    _saveAlbums();
  }

  Future<void> _loadAlbums() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedAlbums = preferences.getString(_storageKey);
    if (encodedAlbums == null || encodedAlbums.isEmpty || _albums.isNotEmpty) {
      return;
    }

    final Object? decodedAlbums;
    try {
      decodedAlbums = jsonDecode(encodedAlbums);
    } catch (_) {
      return;
    }

    if (decodedAlbums is! List) return;

    _albums
      ..clear()
      ..addAll(
        decodedAlbums.whereType<Map>().map(
          (json) => AlbumModel.fromJson(Map<String, dynamic>.from(json)),
        ),
      );
    notifyListeners();
  }

  Future<void> _saveAlbums() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedAlbums = jsonEncode(
      _albums.map((album) => album.toJson()).toList(growable: false),
    );
    await preferences.setString(_storageKey, encodedAlbums);
  }
}
