class AssetsPathConst {
  static final AssetsPathConst _singleton = AssetsPathConst._internal();

  factory AssetsPathConst() {
    return _singleton;
  }

  AssetsPathConst._internal();

  static const String _animationFolder = 'assets/animations';
  static String get animationSplash => '$_animationFolder/gifLoading.json';
  static String get animationLogin =>
      '$_animationFolder/26406-clapperboard.json';
}
