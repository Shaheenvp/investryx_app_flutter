class HeroTagManager {
  static String generateUniqueTag(String baseTag, String identifier) {
    return '${baseTag}_$identifier';
  }
}