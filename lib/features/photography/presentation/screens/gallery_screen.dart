import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../home/presentation/editorial/ed_primitives.dart';
import '../../../home/presentation/editorial/ed_projects.dart';
import '../../../home/presentation/editorial/ed_theme.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const _images = [
    'assets/images/aabes.jpeg',
    'assets/images/abesss.jpeg',
    'assets/images/caat.jpeg',
    'assets/images/cafe.jpeg',
    'assets/images/cat.jpeg',
    'assets/images/flower.jpeg',
    'assets/images/flow.jpeg',
    'assets/images/mount.jpeg',
    'assets/images/shiv.jpeg',
    'assets/images/sq.jpeg',
    'assets/images/abessss.jpg',
    'assets/images/flower.jpg',
    'assets/images/sunshine.jpg',
    'assets/images/fire.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);

    return EdSubScaffold(
      trail: '/ photography',
      activeIndex: 0,
      builder: (context, scroll) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hero band — full-bleed with hatched gutters
          PageHeroBand(
            title: 'Photography',
            badge: '[ 14 CAPTURES ]',
            description:
                'A visual diary of everyday moments, travel frames, light studies, and architectural textures captured through digital and analog glass.',
            highlights: [
              (label: '✦ Digital & 35mm', color: ed.live),
              (label: '📍 Travel & Architecture', color: ed.ink2),
              (label: '📷 Nikon & iPhone', color: ed.ink2),
            ],
            onBack: () => Navigator.of(context).pop(),
          ),

          // ── Section 01: Gallery Grid ────────────────────────────────
          const SectionBand('[ 01 ] SELECTED SHOTS & FRAMES', trailing: MonoTag('14 PHOTOS')),
          ColumnBox(
            padding: EdgeInsets.fromLTRB(edPad(context), 24, edPad(context), 36),
            child: LayoutBuilder(builder: (context, c) {
              final cols = c.maxWidth >= 760 ? 3 : (c.maxWidth >= 480 ? 2 : 1);
              const spacing = 12.0;
              final w = (c.maxWidth - spacing * (cols - 1)) / cols;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (int i = 0; i < _images.length; i++)
                    SizedBox(
                      width: w,
                      child: _GalleryCard(
                        imagePath: _images[i],
                        index: i,
                        onTap: () => _openLightbox(context, _images[i]),
                      ),
                    ),
                ],
              );
            }),
          ),
          const ColumnBox(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  void _openLightbox(BuildContext context, String path) {
    final ed = Ed.of(context);
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.88),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              minScale: 0.8,
              maxScale: 3.5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: ed.line2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(path, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Hover(
                onTap: () => Navigator.of(ctx).pop(),
                semanticLabel: 'Close',
                builder: (_, h) => Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.x, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryCard extends StatefulWidget {
  final String imagePath;
  final int index;
  final VoidCallback onTap;

  const _GalleryCard({
    required this.imagePath,
    required this.index,
    required this.onTap,
  });

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ed = Ed.of(context);
    final fileName = widget.imagePath.split('/').last;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: ed.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _hovered ? ed.ink : ed.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo box
              AspectRatio(
                aspectRatio: 1.25,
                child: AnimatedScale(
                  scale: _hovered ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: ed.raised,
                      alignment: Alignment.center,
                      child: Icon(LucideIcons.imageOff, color: ed.ink3),
                    ),
                  ),
                ),
              ),
              // Footer metadata
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: ed.card,
                  border: Border(top: BorderSide(color: ed.line)),
                ),
                child: Row(
                  children: [
                    Text(
                      '#${(widget.index + 1).toString().padLeft(2, '0')}',
                      style: ed.mono(10, color: ed.ink3),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        fileName,
                        style: ed.mono(10.5, color: _hovered ? ed.ink : ed.ink2),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      LucideIcons.maximize2,
                      size: 11,
                      color: _hovered ? ed.ink : ed.ink3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
