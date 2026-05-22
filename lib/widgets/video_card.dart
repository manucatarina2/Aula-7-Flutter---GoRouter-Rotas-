import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/video_model.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;

  const VideoCard({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/detail/${video.id}',
          extra: {
            'videoId': video.id.toString(),
            'title': video.title,
            'description': video.description,
            'imageUrl': video.imageUrl,
            'category': video.category,
            'numero': video.numero,
            'videoUrl': video.videoUrl,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5DC), // Amarelo manteiga claro
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do vídeo
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  // Imagem
                  SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: video.imageUrl.isNotEmpty
                        ? Image.network(
                            video.imageUrl,
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                height: 120,
                                color: const Color(0xFFF5DEB3),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFFFD700),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: const Color(0xFFF5DEB3),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${video.numero}',
                                        style: const TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFC107),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Tabuada',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.brown,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            height: 120,
                            color: const Color(0xFFF5DEB3),
                            child: Center(
                              child: Text(
                                '${video.numero}',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFC107),
                                ),
                              ),
                            ),
                          ),
                  ),
                  
                  // Ícone de play sobre a imagem
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Color(0xFFFFD700),
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Informações
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Número da tabuada
                  Text(
                    'Tabuada do ${video.numero}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF8F00),
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Título
                  Text(
                    video.title.length > 20 ? '${video.title.substring(0, 18)}...' : video.title,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.brown,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  // Categoria
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      video.category,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFFFF8F00),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}