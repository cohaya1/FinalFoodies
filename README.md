# CraveCart AI

> Turn a craving into a cheap meal — and prove how much you saved versus delivery.

CraveCart AI is an iOS app being grown out of the FinalFoodies codebase. Its one
repeatable action:

```
craving + budget + pantry  →  3 meal options  →  grocery list  →  money saved
```

The product is deliberately small. We are building the smallest useful app that
proves people want "craving → cheap meal → grocery list → savings," then expanding
only once that habit is validated.

## The core loop (MVP)

1. User enters a craving (and optional budget / servings).
2. App returns **3 meal paths**: **Cook It Cheap**, **Lazy Grocery**, **Pickup Alternative**.
3. App builds a grocery list from the chosen meal.
4. User saves the meal.
5. App shows estimated savings vs. delivery.

## MVP scope (5 screens)

| Screen | Purpose |
|---|---|
| Home / Craving input | Enter craving + budget |
| Meal Results | The 3 meal paths + savings line |
| Grocery List | Ingredients to buy |
| Pantry | What the user already has |
| Saved Meals | Meals kept for later |

### Explicitly deferred (YAGNI — not now)

Grocery price comparison, restaurant ordering, receipt scanner, Apple Health,
family mode, creator marketplace, B2B trend dashboards, real-time delivery
estimates, complex macro tracking, social features, Android, a separate backend,
and any autonomous/multi-agent AI. These return only after product-market
validation.

## Architecture

Local-first SwiftUI app calling a client-side AI adapter. No backend yet.

```
View → ViewModel → UseCase → Repository → DataSource (AI adapter / SwiftData)
```

- **Views** are dumb; they bind to a ViewModel.
- **ViewModels** (`@MainActor`, `ObservableObject`) hold UI state only.
- **UseCases** hold one business action each (`GenerateMealOptionsUseCase`, `EstimateSavingsUseCase`).
- **Repositories** hide where data comes from behind a protocol.
- **Adapters** wrap external services (`OpenAIMealGenerationService` wraps the
  existing `ChatGPTService`) so the app is not locked to one AI vendor and
  everything is mockable (DIP).
- **DTO ⇄ domain** mapping (`MealOptionMapper`) keeps the AI JSON shape out of
  the domain.
- **Manual DI** via `AppContainer` — no DI framework (KISS).

New CraveCart code lives under `FinalFoodies/CraveCart/`
(`Domain/`, `Data/`, `Features/`, `App/`); tests under
`FinalFoodiesUnitTests/CraveCart/`.

### Tech stack

SwiftUI · MVVM + UseCases + Repository · SwiftData (persistence, upcoming
slices) · manual dependency injection · client-side OpenAI adapter
(reuses `ChatGPTService`, `TokenManager`, `NetworkMonitor`) · XCTest.

## Build & test

```bash
# Build
xcodebuild -project FinalFoodies.xcodeproj -scheme FinalFoodies -configuration Debug build

# Run tests (incl. CraveCart unit tests)
xcodebuild -project FinalFoodies.xcodeproj -scheme FinalFoodies test
```

Requires Xcode 14+ / iOS 17.1 SDK and an `OPENAI_API_TOKEN` (launch env var or
Keychain) plus `GoogleService-Info.plist`. See `CLAUDE.md` for environment setup.

## How we build it: the slice loop

Development proceeds one **vertical slice** at a time, test-first, via the
`cravecart-slice` skill (see `.claude/skills/cravecart-slice/`):

```
/loop /cravecart-slice
```

Each run: pick the next unchecked slice in `STATUS.md` → write failing tests →
implement the minimum → register files in `project.pbxproj` → code-review →
update `STATUS.md`. Progress and decisions are tracked in **[STATUS.md](STATUS.md)**.
