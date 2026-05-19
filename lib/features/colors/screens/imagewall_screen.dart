import 'package:flutter/material.dart';

/// Mirrors the "Image Wall" fragment (fragment_imagewall.xml).
/// Shows a scrollable feed of community-shared painted images.
/// In the Android version this loaded from a remote API; here it shows
/// a "Coming Soon" placeholder matching the view_developing layout that
/// was included inside fragment_imagewall.xml.
class ImageWallScreen extends StatefulWidget {
  const ImageWallScreen({super.key});

  @override
  State<ImageWallScreen> createState() => _ImageWallScreenState();
}

class _ImageWallScreenState extends State<ImageWallScreen> {
  bool _isRefreshing = false;

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) setState(() => _isRefreshing = false);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      // The Android layout included view_developing (coming-soon overlay)
      // centred on top of the recycler view.
      child: Stack(
        children: [
          // Empty scrollable area so pull-to-refresh still works
          ListView(
            children: const [SizedBox(height: 400)],
          ),
          // Coming-soon overlay  (mirrors view_developing.xml)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/comingsoon.png',
                  width: 200,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Coming soon!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
