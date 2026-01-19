import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../Utils/GlobalLoadingCubit.dart';

class LoadingInterceptor extends Interceptor {
  final GlobalLoadingCubit _loadingCubit = GetIt.instance<GlobalLoadingCubit>();
  int _activeRequests = 0;

  // ✅ قائمة الـ endpoints اللي مش عايزين loading فيها
  final List<String> _excludedEndpoints = [
    '/notifications',        // الإشعارات
    '/notification',         // بعض الـ APIs بتستخدم singular
    '/sse',                  // Server-Sent Events
    '/realtime',             // Real-time updates
    '/heartbeat',            // Health checks
    '/analytics',            // Analytics calls
    '/refresh',
    'auth/login',              // Token refresh
    '/students/my-profile',              
    '/students/preview', 
    'exhibitions/certificates',
    'comm-requests/inquiries',
    'comm-requests',
    '/students/testimonials',
    'module-items/lesson',
  ];

  void _show() {
    if (_activeRequests == 0) {
      _loadingCubit.show();
      print('🔵 Global Loading SHOW - Active requests: ${_activeRequests + 1}');
    }
    _activeRequests++;
  }

  void _hide() {
    _activeRequests--;
    if (_activeRequests <= 0) {
      _activeRequests = 0;
      _loadingCubit.hide();
      print('🟢 Global Loading HIDE - Active requests: 0');
    }
  }

  bool _shouldShowLoading(RequestOptions options) {
    // ✅ 1. لو في الـ extra محدد hideGlobalLoading = true → مش هنظهر loading
    if (options.extra['hideGlobalLoading'] == true) {
      print('⚪️ Skipping loading for: ${options.uri} (hideGlobalLoading=true)');
      return false;
    }

    // ✅ 2. لو الـ endpoint في القائمة المستثناة → مش هنظهر loading
    final uri = options.uri.toString().toLowerCase(); // case-insensitive
    for (var excluded in _excludedEndpoints) {
      if (uri.contains(excluded.toLowerCase())) {
        print('⚪️ Skipping loading for: ${options.uri} (excluded endpoint)');
        return false;
      }
    }

    // ✅ 3. في كل الحالات التانية → نظهر loading
    print('🔵 Showing loading for: ${options.uri}');
    return true;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_shouldShowLoading(options)) {
      _show();
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (_shouldShowLoading(response.requestOptions)) {
      _hide();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_shouldShowLoading(err.requestOptions)) {
      _hide();
    }
    super.onError(err, handler);
  }
}