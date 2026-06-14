class PhotoImageData {
  final String id;
  final String localPath;
  final String? albumName;
  final DateTime? createdAt;

  const PhotoImageData({
    required this.id,
    required this.localPath,
    this.albumName,
    this.createdAt,
  });
}
