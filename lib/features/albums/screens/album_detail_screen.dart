import 'package:flutter/material.dart';

import '../widgets/album_search_field.dart';

class AlbumDetailScreen extends StatefulWidget {
  const AlbumDetailScreen({
    super.key,
    this.albumTitle = 'Birthdays',
    this.photos,
    this.accentColor = const Color(0xFF7B73DC),
  });

  final String albumTitle;
  final List<AlbumPhoto>? photos;
  final Color accentColor;

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<AlbumPhoto> _photos;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _photos = widget.photos ?? _defaultPhotos(widget.albumTitle);
  }

  List<AlbumPhoto> get _filteredPhotos {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return _photos;

    return _photos.where((photo) {
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
    final photos = _filteredPhotos;

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
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      MaterialPageRoute(
        builder: (_) => _PhotoPreviewScreen(photo: photo),
      ),
    );
  }

  void _deletePhoto(AlbumPhoto photo) {
    setState(() => _photos.remove(photo));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${photo.fileName} removed from ${widget.albumTitle}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  List<AlbumPhoto> _defaultPhotos(String albumTitle) {
    return List.generate(16, (index) {
      final seed = '${albumTitle.toLowerCase().replaceAll(' ', '-')}-detail-${index + 1}';
      return AlbumPhoto(
        fileName: 'img${345678 + index}.jpg',
        imageUrl: 'https://picsum.photos/seed/$seed/500/650',
      );
    });
  }
}

class AlbumPhoto {
  const AlbumPhoto({
    required this.fileName,
    required this.imageUrl,
  });

  final String fileName;
  final String imageUrl;
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
              color: Colors.black.withOpacity(0.035),
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
                      Image.network(
                        photo.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _PhotoLoadingPlaceholder(accentColor: accentColor);
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _PhotoErrorPlaceholder(accentColor: accentColor);
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
                                Colors.black.withOpacity(0.04),
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

class _PhotoLoadingPlaceholder extends StatelessWidget {
  const _PhotoLoadingPlaceholder({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor.withOpacity(0.08),
      alignment: Alignment.center,
      child: SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: accentColor,
        ),
      ),
    );
  }
}

class _PhotoErrorPlaceholder extends StatelessWidget {
  const _PhotoErrorPlaceholder({required this.accentColor});

  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: accentColor.withOpacity(0.09),
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
          child: Image.network(
            photo.imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
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
