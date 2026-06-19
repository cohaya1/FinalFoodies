# CraveCart AI — Build Status

Living design + progress tracker. The `cravecart-slice` skill reads and updates
this file. Keep it current: one source of truth for "what's decided" and
"what's next."

## Architecture decisions

| # | Decision | Rationale |
|---|---|---|
| 1 | Pivot FinalFoodies → CraveCart incrementally, not a rewrite | Keep the app building/green at every step |
| 2 | MVVM + UseCase + Repository + manual DI (`AppContainer`) | SOLID without framework bloat (KISS/YAGNI) |
| 3 | Client-side AI adapter (`OpenAIMealGenerationService` over `ChatGPTService`) | Reuse existing OpenAI/Keychain/cache infra; no backend yet |
| 4 | SwiftData for local persistence (saved meals, pantry, grocery lists) | Local-first; iOS 17.1 target supports it |
| 5 | DTO ⇄ domain mapping (`MealOptionMapper`) | Insulate domain from AI JSON changes |
| 6 | New code under `FinalFoodies/CraveCart/`; tests under `FinalFoodiesUnitTests/CraveCart/` | Isolated from legacy restaurant code during migration |
| 7 | No separate backend, no multi-agent AI | Deferred until product-market validation (YAGNI) |
| 8 | `@main` still launches the legacy restaurant flow | Cutover is its own slice to avoid breaking auth/build |

## Slice checklist

Ordered. The skill picks the first unchecked item.

- [x] **Slice 0 — Scaffold + craving → 3 meal options.** Domain models
  (`CravingRequest`, `MealOption`, `EffortLevel`, `CraveCartError`), UseCases
  (`GenerateMealOptionsUseCase`, `EstimateSavingsUseCase`), `MealRepository` +
  `DefaultMealRepository`, AI adapter (`OpenAIMealGenerationService`,
  `MealPromptBuilder`, `MealOptionDTO`, `MealOptionMapper`), `CravingHomeViewModel`
  + views, `AppContainer`. Unit tests for UseCases, mapper, prompt builder, VM.
- [ ] **Slice 1 — `@main` cutover.** Launch `CravingHomeView` via `AppContainer`
  behind the existing auth gate; keep auth working. Guard `ChatGPTService()` when
  no token is present (no fatalError at launch).
- [ ] **Slice 2 — SwiftData saved meals.** `SavedMealRepository` +
  `@Model` store; `SaveMealUseCase`; "Saved Meals" screen.
- [ ] **Slice 3 — Pantry.** `PantryRepository` + SwiftData store; `PantryView`;
  pantry items feed into `CravingRequest` and lower estimated cost.
- [ ] **Slice 4 — Grocery list.** `CreateGroceryListUseCase`; `GroceryListView`;
  derive list from a chosen `MealOption`.
- [ ] **Slice 5 — Savings surfacing.** Wire `EstimateSavingsUseCase` into the
  meal card with a real delivery-estimate input.
- [ ] **Slice 6 — Decommission legacy restaurant flow.** Remove/retire
  FinalFoodies-only screens, models, and tests no longer referenced.

## Changelog

- **2026-06-19 — Slice 0.** Scaffolded the CraveCart architecture under
  `FinalFoodies/CraveCart/` and the first vertical slice (craving → 3 meal
  options), reusing `ChatGPTService` via a new `MealGenerationService` adapter.
  Added unit tests under `FinalFoodiesUnitTests/CraveCart/`
  (`GenerateMealOptionsUseCaseTests`, `EstimateSavingsUseCaseTests`,
  `MealOptionMapperTests`, `MealPromptBuilderTests`, `CravingHomeViewModelTests`).
  Registered all 22 files in `project.pbxproj` (classic groups). Added the
  `cravecart-slice` TDD skill, `scripts/register_files.py`, README, and this
  tracker. Not yet built/run (no Xcode in CI env) — owner to run
  `xcodebuild test` on macOS.

## Open questions / follow-ups

- Confirm the OpenAI model id/params used by `ChatGPTService` are appropriate for
  structured JSON meal output (currently `gpt4_1106_preview`); consider requesting
  JSON mode.
- `PersistentCache` keys prompts by `hashValue` (not stable across launches) —
  revisit when caching meal results matters.
- Decide whether savings needs a per-region delivery-estimate source (Slice 5)
  or a simple heuristic for MVP.
- Legacy `CoreDataManger` is unused; remove during Slice 6 or when SwiftData lands.
