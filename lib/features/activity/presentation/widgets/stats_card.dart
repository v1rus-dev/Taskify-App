import 'package:design/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:taskify/features/activity/domain/models/activity_cell_level.dart';
import 'package:taskify/features/activity/domain/models/activity_heatmap_cell.dart';
import 'package:taskify/l10n/app_localizations.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.heatmapCells});

  final List<ActivityHeatmapCell> heatmapCells;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations?.stats ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColorExtensions.getTextPrimaryColor(context),
                  ),
                ),
                Text(
                  localizations?.last3Months ?? '',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColorExtensions.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _HeatmapGrid(heatmapCells: heatmapCells),
            heatmapCells.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      localizations?.completeTaskToSeeYourProgress ?? '',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColorExtensions.getTextSecondaryColor(
                          context,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _HeatmapGrid extends StatelessWidget {
  const _HeatmapGrid({required this.heatmapCells});

  final List<ActivityHeatmapCell> heatmapCells;

  static const int _gridRows = 7;
  static const int _gridColumns = 17;
  static const double _cellSpacing = 4.0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double totalSpacing = _cellSpacing * (_gridColumns - 1);
    final double cellWidth = (screenWidth - totalSpacing) / _gridColumns;

    List<Widget> gridChildren = [];
    for (int row = 0; row < _gridRows; row++) {
      for (int col = 0; col < _gridColumns; col++) {
        final idx = col * _gridRows + row;
        if (idx >= heatmapCells.length) continue;
        gridChildren.add(
          _HeatmapCell(
            cell: heatmapCells[idx],
            width: cellWidth,
            height: cellWidth,
          ),
        );
      }
    }

    return SizedBox(
      height: _gridRows * cellWidth + (_gridRows - 1),
      width: screenWidth,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: _gridColumns,
        mainAxisSpacing: _cellSpacing,
        crossAxisSpacing: _cellSpacing,
        padding: EdgeInsets.zero,
        children: gridChildren,
      ),
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  const _HeatmapCell({
    required this.cell,
    required this.width,
    required this.height,
  });

  final ActivityHeatmapCell cell;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: cell.level.color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
