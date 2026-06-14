import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/app_photo_image.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/photo_image_data.dart';

class PhotoDetailScreen extends StatefulWidget {
  final List<PhotoImageData> photos;
  final int initialIndex;

  const PhotoDetailScreen({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  PhotoImageData? get _currentPhoto {
    if (widget.photos.isEmpty) return null;
    return widget.photos[_currentIndex];
  }

  @override
  void initState() {
    super.initState();
    if (widget.photos.isEmpty) {
      _currentIndex = 0;
      _pageController = PageController();
      return;
    }

    _currentIndex = widget.initialIndex.clamp(0, widget.photos.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPhoto = _currentPhoto;
    final initials = context.watch<AuthProvider>().user?.initials ?? 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF9FAFB),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
          color: const Color(0xFF111827),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Text(
            currentPhoto?.id ?? 'Photo',
            key: ValueKey(currentPhoto?.id ?? 'empty-photo'),
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _shareCurrentPhoto,
            icon: const Icon(Icons.ios_share_rounded, size: 18),
            color: const Color(0xFF111827),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: widget.photos.isEmpty
            ? const _EmptyPhotoDetailView()
            : Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: widget.photos.length,
                              onPageChanged: (index) =>
                                  setState(() => _currentIndex = index),
                              itemBuilder: (context, index) {
                                final photo = widget.photos[index];
                                return Hero(
                                  tag: 'photo-${photo.id}',
                                  child: AppPhotoImage(
                                    localPath: photo.localPath,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_) {
                                      return Container(
                                        color: const Color(0xFFF2F4F7),
                                        alignment: Alignment.center,
                                        child: const Icon(
                                          Icons.broken_image_outlined,
                                          color: Color(0xFF98A2B3),
                                          size: 34,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          _RoundArrowButton(
                            alignment: Alignment.centerLeft,
                            icon: Icons.chevron_left_rounded,
                            enabled: _currentIndex > 0,
                            onTap: _previousPhoto,
                          ),
                          _RoundArrowButton(
                            alignment: Alignment.centerRight,
                            icon: Icons.chevron_right_rounded,
                            enabled: _currentIndex < widget.photos.length - 1,
                            onTap: _nextPhoto,
                          ),
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF134E4A),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.20),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              initials,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _PhotoCounter(
                      current: _currentIndex + 1,
                      total: widget.photos.length,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _previousPhoto() {
    if (_currentIndex == 0) return;
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _nextPhoto() {
    if (_currentIndex == widget.photos.length - 1) return;
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _shareCurrentPhoto() {
    final currentPhoto = _currentPhoto;
    if (currentPhoto == null) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Share ${currentPhoto.id}')));
  }
}

class _EmptyPhotoDetailView extends StatelessWidget {
  const _EmptyPhotoDetailView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.photo_library_outlined,
              size: 40,
              color: Color(0xFF98A2B3),
            ),
            SizedBox(height: 12),
            Text(
              'No photo selected',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundArrowButton extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _RoundArrowButton({
    required this.alignment,
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(99),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: enabled ? 1 : 0.35,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.24),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoCounter extends StatelessWidget {
  final int current;
  final int total;

  const _PhotoCounter({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Text(
        '$current of $total',
        style: const TextStyle(
          color: Color(0xFF667085),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
