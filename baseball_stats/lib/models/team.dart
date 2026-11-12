
class Team {
  final int id;
  final String name;
  final String abbreviation;
  final String location;
  final String? logo;

  Team({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.location,
    this.logo,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Sin nombre',
      abbreviation: json['abbreviation'] ?? '',
      location: json['locationName'] ?? '',
      logo: json['logo'],
    );
  }
}
