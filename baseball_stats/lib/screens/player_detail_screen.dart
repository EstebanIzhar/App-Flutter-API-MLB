
import 'package:flutter/material.dart';

import '../models/player.dart';
import '../services/baseball_service.dart';

class PlayerDetailScreen extends StatefulWidget {
  final Player player;

  const PlayerDetailScreen({
    super.key,
    required this.player,
  });

  @override
  State<PlayerDetailScreen> createState() =>
      _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  final BaseballService baseballService = BaseballService();

  late Future<Map<String, dynamic>> battingFuture;
  late Future<Map<String, dynamic>> pitchingFuture;

  @override
  void initState() {
    super.initState();

    battingFuture = baseballService.getPlayerStats(
      widget.player.id,
      'hitting',
    );

    pitchingFuture = baseballService.getPlayerStats(
      widget.player.id,
      'pitching',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del jugador'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.player.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Posición: ${widget.player.position}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Estadísticas de bateo',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            StatSection(
              future: battingFuture,
              isPitching: false,
            ),

            const SizedBox(height: 25),

            const Text(
              'Estadísticas de pitcheo',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            StatSection(
              future: pitchingFuture,
              isPitching: true,
            ),
          ],
        ),
      ),
    );
  }
}

class StatSection extends StatelessWidget {
  final Future<Map<String, dynamic>> future;
  final bool isPitching;

  const StatSection({
    super.key,
    required this.future,
    required this.isPitching,
  });

  String formatValue(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return '-';
    }

    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Text(
            'No se pudieron cargar las estadísticas.',
          );
        }

        final data = snapshot.data ?? {};
        final statsList = data['stats'] as List? ?? [];

        Map<String, dynamic>? playerStats;

        if (statsList.isNotEmpty) {
          final splits = statsList[0]['splits'] as List? ?? [];

          if (splits.isNotEmpty) {
            playerStats = Map<String, dynamic>.from(
              splits.last['stat'] as Map,
            );
          }
        }

        if (playerStats == null) {
          return Card(
            color: Colors.grey.shade100,
            elevation: 0,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No hay estadísticas disponibles para esta categoría.',
              ),
            ),
          );
        }

        final List<Map<String, String>> items = isPitching
            ? [
                {'label': 'ERA', 'key': 'era'},
                {'label': 'WHIP', 'key': 'whip'},
                {'label': 'Victorias', 'key': 'wins'},
                {'label': 'Derrotas', 'key': 'losses'},
                {'label': 'Ponches', 'key': 'strikeOuts'},
                {'label': 'Salvamentos', 'key': 'saves'},
                {'label': 'Entradas', 'key': 'inningsPitched'},
              ]
            : [
                {'label': 'AVG', 'key': 'avg'},
                {'label': 'HR', 'key': 'homeRuns'},
                {'label': 'RBI', 'key': 'rbi'},
                {'label': 'Hits', 'key': 'hits'},
                {'label': 'OBP', 'key': 'obp'},
                {'label': 'SLG', 'key': 'slg'},
                {'label': 'OPS', 'key': 'ops'},
              ];

        return Card(
          color: Colors.grey.shade100,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: items.map((item) {
                final value = playerStats![item['key']];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['label']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        formatValue(value),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
