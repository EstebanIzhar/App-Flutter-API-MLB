
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/team.dart';
import '../models/player.dart';
import '../models/game.dart';
import '../models/leader.dart';

class BaseballService {
  static const String baseUrl =
      'https://statsapi.mlb.com/api/v1';

  // Obtener todos los equipos de MLB
  Future<List<Team>> getTeams() async {
    final url = Uri.parse('$baseUrl/teams?sportId=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List teamsJson = data['teams'];

      return teamsJson
          .map((team) => Team.fromJson(team))
          .toList();
    }

    throw Exception('Error al obtener los equipos');
  }

  // Obtener jugadores de un equipo
  Future<List<Player>> getPlayers(int teamId) async {
    final url = Uri.parse(
      '$baseUrl/teams/$teamId/roster?rosterType=active',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List playersJson = data['roster'];

      return playersJson
          .map((player) => Player.fromJson(player))
          .toList();
    }

    throw Exception('Error al obtener los jugadores');
  }

  // Obtener partidos de una fecha
  Future<List<Game>> getGames(String date) async {
    final url = Uri.parse(
      '$baseUrl/schedule?sportId=1&date=$date',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List dates = data['dates'] ?? [];

      if (dates.isEmpty) {
        return [];
      }

      final List gamesJson = dates[0]['games'];

      return gamesJson
          .map((game) => Game.fromJson(game))
          .toList();
    }

    throw Exception('Error al obtener los partidos');
  }

  // Obtener estadísticas de un jugador
  Future<Map<String, dynamic>> getPlayerStats(
    int playerId,
    String group,
  ) async {
    final url = Uri.parse(
      '$baseUrl/people/$playerId/stats'
      '?stats=yearByYear&group=$group',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Error al obtener estadísticas');
  }

  // Obtener líderes de MLB por categoría
  Future<List<Leader>> getLeaders(
    String category,
    String group,
  ) async {
    final url = Uri.https(
      'statsapi.mlb.com',
      '/api/v1/stats/leaders',
      {
        'leaderCategories': category,
        'season': '2026',
        'sportId': '1',
        'statGroup': group,
        'gameType': 'R',
        'limit': '10',
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List categories = data['leagueLeaders'] ?? [];

      if (categories.isEmpty) {
        return [];
      }

      final List leaders = categories[0]['leaders'] ?? [];

      return leaders
          .map(
            (leader) => Leader.fromJson(leader),
          )
          .toList();
    }

    throw Exception('Error al obtener los líderes de MLB');
  }
}
