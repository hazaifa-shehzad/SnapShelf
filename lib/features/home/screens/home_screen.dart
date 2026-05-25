import 'package:flutter/material.dart';

import '../../profile/widgets/profile_drawer.dart';
import '../../upload/screens/choose_album_screen.dart';
import '../../upload/screens/upload_photo_screen.dart';
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

  static const List<String> _recentUploads = [
    'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=400&q=80',
    'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?auto=format&fit=crop&w=400&q=80',
  ];

  static const List<_AlbumData> _albums = [
    _AlbumData(
      title: 'Vacations',
      photos: 124,
      folderColor: Color(0xFFFFC4CD),
      tabColor: Color(0xFFFF6F91),
    ),
    _AlbumData(
      title: 'Birthdays',
      photos: 78,
      folderColor: Color(0xFFDCD9FA),
      tabColor: Color(0xFF7770D9),
    ),
    _AlbumData(
      title: 'Weddings',
      photos: 150,
      folderColor: Color(0xFFBDEDEC),
      tabColor: Color(0xFF42CAC6),
    ),
    _AlbumData(
      title: 'Concerts',
      photos: 56,
      folderColor: Color(0xFFC8DCFF),
      tabColor: Color(0xFF516BCC),
    ),
    _AlbumData(
      title: 'Road Trips',
      photos: 89,
      folderColor: Color(0xFFFFDFB7),
      tabColor: Color(0xFFFFB062),
    ),
    _AlbumData(
      title: 'Reunions',
      photos: 42,
      folderColor: Color(0xFFECC8FF),
      tabColor: Color(0xFFC961E6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAFAFC),
      drawer: const ProfileDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                name: 'Rig',
                subtitle: 'What would you like to do today?',
                avatarUrl:
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=120&q=80',
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
                      onTap: () => _showMessage(context, 'All photos screen coming soon'),
                    ),
                  ),
                  Expanded(
                    child: HomeActionCard(
                      title: 'Create\nAlbum',
                      icon: Icons.create_new_folder_outlined,
                      backgroundColor: const Color(0xFFFFDDE7),
                      iconColor: const Color(0xFFFF7D9B),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ChooseAlbumScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              _SectionHeader(
                title: 'Recent Uploads',
                actionText: 'View All',
                onActionTap: () => _showMessage(context, 'View all recent uploads'),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 90,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: _recentUploads.length,
                  itemBuilder: (context, index) {
                    return RecentUploadCard(imageUrl: _recentUploads[index]);
                  },
                ),
              ),
              const SizedBox(height: 28),
              _SectionHeader(
                title: 'Your Albums',
                actionText: 'More Albums',
                onActionTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChooseAlbumScreen()),
                ),
              ),
              const SizedBox(height: 15),
              GridView.builder(
                itemCount: _albums.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (context, index) {
                  final album = _albums[index];
                  return AlbumPreviewCard(
                    title: album.title,
                    photoCount: album.photos,
                    folderColor: album.folderColor,
                    tabColor: album.tabColor,
                    onTap: () => _showMessage(context, '${album.title} album opened'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
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

class _AlbumData {
  const _AlbumData({
    required this.title,
    required this.photos,
    required this.folderColor,
    required this.tabColor,
  });

  final String title;
  final int photos;
  final Color folderColor;
  final Color tabColor;
}
