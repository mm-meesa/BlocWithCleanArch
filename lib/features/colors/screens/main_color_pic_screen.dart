import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'theme_list_screen.dart';
import 'imagewall_screen.dart';

/// Mirrors MainColorPicActivity which uses a TabLayout + ViewPager.
/// The two tabs are "Theme List" and "Image Wall".
class MainColorPicScreen extends StatefulWidget {
  const MainColorPicScreen({super.key});

  @override
  State<MainColorPicScreen> createState() => _MainColorPicScreenState();
}

class _MainColorPicScreenState extends State<MainColorPicScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    Tab(text: 'Theme List'),
    Tab(text: 'Image Wall'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD3D3D3), // @color/lightgray
      body: Column(
        children: [
          // ── Top bar: back arrow + TabLayout  (mirrors the 80sdp RelativeLayout) ──
          Container(
            color: const Color(0xFF6C3C73), // @color/app_bg
            height: 80.h,
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  // Back button (ivBackPaint)
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 35.w,
                      height: 35.h,
                      margin: EdgeInsets.only(top: 2.h, left: 4.w),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  // TabBar fills remaining width
                  Expanded(
                    child: TabBar(
                      controller: _tabController,
                      tabs: _tabs,
                      indicatorColor: Colors.white,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── ViewPager equivalent ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ThemeListScreen(),
                ImageWallScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
