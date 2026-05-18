class VideoModel {
  final String id;
  final String title;
  final String description;
  final String coverUrl;
  final String videoUrl;
  final String category;
  final int views;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.videoUrl,
    required this.category,
    this.views = 0,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverUrl: json['cover_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      category: json['category'] ?? '',
      views: json['views'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cover_url': coverUrl,
      'video_url': videoUrl,
      'category': category,
      'views': views,
    };
  }
}
