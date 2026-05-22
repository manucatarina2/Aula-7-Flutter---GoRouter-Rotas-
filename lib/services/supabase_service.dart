// Em qualquer tela, você pode usar:
final supabaseService = SupabaseService.instance;

// Login
await supabaseService.signInWithEmail('email@teste.com', 'senha123');

// Buscar tabuadas
final basicas = await supabaseService.getTabuadasBasicas();

// Adicionar favorito
await supabaseService.addFavorite(1, 'basico');

// Verificar se é favorito
final isFav = await supabaseService.isFavorite(1, 'basico');

// Adicionar ao histórico
await supabaseService.addToHistory(
  tabuadaId: 1,
  tipoNivel: 'basico',
  numero: 2,
  multiplicador: 3,
  resultado: 6,
);

// Buscar histórico
final history = await supabaseService.getUserHistory();

// Logout
await supabaseService.signOut();