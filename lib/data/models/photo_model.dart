class PhotoModel {
  final String id;
  final String albumId;
  final String title;
  final String imageUrl;
  final String size;
  final bool isFavorite;
  final DateTime uploadedAt;

  const PhotoModel({
    required this.id,
    required this.albumId,
    required this.title,
    required this.imageUrl,
    required this.size,
    this.isFavorite = false,
    required this.uploadedAt,
  });

  PhotoModel copyWith({
    String? id,
    String? albumId,
    String? title,
    String? imageUrl,
    String? size,
    bool? isFavorite,
    DateTime? uploadedAt,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      albumId: albumId ?? this.albumId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      size: size ?? this.size,
      isFavorite: isFavorite ?? this.isFavorite,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'albumId': albumId,
      'title': title,
      'imageUrl': imageUrl,
      'size': size,
      'isFavorite': isFavorite,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String? ?? '',
      albumId: json['albumId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      size: json['size'] as String? ?? '0 MB',
      isFavorite: json['isFavorite'] as bool? ?? false,
      uploadedAt: DateTime.tryParse(json['uploadedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
