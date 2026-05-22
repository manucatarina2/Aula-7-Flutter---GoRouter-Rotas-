import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
<<<<<<< HEAD
=======
import '../models/video_model.dart';
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
<<<<<<< HEAD
  final _supabase = Supabase.instance.client;
=======
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
  List<Map<String, dynamic>> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
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
          .from('historico')
          .select()
          .eq('user_id', user.id)
          .order('viewed_at', ascending: false);

      setState(() {
        _history = List.from(result);
=======
      final response = await Supabase.instance.client.from('history').select('''
            id,
            watched_at,
            videos (*)
          ''').eq('user_id', user.id).order('watched_at', ascending: false);

      setState(() {
        _history = response;
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
          SnackBar(content: Text('Erro ao carregar histórico: ${e.toString()}')),
=======
          SnackBar(content: Text('Erro ao carregar histórico: $e')),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
        );
      }
    }
  }

  Future<void> _clearHistory() async {
<<<<<<< HEAD
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Histórico'),
        content: const Text('Tem certeza que deseja limpar todo o seu histórico?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _supabase
            .from('historico')
            .delete()
            .eq('user_id', user.id);

        setState(() {
          _history = [];
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Histórico limpo com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao limpar histórico: ${e.toString()}')),
          );
        }
      }
    }
  }

  Future<void> _removeSingleHistory(int id) async {
    try {
      await _supabase.from('historico').delete().eq('id', id);

      setState(() {
        _history.removeWhere((item) => item['id'] == id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removido do histórico!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover: ${e.toString()}')),
        );
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Data desconhecida';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

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
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Assistidos'),
<<<<<<< HEAD
        centerTitle: true,
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _clearHistory,
              tooltip: 'Limpar tudo',
=======
        backgroundColor: const Color(0xFFFFF3E0),
        actions: [
          if (_history.isNotEmpty)
            TextButton(
              onPressed: _clearHistory,
              child: const Text(
                'Limpar tudo',
                style: TextStyle(color: Colors.red),
              ),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
            ),
        ],
      ),
      body: Container(
<<<<<<< HEAD
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber[100]!, Colors.amber[50]!],
          ),
        ),
=======
        color: const Color(0xFFFFF8E1),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
<<<<<<< HEAD
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Colors.amber[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum item no histórico',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.amber[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Assista às tabuadas para aparecerem aqui!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[400],
                          ),
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/home'),
<<<<<<< HEAD
                          child: const Text('Explorar Tabuadas'),
=======
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
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
<<<<<<< HEAD
                      final item = _history[index];
=======
                      final historyItem = _history[index];
                      final video = VideoModel.fromJson(historyItem['videos']);
                      final watchedAt = historyItem['watched_at'].toString();

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
                              '${item['numero']}',
                              style: TextStyle(
                                fontSize: 18,
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
                            '${item['numero']} × ${item['multiplicador']} = ${item['resultado']}',
=======
                            video.title,
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
<<<<<<< HEAD
                              Text(_getNivelText(item['tipo_nivel'])),
                              Text(
                                _formatDate(item['viewed_at']),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
=======
                              Text(video.category),
                              const SizedBox(height: 2),
                              Text(
                                _formatDate(watchedAt),
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                              ),
                            ],
                          ),
                          trailing: IconButton(
<<<<<<< HEAD
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _removeSingleHistory(item['id']),
                            tooltip: 'Remover',
                          ),
                          onTap: () {
                            context.push(
                              '/detail/${item['tipo_nivel']}/${item['tabuada_id']}',
                              extra: {
                                'numero': item['numero'],
                                'multiplicador': item['multiplicador'],
                                'resultado': item['resultado'],
                              },
                            );
                          },
=======
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () =>
                                _removeFromHistory(historyItem['id']),
                          ),
                          onTap: () => context.go('/detail/${video.id}'),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
                        ),
                      );
                    },
                  ),
      ),
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
