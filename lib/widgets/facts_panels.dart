import 'package:flutter/material.dart';
import 'package:travel_project5/data/bag.dart';
import 'package:travel_project5/data/destination_content.dart';
import 'package:travel_project5/models/destination_model.dart';
import 'package:travel_project5/ui/style.dart';
import 'package:travel_project5/widgets/common.dart';
import 'package:travel_project5/widgets/saudi_map.dart';

/// Two panels under the stage: where it is (dark) and what to know (light).
class FactsPanels extends StatelessWidget {
  const FactsPanels({
    super.key,
    required this.destinations,
    required this.active,
    required this.wide,
    required this.onSelect,
  });

  final List<DestinationModel> destinations;
  final int active;
  final bool wide;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final dark = _LocationPanel(destinations: destinations, active: active, wide: wide);
    final light = _FactsPanel(
      destinations: destinations,
      active: active,
      wide: wide,
      onSelect: onSelect,
    );
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [dark, const SizedBox(height: 12), light],
      );
    }
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 10, child: dark),
          const SizedBox(width: 16),
          Expanded(flex: 13, child: light),
        ],
      ),
    );
  }
}

class _LocationPanel extends StatelessWidget {
  const _LocationPanel({
    required this.destinations,
    required this.active,
    required this.wide,
  });

  final List<DestinationModel> destinations;
  final int active;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final current = destinations[active];
    final content = DestinationContent.forName(current.name);
    final stats = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BigStat(
          label: 'REGION',
          value: content.region,
          labelColor: AppColors.quiet,
          valueColor: Colors.white,
          valueSize: wide ? 72 : 58,
        ),
        SizedBox(height: wide ? 26 : 20),
        BigStat(
          label: content.distanceNote,
          value: content.distanceValue,
          labelColor: AppColors.quiet,
          valueColor: Colors.white,
          valueSize: wide ? 72 : 58,
          caption: content.distanceCaption,
        ),
      ],
    );
    final map = SaudiMap(
      points: [
        for (final d in destinations) DestinationContent.forName(d.name).mapPoint,
      ],
      activeIndex: active,
      accent: current.color,
      semanticLabel: 'Map of Saudi Arabia with ${current.name} highlighted',
    );

    return Container(
      padding: EdgeInsets.all(wide ? 28 : 22),
      decoration: BoxDecoration(
        color: AppColors.deep,
        borderRadius: BorderRadius.circular(wide ? 28 : 24),
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 280, child: map),
                const SizedBox(width: 32),
                Expanded(child: stats),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [map, const SizedBox(height: 22), stats],
            ),
    );
  }
}

class _FactsPanel extends StatelessWidget {
  const _FactsPanel({
    required this.destinations,
    required this.active,
    required this.wide,
    required this.onSelect,
  });

  final List<DestinationModel> destinations;
  final int active;
  final bool wide;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final current = destinations[active];
    final content = DestinationContent.forName(current.name);
    final accent = current.color;
    final tags = [for (final b in bagItemsFor(current.name)) b.label];

    final thumbs = Wrap(
      spacing: wide ? 10 : 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < destinations.length; i++)
          _Thumb(
            name: destinations[i].name,
            image: destinations[i].image,
            selected: i == active,
            size: wide ? 60 : 56,
            onTap: () => onSelect(i),
          ),
      ],
    );

    final Widget facts = wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 10,
                child: BigStat(
                  label: 'BEST SEASON',
                  value: content.season,
                  labelColor: AppColors.quietOnPaper,
                  valueColor: AppColors.ink,
                  accentBar: accent,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 13,
                child: BigStat(
                  label: 'EXPERIENCE',
                  value: current.type.toUpperCase(),
                  labelColor: AppColors.quietOnPaper,
                  valueColor: AppColors.ink,
                  accentBar: accent,
                ),
              ),
              const SizedBox(width: 32),
              Expanded(flex: 11, child: _BagTags(tags: tags, accent: accent)),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FactRow(label: 'BEST SEASON', value: content.season),
              _FactRow(label: 'EXPERIENCE', value: current.type.toUpperCase()),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('IN YOUR BAG', style: labelStyle(AppColors.quietOnPaper, size: 11)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 8,
                        runSpacing: 8,
                        children: [for (final t in tags) _Tag(t)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

    return Container(
      padding: EdgeInsets.all(wide ? 28 : 22),
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(wide ? 28 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          facts,
          SizedBox(height: wide ? 28 : 20),
          Container(
            padding: EdgeInsets.only(top: wide ? 20 : 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.lineOnPaper)),
            ),
            child: wide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('SWITCH DESTINATION',
                          style: labelStyle(AppColors.quietOnPaper)),
                      thumbs,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SWITCH DESTINATION',
                          style: labelStyle(AppColors.quietOnPaper, size: 11)),
                      const SizedBox(height: 12),
                      thumbs,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.lineOnPaper)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle(AppColors.quietOnPaper, size: 11)),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final line in splitAtAmpersand(value))
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      line,
                      maxLines: 1,
                      style: displayStyle(44, color: AppColors.ink, height: 1),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BagTags extends StatelessWidget {
  const _BagTags({required this.tags, required this.accent});

  final List<String> tags;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 4,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 10),
        Text('IN YOUR BAG', style: labelStyle(AppColors.quietOnPaper)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final t in tags) _Tag(t)],
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.tag,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: bodyStyle(14, color: AppColors.ink, weight: FontWeight.w700, height: 1.3),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({
    required this.name,
    required this.image,
    required this.selected,
    required this.size,
    required this.onTap,
  });

  final String name;
  final String image;
  final bool selected;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: name,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.paper, width: 3),
            boxShadow: [
              BoxShadow(
                color: selected ? AppColors.ink : AppColors.ink.withValues(alpha: .16),
                spreadRadius: 3,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(color: AppColors.lineOnPaper),
            ),
          ),
        ),
      ),
    );
  }
}
