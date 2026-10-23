import 'package:flutter/material.dart';
import 'package:travel_project5/ui/style.dart';

class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'SAUDI ESCAPE',
      style: displayStyle(size, height: 1, spacing: size * .14),
    );
  }
}

/// Circular outlined icon button used over photos and on the dark ground.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 44,
    this.background = const Color(0x5910180F),
    this.borderColor = const Color(0x80FFFFFF),
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final double size;
  final Color background;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: CircleBorder(side: BorderSide(color: borderColor)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, color: Colors.white, size: size * .42),
          ),
        ),
      ),
    );
  }
}

/// A toggle pill for "what is in your bag?".
class BagChip extends StatelessWidget {
  const BagChip({
    super.key,
    required this.label,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: selected,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13.5),
            decoration: BoxDecoration(
              color: selected ? accent : const Color(0x6110180F),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: selected ? accent : const Color(0x8CFFFFFF),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.body,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                height: 1.25,
                letterSpacing: .3,
                color: selected ? onAccent(accent) : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Splits a long title at its ampersand so it can sit on two lines:
/// "Adventure & Photography" becomes ["Adventure &", "Photography"].
List<String> splitAtAmpersand(String value) {
  final i = value.indexOf(' & ');
  if (i < 0) return [value];
  return [value.substring(0, i + 2), value.substring(i + 3)];
}

/// A label above a big Bebas value, used on the facts panels.
class BigStat extends StatelessWidget {
  const BigStat({
    super.key,
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.valueSize = 60,
    this.accentBar,
    this.caption,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final double valueSize;
  final Color? accentBar;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (accentBar != null) ...[
          Container(
            width: 28,
            height: 4,
            decoration: BoxDecoration(
              color: accentBar,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(label, style: labelStyle(labelColor)),
        const SizedBox(height: 8),
        for (final line in splitAtAmpersand(value))
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              line,
              maxLines: 1,
              style: displayStyle(valueSize, color: valueColor, height: .95),
            ),
          ),
        if (caption != null) ...[
          const SizedBox(height: 6),
          Text(caption!, style: bodyStyle(13, color: labelColor)),
        ],
      ],
    );
  }
}
