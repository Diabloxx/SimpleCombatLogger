# SimpleCombatLogger Classic
## A simple combat logger addon for World of Warcraft Classic - Mists of Pandaria (Patch 5.5.0)

Supports all Classic content types with proper difficulty detection for MoP Classic build 62422.

## Supported Content Types:

### Dungeons:
- **Normal Dungeons** (Difficulty IDs: 1, 173)
- **Heroic Dungeons** (Difficulty IDs: 2, 174)
- **Challenge Mode** (Difficulty ID: 8)
- **Celestial Dungeons** (replaces LFR - uses standard party difficulty IDs)

### Raids:
- **Normal 10-man** (Difficulty IDs: 3, 175)
- **Normal 25-man** (Difficulty IDs: 4, 176)
- **Heroic 10-man** (Difficulty IDs: 5, 193)
- **Heroic 25-man** (Difficulty IDs: 6, 194)
- **Legacy 40-man** (Difficulty ID: 9) - MC, BWL, Naxx, etc.
- **Legacy 20-man** (Difficulty ID: 148) - ZG, AQ20

### PvP:
- **Battlegrounds** - All battleground types
- **Arenas** - All arena formats

### Scenarios:
- **Scenarios** - New MoP content type

## Usage:

`/sclc` or `/simplecombatloggerclassic` to configure

`/sclc enable`

`/sclc disable`

`/sclc test` - Shows current instance information and logging state

## Installation:
Search for the adoon on CurseForge (SimpleCombatLogger Classic)

## Features:
- Automatic combat logging based on content type
- Individual toggles for each difficulty and content type
- Advanced Combat Logging (ACL) prompt and setup
- Debug mode for troubleshooting
- Delayed stop option for external tool compatibility
- Separate settings database from retail version
