import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/video_model.dart';

class DetailScreen extends StatefulWidget {
  final String videoId;
  const DetailScreen({super.key, required this.videoId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  VideoModel? _video;
  bool _isLoading = true;
  bool _isFavorite = false;
  bool _showQuiz = false;
  int _currentQuestion = 0;
  int _score = 0;
  int _userPoints = 0;
  List<Map<String, dynamic>> _quizQuestions = [];
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadVideoDetails();
    _checkIfFavorite();
    _loadUserPoints();
  }

  Future<void> _loadUserPoints() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      // Buscar pontos do usuário (você pode criar uma tabela user_points)
      setState(() {
        _userPoints = 0; // Inicializa, depois você pode buscar do banco
      });
    }
  }

  Future<void> _saveUserPoints(int newPoints) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      // Salvar pontos (opcional - criar tabela user_progress)
      debugPrint('Usuário ganhou $newPoints pontos!');
    }
  }

  Future<void> _loadVideoDetails() async {
    try {
      final response = await _supabase
          .from('videos')
          .select()
          .eq('id', widget.videoId)
          .single();

      setState(() {
        _video = VideoModel.fromJson(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao carregar detalhes do vídeo')),
        );
      }
    }
  }

  Future<void> _checkIfFavorite() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', user.id)
        .eq('video_id', widget.videoId);

    if (mounted) {
      setState(() {
        _isFavorite = response.isNotEmpty;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    if (_isFavorite) {
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', user.id)
          .eq('video_id', widget.videoId);
      setState(() => _isFavorite = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removido dos favoritos')),
        );
      }
    } else {
      await _supabase.from('favorites').insert({
        'user_id': user.id,
        'video_id': widget.videoId,
      });
      setState(() => _isFavorite = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicionado aos favoritos!')),
        );
      }
    }
  }

  Future<void> _addToHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    // Adicionar ao histórico
    await _supabase.from('history').insert({
      'user_id': user.id,
      'video_id': widget.videoId,
      'watched_at': DateTime.now().toIso8601String(),
    });

    // Incrementar views
    if (_video != null) {
      await _supabase
          .from('videos')
          .update({'views': (_video!.views + 1)}).eq('id', widget.videoId);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Vídeo assistido! Agora vamos testar seus conhecimentos! 🎓')),
      );

      // Mostrar quiz após assistir o vídeo
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _startQuiz();
        }
      });
    }
  }

  int _extractTabuadaNumber(String title) {
    final match = RegExp(r'Tabuada do (\d+)').firstMatch(title);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 0;
  }

  void _startQuiz() {
    if (_video == null) return;

    final tabuadaNum = _extractTabuadaNumber(_video!.title);
    if (tabuadaNum == 0) {
      // Se não for vídeo de tabuada, apenas volta pra home
      context.go('/home');
      return;
    }

    setState(() {
      _showQuiz = true;
      _currentQuestion = 0;
      _score = 0;
      _quizQuestions = _generateQuestions(tabuadaNum);
    });
  }

  List<Map<String, dynamic>> _generateQuestions(int number) {
    List<Map<String, dynamic>> questions = [];
    // Gerar 5 perguntas aleatórias sobre a tabuada
    List<int> multipliers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    multipliers.shuffle();
    multipliers = multipliers.take(5).toList();

    for (int i = 0; i < multipliers.length; i++) {
      final multiplier = multipliers[i];
      final answer = number * multiplier;

      // Gerar opções erradas
      List<int> wrongOptions = [];
      wrongOptions.add(answer + number);
      wrongOptions.add(answer - number);
      wrongOptions.add(answer + 1);
      wrongOptions.add(answer - 1);
      wrongOptions.add(answer + 2);
      wrongOptions.add(answer - 2);

      // Remover duplicatas e valores negativos
      wrongOptions =
          wrongOptions.toSet().where((v) => v > 0 && v != answer).toList();
      wrongOptions = wrongOptions.take(3).toList();

      // Garantir que temos 3 opções erradas
      while (wrongOptions.length < 3) {
        wrongOptions.add(answer + wrongOptions.length + 1);
      }

      final allOptions = [answer, ...wrongOptions]..shuffle();

      questions.add({
        'question': '$number × $multiplier = ?',
        'answer': answer,
        'options': allOptions,
        'multiplier': multiplier,
      });
    }
    return questions;
  }

  void _checkAnswer(int selected, int correct) async {
    if (selected == correct) {
      final pointsGained = 10;
      setState(() {
        _score += pointsGained;
        _userPoints += pointsGained;
      });
      await _saveUserPoints(pointsGained);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text('✅ Correto! +$pointsGained pontos'),
              ],
            ),
            backgroundColor: Colors.green[700],
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.cancel, color: Colors.red),
                const SizedBox(width: 8),
                Text('❌ Errado! A resposta era $correct'),
              ],
            ),
            backgroundColor: Colors.red[700],
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }

    // Próxima pergunta
    if (_currentQuestion + 1 < _quizQuestions.length) {
      setState(() {
        _currentQuestion++;
      });
    } else {
      // Fim do quiz
      final totalScore = _score;
      final maxScore = _quizQuestions.length * 10;
      final percentage = (totalScore / maxScore * 100).round();

      await _saveUserPoints(totalScore);

      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Row(
              children: [
                Icon(
                  percentage >= 70 ? Icons.emoji_events : Icons.school,
                  color: percentage >= 70 ? Colors.amber : Colors.orange,
                ),
                const SizedBox(width: 8),
                const Text('Quiz Finalizado!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: totalScore / maxScore,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey[200],
                        color: percentage >= 70 ? Colors.green : Colors.orange,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          '$totalScore',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '/ $maxScore',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  _getMotivationalMessage(percentage),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      'Total ganho: $totalScore pontos',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  setState(() => _showQuiz = false);
                  context.go('/home');
                },
                child: const Text('Voltar para Home'),
              ),
              if (percentage >= 70)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    setState(() => _showQuiz = false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Continuar Aprendendo'),
                ),
            ],
          ),
        );
      }

      setState(() => _showQuiz = false);
    }
  }

  String _getMotivationalMessage(int percentage) {
    if (percentage >= 90) {
      return "🎉 Incrível! Você é um mestre da tabuada! Continue assim! 🌟";
    } else if (percentage >= 70) {
      return "👍 Muito bom! Você está no caminho certo. Continue praticando! 📚";
    } else if (percentage >= 50) {
      return "📖 Bom trabalho! Com mais um pouco de prática você chega lá! 💪";
    } else {
      return "🌱 Continue praticando! Todo mundo começa assim. Você vai melhorar! 🚀";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.orange),
              SizedBox(height: 16),
              Text('Carregando...'),
            ],
          ),
        ),
      );
    }

    if (_video == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhes')),
        body: const Center(child: Text('Vídeo não encontrado')),
      );
    }

    // Tela do Quiz
    if (_showQuiz) {
      return _buildQuizScreen();
    }

    // Tela de Detalhes do Vídeo
    final tabuadaNum = _extractTabuadaNumber(_video!.title);

    return Scaffold(
      appBar: AppBar(
        title: Text(_video!.title),
        backgroundColor: const Color(0xFFFFF3E0),
      ),
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Capa do vídeo
              Stack(
                children: [
                  Image.network(
                    _video!.coverUrl,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 280,
                      width: double.infinity,
                      color: Colors.orange[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calculate,
                              size: 80,
                              color: Colors.orange[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              tabuadaNum > 0
                                  ? 'Tabuada do $tabuadaNum'
                                  : _video!.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tabuadaNum > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange[700],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Tabuada do $tabuadaNum',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          _video!.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 3,
                                  color: Colors.black45),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informações do vídeo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.visibility,
                                  size: 14, color: Colors.brown),
                              const SizedBox(width: 4),
                              Text(
                                '${_video!.views} aulas assistidas',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.brown),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _video!.category,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.brown),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Descrição
                    const Text(
                      'Sobre esta aula',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _video!.description,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),

                    const SizedBox(height: 16),

                    // Dica especial para tabuada
                    if (tabuadaNum > 0)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb, color: Colors.orange[700]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _getTabuadaTip(tabuadaNum),
                                style: TextStyle(
                                    fontSize: 13, color: Colors.brown[700]),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // Botões de ação
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _addToHistory,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Assistir e Fazer Quiz'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor:
                                _isFavorite ? Colors.red[100] : Colors.white,
                            radius: 28,
                            child: IconButton(
                              icon: Icon(
                                _isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isFavorite
                                    ? Colors.red
                                    : Colors.orange[700],
                                size: 28,
                              ),
                              onPressed: _toggleFavorite,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Preview da tabuada
                    if (tabuadaNum > 0)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '📚 Tabela da Tabuada',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 1.5,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                final multiplier = index + 1;
                                final result = tabuadaNum * multiplier;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.orange[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$tabuadaNum × $multiplier = $result',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTabuadaTip(int num) {
    switch (num) {
      case 1:
        return "💡 Dica: Qualquer número multiplicado por 1 é ele mesmo!";
      case 2:
        return "💡 Dica: Multiplicar por 2 é o mesmo que dobrar o número!";
      case 3:
        return "💡 Dica: Some o número três vezes: $num + $num + $num";
      case 4:
        return "💡 Dica: Multiplicar por 4 é dobrar e dobrar de novo!";
      case 5:
        return "💡 Dica: O resultado sempre termina em 0 ou 5!";
      case 6:
        return "💡 Dica: Multiplique por 3 e depois dobre o resultado!";
      case 7:
        return "💡 Dica: 7×8 é 56 (5,6,7,8 - 56)";
      case 8:
        return "💡 Dica: Multiplicar por 8 é dobrar três vezes!";
      case 9:
        return "💡 Dica: Use o método dos dedos! 9×3 = 27 (2 e 7)";
      case 10:
        return "💡 Dica: Basta adicionar um zero no final do número!";
      default:
        return "💡 Pratique diariamente para memorizar!";
    }
  }

  Widget _buildQuizScreen() {
    if (_quizQuestions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final question = _quizQuestions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _quizQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.quiz, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Quiz da Tabuada'),
          ],
        ),
        backgroundColor: Colors.orange[100],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: Column(
          children: [
            // Barra de progresso
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Questão ${_currentQuestion + 1}/${_quizQuestions.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            '$_score pts',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    color: Colors.orange,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone decorativo
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${_currentQuestion + 1}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Pergunta
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          question['question'],
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Opções de resposta
                    ...question['options'].map<Widget>((option) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () =>
                                _checkAnswer(option, question['answer']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.brown[800],
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(
                                    color: Colors.orange[300]!, width: 2),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              option.toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
