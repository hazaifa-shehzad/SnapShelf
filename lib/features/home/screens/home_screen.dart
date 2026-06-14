import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/routes/route_names.dart';
import '../../../data/models/album_model.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/album_provider.dart';
import '../../../providers/photo_provider.dart';
import '../../albums/screens/album_detail_screen.dart';
import '../../albums/screens/all_albums_screen.dart';
import '../../albums/screens/empty_album_screen.dart';
import '../../photos/screens/all_photos_screen.dart';
import '../../profile/widgets/profile_drawer.dart';
import '../../upload/screens/upload_photo_screen.dart';
import '../../upload/widgets/create_album_dialog.dart';
import '../widgets/album_preview_card.dart';
import '../widgets/home_action_card.dart';
import '../widgets/home_header.dart';
import '../widgets/recent_upload_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const Color _primary = Color(0xFF7C74E8);
  static const Color _textDark = Color(0xFF171725);
  static const Color _textMuted = Color(0xFF7D8193);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const List<_AlbumPalette> _albumPalettes = [
    _AlbumPalette(folderColor: Color(0xFFFFC4CD), tabColor: Color(0xFFFF6F91)),
    _AlbumPalette(folderColor: Color(0xFFDCD9FA), tabColor: Color(0xFF7770D9)),
    _AlbumPalette(folderColor: Color(0xFFBDEDEC), tabColor: Color(0xFF42CAC6)),
    _AlbumPalette(folderColor: Color(0xFFC8DCFF), tabColor: Color(0xFF516BCC)),
    _AlbumPalette(folderColor: Color(0xFFFFDFB7), tabColor: Color(0xFFFFB062)),
    _AlbumPalette(folderColor: Color(0xFFECC8FF), tabColor: Color(0xFFC961E6)),
  ];

  @override
  Widget build(BuildContext context) {
    final recentPhotos = context.watch<PhotoProvider>().recentPhotos;
    final albums = context.watch<AlbumProvider>().albums;
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAFAFC),
      drawer: ProfileDrawer(onLogout: () => _logout(context)),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                name: user?.name ?? 'User',
                subtitle: 'What would you like to do today?',
                avatarUrl: user?.avatarUrl,
                initials: user?.initials ?? 'U',
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              const SizedBox(height: 34),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: HomeActionCard(
                      title: 'Upload\nPhoto',
                      icon: Icons.upload_rounded,
                      backgroundColor: const Color(0xFFE2DEFF),
                      iconColor: HomeScreen._primary,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UploadPhotoScreen(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: HomeActionCard(
                      title: 'View all\nPhoto',
                      icon: Icons.image_outlined,
                      backgroundColor: const Color(0xFFDCE8FF),
                      iconColor: const Color(0xFF5A83EC),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const AllPhotosScreen(),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: HomeActionCard(
                      title: 'Create\nAlbum',
                      icon: Icons.create_new_folder_outlined,
                      backgroundColor: const Color(0xFFFFDDE7),
                      iconColor: const Color(0xFFFF7D9B),
                      onTap: _createAlbum,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              _SectionHeader(
                title: 'Recent Uploads',
                actionText: 'View All',
                onActionTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AllPhotosScreen()),
                ),
              ),
              const SizedBox(height: 14),
              recentPhotos.isEmpty
                  ? const _EmptyHomeStrip(message: 'No uploads yet')
                  : SizedBox(
                      height: 90,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: recentPhotos.length,
                        itemBuilder: (context, index) {
                          return RecentUploadCard(
                            localPath: recentPhotos[index].localPath,
                          );
                        },
                      ),
                    ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Your Albums',
                actionText: 'More Albums',
                onActionTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AllAlbumsScreen()),
                ),
              ),
              const SizedBox(height: 15),
              albums.isEmpty
                  ? const _EmptyHomeStrip(message: 'No albums yet')
                  : GridView.builder(
                      itemCount: albums.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 18,
                            childAspectRatio: 0.78,
                          ),
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        final palette = _paletteFor(index);
                        return AlbumPreviewCard(
                          title: album.title,
                          photoCount: album.photoCount,
                          folderColor: palette.folderColor,
                          tabColor: palette.tabColor,
                          onTap: () =>
                              _openAlbum(context, album, palette.tabColor),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _AlbumPalette _paletteFor(int index) {
    return _albumPalettes[index % _albumPalettes.length];
  }

  Future<void> _createAlbum() async {
    final String? createdName = await showDialog<String>(
      context: context,
      barrierColor: const Color(0xFFAAA8DB).withValues(alpha: 0.42),
      builder: (_) => const CreateAlbumDialog(),
    );

    if (!mounted || createdName == null || createdName.trim().isEmpty) return;
    await context.read<AlbumProvider>().addAlbum(createdName);
  }

  void _openAlbum(BuildContext context, AlbumModel album, Color accentColor) {
    if (album.photoCount == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              EmptyAlbumScreen(albumId: album.id, albumTitle: album.title),
        ),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AlbumDetailScreen(
          albumId: album.id,
          albumTitle: album.title,
          accentColor: accentColor,
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final navigator = Navigator.of(context);
    final authProvider = context.read<AuthProvider>();

    await authProvider.logout();
    if (!mounted) return;

    navigator.pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionText,
    this.onActionTap,
  });

  final String title;
  final String actionText;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: HomeScreen._textDark,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.2,
            ),
          ),
        ),
        InkWell(
          onTap: onActionTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Text(
              actionText,
              style: const TextStyle(
                color: HomeScreen._primary,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AlbumPalette {
  const _AlbumPalette({required this.folderColor, required this.tabColor});

  final Color folderColor;
  final Color tabColor;
}

class _EmptyHomeStrip extends StatelessWidget {
  const _EmptyHomeStrip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: HomeScreen._textMuted,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
