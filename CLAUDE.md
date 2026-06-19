# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Test Commands

```bash
# Build (Debug)
xcodebuild -project FinalFoodies.xcodeproj -scheme FinalFoodies -configuration Debug build

# Run all tests
xcodebuild -project FinalFoodies.xcodeproj -scheme FinalFoodies test

# Run unit tests only
xcodebuild -project FinalFoodies.xcodeproj -testPlan FinalFoodies -project FinalFoodies.xcodeproj test

# Build for release
xcodebuild -project FinalFoodies.xcodeproj -scheme FinalFoodies -configuration Release build
```

Requires Xcode 14+ and iOS 17.1 SDK. No CocoaPods — all dependencies are Swift Package Manager.

## Environment Setup

Two external secrets are required at runtime:

- **`GoogleService-Info.plist`** — must be added to `FinalFoodies/` from the Firebase console (not in repo). Enables Firebase Auth, Firestore, Storage, Crashlytics, and Analytics.
- **`OPENAI_API_TOKEN`** — injected as a launch environment variable or pre-stored in Keychain. `AppDelegate` reads it and passes it to `TokenManager` (Keychain-backed), which `ChatGPTService` consumes.

## Architecture

**MVVM with protocol-driven dependency injection.** Views own no logic; ViewModels are `@ObservableObject`; services are injected via protocols so unit tests can swap in mocks.

### Data flow

```
Views → ViewModels → Services/Networking → Xano API / Firebase / OpenAI
```

Root state is held in two `@StateObject`s created in `FinalFoodiesApp.swift` and shared as `@EnvironmentObject`:
- `AuthViewModel` — Firebase + Google Sign-In session state
- `FavoritesViewModel<Restaurant>` — Firestore-backed favorites, keyed per user

### Key layers

**Models** (`FinalFoodies/Models/`)
- `Restaurant` — primary Codable/Hashable data model with all fields from the Xano API.
- `RestaurantDataConverter` — transforms API response shapes.

**Networking** (`FinalFoodies/Networking/`)
- `NetworkManager` (implements `FetchAPI`) — paginates Xano restaurant endpoint using a `PageSynchronizer` actor and a semaphore (max 10 concurrent requests). Results are cached per page.
- `ChatGPTService` (implements `ChatGPTServiceProtocol`) — wraps the MacPaw OpenAI Swift package; has in-memory + persistent response cache; respects `NetworkMonitor` offline state.
- `ImageCache` — `NSCache`-backed async image loading shared across the app.

**ViewModels** (`FinalFoodies/ViewModels/`)
- `FetchRestaurantsViewModel` — fetches restaurants and coordinates `ClosestRestaurantSorter` (sorts by CLLocation distance with rate limiting) and `GeocodeCacheManager` (AppStorage-backed geocode cache).
- `DetailsPageViewModel` / `DirectionsViewModel` — detail screen and MapKit directions state.
- `NearbyMapSearchViewModel` — map-based proximity search.
- `SearchViewModel` / `PromptsViewMode` — text search and AI prompt flows.

**Views** (`FinalFoodies/Views/`)
- `Authentication/` — `AuthView`, `LoginView`, `SignUpView`.
- `MainScreens/` — `TabViewUI` (4-tab root), `HomePage`, `FoodiezMapView`, `FavoritesResultsView`, `DetailsPage`, `DirectionsView`, `SettingsView`, `CityPromptsView`, `NearbySearchView`.
- `Components/` — `CustomProgressView`, `NoInternetPopup`.
- `Alerts/` — empty-state and offline-state views.

**UIKit bridges** (`FinalFoodies/UIKit/`) — `ShareFuncUiKit`, `WebviewUIkit` for sheet and web view functionality not available in SwiftUI.

### Protocols to know

| Protocol | Conformers | Used by |
|---|---|---|
| `FetchAPI` | `NetworkManager`, `MockFetchAPI` | `FetchRestaurantsViewModel` |
| `URLSessionProtocol` | `URLSession`, mocks | `NetworkManager` |
| `ChatGPTServiceProtocol` | `ChatGPTService` | `SearchViewModel`, `PromptsViewMode` |
| `Authenticator` | `AuthViewModel` | Auth views |
| `FirebaseManager` | Firestore wrapper | `FavoritesViewModel` |

### Caching layers (multi-level)

1. Paginated API responses — in-memory `[Int: [Restaurant]]` inside `NetworkManager`
2. Images — `ImageCache` (`NSCache`)
3. Geocoding — `GeocodeCacheManager` (`AppStorage` / UserDefaults)
4. ChatGPT responses — in-memory dictionary + persistent storage in `ChatGPTService`

## Dependencies (SPM)

| Package | Purpose |
|---|---|
| Firebase iOS SDK `~10.15` | Auth, Firestore, Storage, Analytics, Crashlytics |
| GoogleSignIn-iOS `≥7.0` | OAuth |
| OpenAI (MacPaw) `≥0.2.5` | ChatGPT API |
| KeychainSwift `≥20.0` | Secure token storage |

## Testing

Tests live in `FinalFoodiesUnitTests/` (XCTest). Key files:
- `RestaurantFetcher.swift` — uses `MockFetchAPI` conforming to `FetchAPI`; shows the pattern for injecting mock network layers.
- `FoodiesTests.swift` — `NetworkManager` baseline tests.
- `NavigationLogicTests.swift` — navigation state tests (mostly skeleton, good place to expand).

UI tests are in `FinalFoodiesUITests/` and cover launch scenarios.
