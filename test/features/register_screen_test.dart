import 'package:ecommerce/config/di/di.dart';
import 'package:ecommerce/core/exceptions/app_exceptions.dart';
import 'package:ecommerce/core/utils/app_routes.dart';
import 'package:ecommerce/core/utils/cache.dart';
import 'package:ecommerce/domain/entities/request/login_request_dto.dart';
import 'package:ecommerce/domain/entities/request/register_request_dto.dart';
import 'package:ecommerce/domain/entities/response/auth_response_dto.dart';
import 'package:ecommerce/domain/entities/response/user_dto.dart';
import 'package:ecommerce/domain/repos/auth_repo.dart';
import 'package:ecommerce/domain/use_cases/register_use_case.dart';
import 'package:ecommerce/features/auth/register/cubit/register_screen_view_model.dart';
import 'package:ecommerce/features/auth/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthRepo implements AuthRepository {
  final requests = <RegisterRequestDto>[];
  AppExceptions? error;

  @override
  Future<AuthResponseDto> register(RegisterRequestDto registerReq) async {
    requests.add(registerReq);
    if (error != null) throw error!;
    return AuthResponseDto(
      token: 'new-token',
      user: UserDto(name: registerReq.name, email: registerReq.email),
    );
  }

  @override
  Future<AuthResponseDto> login(LoginRequestDto loginReq) =>
      throw UnimplementedError();
}

const valid = {
  'Enter your name': 'Omar Ahmed',
  'Enter your phone No.': '01012345678',
  'Enter your email address': 'omar@example.com',
  'Enter your password': 'Secret@123',
};

void main() {
  late FakeAuthRepo repo;

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferencesUtils.getInstance();
    repo = FakeAuthRepo();
    getIt.registerFactory<RegisterViewModel>(
      () => RegisterViewModel(
        registerUseCase: RegisterUseCase(authRepository: repo),
      ),
    );
  });

  tearDown(() => getIt.reset());

  Future<void> pumpRegister(WidgetTester tester) async {
    // A tall phone-like window so the whole form fits without scrolling.
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = const Size(430, 1400);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(430, 932),
        builder: (_, _) => MaterialApp(
          home: const RegisterScreen(),
          routes: {
            AppRoutes.homeScreen: (_) => const Scaffold(body: Text('HOME')),
          },
        ),
      ),
    );
    await tester.pump();
  }

  Future<void> fill(WidgetTester tester, Map<String, String> values) async {
    for (final MapEntry(key: hint, value: text) in values.entries) {
      final field = find.widgetWithText(TextFormField, hint);
      await tester.ensureVisible(field);
      await tester.enterText(field, text);
    }
  }

  Future<void> tapSignUp(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Sign up'));
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();
  }

  testWidgets('each register field keeps its own text', (tester) async {
    await pumpRegister(tester);
    await fill(tester, valid);
    await tester.pump();

    final fields = tester
        .widgetList<TextFormField>(find.byType(TextFormField))
        .map((f) => f.controller!.text)
        .toList();
    expect(fields, valid.values.toList());
    expect(tester.takeException(), isNull);
  });

  testWidgets('empty form is rejected without calling the API', (tester) async {
    await pumpRegister(tester);
    await tapSignUp(tester);
    expect(find.text("Name can't be empty"), findsOneWidget);
    expect(repo.requests, isEmpty);
  });

  testWidgets('valid form signs up, saves the session and opens Home', (
    tester,
  ) async {
    await pumpRegister(tester);
    await fill(tester, valid);
    await tapSignUp(tester);

    final sent = repo.requests.single;
    expect(sent.name, 'Omar Ahmed');
    expect(sent.phone, '01012345678');
    expect(sent.email, 'omar@example.com');
    expect(sent.password, 'Secret@123');
    expect(sent.rePassword, 'Secret@123');
    expect(SharedPreferencesUtils.readData(key: CacheKeys.token), 'new-token');
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('server errors are shown to the user', (tester) async {
    repo.error = ServerException(message: 'Account Already Exists');
    await pumpRegister(tester);
    await fill(tester, valid);
    await tapSignUp(tester);

    expect(find.text('Account Already Exists'), findsOneWidget);
    expect(find.text('HOME'), findsNothing);
    expect(SharedPreferencesUtils.readData(key: CacheKeys.token), isNull);
  });
}
