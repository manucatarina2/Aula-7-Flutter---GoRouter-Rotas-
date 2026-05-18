import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/video_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, List<VideoModel>> _videosByCategory = {};
  bool _isLoading = true;
  int _selectedIndex = 0;
  int _userPoints = 0;
  String _userName = 'Aluno';

  @override
  void initState() {
    super.initState();
    _loadVideos();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.email?.split('@')[0] ?? 'Aluno';
      });
    }
  }

  Future<void> _loadVideos() async {
    try {
      final response = await Supabase.instance.client
          .from('videos')
          .select()
          .order('views', ascending: false);

      final Map<String, List<VideoModel>> tempMap = {};
      for (var videoJson in response) {
        final video = VideoModel.fromJson(videoJson);
        if (!tempMap.containsKey(video.category)) {
          tempMap[video.category] = [];
        }
        tempMap[video.category]!.add(video);
      }

      if (mounted) {
        setState(() {
          _videosByCategory = tempMap;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        context.go('/favorites');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calculate, color: Colors.orange),
            ),
            const SizedBox(width: 8),
            const Text(
              'Multiplica+',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFFF3E0),
        elevation: 0,
        actions: [
          // Pontuação do usuário
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '$_userPoints pts',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      'Carregando sua jornada matemática...',
                      style: TextStyle(color: Colors.brown[600]),
                    ),
                  ],
                ),
              )
            : _videosByCategory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calculate,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum conteúdo disponível',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      // Banner motivacional
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange[400]!, Colors.orange[700]!],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.emoji_events,
                                color: Colors.white, size: 40),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Olá, $_userName! 👋',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Continue praticando a tabuada e ganhe estrelas! ⭐',
                                    style: TextStyle(
                                        color: Colors.white
                                            .withValues(alpha: 0.9)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Categorias de vídeos
                      ..._videosByCategory.keys.map((category) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 16, 16, 12),
                              child: Row(
                                children: [
                                  _getCategoryIcon(category),
                                  const SizedBox(width: 8),
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${_videosByCategory[category]!.length} vídeos',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.brown[500]),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 210,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                itemCount: _videosByCategory[category]!.length,
                                itemBuilder: (context, index) {
                                  final video =
                                      _videosByCategory[category]![index];
                                  return _buildVideoCard(video);
                                },
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange[700],
        unselectedItemColor: Colors.brown[400],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFF3E0),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category) {
    IconData icon;
    Color color;

    if (category.contains('Básicas')) {
      icon = Icons.looks_one;
      color = Colors.green;
    } else if (category.contains('Intermediárias')) {
      icon = Icons.looks_two;
      color = Colors.blue;
    } else if (category.contains('Avançadas')) {
      icon = Icons.auto_awesome;
      color = Colors.purple;
    } else {
      icon = Icons.sports_esports;
      color = Colors.orange;
    }

    return Icon(icon, color: color, size: 24);
  }

  Widget _buildVideoCard(VideoModel video) {
    // Extrair o número da tabuada do título
    int tabuadaNum = 0;
    final match = RegExp(r'Tabuada do (\d+)').firstMatch(video.title);
    if (match != null) {
      tabuadaNum = int.parse(match.group(1)!);
    }

    return GestureDetector(
      onTap: () => context.go('/detail/${video.id}'),
      child: Container(
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    video.coverUrl,
                    height: 130,
                    width: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 130,
                      width: 150,
                      color: Colors.orange[100],
                      child: Center(
                        child: Text(
                          tabuadaNum > 0 ? '$tabuadaNum ×' : '🎓',
                          style: TextStyle(
                              fontSize: 40, color: Colors.orange[700]),
                        ),
                      ),
                    ),
                  ),
                ),
                if (tabuadaNum > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange[700],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$tabuadaNum',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              video.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.play_circle, size: 14, color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  '${video.views} aulas',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
