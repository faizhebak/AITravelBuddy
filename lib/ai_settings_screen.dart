// From github desktop from laptop acad
import 'package:flutter/material.dart';

// Import the models file (chatbot_models.dart)
import 'chatbot_models.dart';
// For this demo, assume AISettings class is available

class AISettingsScreen extends StatefulWidget {
  final AISettings settings;
  final Function(AISettings) onSave;

  const AISettingsScreen({
    super.key,
    required this.settings,
    required this.onSave,
  });

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  late AISettings _currentSettings;

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Text('AI Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(_currentSettings);
              Navigator.pop(context);
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFA51212),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAvatarSelector(),
          const SizedBox(height: 24),
          _buildHumorLevelSlider(),
          const SizedBox(height: 24),
          _buildAnswerLengthSelector(),
          // const SizedBox(height: 24),
          // _buildProfessionalismSelector(),
          const SizedBox(height: 24),
          _buildRegionalFocusSelector(),
          // const SizedBox(height: 24),
          // _buildSpecialInterests(),
          // const SizedBox(height: 24),
          // _buildLanguageSelector(),
          const SizedBox(height: 32),
          _buildResetButton(),
          const SizedBox(height: 16),
          _buildPreviewCard(),
        ],
      ),
    );
  }

  Widget _buildAvatarSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎨 Avatar Appearance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildAvatarOption('traditional', '👔', 'Traditional'),
              _buildAvatarOption('modern', '👕', 'Modern'),
              _buildAvatarOption('guide', '🎽', 'Tour Guide'),
              _buildAvatarOption('futuristic', '🤖', 'AI Look'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarOption(String value, String emoji, String label) {
    final isSelected = _currentSettings.avatarOutfit == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSettings = _currentSettings.copyWith(avatarOutfit: value);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                )
              : null,
          color: isSelected ? null : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA51212)
                : const Color(0xFF2A2A2A),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFB3B3B3),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHumorLevelSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '😄 Humor Level',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('😐', style: TextStyle(fontSize: 24)),
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFA51212),
                  inactiveTrackColor: const Color(0xFF2A2A2A),
                  thumbColor: const Color(0xFFD32F2F),
                  overlayColor: const Color(0x40A51212),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: _currentSettings.humorLevel.toDouble(),
                  min: 1,
                  max: 4,
                  divisions: 3,
                  onChanged: (value) {
                    setState(() {
                      _currentSettings = _currentSettings.copyWith(
                        humorLevel: value.toInt(),
                      );
                    });
                  },
                ),
              ),
            ),
            const Text('🤩', style: TextStyle(fontSize: 24)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Expanded(child: Center(child: _buildLabel('Serious'))),
              Expanded(child: Center(child: _buildLabel('Neutral'))),
              Expanded(child: Center(child: _buildLabel('Light'))),
              Expanded(child: Center(child: _buildLabel('Fun'))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerLengthSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📏 Answer Length',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildRadioOption('short', 'Short', '1-2 sentences'),
        _buildRadioOption('medium', 'Medium', 'Paragraph (recommended)'),
        _buildRadioOption('detailed', 'Detailed', 'Comprehensive explanation'),
      ],
    );
  }

  Widget _buildRadioOption(String value, String title, String subtitle) {
    final isSelected = _currentSettings.answerLength == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSettings = _currentSettings.copyWith(answerLength: value);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA51212)
                : const Color(0xFF2A2A2A),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA51212)
                      : const Color(0xFF2A2A2A),
                  width: 2,
                ),
                color: isSelected
                    ? const Color(0xFFA51212)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.circle, size: 12, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFFB3B3B3),
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalismSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💼 Professionalism',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSettings.professionalism,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: const [
                DropdownMenuItem(
                  value: 'casual',
                  child: Text('👕 Casual Traveler Guide'),
                ),
                DropdownMenuItem(
                  value: 'friendly',
                  child: Text('🎽 Friendly Tour Guide'),
                ),
                DropdownMenuItem(
                  value: 'professional',
                  child: Text('💼 Professional Expert'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSettings = _currentSettings.copyWith(
                      professionalism: value,
                    );
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionalFocusSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌍 Regional Focus',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSettings.regionalFocus,
              isExpanded: true,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: const [
                DropdownMenuItem(
                  value: 'All Malaysia',
                  child: Text('All Malaysia'),
                ),
                DropdownMenuItem(
                  value: 'Kuala Lumpur',
                  child: Text('Kuala Lumpur'),
                ),
                DropdownMenuItem(value: 'Johor', child: Text('Johor')),
                DropdownMenuItem(value: 'Kedah', child: Text('Kedah')),
                DropdownMenuItem(value: 'Kelantan', child: Text('Kelantan')),
                DropdownMenuItem(value: 'Melaka', child: Text('Melaka')),
                DropdownMenuItem(
                  value: 'Negeri Sembilan',
                  child: Text('Negeri Sembilan'),
                ),
                DropdownMenuItem(value: 'Pahang', child: Text('Pahang')),
                DropdownMenuItem(value: 'Perak', child: Text('Perak')),
                DropdownMenuItem(value: 'Perlis', child: Text('Perlis')),
                DropdownMenuItem(value: 'Penang', child: Text('Penang')),
                DropdownMenuItem(value: 'Sabah', child: Text('Sabah')),
                DropdownMenuItem(value: 'Sarawak', child: Text('Sarawak')),
                DropdownMenuItem(value: 'Selangor', child: Text('Selangor')),
                DropdownMenuItem(
                  value: 'Terengganu',
                  child: Text('Terengganu'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _currentSettings = _currentSettings.copyWith(
                      regionalFocus: value,
                    );
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildSpecialInterests() {
  //   final interests = [
  //     'food',
  //     'culture',
  //     'shopping',
  //     'nightlife',
  //     'adventure',
  //     'history',
  //   ];

  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  // const Text(
  //   '🎯 Special Interests',
  //   style: TextStyle(
  //     color: Colors.white,
  //     fontSize: 18,
  //     fontWeight: FontWeight.bold,
  //   ),
  // ),
  //       const SizedBox(height: 16),
  //       Wrap(
  //         spacing: 8,
  //         runSpacing: 8,
  //         children: interests.map((interest) {
  //           final isSelected = _currentSettings.specialInterests.contains(
  //             interest,
  //           );
  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 if (isSelected) {
  //                   _currentSettings = _currentSettings.copyWith(
  //                     specialInterests: List.from(
  //                       _currentSettings.specialInterests,
  //                     )..remove(interest),
  //                   );
  //                 } else {
  //                   _currentSettings = _currentSettings.copyWith(
  //                     specialInterests: List.from(
  //                       _currentSettings.specialInterests,
  //                     )..add(interest),
  //                   );
  //                 }
  //               });
  //             },
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 16,
  //                 vertical: 10,
  //               ),
  //               decoration: BoxDecoration(
  //                 gradient: isSelected
  //                     ? const LinearGradient(
  //                         colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
  //                       )
  //                     : null,
  //                 color: isSelected ? null : const Color(0xFF1E1E1E),
  //                 borderRadius: BorderRadius.circular(20),
  //                 border: Border.all(
  //                   color: isSelected
  //                       ? const Color(0xFFA51212)
  //                       : const Color(0xFF2A2A2A),
  //                 ),
  //               ),
  //               child: Row(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   if (isSelected)
  //                     const Icon(Icons.check, size: 16, color: Colors.white),
  //                   if (isSelected) const SizedBox(width: 4),
  //                   Text(
  //                     interest.capitalize(),
  //                     style: TextStyle(
  //                       color: isSelected
  //                           ? Colors.white
  //                           : const Color(0xFFB3B3B3),
  //                       fontWeight: isSelected
  //                           ? FontWeight.bold
  //                           : FontWeight.normal,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }).toList(),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildLanguageSelector() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         '🗣️ Language Preference',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Row(
  //         children: [
  //           Expanded(child: _buildLanguageChip('en', 'English', '🇬🇧')),
  //           const SizedBox(width: 8),
  //           Expanded(child: _buildLanguageChip('ms', 'Bahasa', '🇲🇾')),
  //           const SizedBox(width: 8),
  //           Expanded(child: _buildLanguageChip('zh', '中文', '🇨🇳')),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  Widget _buildLanguageChip(String code, String label, String flag) {
    final isSelected = _currentSettings.language == code;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentSettings = _currentSettings.copyWith(language: code);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                )
              : null,
          color: isSelected ? null : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFA51212)
                : const Color(0xFF2A2A2A),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFB3B3B3),
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetButton() {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _currentSettings = AISettings.defaultSettings();
        });
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF2A2A2A)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Reset to Default Settings',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.preview, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Preview',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getPreviewText(),
            style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
          ),
        ],
      ),
    );
  }

  String _getPreviewText() {
    if (_currentSettings.humorLevel == 1) {
      return "Petronas Twin Towers, completed in 1998, stands at 451.9 meters. The towers feature Islamic geometric patterns.";
    } else if (_currentSettings.humorLevel == 4) {
      return "OMG the Petronas Towers!! 🤩✨ They're like Malaysia's version of Eiffel Tower but DOUBLED! 🏢🏢 And yes, you can walk on that skybridge! 😱☁️";
    } else {
      return "The Petronas Twin Towers are absolutely stunning! 🏙️ Built in 1998, they were the world's tallest buildings until 2004. The Islamic-inspired design is really something special.";
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Color(0xFFB3B3B3), fontSize: 10),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
