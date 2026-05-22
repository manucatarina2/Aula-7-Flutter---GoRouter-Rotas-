class VideoModel {
  final int id;
  final int numero;
  final String title;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final String category;
  final int views;

  VideoModel({
    required this.id,
    required this.numero,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.category,
    required this.views,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      numero: json['numero'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      category: json['category'] ?? 'Tabuada',
      views: json['views'] ?? 0,
    );
  }
}