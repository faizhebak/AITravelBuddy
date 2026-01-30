import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationDetailsPage extends StatelessWidget {
  final String title;
  final String image;
  final String maps;
  final String location;
  final String locationIcon;
  final String description;
  final String? highlights;
  final String? entryFee;
  final String? openingHours;

  const DestinationDetailsPage({
    super.key,
    required this.title,
    required this.maps,
    required this.image,
    required this.location,
    required this.locationIcon,
    required this.description,
    this.highlights,
    this.entryFee,
    this.openingHours,
  });

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
              image.startsWith('http')
                  ? Image.network(
                      image,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      image,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFA51212),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Color(0xFFB3B3B3),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Description
                    const Text(
                      'About',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Color(0xFFB3B3B3),
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                    
                    // Highlights
                    if (highlights != null && highlights!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text(
                        'Highlights',
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFFA51212),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                highlights!,
                                style: const TextStyle(
                                  color: Color(0xFFE0E0E0),
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Info Cards Row
                    if (entryFee != null || openingHours != null) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          if (entryFee != null)
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.payment,
                                title: 'Entry Fee',
                                content: entryFee!,
                              ),
                            ),
                          if (entryFee != null && openingHours != null)
                            const SizedBox(width: 12),
                          if (openingHours != null)
                            Expanded(
                              child: _buildInfoCard(
                                icon: Icons.access_time,
                                title: 'Hours',
                                content: openingHours!,
                              ),
                            ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    
                    // Maps Button
                    if (maps.isNotEmpty) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA51212),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            final uri = Uri.tryParse(maps);
                            if (uri == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Invalid map URL.')),
                              );
                              return;
                            }
                            try {
                              if (await canLaunchUrl(uri)) {
                                await launchUrl(uri, mode: LaunchMode.externalApplication);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Could not open maps.')),
                                );
                              }
                            } catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to open maps.')),
                              );
                            }
                          },
                          icon: const Icon(Icons.map, size: 22),
                          label: const Text(
                            'Open in Google Maps',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFFA51212),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}