
class Game {
  final int id;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final String date;

  Game({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.date,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final home = json['teams']?['home'] ?? {};
    final away = json['teams']?['away'] ?? {};

    return Game(
      id: json['gamePk'] ?? 0,
      homeTeam: home['team']?['name'] ?? 'Local',
      awayTeam: away['team']?['name'] ?? 'Visitante',
      homeScore: home['score'],
      awayScore: away['score'],
      status: json['status']?['detailedState'] ?? 'Desconocido',
      date: json['gameDate'] ?? '',
    );
  }
}
