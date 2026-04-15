import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/garden_provider.dart';
import '../theme/app_theme.dart';

class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Garden'),
        centerTitle: true,
      ),
      body: Consumer<GardenProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Garden Stats Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: provider.skyGradient,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildGardenStat(
                            'Level',
                            provider.gardenLevel.toString(),
                            Icons.trending_up,
                          ),
                          _buildGardenStat(
                            'Plants',
                            provider.plantCount.toString(),
                            Icons.emoji_nature,
                          ),
                          _buildGardenStat(
                            'Next Level',
                            provider.nextLevelProgress,
                            Icons.star,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: provider.levelProgress,
                          minHeight: 10,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(provider.levelProgress * 100).toInt()}% to Level ${provider.gardenLevel + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Garden Grid
                Text(
                  'Your Plants',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: 9, // 3x3 grid
                  itemBuilder: (context, index) {
                    final hasPlant = index < provider.plantCount;
                    return Container(
                      decoration: BoxDecoration(
                        color: hasPlant ? AppTheme.primary : AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.accent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: hasPlant
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getPlantIcon(index),
                                  size: 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getPlantName(index),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Icon(
                              Icons.add,
                              color: AppTheme.textLight,
                              size: 30,
                            ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Achievements
                Text(
                  'Recent Achievements',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                ...provider.achievements
                    .map(
                      (achievement) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppTheme.sunlight.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                color: AppTheme.sunlight,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    achievement,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Completed!',
                                    style: TextStyle(
                                      color: AppTheme.textLight,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: AppTheme.primary,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGardenStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  IconData _getPlantIcon(int index) {
    const icons = [
      Icons.emoji_nature,
      Icons.local_florist,
      Icons.forest,
      Icons.park,
      Icons.yard,
      Icons.grass,
      Icons.eco,
      Icons.energy_savings_leaf,
      Icons.spa,
    ];
    return icons[index % icons.length];
  }

  String _getPlantName(int index) {
    const names = [
      'Oak',
      'Rose',
      'Pine',
      'Lily',
      'Maple',
      'Daisy',
      'Tulip',
      'Iris',
      'Fern',
    ];
    return names[index % names.length];
  }
}
