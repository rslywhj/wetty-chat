import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chahua/core/providers/shared_preferences_provider.dart';
import 'package:chahua/core/session/dev_session_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        authBootstrapApiProvider.overrideWithValue(_FakeAuthBootstrapApi()),
      ],
    );
  });

  tearDown(() => container.dispose());

  test(
    'defaults to uid 1 while bootstrapping when no preference is stored',
    () {
      final session = container.read(authSessionProvider);
      expect(session.developerUserId, AuthSessionNotifier.defaultUserId);
      expect(session.currentUserId, AuthSessionNotifier.defaultUserId);
      expect(session.status, AuthBootstrapStatus.bootstrapping);
    },
  );

  test('persists the selected developer uid', () async {
    await container.read(authSessionProvider.notifier).setCurrentUserId(42);

    final session = container.read(authSessionProvider);
    expect(session.developerUserId, 42);
    expect(session.currentUserId, 42);
  });

  test('loginWithJwt stores jwt session and current user id', () async {
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        ),
        authBootstrapApiProvider.overrideWithValue(
          _FakeAuthBootstrapApi(
            onFetchAuthToken: (headers) {
              expect(headers['Authorization'], 'Bearer test-token');
              return 'server-token';
            },
            onFetchMe: (headers) {
              expect(headers['Authorization'], 'Bearer server-token');
              return const AuthBootstrapMe(7);
            },
          ),
        ),
      ],
    );

    await container
        .read(authSessionProvider.notifier)
        .loginWithJwt('test-token');

    final session = container.read(authSessionProvider);
    expect(session.mode, AuthSessionMode.jwt);
    expect(session.currentUserId, 7);
    expect(session.jwtToken, 'server-token');
  });

  test('bootstrap falls back to dev header mode when jwt is absent', () async {
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        ),
        authBootstrapApiProvider.overrideWithValue(
          _FakeAuthBootstrapApi(
            onFetchAuthToken: (headers) {
              expect(headers['X-User-Id'], '1');
              expect(headers['X-Client-Id'], '1');
              return 'dev-token';
            },
          ),
        ),
      ],
    );

    await container.read(authSessionProvider.notifier).bootstrap();

    final session = container.read(authSessionProvider);
    expect(session.mode, AuthSessionMode.devHeader);
    expect(session.status, AuthBootstrapStatus.authenticated);
    expect(session.currentUserId, AuthSessionNotifier.defaultUserId);
    expect(session.jwtToken, isNull);
  });

  test(
    'clearJwt re-runs bootstrap and becomes unauthenticated when dev probe fails',
    () async {
      SharedPreferences.setMockInitialValues({
        'auth_session_jwt_token': 'persisted-token',
      });
      final prefs = await SharedPreferences.getInstance();
      final requests = <Uri>[];
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          authBootstrapApiProvider.overrideWithValue(
            _FakeAuthBootstrapApi(
              onFetchAuthToken: (headers) {
                requests.add(Uri(path: '/users/auth-token'));
                return null;
              },
            ),
          ),
        ],
      );

      await container.read(authSessionProvider.notifier).clearJwt();

      final session = container.read(authSessionProvider);
      expect(session.status, AuthBootstrapStatus.unauthenticated);
      expect(session.mode, AuthSessionMode.none);
      expect(session.jwtToken, isNull);
      expect(
        requests.where((uri) => uri.path.endsWith('/users/auth-token')).length,
        1,
      );
    },
  );

  test('bootstrap falls back to unauthenticated when request throws', () async {
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        ),
        authBootstrapApiProvider.overrideWithValue(
          _FakeAuthBootstrapApi(
            onFetchAuthToken: (headers) => throw Exception('network failed'),
          ),
        ),
      ],
    );

    await container.read(authSessionProvider.notifier).bootstrap();

    final session = container.read(authSessionProvider);
    expect(session.status, AuthBootstrapStatus.unauthenticated);
    expect(session.mode, AuthSessionMode.none);
  });

  test(
    'bootstrap can run again after a previous bootstrap completed',
    () async {
      var devProbeCount = 0;
      container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(
            await SharedPreferences.getInstance(),
          ),
          authBootstrapApiProvider.overrideWithValue(
            _FakeAuthBootstrapApi(
              onFetchAuthToken: (headers) {
                devProbeCount++;
                return null;
              },
            ),
          ),
        ],
      );

      await container.read(authSessionProvider.notifier).bootstrap();
      await container.read(authSessionProvider.notifier).bootstrap();

      expect(devProbeCount, 2);
    },
  );
}

class _FakeAuthBootstrapApi extends AuthBootstrapApi {
  _FakeAuthBootstrapApi({this.onFetchAuthToken, this.onFetchMe})
    : super(_noopDio);

  final String? Function(Map<String, String> headers)? onFetchAuthToken;
  final AuthBootstrapMe? Function(Map<String, String> headers)? onFetchMe;

  static final Dio _noopDio = Dio();

  @override
  Future<String?> fetchAuthToken(Map<String, String> authHeaders) async {
    return onFetchAuthToken?.call(authHeaders);
  }

  @override
  Future<AuthBootstrapMe?> fetchMe(Map<String, String> authHeaders) async {
    return onFetchMe?.call(authHeaders);
  }
}
