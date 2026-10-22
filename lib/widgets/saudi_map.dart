import 'package:flutter/material.dart';
import 'package:travel_project5/ui/style.dart';

/// Simplified outline of Saudi Arabia on a 400 x 330 grid (not survey accurate).
const _outline = <Offset>[
  Offset(8.2, 63.0), Offset(28.6, 66.2), Offset(45.5, 52.0), Offset(56.4, 42.0),
  Offset(63.7, 20.0), Offset(85.5, 7.0), Offset(107.4, 12.0), Offset(136.5, 28.0),
  Offset(185.6, 66.0), Offset(219.3, 68.0), Offset(240.2, 79.0), Offset(253.0, 79.0),
  Offset(262.1, 98.0), Offset(274.8, 111.0), Offset(284.8, 118.0), Offset(285.7, 136.0),
  Offset(296.6, 155.0), Offset(311.2, 165.0), Offset(329.4, 191.0), Offset(384.9, 210.0),
  Offset(373.1, 250.0), Offset(318.5, 270.0), Offset(265.7, 278.0), Offset(249.3, 298.0),
  Offset(236.6, 308.0), Offset(214.8, 305.0), Offset(194.7, 302.0), Offset(172.9, 302.0),
  Offset(160.2, 316.0), Offset(151.1, 322.0), Offset(146.5, 312.0), Offset(132.9, 292.0),
  Offset(120.1, 268.0), Offset(105.6, 246.0), Offset(92.8, 232.0), Offset(85.0, 220.0),
  Offset(81.9, 194.0), Offset(72.8, 178.0), Offset(64.8, 168.2), Offset(50.4, 149.6),
  Offset(35.5, 125.2), Offset(21.8, 103.0), Offset(12.7, 88.0),
];

const _riyadh = Offset(221.6, 155.7);
const _mapWidth = 400.0;
const _mapHeight = 330.0;

/// Outline map with a dot per destination, a dashed route from Riyadh and a
/// pulsing marker on the chosen one.
class SaudiMap extends StatefulWidget {
  const SaudiMap({
    super.key,
    required this.points,
    required this.activeIndex,
    required this.accent,
    required this.semanticLabel,
  });

  /// One entry per destination; null when a destination has no map position.
  final List<Offset?> points;
  final int activeIndex;
  final Color accent;
  final String semanticLabel;

  @override
  State<SaudiMap> createState() => _SaudiMapState();
}

class _SaudiMapState extends State<SaudiMap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the system "reduce motion" setting.
    if (MediaQuery.of(context).disableAnimations) {
      _pulse.stop();
    } else if (!_pulse.isAnimating) {
      _pulse.repeat();
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: widget.semanticLabel,
      child: AspectRatio(
        aspectRatio: _mapWidth / _mapHeight,
        child: CustomPaint(
          painter: _MapPainter(
            points: widget.points,
            active: widget.activeIndex,
            accent: widget.accent,
            pulse: _pulse,
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.points,
    required this.active,
    required this.accent,
    required this.pulse,
  }) : super(repaint: pulse);

  final List<Offset?> points;
  final int active;
  final Color accent;
  final Animation<double> pulse;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / _mapWidth);

    final outline = Path()..addPolygon(_outline, true);
    canvas.drawPath(outline, Paint()..color = AppColors.mapFill);
    canvas.drawPath(
      outline,
      Paint()
        ..color = AppColors.mapLine
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeJoin = StrokeJoin.round,
    );

    final target = (active >= 0 && active < points.length) ? points[active] : null;
    if (target != null) {
      _dashedLine(
        canvas,
        _riyadh,
        target,
        Paint()
          ..color = AppColors.quiet
          ..strokeWidth = 1.2,
      );
    }

    final dot = Paint()..color = AppColors.mapDot;
    for (final p in points) {
      if (p != null) canvas.drawCircle(p, 3.5, dot);
    }

    if (target != null) {
      final t = pulse.value;
      canvas.drawCircle(
        target,
        6 * (1 + 2.4 * t),
        Paint()..color = accent.withValues(alpha: .75 * (1 - t)),
      );
      canvas.drawCircle(target, 4.5, Paint()..color = accent);
      canvas.drawCircle(
        target,
        9,
        Paint()
          ..color = accent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
    }
    canvas.restore();
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 3.0;
    const gap = 5.0;
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    var d = 0.0;
    while (d < total) {
      final end = (d + dash).clamp(0.0, total);
      canvas.drawLine(a + dir * d, a + dir * end, paint);
      d += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.active != active || old.accent != accent || old.points != points;
}
