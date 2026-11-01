import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'ed_theme.dart';

class PaletteCommand {
  final String group;
  final String label;
  final IconData icon;
  final String? hint;
  final VoidCallback run;
  const PaletteCommand(this.group, this.label, this.icon, this.run, {this.hint});
}

/// Opens the ⌘K command palette. The chosen command runs after the dialog closes.
Future<void> showCommandPalette(BuildContext context, List<PaletteCommand> commands) async {
  final picked = await showGeneralDialog<PaletteCommand>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close command menu',
    barrierColor: Colors.black.withValues(alpha: 0.35),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, __, ___) => _Palette(commands: commands),
    transitionBuilder: (_, a, __, child) {
      final c = CurvedAnimation(parent: a, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: c,
        child: ScaleTransition(scale: Tween(begin: 0.97, end: 1.0).animate(c), child: child),
      );
    },
  );
  picked?.run();
}

class _Palette extends StatefulWidget {
  final List<PaletteCommand> commands;
  const _Palette({required this.commands});
  @override
  State<_Palette> createState() => _PaletteState();
}

class _PaletteState extends State<_Palette> {
  final _query = TextEditingController();
  final _scroll = ScrollController();
  int _sel = 0;

  List<PaletteCommand> get _results {
    final q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return widget.commands;
    return widget.commands
        .where((c) => c.label.toLowerCase().contains(q) || c.group.toLowerCase().contains(q))
        .toList();
  }

  void _move(int d) {
    final n = _results.length;
    if (n == 0) return;
    setState(() => _sel = (_sel + d) % n);
    // keep selection in view (rows are 38px, headers ~26px — approximate is fine)
    final target = (_sel * 38.0) - 120;
    if (_scroll.hasClients) {
      _scroll.animateTo(target.clamp(0, _scroll.position.maxScrollExtent),
          duration: const Duration(milliseconds: 120), curve: Curves.easeOut);
    }
  }

  void _pick(PaletteCommand c) => Navigator.of(context).pop(c);

  @override
  void dispose() {
    _query.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final results = _results;
    if (_sel >= results.length) _sel = 0;

    final children = <Widget>[];
    String? group;
    for (int i = 0; i < results.length; i++) {
      final c = results[i];
      if (c.group != group) {
        group = c.group;
        children.add(Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: Text(group.toUpperCase(), style: ed.mono(9, ls: 1.4)),
        ));
      }
      final selected = i == _sel;
      children.add(MouseRegion(
        cursor: SystemMouseCursors.click,
        onHover: (_) {
          if (_sel != i) setState(() => _sel = i);
        },
        child: GestureDetector(
          onTap: () => _pick(c),
          child: Container(
            height: 38,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: selected ? ed.raised : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(children: [
              Icon(c.icon, size: 14, color: selected ? ed.ink : ed.ink2),
              const SizedBox(width: 10),
              Expanded(
                child: Text(c.label,
                    style: ed.sans(13, color: selected ? ed.ink : ed.ink2, w: FontWeight.w500, h: 1.2)),
              ),
              if (c.hint != null) Text(c.hint!, style: ed.mono(9.5)),
              if (selected) ...[
                const SizedBox(width: 8),
                Icon(LucideIcons.cornerDownLeft, size: 12, color: ed.ink3),
              ],
            ]),
          ),
        ),
      ));
    }

    return Align(
      alignment: const Alignment(0, -0.55),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540, maxHeight: 460),
          child: Material(
            color: ed.card,
            elevation: 0,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ed.line2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 40, offset: const Offset(0, 20)),
                ],
              ),
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
                  const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
                  const SingleActivator(LogicalKeyboardKey.enter): () {
                    if (results.isNotEmpty) _pick(results[_sel]);
                  },
                  const SingleActivator(LogicalKeyboardKey.escape): () => Navigator.of(context).pop(),
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(children: [
                      Icon(LucideIcons.search, size: 15, color: ed.ink3),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _query,
                          autofocus: true,
                          cursorColor: ed.ink,
                          cursorWidth: 1.2,
                          style: ed.sans(14, color: ed.ink, h: 1.2),
                          onChanged: (_) => setState(() => _sel = 0),
                          onSubmitted: (_) {
                            if (results.isNotEmpty) _pick(results[_sel]);
                          },
                          decoration: InputDecoration(
                            hintText: 'Type a command or search…',
                            hintStyle: ed.sans(14, color: ed.ink3, h: 1.2),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: ed.line),
                        ),
                        child: Text('esc', style: ed.mono(9)),
                      ),
                    ]),
                  ),
                  Divider(height: 1, thickness: 1, color: ed.line),
                  Flexible(
                    child: results.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(28),
                            child: Text('No results for “${_query.text}”', style: ed.mono(11)),
                          )
                        : ListView(
                            controller: _scroll,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(bottom: 8),
                            children: children,
                          ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: ed.raised.withValues(alpha: 0.5),
                      border: Border(top: BorderSide(color: ed.line)),
                    ),
                    child: Row(children: [
                      Text('↑↓ navigate   ↵ select   esc close', style: ed.mono(9)),
                      const Spacer(),
                      Text('${results.length} results', style: ed.mono(9)),
                    ]),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
