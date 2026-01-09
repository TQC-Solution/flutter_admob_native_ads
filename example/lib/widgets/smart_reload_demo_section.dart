import 'package:flutter/material.dart';

/// Section demonstrating smart reload functionality
class SmartReloadDemoSection extends StatelessWidget {
  final bool isEnabled;
  final String status;
  final int reloadIntervalSeconds;
  final List<int> availableIntervals;
  final VoidCallback onStart;
  final VoidCallback onManualReload;
  final VoidCallback onStop;
  final ValueChanged<int> onIntervalChanged;

  const SmartReloadDemoSection({
    super.key,
    required this.isEnabled,
    required this.status,
    required this.reloadIntervalSeconds,
    required this.availableIntervals,
    required this.onStart,
    required this.onManualReload,
    required this.onStop,
    required this.onIntervalChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.refresh, color: Colors.green),
                const SizedBox(width: 8),
                const Text(
                  'Smart Reload Demo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Visibility-aware reload with cache priority.\n'
              '• Only reloads when app foreground + ad visible\n'
              '• Uses cached ad if available\n'
              '• Remote config interval support',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Status
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isEnabled ? Icons.check_circle : Icons.info_outline,
                        color: isEnabled ? Colors.green : Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Status: $status',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  if (isEnabled) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Interval: ${reloadIntervalSeconds}s',
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Interval selector
            Row(
              children: [
                const Text('Interval: ', style: TextStyle(fontSize: 12)),
                ...availableIntervals.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: ChoiceChip(
                      label: Text('${s}s'),
                      selected: reloadIntervalSeconds == s,
                      onSelected: (selected) {
                        if (selected) onIntervalChanged(s);
                      },
                      labelStyle: const TextStyle(fontSize: 10),
                      padding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Control buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: isEnabled ? null : onStart,
                  icon: const Icon(Icons.play_arrow, size: 16),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: isEnabled ? onManualReload : null,
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Manual Reload'),
                ),
                ElevatedButton.icon(
                  onPressed: isEnabled ? onStop : null,
                  icon: const Icon(Icons.stop, size: 16),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
