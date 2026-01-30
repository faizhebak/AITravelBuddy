import 'package:flutter/material.dart';
import 'destination_details_page.dart';

class AllDestinationsPage extends StatelessWidget {
  final List<Map<String, Object>> destinations;
  const AllDestinationsPage({super.key, required this.destinations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA51212),
        title: const Text('All Destinations'),
      ),
      body: Container(
        color: const Color(0xFF000000),
        child: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: destinations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final dest = destinations[index];
            final imagePath = dest['image'] as String;
            
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DestinationDetailsPage(
                      title: dest['title'] as String,
                      maps: dest['maps'] as String,
                      image: imagePath,
                      location: dest['location'] as String,
                      locationIcon: dest['locationIcon'] as String? ?? '',
                      description: dest['description'] as String,
                    ),
                  ),
                );
              },
              child: Container(
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
                      child: imagePath.startsWith('http')
                          ? Image.network(
                              imagePath,
                              width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              imagePath,
                              width: 95,
                              height: 95,
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
                              dest['title'] as String,
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                if ((dest['locationIcon'] as String?)?.isNotEmpty ?? false)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: (dest['locationIcon'] as String).startsWith('http')
                                        ? Image.network(
                                            dest['locationIcon'] as String,
                                            width: 15,
                                            height: 15,
                                            fit: BoxFit.contain,
                                          )
                                        : Image.asset(
                                            dest['locationIcon'] as String,
                                            width: 15,
                                            height: 15,
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                Text(
                                  dest['location'] as String,
                                  style: const TextStyle(
                                    color: Color(0xFFB3B3B3),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}