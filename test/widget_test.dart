
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tekto_analizes_programele/main.dart';

void main() {

  // unit test

  group('Counter.getWordCount()', () {
    test('count words', () {
      expect(Counter.getWordCount('labas rytas'), 2);
    });

    test('if null, returns -1', () {
      expect(Counter.getWordCount(null), -1);
    });

    test('test with spaces', () {
      expect(Counter.getWordCount('labas      rytas'), 2);
    });

    test('test with numbers', () {
      expect(Counter.getWordCount('labas rytas 123'), 2);
    });

    test('test with punctuation marks', () {
      expect(Counter.getWordCount('labas rytas,..'), 2);
    });

    test('only numbers', () {
      expect(Counter.getWordCount('123 456'), 0);
    });
  });

  group('Counter.getSentenceCount()', () {
    test('count sentences', () {
      expect(Counter.getSentenceCount('labas rytas'), 1);
    });

    test('if null, returns -1', () {
      expect(Counter.getSentenceCount(null), -1);
    });

    test('test with spaces', () {
      expect(Counter.getSentenceCount('labas      rytas.'), 1);
    });

    test('test with numbers', () {
      expect(Counter.getSentenceCount('labas rytas 123'), 1);
    });

    test('test with punctuation marks', () {
      expect(Counter.getSentenceCount('labas rytas,..'), 1);
    });

    test('only numbers', () {
      expect(Counter.getSentenceCount('123 456'), 1);
    });

    test('only punctuation marks', () {
      expect(Counter.getSentenceCount('.,!?;'), 0);
    });
  });

  group('Counter.getNumberCount()', () {
    test('count numbers', () {
      expect(Counter.getNumberCount('labas rytas 123'), 3);
    });

    test('if null, returns -1', () {
      expect(Counter.getNumberCount(null), -1);
    });

    test('test with spaces', () {
      expect(Counter.getNumberCount('labas      rytas 123'), 3);
    });

    test('test with punctuation marks', () {
      expect(Counter.getNumberCount('labas rytas,..'), 0);
    });

    test('only punctuation marks', () {
      expect(Counter.getNumberCount('.,!?;'), 0);
    });
  });

  group('Counter.getPunctuationCount()', () {
    test('count punctuation marks', () {
      expect(Counter.getPunctuationCount('labas rytas,..'), 3);
    });

    test('if null, returns -1', () {
      expect(Counter.getPunctuationCount(null), -1);
    });

    test('test with spaces', () {
      expect(Counter.getPunctuationCount('labas      rytas,..'), 3);
    });

    test('test with numbers', () {
      expect(Counter.getPunctuationCount('labas rytas 123'), 0);
    });

    test('only numbers', () {
      expect(Counter.getPunctuationCount('123 456'), 0);
    });
  });

  //widget test

  testWidgets('Test without any text', (tester) async {
    await tester.pumpWidget(const TextAnalyzerApp());

    expect(find.text('Teksto analizė'), findsOneWidget); // AppBar
    expect(find.textContaining('Rezultatų dar nėra'), findsOneWidget);
    expect(find.text('Istorija tuščia.'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('click button without text', (tester) async {
    await tester.pumpWidget(const TextAnalyzerApp());
    await tester.tap(find.text('Analizuoti'));
    await tester.pump();

    expect(find.textContaining('Įveskite tekstą analizei'), findsOneWidget);
  });

  testWidgets('text with results', (tester) async {
    await tester.pumpWidget(const TextAnalyzerApp());
    await tester.enterText(find.byType(TextField), 'Labas pasauli!');
    await tester.tap(find.text('Analizuoti'));
    await tester.pump();

    expect(find.text('Rezultatai'), findsOneWidget);
    expect(find.text('Sakiniai: 1'), findsOneWidget);
    expect(find.text('Žodžiai: 2'), findsOneWidget);
  });

  testWidgets('history fills', (tester) async {
    await tester.pumpWidget(const TextAnalyzerApp());
    await tester.enterText(find.byType(TextField), 'labas rytas');
    await tester.tap(find.text('Analizuoti'));
    await tester.pump();

    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text('Istorija tuščia.'), findsNothing);
  });

  testWidgets('history fills with two texts', (tester) async {
    await tester.pumpWidget(const TextAnalyzerApp());
    await tester.enterText(find.byType(TextField), 'labas rytas');
    await tester.tap(find.text('Analizuoti'));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'laba diena');
    await tester.tap(find.text('Analizuoti'));
    await tester.pump();

    expect(find.byType(ListTile), findsNWidgets(2));
  });
}


