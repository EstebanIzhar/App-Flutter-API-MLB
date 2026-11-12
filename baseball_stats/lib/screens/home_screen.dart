import 'package:flutter/material.dart';

import 'leaders_screen.dart';
import 'teams_screen.dart';

class HomeScreen
    extends
        StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<
    HomeScreen
  >
  createState() => _HomeScreenState();
}

class _HomeScreenState
    extends
        State<
          HomeScreen
        > {
  int selectedIndex = 0;

  final List<
    Widget
  >
  screens = const [
    HomeContent(),
    TeamsScreen(),
    LeadersScreen(),
    FavoritesContent(),
  ];

  final List<
    String
  >
  titles = [
    'Baseball Stats',
    'Equipos MLB',
    'Estadísticas',
    'Favoritos',
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[selectedIndex],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
      ),

      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap:
            (
              index,
            ) {
              setState(() {
                selectedIndex = index;
              });
            },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.groups_outlined,
            ),
            label: 'Equipos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
            ),
            label: 'Estadísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star_border,
            ),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}

class HomeContent
    extends
        StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bienvenido a Baseball Stats',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          const Text(
            'Consulta información, equipos y estadísticas '
            'de las Grandes Ligas de Béisbol.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          const Text(
            'Información disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          const HomeOption(
            icon: Icons.groups,
            title: 'Equipos MLB',
            description: 'Consulta los equipos de las Grandes Ligas.',
          ),

          const HomeOption(
            icon: Icons.person,
            title: 'Jugadores',
            description: 'Información y perfiles de jugadores.',
          ),

          const HomeOption(
            icon: Icons.sports_baseball,
            title: 'Bateo y pitcheo',
            description: 'Consulta estadísticas individuales.',
          ),
        ],
      ),
    );
  }
}

class HomeOption
    extends
        StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const HomeOption({super.key, required this.icon, required this.title, required this.description});

  @override
  Widget build(
    BuildContext context,
  ) {
    return Card(
      color: Colors.grey.shade100,
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.black,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
        ),
      ),
    );
  }
}

class StatisticsContent
    extends
        StatelessWidget {
  const StatisticsContent({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Center(
      child: Text(
        'Próximamente: estadísticas de bateo y pitcheo.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class FavoritesContent
    extends
        StatelessWidget {
  const FavoritesContent({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return const Center(
      child: Text(
        'Todavía no tienes favoritos.',
      ),
    );
  }
}
