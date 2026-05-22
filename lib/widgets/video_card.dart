import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/video_model.dart';

class VideoCard extends StatelessWidget {
  final VideoModel video;
<<<<<<< HEAD

  const VideoCard({super.key, required this.video});
=======
  
  const VideoCard({
    super.key,
    required this.video,
  });
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
<<<<<<< HEAD
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
=======
      onTap: () => context.push('/details/${video.id}'),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
<<<<<<< HEAD
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
=======
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background com gradiente
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.pink[200]!, Colors.purple[200]!],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calculate, size: 50, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        '${video.multiplicationTable} × ?',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Gradiente overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                ),
              ),
              // Conteúdo
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.pink[400],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Tabuada do ${video.multiplicationTable}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        video.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Text(_getLevelIcon(video.level), style: const TextStyle(fontSize: 10)),
                                const SizedBox(width: 4),
                                Text(
                                  video.level,
                                  style: const TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.yellow, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${video.points}',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
        ),
      ),
    );
  }
<<<<<<< HEAD
}
=======

  String _getLevelIcon(String level) {
    switch (level) {
      case 'Fácil':
        return '🌟';
      case 'Médio':
        return '⚡';
      case 'Difícil':
        return '🏆';
      default:
        return '📚';
    }
  }
} 
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
