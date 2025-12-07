class ApiConfig {
  // 🔧 CHANGE THIS TO YOUR LOCAL IP FOR TESTING
  static const String localIp = '147.182.180.167'; // ← Your IP here
  static const String localPort = '3000';
  
  static const bool isProduction = false; // Set to true for production
  
  static String get baseUrl {
    if (isProduction) {
      return 'http://$localIp:$localPort'; // Your production URL
    } else {
      return 'http://$localIp:$localPort';
    }
  }
  
  static String get healthEndpoint => '$baseUrl/health';
  static String videoInfoEndpoint(String videoId) => '$baseUrl/api/video/info/$videoId';
  static String videoUrlEndpoint(String videoId, {String quality = '720'}) => 
      '$baseUrl/api/video/url/$videoId?quality=$quality';
  static String videoStreamEndpoint(String videoId, {String quality = '720'}) => 
      '$baseUrl/api/video/stream/$videoId?quality=$quality';
}