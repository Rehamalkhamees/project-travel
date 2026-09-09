import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:travel_project5/models/destination_model.dart';

class Database {
  final supabase = Supabase.instance.client;

  Future<List<DestinationModel>> getAlltravel() async {
    final data = await supabase.from("destinationData").select();

    List<DestinationModel> travels = [];

    for (var element in data) {
      DestinationModel travel = DestinationModel.fromJson(element);
      travels.add(travel);
    }
    return travels;
  }
}
