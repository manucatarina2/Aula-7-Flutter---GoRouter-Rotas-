import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
<<<<<<< HEAD
  final _supabase = Supabase.instance.client;
  String? _email;
  String? _userId;
  String? _createdAt;
=======
  String? _userEmail;
  String? _userId;
  String? _userCreatedAt;
  bool _isLoading = true;
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() {
<<<<<<< HEAD
    final user = _supabase.auth.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email;
        _userId = user.id;
        _createdAt = user.createdAt?.toString();
      });
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
    }
  }

  Future<void> _logout() async {
<<<<<<< HEAD
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
            child: const Text('Sair'),
          ),
        ],
      ),
    );
<<<<<<< HEAD

    if (confirm == true) {
      await _supabase.auth.signOut();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Não disponível';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.amber[800],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Informações da Conta',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber[800],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildInfoRow(
                      icon: Icons.email,
                      label: 'E-mail',
                      value: _email ?? 'Carregando...',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.fingerprint,
                      label: 'ID do Usuário',
                      value: _userId != null
                          ? '${_userId!.substring(0, 8)}...'
                          : 'Carregando...',
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Conta criada em',
                      value: _formatDate(_createdAt),
                    ),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildStatCard(),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _logout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 8),
                            Text('Sair da Conta', style: TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
=======
  Widget _buildInfoRow(IconData icon, String label, String value) {
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
<<<<<<< HEAD
            color: Colors.amber[200],
=======
            color: Colors.amber[100],
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
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
<<<<<<< HEAD
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
=======
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
              ),
            ],
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
  Widget _buildStatCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.favorite,
            label: 'Favoritos',
            onTap: () => context.go('/favorites'),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.amber[200],
          ),
          _buildStatItem(
            icon: Icons.history,
            label: 'Histórico',
            onTap: () => context.go('/history'),
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.amber[200],
          ),
          _buildStatItem(
            icon: Icons.school,
            label: 'Tabuadas',
            onTap: () => context.go('/home'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.amber[700]),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.amber[700],
              ),
            ),
          ],
        ),
      ),
=======
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
>>>>>>> fdca2904316bc4712de5933727bc3972f49dbb63
    );
  }
}