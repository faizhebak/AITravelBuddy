import 'package:flutter/material.dart';

class DestinationDetailsPage extends StatelessWidget {
  final String title;
  final String image;
  final String location;
  final String locationIcon;
  final String description;

  const DestinationDetailsPage({
    Key? key,
    required this.title,
    required this.image,
    required this.location,
    required this.locationIcon,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA51212),
        title: Text(title),
      ),
      body: Container(
        color: const Color(0xFF000000),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                image,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(locationIcon, width: 22, height: 22),
                        const SizedBox(width: 8),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// yang baruuuu

// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class DestinationDetailsPage extends StatefulWidget {
//   final String title;
//   final String image;
//   final String location;
//   final String locationIcon;
//   final String description;

//   const DestinationDetailsPage({
//     Key? key,
//     required this.title,
//     required this.image,
//     required this.location,
//     required this.locationIcon,
//     required this.description,
//   }) : super(key: key);

//   @override
//   State<DestinationDetailsPage> createState() => _DestinationDetailsPageState();
// }

// class _DestinationDetailsPageState extends State<DestinationDetailsPage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   bool _isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   // Get detailed information based on destination
//   Map<String, dynamic> _getDestinationInfo() {
//     // TODO: Replace with actual data from API or database
//     if (widget.title.contains('Petronas')) {
//       return {
//         'history': 'The Petronas Twin Towers were completed in 1998 and held the title of the world\'s tallest buildings until 2004. Designed by Argentine architect César Pelli, the towers stand at 451.9 meters (1,483 feet) tall with 88 floors each. The design incorporates Islamic geometric patterns, reflecting Malaysia\'s Muslim heritage. The towers were built to house the headquarters of Petronas, Malaysia\'s national petroleum company.',
//         'highlights': [
//           'Skybridge on 41st & 42nd floors',
//           'Observation deck on 86th floor',
//           'KLCC Park at the base',
//           'Suria KLCC shopping mall',
//           'Symphony Lake with fountain shows'
//         ],
//         'visitingHours': 'Tuesday - Sunday: 9:00 AM - 9:00 PM\nMonday: Closed',
//         'ticketPrice': 'Adult: RM 85\nChild (3-12): RM 35\nSenior (55+): RM 45',
//         'bestTimeToVisit': 'Early morning (9-10 AM) or late evening (7-8 PM) to avoid crowds. Sunset visits offer stunning city views.',
//         'nearbyAttractions': [
//           'KLCC Park',
//           'Aquaria KLCC',
//           'Petrosains Science Center',
//           'Suria KLCC Mall'
//         ],
//         'tips': [
//           'Book tickets online in advance to avoid long queues',
//           'Photography is allowed but no tripods',
//           'Dress modestly - covered shoulders and knees',
//           'Allow 1-2 hours for the full experience'
//         ],
//         'googleMapsUrl': 'https://maps.google.com/?q=Petronas+Twin+Towers+Kuala+Lumpur',
//         'latitude': '3.1579',
//         'longitude': '101.7117',
//       };
//     } else if (widget.title.contains('Batu Caves')) {
//       return {
//         'history': 'Batu Caves is a limestone hill containing a series of caves and cave temples, located 13 km north of Kuala Lumpur. The caves are estimated to be 400 million years old. In 1890, American naturalist William Hornaday recorded the caves. The site was promoted as a place of worship by Indian trader K. Thamboosamy Pillai, who installed the murti (statue) of Lord Murugan in 1890. The 140-foot golden statue was completed in 2006.',
//         'highlights': [
//           '272 rainbow-colored steps',
//           '140-foot golden Lord Murugan statue',
//           'Cathedral Cave with Hindu shrines',
//           'Dark Cave conservation site',
//           'Annual Thaipusam festival'
//         ],
//         'visitingHours': 'Daily: 6:00 AM - 9:00 PM\nBest to visit early morning',
//         'ticketPrice': 'Main temple: Free\nDark Cave tour: RM 35-45\nRamayana Cave: RM 5',
//         'bestTimeToVisit': 'Early morning (6-8 AM) to avoid heat and crowds. January/February for Thaipusam festival.',
//         'nearbyAttractions': [
//           'Dark Cave Conservation Site',
//           'Ramayana Cave',
//           'Cave Villa',
//           'Malaysian Batik Centre'
//         ],
//         'tips': [
//           'Wear comfortable shoes for climbing steps',
//           'Watch out for monkeys - don\'t feed them',
//           'Dress modestly - sarongs available for rent',
//           'Bring water and sun protection',
//           'Remove shoes before entering temples'
//         ],
//         'googleMapsUrl': 'https://maps.google.com/?q=Batu+Caves+Selangor',
//         'latitude': '3.2379',
//         'longitude': '101.6840',
//       };
//     } else {
//       return {
//         'history': 'This historic landmark has played a significant role in Malaysia\'s rich cultural heritage. Its architecture and location make it a must-visit destination for tourists and locals alike.',
//         'highlights': [
//           'Stunning architecture',
//           'Cultural significance',
//           'Photo opportunities',
//           'Local heritage site'
//         ],
//         'visitingHours': 'Daily: 9:00 AM - 6:00 PM',
//         'ticketPrice': 'Admission fees may apply',
//         'bestTimeToVisit': 'Weekday mornings for fewer crowds',
//         'nearbyAttractions': ['Other local attractions'],
//         'tips': [
//           'Check opening hours before visiting',
//           'Bring your camera',
//           'Respect local customs'
//         ],
//         'googleMapsUrl': 'https://maps.google.com/?q=${Uri.encodeComponent(widget.title)}+${Uri.encodeComponent(widget.location)}',
//         'latitude': '3.1390',
//         'longitude': '101.6869',
//       };
//     }
//   }

//   Future<void> _openGoogleMaps() async {
//     final info = _getDestinationInfo();
//     final url = Uri.parse(info['googleMapsUrl']);
    
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Could not open Google Maps')),
//         );
//       }
//     }
//   }

//   Future<void> _openDirections() async {
//     final info = _getDestinationInfo();
//     final url = Uri.parse(
//       'https://www.google.com/maps/dir/?api=1&destination=${info['latitude']},${info['longitude']}'
//     );
    
//     if (await canLaunchUrl(url)) {
//       await launchUrl(url, mode: LaunchMode.externalApplication);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final info = _getDestinationInfo();
    
//     return Scaffold(
//       backgroundColor: const Color(0xFF000000),
//       body: CustomScrollView(
//         slivers: [
//           // App Bar with Image
//           SliverAppBar(
//             expandedHeight: 300,
//             pinned: true,
//             backgroundColor: const Color(0xFF121212),
//             leading: IconButton(
//               icon: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.black54,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(Icons.arrow_back, color: Colors.white),
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//             actions: [
//               IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     _isFavorite ? Icons.favorite : Icons.favorite_border,
//                     color: _isFavorite ? Colors.red : Colors.white,
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isFavorite = !_isFavorite;
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
//                       duration: const Duration(seconds: 1),
//                     ),
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black54,
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: const Icon(Icons.share, color: Colors.white),
//                 ),
//                 onPressed: () {
//                   // TODO: Implement share functionality
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Share feature coming soon!')),
//                   );
//                 },
//               ),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   Image.network(
//                     widget.image,
//                     fit: BoxFit.cover,
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.7),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Content
//           SliverToBoxAdapter(
//             child: Container(
//               color: const Color(0xFF000000),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title and Location
//                   Padding(
//                     padding: const EdgeInsets.all(24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.title,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Image.network(
//                               widget.locationIcon,
//                               width: 20,
//                               height: 20,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               widget.location,
//                               style: const TextStyle(
//                                 color: Color(0xFFB3B3B3),
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Action Buttons
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: _buildActionButton(
//                             'Get Directions',
//                             Icons.directions,
//                             () => _openDirections(),
//                             isPrimary: true,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Expanded(
//                           child: _buildActionButton(
//                             'View on Map',
//                             Icons.map,
//                             () => _openGoogleMaps(),
//                             isPrimary: false,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Tab Bar
//                   Container(
//                     decoration: const BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
//                       ),
//                     ),
//                     child: TabBar(
//                       controller: _tabController,
//                       labelColor: const Color(0xFFA51212),
//                       unselectedLabelColor: const Color(0xFFB3B3B3),
//                       indicatorColor: const Color(0xFFA51212),
//                       indicatorWeight: 3,
//                       tabs: const [
//                         Tab(text: 'Overview'),
//                         Tab(text: 'Visitor Info'),
//                         Tab(text: 'Tips'),
//                       ],
//                     ),
//                   ),

//                   // Tab Content
//                   SizedBox(
//                     height: 600,
//                     child: TabBarView(
//                       controller: _tabController,
//                       children: [
//                         _buildOverviewTab(info),
//                         _buildVisitorInfoTab(info),
//                         _buildTipsTab(info),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 32),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(String label, IconData icon, VoidCallback onTap, {required bool isPrimary}) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           gradient: isPrimary
//               ? const LinearGradient(
//                   colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
//                 )
//               : null,
//           color: isPrimary ? null : const Color(0xFF1E1E1E),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isPrimary ? const Color(0xFFA51212) : const Color(0xFF2A2A2A),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, color: Colors.white, size: 20),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 14,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOverviewTab(Map<String, dynamic> info) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle('About'),
//           const SizedBox(height: 12),
//           Text(
//             widget.description,
//             style: const TextStyle(
//               color: Color(0xFFB3B3B3),
//               fontSize: 16,
//               height: 1.6,
//             ),
//           ),
//           const SizedBox(height: 24),
//           _buildSectionTitle('History'),
//           const SizedBox(height: 12),
//           Text(
//             info['history'],
//             style: const TextStyle(
//               color: Color(0xFFB3B3B3),
//               fontSize: 16,
//               height: 1.6,
//             ),
//           ),
//           const SizedBox(height: 24),
//           _buildSectionTitle('Highlights'),
//           const SizedBox(height: 12),
//           ...List.generate(
//             info['highlights'].length,
//             (index) => _buildBulletPoint(info['highlights'][index]),
//           ),
//           const SizedBox(height: 24),
//           _buildSectionTitle('Nearby Attractions'),
//           const SizedBox(height: 12),
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: List.generate(
//               info['nearbyAttractions'].length,
//               (index) => _buildChip(info['nearbyAttractions'][index]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildVisitorInfoTab(Map<String, dynamic> info) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildInfoCard(
//             icon: Icons.access_time,
//             title: 'Opening Hours',
//             content: info['visitingHours'],
//           ),
//           const SizedBox(height: 16),
//           _buildInfoCard(
//             icon: Icons.confirmation_number,
//             title: 'Ticket Prices',
//             content: info['ticketPrice'],
//           ),
//           const SizedBox(height: 16),
//           _buildInfoCard(
//             icon: Icons.wb_sunny,
//             title: 'Best Time to Visit',
//             content: info['bestTimeToVisit'],
//           ),
//           const SizedBox(height: 24),
//           _buildSectionTitle('Getting There'),
//           const SizedBox(height: 12),
//           Text(
//             'Tap "Get Directions" above to navigate from your current location using Google Maps. Public transport options and parking information available on Google Maps.',
//             style: const TextStyle(
//               color: Color(0xFFB3B3B3),
//               fontSize: 14,
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTipsTab(Map<String, dynamic> info) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildSectionTitle('Visitor Tips'),
//           const SizedBox(height: 12),
//           Text(
//             'Make the most of your visit with these helpful tips:',
//             style: const TextStyle(
//               color: Color(0xFFB3B3B3),
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 16),
//           ...List.generate(
//             info['tips'].length,
//             (index) => _buildTipCard(index + 1, info['tips'][index]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Text(
//       title,
//       style: const TextStyle(
//         color: Colors.white,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }

//   Widget _buildBulletPoint(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 8, right: 12),
//             width: 6,
//             height: 6,
//             decoration: const BoxDecoration(
//               color: Color(0xFFA51212),
//               shape: BoxShape.circle,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               text,
//               style: const TextStyle(
//                 color: Color(0xFFB3B3B3),
//                 fontSize: 16,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildChip(String label) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E1E1E),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: Text(
//         label,
//         style: const TextStyle(
//           color: Color(0xFFB3B3B3),
//           fontSize: 14,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard({
//     required IconData icon,
//     required String title,
//     required String content,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E1E1E),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(icon, color: Colors.white, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   content,
//                   style: const TextStyle(
//                     color: Color(0xFFB3B3B3),
//                     fontSize: 14,
//                     height: 1.5,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTipCard(int number, String tip) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1E1E1E),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: const Color(0xFF2A2A2A)),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               gradient: const LinearGradient(
//                 colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
//               ),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Center(
//               child: Text(
//                 '$number',
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               tip,
//               style: const TextStyle(
//                 color: Color(0xFFB3B3B3),
//                 fontSize: 14,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }