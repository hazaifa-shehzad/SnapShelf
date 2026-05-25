class AlbumModel {
  final String id;
  final String title;
  final String? coverImageUrl;
  final int photoCount;
  final DateTime createdAt;

  const AlbumModel({
    required this.id,
    required this.title,
    this.coverImageUrl,
    required this.photoCount,
    required this.createdAt,
  });

  AlbumModel copyWith({
    String? id,
    String? title,
    String? coverImageUrl,
    int? photoCount,
    DateTime? createdAt,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      title: title ?? this.title,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      photoCount: photoCount ?? this.photoCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverImageUrl': coverImageUrl,
      'photoCount': photoCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      coverImageUrl: json['coverImageUrl'] as String?,
      photoCount: json['photoCount'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
