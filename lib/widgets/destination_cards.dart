import 'package:flutter/material.dart';
import 'package:travel_project5/data/bag.dart';
import 'package:travel_project5/models/destination_model.dart';
import 'package:travel_project5/ui/style.dart';

/// Heading, search field and the cards. [onSelect] gets the index into the
/// full [destinations] list (not into the filtered one).
class DestinationCards extends StatelessWidget {
  const DestinationCards({
    super.key,
    required this.destinations,
    required this.active,
    required this.picked,
    required this.wide,
    required this.searchController,
    required this.query,
    required this.onQueryChanged,
    required this.onSelect,
  });

  final List<DestinationModel> destinations;
  final int active;
  final Set<String> picked;
  final bool wide;
  final TextEditingController searchController;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final q = query.trim().toLowerCase();
    final visible = [
      for (var i = 0; i < destinations.length; i++)
        if (q.isEmpty ||
            destinations[i].name.toLowerCase().contains(q) ||
            destinations[i].type.toLowerCase().contains(q))
          i,
    ];

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text('DESTINATIONS', style: displayStyle(wide ? 64 : 52)),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a destination and discover its story.',
          style: bodyStyle(wide ? 16 : 15),
        ),
      ],
    );

    final search = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 340),
      child: TextField(
        controller: searchController,
        onChanged: onQueryChanged,
        style: bodyStyle(15, color: AppColors.ink),
        decoration: InputDecoration(
          hintText: 'Search a destination...',
          hintStyle: bodyStyle(15, color: const Color(0xFF6B7470)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7470)),
          filled: true,
          fillColor: AppColors.paper,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (wide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Expanded(child: heading), search],
          )
        else ...[
          heading,
          const SizedBox(height: 18),
          search,
        ],
        SizedBox(height: wide ? 28 : 18),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              'No destination matches that search. Try Riyadh, AlUla or Abha.',
              style: bodyStyle(18),
            ),
          )
        else if (wide)
          LayoutBuilder(
            builder: (context, c) {
              const gap = 16.0;
              final cols = ((c.maxWidth + gap) ~/ (220 + gap)).clamp(1, 5);
              final width = (c.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final i in visible)
                    _DestinationCard(
                      destination: destinations[i],
                      selected: i == active,
                      matchText: _matchText(destinations[i].name),
                      width: width,
                      height: width * 4 / 3,
                      onTap: () => onSelect(i),
                    ),
                ],
              );
            },
          )
        else
          SizedBox(
            height: 352,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 6),
              itemCount: visible.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, n) {
                final i = visible[n];
                return _DestinationCard(
                  destination: destinations[i],
                  selected: i == active,
                  matchText: _matchText(destinations[i].name),
                  width: 250,
                  height: 340,
                  onTap: () => onSelect(i),
                );
              },
            ),
          ),
      ],
    );
  }

  String? _matchText(String name) {
    final score = bagScore(name, picked);
    if (score == 0) return null;
    return '$score of ${bagItemsFor(name).length} in your bag';
  }
}

class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.destination,
    required this.selected,
    required this.matchText,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final DestinationModel destination;
  final bool selected;
  final String? matchText;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = destination.color;
    return Semantics(
      button: true,
      label: 'Open ${destination.name}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.deep,
            boxShadow: [
              BoxShadow(
                color: selected ? accent : Colors.transparent,
                spreadRadius: 3,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  destination.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.deep),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x000A100E), Color(0xD90A100E)],
                      stops: [.45, 1],
                    ),
                  ),
                ),
                if (matchText != null)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        matchText!,
                        style: labelStyle(onAccent(accent), size: 12, spacing: .4),
                      ),
                    ),
                  ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(destination.name, style: displayStyle(46, height: .95, spacing: .5)),
                      const SizedBox(height: 6),
                      Text(
                        destination.type,
                        style: bodyStyle(14, color: const Color(0xFFE3E7E4)),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Discover →',
                        style: bodyStyle(15, color: Colors.white, weight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
