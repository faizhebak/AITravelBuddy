import 'package:flutter/material.dart';
import 'route_suggestion.dart';
import 'all_destinations_page.dart';
import 'destination_details_page.dart';

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFF000000),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        _buildMainContent(context),
                        _buildBottomNavigation(context),
                      ],
                    ),
                  ),
                ),
              ),
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
      margin: const EdgeInsets.only(bottom: 80),
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
              icon:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/ey1o4os6_expires_30_days.png",
              title: "Launch AR",
              subtitle: "Scan landmarks",
              colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
              onTap: () {
                print('Navigate to AR Scanner');
              },
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: _buildActionCard(
              icon:
                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/bh6ra67r_expires_30_days.png",
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
    required String icon,
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
            Image.network(icon, width: 55, height: 55, fit: BoxFit.contain),
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
                  icon:
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/xsenwe3m_expires_30_days.png",
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
                  icon:
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/k9ap9bzy_expires_30_days.png",
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
                  icon:
                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/uadgyttp_expires_30_days.png",
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
    required String icon,
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
            Image.network(icon, width: 23, height: 23, fit: BoxFit.contain),
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
              Image.network(
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/dj9004yd_expires_30_days.png",
                width: 7,
                height: 7,
                fit: BoxFit.contain,
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
        'image':
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/rl48p2ix_expires_30_days.png",
        'title': "Petronas Twin Towers",
        'maps' : "https://maps.app.goo.gl/vC1x3UMcyq8xhdCr7",
        'location': "Kuala Lumpur",
        'locationIcon':
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/l6hfg72q_expires_30_days.png",
        'description': "The iconic twin skyscrapers in Kuala Lumpur, Malaysia.",
      },
      {
        'image':
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/bvg8eil6_expires_30_days.png",
        'title': "Batu Caves",
        'maps' : "https://maps.app.goo.gl/ttVUoK54PRAxa1aJ9",
        'location': "Selangor",
        'locationIcon':
            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/ch4tsc0k_expires_30_days.png",
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
                          locationIcon: dest['locationIcon'] as String,
                          description: dest['description'] as String,
                        ),
                      );
                    },
                    child: _buildDestinationCard(
                      image: dest['image'] as String,
                      title: dest['title'] as String,
                      location: dest['location'] as String,
                      locationIcon: dest['locationIcon'] as String,
                      onTap: () {
                        _navigateToPage(
                          context,
                          DestinationDetailsPage(
                            title: dest['title'] as String,
                            maps: dest['maps'] as String,
                            image: dest['image'] as String,
                            location: dest['location'] as String,
                            locationIcon: dest['locationIcon'] as String,
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
    required String locationIcon,
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
            child: Image.network(
              image,
              width: 95,
              height: 110,
              fit: BoxFit.cover,
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
                      Image.network(
                        locationIcon,
                        width: 15,
                        height: 15,
                        fit: BoxFit.contain,
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

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        boxShadow: [
          BoxShadow(
            color: const Color(0x40000000),
            blurRadius: 50,
            offset: const Offset(0, -25),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon:
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/rcl0gtkr_expires_30_days.png",
            label: "Home",
            isActive: true,
            onTap: () {},
          ),

          _buildNavItem(
            icon:
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/k9kjfm62_expires_30_days.png",
            label: "AR Scan",
            isActive: false,
            onTap: () {
              print('Navigate to AR Scan');
            },
          ),

          _buildNavItem(
            icon:
                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/kZ2ICKDiv2/zsxbv0wr_expires_30_days.png",
            label: "Chat AI",
            isActive: false,
            onTap: () {
              _navigateToPage(context, const RouteSuggestion());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                ),
              )
            : null,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(icon, width: 23, height: 23, fit: BoxFit.contain),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFFB3B3B3),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
