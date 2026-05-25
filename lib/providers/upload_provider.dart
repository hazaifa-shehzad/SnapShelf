import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/models/photo_model.dart';
import '../data/models/upload_model.dart';
import '../data/services/image_picker_service.dart';

class UploadProvider extends ChangeNotifier {
  UploadProvider({ImagePickerService? imagePickerService})
      : _imagePickerService = imagePickerService ?? ImagePickerService();

  final ImagePickerService _imagePickerService;

  XFile? _selectedImage;
  String? _selectedAlbumId;
  String _caption = '';
  UploadStatus _status = UploadStatus.idle;
  double _progress = 0;

  XFile? get selectedImage => _selectedImage;
  String? get selectedAlbumId => _selectedAlbumId;
  String get caption => _caption;
  UploadStatus get status => _status;
  double get progress => _progress;

  bool get hasSelectedImage => _selectedImage != null;
  bool get canUpload => _selectedImage != null && _selectedAlbumId != null;
  bool get isUploading => _status == UploadStatus.uploading;

  Future<void> pickFromGallery() async {
    final image = await _imagePickerService.pickFromGallery();
    if (image == null) return;
    _selectedImage = image;
    _status = UploadStatus.selected;
    notifyListeners();
  }

  Future<void> pickFromCamera() async {
    final image = await _imagePickerService.pickFromCamera();
    if (image == null) return;
    _selectedImage = image;
    _status = UploadStatus.selected;
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

  Future<PhotoModel?> uploadSelectedPhoto() async {
    if (!canUpload) return null;

    _status = UploadStatus.uploading;
    _progress = 0;
    notifyListeners();

    for (int i = 1; i <= 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 180));
      _progress = i / 5;
      notifyListeners();
    }

    final image = _selectedImage!;
    final uploadedPhoto = PhotoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      albumId: _selectedAlbumId!,
      title: _caption.trim().isEmpty ? image.name : _caption.trim(),
      imageUrl: image.path,
      size: 'Local file',
      uploadedAt: DateTime.now(),
    );

    _status = UploadStatus.completed;
    notifyListeners();
    return uploadedPhoto;
  }

  void clear() {
    _selectedImage = null;
    _selectedAlbumId = null;
    _caption = '';
    _status = UploadStatus.idle;
    _progress = 0;
    notifyListeners();
  }
}
