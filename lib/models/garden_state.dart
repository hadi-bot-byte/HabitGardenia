class GardenState {
  final double overallHealth; // 0.0 - 1.0
  final int totalStreak;
  final int plantsAlive;
  final String season; // spring, summer, autumn, winter
  final String weatherMood; // sunny, cloudy, rainy (based on recent habits)

  const GardenState({
    required this.overallHealth,
    required this.totalStreak,
    required this.plantsAlive,
    required this.season,
    required this.weatherMood,
  });

  // Ecosystem description shown to user
  String get ecosystemDescription {
    if (overallHealth >= 0.8) return "Your garden is thriving! 🌸";
    if (overallHealth >= 0.5) return "Your garden is growing steadily 🌿";
    if (overallHealth >= 0.2) return "Your garden needs some attention 🍂";
    return "Your garden is dormant. Start your habits! 🌱";
  }
}
