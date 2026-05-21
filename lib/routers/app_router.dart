class VideoModel {
  final String id;
  final String title;
  final String description;
  final String synopsis;
  final String coverUrl;
  final String? videoUrl;
  final int multiplicationTable;
  final String level;
  final int points;
  final bool isFeatured;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.synopsis,
    required this.coverUrl,
    this.videoUrl,
    required this.multiplicationTable,
    required this.level,
    required this.points,
    required this.isFeatured,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      synopsis: json['synopsis'] ?? '',
      coverUrl: json['cover_url'] ?? '',
      videoUrl: json['video_url'],
      multiplicationTable: json['multiplication_table'] ?? 0,
      level: json['level'] ?? 'Fácil',
      points: json['points'] ?? 0,
      isFeatured: json['is_featured'] ?? false,
    );
  }
}