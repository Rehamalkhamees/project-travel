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

  Future<void> addNewplace({required DestinationModel model}) async {
    await supabase.from("travel").insert({
      "name": model.name,
      "type": model.type,
      "image": model.image,
      "color": model.color,
    });
  }
}
