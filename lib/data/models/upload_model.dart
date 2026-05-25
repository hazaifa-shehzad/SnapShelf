enum UploadStatus { idle, selected, uploading, completed, failed }

class UploadModel {
  final String id;
  final String fileName;
  final String filePath;
  final String? albumId;
  final double progress;
  final UploadStatus status;
  final DateTime createdAt;

  const UploadModel({
    required this.id,
    required this.fileName,
    required this.filePath,
    this.albumId,
    this.progress = 0,
    this.status = UploadStatus.idle,
    required this.createdAt,
  });

  UploadModel copyWith({
    String? id,
    String? fileName,
    String? filePath,
    String? albumId,
    double? progress,
    UploadStatus? status,
    DateTime? createdAt,
  }) {
    return UploadModel(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      albumId: albumId ?? this.albumId,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
