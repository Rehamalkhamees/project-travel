import 'package:flutter/material.dart';
import 'package:travel_project5/data/destination_content.dart';
import 'package:travel_project5/ui/style.dart';
import 'package:travel_project5/widgets/common.dart';
import 'package:travel_project5/widgets/story_section.dart';

import '../models/destination_model.dart';

/// One destination on its own screen (phones). On wide screens the home page
/// shows the same content inline.
class DestinationPage extends StatelessWidget {
  final DestinationModel destination;

  const DestinationPage({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    final content = DestinationContent.forName(destination.name);
    final accent = destination.color;

    return Scaffold(
      backgroundColor: AppColors.ground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        RoundIconButton(
                          icon: Icons.arrow_back,
                          label: 'Back to destinations',
                          size: 48,
                          background: Colors.transparent,
                          borderColor: AppColors.mapLine,
                          onTap: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        const Wordmark(size: 26),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: 470,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              heroPhotoFor(destination),
                              fit: BoxFit.cover,
                              alignment: heroAlignmentFor(destination),
                              semanticLabel: destination.name,
                              errorBuilder: (_, _, _) =>
                                  const ColoredBox(color: AppColors.deep),
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0x8C0A100E),
                                    Color(0x000A100E),
                                    Color(0x000A100E),
                                    Color(0xD10A100E),
                                  ],
                                  stops: [0, .4, .55, 1],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 18,
                              left: 16,
                              right: 16,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Semantics(
                                    header: true,
                                    child: Text(
                                      destination.name.toUpperCase(),
                                      maxLines: 1,
                                      softWrap: false,
                                      style: displayStyle(
                                        158,
                                        height: .86,
                                        spacing: -1,
                                        shadows: const [
                                          Shadow(
                                            color: Color(0x400A100E),
                                            blurRadius: 24,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 18,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _Pill(destination.type.toUpperCase(),
                                      background: accent, foreground: onAccent(accent)),
                                  _Pill(content.region),
                                  _Pill(content.season),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    AboutText(destination: destination, wide: false),
                    const SizedBox(height: 28),
                    DontMiss(destination: destination, wide: false),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          foregroundColor: onAccent(accent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'BACK TO DESTINATIONS',
                          style: labelStyle(onAccent(accent), size: 15, spacing: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, {this.background, this.foreground = Colors.white});

  final String text;
  final Color? background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: background ?? const Color(0x6610180F),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: background ?? const Color(0x99FFFFFF)),
      ),
      child: Text(text, style: labelStyle(foreground, size: 13, spacing: .8)),
    );
  }
}
