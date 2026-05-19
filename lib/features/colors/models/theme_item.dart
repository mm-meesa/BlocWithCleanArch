/// Represents a coloring-book theme (e.g. "Secret Garden").
class ThemeItem {
  final String name;
  final String folderName;   // asset sub-folder, e.g. "SecretGarden"
  final int imageCount;      // how many numbered images exist (1..imageCount)
  final String previewAsset; // path to the preview / cover image

  const ThemeItem({
    required this.name,
    required this.folderName,
    required this.imageCount,
    required this.previewAsset,
  });
}

/// All available themes that ship with the app.
const List<ThemeItem> kBuiltInThemes = [
  ThemeItem(
    name: 'Secret Garden',
    folderName: 'SecretGarden',
    imageCount: 41,
    previewAsset: 'assets/images/secretgraden.jpg',
  ),
];

/// Returns the asset path for image [index] (1-based) inside [theme].
/// Android named them "1.2.png", "2.2.png" … "39.2.png", "40.2.jpg", "41.2.jpg".
String assetPathForImage(ThemeItem theme, int index) {
  // The last two images in SecretGarden are .jpg; everything else is .png.
  final ext = (theme.folderName == 'SecretGarden' && index >= 40) ? 'jpg' : 'png';
  return 'assets/${theme.folderName}/$index.2.$ext';
}
