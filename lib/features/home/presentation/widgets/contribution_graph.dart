import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../features/github/data/github_repository.dart';
import 'heatmap_wave_reveal.dart';

















class ContributionGraph extends StatefulWidget {
  final List<ContributionDay> contributions;

  const ContributionGraph({super.key, required this.contributions});

  @override
  State<ContributionGraph> createState() => _ContributionGraphState();
}

class _ContributionGraphState extends State<ContributionGraph> {
  late List<List<ContributionDay?>> _weeks;

  static const int _rows = 7;
  static const double _cellGap = 3.0;

  @override
  void initState() {
    super.initState();
    _weeks = _buildWeeks();
  }

  @override
  void didUpdateWidget(ContributionGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.contributions != oldWidget.contributions) {
      _weeks = _buildWeeks();
    }
  }

  

  List<List<ContributionDay?>> _buildWeeks() {
    final days = widget.contributions;
    if (days.isEmpty) return [];

    final weeks = <List<ContributionDay?>>[];
    final firstWeekday = days.first.date.weekday % 7; 

    var current = List<ContributionDay?>.filled(7, null);
    int wIdx = firstWeekday;

    for (final day in days) {
      current[wIdx] = day;
      wIdx++;
      if (wIdx == 7) {
        weeks.add(List.from(current));
        current = List.filled(7, null);
        wIdx = 0;
      }
    }
    if (wIdx > 0) weeks.add(List.from(current));
    return weeks;
  }

  

  Map<int, String> _buildMonthLabels(List<List<ContributionDay?>> weeks) {
    final labels = <int, String>{};
    final seen = <String>{};
    for (int w = 0; w < weeks.length; w++) {
      for (final day in weeks[w]) {
        if (day == null) continue;
        if (day.date.day <= 7) {
          final key = '${day.date.year}-${day.date.month}';
          if (seen.add(key)) labels[w] = _monthAbbr(day.date.month);
        }
      }
    }
    return labels;
  }

  

  Color _colorForLevel(int level) {
    switch (level) {
      case 0:  return AppColors.contrib0;
      case 1:  return AppColors.contrib1;
      case 2:  return AppColors.contrib2;
      case 3:  return AppColors.contrib3;
      case 4:  return AppColors.contrib4;
      case 5:  return AppColors.contrib5;
      default: return AppColors.contrib5;
    }
  }

  String _monthAbbr(int m) => const [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][m - 1];

  String _formatDate(DateTime d) =>
      '${_monthAbbr(d.month)} ${d.day}, ${d.year}';

  

  @override
  Widget build(BuildContext context) {
    if (_weeks.isEmpty) return const SizedBox(height: 80);

    final labelColor = AppColors.textSecondary;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;

      
      final showDayLabels = width >= 300;
      final dayLabelWidth = showDayLabels ? 18.0 : 0.0;
      final gridWidth = width - dayLabelWidth;

      
      final maxWeeks = ((gridWidth + _cellGap) / (7.0 + _cellGap)).floor();
      final weeksToShow = maxWeeks.clamp(20, _weeks.length).toInt();

      
      final weeks = _weeks.length > weeksToShow
          ? _weeks.sublist(_weeks.length - weeksToShow)
          : _weeks;

      final weekCount = weeks.length;

      
      
      double cellSize = (gridWidth + _cellGap) / weekCount - _cellGap;
      cellSize = cellSize.clamp(5.0, 15.0);

      final weekStep = cellSize + _cellGap;
      final rowStep  = cellSize + _cellGap;
      final gridHeight = _rows * rowStep - _cellGap;

      
      final monthLabels = _buildMonthLabels(weeks);

      
      const labelRowHeight = 14.0;
      const labelGap = 4.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          
          SizedBox(
            height: labelRowHeight,
            child: Padding(
              padding: EdgeInsets.only(left: dayLabelWidth),
              child: Stack(
                clipBehavior: Clip.none,
                children: monthLabels.entries.map((e) {
                  return Positioned(
                    left: e.key * weekStep,
                    top: 0,
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: cellSize < 9 ? 7 : 8,
                        color: labelColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: labelGap),

          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              if (showDayLabels)
                SizedBox(
                  width: dayLabelWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_rows, (i) {
                      const labels = ['', 'M', '', 'W', '', 'F', ''];
                      return SizedBox(
                        height: rowStep,
                        child: labels[i].isNotEmpty
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  labels[i],
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: cellSize < 9 ? 6 : 7,
                                    color: labelColor,
                                  ),
                                ),
                              )
                            : null,
                      );
                    }),
                  ),
                ),

              
              Expanded(
                child: RepaintBoundary(
                  child: SizedBox(
                    height: gridHeight,
                    child: _HeatmapGrid(
                      weeks: weeks,
                      cellSize: cellSize,
                      cellGap: _cellGap,
                      colorForLevel: _colorForLevel,
                      formatDate: _formatDate,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}





class _HeatmapGrid extends StatelessWidget {
  final List<List<ContributionDay?>> weeks;
  final double cellSize;
  final double cellGap;
  final Color Function(int level) colorForLevel;
  final String Function(DateTime) formatDate;

  const _HeatmapGrid({
    required this.weeks,
    required this.cellSize,
    required this.cellGap,
    required this.colorForLevel,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    final weekStep = cellSize + cellGap;
    final rowStep  = cellSize + cellGap;

    return Stack(
      children: [
        for (int w = 0; w < weeks.length; w++)
          for (int d = 0; d < 7; d++)
            Positioned(
              left: w * weekStep,
              top:  d * rowStep,
              child: weeks[w][d] != null
                  ? HeatmapWaveReveal(
                      columnIndex: w,
                      child: _HeatmapCell(
                        day: weeks[w][d]!,
                        size: cellSize,
                        color: colorForLevel(weeks[w][d]!.level),
                        formatDate: formatDate,
                      ),
                    )
                  : SizedBox(width: cellSize, height: cellSize),
            ),
      ],
    );
  }
}





class _HeatmapCell extends StatefulWidget {
  final ContributionDay day;
  final double size;
  final Color color;
  final String Function(DateTime) formatDate;

  const _HeatmapCell({
    required this.day,
    required this.size,
    required this.color,
    required this.formatDate,
  });

  @override
  State<_HeatmapCell> createState() => _HeatmapCellState();
}

class _HeatmapCellState extends State<_HeatmapCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message:
            '${widget.formatDate(widget.day.date)} · ${widget.day.count} contribution${widget.day.count == 1 ? '' : 's'}',
        preferBelow: false,
        waitDuration: Duration.zero,
        textStyle: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 10,
          color: AppColors.textPrimary,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceElev,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            
            borderRadius: BorderRadius.zero,
            
            border: widget.day.level == 0
                ? Border.all(
                    color: isDark
                        ? const Color(0xFF21262D) 
                        : const Color(0xFFD0D7DE).withValues(alpha: 0.5), 
                    width: 0.5,
                  )
                : null,
            color: _isHovered
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.9)
                    : Colors.black.withValues(alpha: 0.55))
                : widget.color,
          ),
        ),
      ),
    );
  }
}