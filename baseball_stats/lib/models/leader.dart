
class Leader {
  final int rank;
  final String playerName;
  final String teamName;
  final String value;

  Leader({
    required this.rank,
    required this.playerName,
    required this.teamName,
    required this.value,
  });

  factory Leader.fromJson(Map<String, dynamic> json) {
    return Leader(
      rank: json['rank'] ?? 0,
      playerName: json['person']?['fullName'] ?? 'Sin nombre',
      teamName: json['team']?['name'] ?? 'Sin equipo',
      value: json['value']?.toString() ?? '-',
    );
  }
}
