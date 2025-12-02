import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class YouTubeWebViewPlayer extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final VoidCallback? onReady;
  final VoidCallback? onEnded;
  final Function(int)? onTimeUpdate;

  const YouTubeWebViewPlayer({
    Key? key,
    required this.videoId,
    this.autoPlay = true,
    this.onReady,
    this.onEnded,
    this.onTimeUpdate,
  }) : super(key: key);

  @override
  State<YouTubeWebViewPlayer> createState() => YouTubeWebViewPlayerState();
}

class YouTubeWebViewPlayerState extends State<YouTubeWebViewPlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;
    
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'VideoEvents',
        onMessageReceived: (JavaScriptMessage message) {
          _handleVideoEvents(message.message);
        },
      )
      ..loadRequest(Uri.parse(_buildHtmlContent()));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController).setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  String _buildHtmlContent() {
    final autoplayParam = widget.autoPlay ? '1' : '0';
    final origin = Platform.isIOS ? 'https://primeacademy.education' : 'https://localhost';
    
    // ✅ ALL FLAGS FROM YOUR IFRAME - EXACT MATCH
    final iframeSrc = 'https://www.youtube-nocookie.com/embed/${widget.videoId}'
        '?rel=0'                          // No related videos
        '&autoplay=$autoplayParam'        // Auto play control
        '&cc_lang_pref=ar'                // Arabic captions preference
        '&cc_load_policy=undefined'       // ✅ NO CAPTIONS WATERMARK
        '&color=red'                      // Progress bar color
        '&controls=0'                     // ✅ HIDE YOUTUBE CONTROLS (removes watermark)
        '&disablekb=1'                    // Disable keyboard controls
        '&enablejsapi=1'                  // Enable JavaScript API
        '&fs=1'                           // Allow fullscreen
        '&hl=ar'                          // Arabic interface
        '&iv_load_policy=3'               // Hide video annotations
        '&mute=0'                         // Not muted
// primeacademy.education
// Prime Academy

'&playsinline=1'                  // Play inline on iOS
        '&origin=${Uri.encodeComponent(origin)}'; // Required for API
    
    return Uri.dataFromString(
      '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <style>
            * {
              margin: 0;
              padding: 0;
              box-sizing: border-box;
            }
            body, html {
              width: 100%;
              height: 100%;
              background-color: #000;
              overflow: hidden;
            }
            .video-container {
              position: relative;
              width: 100%;
              height: 100%;
            }
            iframe.vds-youtube {
              position: absolute;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              border: none;
            }
          </style>
        </head>
        <body>
          <div class="video-container">
            <iframe 
              id="ytplayer"
              class="vds-youtube" 
              tabindex="-1" 
              aria-hidden="true" 
              data-no-controls="" 
              frameborder="0" 
              allow="autoplay; fullscreen; encrypted-media; picture-in-picture; accelerometer; gyroscope" 
              src="$iframeSrc"
              allowfullscreen>
            </iframe>
          </div>
          
          <script>
            var player;
            var currentTime = 0;
            var isReady = false;
            
            // YouTube IFrame API
            var tag = document.createElement('script');
            tag.src = "https://www.youtube.com/iframe_api";
            var firstScriptTag = document.getElementsByTagName('script')[0];
            firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
            
            function onYouTubeIframeAPIReady() {
              player = new YT.Player('ytplayer', {
                events: {
                  'onReady': onPlayerReady,
                  'onStateChange': onPlayerStateChange,
                  'onError': onPlayerError
                }
              });
            }
            
            function onPlayerReady(event) {
              isReady = true;
              VideoEvents.postMessage(JSON.stringify({type: 'ready'}));
              startTimeTracking();
            }
            
            function onPlayerStateChange(event) {
              if (event.data == YT.PlayerState.ENDED) {
                VideoEvents.postMessage(JSON.stringify({type: 'ended'}));
              } else if (event.data == YT.PlayerState.PLAYING) {
                VideoEvents.postMessage(JSON.stringify({type: 'playing'}));
              } else if (event.data == YT.PlayerState.PAUSED) {
                VideoEvents.postMessage(JSON.stringify({type: 'paused'}));
              }
            }
            
            function onPlayerError(event) {
              VideoEvents.postMessage(JSON.stringify({
                type: 'error',
                code: event.data
              }));
            }
            
            function startTimeTracking() {
              setInterval(function() {
                if (player && player.getCurrentTime && isReady) {
                  try {
                    currentTime = Math.floor(player.getCurrentTime());
                    VideoEvents.postMessage(JSON.stringify({
                      type: 'timeUpdate',
                      currentTime: currentTime
                    }));
                  } catch(e) {
                    console.error('Error getting current time:', e);
                  }
                }
              }, 1000);
            }
function playVideo() {
              if (player && player.playVideo && isReady) {
                try {
                  player.playVideo();
                } catch(e) {
                  console.error('Error playing video:', e);
                }
              }
            }
            
            function pauseVideo() {
              if (player && player.pauseVideo && isReady) {
                try {
                  player.pauseVideo();
                } catch(e) {
                  console.error('Error pausing video:', e);
                }
              }
            }
            
            function getCurrentTime() {
              if (player && player.getCurrentTime && isReady) {
                try {
                  return Math.floor(player.getCurrentTime());
                } catch(e) {
                  console.error('Error getting current time:', e);
                  return 0;
                }
              }
              return 0;
            }
            
            function seekTo(seconds) {
              if (player && player.seekTo && isReady) {
                try {
                  player.seekTo(seconds, true);
                } catch(e) {
                  console.error('Error seeking:', e);
                }
              }
            }
          </script>
        </body>
      </html>
      ''',
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();
  }

  void _handleVideoEvents(String message) {
    try {
      final data = jsonDecode(message);
      final type = data['type'];
      
      switch (type) {
        case 'ready':
          if (mounted) {
            setState(() {
              _isReady = true;
            });
            widget.onReady?.call();
          }
          break;
        case 'ended':
          widget.onEnded?.call();
          break;
        case 'timeUpdate':
          final time = data['currentTime'] as int;
          widget.onTimeUpdate?.call(time);
          break;
        case 'error':
          print('YouTube Player Error: ${data['code']}');
          break;
      }
    } catch (e) {
      print('Error handling video event: $e');
    }
  }

  Future<void> play() async {
    if (_isReady) {
      try {
        await _controller.runJavaScript('playVideo()');
      } catch (e) {
        print('Error playing video: $e');
      }
    }
  }

  Future<void> pause() async {
    if (_isReady) {
      try {
        await _controller.runJavaScript('pauseVideo()');
      } catch (e) {
        print('Error pausing video: $e');
      }
    }
  }

  Future<int> getCurrentTime() async {
    if (!_isReady) return 0;
    
    try {
      final result = await _controller.runJavaScriptReturningResult('getCurrentTime()');
      return int.tryParse(result.toString()) ?? 0;
    } catch (e) {
      print('Error getting current time: $e');
      return 0;
    }
  }

  Future<void> seekTo(int seconds) async {
    if (_isReady) {
      try {
        await _controller.runJavaScript('seekTo($seconds)');
      } catch (e) {
        print('Error seeking: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
