class Assets {
  Assets._();

  static const _Images images = _Images();
  static const _Icons icons = _Icons();
}

class _Images {
  const _Images();

  String get logo => 'assets/images/logo.png';
  String get authIllustration => 'assets/images/auth_illustration.png';
  String get emptyPhotos => 'assets/images/empty_photos.png';
  String get emptyAlbums => 'assets/images/empty_albums.png';
  String get profileAvatar => 'assets/images/profile_avatar.png';
}

class _Icons {
  const _Icons();

  String get google => 'assets/icons/google.png';
  String get apple => 'assets/icons/apple.png';
}
