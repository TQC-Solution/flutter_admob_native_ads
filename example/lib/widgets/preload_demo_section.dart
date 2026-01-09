import 'package:flutter/material.dart';
import 'package:flutter_admob_native_ads/flutter_admob_native_ads.dart';

/// Section demonstrating preload functionality
class PreloadDemoSection extends StatelessWidget {
  final NativeAdController? preloadedController;
  final bool isPreloading;
  final VoidCallback onPreload;
  final VoidCallback onShowPreloaded;
  final VoidCallback onShowInNewScreen;

  const PreloadDemoSection({
    super.key,
    required this.preloadedController,
    required this.isPreloading,
    required this.onPreload,
    required this.onShowPreloaded,
    required this.onShowInNewScreen,
  });

  @override
  Widget build(BuildContext context) {
    final isAdLoaded = preloadedController?.isLoaded == true;

    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Preload Demo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Preload ads before showing them for instant display.',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: isPreloading ? null : onPreload,
                  icon: isPreloading
                      ? const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download),
                  label: Text(isPreloading ? 'Preloading...' : 'Preload Ad'),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (isAdLoaded) ? onShowPreloaded : null,
                    icon: const Icon(Icons.visibility),
                    label: const Text('Show Preloaded'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: isAdLoaded ? onShowInNewScreen : null,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Show Preloaded Ad in New Screen'),
            ),
            if (isAdLoaded)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Ad is preloaded and ready!',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
