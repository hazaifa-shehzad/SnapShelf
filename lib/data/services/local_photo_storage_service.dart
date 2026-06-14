import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalPhotoStorageService {
  const LocalPhotoStorageService();

  Future<LocalPhotoFile> copyPickedImage(XFile image) async {
    final appDirectory = await getApplicationDocumentsDirectory();
    final photosDirectory = Directory(p.join(appDirectory.path, 'photos'));

    if (!await photosDirectory.exists()) {
      await photosDirectory.create(recursive: true);
    }

    final originalName = image.name.trim().isEmpty ? 'photo.jpg' : image.name;
    final extension = p.extension(originalName).isEmpty
        ? '.jpg'
        : p.extension(originalName);
    final storedFileName = '${DateTime.now().microsecondsSinceEpoch}$extension';
    final localPath = p.join(photosDirectory.path, storedFileName);

    final sourceFile = File(image.path);
    await sourceFile.copy(localPath);

    final savedFile = File(localPath);
    final fileSize = await savedFile.length();

    return LocalPhotoFile(
      localPath: localPath,
      fileName: originalName,
      fileType: extension.replaceFirst('.', '').toLowerCase(),
      fileSize: fileSize,
    );
  }
}

class LocalPhotoFile {
  const LocalPhotoFile({
    required this.localPath,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
  });

  final String localPath;
  final String fileName;
  final String fileType;
  final int fileSize;
}
