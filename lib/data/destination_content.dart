import 'package:flutter/material.dart';
import 'package:travel_project5/models/destination_model.dart';

/// Everything shown about a destination that does not come from Supabase.
/// Looked up by the destination's name (the same names the table uses).
class DestinationContent {
  const DestinationContent({
    required this.hero,
    required this.heroAlignment,
    required this.region,
    required this.season,
    required this.distanceValue,
    required this.distanceNote,
    required this.distanceCaption,
    required this.mapPoint,
    required this.about,
    required this.dontMiss,
    required this.icons,
  });

  /// Wide photo used on the big stage.
  final String hero;
  final Alignment heroAlignment;
  final String region;
  final String season;
  final String distanceValue;
  final String distanceNote;

  /// Small line under the distance, e.g. how it was measured (null: none).
  final String? distanceCaption;

  /// Position on the 400 x 330 outline map of Saudi Arabia (null: not shown).
  final Offset? mapPoint;
  final String about;
  final List<String> dontMiss;
  final List<IconData> icons;

  static DestinationContent forName(String name) => _byName[name] ?? _fallback;

  /// True for the destinations with curated content (not added from the app).
  static bool isKnown(String name) => _byName.containsKey(name);
}

/// The stage photo: the curated wide one for known destinations, otherwise
/// the photo the destination itself carries.
String heroPhotoFor(DestinationModel destination) =>
    DestinationContent.isKnown(destination.name)
        ? DestinationContent.forName(destination.name).hero
        : destination.image;

Alignment heroAlignmentFor(DestinationModel destination) =>
    DestinationContent.isKnown(destination.name)
        ? DestinationContent.forName(destination.name).heroAlignment
        : Alignment.center;

const _fromRiyadh = 'FROM RIYADH';
const _straightLine = 'in a straight line';

const _fallback = DestinationContent(
  hero: 'assets/images/riyadh2.jpeg',
  heroAlignment: Alignment.center,
  region: 'SAUDI ARABIA',
  season: 'ALL YEAR',
  distanceValue: '—',
  distanceNote: _fromRiyadh,
  distanceCaption: null,
  mapPoint: null,
  about: 'Pack your bag and discover a beautiful Saudi destination filled with '
      'unique experiences and unforgettable places.',
  dontMiss: ['Explore', 'Discover', 'Enjoy'],
  icons: [Icons.explore, Icons.place, Icons.favorite],
);

const _byName = <String, DestinationContent>{
  'Diriyah': DestinationContent(
    hero: 'assets/images/diriyah1.jpeg',
    heroAlignment: Alignment(0, .1),
    region: 'RIYADH',
    season: 'NOV – MAR',
    distanceValue: '10 KM',
    distanceNote: _fromRiyadh,
    distanceCaption: _straightLine,
    mapPoint: Offset(219.8, 155.3),
    about: 'Your bag is packed for a journey through Saudi Arabia’s history. '
        'Bring your curiosity and get ready to travel back in time. '
        'Diriyah is one of Saudi Arabia’s most important historical '
        'destinations and the birthplace of the first Saudi state. '
        'Explore At-Turaif, admire traditional Najdi architecture, and '
        'enjoy the atmosphere of Bujairi Terrace with its restaurants and cafés.',
    dontMiss: ['At-Turaif', 'Bujairi Terrace', 'Najdi Heritage'],
    icons: [Icons.account_balance, Icons.restaurant, Icons.history_edu],
  ),
  'Riyadh': DestinationContent(
    hero: 'assets/images/riyadh2.jpeg',
    heroAlignment: Alignment(0, .44),
    region: 'RIYADH',
    season: 'NOV – MAR',
    distanceValue: 'CAPITAL',
    distanceNote: 'STARTING POINT',
    distanceCaption: null,
    mapPoint: Offset(221.6, 155.7),
    about: 'Your bag is ready for a vibrant city escape. Pack your best outfit '
        'and get ready for shopping, cafés, restaurants, and exciting entertainment. '
        'Riyadh combines modern city life with Saudi culture, offering something '
        'exciting for every visitor through its shopping destinations, stylish cafés, '
        'and seasonal events.',
    dontMiss: ['Boulevard City', 'Via Riyadh', 'Kingdom Centre'],
    icons: [Icons.celebration, Icons.shopping_bag, Icons.location_city],
  ),
  'AlUla': DestinationContent(
    hero: 'assets/images/alula1.jpeg',
    heroAlignment: Alignment(-.1, .24),
    region: 'MADINAH',
    season: 'OCT – MAR',
    distanceValue: '900 KM',
    distanceNote: _fromRiyadh,
    distanceCaption: _straightLine,
    mapPoint: Offset(62.3, 117.8),
    about: 'Your bag is packed and adventure is calling. Bring your camera and '
        'comfortable shoes as you explore extraordinary desert landscapes and ancient history. '
        'AlUla is famous for its dramatic rock formations, Hegra, Elephant Rock, '
        'and Old Town, offering unforgettable moments surrounded by nature.',
    dontMiss: ['Hegra', 'Elephant Rock', 'Old Town'],
    icons: [Icons.account_balance, Icons.landscape, Icons.photo_camera],
  ),
  'Umluj': DestinationContent(
    hero: 'assets/images/umluj2.jpeg',
    heroAlignment: Alignment(0, .16),
    region: 'TABUK',
    season: 'OCT – APR',
    distanceValue: '950 KM',
    distanceNote: _fromRiyadh,
    distanceCaption: _straightLine,
    mapPoint: Offset(50.4, 149.6),
    about: 'Your bag is ready for a peaceful beach escape. Pack your essentials '
        'and get ready to enjoy clear water and relaxing views. Often called the '
        'Saudi Maldives, Umluj is known for its turquoise water, soft beaches, '
        'beautiful islands, and unforgettable Red Sea experiences.',
    dontMiss: ['Crystal Beaches', 'Island Trips', 'Snorkeling'],
    icons: [Icons.beach_access, Icons.directions_boat, Icons.scuba_diving],
  ),
  'Abha': DestinationContent(
    hero: 'assets/images/abha2.jpeg',
    heroAlignment: Alignment(0, -.16),
    region: 'ASIR',
    season: 'JUN – SEP',
    distanceValue: '840 KM',
    distanceNote: _fromRiyadh,
    distanceCaption: _straightLine,
    mapPoint: Offset(145.7, 285.7),
    about: 'Your bag is packed for a refreshing nature escape. Bring comfortable '
        'clothes and get ready for cool weather, mountains, and fresh air. '
        'Abha offers a completely different side of Saudi Arabia with green landscapes, '
        'scenic villages, breathtaking viewpoints, and the calm atmosphere of the Asir region.',
    dontMiss: ['Rijal Almaa', 'Al-Soudah', 'Mountain Views'],
    icons: [Icons.home_work, Icons.terrain, Icons.visibility],
  ),
};
