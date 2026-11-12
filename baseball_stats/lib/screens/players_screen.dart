
import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/team.dart';
import '../services/baseball_service.dart';
import 'player_detail_screen.dart';

class PlayersScreen extends StatefulWidget {
  final Team team;

  const PlayersScreen({
    super.key,
    required this.team,
  });

  @override
  State<PlayersScreen> createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  final BaseballService baseballService = BaseballService();

  late Future<List<Player>> playersFuture;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    playersFuture = baseballService.getPlayers(widget.team.id);
  }

  void reloadPlayers() {
    setState(() {
      playersFuture = baseballService.getPlayers(widget.team.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar jugador...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Player>>(
              future: playersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Error al cargar los jugadores.'),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: reloadPlayers,
                          child: const Text('Intentar nuevamente'),
                        ),
                      ],
                    ),
                  );
                }

                final players = snapshot.data ?? [];

                final filteredPlayers = players.where((player) {
                  return player.name.toLowerCase().contains(searchText);
                }).toList();

                if (filteredPlayers.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron jugadores.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredPlayers.length,
                  itemBuilder: (context, index) {
                    final player = filteredPlayers[index];

                    return Card(
                      color: Colors.grey.shade100,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: const Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                        ),
                        title: Text(
                          player.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Posición: ${player.position}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PlayerDetailScreen(
                                  player: player,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
