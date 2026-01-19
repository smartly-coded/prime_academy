import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Main settings bottom sheet with Playback and Accessibility options
void showMainSettingsSheet({
  required BuildContext context,
  required YoutubePlayerController controller,
  required bool isLooping,
  required Function(bool) onLoopChanged,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Playback Option
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showPlaybackSheet(
                  context: context,
                  controller: controller,
                  isLooping: isLooping,
                  onLoopChanged: onLoopChanged,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.play_circle_outline, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Playback',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Accessibility Option
            InkWell(
              onTap: () {
                Navigator.pop(context);
                showAccessibilitySheet(context: context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.accessibility_new, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Accessibility',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Playback bottom sheet with Loop and Speed controls
void showPlaybackSheet({
  required BuildContext context,
  required YoutubePlayerController controller,
  required bool isLooping,
  required Function(bool) onLoopChanged,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: _PlaybackSheet(
        controller: controller,
        isLooping: isLooping,
        onLoopChanged: onLoopChanged,
      ),
    ),
  );
}

/// Accessibility bottom sheet with Announcements and Keyboard Animations
void showAccessibilitySheet({required BuildContext context}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => const Padding(
      padding: EdgeInsets.all(20.0),
      child: _AccessibilitySheet(),
    ),
  );
}

// Playback Sheet Widget
class _PlaybackSheet extends StatefulWidget {
  final YoutubePlayerController controller;
  final bool isLooping;
  final Function(bool) onLoopChanged;

  const _PlaybackSheet({
    required this.controller,
    required this.isLooping,
    required this.onLoopChanged,
  });

  @override
  State<_PlaybackSheet> createState() => _PlaybackSheetState();
}

class _PlaybackSheetState extends State<_PlaybackSheet> {
  double _currentSpeed = 1.0;
  late bool _localIsLooping;

  @override
  void initState() {
    super.initState();
    _currentSpeed = widget.controller.value.playbackRate;
    _localIsLooping = widget.isLooping;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'Playback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Loop Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Loop', style: TextStyle(fontSize: 16)),
              Switch(
                value: _localIsLooping,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _localIsLooping = value;
                  });
                  widget.onLoopChanged(value);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Speed Controls
        const Text(
          'Speed',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          '${_currentSpeed.toStringAsFixed(2)}x',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.fast_rewind),
              onPressed: () {
                setState(() {
                  _currentSpeed = (_currentSpeed - 0.25).clamp(0.25, 2.0);
                });
                widget.controller.setPlaybackRate(_currentSpeed);
              },
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: const Color(0xFF1E3A8A),
                  inactiveTrackColor: Colors.grey[300],
                  thumbColor: const Color(0xFF1E3A8A),
                  overlayColor: const Color(0xFF1E3A8A).withOpacity(0.2),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: _currentSpeed,
                  min: 0.25,
                  max: 2.0,
                  divisions: 7,
                  onChanged: (value) {
                    setState(() {
                      _currentSpeed = value;
                    });
                    widget.controller.setPlaybackRate(value);
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.fast_forward),
              onPressed: () {
                setState(() {
                  _currentSpeed = (_currentSpeed + 0.25).clamp(0.25, 2.0);
                });
                widget.controller.setPlaybackRate(_currentSpeed);
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Accessibility Sheet Widget
class _AccessibilitySheet extends StatefulWidget {
  const _AccessibilitySheet();

  @override
  State<_AccessibilitySheet> createState() => _AccessibilitySheetState();
}

class _AccessibilitySheetState extends State<_AccessibilitySheet> {
  bool _announcements = true;
  bool _keyboardAnimations = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            const Text(
              'Accessibility',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Announcements Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Announcements',
                style: TextStyle(fontSize: 16),
              ),
              Switch(
                value: _announcements,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _announcements = value;
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Keyboard Animations Toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Keyboard Animations',
                style: TextStyle(fontSize: 16),
              ),
              Switch(
                value: _keyboardAnimations,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    _keyboardAnimations = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}