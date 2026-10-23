import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_project5/data/demo_destinations.dart';
import 'package:travel_project5/pages/home_page.dart';

Widget _app(Future<List<dynamic>> Function() load) {
  return MaterialApp(
    // The map marker pulses forever; switch animations off so the test settles.
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: true),
      child: child!,
    ),
    home: HomePage(loadDestinations: () async => demoDestinations),
  );
}

/// Tests draw text with a placeholder font unless the app's own fonts are
/// loaded, which would make every word far wider than on a real device.
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

void main() {
  setUpAll(_loadAppFonts);

  void useSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('each destination shows only its own bag items (wide)', (tester) async {
    useSize(tester, const Size(1440, 2600));
    await tester.pumpWidget(_app(() async => demoDestinations));
    await tester.pumpAndSettle();

    // Diriyah: just Curiosity. No other destination's items on show.
    expect(find.text('Pack curiosity for Diriyah'), findsOneWidget);
    expect(find.text('Curiosity'), findsWidgets);
    expect(find.text('Swimsuit'), findsNothing);
    expect(find.text('Camera'), findsNothing);

    await tester.tap(find.text('Curiosity').first);
    await tester.pumpAndSettle();
    expect(find.text('Your bag is ready for Diriyah'), findsOneWidget);
    expect(find.text('1 of 1 packed'), findsOneWidget);

    // Next two destinations: Riyadh, then AlUla.
    await tester.tap(find.bySemanticsLabel('Next destination'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Next destination'));
    await tester.pumpAndSettle();
    expect(find.text('Pack camera + comfortable shoes for AlUla'), findsOneWidget);
    expect(find.text('Swimsuit'), findsNothing);

    await tester.tap(find.text('Camera').first);
    await tester.pumpAndSettle();
    expect(find.text('Pack comfortable shoes for AlUla'), findsOneWidget);
    expect(find.text('1 of 2 packed'), findsOneWidget);
    // Ticking never moves you to another destination.
    expect(find.text('03 / 05'), findsOneWidget);
  });

  testWidgets('search filters the destination cards', (tester) async {
    useSize(tester, const Size(1440, 2600));
    await tester.pumpWidget(_app(() async => demoDestinations));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'abha');
    await tester.pumpAndSettle();
    expect(find.text('Discover →'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.textContaining('No destination matches'), findsOneWidget);
  });

  testWidgets('shows a retry button when loading fails', (tester) async {
    useSize(tester, const Size(390, 900));
    var attempts = 0;
    await tester.pumpWidget(MaterialApp(
      home: HomePage(loadDestinations: () async {
        attempts++;
        if (attempts == 1) throw Exception('offline');
        return demoDestinations;
      }),
    ));
    await tester.pump();
    await tester.pump();
    expect(find.text('Try again'), findsOneWidget);
    // The reason is shown too, so a paused or misconfigured backend is easy to spot.
    expect(find.textContaining('offline'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Try again'), findsNothing);
    expect(attempts, 2);
  });

  testWidgets('phone layout builds without overflow', (tester) async {
    useSize(tester, const Size(390, 900));
    await tester.pumpWidget(_app(() async => demoDestinations));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);
    expect(find.text('WHAT IS IN YOUR BAG?'), findsOneWidget);
  });
}
