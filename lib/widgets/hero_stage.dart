import 'package:flutter/material.dart';
import 'package:travel_project5/data/bag.dart';
import 'package:travel_project5/data/destination_content.dart';
import 'package:travel_project5/models/destination_model.dart';
import 'package:travel_project5/ui/style.dart';
import 'package:travel_project5/widgets/common.dart';

/// The big photo stage: the chosen destination's name, a counter with
/// previous / next, and the "what is in your bag?" chips.
class HeroStage extends StatelessWidget {
  const HeroStage({
    super.key,
    required this.destinations,
    required this.active,
    required this.wide,
    required this.picked,
    required this.pickLine,
    required this.onToggle,
    required this.onPrev,
    required this.onNext,
    required this.onOpen,
  });

  final List<DestinationModel> destinations;
  final int active;
  final bool wide;
  final Set<String> picked;
  final String pickLine;
  final ValueChanged<String> onToggle;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final accent = destinations[active].color;
    final pad = wide ? 40.0 : 20.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(wide ? 28 : 24),
      child: SizedBox(
        height: wide ? 640 : 580,
        child: LayoutBuilder(
          builder: (context, c) {
            final titleSize = (c.maxWidth * (wide ? .236 : .44)).clamp(110.0, 300.0);
            return Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: Color(0xFF101815)),
                for (var i = 0; i < destinations.length; i++)
                  Positioned.fill(
                    child: ExcludeSemantics(
                      child: AnimatedOpacity(
                        opacity: i == active ? 1 : 0,
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeInOut,
                        child: AnimatedScale(
                          scale: i == active ? 1 : 1.07,
                          duration: const Duration(milliseconds: 1600),
                          curve: Curves.easeOut,
                          child: Image.asset(
                            DestinationContent.forName(destinations[i].name).hero,
                            fit: BoxFit.cover,
                            alignment: DestinationContent.forName(destinations[i].name)
                                .heroAlignment,
                            errorBuilder: (_, _, _) =>
                                const ColoredBox(color: Color(0xFF101815)),
                          ),
                        ),
                      ),
                    ),
                  ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0x940A100E),
                        Color(0x000A100E),
                        Color(0x000A100E),
                        Color(0xC70A100E),
                      ],
                      stops: [0, .42, .52, 1],
                    ),
                  ),
                ),
                // Top row: slogan + navigation.
                Positioned(
                  top: wide ? 26 : 20,
                  left: pad,
                  right: wide ? 28 : 14,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: Text(
                            'YOUR BAG DECIDES YOUR DESTINATION',
                            style: labelStyle(
                              Colors.white.withValues(alpha: .9),
                              size: wide ? 12 : 10,
                              spacing: wide ? 2.6 : 2,
                            ).copyWith(height: 1.6),
                          ),
                        ),
                      ),
                      if (wide) ...[
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Text(
                            '${(active + 1).toString().padLeft(2, '0')} / '
                            '${destinations.length.toString().padLeft(2, '0')}',
                            style: labelStyle(Colors.white, size: 13, spacing: 1.6)
                                .copyWith(
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                        RoundIconButton(
                          icon: Icons.chevron_left,
                          label: 'Previous destination',
                          onTap: onPrev,
                        ),
                        const SizedBox(width: 10),
                        RoundIconButton(
                          icon: Icons.chevron_right,
                          label: 'Next destination',
                          onTap: onNext,
                        ),
                      ] else
                        RoundIconButton(
                          icon: Icons.north_east,
                          label: 'Open ${destinations[active].name}',
                          onTap: onOpen,
                          size: 52,
                        ),
                    ],
                  ),
                ),
                // The name, one layer per destination so they cross-fade.
                Positioned(
                  top: wide ? 78 : 76,
                  left: pad,
                  right: pad,
                  child: IgnorePointer(
                    child: Stack(
                      children: [
                        for (var i = 0; i < destinations.length; i++)
                          Align(
                            alignment: Alignment.topLeft,
                            child: ExcludeSemantics(
                              excluding: i != active,
                              child: AnimatedSlide(
                                offset: i == active ? Offset.zero : const Offset(0, .14),
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeOut,
                                child: AnimatedOpacity(
                                  opacity: i == active ? 1 : 0,
                                  duration: const Duration(milliseconds: 600),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Semantics(
                                      header: true,
                                      child: Text(
                                        destinations[i].name.toUpperCase(),
                                        maxLines: 1,
                                        softWrap: false,
                                        style: displayStyle(
                                          titleSize,
                                          height: .86,
                                          spacing: -1,
                                          shadows: const [
                                            Shadow(
                                              color: Color(0x400A100E),
                                              blurRadius: 30,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Bottom: the bag.
                Positioned(
                  left: pad,
                  right: pad,
                  bottom: wide ? 32 : 22,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WHAT IS IN YOUR BAG?',
                        style: labelStyle(
                          Colors.white.withValues(alpha: .85),
                          size: wide ? 12 : 11,
                          spacing: wide ? 2.6 : 2.2,
                        ),
                      ),
                      SizedBox(height: wide ? 14 : 12),
                      Text(
                        pickLine,
                        style: bodyStyle(
                          wide ? 24 : 20,
                          color: Colors.white,
                          weight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: wide ? 14 : 12),
                      Wrap(
                        spacing: wide ? 10 : 8,
                        runSpacing: wide ? 10 : 8,
                        children: [
                          for (final item in bagItems)
                            BagChip(
                              label: item.label,
                              selected: picked.contains(item.id),
                              accent: accent,
                              onTap: () => onToggle(item.id),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
