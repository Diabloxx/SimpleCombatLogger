# SimpleCombatLogger Classic

## [1.6.12-Classic](https://github.com/csutcliff/SimpleCombatLogger/tree/1.6.12-Classic) (2025-08-07)

- Initial Classic Mists of Pandaria adaptation for patch 5.5.0 (build 62422)
- **Implemented correct Classic difficulty IDs:**
  - Dungeons: Normal (1, 173), Heroic (2, 174), Challenge Mode (8)
  - Raids: 10N (3, 175), 25N (4, 176), 10H (5, 193), 25H (6, 194)
  - Legacy Raids: 40-man (9), 20-man (148)
- **Content Structure Adaptations:**
  - Dungeons: Normal, Heroic, Challenge Mode, Celestial (replacing LFR)
  - Raids: Separate options for 10/25-man Normal/Heroic plus legacy raid support
  - PvP: Simplified Arena and Battleground support
  - Scenarios: New MoP content type support
- **Technical Changes:**
  - Changed chat commands to `/sclc` to avoid conflicts with retail version
  - Updated interface version for Classic MoP 5.5.0 (50500)
  - Separated database name to avoid conflicts (SimpleCombatLoggerClassicDB)
  - Removed retail-specific features (Mythic+, modern PvP modes, etc.)
  - Added compatibility checks for Classic API differences
- **New Configuration Options:**
  - Separate toggles for each raid size and difficulty combination
  - Legacy raid support for 40-man and 20-man content
  - Enhanced debug output with difficulty ID logging

## Supported Difficulty IDs:
- **Party (Dungeons):** 1, 2, 8, 173, 174
- **Raid:** 3, 4, 5, 6, 9, 148, 175, 176, 193, 194
- **PvP:** Standard battleground and arena detection
- **Scenario:** Standard scenario difficulty detection

## Compatibility:
- **Target Version:** Classic MoP Patch 5.5.0 (Interface 50500)
- **Build:** 62422
