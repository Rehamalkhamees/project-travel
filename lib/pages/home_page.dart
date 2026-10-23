import 'package:flutter/material.dart';
import 'package:travel_project5/data/bag.dart';
import 'package:travel_project5/service/database.dart';
import 'package:travel_project5/ui/style.dart';
import 'package:travel_project5/widgets/add_destination_dialog.dart';
import 'package:travel_project5/widgets/common.dart';
import 'package:travel_project5/widgets/destination_cards.dart';
import 'package:travel_project5/widgets/facts_panels.dart';
import 'package:travel_project5/widgets/hero_stage.dart';
import 'package:travel_project5/widgets/story_section.dart';

import '../models/destination_model.dart';
import 'destination_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.loadDestinations, this.saveDestination});

  /// Where the destinations come from. Defaults to the Supabase table.
  final Future<List<DestinationModel>> Function()? loadDestinations;

  /// Where a new destination is stored. Defaults to the Supabase table.
  final Future<void> Function(DestinationModel model)? saveDestination;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final GlobalKey storyKey = GlobalKey();
  final GlobalKey destinationsKey = GlobalKey();

  List<DestinationModel> destinations = [];
  bool loading = true;
  Object? error;
  int active = 0;
  Set<String> picked = {};
  String query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  /// Loads the destinations; [select] names the one to show afterwards.
  Future<void> _load({String? select}) async {
    try {
      final loader = widget.loadDestinations ?? Database().getAlltravel;
      final data = await loader();
      if (!mounted) return;
      final selected = select == null ? -1 : data.indexWhere((d) => d.name == select);
      setState(() {
        destinations = data;
        active = selected < 0 ? 0 : selected;
        loading = false;
        error = null;
      });
    } catch (e) {
      debugPrint('Could not load the destinations: $e');
      if (!mounted) return;
      setState(() {
        error = e;
        loading = false;
      });
    }
  }

  void _retry() {
    setState(() {
      loading = true;
      error = null;
    });
    _load();
  }

  void _select(int index) => setState(() => active = index);

  Future<void> _addDestination() async {
    final added = await showDialog<String>(
      context: context,
      builder: (context) => AddDestinationDialog(
        onSave: widget.saveDestination ??
            (model) => Database().addNewplace(model: model),
      ),
    );
    if (added == null || !mounted) return;
    await _load(select: added);
    if (!mounted) return;
    if (scrollController.hasClients) _scrollToTop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$added was added')),
    );
  }

  void _step(int delta) {
    final n = destinations.length;
    _select((active + delta + n) % n);
  }

  void _toggle(String id) {
    final next = {...picked};
    if (!next.remove(id)) next.add(id);
    setState(() => picked = next);
  }

  void _openDetail(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DestinationPage(destination: destinations[index]),
      ),
    );
  }

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(
      target,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ground,
      floatingActionButton: loading || error != null
          ? null
          : FloatingActionButton(
              onPressed: _addDestination,
              tooltip: 'Add a destination',
              backgroundColor: AppColors.paper,
              foregroundColor: AppColors.ink,
              child: const Icon(Icons.add, size: 30),
            ),
      body: SafeArea(
        child: loading
            ? const Center(child: CircularProgressIndicator(color: AppColors.mist))
            : error != null
                ? _Message(
                    text: 'Could not load the destinations. Check your connection and try again.',
                    detail: _describe(error!),
                    action: 'Try again',
                    onAction: _retry,
                  )
                : destinations.isEmpty
                    ? const _Message(text: 'No destinations yet.')
                    : _content(),
      ),
    );
  }

  Widget _content() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= kWideBreakpoint;
        final pad = wide ? 24.0 : 16.0;
        final current = destinations[active];

        return SingleChildScrollView(
          controller: scrollController,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: kMaxContentWidth + 48),
              child: Padding(
                padding: EdgeInsets.fromLTRB(pad, 0, pad, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(
                      wide: wide,
                      counter: '${(active + 1).toString().padLeft(2, '0')} / '
                          '${destinations.length.toString().padLeft(2, '0')}',
                      onBag: _scrollToTop,
                      onStory: () => _scrollTo(storyKey),
                      onDestinations: () => _scrollTo(destinationsKey),
                    ),
                    const SizedBox(height: 12),
                    HeroStage(
                      destinations: destinations,
                      active: active,
                      wide: wide,
                      picked: picked,
                      pickLine: packLine(current.name, picked),
                      onToggle: _toggle,
                      onPrev: () => _step(-1),
                      onNext: () => _step(1),
                      onOpen: () => _openDetail(active),
                    ),
                    SizedBox(height: wide ? 16 : 12),
                    FactsPanels(
                      destinations: destinations,
                      active: active,
                      wide: wide,
                      onSelect: _select,
                    ),
                    if (wide) ...[
                      SizedBox(key: storyKey, height: 64),
                      StorySection(destination: current, wide: wide),
                    ],
                    SizedBox(key: destinationsKey, height: wide ? 64 : 36),
                    DestinationCards(
                      destinations: destinations,
                      active: active,
                      picked: picked,
                      wide: wide,
                      searchController: searchController,
                      query: query,
                      onQueryChanged: (value) => setState(() => query = value),
                      onSelect: (index) {
                        _select(index);
                        if (wide) {
                          _scrollToTop();
                        } else {
                          _openDetail(index);
                        }
                      },
                    ),
                    const SizedBox(height: 56),
                    const _Footer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.wide,
    required this.counter,
    required this.onBag,
    required this.onStory,
    required this.onDestinations,
  });

  final bool wide;
  final String counter;
  final VoidCallback onBag;
  final VoidCallback onStory;
  final VoidCallback onDestinations;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: wide ? 22 : 20, left: 2, right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wordmark(size: wide ? 28 : 26),
          if (wide)
            Row(
              children: [
                _NavLink('Your bag', onBag),
                _NavLink('The experience', onStory),
                _NavLink('Destinations', onDestinations),
              ],
            )
          else
            Text(counter, style: labelStyle(AppColors.mist, size: 13, spacing: 1.6)),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink(this.text, this.onTap);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.mist,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      child: Text(text, style: bodyStyle(14, weight: FontWeight.w600, color: AppColors.mist)),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 6,
        spacing: 12,
        children: [
          const Wordmark(size: 22),
          Text('Your Bag, Your Destination',
              style: bodyStyle(14, color: AppColors.quiet)),
        ],
      ),
    );
  }
}

/// Short technical reason shown under the error message (helps spot a paused
/// Supabase project, a wrong key or a missing table).
String _describe(Object error) {
  final text = error.toString();
  return text.length > 220 ? '${text.substring(0, 220)}…' : text;
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.detail, this.action, this.onAction});

  final String text;
  final String? detail;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, textAlign: TextAlign.center, style: bodyStyle(18)),
            if (detail != null) ...[
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SelectableText(
                  detail!,
                  textAlign: TextAlign.center,
                  style: bodyStyle(13, color: AppColors.quiet),
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.paper,
                  foregroundColor: AppColors.ink,
                  minimumSize: const Size(160, 48),
                ),
                child: Text(action!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
