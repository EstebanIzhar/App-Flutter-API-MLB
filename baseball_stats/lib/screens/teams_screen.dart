
import 'package:flutter/material.dart';

import '../models/team.dart';
import '../services/baseball_service.dart';
import 'players_screen.dart';

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  final BaseballService baseballService = BaseballService();

  late Future<List<Team>> teamsFuture;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    teamsFuture = baseballService.getTeams();
  }

  void reloadTeams() {
    setState(() {
      teamsFuture = baseballService.getTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar equipo...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Team>>(
            future: teamsFuture,
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
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 45,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'No se pudieron cargar los equipos.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: reloadTeams,
                          child: const Text('Intentar nuevamente'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final teams = snapshot.data ?? [];

              final filteredTeams = teams.where((team) {
                return team.name.toLowerCase().contains(searchText) ||
                    team.abbreviation.toLowerCase().contains(searchText);
              }).toList();

              if (filteredTeams.isEmpty) {
                return const Center(
                  child: Text('No se encontraron equipos.'),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredTeams.length,
                itemBuilder: (context, index) {
                  final team = filteredTeams[index];

                  return Card(
                    color: Colors.grey.shade100,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: const Icon(
                          Icons.sports_baseball,
                          color: Colors.black,
                        ),
                      ),
                      title: Text(
                        team.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${team.location} • ${team.abbreviation}',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PlayersScreen(team: team);
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
    );
  }
}
