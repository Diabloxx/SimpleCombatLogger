# SimpleCombatLogger Classic v1.0.2 Release Notes

## 🎉 Initial Release - Classic MoP Support

This is the initial release of SimpleCombatLogger Classic, specifically adapted for **World of Warcraft Classic: Mists of Pandaria (5.5.0)**.

### 🆕 New Features

#### **Complete Classic MoP Adaptation**
- **Interface 50500** compatibility for Classic MoP 5.5.0
- **Classic difficulty system** support with proper ID mapping
- **MoP content detection** for all dungeons and raids
- **Separate database** (SimpleCombatLoggerClassicDB) to avoid conflicts

#### **Smart Content Detection**
- **Mists of Pandaria Dungeons**: Temple of the Jade Serpent, Gate of the Setting Sun, Stormstout Brewery, Shado-Pan Monastery, Mogu'shan Palace, Siege of Niuzao Temple, Scarlet Halls, Scarlet Monastery, Scholomance
- **Mists of Pandaria Raids**: Mogu'shan Vaults, Heart of Fear, Terrace of Endless Spring, Throne of Thunder, Siege of Orgrimmar
- **Legacy Content**: All Classic, TBC, and WotLK dungeons and raids
- **PvP Content**: Battlegrounds and Arenas with Classic API compatibility

#### **Granular Difficulty Control**
- **Dungeons**: Normal, Heroic, Challenge Mode, Celestial dungeons
- **Raids**: 10/25-man Normal/Heroic, Legacy 40-man, Legacy 20-man
- **Individual toggles** for each content type and difficulty

#### **Enhanced User Experience**
- **Smart notifications** when logging starts/stops
- **Duplicate message prevention** for zone changes
- **Delayed stop functionality** (30-second configurable delay)
- **Debug mode** with comprehensive logging information
- **Advanced Combat Logging** prompt for parser compatibility

#### **Robust Event Handling**
- **Zone change detection** for reliable instance leaving
- **Logout/disconnect handling** via PLAYER_LEAVING_WORLD
- **Multiple event listeners** for comprehensive coverage
- **Delayed instance checks** to prevent false triggers

### 🔧 Technical Implementation

#### **Classic API Compatibility**
- **Ace3 framework** integration for stability
- **Classic difficulty IDs**: 1,2,3,4,5,6,8,9,148,173,174,175,176,193,194
- **Fallback systems** for different Classic versions
- **MoP content verification** via instance name matching

#### **Smart Logic**
- **Instance type detection** (party, raid, pvp, scenario)
- **Difficulty-based decisions** for logging control
- **Content-aware handling** with MoP specialization
- **Edge case management** for unknown difficulties

### 🎯 Perfect For

- **Raiders** uploading logs to WarcraftLogs
- **Dungeon groups** analyzing performance
- **PvP players** tracking arena matches
- **Guild officers** managing raid logs
- **Casual players** wanting automatic log management

### 📋 Commands

- `/sclc` - Open configuration panel
- `/sclc enable` - Enable the addon  
- `/sclc disable` - Disable the addon
- `/sclc test` - Display current status information

### 🔄 Configuration Options

- **Content Type Toggles**: Enable/disable specific dungeons, raids, PvP, scenarios
- **Difficulty Granularity**: Individual controls for 10/25-man, Normal/Heroic
- **Delayed Log Stop**: Prevent premature log ending (default: enabled)
- **Advanced Combat Logging**: Automatic prompt for parser compatibility
- **Debug Mode**: Detailed information for troubleshooting

### 🛠️ Installation

1. Download `SimpleCombatLogger-Classic-v1.0.0.zip`
2. Extract to `World of Warcraft\_classic_\Interface\AddOns\`
3. Restart WoW Classic or `/reload`
4. Configure via Interface Options → AddOns → SimpleCombatLogger Classic

### 🔍 Known Issues

- **Celestial dungeons** may use unknown difficulty IDs (treated as MoP content when detected)
- **Some legacy content** may need verification of specific difficulty mappings
- **First-time setup** requires Advanced Combat Logging confirmation

### 🧪 Testing Completed

- ✅ **MoP dungeon detection** across all difficulties
- ✅ **MoP raid detection** for 10/25-man Normal/Heroic
- ✅ **Legacy content support** for Classic/TBC/WotLK
- ✅ **PvP functionality** in battlegrounds and arenas
- ✅ **Zone transition handling** and logout detection
- ✅ **Configuration persistence** across sessions
- ✅ **Debug output accuracy** for troubleshooting

### 📝 Future Enhancements

- **Additional content detection** as Classic MoP evolves
- **Performance optimizations** based on user feedback
- **Extended difficulty mapping** for edge cases
- **Community-requested features** and improvements

### 🙏 Acknowledgments

Special thanks to:
- **Original SimpleCombatLogger** developers for the foundation
- **Classic MoP community** for testing and feedback
- **WarcraftLogs** for combat log analysis tools
- **Ace3 framework** contributors for addon stability

---

## 📥 Download

**File**: `SimpleCombatLogger-Classic-v1.0.0.zip`  
**Size**: ~50KB  
**Checksum**: Available in release assets  
**Compatibility**: Classic MoP 5.5.0 (Interface 50500)

For support, bug reports, or feature requests, please visit the [Issues](../../issues) page.

**Happy logging!** 🎮⚔️
