import 'package:flutter_test/flutter_test.dart';
import 'package:travel_project5/data/bag.dart';

void main() {
  group('bagItemsFor', () {
    test('every item is listed only under its own destination', () {
      expect([for (final b in bagItemsFor('AlUla')) b.label],
          ['Camera', 'Comfortable shoes']);
      expect([for (final b in bagItemsFor('Umluj')) b.label], ['Swimsuit']);
      expect(bagItemsFor('Khobar'), isEmpty);
    });

    test('ticking another destination\'s item does not count', () {
      expect(bagScore('AlUla', {'swim'}), 0);
      expect(bagScore('AlUla', {'camera', 'swim'}), 1);
      expect(bagScore('Umluj', {'camera', 'swim'}), 1);
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
