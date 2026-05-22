import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:go_router/go_router.dart';
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/video_model.dart';
import '../widgets/video_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _supabase = Supabase.instance.client;
<<<<<<< HEAD
  List<VideoModel> _videos = [];
  bool _isLoading = true;
=======
  List<VideoModel> _allVideos = [];
  bool _isLoading = true;
  int _totalPoints = 0;
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    try {
      final result = await _supabase
          .from('videos_tabuadas')
          .select()
          .order('numero', ascending: true);

      setState(() {
        _videos = result.map((json) => VideoModel.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar vídeos: $e')),
        );
      }
    }
=======
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final profileData = await _supabase
            .from('profiles')
            .select('total_points')
            .eq('id', user.id)
            .maybeSingle();
        if (profileData != null) {
          _totalPoints = profileData['total_points'] ?? 0;
        }
      }

      final videosData = await _supabase.from('videos').select();
      
      final List<VideoModel> videosList = [];
      for (var json in videosData as List) {
        videosList.add(VideoModel.fromJson(json));
      }
      
      // Ordenar por multiplicationTable
      videosList.sort((a, b) {
        final int aValue = a.multiplicationTable;
        final int bValue = b.multiplicationTable;
        return aValue.compareTo(bValue);
      });
      
      setState(() {
        _allVideos = videosList;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Erro ao carregar: $e');
      setState(() => _isLoading = false);
    }
  }

  List<VideoModel> get _basicVideos {
    List<VideoModel> result = [];
    for (var v in _allVideos) {
      if (v.multiplicationTable <= 3) {
        result.add(v);
      }
    }
    return result;
  }

  List<VideoModel> get _intermediateVideos {
    List<VideoModel> result = [];
    for (var v in _allVideos) {
      if (v.multiplicationTable >= 4 && v.multiplicationTable <= 6) {
        result.add(v);
      }
    }
    return result;
  }

  List<VideoModel> get _advancedVideos {
    List<VideoModel> result = [];
    for (var v in _allVideos) {
      if (v.multiplicationTable >= 7) {
        result.add(v);
      }
    }
    return result;
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiplica+'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: const Color(0xFF5D4037),
      ),
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                ),
              )
            : _videos.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum vídeo encontrado',
                      style: TextStyle(color: Color(0xFF5D4037)),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFF0B5), Color(0xFFFFF8E1)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFFFFD700).withOpacity(0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.school, color: Color(0xFFFFC107), size: 40),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Aprenda Tabuada',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF5D4037),
                                      ),
                                    ),
                                    Text(
                                      'Clique em qualquer card para assistir o vídeo',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8D6E63),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: _videos.length,
                            itemBuilder: (context, index) {
                              return VideoCard(video: _videos[index]);
                            },
                          ),
=======
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.pink),
              SizedBox(height: 16),
              Text('Carregando tabuadas...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('TabuadaPlay', style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.pink[300]!, Colors.purple[300]!, Colors.orange[200]!],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white54,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$_totalPoints pts',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite, color: Colors.white),
                                  onPressed: () => context.push('/favorites'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.history, color: Colors.white),
                                  onPressed: () => context.push('/history'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.person, color: Colors.white),
                                  onPressed: () => context.push('/profile'),
                                ),
                              ],
                            ),
                          ],
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                        ),
                      ],
                    ),
                  ),
<<<<<<< HEAD
=======
                ),
              ),
            ),
          ),

          // Seção 1: Tabuadas Básicas
          if (_basicVideos.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      children: [
                        Text('🌱', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text(
                          'Tabuadas Básicas',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(Do 1 ao 3)',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Comece sua jornada pelas tabuadas mais simples!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _basicVideos.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 180,
                          child: VideoCard(video: _basicVideos[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Seção 2: Tabuadas Intermediárias
          if (_intermediateVideos.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(
                      children: [
                        Text('⚡', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text(
                          'Tabuadas Intermediárias',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(Do 4 ao 6)',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Aumente o desafio! Tabuadas um pouco mais complexas.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _intermediateVideos.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 180,
                          child: VideoCard(video: _intermediateVideos[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Seção 3: Tabuadas Avançadas
          if (_advancedVideos.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(
                      children: [
                        Text('🏆', style: TextStyle(fontSize: 24)),
                        SizedBox(width: 8),
                        Text(
                          'Tabuadas Avançadas',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '(Do 7 ao 10)',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Desafie-se com as tabuadas mais difíceis!',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _advancedVideos.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 180,
                          child: VideoCard(video: _advancedVideos[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              context.push('/favorites');
              break;
            case 2:
              context.push('/history');
              break;
            case 3:
              context.push('/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink[300],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
      ),
    );
  }
}