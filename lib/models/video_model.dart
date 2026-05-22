class VideoModel {
<<<<<<< HEAD
  final int id;
  final int numero;
  final String title;
  final String description;
  final String imageUrl;
=======
  final String id;
  final String title;
  final String description;
  final String coverUrl;
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
  final String videoUrl;
  final String category;
  final int views;

  VideoModel({
    required this.id,
<<<<<<< HEAD
    required this.numero,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.category,
    required this.views,
=======
    required this.title,
    required this.description,
    required this.coverUrl,
    required this.videoUrl,
    required this.category,
    this.views = 0,
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
<<<<<<< HEAD
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
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
