enum Highlight { bestValue, recommended, mostAffordable, lite, none }

extension SubHighlight on Highlight {
  /// Convert enum to string
  String get value {
    switch (this) {
      case Highlight.lite:
        return "lite";
      case Highlight.bestValue:
        return "best_value";
      case Highlight.mostAffordable:
        return "most_affordable";
      case Highlight.recommended:
        return 'recommended';
      case Highlight.none:
        return 'most_affordable';
    }
  }

  /// Parse string to enum
  static Highlight fromString(String highlight) {
    switch (highlight) {
      case "lite":
        return Highlight.lite;
      case "best_value":
        return Highlight.bestValue;
      case "most_affordable":
        return Highlight.mostAffordable;
      case 'recommended':
        return Highlight.recommended;
      default:
        throw ArgumentError("Invalid highlight value: $highlight");
    }
  }
}
