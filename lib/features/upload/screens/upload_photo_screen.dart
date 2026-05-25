import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/services/image_picker_service.dart';
import '../widgets/upload_drop_box.dart';
import '../widgets/upload_progress_tile.dart';
import 'choose_album_screen.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final List<_UploadItem> _uploads = <_UploadItem>[];
  final ImagePickerService _imagePickerService = ImagePickerService();
  Timer? _timer;
  bool _isPickingFiles = false;

  static const Color _primary = Color(0xFF7C74E8);
  static const Color _textDark = Color(0xFF171725);
  static const Color _textMuted = Color(0xFF7D8193);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).maybePop(),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: _textDark,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'Upload Your Photos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 25,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.45,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Select images from your device to store them\nsecurely in the cloud',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _textMuted,
                    fontSize: 12.2,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Upload Images',
                style: TextStyle(
                  color: _textDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              UploadDropBox(onTap: _pickAndUploadPhotos),
              const SizedBox(height: 34),
              if (_uploads.isNotEmpty) ...[
                for (final item in _uploads)
                  UploadProgressTile(
                    key: ValueKey(item.id),
                    title: item.fileName,
                    subtitle: _statusText(item),
                    progress: item.progress,
                    onCancel: () => _removeUpload(item.id),
                  ),
                const SizedBox(height: 10),
                if (_uploads.every((item) => item.progress >= 1))
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _chooseAlbum,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: _primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Choose Album',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndUploadPhotos() async {
    if (_isPickingFiles) return;

    _timer?.cancel();
    setState(() => _isPickingFiles = true);

    try {
      final List<XFile> selectedFiles =
          await _imagePickerService.pickMultiplePhotos();
      if (!mounted) return;

      if (selectedFiles.isEmpty) {
        setState(() => _isPickingFiles = false);
        return;
      }

      final List<_UploadItem> uploads = await _buildUploadItems(selectedFiles);
      if (!mounted) return;

      setState(() {
        _isPickingFiles = false;
        _uploads
          ..clear()
          ..addAll(uploads);
      });

      _startUploadProgress();
    } catch (_) {
      if (!mounted) return;

      setState(() => _isPickingFiles = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Unable to open the file picker. Please try again.'),
        ),
      );
    }
  }

  Future<List<_UploadItem>> _buildUploadItems(List<XFile> files) async {
    final List<_UploadItem> uploads = <_UploadItem>[];

    for (int i = 0; i < files.length; i++) {
      final XFile file = files[i];
      int sizeMb = 1;

      try {
        final int sizeInBytes = await file.length();
        sizeMb = ((sizeInBytes / (1024 * 1024)).ceil()).clamp(1, 999);
      } catch (_) {
        sizeMb = 1;
      }

      uploads.add(
        _UploadItem(
          id: '${DateTime.now().microsecondsSinceEpoch}-$i',
          fileName: file.name,
          sizeMb: sizeMb,
          secondsRemaining: 18 + (i * 8),
          progress: 0,
        ),
      );
    }

    return uploads;
  }

  void _startUploadProgress() {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;

      setState(() {
        for (int i = 0; i < _uploads.length; i++) {
          final _UploadItem item = _uploads[i];
          if (item.progress >= 1) continue;

          final double step = (0.08 - (i * 0.01)).clamp(0.03, 0.08);
          final double nextProgress =
              (item.progress + step).clamp(0.0, 1.0).toDouble();
          final int nextSeconds =
              (item.secondsRemaining - 2).clamp(0, 999).toInt();

          _uploads[i] = item.copyWith(
            progress: nextProgress,
            secondsRemaining: nextSeconds,
          );
        }
      });

      if (_uploads.isEmpty || _uploads.every((item) => item.progress >= 1)) {
        timer.cancel();
      }
    });
  }

  String _statusText(_UploadItem item) {
    final int percent =
        (item.progress * 100).round().clamp(0, 100).toInt();
    if (item.progress >= 1) return '100% - Upload completed';
    return '$percent% - ${item.secondsRemaining} sec remaining';
  }

  void _removeUpload(String id) {
    setState(() => _uploads.removeWhere((item) => item.id == id));
    if (_uploads.isEmpty) _timer?.cancel();
  }

  Future<void> _chooseAlbum() async {
    final selectedAlbum = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ChooseAlbumScreen()),
    );

    if (!mounted || selectedAlbum == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Photos added to $selectedAlbum'),
      ),
    );
  }
}

class _UploadItem {
  const _UploadItem({
    required this.id,
    required this.fileName,
    required this.sizeMb,
    required this.secondsRemaining,
    required this.progress,
  });

  final String id;
  final String fileName;
  final int sizeMb;
  final int secondsRemaining;
  final double progress;

  _UploadItem copyWith({
    String? id,
    String? fileName,
    int? sizeMb,
    int? secondsRemaining,
    double? progress,
  }) {
    return _UploadItem(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      sizeMb: sizeMb ?? this.sizeMb,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      progress: progress ?? this.progress,
    );
  }
}
