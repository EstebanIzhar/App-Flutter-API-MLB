import 'package:flutter/material.dart';

import '../models/leader.dart';
import '../services/baseball_service.dart';

class LeadersScreen
    extends
        StatefulWidget {
  const LeadersScreen({super.key});

  @override
  State<
    LeadersScreen
  >
  createState() => _LeadersScreenState();
}

class _LeadersScreenState
    extends
        State<
          LeadersScreen
        > {
  final BaseballService baseballService = BaseballService();

  String selectedGroup = 'hitting';
  String selectedCategory = 'homeRuns';

  late Future<
    List<
      Leader
    >
  >
  leadersFuture;

  final Map<
    String,
    String
  >
  battingCategories = {
    'AVG': 'battingAverage',
    'HR': 'homeRuns',
    'RBI': 'runsBattedIn',
    'Hits': 'hits',
    'OBP': 'onBasePercentage',
    'SLG': 'sluggingPercentage',
    'OPS': 'onBasePlusSlugging',
  };

  final Map<
    String,
    String
  >
  pitchingCategories = {
    'ERA': 'era',
    'WHIP': 'whip',
    'Victorias': 'wins',
    'Derrotas': 'losses',
    'Ponches': 'strikeouts',
    'Salvamentos': 'saves',
    'Entradas': 'inningsPitched',
  };

  @override
  void initState() {
    super.initState();
    loadLeaders();
  }

  void loadLeaders() {
    leadersFuture = baseballService.getLeaders(
      selectedCategory,
      selectedGroup,
    );
  }

  void changeGroup(
    String group,
  ) {
    setState(() {
      selectedGroup = group;

      selectedCategory =
          group ==
              'hitting'
          ? 'homeRuns'
          : 'era';

      loadLeaders();
    });
  }

  void changeCategory(
    String? category,
  ) {
    if (category ==
        null) {
      return;
    }
    setState(() {
      selectedCategory = category;
      loadLeaders();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final categories =
        selectedGroup ==
            'hitting'
        ? battingCategories
        : pitchingCategories;

    return Padding(
      padding: const EdgeInsets.all(
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Líderes de MLB',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 5,
          ),

          const Text(
            'Temporada 2026',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => changeGroup(
                    'hitting',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedGroup ==
                            'hitting'
                        ? Colors.black
                        : Colors.grey.shade200,
                    foregroundColor:
                        selectedGroup ==
                            'hitting'
                        ? Colors.white
                        : Colors.black,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Bateo',
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: ElevatedButton(
                  onPressed: () => changeGroup(
                    'pitching',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedGroup ==
                            'pitching'
                        ? Colors.black
                        : Colors.grey.shade200,
                    foregroundColor:
                        selectedGroup ==
                            'pitching'
                        ? Colors.white
                        : Colors.black,
                    elevation: 0,
                  ),
                  child: const Text(
                    'Pitcheo',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 15,
          ),

          DropdownButtonFormField<
            String
          >(
            initialValue: selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Estadística',
              border: OutlineInputBorder(),
            ),
            items: categories.entries.map((
              entry,
            ) {
              return DropdownMenuItem<
                String
              >(
                value: entry.value,
                child: Text(
                  entry.key,
                ),
              );
            }).toList(),
            onChanged: changeCategory,
          ),

          const SizedBox(
            height: 15,
          ),

          Expanded(
            child:
                FutureBuilder<
                  List<
                    Leader
                  >
                >(
                  future: leadersFuture,
                  builder:
                      (
                        context,
                        snapshot,
                      ) {
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
                                const Text(
                                  'No se pudieron cargar los líderes.',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      loadLeaders();
                                    });
                                  },
                                  child: const Text(
                                    'Intentar nuevamente',
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final leaders =
                            snapshot.data ??
                            [];

                        if (leaders.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay estadísticas disponibles.',
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: leaders.length,
                          itemBuilder:
                              (
                                context,
                                index,
                              ) {
                                final leader = leaders[index];

                                return Card(
                                  color: Colors.grey.shade100,
                                  elevation: 0,
                                  margin: const EdgeInsets.only(
                                    bottom: 8,
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.grey.shade300,
                                      child: Text(
                                        '${leader.rank}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      leader.playerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      leader.teamName,
                                    ),
                                    trailing: Text(
                                      leader.value,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
