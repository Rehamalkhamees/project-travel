import 'package:flutter_test/flutter_test.dart';
import 'package:travel_project5/data/bag.dart';

void main() {
  const destinations = ['Diriyah', 'Riyadh', 'AlUla', 'Umluj', 'Abha'];

  group('bestBagMatch', () {
    test('returns -1 when nothing is ticked', () {
      expect(bestBagMatch(destinations, {}, 0), -1);
    });

    test('picks the destination with the most ticked items', () {
      expect(bestBagMatch(destinations, {'camera', 'shoes'}, 0), 2);
      expect(bestBagMatch(destinations, {'swim'}, 0), 3);
    });

    test('keeps the current destination when it ties for best', () {
      // One item for AlUla and one for Umluj: both score 1.
      expect(bestBagMatch(destinations, {'camera', 'swim'}, 3), 3);
      expect(bestBagMatch(destinations, {'camera', 'swim'}, 2), 2);
    });

    test('moves to the first best match when current is not among them', () {
      expect(bestBagMatch(destinations, {'camera', 'swim'}, 0), 2);
    });

    test('handles an empty destination list', () {
      expect(bestBagMatch(const [], {'camera'}, 0), -1);
    });
  });

  group('packLine', () {
    test('lists what is still missing', () {
      expect(packLine('AlUla', {}), 'Pack camera + comfortable shoes for AlUla');
      expect(packLine('AlUla', {'camera'}), 'Pack comfortable shoes for AlUla');
    });

    test('says the bag is ready when everything is packed', () {
      expect(packLine('AlUla', {'camera', 'shoes'}), 'Your bag is ready for AlUla');
    });
  });
}
