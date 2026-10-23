import 'package:flutter/material.dart';
import 'package:travel_project5/data/destination_content.dart';
import 'package:travel_project5/models/destination_model.dart';
import 'package:travel_project5/ui/style.dart';

/// "About the experience" and "Don't miss" for one destination.
class StorySection extends StatelessWidget {
  const StorySection({super.key, required this.destination, required this.wide});

  final DestinationModel destination;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final about = AboutText(destination: destination, wide: wide);
    final miss = DontMiss(destination: destination, wide: wide);
    if (!wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [about, const SizedBox(height: 40), miss],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 13, child: about),
        const SizedBox(width: 64),
        Expanded(flex: 10, child: miss),
      ],
    );
  }
}

class AboutText extends StatelessWidget {
  const AboutText({super.key, required this.destination, required this.wide});

  final DestinationModel destination;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final content = DestinationContent.forName(destination.name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 4,
          decoration: BoxDecoration(
            color: destination.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 14),
        Semantics(
          header: true,
          child: Text(
            'ABOUT THE EXPERIENCE',
            style: displayStyle(wide ? 64 : 52),
          ),
        ),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            content.about,
            style: bodyStyle(wide ? 18 : 17, height: 1.75),
          ),
        ),
      ],
    );
  }
}

class DontMiss extends StatelessWidget {
  const DontMiss({super.key, required this.destination, required this.wide});

  final DestinationModel destination;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final content = DestinationContent.forName(destination.name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text('DON’T MISS', style: displayStyle(wide ? 64 : 52)),
        ),
        const SizedBox(height: 18),
        for (var i = 0; i < content.dontMiss.length; i++)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                top: const BorderSide(color: AppColors.line),
                bottom: i == content.dontMiss.length - 1
                    ? const BorderSide(color: AppColors.line)
                    : BorderSide.none,
              ),
            ),
            child: Row(
              children: [
                Icon(content.icons[i], color: destination.color, size: 26),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    content.dontMiss[i],
                    style: displayStyle(wide ? 38 : 36, height: 1, spacing: 1),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
