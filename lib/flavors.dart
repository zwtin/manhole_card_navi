enum Flavor {
  development,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'マンナビDev';
      case Flavor.production:
        return 'マンナビ';
      default:
        return 'title';
    }
  }

}
