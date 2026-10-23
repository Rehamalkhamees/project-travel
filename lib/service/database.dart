import 'package:flutter/painting.dart' show Color;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_project5/config.dart';
import 'package:travel_project5/data/demo_destinations.dart';
import 'package:travel_project5/models/destination_model.dart';

/// The text form stored in the `color` column, like the existing rows:
/// `Color(0xFFEB9C63)` becomes `"0xFFEB9C63"` (DestinationModel.fromJson reads it back).
String encodeColor(Color color) =>
    '0x${color.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0')}';

class Database {
  /// Destinations added while the offline demo is running (kept until the
  /// app restarts).
  static final List<DestinationModel> _demoRows = [...demoDestinations];

  Future<List<DestinationModel>> getAlltravel() async {
    if (kOfflineDemo) return List.of(_demoRows);

    final data =
        await Supabase.instance.client.from("destinationData").select();
    return data.map(DestinationModel.fromJson).toList();
  }

  Future<void> addNewplace({required DestinationModel model}) async {
    if (kOfflineDemo) {
      _demoRows.add(model);
      return;
    }

    await Supabase.instance.client.from("destinationData").insert({
      "name": model.name,
      "type": model.type,
      "image": model.image,
      "color": encodeColor(model.color),
    });
  }
}
