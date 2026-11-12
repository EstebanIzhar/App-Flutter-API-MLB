
class Player {
  final int id;
  final String name;
  final String position;
  final String? teamName;
  final String? image;

  Player({
    required this.id,
    required this.name,
    required this.position,
    this.teamName,
    this.image,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['person']?['id'] ?? json['id'] ?? 0,
      name: json['person']?['fullName'] ??
          json['fullName'] ??
          'Sin nombre',
      position: json['position']?['abbreviation'] ??
          json['primaryPosition']?['abbreviation'] ??
          'N/A',
      teamName: json['team']?['name'],
      image: json['image'],
    );
  }
}
