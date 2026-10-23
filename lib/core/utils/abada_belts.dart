class AbadaBelts {
  AbadaBelts._();
  final List<AbadaBelt> belts = const [
    // categoria: aluno
    AbadaBelt(belt: "CRUA", category: "aluno", number: 0),
    AbadaBelt(belt: "PONTA CURA AMARELA", category: "aluno", number: 1),
    AbadaBelt(belt: "PONTA AMARELA", category: "aluno", number: 2),
    AbadaBelt(belt: "PONTA AMARELA LARANJA", category: "aluno", number: 3),
    AbadaBelt(belt: "PONTA LARANJA", category: "aluno", number: 4),
    AbadaBelt(belt: "PONTA LARANJA AZUL", category: "aluno", number: 5),
    AbadaBelt(belt: "PONTA AZUL", category: "aluno", number: 6),
    AbadaBelt(belt: "CRUA AMARELA", category: "aluno", number: 7),
    AbadaBelt(belt: "AMARELA", category: "aluno", number: 8),
    AbadaBelt(belt: "CRUA LARANJA", category: "aluno", number: 9),
    AbadaBelt(belt: "AMARELA LARANJA", category: "aluno", number: 10),
    AbadaBelt(belt: "LARANJA", category: "aluno", number: 11),
    AbadaBelt(belt: "CRUA AZUL", category: "aluno", number: 12),
    AbadaBelt(belt: "AMARELA AZUL", category: "aluno", number: 13),
    AbadaBelt(belt: "LARANJA AZUL", category: "aluno", number: 14),
    // categoria: graduado
    AbadaBelt(belt: "AZUL", category: "graduado", number: 15),
    AbadaBelt(belt: "AZUL VERDE", category: "graduado", number: 16),
    AbadaBelt(belt: "VERDE", category: "graduado", number: 17),
    AbadaBelt(belt: "VERDE ROXA", category: "graduado", number: 18),
    // categoria: instrutor
    AbadaBelt(belt: "ROXA", category: "instrutor", number: 19),
    AbadaBelt(belt: "ROXA MARROM", category: "instrutor", number: 20),
    // categoria: professor
    AbadaBelt(belt: "MARROM", category: "professor", number: 21),
    AbadaBelt(belt: "MARROM VERMELHA", category: "professor", number: 22),
    // categoria: instrutor baobá
    AbadaBelt(belt: "ROXA AMARELA", category: "instrutor baobá", number: 23),
    AbadaBelt(belt: "ROXA LARANJA", category: "instrutor baobá", number: 24),
    AbadaBelt(belt: "ROXA AZUL", category: "instrutor baobá", number: 25),
    // categoria: professor baobá
    AbadaBelt(belt: "MARROM AMARELA", category: "professor baobá", number: 26),
    AbadaBelt(belt: "MARROM LARANJA", category: "professor baobá", number: 27),
    AbadaBelt(belt: "MARROM AZUL", category: "professor baobá", number: 28),
    AbadaBelt(belt: "MARROM VERDE", category: "professor baobá", number: 29),
    AbadaBelt(belt: "MARROM BRANCA", category: "professor baobá", number: 30),
    // categoria: mestrando
    AbadaBelt(belt: "VERMELHA", category: "mestrando", number: 31),
    // categoria: mestre
    AbadaBelt(belt: "VERMELHA BRANCA", category: "mestre", number: 32),
    AbadaBelt(belt: "BRANCA", category: "mestre", number: 33),
  ];
}

class AbadaBelt {
  final String belt;
  final String category;
  final int number;

  const AbadaBelt({
    required this.belt,
    required this.category,
    required this.number,
  });
}
