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
        'description': "Standing at 451.9 meters tall, the Petronas Twin Towers were the world's tallest buildings from 1998 to 2004. These iconic 88-story twin skyscrapers are connected by a sky bridge on the 41st and 42nd floors, offering breathtaking views of the city. The towers house the Suria KLCC shopping mall, Petrosains science discovery center, and the KLCC Park. Visit the observation deck on the 86th floor for panoramic views. Best time to visit is during sunset to see the towers light up. Entry tickets should be booked in advance online.",
        'highlights': "Sky Bridge • Observation Deck • KLCC Park • Suria KLCC Mall",
        'entryFee': "RM 85 (Adult) • RM 35 (Child)",
        'openingHours': "9:00 AM - 9:00 PM (Closed on Mondays)",
      },
      {
        'image': "assets/images/batu_caves.png",
        'title': "Batu Caves",
        'maps': "https://maps.app.goo.gl/ttVUoK54PRAxa1aJ9",
        'location': "Selangor",
        'description': "A spectacular limestone hill featuring a series of caves and cave temples, Batu Caves is one of Malaysia's most popular Hindu shrines. The 42.7-meter tall golden statue of Lord Murugan stands guard at the entrance, making it the tallest statue of a Hindu deity in Malaysia. Climb the iconic 272 colorful steps to reach the main Temple Cave, a cathedral-like cave adorned with Hindu shrines. The cave system is over 400 million years old and is also home to a large colony of fruit bats. During the annual Thaipusam festival, over 1.5 million devotees and tourists visit. Beware of the cheeky monkeys! Dress modestly as this is a religious site.",
        'highlights': "272 Rainbow Steps • Lord Murugan Statue • Cathedral Cave • Dark Cave Tour",
        'entryFee': "Free (Temple) • RM 35-45 (Dark Cave Tour)",
        'openingHours': "6:00 AM - 9:00 PM (Daily)",
      },
      {
        'image': "assets/images/langkawi_sky_bridge.png",
        'title': "Langkawi Sky Bridge",
        'maps': "https://maps.app.goo.gl/AbCdEfGhIjKlMnOp1",
        'location': "Langkawi, Kedah",
        'description': "This architectural marvel is a 125-meter curved pedestrian bridge suspended 660 meters above sea level on Gunung Mat Cincang. The Sky Bridge offers 360-degree panoramic views of the Andaman Sea and surrounding rainforests. Access is via the SkyCab cable car, one of the steepest in the world. The bridge has two viewing platforms and a glass floor section for thrill-seekers. On clear days, you can see southern Thailand. The journey includes stops at Middle Station and Top Station, each offering unique viewpoints. Bring a light jacket as it can be cool at the summit.",
        'highlights': "Cable Car Ride • Glass Floor Walkway • Oriental Village • 3D Art Museum",
        'entryFee': "RM 55 (Cable Car + Sky Bridge)",
        'openingHours': "9:30 AM - 6:00 PM (Daily)",
      },
      {
        'image': "assets/images/george_town.png",
        'title': "George Town Heritage",
        'maps': "https://maps.app.goo.gl/QrStUvWxYzAbCdEf2",
        'location': "Penang",
        'description': "A UNESCO World Heritage Site since 2008, George Town is a living museum showcasing a unique blend of Asian and European influences. The historic city features over 12,000 heritage buildings with distinctive Straits Chinese and colonial architecture. Famous for its vibrant street art murals by Ernest Zacharevic, including the iconic 'Little Children on a Bicycle'. Explore clan jetties, traditional shophouses, and historic temples. Don't miss the Blue Mansion (Cheong Fatt Tze Mansion), Armenian Street, and Little India. George Town is also Malaysia's food capital - try char kway teow, laksa, and rojak. Best explored on foot or by trishaw.",
        'highlights': "Street Art Murals • Clan Jetties • Blue Mansion • Street Food • Night Markets",
        'entryFee': "Free (Walking around) • RM 25 (Blue Mansion Tour)",
        'openingHours': "Open 24/7 (Heritage streets)",
      },
      {
        'image': "assets/images/cameron_highlands.png",
        'title': "Cameron Highlands",
        'maps': "https://maps.app.goo.gl/GhIjKlMnOpQrStUv3",
        'location': "Pahang",
        'description': "Malaysia's largest hill station resort, perched at 1,500 meters above sea level with temperatures ranging from 15°C to 25°C year-round. Famous for its sprawling tea plantations, particularly the BOH Tea Plantation established in 1929. Explore strawberry farms where you can pick your own berries, visit butterfly gardens, and tour rose valleys. The mossy forests and jungle trails offer excellent hiking opportunities. Try local specialties like steamboat, scones with strawberry jam, and fresh highland vegetables. The region produces 70% of Malaysia's vegetables. Best visited during weekdays to avoid crowds. Bring a sweater!",
        'highlights': "BOH Tea Plantation • Strawberry Farms • Mossy Forest • Night Market • Butterfly Garden",
        'entryFee': "Free (Most attractions) • RM 5-15 (Farm entries)",
        'openingHours': "Varies by attraction",
      },
      {
        'image': "assets/images/malacca_river.png",
        'title': "Malacca Historic City",
        'maps': "https://maps.app.goo.gl/WxYzAbCdEfGhIjKl4",
        'location': "Malacca",
        'description': "Another UNESCO World Heritage Site, Malacca (Melaka) was the center of Malay Sultanate and European colonization. Walk through 600 years of history visiting A Famosa fortress (1511), St. Paul's Hill, Dutch Square with its iconic red buildings, and Jonker Street. Take a river cruise along the Malacca River to see vibrant street art and historic buildings. Visit Cheng Hoon Teng Temple, Malaysia's oldest functioning Chinese temple (1673). The city is a melting pot of Malay, Chinese, Indian, and European cultures. Try authentic Nyonya cuisine and visit the night market on Jonker Street (weekends). The Stadthuys is one of the oldest Dutch buildings in the East.",
        'highlights': "A Famosa • Jonker Street • River Cruise • Dutch Square • Nyonya Food",
        'entryFee': "Free (Walking) • RM 20-30 (River Cruise)",
        'openingHours': "Open 24/7 (Historic areas)",
      },
      {
        'image': "assets/images/perhentian_islands.png",
        'title': "Perhentian Islands",
        'maps': "https://maps.app.goo.gl/MnOpQrStUvWxYzAb5",
        'location': "Terengganu",
        'description': "A tropical paradise featuring crystal-clear turquoise waters, pristine white sand beaches, and vibrant coral reefs. The islands comprise Perhentian Besar (Big) and Perhentian Kecil (Small). Perfect for snorkeling and diving - spot sea turtles, blacktip reef sharks, and colorful tropical fish. Take a jungle trek to secluded beaches, enjoy fresh seafood by the beach, or simply relax in a hammock. The waters are home to over 300 species of fish and vibrant coral gardens. No cars allowed - transportation is by boat only, preserving the islands' tranquil atmosphere. Best visited between March and October. Book accommodations in advance during peak season.",
        'highlights': "Snorkeling • Diving • Turtle Beach • Jungle Trekking • Sunset Views",
        'entryFee': "RM 30 (Marine Park Conservation Fee)",
        'openingHours': "Open seasonally (Closed Nov-Feb)",
      },
      {
        'image': "assets/images/kl_tower.png",
        'title': "KL Tower (Menara KL)",
        'maps': "https://maps.app.goo.gl/CdEfGhIjKlMnOpQr6",
        'location': "Kuala Lumpur",
        'description': "Standing at 421 meters, KL Tower is the 7th tallest freestanding tower in the world and offers the best views of Kuala Lumpur's skyline, including the Petronas Towers. The Observation Deck at 276 meters provides 360-degree panoramic views. For adrenaline junkies, try the Sky Box - a glass-floored viewing platform extending beyond the edge. Dine at the revolving Atmosphere 360 restaurant while enjoying the cityscape. The tower base sits on Bukit Nanas, KL's oldest forest reserve with nature trails. Cultural performances are held regularly at the tower's base. Visit during blue hour (just after sunset) for the best photography. Book tickets online for discounts.",
        'highlights': "Sky Box • Observation Deck • Revolving Restaurant • Forest Reserve • Cultural Shows",
        'entryFee': "RM 52 (Observation Deck) • RM 105 (Sky Deck + Sky Box)",
        'openingHours': "9:00 AM - 10:00 PM (Daily)",
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
                          locationIcon: '',
                          description: dest['description'] as String,
                          highlights: dest['highlights'] as String?,
                          entryFee: dest['entryFee'] as String?,
                          openingHours: dest['openingHours'] as String?,
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