import 'package:flutter/material.dart';

import '../widgets/album_radio_tile.dart';
import '../widgets/create_album_dialog.dart';

class ChooseAlbumScreen extends StatefulWidget {
  const ChooseAlbumScreen({super.key});

  @override
  State<ChooseAlbumScreen> createState() => _ChooseAlbumScreenState();
}

class _ChooseAlbumScreenState extends State<ChooseAlbumScreen> {
  final List<String> _albums = <String>['Album 1', 'Album 2', 'Album 3'];
  String _selectedAlbum = 'Album 1';

  static const Color _primary = Color(0xFF7C74E8);
  static const Color _textDark = Color(0xFF171725);
  static const Color _textMuted = Color(0xFF7D8193);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
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
              const SizedBox(height: 2),
              const Center(
                child: Text(
                  'Choose Album',
                  style: TextStyle(
                    color: _textDark,
                    fontSize: 25,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.45,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  'Select album to add the photo',
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
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _albums.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final String album = _albums[index];
                    return AlbumRadioTile(
                      title: album,
                      value: album,
                      groupValue: _selectedAlbum,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedAlbum = value);
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _selectAlbum,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Select Album',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _openCreateAlbumDialog,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _primary,
                    side: const BorderSide(color: _primary, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text(
                    'Create New',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAlbum() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Selected $_selectedAlbum'),
      ),
    );
    Navigator.of(context).maybePop(_selectedAlbum);
  }

  Future<void> _openCreateAlbumDialog() async {
    final String? createdName = await showDialog<String>(
      context: context,
      barrierColor: const Color(0xFFAAA8DB).withOpacity(0.42),
      builder: (_) => const CreateAlbumDialog(),
    );

    if (createdName == null || createdName.trim().isEmpty) return;

    setState(() {
      _albums.add(createdName.trim());
      _selectedAlbum = createdName.trim();
    });
  }
}
