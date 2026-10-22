import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_project5/config.dart';
import 'package:travel_project5/data/demo_destinations.dart';
import 'package:travel_project5/models/destination_model.dart';

class Database {
  Future<List<DestinationModel>> getAlltravel() async {
    if (kOfflineDemo) return demoDestinations;

    final data =
        await Supabase.instance.client.from("destinationData").select();
    return data.map(DestinationModel.fromJson).toList();
  }
}
