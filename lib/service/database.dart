import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_project5/config.dart';
import 'package:travel_project5/data/demo_destinations.dart';
import 'package:travel_project5/models/destination_model.dart';

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
      // Stored as the ARGB number that DestinationModel.fromJson reads back.
      "color": model.color.toARGB32(),
    });
  }
}
