import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userEmail;
  String? _userId;
  String? _userCreatedAt;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
        _userId = user.id;

        final createdAtRaw = user.createdAt;
        if (createdAtRaw != null) {
          final dateStr = createdAtRaw.toString();
          if (dateStr.contains(' ')) {
            _userCreatedAt = dateStr.split(' ')[0];
          } else if (dateStr.contains('T')) {
            _userCreatedAt = dateStr.split('T')[0];
          } else {
            _userCreatedAt = dateStr;
          }
          if (_userCreatedAt != null && _userCreatedAt!.contains('-')) {
            final parts = _userCreatedAt!.split('-');
            if (parts.length == 3) {
              _userCreatedAt = '${parts[2]}/${parts[1]}/${parts[0]}';
            }
          }
        } else {
          _userCreatedAt = 'Não disponível';
        }
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  Future<int> _getCount(String type) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return 0;

    final String tableName = type == 'favoritos' ? 'favorites' : 'watch_history';

    try {
      final response = await Supabase.instance.client
          .from(tableName)
          .select('id')
          .eq('user_id', user.id);

      if (response is List) {
        return response.length;
      }
      return 0;
    } catch (e) {
      debugPrint('Erro ao contar $type: $e');
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: const Color(0xFFFFF3E0),
      ),
      body: Container(
        color: const Color(0xFFFFF8E1),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _userEmail == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text('Usuário não encontrado'),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.go('/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[700],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Fazer Login'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.amber[200],
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.amber[800],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'EduStream',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Streaming Educacional',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown[500],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  Icons.email_outlined,
                                  'E-mail',
                                  _userEmail!,
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  Icons.vpn_key,
                                  'ID do Usuário',
                                  '${_userId!.substring(0, 8)}...',
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  Icons.calendar_today,
                                  'Membro desde',
                                  _userCreatedAt ?? 'Não disponível',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Estatísticas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildStatRow(Icons.favorite, 'Favoritos'),
                                _buildStatRow(Icons.history, 'Histórico'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              'Sair da Conta',
                              style: TextStyle(fontSize: 16),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Versão 1.0.0',
                              style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: Colors.amber[800]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(IconData icon, String label) {
    return FutureBuilder<int>(
      future: _getCount(label.toLowerCase()),
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.amber[700]),
              const SizedBox(width: 16),
              Text(label),
              const Spacer(),
              Text(
                snapshot.data?.toString() ?? '0',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}