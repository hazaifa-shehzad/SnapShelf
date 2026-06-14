import 'package:share_plus/share_plus.dart';

class ShareService {
  ShareService._();

  static Future<void> shareText(String text) async {
    if (text.trim().isEmpty) return;
    await SharePlus.instance.share(ShareParams(text: text.trim()));
  }

  static Future<void> sharePhoto({
    required String title,
    required String localPath,
  }) async {
    final message = '$title\n$localPath';
    await shareText(message);
  }
}
