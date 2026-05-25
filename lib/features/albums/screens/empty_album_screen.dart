import 'package:flutter/material.dart';

class EmptyAlbumScreen extends StatelessWidget {
  const EmptyAlbumScreen({
    super.key,
    this.albumTitle = 'New Album',
    this.onUploadTap,
    this.uploadRouteName,
  });

  final String albumTitle;
  final VoidCallback? onUploadTap;
  final String? uploadRouteName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            _EmptyAlbumTopBar(
              title: albumTitle,
              onBack: () => Navigator.maybePop(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _EmptyAlbumIllustration(),
                    const SizedBox(height: 20),
                    const Text(
                      'No photo uploaded yet',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF8D8F9E),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 58),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => _handleUpload(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B73DC),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Upload Photos',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _handleUpload(BuildContext context) {
    if (onUploadTap != null) {
      onUploadTap!();
      return;
    }

    if (uploadRouteName != null) {
      Navigator.pushNamed(context, uploadRouteName!);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connect this button with your UploadPhotoScreen.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _EmptyAlbumTopBar extends StatelessWidget {
  const _EmptyAlbumTopBar({required this.title, required this.onBack});

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

class _EmptyAlbumIllustration extends StatelessWidget {
  const _EmptyAlbumIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 135,
      width: 180,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 4,
            left: 17,
            child: _SoftBlob(
              height: 60,
              width: 130,
              color: const Color(0xFFB8B9F2).withOpacity(0.35),
              radius: 60,
            ),
          ),
          Positioned(
            bottom: 18,
            left: 35,
            child: Transform.rotate(
              angle: -0.14,
              child: Container(
                height: 56,
                width: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF8F8BE8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B73DC).withOpacity(0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.photo_rounded,
                  color: Colors.white,
                  size: 31,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 34,
            child: Transform.rotate(
              angle: 0.13,
              child: Container(
                height: 68,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A73D9),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD268),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14),
                        ),
                        child: SizedBox(
                          height: 34,
                          width: 80,
                          child: CustomPaint(
                            painter: _MountainPainter(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 31,
            top: 20,
            child: Transform.rotate(
              angle: -0.38,
              child: _Leaf(color: const Color(0xFF7B73DC).withOpacity(0.75)),
            ),
          ),
          Positioned(
            left: 48,
            top: 5,
            child: Transform.rotate(
              angle: 0.18,
              child: const _Leaf(color: Color(0xFFFF82A2)),
            ),
          ),
          Positioned(
            left: 61,
            top: 19,
            child: Transform.rotate(
              angle: 0.42,
              child: _Leaf(color: const Color(0xFF95A0F2).withOpacity(0.9)),
            ),
          ),
          const Positioned(
            right: 22,
            top: 22,
            child: _InitialBadge(initial: 'H'),
          ),
        ],
      ),
    );
  }
}

class _InitialBadge extends StatelessWidget {
  const _InitialBadge({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0F7FBA),
        border: Border.all(color: const Color(0xFF1D2C44), width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SoftBlob extends StatelessWidget {
  const _SoftBlob({
    required this.height,
    required this.width,
    required this.color,
    required this.radius,
  });

  final double height;
  final double width;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _Leaf extends StatelessWidget {
  const _Leaf({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 18,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
        ),
      ),
    );
  }
}

class _MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final firstPaint = Paint()
      ..color = Colors.white.withOpacity(0.62)
      ..style = PaintingStyle.fill;
    final secondPaint = Paint()
      ..color = Colors.white.withOpacity(0.82)
      ..style = PaintingStyle.fill;

    final firstPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.28, size.height * 0.35)
      ..lineTo(size.width * 0.55, size.height)
      ..close();

    final secondPath = Path()
      ..moveTo(size.width * 0.28, size.height)
      ..lineTo(size.width * 0.68, size.height * 0.20)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(firstPath, firstPaint);
    canvas.drawPath(secondPath, secondPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
