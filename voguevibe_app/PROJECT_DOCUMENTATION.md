# VogueVibe App — Project Documentation

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Architecture](#3-architecture)
4. [State Management](#4-state-management)
5. [API & Data Flow](#5-api--data-flow)
6. [UI & UX Logic](#6-ui--ux-logic)
7. [User Journey](#7-user-journey)
8. [Features Breakdown](#8-features-breakdown)
9. [Performance Considerations](#9-performance-considerations)
10. [Security Considerations](#10-security-considerations)
11. [Scalability & Maintainability](#11-scalability--maintainability)
12. [Project Structure Tree](#12-project-structure-tree)
13. [Setup & Run Instructions](#13-setup--run-instructions)

---

## 1. Project Overview

### Purpose

VogueVibe is a mobile e-commerce application for browsing and purchasing clothing products. It provides a dark-themed, glassmorphism-styled shopping experience with product browsing, cart management, favorites, checkout, and user profile features.

### Core Problem It Solves

Delivers a complete mobile storefront with persistent user sessions, reactive cart/favorites state, and a polished UI — structured with clean architecture to support long-term maintainability.

### Target Users

Fashion-conscious consumers looking for a modern, visually rich mobile shopping experience.

### High-Level Architecture Summary

The app follows **Clean Architecture** organized by feature modules. Each feature has three layers: **Domain** (entities, abstract repositories, use cases), **Data** (models, data sources, repository implementations), and **Presentation** (Cubits, pages, widgets). Cross-feature state synchronization is achieved through a singleton `ProductRepository` pattern. All API calls are intercepted by a `MockInterceptor` that returns mock responses, enabling full-featured development without a live backend.

---

## 2. Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| Flutter | SDK (stable) | Cross-platform UI framework |
| Dart | `>=3.10.4` | Programming language |
| `flutter_bloc` | `^8.1.6` | State management via Cubit pattern |
| `dio` | `^5.7.0` | HTTP networking with interceptor support |
| `get_it` | `^8.0.2` | Service locator for dependency injection |
| `shared_preferences` | `^2.3.3` | Key-value local storage for user data |
| `flutter_secure_storage` | `^9.2.2` | Encrypted storage for auth tokens |
| `cached_network_image` | `^3.4.1` | Image caching and loading |
| `shimmer` | `^3.0.0` | Shimmer loading placeholder effects |
| `equatable` | `^2.0.5` | Value equality for state classes |
| `intl` | `^0.19.0` | Internationalization and formatting |
| `cupertino_icons` | `^1.0.8` | iOS-style icon set |
| `flutter_lints` | `^6.0.0` | Static analysis and linting rules |

### Key Technical Decisions

- **State Management:** `flutter_bloc` (Cubit variant) was chosen over Provider/Riverpod for its explicit state classes with `Equatable`, clear separation of business logic, and `BlocBuilder`/`BlocListener` widgets for reactive UI.
- **Dependency Injection:** `get_it` as a service locator initializes singletons (storage, networking, navigation) at app startup. Feature-level cubits are provided via `BlocProvider` in the widget tree.
- **Networking:** `dio` with a custom `MockInterceptor` intercepts all HTTP requests and returns mock responses. This enables full-stack development without a backend.
- **Routing:** A custom `AppNavigator` (stack-based, using `ChangeNotifier`) manages top-level routes, while `TabNavigator` handles bottom navigation tabs. Page transitions use `Navigator.pushReplacement` and `pushAndRemoveUntil` for auth flows.

---

## 3. Architecture

### Pattern: Feature-First Clean Architecture

Each feature module is self-contained with three layers:

```
feature/
├── domain/          # Business rules — no dependencies on Flutter or external packages
│   ├── entities/    # Pure Dart classes representing business objects
│   ├── repositories/# Abstract interfaces defining data contracts
│   └── usecases/    # Single-responsibility business operations
├── data/            # Implementation details — API calls, storage, mapping
│   ├── models/      # DTOs with JSON serialization (extend domain entities)
│   ├── sources/     # Remote (Dio) and local (SharedPreferences) data sources
│   └── repositories/# Concrete implementations of domain repository interfaces
└── presentation/    # UI and state management
    ├── cubit/       # BLoC Cubits and state classes
    ├── pages/       # Full-screen page widgets
    └── widgets/     # Reusable feature-specific widgets
```

### Layer Responsibilities

**Domain Layer**
- Defines entities as immutable data classes with `Equatable`.
- Declares abstract repository interfaces that the data layer must implement.
- Contains use cases — each encapsulates a single business operation (e.g., `LoginUseCase`, `AddToCartUseCase`). Use cases call repository methods and return `Result<T>`.

**Data Layer**
- Models extend domain entities and add `toJson()`/`fromJson()` serialization.
- Data sources handle I/O: `RemoteSource` classes use Dio for HTTP, `LocalSource` classes use SharedPreferences.
- Repository implementations coordinate between remote and local sources, handle error mapping, and return `Result<T>`.

**Presentation Layer**
- Cubits hold business state and expose methods that trigger use cases.
- State classes are `Equatable` sealed hierarchies (e.g., `Initial`, `Loading`, `Loaded`, `Error`).
- Pages use `BlocBuilder` for reactive rebuilds and `BlocListener` for side effects (navigation, snackbars).

### Data Flow Between Layers

```
UI (Page/Widget)
  → Cubit.method()
    → UseCase.call()
      → Repository (abstract, resolved to impl)
        → DataSource (remote or local)
          → Returns Result<Model>
        ← Maps Model → Entity
      ← Returns Result<Entity>
    ← Emits new State
  ← BlocBuilder rebuilds UI
```

### Cross-Feature State Synchronization

A singleton `ProductRepository` holds the canonical list of `ProductModel` objects with mutable flags (`isFavorite`, `isInCart`, `cartQuantity`). When `CartCubit` or `FavoritesCubit` modify these flags, `HomeCubit` sees the changes because all cubits reference the same underlying objects. Domain entities use a proxy pattern (`HomeProductModel`) to delegate mutable field reads to the singleton.

---

## 4. State Management

### Strategy

Each feature has its own `Cubit<FeatureState>`. States follow a consistent sealed hierarchy:

```dart
abstract class FeatureState extends Equatable {}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final List<Entity> items;
  // ... computed getters
}
class FeatureError extends FeatureState {
  final String message;
}
```

### State Lifecycle

1. **Initial** — Cubit created, no data loaded.
2. **Loading** — Async operation in progress. UI shows loading indicators.
3. **Loaded** — Data available. UI renders content. Contains helper methods (e.g., `getProductById`, `isFavorite`).
4. **Error** — Operation failed. UI shows error message with optional retry.

### How UI Reacts to State

- `BlocBuilder<Cubit, State>` — Rebuilds widget subtree when state changes. Used for rendering lists, buttons, and content areas.
- `BlocListener<Cubit, State>` — Triggers side effects (navigation, snackbars) without rebuilding. Used in login/register flows.
- Nested `BlocBuilder` — Used when a widget depends on multiple cubits (e.g., favorites page listens to both `FavoritesCubit` and `CartCubit` to show reactive "Add to Cart" buttons).

### Error Handling Strategy

All async operations return `Result<T>` (sealed class with `Success<T>` and `Failure<String>`). Cubits pattern-match on results:

```dart
final result = await _useCase(params);
switch (result) {
  case Success(data: final value):
    emit(Loaded(value));
  case Failure(message: final msg):
    emit(Error(msg));
}
```

Repository implementations map raw error strings to user-friendly messages (e.g., `"Invalid credentials"` → `"Invalid email or password"`).

### Loading States

- `AuthLoading` disables the sign-in button and changes text to "Signing In...".
- `HomeLoading` / `CartLoading` / `FavoritesLoading` show a centered `CircularProgressIndicator` with the app's accent color.
- Splash page awaits auth initialization completion before allowing navigation.

### Edge Cases

- **Auth race condition:** Splash page's "Start Your Journey" button awaits `authCubit.stream.firstWhere(...)` if the cubit is still in `AuthLoading` or `AuthInitial` state, preventing premature navigation.
- **Empty states:** Cart page shows "Your cart is empty" with icon. Favorites page shows "No favourites yet" with icon.
- **Null user:** Cart and favorites operations short-circuit if `userId` is null, emitting appropriate errors or empty states.

---

## 5. API & Data Flow

### API Structure

All HTTP requests go through Dio to `https://mock.clothing.api`. A `MockInterceptor` intercepts every request before it hits the network and returns mock responses.

### Endpoints

| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | `/auth/login` | Authenticate user with email/password |
| `POST` | `/auth/register` | Register new user |
| `GET` | `/auth/profile` | Fetch user profile (requires Bearer token) |
| `GET` | `/home` | Load home page sections and products |
| `GET` | `/categories` | List product categories |
| `GET` | `/products` | List all products (filterable by category) |
| `GET` | `/products/{id}` | Get single product detail |
| `GET` | `/favorites` | Get user's favorite products |
| `POST` | `/favorites/toggle` | Toggle favorite status |
| `GET` | `/cart` | Get user's cart |
| `POST` | `/cart/add` | Add product to cart |
| `POST` | `/checkout` | Place an order |
| `GET` | `/orders` | Get order history |

### Mock Credentials

```
Email:    test@clothingapp.com
Password: 12345678
Token:    mock-jwt-token-123456
```

### Request/Response Models

Each feature has dedicated model classes:

- **Auth:** `AuthUserModel` (extends `User` entity) with `fromJson()`, `fromAuthResponse()`, `toJson()`. `AuthResponseModel` parses the login/register response containing user data and token.
- **Home:** `HomeSectionModel` maps API sections to `HomeSection` entities. `HomeProductModel` proxies mutable state from the singleton `ProductModel`.
- **Cart:** `CartItemModel` (extends `CartItemEntity`) with product details and quantity. `CartModel` (extends `CartEntity`) with items list, total, and item count.
- **Favorites:** `FavoriteItemModel` (extends `FavoriteItemEntity`) with product metadata.
- **Product:** `ProductDetailModel` (extends `ProductDetail` entity) with full specifications. `VariantModel` for product variants.

### Mapping Strategy (DTO → Entity)

Models extend their corresponding domain entities directly. Factory constructors (`fromJson`, `fromAuthResponse`) handle deserialization. The `toJson()` methods handle serialization for local storage. Domain entities are pure Dart classes with no serialization logic.

### Repository Pattern

```dart
// Domain — abstract contract
abstract class AuthRepository {
  Future<Result<User>> login({required String email, required String password});
  Future<Result<void>> logout();
  Future<Result<User?>> getSavedUser();
  // ...
}

// Data — concrete implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource remoteSource;
  final AuthLocalSource localSource;

  @override
  Future<Result<User>> login({required String email, required String password}) async {
    final result = await remoteSource.signIn(email: email, password: password);
    switch (result) {
      case Success(data: final user):
        await localSource.saveUser(user);  // Persist to SharedPreferences
        return Success(user);
      case Failure(message: final message):
        return Failure(_mapErrorMessage(message));
    }
  }
}
```

### Caching Strategy

- **Auth session:** User JSON stored in SharedPreferences (`saved_user` key), token in FlutterSecureStorage (`auth_token` key). Restored on app startup via `AuthCubit.initialize()`.
- **User data:** Favorites (Set of product IDs), cart (Map of productId → quantity), and orders stored in SharedPreferences keyed by userId (e.g., `user_cart_{userId}`).
- **Product data:** In-memory singleton. No disk caching for product catalog — loaded fresh from mock data on each app session.

---

## 6. UI & UX Logic

### Widget Structure Strategy

- **Pages** are full-screen `StatefulWidget`s that own `BlocBuilder`/`BlocListener` wiring and layout scaffolding.
- **Widgets** are extracted reusable components within each feature (e.g., `ProductCardWidget`, `CartItemCard`, `FavoriteProductHighlightCard`).
- Private helper widgets (prefixed with `_`) encapsulate sub-sections within pages (e.g., `_ProductImage`, `_CustomActionButton`).

### Reusable Components

| Widget | Location | Purpose |
|---|---|---|
| `AppButton` | `core/widgets/app_button.dart` | Primary CTA button with optional trailing icon |
| `PrimaryActionButton` | `core/widgets/app_button.dart` | Full-width responsive action button |
| `CustomFlexibleAppBar` | `core/widgets/appbar.dart` | Fixed-height app bar with leading, title, and action slots |
| `CustomBottomNavBar` | `core/widgets/bottom_navigation_bar.dart` | 4-tab floating bottom nav with accent selection |
| `AuthTextField` | `auth/presentation/widgets/auth_form_field.dart` | Styled text field for auth forms with password toggle |
| `CategorySelector` | `home/presentation/widgets/category_selector.dart` | Horizontal chip-style category filter |
| `ProductCardWidget` | `home/presentation/widgets/product_card.dart` | Product grid card with image, price, favorite/cart actions |
| `FavoriteProductHighlightCard` | `favorites/presentation/widgets/favorite_item_card.dart` | Glassmorphic favorite item card with reactive cart button |
| `ProductDetailsBottomSheet` | `product/presentation/widgets/product_details_screen.dart` | Modal bottom sheet with full product details |
| `QuantitySelector` | `cart/presentation/widgets/quantity_selector.dart` | Increment/decrement quantity control |
| `CartSummaryBar` | `cart/presentation/widgets/cart_summary.dart` | Fixed bottom bar with total and checkout button |

### Theming Strategy

**Color Palette** (`AppColors`):

| Name | Hex | Usage |
|---|---|---|
| `white` | `#FFFFFF` | Primary text, icon color on dark backgrounds |
| `alabasterGrey` | `#F2F2F2` | Secondary text, muted content |
| `black` | `#000000` | Scaffold backgrounds, primary surface |
| `carbonBlack` | `#1C1C1C` | Card backgrounds, elevated surfaces, dialog background |
| `raspberryPlum` | `#8B1E3F` | Primary accent — buttons, highlights, active states |
| `blackberryCream` | `#4B0F2E` | Glassmorphism card backgrounds (with alpha) |
| `royalPlum` | `#702963` | Tertiary accent |

**Glassmorphism:** Achieved via `ClipRRect` + `BackdropFilter(ImageFilter.blur)` + semi-transparent `blackberryCream` containers. Applied to product detail bottom sheet, favorite item cards, and promotional widgets.

**Theme Configuration:** The app uses `ThemeData` with `useMaterial3: true` and `Brightness.dark`. Custom styling is applied per-widget using `AppColors` constants rather than a global theme override.

### Responsiveness Strategy

- `MediaQuery.of(context).size` is used for proportional sizing (e.g., button widths at `screenWidth * 0.7`, logo at `screenWidth * 0.3`).
- Product grids use `GridView.builder` with `crossAxisCount: 2` and `childAspectRatio: 0.65` for consistent card proportions.
- Bottom sheets are sized at `screenHeight * 0.85`.
- Padding and margins use fixed values from the design system (16, 20, 24dp).

### Accessibility Considerations

- **Not explicitly implemented.** No `Semantics` widgets, `excludeSemantics`, or `labeledBy` annotations are present. Screen reader support relies on default Material widget accessibility. This is a known gap.

### Navigation Flow

```
SplashPage
  ├── [Authenticated] → HomePage
  └── [Not Authenticated] → LoginPage
                              ├── [Success] → HomePage
                              └── [Register] → RegisterPage → LoginPage

HomePage (with bottom nav)
  ├── Home tab (default)
  │   ├── Product card tap → ProductDetailsBottomSheet
  │   └── Logout icon → Confirmation Dialog → SplashPage
  ├── Cart tab → CartPage → CheckoutPage → OrderSuccessPage
  ├── Favorites tab → FavoritesPage
  └── Profile tab → ProfilePage → OrdersHistoryPage
```

---

## 7. User Journey

### App Launch

1. `main()` initializes Flutter bindings and calls `setupDependencies()` to register singletons (SharedPreferences, LocalStorage, SecureStorage, ApiClient, AppNavigator, TabNavigator) in GetIt.
2. `VogueVibeApp` builds `MultiBlocProvider` providing all 8 cubits globally.
3. `AuthCubit` is created and `initialize()` is called immediately — it reads `saved_user` from SharedPreferences and emits `AuthAuthenticated` or `AuthUnauthenticated`.
4. `SplashPage` renders with logo, tagline, and "Start Your Journey" button.

### Authentication Flow

**First-time user:**

1. User taps "Start Your Journey" → `AuthCubit.isAuthenticated` is `false` → navigates to `LoginPage`.
2. User enters credentials and taps "Sign In".
3. `AuthCubit.login()` → `LoginUseCase` → `AuthRepositoryImpl.login()` → `AuthRemoteSource.signIn()` (Dio POST intercepted by `MockInterceptor`).
4. On success: user JSON saved to SharedPreferences, token saved to SecureStorage, `AuthAuthenticated` emitted.
5. `BlocListener` on `LoginPage` catches `AuthAuthenticated` → `Navigator.pushReplacement` to `HomePage`.

**Returning user:**

1. User taps "Start Your Journey" → button awaits auth initialization if still loading → `AuthCubit.isAuthenticated` is `true` → navigates directly to `HomePage`.
2. All user-specific data (cart, favorites) loads from SharedPreferences keyed by userId.

### Main Features Usage

1. **Browsing:** Home page loads all products grouped by category sections. Category selector filters the view. Product cards show thumbnail, title, price, with favorite and cart action buttons.
2. **Product Details:** Tapping a product card opens a glassmorphic bottom sheet with full image, description, specifications, and reactive "Add to Cart" / favorite toggle buttons.
3. **Cart:** Adding products updates the cart badge. Cart page shows items with quantity controls. Cart summary shows total with checkout button.
4. **Favorites:** Heart icon toggles favorite status. Favorites page lists all favorited products with reactive "Add to Cart" / "Added To Cart" buttons.
5. **Checkout:** Cart summary leads to checkout with order placement.
6. **Profile:** User profile with order history.

### Sign Out

1. User taps logout icon in home page app bar.
2. Confirmation dialog appears: "Are you sure you want to sign out?"
3. "Cancel" dismisses the dialog. "Sign Out" triggers:
   - `AuthCubit.logout()` → `LogoutUseCase` → `AuthRepositoryImpl.logout()` → `AuthLocalSource.clearUser()` (removes `saved_user` and `auth_token` from storage).
   - Navigation stack cleared, replaced with `SplashPage`.
4. Next "Start Your Journey" tap goes to `LoginPage`.

### Error Scenarios

- **Invalid credentials:** `MockInterceptor` returns 401 → `AuthError("Invalid email or password")` → SnackBar displayed on login page.
- **Empty form fields:** Client-side validation shows "Please enter email and password" SnackBar before any API call.
- **Cart/Favorites with no user:** Operations short-circuit with error message "Please login to add items to cart".

---

## 8. Features Breakdown

### Auth

| Aspect | Detail |
|---|---|
| **What it does** | Handles user login, registration, session persistence, and logout |
| **Domain** | `User` entity, `AuthRepository` interface, `LoginUseCase`, `RegisterUseCase`, `LogoutUseCase`, `GetProfileUseCase` |
| **Data** | `AuthUserModel`, `AuthResponseModel`, `AuthRemoteSource` (Dio + MockInterceptor), `AuthLocalSource` (SharedPreferences), `AuthRepositoryImpl` |
| **Presentation** | `AuthCubit` (5 states), `LoginPage`, `RegisterPage`, `AuthTextField` |
| **Storage** | User JSON in SharedPreferences, token in FlutterSecureStorage |

### Home

| Aspect | Detail |
|---|---|
| **What it does** | Displays product catalog grouped by category sections with search, filtering, and product actions |
| **Domain** | `HomeSection` entity (with `Product` sub-entities), `HomeRepository` interface, `GetHomeDataUseCase` |
| **Data** | `HomeSectionModel`, `HomeProductModel` (proxy pattern), `HomeDataSource`, `HomeRepositoryImpl` |
| **Presentation** | `HomeCubit`, `HomePage` (with app bar, search, category selector, product grid), `ProductCardWidget`, `CategorySelector`, `OfferWidget` |
| **Cross-feature** | Reads `CartCubit` and `FavoritesCubit` state for reactive button rendering |

### Product

| Aspect | Detail |
|---|---|
| **What it does** | Provides product detail views and product listing capabilities |
| **Domain** | `Product`, `ProductDetail`, `Variant` entities, `ProductFeatureRepository` interface, `GetProductsUseCase`, `GetProductDetailUseCase` |
| **Data** | `ProductFeatureModel`, `ProductDetailModel`, `VariantModel`, `ProductDataSource`, `ProductFeatureRepositoryImpl` |
| **Presentation** | `ProductsCubit`, `ProductDetailCubit`, `ProductDetailsBottomSheet` (glassmorphic modal with reactive cart/favorite buttons) |

### Cart

| Aspect | Detail |
|---|---|
| **What it does** | Manages shopping cart — add, remove, increment, decrement, clear, calculate totals |
| **Domain** | `CartEntity`, `CartItemEntity`, `CartFeatureRepository` interface, `GetCartUseCase`, `AddToCartUseCase` |
| **Data** | `CartModel`, `CartItemModel`, `CartDataSource`, `CartRepositoryImpl` |
| **Presentation** | `CartCubit` (with `isInCart`, `getCartQuantity` helpers), `CartPage`, `CartItemCard`, `CartSummaryBar`, `QuantitySelector` |
| **Storage** | Cart map (`productId → quantity`) in SharedPreferences keyed by userId |

### Favorites

| Aspect | Detail |
|---|---|
| **What it does** | Toggle and display favorite products, with reactive cart integration |
| **Domain** | `FavoriteItemEntity`, `FavoritesRepository` interface, `GetFavoritesUseCase`, `ToggleFavoriteUseCase` |
| **Data** | `FavoriteItemModel`, `FavoritesDataSource`, `FavoritesRepositoryImpl` |
| **Presentation** | `FavoritesCubit` (with `isFavorite` helper), `FavoritesPage`, `FavoriteProductHighlightCard` (glassmorphic card with reactive "Add to Cart" / "Added To Cart" button) |
| **Storage** | Favorite product IDs set in SharedPreferences keyed by userId |

### Checkout

| Aspect | Detail |
|---|---|
| **What it does** | Handles order placement and order retrieval |
| **Domain** | `OrderEntity`, `CheckoutRepository` interface, `PlaceOrderUseCase`, `GetOrdersUseCase` |
| **Data** | `CheckoutOrderModel`, `CheckoutResponseModel`, `CheckoutDataSource`, `CheckoutRepositoryImpl` |
| **Presentation** | `CheckoutCubit`, `CheckoutPage`, `OrderSuccessPage`, `OrderSummaryCard`, `PaymentMethodWidget` |

### Profile

| Aspect | Detail |
|---|---|
| **What it does** | Displays user profile information and order history |
| **Domain** | `UserProfile`, `ProfileOrder` entities, `ProfileRepository` interface, `GetUserProfileUseCase`, `GetOrderHistoryUseCase` |
| **Data** | `UserProfileModel`, `ProfileOrderModel`, `ProfileDataSource`, `ProfileRepositoryImpl` |
| **Presentation** | `ProfileCubit`, `ProfilePage`, `OrdersHistoryPage`, `ProfileHeader`, `OrderHistoryCard` |

### Splash

| Aspect | Detail |
|---|---|
| **What it does** | Entry point screen with auth-aware routing |
| **Presentation** | `SplashPage` — shows logo, tagline, and "Start Your Journey" button that routes to `HomePage` (authenticated) or `LoginPage` (unauthenticated) |

---

## 9. Performance Considerations

### Widget Rebuild Optimization

- **Equatable states:** All cubit states extend `Equatable`, preventing unnecessary rebuilds when the same state is emitted.
- **Scoped BlocBuilders:** `BlocBuilder` widgets are placed as deep in the widget tree as possible. For example, the cart button in `ProductDetailsBottomSheet` wraps only the action buttons section in `BlocBuilder<CartCubit, CartState>`, not the entire sheet.
- **Const constructors:** Widgets and text styles use `const` where possible to enable Flutter's compile-time constant optimization.

### Async Handling

- All I/O operations are `async/await` with `Result<T>` return types — no uncaught exceptions from data layer operations.
- `AuthCubit.initialize()` is fire-and-forget at startup. The splash page's button handler awaits the cubit's stream if initialization hasn't completed, preventing race conditions.
- `context.mounted` checks guard navigation after async gaps.

### Memory Considerations

- **Singleton `ProductRepository`** holds the product list once in memory. All cubits reference the same objects rather than creating copies.
- **AnimatedContainer** used for button state transitions (cart toggle) with 250ms duration — lightweight compared to custom animation controllers.
- **No image pre-loading.** Product images are loaded from local assets (`AssetImage`) which Flutter caches in the image cache automatically.

### Known Gaps

- No `ListView` item recycling optimization (e.g., `AutomaticKeepAliveClientMixin`) for long lists.
- No pagination — all products load at once. Acceptable for the current 17-item catalog but would need pagination for scale.
- `SharedPreferences.getInstance()` is called per-operation in `AuthLocalSource` rather than using the singleton from DI. This is a minor inefficiency.

---

## 10. Security Considerations

### API Security

- All API calls include a Bearer token in the `Authorization` header via Dio's auth interceptor (`ApiClient._authInterceptor`).
- Token is injected automatically — individual data sources don't handle auth headers.
- Currently mocked — no real API validation occurs.

### Token Handling

- JWT token stored in `FlutterSecureStorage` (AES-encrypted on Android, Keychain on iOS) via `SecureStorage.saveToken()`.
- Token retrieved on each API call by the auth interceptor.
- Token cleared on logout via `SecureStorage.deleteToken()`.

### Local Storage Security

- **Sensitive data:** Auth token uses `FlutterSecureStorage` (encrypted).
- **Non-sensitive data:** User profile JSON, cart, and favorites use `SharedPreferences` (unencrypted but app-sandboxed).
- User data is keyed by userId (`user_cart_{userId}`) to prevent cross-user data leakage.

### Validation Strategy

- **Client-side:** Login/register forms validate for empty fields before triggering API calls.
- **Server-side (mock):** `MockInterceptor` validates email/password match and returns appropriate error codes (401 for invalid credentials, 409 for duplicate email).
- **Error mapping:** Raw API error strings are mapped to user-friendly messages in repository implementations.

### Known Gaps

- No input sanitization beyond empty checks (no email format validation, no password strength requirements).
- User JSON stored in SharedPreferences is not encrypted — contains name, email, phone. Consider migrating to FlutterSecureStorage if storing PII.
- No token expiration or refresh logic.

---

## 11. Scalability & Maintainability

### How This Architecture Supports Scaling

**Adding a new feature** follows a consistent template:

1. Create `features/new_feature/domain/` with entity, abstract repository, and use case(s).
2. Create `features/new_feature/data/` with model(s), data source(s), and repository implementation.
3. Create `features/new_feature/presentation/` with cubit, state, page(s), and widget(s).
4. Add `BlocProvider` in `app.dart`'s `MultiBlocProvider`.
5. Add route to `AppRoute` enum and `_buildCurrentPage()` switch.

Each feature is fully isolated — changes to one feature's data layer don't affect others. The domain layer has zero external dependencies.

### Dependency Direction

```
Presentation → Domain ← Data
```

The domain layer is the stable core. Presentation depends on domain (via cubit → use case → repository interface). Data depends on domain (implements repository interface). Presentation and data never depend on each other directly.

### Testing Strategy

**Not currently implemented.** The project has no test files. However, the architecture is test-friendly:

- **Unit tests:** Use cases and repository implementations can be tested by mocking abstract repository interfaces and data sources.
- **Cubit tests:** `bloc_test` package can verify state emissions for each cubit method.
- **Widget tests:** Pages can be tested with `BlocProvider.value` and mock cubits.
- **Integration tests:** The `MockInterceptor` already simulates API behavior, which could be reused in integration tests.

---

## 12. Project Structure Tree

```
voguevibe_app/
├── pubspec.yaml
├── PROJECT_DOCUMENTATION.md
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── app_shell.dart
│   │   └── di.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── api_constants.dart
│   │   │   └── app_constants.dart
│   │   ├── navigation/
│   │   │   ├── app_navigator.dart
│   │   │   ├── app_route.dart
│   │   │   ├── navigation_state.dart
│   │   │   └── tab_navigator.dart
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   └── api_exception.dart
│   │   ├── storage/
│   │   │   ├── local_storage.dart
│   │   │   └── secure_storage.dart
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   ├── app_theme.dart
│   │   │   └── glass_decoration.dart
│   │   ├── utils/
│   │   │   └── result.dart
│   │   └── widgets/
│   │       ├── app_button.dart
│   │       ├── app_text_field.dart
│   │       ├── appbar.dart
│   │       ├── bottom_navigation_bar.dart
│   │       ├── glass_container.dart
│   │       └── loading_indicator.dart
│   ├── data/
│   │   ├── managers/
│   │   │   └── user_data_manager.dart
│   │   ├── mock_data/
│   │   │   └── products_data.dart
│   │   ├── models/
│   │   │   ├── product_model.dart
│   │   │   ├── order_model.dart
│   │   │   └── user_model.dart
│   │   ├── repositories/
│   │   │   ├── product_repository.dart
│   │   │   └── auth_repository.dart
│   │   └── services/
│   │       ├── mock_interceptor.dart
│   │       └── auth_service.dart
│   └── features/
│       ├── splash/
│       │   └── presentation/pages/splash_page.dart
│       ├── auth/
│       │   ├── domain/
│       │   │   ├── entities/user.dart
│       │   │   ├── repositories/auth_repository.dart
│       │   │   └── usecases/
│       │   │       ├── login_usecase.dart
│       │   │       ├── register_usecase.dart
│       │   │       ├── logout_usecase.dart
│       │   │       └── get_profile_usecase.dart
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── user_model.dart
│       │   │   │   └── auth_response_model.dart
│       │   │   ├── repositories/auth_repository_impl.dart
│       │   │   └── sources/
│       │   │       ├── auth_remote_source.dart
│       │   │       └── auth_local_source.dart
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── auth_cubit.dart
│       │       │   └── auth_state.dart
│       │       ├── pages/
│       │       │   ├── login_page.dart
│       │       │   └── register_page.dart
│       │       └── widgets/auth_form_field.dart
│       ├── home/
│       │   ├── domain/
│       │   │   ├── entities/home_section.dart
│       │   │   ├── repositories/home_repository.dart
│       │   │   └── usecases/get_home_data_usecase.dart
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── home_response_model.dart
│       │   │   │   └── home_section_model.dart
│       │   │   ├── repositories/home_repository_impl.dart
│       │   │   └── sources/home_remote_source.dart
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── home_cubit.dart
│       │       │   └── home_state.dart
│       │       ├── pages/
│       │       │   ├── home_page.dart
│       │       │   └── category_page.dart
│       │       └── widgets/
│       │           ├── category_section.dart
│       │           ├── category_selector.dart
│       │           ├── homesearch.dart
│       │           ├── offer_widget.dart
│       │           └── product_card.dart
│       ├── product/
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── product.dart
│       │   │   │   ├── product_detail.dart
│       │   │   │   └── variant.dart
│       │   │   ├── repositories/product_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_product_detail_usecase.dart
│       │   │       └── get_products_usecase.dart
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── product_model.dart
│       │   │   │   ├── product_detail_model.dart
│       │   │   │   └── variant_model.dart
│       │   │   ├── repositories/product_repository_impl.dart
│       │   │   └── sources/product_remote_source.dart
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── product_detail_cubit.dart
│       │       │   ├── product_detail_state.dart
│       │       │   ├── products_cubit.dart
│       │       │   └── products_state.dart
│       │       ├── pages/product_detail_page.dart
│       │       └── widgets/product_details_screen.dart
│       ├── cart/
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   │   ├── cart.dart
│       │   │   │   └── cart_item.dart
│       │   │   ├── repositories/cart_repository.dart
│       │   │   └── usecases/
│       │   │       ├── add_to_cart_usecase.dart
│       │   │       └── get_cart_usecase.dart
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── cart_model.dart
│       │   │   │   └── cart_item_model.dart
│       │   │   ├── repositories/cart_repository_impl.dart
│       │   │   └── sources/cart_remote_source.dart
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── cart_cubit.dart
│       │       │   └── cart_state.dart
│       │       ├── pages/cart_page.dart
│       │       └── widgets/
│       │           ├── cart_item_card.dart
│       │           ├── cart_summary.dart
│       │           └── quantity_selector.dart
│       ├── favorites/
│       │   ├── domain/
│       │   │   ├── entities/favorite_item.dart
│       │   │   ├── repositories/favorites_repository.dart
│       │   │   └── usecases/
│       │   │       ├── get_favorites_usecase.dart
│       │   │       └── toggle_favorite_usecase.dart
│       │   ├── data/
│       │   │   ├── models/favorite_item_model.dart
│       │   │   ├── repositories/favorites_repository_impl.dart
│       │   │   └── sources/favorites_remote_source.dart
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── favorites_cubit.dart
│       │       │   └── favorites_state.dart
│       │       ├── pages/favorites_page.dart
│       │       └── widgets/favorite_item_card.dart
│       ├── checkout/
│       │   ├── domain/
│       │   │   ├── entities/order.dart
│       │   │   ├── repositories/checkout_repository.dart
│       │   │   └── usecases/
│       │   │       ├── place_order_usecase.dart
│       │   │       └── get_orders_usecase.dart
│       │   ├── data/
│       │   │   ├── models/
│       │   │   │   ├── order_model.dart
│       │   │   │   └── checkout_response_model.dart
│       │   │   ├── repositories/checkout_repository_impl.dart
│       │   │   └── sources/checkout_remote_source.dart
│       │   └── presentation/
│       │       ├── cubit/
│       │       │   ├── checkout_cubit.dart
│       │       │   └── checkout_state.dart
│       │       ├── pages/
│       │       │   ├── checkout_page.dart
│       │       │   └── order_success_page.dart
│       │       └── widgets/
│       │           ├── order_summary_card.dart
│       │           └── payment_method.dart
│       └── profile/
│           ├── domain/
│           │   ├── entities/
│           │   │   ├── user_profile.dart
│           │   │   └── order.dart
│           │   ├── repositories/profile_repository.dart
│           │   └── usecases/
│           │       ├── get_user_profile_usecase.dart
│           │       ├── update_profile_usecase.dart
│           │       └── get_order_history_usecase.dart
│           ├── data/
│           │   ├── models/
│           │   │   ├── user_profile_model.dart
│           │   │   └── order_model.dart
│           │   ├── repositories/profile_repository_impl.dart
│           │   └── sources/profile_remote_source.dart
│           └── presentation/
│               ├── cubit/
│               │   ├── profile_cubit.dart
│               │   └── profile_state.dart
│               ├── pages/
│               │   ├── profile_page.dart
│               │   └── orders_history_page.dart
│               └── widgets/
│                   ├── profile_header.dart
│                   └── order_history_card.dart
└── assets/
    └── images/
        ├── logo/logo.png
        ├── splash/splash.png
        ├── future/future1-5.png
        ├── new/new1-5.png
        ├── trending/trend1-7.png
        └── offer/offer.jpg
```

---

## 13. Setup & Run Instructions

### Prerequisites

- Flutter SDK (stable channel)
- Dart SDK `>=3.10.4`
- Android Studio / VS Code with Flutter extensions
- An Android emulator or iOS simulator (or physical device)

### Environment Setup

```bash
# Verify Flutter installation
flutter doctor

# Clone the repository
git clone https://github.com/1997-dot/Voguevibe.git
cd Voguevibe/voguevibe_app

# Install dependencies
flutter pub get
```

### Required Environment Variables

None. The app uses a `MockInterceptor` that intercepts all API calls — no backend or API keys required.

### Run the Project

```bash
# Run in debug mode
flutter run

# Run on a specific device
flutter devices
flutter run -d <device_id>

# Run with hot reload enabled (default in debug)
flutter run --debug
```

### Build Release

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (requires macOS)
flutter build ios --release
```

### Test Credentials

```
Email:    test@clothingapp.com
Password: 12345678
```

---

*Generated from source code analysis. Last updated: February 2026.*
