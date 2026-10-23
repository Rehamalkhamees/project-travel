import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_project5/data/demo_destinations.dart';
import 'package:travel_project5/models/destination_model.dart';
import 'package:travel_project5/pages/home_page.dart';

Future<void> _loadAppFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load(file));
    }
    await loader.load();
  }

  await load('BebasNeue', ['assets/fonts/BebasNeue-400.ttf']);
  await load('Manrope', [
    'assets/fonts/Manrope-500.ttf',
    'assets/fonts/Manrope-600.ttf',
    'assets/fonts/Manrope-700.ttf',
  ]);
}

Widget _app({
  required Future<List<DestinationModel>> Function() load,
  required Future<void> Function(DestinationModel) save,
}) {
  return MaterialApp(
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: child!,
    ),
    home: HomePage(loadDestinations: load, saveDestination: save),
  );
}

void main() {
  setUpAll(_loadAppFonts);

  void useWideScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1440, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('adds a destination and shows it', (tester) async {
    useWideScreen(tester);
    final rows = [...demoDestinations];
    DestinationModel? saved;
    await tester.pumpWidget(_app(
      load: () async => List.of(rows),
      save: (model) async {
        saved = model;
        rows.add(model);
      },
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('ADD A DESTINATION'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('add-name')), 'Khobar');
    await tester.enterText(find.byKey(const Key('add-type'), ), 'Waterfront');
    await tester.tap(find.text('Add destination'));
    await tester.pumpAndSettle();

    expect(saved?.name, 'Khobar');
    expect(saved?.type, 'Waterfront');
    expect(saved?.image, startsWith('assets/images/'));
    expect(find.text('ADD A DESTINATION'), findsNothing);
    // The new destination has a card and is the one on the stage.
    expect(find.text('Khobar'), findsOneWidget);
    expect(find.text('Your bag is ready for Khobar'), findsOneWidget);
    expect(find.text('Khobar was added'), findsOneWidget);
  });

  testWidgets('asks for a name and a type before saving', (tester) async {
    useWideScreen(tester);
    var saves = 0;
    await tester.pumpWidget(_app(
      load: () async => demoDestinations,
      save: (model) async => saves++,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add destination'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a name and a type.'), findsOneWidget);
    expect(saves, 0);
  });

  testWidgets('keeps the form open and explains when saving fails', (tester) async {
    useWideScreen(tester);
    await tester.pumpWidget(_app(
      load: () async => demoDestinations,
      save: (model) async => throw Exception('permission denied'),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('add-name')), 'Khobar');
    await tester.enterText(find.byKey(const Key('add-type')), 'Waterfront');
    await tester.tap(find.text('Add destination'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Could not save the destination'), findsOneWidget);
    expect(find.textContaining('permission denied'), findsOneWidget);
    expect(find.text('ADD A DESTINATION'), findsOneWidget);
  });
}
