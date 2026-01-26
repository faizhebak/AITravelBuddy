import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class ARScannerPage extends StatefulWidget {
  const ARScannerPage({super.key});

  @override
  State<ARScannerPage> createState() => _ARScannerPageState();
}

class _ARScannerPageState extends State<ARScannerPage> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isScanning = false;
  String _scanResult = '';
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    
    if (status.isDenied) {
      _showPermissionDialog();
      return;
    }

    try {
      // Get available cameras
      _cameras = await availableCameras();
      
      if (_cameras == null || _cameras!.isEmpty) {
        _showError('No cameras found on this device');
        return;
      }

      // Initialize the first camera (usually back camera)
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      _showError('Failed to initialize camera: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Camera Permission Required',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Please grant camera permission to use AR scanning feature.',
          style: TextStyle(color: Color(0xFFB3B3B3)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (_isScanning) return;

    setState(() {
      _isScanning = true;
      _showResult = false;
    });

    try {
      // Capture image
      final image = await _cameraController!.takePicture();

      // Simulate AI analysis (Replace with actual ML Kit or API call)
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Replace with actual landmark recognition
      // For now, we'll use mock data
      final result = await _analyzeImage(image.path);

      if (mounted) {
        setState(() {
          _scanResult = result;
          _showResult = true;
          _isScanning = false;
        });

        // Show result dialog
        _showResultDialog(result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
        _showError('Failed to capture image: $e');
      }
    }
  }

  Future<String> _analyzeImage(String imagePath) async {
    // TODO: Implement actual image recognition
    // Options:
    // 1. Use Google ML Kit Image Labeling
    // 2. Use Google Cloud Vision API
    // 3. Use custom ML model
    // 4. Use Claude API with vision

    // Mock landmarks for demo
    final mockLandmarks = [
      'Petronas Twin Towers',
      'Batu Caves',
      'Merdeka Square',
      'KL Tower',
      'Sultan Abdul Samad Building',
    ];

    // Simulate random detection
    return mockLandmarks[DateTime.now().millisecond % mockLandmarks.length];
  }

  void _showResultDialog(String landmarkName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildResultSheet(landmarkName),
    );
  }

  Widget _buildResultSheet(String landmarkName) {
    // Get landmark info
    final info = _getLandmarkInfo(landmarkName);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Success icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Landmark detected
                  const Center(
                    child: Text(
                      'Landmark Detected!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      landmarkName,
                      style: const TextStyle(
                        color: Color(0xFFA51212),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quick info
                  _buildInfoRow(Icons.location_on, info['location']),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.info_outline, info['quickFact']),
                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'Learn More',
                          Icons.book,
                          () {
                            Navigator.pop(context);
                            // TODO: Navigate to destination details
                            print('Navigate to $landmarkName details');
                          },
                          isPrimary: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          'Ask AI',
                          Icons.chat,
                          () {
                            Navigator.pop(context);
                            // TODO: Navigate to chatbot with context
                            print('Open chatbot about $landmarkName');
                          },
                          isPrimary: false,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _buildActionButton(
                      'Scan Again',
                      Icons.camera_alt,
                      () => Navigator.pop(context),
                      isPrimary: false,
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

  Map<String, String> _getLandmarkInfo(String name) {
    // Mock data - replace with actual database
    final landmarks = {
      'Petronas Twin Towers': {
        'location': 'Kuala Lumpur City Centre',
        'quickFact': '451.9m tall, completed in 1998',
      },
      'Batu Caves': {
        'location': 'Gombak, Selangor',
        'quickFact': '400 million years old limestone caves',
      },
      'Merdeka Square': {
        'location': 'Kuala Lumpur',
        'quickFact': 'Site of Malaysian independence declaration',
      },
      'KL Tower': {
        'location': 'Kuala Lumpur',
        'quickFact': '421m tall telecommunications tower',
      },
      'Sultan Abdul Samad Building': {
        'location': 'Jalan Raja, Kuala Lumpur',
        'quickFact': 'Built in 1897, Moorish architecture',
      },
    };

    return landmarks[name] ?? {
      'location': 'Malaysia',
      'quickFact': 'Historic landmark',
    };
  }

  // Widget _buildInfoRow(IconData icon, String text) {
  Widget _buildInfoRow(IconData icon, String? text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFA51212), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            // text,
            text ?? '-',
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap, {required bool isPrimary}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(colors: [Color(0xFFA51212), Color(0xFFD32F2F)])
              : null,
          color: isPrimary ? null : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary ? const Color(0xFFA51212) : const Color(0xFF2A2A2A),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          if (_isInitialized && _cameraController != null)
            SizedBox.expand(
              child: CameraPreview(_cameraController!),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFA51212),
              ),
            ),

          // Overlay UI
          SafeArea(
            child: Column(
              children: [
                // Top bar
                _buildTopBar(),
                
                const Spacer(),

                // Scanning indicator
                if (_isScanning) _buildScanningIndicator(),

                // Bottom controls
                _buildBottomControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  'Point camera at landmark',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance layout
        ],
      ),
    );
  }

  Widget _buildScanningIndicator() {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFA51212),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Analyzing landmark...',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery button
          _buildControlButton(
            icon: Icons.photo_library,
            onTap: () {
              // TODO: Implement gallery picker
              print('Open gallery');
            },
          ),

          // Capture button
          GestureDetector(
            onTap: _captureAndAnalyze,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFA51212), Color(0xFFD32F2F)],
                  ),
                ),
                child: _isScanning
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.camera_alt, color: Colors.white, size: 40),
              ),
            ),
          ),

          // Flash button
          _buildControlButton(
            icon: Icons.flash_off,
            onTap: () {
              // TODO: Implement flash toggle
              print('Toggle flash');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}