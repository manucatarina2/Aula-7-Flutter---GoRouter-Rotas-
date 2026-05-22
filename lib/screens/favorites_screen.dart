import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
<<<<<<< HEAD
=======
import '../models/video_model.dart';
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
<<<<<<< HEAD
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _favorites = [];
=======
  List<VideoModel> _favorites = [];
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
<<<<<<< HEAD
    final user = _supabase.auth.currentUser;
=======
    final user = Supabase.instance.client.auth.currentUser;
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
<<<<<<< HEAD
      final result = await _supabase
          .from('favoritos')
          .select()
          .eq('user_id', user.id);

      List<Map<String, dynamic>> completeFavorites = [];

      for (var fav in result) {
        final tipo = fav['tipo_nivel'];
        final tabuadaId = fav['tabuada_id'];
        Map<String, dynamic>? tabuadaData;

        if (tipo == 'basico') {
          final data = await _supabase
              .from('tabuadas_basicas')
              .select()
              .eq('id', tabuadaId)
              .single();
          tabuadaData = data;
        } else if (tipo == 'intermediario') {
          final data = await _supabase
              .from('tabuadas_intermediarias')
              .select()
              .eq('id', tabuadaId)
              .single();
          tabuadaData = data;
        } else if (tipo == 'avancado') {
          final data = await _supabase
              .from('tabuadas_avancadas')
              .select()
              .eq('id', tabuadaId)
              .single();
          tabuadaData = data;
        }

        if (tabuadaData != null) {
          completeFavorites.add({
            ...tabuadaData,
            'tipo_nivel': tipo,
            'favorito_id': fav['id'],
          });
        }
      }

      setState(() {
        _favorites = completeFavorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar favoritos: ${e.toString()}')),
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
        );
      }
    }
  }

<<<<<<< HEAD
  Future<void> _removeFavorite(int favoritoId, int tabuadaId, String tipo) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      await _supabase
          .from('favoritos')
          .delete()
          .eq('id', favoritoId);

      setState(() {
        _favorites.removeWhere((item) => item['id'] == tabuadaId && item['tipo_nivel'] == tipo);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removido dos favoritos!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover: ${e.toString()}')),
        );
      }
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
<<<<<<< HEAD
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber[100]!, Colors.amber[50]!],
          ),
        ),
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favorites.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
<<<<<<< HEAD
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.amber[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum favorito ainda',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.amber[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Vá até a tela inicial e favorite suas tabuadas!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[400],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/home'),
                          child: const Text('Explorar Tabuadas'),
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
<<<<<<< HEAD
                      final fav = _favorites[index];
=======
                      final video = _favorites[index];
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
<<<<<<< HEAD
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber[200],
                            child: Text(
                              '${fav['numero']}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                              ),
                            ),
                          ),
                          title: Text(
<<<<<<< HEAD
                            '${fav['numero']} × ${fav['multiplicador']} = ${fav['resultado']}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(_getNivelText(fav['tipo_nivel'])),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFavorite(
                              fav['favorito_id'],
                              fav['id'],
                              fav['tipo_nivel'],
                            ),
                          ),
                          onTap: () {
                            context.push(
                              '/detail/${fav['tipo_nivel']}/${fav['id']}',
                              extra: {
                                'numero': fav['numero'],
                                'multiplicador': fav['multiplicador'],
                                'resultado': fav['resultado'],
                              },
                            );
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
<<<<<<< HEAD

  String _getNivelText(String nivel) {
    switch (nivel) {
      case 'basico':
        return 'Nível Básico';
      case 'intermediario':
        return 'Nível Intermediário';
      case 'avancado':
        return 'Nível Avançado';
      default:
        return nivel;
    }
  }
}
=======
}
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
