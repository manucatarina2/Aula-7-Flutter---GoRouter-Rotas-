import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/video_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await Supabase.instance.client.from('history').select('''
            id,
            watched_at,
            videos (*)
          ''').eq('user_id', user.id).order('watched_at', ascending: false);

      setState(() {
        _history = response;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar histórico: $e')),
        );
      }
    }
  }

  Future<void> _clearHistory() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    await Supabase.instance.client
        .from('history')
        .delete()
        .eq('user_id', user.id);

    setState(() {
      _history = [];
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Histórico limpo com sucesso!')),
      );
    }
  }

  Future<void> _removeFromHistory(String historyId) async {
    await Supabase.instance.client.from('history').delete().eq('id', historyId);

    setState(() {
      _history.removeWhere((item) => item['id'] == historyId);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removido do histórico')),
      );
    }
  }

  String _formatDate(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString);
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else if (difference.inDays > 0) {
      return 'Há ${difference.inDays} ${difference.inDays == 1 ? 'dia' : 'dias'}';
    } else if (difference.inHours > 0) {
      return 'Há ${difference.inHours} ${difference.inHours == 1 ? 'hora' : 'horas'}';
    } else if (difference.inMinutes > 0) {
      return 'Há ${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minutos'}';
    } else {
      return 'Agora mesmo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Assistidos'),
        backgroundColor: const Color(0xFFFFF3E0),
        actions: [
          if (_history.isNotEmpty)
            TextButton(
              onPressed: _clearHistory,
              child: const Text(
                'Limpar tudo',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 80, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum vídeo assistido',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Assista vídeos para aparecerem aqui!',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/home'),
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
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final historyItem = _history[index];
                      final video = VideoModel.fromJson(historyItem['videos']);
                      final watchedAt = historyItem['watched_at'].toString();

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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(video.category),
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(watchedAt),
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () =>
                                _removeFromHistory(historyItem['id']),
                          ),
                          onTap: () => context.go('/detail/${video.id}'),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
