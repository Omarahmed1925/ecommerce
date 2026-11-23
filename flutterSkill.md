# flutterSkill.md — Flutter MVVM + Clean Architecture Conventions

Read this file fully before implementing any Flutter feature. It encodes one developer's engineering style. Reproduce the style, not any specific app.

---

## Reference Code Policy

All code snippets in this file are illustrative references, not templates to copy literally.

Follow the demonstrated architectural patterns, dependency relationships, naming conventions, and separation of concerns.

Adapt class names, methods, parameters, entities, states, and implementations to the actual project requirements.

Never create example classes or features unless they are explicitly required by the current task.

Architectural rules are mandatory where specified. Example implementations are not.

---

## 1. Stack Policy (read first)

**Default architecture ≠ mandatory technology stack.**

| Element | Status |
|---|---|
| MVVM + Clean Architecture (layers, dependency direction) | **Mandatory** |
| Use cases for every repository operation | **Mandatory** |
| Top-level folder structure (§3) | **Default for new projects**; adapt incrementally in existing ones |
| Cubit as ViewModel | Preferred default, replaceable |
| Dio + Retrofit | Preferred default, replaceable |
| GetIt + Injectable | Preferred default, replaceable |

Rules:
- **New project:** use the full default stack and structure.
- **Existing project:** inspect `pubspec.yaml` and `lib/` first. Use its state management, networking, DI, routing, and folder layout. Never add a competing library or reorganize folders to match this file. Apply the *responsibilities* in this file using the project's own tools.
- If a needed architectural boundary is missing (e.g., no domain layer for the feature), add only that boundary, with minimal disruption.
- Add a dependency only when the task needs it.

---

## 2. Core Principles

1. Presentation → Domain ← Data. Domain depends on nothing (no Flutter UI, Dio, Retrofit, DTOs, Hive, or state libraries).
2. UI widgets render state and forward user actions. No business logic, no API calls, no DTOs.
3. The ViewModel (Cubit/Notifier/etc.) holds screen data and orchestrates use cases. It is one class: never stack a ViewModel on top of a Cubit.
4. Every repository operation is exposed through a **use case**: one class, one operation, one `invoke()` method. Straight pass-through use cases are intentional here. Add no logic beyond what the operation needs, and no extra wrappers.
5. Transport models (DTOs) stop at the `api/` layer. Entities are what the rest of the app sees. Conversion happens through mapper extensions.
6. Depend on abstractions: ViewModels get use cases, use cases get abstract repositories, repository impls get abstract data sources.
7. Create files only when needed. No empty folders, no placeholder implementations, no unused generated files.

---

## 3. Project Structure (new projects)

```text
lib/
├── api/
│   ├── data_sources/{local,remote}/   # concrete *_impl classes
│   ├── dio/                           # dio module, interceptors
│   ├── mapper/                        # DTO <-> entity extensions
│   ├── model/{request,response}/      # DTOs (+ .g.dart)
│   ├── api_endpoints.dart
│   ├── web_services.dart              # Retrofit service (+ .g.dart)
├── config/di/                         # di.dart, di.config.dart (+ bloc observer or similar app config)
├── core/
│   ├── exceptions/                    # app_exception.dart
│   ├── cache/                         # token/prefs storage
│   └── utils/                         # app_assets, app_colors, app_styles, app_theme, app_routes, validators, dialog/toast helpers
├── data/
│   ├── data_sources/{local,remote}/   # abstract contracts
│   └── repos/                         # *_repo_impl.dart
├── domain/
│   ├── entities/{request,response}/   # plain classes
│   ├── repos/                         # abstract repositories
│   └── use_cases/
└── features/
    └── <feature_name>/
        ├── view/                      # screens
        ├── cubit/                     # <x>_view_model.dart + <x>_states.dart (rename for other state libs: bloc/, providers/, notifiers/)
        └── widgets/                   # widgets used only by this feature
```

