import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_photo_image.dart';
import '../../../data/models/photo_model.dart';
import '../../../providers/album_provider.dart';
import '../../../providers/photo_provider.dart';
import '../widgets/album_search_field.dart';

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({
    super.key,
    this.albumId,
    this.albumTitle = 'Album',
    this.photos,
    this.accentColor = const Color(0xFF7B73DC),
  });

  final String? albumId;
  final String albumTitle;
  final List<AlbumPhoto>? photos;
  final Color accentColor;

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<AlbumPhoto> _localPhotos;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _localPhotos = widget.photos ?? <AlbumPhoto>[];
  }

  List<AlbumPhoto> _filteredPhotos(List<AlbumPhoto> photos) {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return photos;

    return photos.where((photo) {
      return photo.fileName.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sourcePhotos = widget.albumId == null
        ? _localPhotos
        : context
              .watch<PhotoProvider>()
              .photosByAlbum(widget.albumId!)
              .map(_toAlbumPhoto)
              .toList();
    final photos = _filteredPhotos(sourcePhotos);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _DetailTopBar(
              title: widget.albumTitle,
              onBack: () => Navigator.maybePop(context),
            ),
            const SizedBox(height: 14),
            AlbumSearchField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: photos.isEmpty
                  ? _NoPhotoResult(query: _query)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: photos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.78,
                          ),
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return _AlbumPhotoCard(
                          photo: photo,
                          accentColor: widget.accentColor,
                          onView: () => _openPreview(photo),
                          onDelete: () => _deletePhoto(photo),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPreview(AlbumPhoto photo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _PhotoPreviewScreen(photo: photo)),
    );
  }

  Future<void> _deletePhoto(AlbumPhoto photo) async {
    final messenger = ScaffoldMessenger.of(context);
    if (photo.id == null || widget.albumId == null) {
      setState(() => _localPhotos.remove(photo));
    } else {
      await context.read<PhotoProvider>().deletePhoto(photo.id!);
      if (!mounted) return;
      await context.read<AlbumProvider>().decrementPhotoCount(widget.albumId!);
    }

    messenger.showSnackBar(
      SnackBar(
        content: Text('${photo.fileName} removed from ${widget.albumTitle}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  AlbumPhoto _toAlbumPhoto(PhotoModel photo) {
    return AlbumPhoto(
      id: photo.id,
      fileName: photo.title,
      localPath: photo.localPath,
    );
  }
}

class AlbumPhoto {
  const AlbumPhoto({this.id, required this.fileName, required this.localPath});

  final String? id;
  final String fileName;
  final String localPath;
}

class _DetailTopBar extends StatelessWidget {
  const _DetailTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: SizedBox(
        height: 42,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                color: const Color(0xFF1A1B23),
                splashRadius: 22,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF15161E),
                fontWeight: FontWeight.w800,
                letterSpacing: -0.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumPhotoCard extends StatelessWidget {
  const _AlbumPhotoCard({
    required this.photo,
    required this.accentColor,
    required this.onView,
    required this.onDelete,
  });

  final AlbumPhoto photo;
  final Color accentColor;
  final VoidCallback onView;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onView,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 4, 5),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      photo.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF525463),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: PopupMenuButton<_PhotoAction>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 16,
                        color: Color(0xFF9A9BA6),
                      ),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      onSelected: (action) {
                        switch (action) {
                          case _PhotoAction.view:
                            onView();
                          case _PhotoAction.delete:
                            onDelete();
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: _PhotoAction.view,
                          child: Text('View photo'),
                        ),
                        PopupMenuItem(
                          value: _PhotoAction.delete,
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(11),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppPhotoImage(
                        localPath: photo.localPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_) {
                          return _PhotoErrorPlaceholder(
                            accentColor: accentColor,
                          );
                        },
                      ),
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.04),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _PhotoAction { view, delete }

class _PhotoErrorPlaceholder extends StatelessWidget {
  const _PhotoErrorPlaceholder({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor.withValues(alpha: 0.09),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: accentColor,
        size: 30,
      ),
    );
  }
}

class _NoPhotoResult extends StatelessWidget {
  const _NoPhotoResult({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final message = query.trim().isEmpty
        ? 'No photos available in this album.'
        : 'No photo found for “$query”.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 54,
              color: Color(0xFFC4C5D2),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF383A46),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPreviewScreen extends StatelessWidget {
  const _PhotoPreviewScreen({required this.photo});

  final AlbumPhoto photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          photo.fileName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.8,
          maxScale: 4,
          child: AppPhotoImage(
            localPath: photo.localPath,
            fit: BoxFit.contain,
            errorBuilder: (_) => const Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}
