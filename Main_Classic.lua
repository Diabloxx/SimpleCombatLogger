local SimpleCombatLoggerClassic = LibStub("AceAddon-3.0"):NewAddon("SimpleCombatLoggerClassic", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local IsLoggingCombat = false
local DelayStopTimer = nil

-- MoP Dungeon and Scenario MapIDs for more precise detection
local MoPDungeonMapIDs = {
    [867] = "Temple of the Jade Serpent",
    [875] = "Gate of the Setting Sun", 
    [876] = "Stormstout Brewery",
    [877] = "Shado-Pan Monastery",
    [885] = "Mogu'shan Palace",
    [887] = "Siege of Niuzao Temple",
    [871] = "Scarlet Halls",
    [874] = "Scarlet Monastery",
    [898] = "Scholomance"
}

local MoPRaidMapIDs = {
    [886] = "Terrace of Endless Spring",
    [896] = "Mogu'shan Vaults",
    [897] = "Heart of Fear",
    [930] = "Throne of Thunder",
    [953] = "Siege of Orgrimmar"
}

local options = {
    name = "SimpleCombatLogger Classic",
    handler = SimpleCombatLoggerClassic,
    type = "group",
    args = {
        enable = {
            name = "Enabled",
            desc = "Enables / Disables the addon",
            type = "toggle",
            set = function(info, value) SimpleCombatLoggerClassic:SetEnable(value) end,
            get = function(info) return SimpleCombatLoggerClassic.db.profile.enable end
        },
        disableaclprompt = {
            name = "Disable ACL Reminder",
            desc = "Disables the Advanced Combat Logging prompt",
            type = "toggle",
            set = function(info, value) SimpleCombatLoggerClassic.db.profile.disableaclprompt = value end,
            get = function(info) return SimpleCombatLoggerClassic.db.profile.disableaclprompt end
        },
        enabledebug = {
            name = "Debug",
            desc = "Enable Debug output",
            type = "toggle",
            set = function(info, value) SimpleCombatLoggerClassic.db.profile.enabledebug = value end,
            get = function(info) return SimpleCombatLoggerClassic.db.profile.enabledebug end
        },
        delaystop = {
            name = "Delayed Log Stop",
            desc = "Delay the stopping of combat logging by 30 seconds, this can help compatibility with some external programs",
            type = "toggle",
            set = function(info, value) SimpleCombatLoggerClassic.db.profile.delaystop = value end,
            get = function(info) return SimpleCombatLoggerClassic.db.profile.delaystop end
        },
        party = {
            name = "Dungeons",
            type = "group",
            args = {
                normal = {
                    name = "Normal Dungeons",
                    desc = "Enables / Disables normal dungeon logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.party.normal = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.party.normal end
                },
                heroic = {
                    name = "Heroic Dungeons",
                    desc = "Enables / Disables heroic dungeon logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.party.heroic = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.party.heroic end
                },
                challenge = {
                    name = "Challenge Mode",
                    desc = "Enables / Disables challenge mode dungeon logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.party.challenge = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.party.challenge end
                },
                celestial = {
                    name = "Celestial Dungeons",
                    desc = "Enables / Disables celestial dungeon logging (replaces LFR)",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.party.celestial = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.party.celestial end
                },
            }
        },
        raid = {
            name = "Raids",
            type = "group",
            args = {
                normal10 = {
                    name = "Normal 10-man",
                    desc = "Enables / Disables normal 10-man raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.raid.normal10 = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.raid.normal10 end
                },
                normal25 = {
                    name = "Normal 25-man",
                    desc = "Enables / Disables normal 25-man raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.raid.normal25 = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.raid.normal25 end
                },
                heroic10 = {
                    name = "Heroic 10-man",
                    desc = "Enables / Disables heroic 10-man raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.raid.heroic10 = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.raid.heroic10 end
                },
                heroic25 = {
                    name = "Heroic 25-man",
                    desc = "Enables / Disables heroic 25-man raid logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.raid.heroic25 = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.raid.heroic25 end
                },
                legacy40 = {
                    name = "Legacy 40-man",
                    desc = "Enables / Disables legacy 40-man raid logging (MC, BWL, etc.)",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.raid.legacy40 = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.raid.legacy40 end
                },
                legacy20 = {
                    name = "Legacy 20-man",
                    desc = "Enables / Disables legacy 20-man raid logging (ZG, AQ20)",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.raid.legacy20 = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.raid.legacy20 end
                },
            }
        },
        pvp = {
            name = "PvP",
            type = "group",
            args = {
                regularbg = {
                    name = "Battlegrounds",
                    desc = "Enables / Disables battleground logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.pvp.regularbg = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.pvp.regularbg end
                },
                arena = {
                    name = "Arenas",
                    desc = "Enables / Disables arena logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.pvp.arena = value
                        SimpleCombatLoggerClassic:CheckArenaLogging()
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.pvp.arena end
                },
            }
        },
        scenario = {
            name = "Scenarios",
            type = "group",
            args = {
                scenario = {
                    name = "Scenarios",
                    desc = "Enables / Disables scenario logging",
                    type = "toggle",
                    set = function(info, value)
                        SimpleCombatLoggerClassic.db.profile.scenario.scenario = value
                        SimpleCombatLoggerClassic:CheckToggleLogging(nil)
                    end,
                    get = function(info) return SimpleCombatLoggerClassic.db.profile.scenario.scenario end
                }
            }
        },
        credits = {
            name = "Credits",
            type = "group",
            args = {
                header = {
                    name = "SimpleCombatLogger Classic",
                    type = "header",
                    order = 1
                },
                original = {
                    name = "Original SimpleCombatLogger created by csutcliff",
                    type = "description",
                    fontSize = "medium",
                    order = 2
                },
                modified = {
                    name = "Classic adaptation by Valleriaà-Firemaw (EU)",
                    type = "description",
                    fontSize = "medium",
                    order = 3
                },
                spacer = {
                    name = " ",
                    type = "description",
                    order = 4
                },
                version = {
                    name = "Version: 1.0.1 - Classic MoP (Interface 50500)",
                    type = "description",
                    fontSize = "small",
                    order = 5
                }
            }
        }
    }
}

local defaults = {
    profile = {
        enable = true,
        disableaclprompt = false,
        enabledebug = false,
        delaystop = true,
        party = {
            ["*"] = true,
        },
        raid = {
            ["*"] = true,
        },
        pvp = {
            ["*"] = true,
        },
        scenario = {
            ["*"] = true,
        },
    }
}

function SimpleCombatLoggerClassic:OnInitialize()
    -- Called when the addon is initialized

    -- ACL Prompt
    StaticPopupDialogs["SCL_CLASSIC_ENABLE_ACL"] = {
        text = "Advanced Combat Logging is required for most combat log parsers, would you like to enable it?",
        button1 = "Yes",
        button2 = "No",
        OnAccept = function()
            SimpleCombatLoggerClassic:EnableACL()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
    }

    -- Initialisation
    self.db = LibStub("AceDB-3.0"):New("SimpleCombatLoggerClassicDB", defaults, true)
    self.db.RegisterCallback(self, "OnProfileChanged", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileCopied", "RefreshConfig")
    self.db.RegisterCallback(self, "OnProfileReset", "RefreshConfig")
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SimpleCombatLoggerClassic", options)
    --Only the category ID is required, discard first parameter
    _, self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SimpleCombatLoggerClassic", "SimpleCombatLogger Classic")
    LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("SCL_Classic/Profiles", LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db))
    LibStub("AceConfigDialog-3.0"):AddToBlizOptions("SCL_Classic/Profiles", "Profiles", "SimpleCombatLogger Classic")
    self:RegisterChatCommand("sclc", "ChatCommand");
    self:RegisterChatCommand("SimpleCombatLoggerClassic", "ChatCommand");
    hooksecurefunc("LoggingCombat", function(state)
        IsLoggingCombat = state
        if (self.db.profile.enabledebug) then
            self:Print("LoggingCombat called with: " .. tostring(state));
        end
    end);
end

function SimpleCombatLoggerClassic:IsMoPContent(instanceName)
    -- Check if the instance name matches known MoP content
    if not instanceName then return false end
    
    local mopDungeons = {
        ["Temple of the Jade Serpent"] = true,
        ["Gate of the Setting Sun"] = true,
        ["Stormstout Brewery"] = true,
        ["Shado-Pan Monastery"] = true,
        ["Mogu'shan Palace"] = true,
        ["Siege of Niuzao Temple"] = true,
        ["Scarlet Halls"] = true,
        ["Scarlet Monastery"] = true,
        ["Scholomance"] = true,
    }
    
    local mopRaids = {
        ["Terrace of Endless Spring"] = true,
        ["Mogu'shan Vaults"] = true,
        ["Heart of Fear"] = true,
        ["Throne of Thunder"] = true,
        ["Siege of Orgrimmar"] = true
    }
    
    return mopDungeons[instanceName] or mopRaids[instanceName]
end

function SimpleCombatLoggerClassic:RefreshConfig()
    self:CheckToggleLogging(nil)
end

function SimpleCombatLoggerClassic:EnableACL()
    SetCVar("advancedCombatLogging", 1)
end

function SimpleCombatLoggerClassic:OnEnable()
    if (not self.db.profile.enable) then
        self:OnDisable()
        return
    end

    self:Print("Enabled")
    if (not self.db.profile.disableaclprompt and GetCVar("advancedCombatLogging") == "0") then
        StaticPopup_Show("SCL_CLASSIC_ENABLE_ACL")
    end
    self:RegisterEvent("UPDATE_INSTANCE_INFO", "CheckEnableLogging")
    self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED", "CheckEnableLogging")
    self:RegisterEvent("ZONE_CHANGED_NEW_AREA", "CheckDisableLogging")
    self:RegisterEvent("ZONE_CHANGED", "CheckDisableLogging")
    self:RegisterEvent("PLAYER_ENTERING_WORLD", "ArenaEventTimer")
    self:RegisterEvent("PLAYER_LEAVING_WORLD", "CheckDisableLogging")
    self:CheckToggleLogging(nil)
end

function SimpleCombatLoggerClassic:OnDisable()
    self:Print("Disabled")
    self:UnregisterEvent("UPDATE_INSTANCE_INFO")
    self:UnregisterEvent("PLAYER_DIFFICULTY_CHANGED")
    self:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
    self:UnregisterEvent("ZONE_CHANGED")
    self:UnregisterEvent("PLAYER_LEAVING_WORLD")
    self:StopLogging()
end

function SimpleCombatLoggerClassic:ChatCommand(input)
    if (not input or input:trim() == "") then
        -- For Classic, try to open the options frame
        if InterfaceOptionsFrame_OpenToCategory then
            InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
            InterfaceOptionsFrame_OpenToCategory(self.optionsFrame) -- Called twice to ensure it opens
        else
            -- Fallback for different Classic versions
            self:Print("Use /sclc enable or /sclc disable to control the addon")
        end
    elseif (input:trim() == "enable") then
        self:SetEnable(true)
    elseif (input:trim() == "disable") then
        self:SetEnable(false)
    elseif (input:trim() == "test") then
        self:Print("Logging Combat: " .. tostring(IsLoggingCombat))
        self:Print("Instance Info: " .. tostring(GetInstanceInfo()))
        -- Classic MoP doesn't have these PvP functions
        if C_PvP then
            self:Print("Rated Arena: " .. tostring(C_PvP.IsRatedArena()))
            self:Print("Rated BG: " .. tostring(C_PvP.IsRatedBattleground()))
        end
        if IsArenaSkirmish then
            self:Print("Arena Skirmish: " .. tostring(IsArenaSkirmish()))
        end
    else
        LibStub("AceConfigCmd-3.0").HandleCommand(SimpleCombatLoggerClassic, "SimpleCombatLoggerClassic", "SimpleCombatLoggerClassic", input)
    end
end

function SimpleCombatLoggerClassic:SetEnable(value)
    if (self.db.profile.enable == value) then
        return
    end
    self.db.profile.enable = value
    if (value) then
        SimpleCombatLoggerClassic:OnEnable()
    else
        SimpleCombatLoggerClassic:OnDisable()
    end
end

function SimpleCombatLoggerClassic:StartLogging()
    if (self.db.profile.enabledebug) then
        self:Print("Start called")
    end

    if (IsLoggingCombat) then
        if (self.db.profile.enabledebug) then
            self:Print("Combat Logging is already enabled")
        end
        if (DelayStopTimer ~= nil) then
            if (self.db.profile.enabledebug) then
                self:Print("Cancelling Delayed Stop")
            end
            self:CancelTimer(DelayStopTimer)
            DelayStopTimer = nil
        else
            if (self.db.profile.enabledebug) then
                self:Print("No active delayed stop")
            end
        end
    end

    if (not IsLoggingCombat) then
        self:Print("Starting Combat Logging")
        if (LoggingCombat(true)) then
            if (self.db.profile.enabledebug) then
                self:Print("Successfully started Combat Logging")
            end
        else
            self:Print("Failed to start Combat Logging") -- this should never be hit
        end
    end
end

function SimpleCombatLoggerClassic:StopLogging()
    if (self.db.profile.enabledebug) then
        self:Print("Stop called")
    end

    if (IsLoggingCombat) then
        if (self.db.profile.delaystop) then
            if (self.db.profile.enabledebug) then
                self:Print("Delay enabled, stopping in 30 seconds")
            end
            if (DelayStopTimer ~= nil) then
                if (self.db.profile.enabledebug) then
                    self:Print("Another delayed stop is queued, overwriting it")
                end
                self:CancelTimer(DelayStopTimer)
            end
            DelayStopTimer = self:ScheduleTimer("StopLoggingNow", 30)
        else
            self:StopLoggingNow()
        end
    elseif (self.db.profile.enabledebug) then
        self:Print("Combat logging is already stopped")
    end
end

function SimpleCombatLoggerClassic:StopLoggingNow()
    DelayStopTimer = nil
    if (IsLoggingCombat) then
        self:Print("Stopping Combat Logging")
        if (not LoggingCombat(false)) then
            if (self.db.profile.enabledebug) then
                self:Print("Successfully stopped Combat Logging")
            end
        elseif (self.db.profile.enabledebug) then
            self:Print("Failed to stop Combat Logging")
        end
    elseif (self.db.profile.enabledebug) then
        self:Print("Combat Logging is not running")
    end
end

function SimpleCombatLoggerClassic:ArenaEventTimer(event)
    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    if (self.db.profile.enabledebug) then
        self:Print("Arena Event Timer")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        self:Print("Event: " .. tostring(event))
        self:Print("    name: " .. tostring(name))
        self:Print("    instanceType: " .. tostring(instanceType))
        self:Print("    difficultyID: " .. tostring(difficultyID))
        self:Print("    difficultyName: " .. tostring(difficultyName))
        self:Print("    maxPlayers: " .. tostring(maxPlayers))
        self:Print("    dynamicDifficulty: " .. tostring(dynamicDifficulty))
        self:Print("    isDynamic: " .. tostring(isDynamic))
        self:Print("    instanceID: " .. tostring(instanceID))
        self:Print("    instanceGroupSize: " .. tostring(instanceGroupSize))
        self:Print("    LfgDungeonID: " .. tostring(LfgDungeonID))
    end
    if (instanceType == "arena") then
        if (self.db.profile.enabledebug) then
            self:Print("Scheduling arena check for 5 seconds")
        end
        self:ScheduleTimer("CheckArenaLogging", 5)
    else
        -- Schedule a delayed check to ensure we stop logging if we've left an instance
        self:ScheduleTimer("DelayedInstanceCheck", 3)
    end
end

function SimpleCombatLoggerClassic:DelayedInstanceCheck()
    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    if (self.db.profile.enabledebug) then
        self:Print("Delayed Instance Check")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        self:Print("    instanceType: " .. tostring(instanceType))
        self:Print("    difficultyID: " .. tostring(difficultyID))
    end
    
    -- If we're not in any meaningful instance, stop logging
    if (instanceType == nil or instanceType == "none") then
        if (self.db.profile.enabledebug) then
            self:Print("Delayed check: Not in instance, stopping logging")
        end
        self:StopLogging()
    end
end

function SimpleCombatLoggerClassic:CheckToggleLogging(event)
    if (IsLoggingCombat) then
        self:CheckDisableLogging(nil)
    else
        self:CheckEnableLogging(nil)
    end
end

function SimpleCombatLoggerClassic:CheckEnableLogging(event)
    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    
    if (self.db.profile.enabledebug) then
        self:Print("Check Enable")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        self:Print("Event: " .. tostring(event))
        self:Print("    name: " .. tostring(name))
        self:Print("    instanceType: " .. tostring(instanceType))
        self:Print("    difficultyID: " .. tostring(difficultyID))
        self:Print("    difficultyName: " .. tostring(difficultyName))
        self:Print("    maxPlayers: " .. tostring(maxPlayers))
        self:Print("    dynamicDifficulty: " .. tostring(dynamicDifficulty))
        self:Print("    isDynamic: " .. tostring(isDynamic))
        self:Print("    instanceID: " .. tostring(instanceID))
        self:Print("    instanceGroupSize: " .. tostring(instanceGroupSize))
        self:Print("    LfgDungeonID: " .. tostring(LfgDungeonID))
        self:Print("    isMoPContent: " .. tostring(self:IsMoPContent(name)))
    end
    
    if (instanceType == "pvp") then
        -- Handle battlegrounds and arenas
        if (self.db.profile.pvp.regularbg) then
            self:StartLogging()
        end
    elseif (instanceType == "party") then
        -- Handle dungeons (including celestial dungeons that replace LFR)
        if (difficultyID == 1 or difficultyID == 173) then -- Normal Dungeon
            if (self.db.profile.party.normal) then
                self:StartLogging()
            end
        elseif (difficultyID == 2 or difficultyID == 174) then -- Heroic Dungeon
            if (self.db.profile.party.heroic) then
                self:StartLogging()
            end
        elseif (difficultyID == 8) then -- Challenge Mode
            if (self.db.profile.party.challenge) then
                self:StartLogging()
            end
        else
            -- Check if this might be a celestial dungeon (LFR replacement)
            -- Celestial dungeons might use a different difficulty ID
            -- For now, treat unknown party difficulties as celestial if they're MoP content
            if (self:IsMoPContent(name) and self.db.profile.party.celestial) then
                if (self.db.profile.enabledebug) then
                    self:Print("Detected potential celestial dungeon: " .. tostring(name) .. " (ID: " .. tostring(difficultyID) .. ")")
                end
                self:StartLogging()
            end
        end
    elseif (instanceType == "raid") then
        -- Handle 10/25 man Normal/Heroic raids based on Classic difficulty IDs
        if (difficultyID == 3 or difficultyID == 175) then -- 10-man Normal
            if (self.db.profile.raid.normal10) then
                self:StartLogging()
            end
        elseif (difficultyID == 4 or difficultyID == 176) then -- 25-man Normal
            if (self.db.profile.raid.normal25) then
                self:StartLogging()
            end
        elseif (difficultyID == 5 or difficultyID == 193) then -- 10-man Heroic
            if (self.db.profile.raid.heroic10) then
                self:StartLogging()
            end
        elseif (difficultyID == 6 or difficultyID == 194) then -- 25-man Heroic
            if (self.db.profile.raid.heroic25) then
                self:StartLogging()
            end
        elseif (difficultyID == 9) then -- 40 Player (legacy content)
            -- For 40-man raids (MC, BWL, etc.)
            if (self.db.profile.raid.legacy40) then
                self:StartLogging()
            end
        elseif (difficultyID == 148) then -- 20 Player (ZG, AQ20)
            -- For 20-man raids
            if (self.db.profile.raid.legacy20) then
                self:StartLogging()
            end
        end
    elseif (instanceType == "scenario") then
        -- Handle scenarios (new in MoP) - be more specific about MoP scenarios
        if (self:IsMoPContent(name)) then
            if (self.db.profile.scenario.scenario) then
                self:StartLogging()
            end
        else
            -- For non-MoP scenarios, still log if enabled
            if (self.db.profile.scenario.scenario) then
                self:StartLogging()
            end
        end
    end
end

function SimpleCombatLoggerClassic:CheckArenaLogging()
    if (self.db.profile.enabledebug) then
        self:Print("Check Arena")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        -- Classic may not have all the modern PvP detection functions
        if C_PvP then
            self:Print("Rated Arena: " .. tostring(C_PvP.IsRatedArena()))
        end
        if IsArenaSkirmish then
            self:Print("Arena Skirmish: " .. tostring(IsArenaSkirmish()))
        end
    end
    
    -- In Classic MoP, we'll handle arenas more simply
    if (self.db.profile.pvp.arena) then
        self:StartLogging()
    else
        self:StopLogging()
    end
end

function SimpleCombatLoggerClassic:CheckDisableLogging(event)
    local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
    if (self.db.profile.enabledebug) then
        self:Print("Check Disable")
        self:Print("Currently Logging: " .. tostring(IsLoggingCombat))
        self:Print("Event: " .. tostring(event))
        self:Print("    name: " .. tostring(name))
        self:Print("    instanceType: " .. tostring(instanceType))
        self:Print("    difficultyID: " .. tostring(difficultyID))
        self:Print("    difficultyName: " .. tostring(difficultyName))
        self:Print("    maxPlayers: " .. tostring(maxPlayers))
        self:Print("    dynamicDifficulty: " .. tostring(dynamicDifficulty))
        self:Print("    isDynamic: " .. tostring(isDynamic))
        self:Print("    instanceID: " .. tostring(instanceID))
        self:Print("    instanceGroupSize: " .. tostring(instanceGroupSize))
        self:Print("    LfgDungeonID: " .. tostring(LfgDungeonID))
        self:Print("    isMoPContent: " .. tostring(self:IsMoPContent(name)))
    end
    
    -- If we're not in an instance at all, stop logging
    if (instanceType == nil or instanceType == "none") then
        if (self.db.profile.enabledebug) then
            self:Print("Not in instance, stopping logging")
        end
        self:StopLogging()
        return
    end
    
    -- If we're leaving world (disconnecting/reloading), stop logging
    if (event == "PLAYER_LEAVING_WORLD") then
        if (self.db.profile.enabledebug) then
            self:Print("Player leaving world, stopping logging")
        end
        self:StopLogging()
        return
    end
    
    -- Check if current instance type should have logging disabled
    local shouldStop = false
    
    if (instanceType == "pvp") then
        shouldStop = not self.db.profile.pvp.regularbg
    elseif (instanceType == "party") then
        if (difficultyID == 1 or difficultyID == 173) then -- Normal Dungeon
            shouldStop = not self.db.profile.party.normal
        elseif (difficultyID == 2 or difficultyID == 174) then -- Heroic Dungeon
            shouldStop = not self.db.profile.party.heroic
        elseif (difficultyID == 8) then -- Challenge Mode
            shouldStop = not self.db.profile.party.challenge
        else
            -- Unknown party instance, stop logging
            shouldStop = true
        end
    elseif (instanceType == "raid") then
        if (difficultyID == 3 or difficultyID == 175) then -- 10-man Normal
            shouldStop = not self.db.profile.raid.normal10
        elseif (difficultyID == 4 or difficultyID == 176) then -- 25-man Normal
            shouldStop = not self.db.profile.raid.normal25
        elseif (difficultyID == 5 or difficultyID == 193) then -- 10-man Heroic
            shouldStop = not self.db.profile.raid.heroic10
        elseif (difficultyID == 6 or difficultyID == 194) then -- 25-man Heroic
            shouldStop = not self.db.profile.raid.heroic25
        elseif (difficultyID == 9) then -- 40 Player (legacy content)
            shouldStop = not self.db.profile.raid.legacy40
        elseif (difficultyID == 148) then -- 20 Player (ZG, AQ20)
            shouldStop = not self.db.profile.raid.legacy20
        else
            -- Unknown raid instance, stop logging
            shouldStop = true
        end
    elseif (instanceType == "scenario") then
        shouldStop = not self.db.profile.scenario.scenario
    end
    
    if (shouldStop) then
        if (self.db.profile.enabledebug) then
            self:Print("Instance type disabled or unknown, stopping logging")
        end
        if (IsLoggingCombat) then
            self:Print("Combat logging disabled")
        end
        self:StopLogging()
    end
end
