/// Something to pack. Each item belongs to one destination and is shown only
/// with it.
class BagItem {
  const BagItem(this.id, this.label, this.destination);

  final String id;
  final String label;
  final String destination;
}

const bagItems = <BagItem>[
  BagItem('camera', 'Camera', 'AlUla'),
  BagItem('shoes', 'Comfortable shoes', 'AlUla'),
  BagItem('swim', 'Swimsuit', 'Umluj'),
  BagItem('warm', 'Warm clothes', 'Abha'),
  BagItem('outfit', 'Best outfit', 'Riyadh'),
  BagItem('curious', 'Curiosity', 'Diriyah'),
];

List<BagItem> bagItemsFor(String destination) =>
    bagItems.where((b) => b.destination == destination).toList();

int bagScore(String destination, Set<String> picked) =>
    bagItemsFor(destination).where((b) => picked.contains(b.id)).length;

/// The sentence on the stage: what is still missing for [destination].
String packLine(String destination, Set<String> picked) {
  final missing = bagItemsFor(destination)
      .where((b) => !picked.contains(b.id))
      .map((b) => b.label.toLowerCase())
      .toList();
  return missing.isEmpty
      ? 'Your bag is ready for $destination'
      : 'Pack ${missing.join(' + ')} for $destination';
}
