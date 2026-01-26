import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationDetailsPage extends StatelessWidget {
  final String title;
  final String image;
  final String maps;
  final String location;
  final String locationIcon;
  final String description;

  const DestinationDetailsPage({
    super.key,
    required this.title,
    required this.maps,
    required this.image,
    required this.location,
    required this.locationIcon,
    required this.description,
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
                    const SizedBox(height: 20),
                    if (maps.isNotEmpty) ...[
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA51212),
                          foregroundColor: Colors.white,
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
                        icon: const Icon(Icons.map),
                        label: const Text('Open in Maps'),
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
}
