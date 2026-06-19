---
name: cravecart-slice
description: Drives one CraveCart vertical slice via strict TDD. Reads STATUS.md to pick the next unchecked slice, writes failing XCTest(s), implements the minimum Swift to pass, registers new files in project.pbxproj, runs a code-review pass, then updates STATUS.md. Designed to be invoked repeatedly with /loop to advance the MVP one slice at a time. Use when building out CraveCart features.
---

# CraveCart Slice (TDD loop)

You implement **exactly one** vertical slice of the CraveCart MVP per invocation,
test-first, then stop so `/loop` can re-invoke you for the next slice. Never batch
multiple slices — small, reviewed increments are the whole point.

## Environment constraints (read first)
- **No Xcode here.** This repo runs in a Linux container; you cannot run
  `xcodebuild`. Validate tests by *structure and logic* (mocks conform to
  protocols, async/await is correct, assertions match behavior). The owner runs
  `xcodebuild test` on macOS.
- **`project.pbxproj` uses classic groups (`objectVersion = 55`).** Every new
  `.swift` file MUST be registered or it will not compile. This is step 4 below
  and is non-optional.

## The loop (one slice)

### 1. Select
- Read `STATUS.md`. Pick the **first unchecked** slice in the Slice Checklist.
- If all are checked, report "MVP slices complete" and stop.
- Restate the slice's goal and acceptance criteria in one sentence.

### 2. Red — write failing tests first
- Add test(s) under `FinalFoodiesUnitTests/CraveCart/`.
- Follow the existing mock idiom: a nested `final class Mock…` /  `Stub…`
  conforming to the protocol under test (see
  `GenerateMealOptionsUseCaseTests.swift` and
  `RestaurantFetcher.swift`'s `MockFetchAPI`).
- `@testable import FinalFoodies`. Mark ViewModel tests `@MainActor`.
- State what the test asserts and why it fails today.

### 3. Green — minimum implementation
- Implement under `FinalFoodies/CraveCart/{Domain,Data,Features,App}/…`.
- Respect the layering: **Views** are dumb; **ViewModels** hold UI state only;
  business rules live in **UseCases**; data access hides behind a
  **Repository** protocol; external services (AI, HTTP, persistence) sit behind
  protocols so they can be mocked (DIP). Map DTO ⇄ domain — never leak wire
  shapes into the domain.
- Reuse existing infra: `ChatGPTServiceProtocol`, `TokenManager`,
  `NetworkMonitor`, `URLSessionProtocol`. Do not rebuild them.

### 4. Register files in project.pbxproj (non-optional)
For each new `.swift` file add **four** things (a helper script lives at
`scripts/register_files.py` if present; otherwise edit by hand or adapt the
script used for the first slice):
1. A `PBXBuildFile` entry.
2. A `PBXFileReference` entry (app files: path relative to the `CraveCart`
   group, e.g. `Domain/Models/Foo.swift`; test files: bare filename).
3. Membership in the correct `CraveCart` `PBXGroup`
   (app group `CAFE09000000000000000001`, test group `CAFE09000000000000000002`).
4. An entry in the correct `PBXSourcesBuildPhase`
   (app: `9883232927B8A2A90052859D`; unit tests: `98C7F5FE29A1BE80005273D2`).
Use fresh, unique 24-hex-char UUIDs (the first slice used the `CAFE…` range —
keep going from there, e.g. `CAFE04xx…`). After editing, verify `{`/`}` and
`(`/`)` counts stay balanced.

### 5. Review
- Run the `/code-review` skill on the diff, or apply this checklist inline:
  SRP (no business logic in Views/ViewModels), DIP (depend on protocols),
  error handling normalized to `CraveCartError`, tests isolated and
  deterministic, no force-unwraps on AI/JSON paths.
- Apply the fixes.

### 6. Record
- Tick the slice's checkbox in `STATUS.md`.
- Append a dated line to the Changelog with what shipped.
- Note any follow-ups or newly-discovered slices under Open Questions.

### 7. Stop
- One slice only. Do not start the next. End your turn so `/loop` can re-invoke.

## Definition of done for a slice
Tests written first and logically pass • implementation minimal and layered •
all new files registered in `project.pbxproj` • review applied • `STATUS.md`
updated. If you cannot finish a slice, leave it unchecked and record exactly
where you stopped in the Changelog.
