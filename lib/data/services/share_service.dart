import 'package:share_plus/share_plus.dart';

class ShareService {
  ShareService._();

  static Future<void> shareText(String text) async {
    if (text.trim().isEmpty) return;
    await Share.share(text.trim());
  }

  static Future<void> sharePhotoUrl({
    required String title,
    required String imageUrl,
  }) async {
    final message = '$title\n$imageUrl';
    await shareText(message);
  }
}
