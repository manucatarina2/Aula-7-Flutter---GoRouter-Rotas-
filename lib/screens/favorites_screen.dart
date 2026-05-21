import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/video_model.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<VideoModel> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final response =
          await Supabase.instance.client.from('favorites').select('''
            video_id,
            videos (*)
          ''').eq('user_id', user.id);

      if (mounted) {
        // Adicionado verificação mounted
        setState(() {
          _favorites = response.map((item) {
            return VideoModel.fromJson(item['videos']);
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // Adicionado verificação mounted
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar favoritos: $e')),
        );
      }
    }
  }

  Future<void> _removeFavorite(String videoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    await Supabase.instance.client
        .from('favorites')
        .delete()
        .eq('user_id', user.id)
        .eq('video_id', videoId);

    if (mounted) {
      // Adicionado verificação mounted
      setState(() {
        _favorites.removeWhere((v) => v.id == videoId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removido dos favoritos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
        backgroundColor: const Color(0xFFFFF3E0),
        actions: [
          if (_favorites.isNotEmpty)
            TextButton(
              onPressed: () async {
                final user = Supabase.instance.client.auth.currentUser;
                if (user == null) return;

                await Supabase.instance.client
                    .from('favorites')
                    .delete()
                    .eq('user_id', user.id);

                if (mounted) {
                  // Adicionado verificação mounted
                  setState(() => _favorites.clear());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Todos favoritos removidos')),
                  );
                }
              },
              child: const Text('Limpar tudo'),
            ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favorites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum favorito ainda',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione vídeos aos favoritos na tela de detalhes!',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (mounted) context.go('/home');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Explorar vídeos'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final video = _favorites[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              video.coverUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.movie),
                              ),
                            ),
                          ),
                          title: Text(
                            video.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(video.category),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _removeFavorite(video.id),
                          ),
                          onTap: () {
                            if (mounted) context.go('/detail/${video.id}');
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
