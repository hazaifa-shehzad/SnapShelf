import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/photo_model.dart';
import '../data/models/upload_model.dart';
import '../data/services/image_picker_service.dart';
import '../data/services/local_photo_storage_service.dart';
import 'album_provider.dart';
import 'photo_provider.dart';

class UploadProvider extends ChangeNotifier {
  UploadProvider({
    ImagePickerService? imagePickerService,
    LocalPhotoStorageService? localPhotoStorageService,
  }) : _imagePickerService = imagePickerService ?? ImagePickerService(),
       _localPhotoStorageService =
           localPhotoStorageService ?? const LocalPhotoStorageService();

  final ImagePickerService _imagePickerService;
  final LocalPhotoStorageService _localPhotoStorageService;

  final List<XFile> _selectedImages = <XFile>[];
  String? _selectedAlbumId;
  String _caption = '';
  UploadStatus _status = UploadStatus.idle;
  double _progress = 0;
  String? _errorMessage;

  XFile? get selectedImage =>
      _selectedImages.isEmpty ? null : _selectedImages.first;
  List<XFile> get selectedImages => List.unmodifiable(_selectedImages);
  String? get selectedAlbumId => _selectedAlbumId;
  String get caption => _caption;
  UploadStatus get status => _status;
  double get progress => _progress;
  String? get errorMessage => _errorMessage;

  bool get hasSelectedImage => _selectedImages.isNotEmpty;
  bool get canUpload => _selectedImages.isNotEmpty && _selectedAlbumId != null;
  bool get isUploading => _status == UploadStatus.uploading;

  Future<void> pickFromGallery() async {
    final image = await _imagePickerService.pickFromGallery();
    if (image == null) return;
    selectImages([image]);
  }

  Future<void> pickMultipleFromGallery() async {
    final images = await _imagePickerService.pickMultiplePhotos();
    if (images.isEmpty) return;
    selectImages(images);
  }

  Future<void> pickFromCamera() async {
    final image = await _imagePickerService.pickFromCamera();
    if (image == null) return;
    selectImages([image]);
  }

  void selectImages(List<XFile> images) {
    _selectedImages
      ..clear()
      ..addAll(images);
    _status = UploadStatus.selected;
    _progress = 0;
    _errorMessage = null;
    notifyListeners();
  }

  void removeSelectedImage(String path) {
    _selectedImages.removeWhere((image) => image.path == path);
    if (_selectedImages.isEmpty) {
      _status = UploadStatus.idle;
      _progress = 0;
    }
    notifyListeners();
  }

  void selectAlbum(String albumId) {
    _selectedAlbumId = albumId;
    notifyListeners();
  }

  void updateCaption(String value) {
    _caption = value;
    notifyListeners();
  }

  Future<List<PhotoModel>> uploadSelectedPhotos({
    required AlbumProvider albumProvider,
    required PhotoProvider photoProvider,
  }) async {
    if (!canUpload) return <PhotoModel>[];

    try {
      _status = UploadStatus.uploading;
      _progress = 0;
      _errorMessage = null;
      notifyListeners();

      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest_user';
      final albumId = _selectedAlbumId!;
      final uploadedPhotos = <PhotoModel>[];

      for (int i = 0; i < _selectedImages.length; i++) {
        final image = _selectedImages[i];
        final localFile = await _localPhotoStorageService.copyPickedImage(
          image,
        );
        final docRef = FirebaseFirestore.instance.collection('photos').doc();
        final now = DateTime.now();
        final title = _caption.trim().isNotEmpty && _selectedImages.length == 1
            ? _caption.trim()
            : localFile.fileName;

        final photo = PhotoModel(
          id: docRef.id,
          userId: userId,
          albumId: albumId,
          title: title,
          localPath: localFile.localPath,
          fileName: localFile.fileName,
          fileType: localFile.fileType,
          fileSize: localFile.fileSize,
          isFavorite: false,
          isLocalOnly: true,
          createdAt: now,
          updatedAt: now,
        );

        final albumRef = FirebaseFirestore.instance
            .collection('albums')
            .doc(albumId);

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final albumSnapshot = await transaction.get(albumRef);
          final albumData = albumSnapshot.data() ?? <String, dynamic>{};
          final coverLocalPath = albumData['coverLocalPath'] as String? ?? '';
          final coverPhotoId = albumData['coverPhotoId'] as String? ?? '';

          transaction.set(docRef, {
            ...photo.toJson(),
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          transaction.update(albumRef, {
            'photoCount': FieldValue.increment(1),
            if (coverLocalPath.isEmpty) 'coverLocalPath': photo.localPath,
            if (coverPhotoId.isEmpty) 'coverPhotoId': photo.id,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        });

        uploadedPhotos.add(photo);
        photoProvider.addPhoto(photo);
        albumProvider.applyUploadedPhoto(
          albumId: albumId,
          photoId: photo.id,
          localPath: photo.localPath,
        );

        _progress = (i + 1) / _selectedImages.length;
        notifyListeners();
      }

      await albumProvider.refreshAlbums();
      await photoProvider.refreshPhotos();

      _status = UploadStatus.completed;
      _progress = 1;
      notifyListeners();

      return uploadedPhotos;
    } catch (e) {
      _status = UploadStatus.failed;
      _errorMessage = e.toString();
      notifyListeners();
      return <PhotoModel>[];
    }
  }

  Future<PhotoModel?> uploadSelectedPhoto({
    required AlbumProvider albumProvider,
    required PhotoProvider photoProvider,
  }) async {
    final photos = await uploadSelectedPhotos(
      albumProvider: albumProvider,
      photoProvider: photoProvider,
    );
    return photos.isEmpty ? null : photos.first;
  }

  void clear() {
    _selectedImages.clear();
    _selectedAlbumId = null;
    _caption = '';
    _status = UploadStatus.idle;
    _progress = 0;
    _errorMessage = null;
    notifyListeners();
  }
}
