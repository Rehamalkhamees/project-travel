/// Something a traveller can tick as "in my bag". Each item points to the
/// destination it is packed for.
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

/// Index (into [destinations]) of the destination the bag points to, or -1
/// when nothing relevant is ticked. A tie keeps [current] if it is among the
/// best, so ticking more items never jumps away from a destination that
/// already fits.
int bestBagMatch(List<String> destinations, Set<String> picked, int current) {
  if (destinations.isEmpty) return -1;
  final scores = destinations.map((d) => bagScore(d, picked)).toList();
  final top = scores.reduce((a, b) => a > b ? a : b);
  if (top == 0) return -1;
  if (current >= 0 && current < scores.length && scores[current] == top) {
    return current;
  }
  return scores.indexOf(top);
}

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
