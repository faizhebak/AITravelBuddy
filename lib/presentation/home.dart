import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'route_suggestion.dart';
import 'all_destinations_page.dart';
import 'destination_details_page.dart';
import 'ar_scanner_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFF000000),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      _buildMainContent(context),
                    ],
                  ),
                ),
              ),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            blurRadius: 50,
            offset: const Offset(0, 25),
          ),
        ],
      ),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x4DA51212),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFA51212), Color(0xFFD32F2F), Color(0xFF8B0000)],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 23),
        child: Column(
          children: [
            const Text(
              "Malaysia Explorer",
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Discover Malaysia with AR & AI",
              style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Container(
      color: const Color(0xFF000000),
      padding: const EdgeInsets.symmetric(vertical: 23),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(),
          _buildMainActionButtons(context),
          _buildQuickAccessSection(context),
          _buildAIPoweredCard(),
          _buildFeaturedDestinations(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        const Text(
          "Welcome to Malaysia! 🇲🇾",
          style: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            "Explore iconic landmarks with AR technology and get instant travel tips from our AI assistant",
            style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMainActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildActionCard(
              icon: FontAwesomeIcons.camera,
              title: "Launch AR",
              subtitle: "Scan landmarks",
              colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
              onTap: () {
                _navigateToPage(context, const ARScannerPage());
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildActionCard(
              icon: FontAwesomeIcons.robot,
              title: "AI Chatbot",
              subtitle: "Ask anything",
              colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
              onTap: () {
                _navigateToPage(context, const RouteSuggestion());
              },
            ),
          ),
        ],
      ),
    );
  }
  

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colors[0], width: 1),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          children: [
            FaIcon(icon, size: 55, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFFFFFEFE), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 23),
          child: Text(
            "Quick Access",
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 13),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: _buildQuickAccessCard(
                  icon: FontAwesomeIcons.hotel,
                  label: "Hotel Booking",
                  colors: [Color(0xFFD32F2F), Color(0xFF8B0000)],
                  onTap: () {
                    _navigateToPage(context, const RouteSuggestion());
                    print('Navigate to Hotel Booking');
                  },
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: _buildQuickAccessCard(
                  icon: FontAwesomeIcons.route,
                  label: "Route Suggestion",
                  colors: [Color(0xFFD32F2F), Color(0xFF8B0000)],
                  onTap: () {
                    _navigateToPage(context, const RouteSuggestion());
                  },
                ),
              ),
              const SizedBox(width: 13),

              Expanded(
                child: _buildQuickAccessCard(
                  icon: FontAwesomeIcons.utensils,
                  label: "Food Explorer",
                  colors: [Color(0xFFD32F2F), Color(0xFF8B0000)],
                  onTap: () {
                    _navigateToPage(context, const RouteSuggestion());
                    print('Navigate to Food Explorer');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String label,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFA51212), width: 1),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colors,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 17),
        child: Column(
          children: [
            FaIcon(icon, size: 23, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIPoweredCard() {
    return Container(
      margin: const EdgeInsets.only(top: 25, left: 24, right: 24),
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFFA51212),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "AI-Powered Experience",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.only(left: 19),
            child: Text(
              "Get personalized recommendations, cultural insights, and instant answers about Malaysian attractions, food, and traditions",
              style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedDestinations(BuildContext context) {
    final destinations = [
      {
        'image': "assets/images/petronas_towers.png",
        'title': "Petronas Twin Towers",
        'maps': "https://maps.app.goo.gl/vC1x3UMcyq8xhdCr7",
        'location': "Kuala Lumpur",
        'description': "The iconic twin skyscrapers in Kuala Lumpur, Malaysia.",
      },
      {
        'image': "assets/images/batu_caves.png",
        'title': "Batu Caves",
        'maps': "https://maps.app.goo.gl/ttVUoK54PRAxa1aJ9",
        'location': "Selangor",
        'description':
            "A limestone hill with caves and temples, famous for the Hindu festival Thaipusam.",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Featured Destinations",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  _navigateToPage(
                    context,
                    AllDestinationsPage(destinations: destinations),
                  );
                },
                child: const Text(
                  "View All",
                  style: TextStyle(color: Color(0xFFA51212), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: List.generate(destinations.length, (index) {
              final dest = destinations[index];
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _navigateToPage(
                        context,
                        DestinationDetailsPage(
                          title: dest['title'] as String,
                          maps: dest['maps'] as String,
                          image: dest['image'] as String,
                          location: dest['location'] as String,
                          locationIcon: '', // No longer needed
                          description: dest['description'] as String,
                        ),
                      );
                    },
                    child: _buildDestinationCard(
                      image: dest['image'] as String,
                      title: dest['title'] as String,
                      location: dest['location'] as String,
                      onTap: () {
                        _navigateToPage(
                          context,
                          DestinationDetailsPage(
                            title: dest['title'] as String,
                            maps: dest['maps'] as String,
                            image: dest['image'] as String,
                            location: dest['location'] as String,
                            locationIcon: '', // No longer needed
                            description: dest['description'] as String,
                          ),
                        );
                      },
                    ),
                  ),
                  if (index != destinations.length - 1)
                    const SizedBox(height: 12),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildDestinationCard({
    required String image,
    required String title,
    required String location,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF1E1E1E),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: Image.asset(
              image,
              width: 95,
              height: 110,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 95,
                  height: 110,
                  color: const Color(0xFF2A2A2A),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Color(0xFF666666),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.locationDot,
                        size: 15,
                        color: Color(0xFFA51212),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: Color(0xFFB3B3B3),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  InkWell(
                    onTap: onTap,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 5,
                      ),
                      child: const Text(
                        "Scan with AR",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            FontAwesomeIcons.house,
            "Home",
            true,
            () {},
          ),
          _buildNavItem(
            FontAwesomeIcons.cameraRetro,
            "AR Scan",
            false,
            () => _navigateToPage(context, const ARScannerPage()),
          ),
          _buildNavItem(
            FontAwesomeIcons.commentDots,
            "Chat AI",
            false,
            () => _navigateToPage(context, const RouteSuggestion()),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isActive
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x4DA51212),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
                gradient: const LinearGradient(
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              icon,
              size: 23,
              color: isActive ? Colors.white : const Color(0xFFB3B3B3),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : const Color(0xFFB3B3B3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}