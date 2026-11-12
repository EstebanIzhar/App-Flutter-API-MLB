
import 'package:flutter_test/flutter_test.dart';
import 'package:baseball_stats/main.dart';

void main() {
  testWidgets('Baseball Stats muestra la pantalla principal',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BaseballStatsApp());

    expect(find.text('Baseball Stats'), findsOneWidget);
    expect(find.text('Bienvenido a Baseball Stats'), findsOneWidget);
    expect(find.text('Información disponible'), findsOneWidget);
  });

  testWidgets('La navegación permite abrir equipos',
      (WidgetTester tester) async {
    await tester.pumpWidget(const BaseballStatsApp());

    await tester.tap(find.text('Equipos'));
    await tester.pump();

    expect(find.text('Equipos MLB'), findsOneWidget);
    expect(find.text('Buscar equipo...'), findsOneWidget);
  });
}
