import 'package:flutter/material.dart';
import 'package:travel_project5/models/destination_model.dart';
import 'package:travel_project5/ui/style.dart';

class _Photo {
  const _Photo(this.label, this.path);

  final String label;
  final String path;
}

/// Photos that ship with the app. A new destination can only use one of
/// these, because the app loads its pictures from `assets/images/`.
const _photos = <_Photo>[
  _Photo('Diriyah', 'assets/images/diriyah2.jpeg'),
  _Photo('Diriyah (wide)', 'assets/images/diriyah1.jpeg'),
  _Photo('Riyadh', 'assets/images/riyadh1.jpeg'),
  _Photo('Riyadh (wide)', 'assets/images/riyadh2.jpeg'),
  _Photo('AlUla', 'assets/images/alula2.jpeg'),
  _Photo('AlUla (wide)', 'assets/images/alula1.jpeg'),
  _Photo('Umluj', 'assets/images/umluj1.jpeg'),
  _Photo('Umluj (wide)', 'assets/images/umluj2.jpeg'),
  _Photo('Abha', 'assets/images/abha1.jpeg'),
  _Photo('Abha (wide)', 'assets/images/abha2.jpeg'),
];

const _swatches = <Color>[
  Color(0xFFE3A872),
  Color(0xFF8CC0D6),
  Color(0xFFEB9C63),
  Color(0xFF63CFC8),
  Color(0xFF9CCB78),
  Color(0xFFF2C94C),
];

/// A form for a new destination. [onSave] stores it; when it throws, the
/// dialog stays open and shows the problem. Pops with the new name on success.
class AddDestinationDialog extends StatefulWidget {
  const AddDestinationDialog({super.key, required this.onSave});

  final Future<void> Function(DestinationModel model) onSave;

  @override
  State<AddDestinationDialog> createState() => _AddDestinationDialogState();
}

class _AddDestinationDialogState extends State<AddDestinationDialog> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  String image = _photos.first.path;
  Color color = _swatches[2];
  String? error;
  bool saving = false;

  @override
  void dispose() {
    nameController.dispose();
    typeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = nameController.text.trim();
    final type = typeController.text.trim();
    if (name.isEmpty || type.isEmpty) {
      setState(() => error = 'Enter a name and a type.');
      return;
    }

    setState(() {
      saving = true;
      error = null;
    });
    try {
      await widget.onSave(
        DestinationModel(name: name, type: type, image: image, color: color),
      );
      if (!mounted) return;
      Navigator.of(context).pop(name);
    } catch (e) {
      if (!mounted) return;
      final detail = e.toString();
      setState(() {
        saving = false;
        error = 'Could not save the destination. '
            '${detail.length > 160 ? '${detail.substring(0, 160)}…' : detail}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // The app is dark; the form sits on a light card, so it gets a light theme
    // (otherwise typed text and labels would be light on light).
    return Theme(
      data: ThemeData(
        brightness: Brightness.light,
        fontFamily: AppFonts.body,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.ink,
          brightness: Brightness.light,
        ),
      ),
      child: _buildDialog(),
    );
  }

  Widget _buildDialog() {
    return Dialog(
      backgroundColor: AppColors.paper,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  'ADD A DESTINATION',
                  style: displayStyle(40, color: AppColors.ink, spacing: .5),
                ),
              ),
              const SizedBox(height: 18),
              TextField(
                key: const Key('add-name'),
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                key: const Key('add-type'),
                controller: typeController,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  hintText: 'For example: Beach',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                key: const Key('add-photo'),
                initialValue: image,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Photo',
                  border: OutlineInputBorder(),
                ),
                items: [
                  for (final photo in _photos)
                    DropdownMenuItem(
                      value: photo.path,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              photo.path,
                              width: 36,
                              height: 36,
                              fit: BoxFit.cover,
                              excludeFromSemantics: true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(photo.label),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => image = value);
                },
              ),
              const SizedBox(height: 18),
              Text('Accent colour',
                  style: labelStyle(AppColors.quietOnPaper, size: 12)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final swatch in _swatches)
                    _Swatch(
                      color: swatch,
                      selected: swatch == color,
                      onTap: () => setState(() => color = swatch),
                    ),
                ],
              ),
              if (error != null) ...[
                const SizedBox(height: 16),
                Text(
                  error!,
                  style: bodyStyle(14,
                      color: const Color(0xFFB3261E), weight: FontWeight.w600),
                ),
              ],
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: saving ? null : () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(foregroundColor: AppColors.ink),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: saving ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      foregroundColor: AppColors.paper,
                      minimumSize: const Size(140, 48),
                    ),
                    child: saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.paper,
                            ),
                          )
                        : const Text('Add destination'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Accent colour',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.ink : Colors.transparent,
              width: 3,
            ),
          ),
          child: selected
              ? Icon(Icons.check, color: onAccent(color), size: 22)
              : null,
        ),
      ),
    );
  }
}
