import 'package:flutter/material.dart';

import '../widgets/album_folder_card.dart';
import '../widgets/album_search_field.dart';
import 'album_detail_screen.dart';
import 'empty_album_screen.dart';

class AllAlbumsScreen extends StatefulWidget {
  const AllAlbumsScreen({super.key});

  @override
  State<AllAlbumsScreen> createState() => _AllAlbumsScreenState();
}

class _AllAlbumsScreenState extends State<AllAlbumsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_AlbumItem> _albums = const [
    _AlbumItem(
      title: 'Vacations',
      photoCount: 124,
      folderColor: Color(0xFFFFC8D4),
      tabColor: Color(0xFFF17998),
    ),
    _AlbumItem(
      title: 'Birthdays',
      photoCount: 78,
      folderColor: Color(0xFFDAD8FF),
      tabColor: Color(0xFF7B73DC),
    ),
    _AlbumItem(
      title: 'Concerts',
      photoCount: 56,
      folderColor: Color(0xFFC6D6FF),
      tabColor: Color(0xFF4E6ED0),
    ),
    _AlbumItem(
      title: 'Road Trips',
      photoCount: 89,
      folderColor: Color(0xFFFFE1B9),
      tabColor: Color(0xFFFFB665),
    ),
    _AlbumItem(
      title: 'Weddings',
      photoCount: 150,
      folderColor: Color(0xFFBCEDED),
      tabColor: Color(0xFF45C6C8),
    ),
    _AlbumItem(
      title: 'Reunions',
      photoCount: 42,
      folderColor: Color(0xFFECC8FF),
      tabColor: Color(0xFFC46BE8),
    ),
  ];

  List<_AlbumItem> get _filteredAlbums {
    final normalizedQuery = _query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return _albums;

    return _albums.where((album) {
      return album.title.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final albums = _filteredAlbums;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _AlbumsTopBar(
              title: 'All Albums',
              onBack: () => Navigator.maybePop(context),
            ),
            const SizedBox(height: 14),
            AlbumSearchField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: albums.isEmpty
                  ? _NoAlbumResult(query: _query)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: albums.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 22,
                        mainAxisSpacing: 22,
                        childAspectRatio: 0.88,
                      ),
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        return AlbumFolderCard(
                          title: album.title,
                          subtitle: '${album.photoCount} Photos',
                          folderColor: album.folderColor,
                          tabColor: album.tabColor,
                          onTap: () => _openAlbum(context, album),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAlbum(BuildContext context, _AlbumItem album) {
    if (album.photoCount == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EmptyAlbumScreen(albumTitle: album.title),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AlbumDetailScreen(
          albumTitle: album.title,
          accentColor: album.tabColor,
          photos: _samplePhotos(album.title),
        ),
      ),
    );
  }

  List<AlbumPhoto> _samplePhotos(String albumTitle) {
    return List.generate(18, (index) {
      final seed = '${albumTitle.toLowerCase().replaceAll(' ', '-')}-${index + 1}';
      return AlbumPhoto(
        fileName: 'img${345678 + index}.jpg',
        imageUrl: 'https://picsum.photos/seed/$seed/500/650',
      );
    });
  }
}

class _AlbumsTopBar extends StatelessWidget {
  const _AlbumsTopBar({required this.title, required this.onBack});

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
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.only(right: 7),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF009688),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Z',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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

class _NoAlbumResult extends StatelessWidget {
  const _NoAlbumResult({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.folder_off_rounded,
              size: 54,
              color: Color(0xFFC4C5D2),
            ),
            const SizedBox(height: 12),
            Text(
              'No album found for “$query”',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF383A46),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try searching with another album title.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF8B8D9B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumItem {
  const _AlbumItem({
    required this.title,
    required this.photoCount,
    required this.folderColor,
    required this.tabColor,
  });

  final String title;
  final int photoCount;
  final Color folderColor;
  final Color tabColor;
}
