import 'package:flutter/material.dart';

import '../widgets/delete_photo_dialog.dart';
import '../widgets/photo_image_data.dart';
import '../widgets/photo_grid_card.dart';
import '../widgets/photo_options_sheet.dart';
import 'photo_detail_screen.dart';

class AllPhotosScreen extends StatefulWidget {
  const AllPhotosScreen({super.key});

  @override
  State<AllPhotosScreen> createState() => _AllPhotosScreenState();
}

class _AllPhotosScreenState extends State<AllPhotosScreen> {
  final List<PhotoImageData> _photos = [
    PhotoImageData(
      id: 'img345768809',
      albumName: 'Nature',
      imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=900&q=80',
    ),
    PhotoImageData(
      id: 'img345768609',
      albumName: 'Mountains',
      imageUrl: 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?auto=format&fit=crop&w=900&q=80',
    ),
    PhotoImageData(
      id: 'img345768809',
      albumName: 'Travel',
      imageUrl: 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=80',
    ),
    PhotoImageData(
      id: 'img345768609',
      albumName: 'City',
      imageUrl: 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=80',
    ),
    PhotoImageData(
      id: 'img345768409',
      albumName: 'Roads',
      imageUrl: 'https://images.unsplash.com/photo-1470770903676-69b98201ea1c?auto=format&fit=crop&w=900&q=80',
    ),
    PhotoImageData(
      id: 'img345768109',
      albumName: 'Sunset',
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=900&q=80',
    ),
    PhotoImageData(
      id: 'img345768909',
      albumName: 'Flowers',
      imageUrl: 'https://images.unsplash.com/photo-1490750967868-88aa4486c946?auto=format&fit=crop&w=900&q=80',
    ),
    PhotoImageData(
      id: 'img345768209',
      albumName: 'Sea',
      imageUrl: 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=900&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF9FAFB),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 17),
          color: const Color(0xFF111827),
        ),
        title: const Text(
          'All Photos',
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: _photos.isEmpty ? const _EmptyPhotosView() : _PhotosGrid(
          photos: _photos,
          onPhotoTap: _openPhotoDetail,
          onMoreTap: _openPhotoOptions,
        ),
      ),
    );
  }

  void _openPhotoDetail(PhotoImageData photo) {
    final selectedIndex = _photos.indexOf(photo);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhotoDetailScreen(
          photos: List<PhotoImageData>.unmodifiable(_photos),
          initialIndex: selectedIndex < 0 ? 0 : selectedIndex,
        ),
      ),
    );
  }

  void _openPhotoOptions(PhotoImageData photo) {
    PhotoOptionsSheet.show(
      context: context,
      photo: photo,
      onView: () => _openPhotoDetail(photo),
      onDownload: () => _showSnackBar('Download started for ${photo.id}'),
      onDelete: () => _confirmDelete(photo),
      onShare: () => _showSnackBar('Share ${photo.id}'),
    );
  }

  Future<void> _confirmDelete(PhotoImageData photo) async {
    final shouldDelete = await DeletePhotoDialog.show(context);
    if (!mounted || shouldDelete != true) return;

    setState(() {
      _photos.remove(photo);
    });

    _showSnackBar('${photo.id} deleted successfully');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _PhotosGrid extends StatelessWidget {
  final List<PhotoImageData> photos;
  final ValueChanged<PhotoImageData> onPhotoTap;
  final ValueChanged<PhotoImageData> onMoreTap;

  const _PhotosGrid({
    required this.photos,
    required this.onPhotoTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: photos.length,
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.86,
      ),
      itemBuilder: (context, index) {
        final photo = photos[index];
        return PhotoGridCard(
          photo: photo,
          onTap: () => onPhotoTap(photo),
          onMoreTap: () => onMoreTap(photo),
        );
      },
    );
  }
}

class _EmptyPhotosView extends StatelessWidget {
  const _EmptyPhotosView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.photo_library_outlined,
                color: Color(0xFF2563EB),
                size: 34,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No photos yet',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Uploaded photos will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
