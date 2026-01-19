import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_academy/core/services/unified_sse_service.dart';
import 'package:prime_academy/features/Notification/logic/notification_cubit.dart';
import 'package:prime_academy/features/authScreen/data/models/login_response.dart';
import 'package:prime_academy/presentation/Notification/notification_screen.dart';

class AnimatedNotificationBell extends StatefulWidget {
  final LoginResponse user;

  const AnimatedNotificationBell({
    super.key,
    required this.user,
  });

  @override
  State<AnimatedNotificationBell> createState() => _AnimatedNotificationBellState();
}

class _AnimatedNotificationBellState extends State<AnimatedNotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _previousHasUnread = false;
  StreamSubscription<bool>? _notificationSubscription;
  final UnifiedSSEService _sseService = UnifiedSSEService();

  @override
  void initState() {
    super.initState();
    
    // Setup animation controller for bell ringing (shake effect)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Create a shake animation that goes left-right-left-right-center
    _animation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.12, end: -0.12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    // 🔔 Listen to notification stream from SSE service
    _notificationSubscription = _sseService.notificationStream.listen((_) {
      _triggerAnimation();
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _triggerAnimation() async {
    if (_animationController.isAnimating) return;

    // Play notification sound
    try {
      await SystemSound.play(SystemSoundType.alert);
    } catch (e) {
      print('Error playing sound: $e');
    }

    // Start animation from beginning and let it complete
    _animationController.reset();
    await _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {
        // Trigger animation when new unread notification arrives
        if (state is NotificationLoaded) {
          bool hasUnread = state.notifications.any((n) => n.isRead == false);
          
          // If changed from no unread to has unread, animate
          if (!_previousHasUnread && hasUnread) {
            _triggerAnimation();
          }
          
          _previousHasUnread = hasUnread;
        }
      },
      builder: (context, state) {
        bool hasUnread = false;

        if (state is NotificationLoaded) {
          hasUnread = state.notifications.any((n) => n.isRead == false);
        }

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(-1, 1),
                        radius: 1.5,
                        colors: [
                          Color(0xFFFF9933),
                          Color(0xFF450486),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF222633),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9999),
                              onTap: () {
                                showNotificationsDialog(context, widget.user);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Simple red dot for unread notifications (matching website)
                  if (hasUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF5757),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}