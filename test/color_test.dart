import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_project5/models/destination_model.dart';
import 'package:travel_project5/service/database.dart';

void main() {
  test('stores colours in the same text form as the existing rows', () {
    expect(encodeColor(const Color(0xFFEB9C63)), '0xFFEB9C63');
    expect(encodeColor(const Color(0xFFB8D0B0)), '0xFFB8D0B0');
  });

  test('a stored colour reads back as the same colour', () {
    const color = Color(0xFF63CFC8);
    final model = DestinationModel.fromJson({
      'name': 'Umluj',
      'type': 'Beach',
      'image': 'assets/images/umluj1.jpeg',
      'color': encodeColor(color),
    });
    expect(model.color, color);
  });
}
