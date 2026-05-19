import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'main_color_pic_screen.dart';

/// Mirrors MainActivity: a single "Click" button that navigates to the
/// main coloring-book hub and requests storage permissions on launch.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    _checkStoragePermission();
  }

  /// Replicates MainActivity.checkStoragePermission().
  Future<void> _checkStoragePermission() async {
    // On Android 13+ request READ_MEDIA_IMAGES; otherwise READ/WRITE_EXTERNAL_STORAGE.
    final statuses = await [
      Permission.photos,       // READ_MEDIA_IMAGES on Android 13+
      Permission.storage,      // WRITE / READ_EXTERNAL_STORAGE on older Android
    ].request();

    // Mirror the Toast shown when permission is denied.
    final denied = statuses.values.any((s) => s.isDenied || s.isPermanentlyDenied);
    if (denied && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Storage permission required to save image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onClickButton() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const MainColorPicScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 100.h),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          onPressed: _onClickButton,
          child: const Text('Click'),
        ),
      ),
    );
  }
}
