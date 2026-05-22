import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class DetailScreen extends StatefulWidget {
  final String videoId;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final int numero;
  final String videoUrl;

  const DetailScreen({
    super.key,
    required this.videoId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.numero,
    required this.videoUrl,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _supabase = Supabase.instance.client;
  bool _isFavorite = false;
  bool _isLoading = true;
  String? _userId;
  List<Map<String, dynamic>> _tabuadaCompleta = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      _userId = user.id;
      await _checkIfFavorite();
    }
    await _loadFullTabuada();
    await _addToHistory();
    setState(() => _isLoading = false);
  }

  Future<void> _loadFullTabuada() async {
    try {
      final result = await _supabase
          .from('tabuadas_basicas')
          .select()
          .eq('numero', widget.numero)
          .order('multiplicador', ascending: true);

      if (result.isNotEmpty) {
        setState(() {
          _tabuadaCompleta = List.from(result);
        });
      } else {
        _createManualTabuada();
      }
    } catch (e) {
      _createManualTabuada();
    }
  }

  void _createManualTabuada() {
    List<Map<String, dynamic>> manual = [];
    for (int i = 1; i <= 10; i++) {
      manual.add({
        'numero': widget.numero,
        'multiplicador': i,
        'resultado': widget.numero * i,
      });
    }
    setState(() {
      _tabuadaCompleta = manual;
    });
  }

  Future<void> _checkIfFavorite() async {
    try {
      final response = await _supabase
          .from('favoritos')
          .select()
          .eq('user_id', _userId!)
          .eq('tabuada_id', widget.videoId);

      if (mounted) {
        setState(() => _isFavorite = response.isNotEmpty);
      }
    } catch (e) {
      // Erro ignorado
    }
  }

  Future<void> _toggleFavorite() async {
    if (_userId == null) return;

    try {
      if (_isFavorite) {
        await _supabase
            .from('favoritos')
            .delete()
            .eq('user_id', _userId!)
            .eq('tabuada_id', widget.videoId);

        if (mounted) {
          setState(() => _isFavorite = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removido dos favoritos'),
              backgroundColor: Color(0xFFF5DEB3),
            ),
          );
        }
      } else {
        await _supabase.from('favoritos').insert({
          'user_id': _userId!,
          'tabuada_id': widget.videoId,
          'tipo_nivel': 'video',
          'created_at': DateTime.now().toIso8601String(),
        });

        if (mounted) {
          setState(() => _isFavorite = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Adicionado aos favoritos!'),
              backgroundColor: Color(0xFFFFD700),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao favoritar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _addToHistory() async {
    if (_userId == null) return;

    try {
      await _supabase.from('historico').insert({
        'user_id': _userId!,
        'tabuada_id': int.parse(widget.videoId),
        'tipo_nivel': 'video',
        'numero': widget.numero,
        'multiplicador': 1,
        'resultado': widget.numero,
        'viewed_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Erro ignorado
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF8E1),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFFFFD700),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => context.go('/home'),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  widget.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFFF5DEB3),
                              child: Center(
                                child: Text(
                                  '${widget.numero}',
                                  style: const TextStyle(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFC107),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: const Color(0xFFF5DEB3),
                          child: Center(
                            child: Text(
                              '${widget.numero}',
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFFC107),
                              ),
                            ),
                          ),
                        ),
                  Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showVideoDialog();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFFD700),
                            width: 2,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Color(0xFFFFD700),
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.redAccent : Colors.white,
                      size: 20,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.category.toUpperCase(),
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFF8F00),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5D4037),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Tabuada do ${widget.numero}',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFFFF8F00),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Text(
                    'Tabuada Completa',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3.5,
                    ),
                    itemCount: _tabuadaCompleta.length,
                    itemBuilder: (context, index) {
                      final item = _tabuadaCompleta[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5DEB3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFD700).withOpacity(0.5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${item['numero']} × ${item['multiplicador']} = ${item['resultado']}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF5D4037),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Text(
                    'Sobre este conteúdo',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF5D4037),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF5D4037).withOpacity(0.7),
                      height: 1.6,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5DEB3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFFFD700).withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Color(0xFFFFC107), size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Dica: Assista ao vídeo e acompanhe a tabuada! Pratique todos os dias para memorizar.',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: const Color(0xFF5D4037),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVideoDialog() {
    if (widget.videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL do vídeo não disponível'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    showDialog(
      context: context,
      builder: (context) => YouTubePlayerDialog(
        videoUrl: widget.videoUrl,
        title: widget.title,
      ),
    );
  }
}

// Player do YouTube
class YouTubePlayerDialog extends StatefulWidget {
  final String videoUrl;
  final String title;
  
  const YouTubePlayerDialog({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<YouTubePlayerDialog> createState() => _YouTubePlayerDialogState();
}

class _YouTubePlayerDialogState extends State<YouTubePlayerDialog> {
  late YoutubePlayerController _controller;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.tryParse(widget.videoUrl);
    String? videoId = uri?.queryParameters['v'];
    
    if (videoId == null && uri != null && uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    }

    if (videoId == null) {
      _isError = true;
    } else {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          color: 'gold',
        ),
      );
    }
  }

  @override
  void dispose() {
    if (!_isError) {
      _controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isError) {
      return AlertDialog(
        backgroundColor: const Color(0xFFF5DEB3),
        title: const Text('Erro', style: TextStyle(color: Color(0xFF5D4037))),
        content: const Text('Não foi possível carregar o vídeo.', style: TextStyle(color: Color(0xFF5D4037))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar', style: TextStyle(color: Color(0xFFFF8F00))),
          )
        ],
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF8E1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF5D4037),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF5D4037), size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
          ],
        ),
      ),
    );
  }
}