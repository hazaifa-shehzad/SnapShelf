class PhotoImageData {
  final String id;
  final String imageUrl;
  final String? albumName;
  final DateTime? createdAt;

  const PhotoImageData({
    required this.id,
    required this.imageUrl,
    this.albumName,
    this.createdAt,
  });
}
