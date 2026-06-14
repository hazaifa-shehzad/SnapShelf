import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String coverLocalPath;
  final String coverPhotoId;
  final String color;
  final int photoCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlbumModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description = '',
    this.coverLocalPath = '',
    this.coverPhotoId = '',
    this.color = 'purple',
    required this.photoCount,
    required this.createdAt,
    required this.updatedAt,
  });

  AlbumModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? coverLocalPath,
    String? coverPhotoId,
    String? color,
    int? photoCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlbumModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      coverLocalPath: coverLocalPath ?? this.coverLocalPath,
      coverPhotoId: coverPhotoId ?? this.coverPhotoId,
      color: color ?? this.color,
      photoCount: photoCount ?? this.photoCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'coverLocalPath': coverLocalPath,
      'coverPhotoId': coverPhotoId,
      'color': color,
      'photoCount': photoCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    final createdAt = _dateFromJson(json['createdAt']) ?? DateTime.now();
    final updatedAt = _dateFromJson(json['updatedAt']) ?? createdAt;

    return AlbumModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      coverLocalPath: json['coverLocalPath'] as String? ?? '',
      coverPhotoId: json['coverPhotoId'] as String? ?? '',
      color: json['color'] as String? ?? 'purple',
      photoCount: json['photoCount'] as int? ?? 0,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

DateTime? _dateFromJson(Object? value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
