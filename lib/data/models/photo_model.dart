import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  final String id;
  final String userId;
  final String albumId;
  final String title;
  final String localPath;
  final String fileName;
  final String fileType;
  final int fileSize;
  final bool isFavorite;
  final bool isLocalOnly;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PhotoModel({
    required this.id,
    required this.userId,
    required this.albumId,
    required this.title,
    required this.localPath,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    this.isFavorite = false,
    this.isLocalOnly = true,
    required this.createdAt,
    required this.updatedAt,
  });

  PhotoModel copyWith({
    String? id,
    String? userId,
    String? albumId,
    String? title,
    String? localPath,
    String? fileName,
    String? fileType,
    int? fileSize,
    bool? isFavorite,
    bool? isLocalOnly,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      albumId: albumId ?? this.albumId,
      title: title ?? this.title,
      localPath: localPath ?? this.localPath,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      isFavorite: isFavorite ?? this.isFavorite,
      isLocalOnly: isLocalOnly ?? this.isLocalOnly,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'albumId': albumId,
      'title': title,
      'localPath': localPath,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'isFavorite': isFavorite,
      'isLocalOnly': isLocalOnly,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    final createdAt =
        _dateFromJson(json['createdAt']) ??
        _dateFromJson(json['uploadedAt']) ??
        DateTime.now();
    final updatedAt = _dateFromJson(json['updatedAt']) ?? createdAt;

    return PhotoModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      albumId: json['albumId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      localPath: json['localPath'] as String? ?? '',
      fileName: json['fileName'] as String? ?? json['title'] as String? ?? '',
      fileType: json['fileType'] as String? ?? '',
      fileSize: json['fileSize'] as int? ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      isLocalOnly: json['isLocalOnly'] as bool? ?? true,
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
