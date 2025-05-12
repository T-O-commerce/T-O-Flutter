import 'package:flutter/material.dart';

class CategoryData {
  final IconData icon;
  final String name;
  final String description;
  final List<Color> gradientColors;

  CategoryData({
    required this.icon,
    required this.name,
    required this.description,
    required this.gradientColors,
  });
}

class AccessoriesCarousel extends StatefulWidget {
  const AccessoriesCarousel({super.key});

  @override
  State<AccessoriesCarousel> createState() => _AccessoriesCarouselState();
}

class _AccessoriesCarouselState extends State<AccessoriesCarousel> {
  int _activeIndex = 0;

  final List<CategoryData> categories = [
    CategoryData(
      icon: Icons.smartphone,
      name: "Phones",
      description: "Latest Smartphones",
      gradientColors: [
        const Color(0xFFEC4899),
        const Color(0xFFF43F5E),
      ],
    ),
    CategoryData(
      icon: Icons.headphones,
      name: "Audio",
      description: "Premium Sound",
      gradientColors: [
        const Color(0xFF8B5CF6),
        const Color(0xFF6366F1),
      ],
    ),
    CategoryData(
      icon: Icons.camera_alt,
      name: "Cameras",
      description: "Pro Photography",
      gradientColors: [
        const Color(0xFF3B82F6),
        const Color(0xFF06B6D4),
      ],
    ),
    CategoryData(
      icon: Icons.battery_full,
      name: "Power",
      description: "Fast Charging",
      gradientColors: [
        const Color(0xFF10B981),
        const Color(0xFF059669),
      ],
    ),
    CategoryData(
      icon: Icons.tablet,
      name: "Tablets",
      description: "Touch Computing",
      gradientColors: [
        const Color(0xFFF97316),
        const Color(0xFFF59E0B),
      ],
    ),
    CategoryData(
      icon: Icons.laptop,
      name: "Laptops",
      description: "Portable Power",
      gradientColors: [
        const Color(0xFFEF4444),
        const Color(0xFFEC4899),
      ],
    ),
    CategoryData(
      icon: Icons.sports_esports,
      name: "Gaming",
      description: "Play More",
      gradientColors: [
        const Color(0xFF8B5CF6),
        const Color(0xFFA855F7),
      ],
    ),
    CategoryData(
      icon: Icons.apple,
      name: "Apple",
      description: "iOS Ecosystem",
      gradientColors: [
        const Color(0xFF374151),
        const Color(0xFF111827),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF9FAFB), Colors.white],
        ),
      ),
      child: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'Explore Categories',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Discover our wide range of premium tech accessories and gadgets',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _activeIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  transform: Matrix4.identity()..scale(_activeIndex == index ? 1.05 : 1.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: category.gradientColors,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Icon Container
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                category.icon,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      
                      // New Badge
                      if (_activeIndex == index)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: _buildNewBadge(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewBadge() {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Text(
              'NEW',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B5CF6),
              ),
            ),
          ),
        );
      },
    );
  }
}