- No extra `ui/` directory under `features/`.
- Feature names come from the product (`auth`, `cart`, `home`…), never copied from a reference.
- Widgets shared by 2+ features: `features/shared/widgets/` (or the project's existing shared location). A widget used by one feature stays in that feature.
- Sub-screens with their own state (e.g., tabs): nest a sub-feature folder with its own `view/`, `cubit/`, `widgets/` as needed.
- Generated files (`*.g.dart`, `di.config.dart`) exist only when the matching generator is configured.

### Layer responsibilities

| Folder | Contains |
|---|---|
| `domain/entities` | Plain Dart classes: fields + constructor. No `fromJson`/`toJson`. Request entities go in `request/`, response entities in `response/`. |
| `domain/repos` | Abstract class, one method per operation, returns entities. |
| `domain/use_cases` | One class per operation, `invoke()`, holds an abstract repo. |
| `data/data_sources` | Abstract contracts (`XRemoteDataSource`, `XLocalDataSource`). Return entities. |
| `data/repos` | `XRepoImpl implements XRepo`; coordinates data sources (remote only, or remote + local cache). |
| `api/data_sources` | `XRemoteDataSourceImpl`: calls `WebServices`, maps DTO→entity, translates errors. `XLocalDataSourceImpl`: wraps prefs/Hive/etc. |
| `api/model` | DTOs with serialization annotations. |
| `api/mapper` | Extension methods converting between DTOs and entities. |
| `core` | Cross-cutting only: exceptions, theme/design tokens, validators, storage helpers. Not a dumping ground. |
| `features` | Presentation only. |

---

## 4. Call Chain

```
View → ViewModel(Cubit) → UseCase → Repo (abstract) → RepoImpl → DataSource (abstract)
     → DataSourceImpl → WebServices/Dio (or local storage)
```

Rule: a class only knows the abstraction one step down. Never instantiate an impl by hand (outside DI).

---

## 5. Feature Implementation Order

1. Domain: entities → repo contract → use cases.
2. Data: abstract data source → repo impl.
3. API: DTOs → mappers → `ApiEndPoints` entry → `WebServices` method → data source impl.
4. DI registration (annotations; run `build_runner` if Injectable/Retrofit/json_serializable are used).
5. Presentation: states → ViewModel → screen → widgets.
6. Route registration, then verification (§16).

---

## 6. Domain Layer

```dart
// entity
class User {
  final String? name;
  final String? email;
  User({required this.name, required this.email});
}

// repo contract
abstract class AuthRepo {
  Future<AuthResponse> login(LoginRequest request);
}

// use case — one operation, `invoke`
@injectable
class LoginUseCase {
  final AuthRepo authRepo;
  LoginUseCase({required this.authRepo});

  Future<AuthResponse> invoke(LoginRequest request) => authRepo.login(request);
}
```

- Use case naming: `<Verb><Noun>UseCase`, file `<verb>_<noun>_use_case.dart`. Constructor uses named `required` parameters.
- Parameters for use cases are plain values or request entities (never DTOs).
- Entity fields mirror what the UI needs; make fields nullable only when the API can omit them. Prefer `final`.

---

## 7. Data Layer

```dart
abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginRequest request);
}

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepoImpl({required this.remoteDataSource});

  @override
  Future<AuthResponse> login(LoginRequest request) => remoteDataSource.login(request);
}
```

- Repo impl is a thin coordinator. Add logic only when there is a real reason: remote + local caching, fallback when offline (check connectivity → remote and save, else read local), merging sources.
- Local data sources (prefs, Hive, Firestore cache) get an abstract contract in `data/data_sources/local/` and an impl in `api/data_sources/local/`.

---

## 8. API Layer (Dio + Retrofit default)

### Endpoints and service

```dart
class ApiEndPoints {
  static const String baseUrl = '...';          // from config/env, never a secret literal
  static const String loginApi = 'api/v1/auth/signin';
  static const String productByIdApi = 'api/v1/products/{id}';
}

@RestApi()
abstract class WebServices {
  factory WebServices(Dio dio, {String? baseUrl}) = _WebServices;

  @POST(ApiEndPoints.loginApi)
  Future<AuthResponseDto> login(@Body() LoginRequestDto request);

  @GET(ApiEndPoints.productByIdApi)
  @Extras({'authType': 'bearer'})               // protected endpoint
  Future<ProductResponseDto> getProduct(@Path('id') String id);
}
```

- One `ApiEndPoints` constant per endpoint; services reference constants.
- Request/response types in service methods are DTOs only.
- Retrofit usage: `@Body()` JSON; `@Field` + `@FormUrlEncoded` for form bodies; `@Query` for URL params; `@Path` for URL segments; `@Part` + `@Multipart` for uploads; `@Headers` for static headers; `@Extras` for per-endpoint metadata read by interceptors.
- Do not pass tokens as method parameters (see §9).

### Dio module

Register Dio infrastructure in DI (`@module`): `BaseOptions` (base URL, 20s connect/receive timeouts, `receiveDataWhenStatusError: true`), a logger (debug builds only), the interceptors, `Dio`, then `WebServices(dio)` as singletons.

### DTOs

```dart
@JsonSerializable()
class UserDto {
  @JsonKey(name: 'name') final String? name;
  @JsonKey(name: 'email') final String? email;
  UserDto({this.name, this.email});

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
```

- DTO fields are `final` and nullable; file `*_dto.dart`; requests in `model/request/`, responses in `model/response/` (group related ones in subfolders; shared nested DTOs in `common/`).
- With Hive: model `extends HiveObject` with `@HiveType`/`@HiveField` and a registered adapter in `main`. Hive models are local-storage details, not domain entities.

### Mappers (extension methods)

```dart
extension UserMapper on UserDto {
  User toUser() => User(name: name, email: email);
}
extension LoginRequestMapper on LoginRequest {
  LoginRequestDto toLoginRequestDto() => LoginRequestDto(email: email, password: password);
}
```

- One file per mapped type: `<type>_mapper.dart`. Naming: DTO→entity `toX()`, entity→DTO `toXDto()`.
- DTO→entity returns the entity. When required data is missing, throw `ServerException` here (once), not scattered null checks in the UI.
- Mappers hold data transformation only; all conversion logic lives here, so a server JSON change touches only DTOs and mappers.

### Remote data source impl

```dart
@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final WebServices webServices;
  AuthRemoteDataSourceImpl({required this.webServices});

  @override
  Future<AuthResponse> login(LoginRequest request) async {
    final dto = await webServices.login(request.toLoginRequestDto());
    return dto.toAuthResponse();
  }
}
```

### Errors

`core/exceptions/app_exception.dart`:

```dart
sealed class AppException implements Exception {
  final String message;
  final int? statusCode;
  AppException({required this.message, this.statusCode});
}
class ServerException extends AppException { ServerException({required super.message, super.statusCode}); }
class NetworkException extends AppException { NetworkException({required super.message, super.statusCode}); }
class UnexpectedException extends AppException { UnexpectedException({required super.message, super.statusCode}); }
```

- An error interceptor converts every `DioException` into an `AppException`: connection error/timeout → `NetworkException`; response with status code → `ServerException(message from body, statusCode)`; otherwise `UnexpectedException`. It rejects with `DioException(requestOptions, error: exception)`.
- Translate **once**, below the repo: the data source impl unwraps `DioException.error` into `AppException` (a small shared helper in `core/` avoids repeating this in every method). ViewModels catch only `AppException`.
- Parse the message from the response body defensively (`errors.msg` / `message` / fallback text); adapt keys to the project's API.

---

## 9. Authentication Headers (Dio interceptor)

Tokens are attached by an interceptor. Never pass a token through service/data-source/use-case methods.

**Components**
- `TokenStorage` abstraction in `core/cache/` (`getAccessToken`, `getRefreshToken`, `saveTokens`, `clear`), implemented over SharedPreferences or secure storage (prefer secure storage for real credentials). Register in DI and inject into the interceptor.
- `AuthInterceptor` in `api/dio/`.
- Endpoint marking via `@Extras({'authType': 'bearer'})` or `'token'` (when the backend expects a raw `token` header). **Public endpoints carry no extra and receive no header.**

**Behavior**
1. `onRequest`: read `options.extra['authType']`. If absent → pass through untouched. If present and a token exists → set `Authorization: Bearer <token>` or `token: <token>`.
2. `onError` with 401, only if the request was authenticated and not already retried (`options.extra['retried'] != true`) and a refresh token exists:
   - Refresh using a **separate Dio instance with no AuthInterceptor** (prevents recursion). Never refresh for the refresh/login endpoints themselves.
   - Serialize concurrent refreshes (a shared in-flight `Future`/lock) so parallel 401s trigger one refresh.
   - On success: `saveTokens`, mark `retried = true`, replay with `dio.fetch(err.requestOptions)` and `handler.resolve(response)`.
   - On failure: `clear()`, signal logout (e.g., emit on an auth-session stream or call a callback registered in DI), then `handler.next(err)`.
3. Interceptor order: auth → error-mapping → logger.
4. Startup route is decided from stored token presence (`TokenStorage`), not from a hardcoded route.

If the project already has a different auth mechanism, extend it rather than replacing it.

---

## 10. Dependency Injection (GetIt + Injectable default)

- `config/di/di.dart`: `final getIt = GetIt.instance;` and `@InjectableInit(...) void configureDependencies() => getIt.init();` called in `main()` before `runApp`.
- Registration:
  - Implementations: `@Injectable(as: Abstraction)` (data source impls, repo impls).
  - Use cases and ViewModels: `@injectable` (new instance per request).
  - Dio, `WebServices`, token storage, shared services: `@singleton` / `@module`.
  - App-wide ViewModels (e.g., cart count, session) provided once at the app root (`MultiBlocProvider` or equivalent) and registered so they resolve from DI.
- Screens get their ViewModel from DI (`getIt<XViewModel>()`) or from the provider tree for shared ones; never `new` a ViewModel with manual dependencies.
- In existing projects with another DI approach, register through that approach.
- Run `dart run build_runner build --delete-conflicting-outputs` after changing annotated classes.

---

## 11. Presentation Layer

### States (Cubit default)

```dart
sealed class AuthStates {}
class AuthInitialState extends AuthStates {}
class AuthLoadingState extends AuthStates {}
class AuthErrorState extends AuthStates { final String message; AuthErrorState({required this.message}); }
class AuthSuccessState extends AuthStates { final AuthResponse authResponse; AuthSuccessState({required this.authResponse}); }
```

- File `<x>_states.dart` next to `<x>_view_model.dart` in `cubit/`.
- Names: `<Feature|Action><Initial|Loading|Error|Success>State`. Add an `Empty` state when a list can be empty. Use `copyWith` on a success state when one screen merges several loads.
- Prefer `final` fields.

### ViewModel

```dart
@injectable
class LoginViewModel extends Cubit<AuthStates> {
  final LoginUseCase loginUseCase;
  LoginViewModel({required this.loginUseCase}) : super(AuthInitialState());

  final formKey = GlobalKey<FormState>();   // UI-adjacent form state may live here

  Future<void> login({required String email, required String password}) async {
    if (formKey.currentState?.validate() != true) return;
    try {
      emit(AuthLoadingState());
      final response = await loginUseCase.invoke(LoginRequest(email: email, password: password));
      emit(AuthSuccessState(authResponse: response));
    } on AppException catch (e) {
      emit(AuthErrorState(message: e.message));
    }
  }
}
```

- Naming: `<Screen|Feature>ViewModel` for Cubit-as-ViewModel, file `*_view_model.dart`.
- Depends only on use cases. Holds data the screen needs; exposes methods for user actions; emits Loading → Success/Error. Emit only on meaningful change.
- Catch `AppException`; show `message`. Never expose raw exceptions or stack traces to the UI.
- Persistence side effects (saving a token after login) are done through a use case/storage abstraction, not inside widgets.

### Screens

- `StatefulWidget` when it creates/owns a ViewModel or calls load methods in `initState`; otherwise `StatelessWidget`. Constructor `const` when possible.
- `BlocListener`/listener for one-off effects (dialogs, toasts, navigation); `BlocBuilder`/builder for rendering. Use the equivalent of each in other state libraries.
- Standard render switch:

```dart
BlocBuilder<ProductsViewModel, ProductsStates>(
  bloc: viewModel,
  builder: (context, state) {
    if (state is ProductsErrorState) {
      return MainErrorWidget(errorMessage: state.message, onTryAgain: viewModel.getProducts);
    } else if (state is ProductsSuccessState) {
      return /* content, or an empty-state widget when the list is empty */;
    }
    return const MainLoadingWidget();
  },
)
```

- Every data-loading screen handles loading, error (with retry), success, and empty.
- Screens never call `WebServices`, data sources, repos, or use cases directly.
- Dispose controllers and subscriptions you create; close ViewModels you own (when not managed by a provider).

### Widget decomposition

Extract a widget into its **own file** when any is true:
1. It is a repeated cell/item (list/grid item, card, row) — `<name>_item.dart`.
2. It is reused in 2+ places (button, text field, loading/error/empty views).
3. It has independent behavior or its own state.

Keep a part as a **private builder method** (`_buildHeader()`) or private widget in the same file when it is used once and exists only to keep `build` readable.

Rules:
- Item widgets receive an **entity** (not a DTO) plus callbacks through the constructor; they hold no business logic.
- Shared generic widgets take configuration through named parameters with sensible defaults (required vs. defaulted decided deliberately; avoid forcing callers to pass what rarely changes).
- Anything that can change at runtime comes from a variable/state, never a literal.
- Don't split every `Padding`/`Text`. Don't leave a 300-line `build`. Aim for a tree readable at a glance.
- Build the whole screen first, test it visually, then refine spacing; extract widgets when repetition appears.

### Reusable component conventions
- Typical shared set: primary button, text form field (with password toggle, validator, hint), loading widget, error widget (message + optional retry), empty-state widget, dialog/toast helpers.
- Shared widgets take colors/styles from theme tokens and accept overrides as optional parameters.
- Do not create a global abstraction for something used once.

---

## 12. State Management Adaptation

Keep the same responsibilities regardless of library:

| Concept | Cubit/Bloc | Provider/ChangeNotifier | Riverpod | Other |
|---|---|---|---|---|
| ViewModel | Cubit (or Bloc) | ChangeNotifier | Notifier/AsyncNotifier | equivalent |
| States | sealed state classes | status enum/state object | `AsyncValue` or state class | equivalent |
| Render | BlocBuilder | Consumer/Selector | ref.watch / Consumer | equivalent |
| Side effects | BlocListener | listener/callback | ref.listen | equivalent |
| Folder | `cubit/` or `bloc/` | `providers/` or `view_model/` | `providers/` | name it for the tool |

- Existing project: use its tool and its naming exactly. Do not introduce Cubit.
- ViewModel still depends only on use cases; use cases/domain stay library-free.
- Represent loading, success, error, and empty consistently. Observe only what a widget needs to avoid extra rebuilds.
- New project with no instruction: Cubit.

---

## 13. Navigation

- Use the project's router. New project default: `MaterialApp` named routes: `AppRoutes` static route-name constants in `core/utils/app_routes.dart` and a `routes:` map; `Navigator.pushNamed(..., arguments: entity)`; `pushReplacementNamed` after login/logout.
- Route names are constants, never inline strings.
- Pass entities or ids as arguments, not DTOs.
- Initial route is computed in `main()` from session state.
- Bottom navigation: a ViewModel holds `selectedIndex` and the tab list; the screen renders the selected tab.
- Existing project on `go_router`/`auto_route`/etc.: add routes in its format.

---

## 14. UI Implementation, Theme, Figma and Screenshots

### Design system (`core/utils`)
- `app_colors.dart`: `static const Color` tokens.
- `app_styles.dart`: named `TextStyle` tokens `<weight><size><Color>` (e.g., `semi24White`) using the project's font package.
- `app_assets.dart`: asset path constants (images in 1x/2x/3x folders when density variants exist; register assets in `pubspec.yaml`; run `pub get` after adding).
- `app_theme.dart`: `lightTheme` (and `darkTheme` if required).
- `app_routes.dart`, `validators.dart`.
- Inspect these before coding UI; reuse tokens; add a token only when none matches. Never scatter hex values or raw `TextStyle`s through widgets.

### Responsiveness
- If the project uses `flutter_screenutil`: `.w/.h/.r/.sp` and `ScreenUtilInit(designSize: <the design frame size>)`. Otherwise use `MediaQuery` ratios (`value / designDimension * screenDimension`), `Expanded`/`Flexible`, and `LayoutBuilder`. Match whatever the project already does.
- Use `AutoSizeText` (if present) or `maxLines` + `overflow` for text that must fit.
- Avoid hardcoded absolute positions; prefer `Column`/`Row`/`Stack` composition with `Spacer`, `Expanded`, `SizedBox`.

### Layout habits
- Build outside-in (top → bottom by `Column`, outer containers before inner). `Container` + color to debug bounds.
- Lists: `ListView.separated` (separator = `Divider` or sized box) inside `Expanded`. Scrolling content in `SingleChildScrollView`/`ListView`; forms in `Form` with a key.
- Network images: `CachedNetworkImage` with placeholder and error widget (or the project's equivalent).
- Text fields: configure enabled/focused/error borders, radius, hint, prefix/suffix through one shared field widget.

### From Figma
1. Identify the single relevant frame; inspect structure first, then only the nodes needed. Do not pull the whole file; do not re-request the same node.
2. Extract exact values: colors, font family/size/weight/line height, spacing, radii, shadows, sizes, assets.
3. Map to existing tokens; add new tokens once, then reuse across screens.
4. Identify repeated components before coding.
5. Implement following §11; export required assets.
6. If a render/screenshot tool exists, compare with the frame and fix differences.

### From screenshots (or written requirements)
1. Describe hierarchy, grouping, repeated elements.
2. Estimate spacing/proportions and type scale; match to existing tokens.
3. Implement responsively, no absolute positioning.
4. Compare the render if possible; refine.
5. State that measurements are estimates; never claim pixel-perfect without verification.

UI follows the same architecture as everything else: the UI work does not change where logic lives.

---

## 15. Naming and Formatting

- Files/dirs `snake_case`; classes `UpperCamelCase`; members `lowerCamelCase`; constants `lowerCamelCase`.
- Suffixes: `_dto`, `_mapper`, `_impl` (data source), `_repo_impl`, `_repo`, `_use_case`, `_view_model`, `_states`, `_screen`, `_tab`, `_item`, `_widget`.
- Classes: `XRepo`/`XRepoImpl`, `XRemoteDataSource`/`XRemoteDataSourceImpl`, `XUseCase`, `XViewModel`, `XStates`, `AppColors`, `AppStyles`, `AppRoutes`.
- Imports: package imports; keep layer imports legal per §4 (UI/domain imports never reach `api/`).
- Single quotes, `final` by default, `const` constructors where possible, null safety respected (no blanket `!`; handle nulls at the mapper boundary).
- `dart format` on changed files. Respect the project's `analysis_options.yaml`.
- Comments only where they explain *why*. No leftover `print`, debug `TODO` blocks, commented-out code.

---

## 16. AI Workflow

**Before**
1. Read this file. Inspect `pubspec.yaml`, `lib/` structure, `main.dart`, DI, routing, theme/tokens.
2. Find the closest existing feature and reuse its patterns, widgets, and tokens. Read only the relevant files.
3. Decide which layers are affected; plan the smallest coherent change.

**During**
4. Follow §3–§5 order; respect dependency direction (§4).
5. Reuse existing abstractions; no new packages unless required.
6. Handle loading/error/empty; integrate with existing DI and routing.
7. No unrelated refactors; preserve existing behavior.

**After**
8. Run code generation if annotations changed.
9. `dart format` changed files; `flutter analyze`; run relevant tests if present.
10. Review the diff for architecture violations (§17).
11. Summarize changes. State plainly what was not run or not verified (tests, device run, visual comparison). Never claim verification that did not happen.

Tests (when added): use cases and ViewModels are tested with mocked abstractions; mappers with plain unit tests.

---

## 17. Anti-Patterns

- Business logic or API calls in widgets; widgets touching DTOs.
- Entities importing DTOs, Flutter, Dio, or Hive; `fromJson` on entities.
- Skipping the use case and calling a repo from a ViewModel.
- A ViewModel wrapped around a Cubit (or any duplicate presentation layer).
- Passing tokens manually through every method; storing/reading tokens inside random classes.
- Refresh logic that uses the same Dio with the auth interceptor (recursion); parallel refreshes; infinite retry.
- Authorization headers on public endpoints.
- Hardcoded credentials, API keys, base URLs with secrets, or prefilled test logins in committed code.
- Inline hex colors, raw text styles, inline route strings, magic numbers for repeated values.
- Mega `build` methods, or one file per trivial widget; duplicated reusable widgets.
- Mapper logic duplicated in data sources, repos, or ViewModels.
- Adding libraries or restructuring an existing project to match this file.
- Empty folders, unused generated files, stub methods presented as finished work.
- Swallowed exceptions; showing raw exception text; `print` for logging.
- Mutable widget fields (`StatelessWidget` fields should be `final`).

---

## 18. Final Checklist

- [ ] Existing stack and structure respected (or full defaults used for a new project).
- [ ] Domain: entity → repo contract → use case (`invoke`) exist for each operation.
- [ ] Data: abstract data source + repo impl; API: DTO, mapper, endpoint constant, service method, data source impl.
- [ ] Auth handled by the interceptor; public endpoints untouched; refresh is recursion-safe.
- [ ] Errors flow `DioException → AppException → ViewModel state → UI message`.
- [ ] DI registered (and generated); no manual construction.
- [ ] ViewModel depends only on use cases; states cover loading/success/error/empty.
- [ ] Screens contain no logic; widgets split by §11 rules; tokens reused.
- [ ] Route registered with a constant.
- [ ] Naming, formatting, analyzer clean; no debug leftovers or secrets.
- [ ] Verification honestly reported.
