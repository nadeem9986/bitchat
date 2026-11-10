# SEEDFILE - bitchat (nadeem9986 fork)

Durable context for any future AI or human editing this repo. Read this before
making changes; update it when the architecture changes.

## What this repo is

Nadeem's fork of [permissionlesstech/bitchat](https://github.com/permissionlesstech/bitchat),
Jack Dorsey's Bluetooth mesh chat app (iOS/macOS, Swift/SwiftUI). Forked
October 30, 2026. The fork carries his own spin: a monochrome theme called
**matrix**. Do not open PRs, issues, comments or stars on upstream; all work
stays on this fork.

## The matrix theme

Design intent: black base, grey/white ink, no hue anywhere. Light mode inverts
the same greys. The owner dislikes cyan - never reintroduce it. The original
**liquidGlass** theme ships unchanged and must stay visually identical.

## Theme architecture

- `bitchat/Utils/Theme.swift` - `ThemePalette` with two static palettes:
  `matrix(_ colorScheme:)` (monochrome) and `liquidGlass()` (upstream look).
  Every themed color is a named slot (`primary`, `secondary`, `accent`,
  `accentBlue`, `locationAccent`, `statusSelf`, `statusRelay`, `statusUnread`,
  `alertRed`, `divider`, ...). Views read the active palette via
  `@ThemedPalette private var palette`.
- Peer name colors - `bitchat/Utils/Color+Peer.swift`: `Color(peerSeed:isDark:monochrome:)`
  has a monochrome branch that derives a stable grey per peer from the same
  seed. Callers in `bitchat/ViewModels/ChatMessageFormatter.swift` pass
  `monochrome: viewModel.currentTheme == .matrix`. Distance palettes
  (`MinimalDistancePalette`) have mono variants (`meshPaletteMono`,
  `nostrPaletteMono`).

## Rules for future edits

1. Route every UI color through a `ThemePalette` slot. If none fits, add a
   slot to BOTH palettes; never hardcode a hue in a view.
2. Deliberate exceptions: `.red` stays on errors, panic wipe, and fingerprint
   verify actions (security screens must not be ambiguous). Achromatic grey
   overlays in media/image viewers are fine as-is.
3. The globe in `bitchat/Views/Globe/GeohashPickerView.swift` is theme-gated:
   the matrix branch is monochrome; the liquidGlass branch keeps the original
   green tones. Do not "fix" the liquidGlass values.
4. Keep liquidGlass pixel-for-pixel upstream. Matrix-only changes belong in
   the matrix palette or behind a `currentTheme == .matrix` check.

## Verification constraints

Changes here are made without a Swift toolchain: they are code-reviewed and
syntax-balanced, NOT compiled or run. Commit messages and reports must say so.
If Xcode reports a build error, fix forward and note it.

## Divergence from upstream

The fork is many commits ahead of upstream, all theme work. Do not bulk-sync
from upstream without reviewing every incoming color change against the rules
above - a blind sync will reintroduce hues into matrix.
