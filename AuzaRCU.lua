-- Load Rayfield Library
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Core Variables
local a = require(script.Library)
a.Debug = true
local b = a.Libraries
local c = a.Services
local d = a.Variables
local e = b.Generic
local f = b.Special
local g = b.RBXUtil
local h = g.Tree
local i = g.Promise
local j = g.Signal
local k = g.Trove
local l = g.TableUtil
local m = f.GameModules.Get()
local n = e.Interface.Get()
local o = e.Threading
local p = a.Functions
local q = p.Special
local r = p.Generic
local s = d.LRM_Variables
local t = c.Players
local u = c.RunService
local v = c.Workspace
local w = c.ReplicatedStorage
local x = c.UserInputService
local y = c.GuiService
local z = c.CoreGui
local A = c.CollectionService
local B = t.LocalPlayer
local C = game.FindFirstChild
local D = game.FindFirstChildWhichIsA
local E = game.FindFirstAncestor
local F = game.IsA
local G = m.Knit
local H = G.GetService'ClickService'
local I = G.GetService'RebirthService'
local J = G.GetService'EggService'
local K = G.GetService'FarmService'
local L = G.GetService'UpgradeService'
local M = G.GetService'RewardService'
local N = G.GetService'PetService'
local O = G.GetService'IndexService'
local P = G.GetService'PrestigeService'
local Q = G.GetService'InventoryService'
local R = G.GetController'HatchingController'
local S = G.GetController'FarmController'
local T = G.GetController'DataController'
T:waitForData()

local U = T.replica
local V = m.Functions
local W = m.Variables

setthreadidentity(8)
setthreadcontext(8)

local X = a.Cache.ScriptCache
X.InitTime = DateTime.now().UnixTimestamp
local Y = o.new'MainThread'

-- Create Window with Rayfield
local window = Rayfield:CreateWindow({
    Name = "Auza Hub",
    LoadingTitle = "Loading Auza Hub...",
    LoadingSubtitle = "Developed by iKazu | Enhance your gameplay experience.",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AuzaHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = true,
        Invite = "Vf4Wu3Cft7", -- Replace with your Discord invite code
        RememberJoins = true
    }
})

-- Tabs
local tabs = {
    Home = window:CreateTab("Dashboard", 4483362458), -- Icon ID (optional)
    Farming = window:CreateTab("Farming", 6023426915), -- Icon ID (optional)
    Crops = window:CreateTab("Crops", 6026568888), -- Icon ID (optional)
    Misc = window:CreateTab("Utilities", 6023426915), -- Icon ID (optional)
    Settings = window:CreateTab("Configuration", 6026568888) -- Icon ID (optional)
}

-- Sections
local sections = {
    Home_Info = tabs.Home:CreateSection("↳ General Information"),
    Home_About = tabs.Home:CreateSection("↳ About Auza Hub"),
    Farming_Clicking = tabs.Farming:CreateSection("↳ Auto Clicking"),
    Farming_Rebirth = tabs.Farming:CreateSection("↳ Rebirth Automation"),
    Farming_Hatching = tabs.Farming:CreateSection("↳ Egg Hatching"),
    Farming_Upgrades = tabs.Farming:CreateSection("↳ Upgrade Management"),
    Crops_Claim = tabs.Crops:CreateSection("↳ Crop Collection"),
    Crops_Upgrade = tabs.Crops:CreateSection("↳ Crop Upgrades"),
    Misc_Chests = tabs.Misc:CreateSection("↳ Chest Handling"),
    Misc_Items = tabs.Misc:CreateSection("↳ Item Usage"),
    Misc_Combining = tabs.Misc:CreateSection("↳ Pet Combining"),
    Misc_Misc = tabs.Misc:CreateSection("↳ Miscellaneous Tools"),
    Settings_Config = tabs.Settings:CreateSection("↳ Configuration")
}

-- Home Tab: Information Section
do
    -- Client Uptime Paragraph
    local uptimeParagraph = sections.Home_Info:CreateParagraph({
        Title = "Client Uptime",
        Content = "Displays how long the script has been active."
    })

    -- Update Uptime Every Second
    task.spawn(function()
        while task.wait(1) do
            uptimeParagraph:Set({ Content = string.format("Active Time: %s", os.date("!%H:%M:%S", math.floor(tick()))) })
        end
    end)

    -- Lua Heap Paragraph
    local luaHeapParagraph = sections.Home_Info:CreateParagraph({
        Title = "Lua Heap (MB)",
        Content = "Displays current Lua memory usage."
    })

    -- Update Lua Heap Every Second
    task.spawn(function()
        while task.wait(1) do
            luaHeapParagraph:Set({ Content = string.format("Memory: %sMB", tostring(r.CommaNumber(math.ceil(gcinfo() / 1000)))) })
        end
    end)

    -- Join Discord Button
    sections.Home_Info:CreateButton({
        Name = "Join Discord",
        Callback = function()
            r.PromptDiscordJoin('Vf4Wu3Cft7', true)
            Rayfield:Notify({
                Title = "Discord Invite",
                Content = "Invite link has been copied!",
                Duration = 2
            })
        end
    })

    -- About Paragraph
    sections.Home_About:CreateParagraph({
        Title = "About Auza Hub",
        Content = "Auza Hub is a powerful tool designed to enhance your gaming experience. Developed by iKazu."
    })
end

-- Farming Tab: Auto Clicking Section
do
    -- Auto Click Toggle
    sections.Farming_Clicking:CreateToggle({
        Name = "Enable Auto Click",
        CurrentValue = false,
        Flag = "AutoClickToggle",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoClickToggle'
                return
            end
            o.new('AutoClickToggle', function()
                while task.wait() do
                    H.click:Fire()
                end
            end):Start()
        end
    })
end

-- Farming Tab: Rebirth Automation Section
do
    -- Rebirth Dropdown
    local rebirthOptions = {}
    for option, value in pairs(m.Rebirths) do
        table.insert(rebirthOptions, { Name = string.format('%s Rebirths', tostring(option)), Value = option })
    end

    sections.Farming_Rebirth:CreateDropdown({
        Name = "Select Rebirth Option",
        Options = rebirthOptions,
        CurrentOption = {},
        Flag = "RebirthDropdown",
        Callback = function(selectedOption)
            print("Selected Rebirth Option:", selectedOption)
        end
    })

    -- Auto Rebirth Toggle
    sections.Farming_Rebirth:CreateToggle({
        Name = "Enable Auto Rebirth",
        CurrentValue = false,
        Flag = "AutoRebirthToggle",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoRebirthToggle'
                return
            end
            o.new('AutoRebirthToggle', function()
                while task.wait(0.5) do
                    local selectedOption = ai.Value
                    if not selectedOption then continue end
                    local bestOption = (selectedOption.Value == math.huge and q.GetBestRebirthOption()) or selectedOption.Value
                    if q.CanAffordRebirth(bestOption) then
                        I:rebirth(bestOption)
                    end
                end
            end):Start()
        end
    })
end

-- Farming Tab: Egg Hatching Section
do
    -- Egg Dropdown
    local eggOptions = {}
    for eggName, eggData in pairs(m.Eggs) do
        table.insert(eggOptions, { Name = string.format('%s Egg | Price: %s', tostring(eggName), tostring(V.suffixes(eggData.cost))), Value = eggName, Cost = eggData.cost or 0 })
    end
    table.sort(eggOptions, function(a, b) return a.Cost < b.Cost end)

    sections.Farming_Hatching:CreateDropdown({
        Name = "Select Egg",
        Options = eggOptions,
        CurrentOption = {},
        Flag = "EggDropdown",
        Callback = function(selectedEgg)
            print("Selected Egg:", selectedEgg)
        end
    })

    -- Hide Hatch Animation Toggle
    sections.Farming_Hatching:CreateToggle({
        Name = "Hide Hatch Animation",
        CurrentValue = false,
        Flag = "HideHatchAnimation",
        Callback = function(enabled)
            local originalFunction
            originalFunction = hookfunction(R.eggAnimation, function(...)
                if enabled then return nil end
                return originalFunction(...)
            end)
        end
    })

    -- Auto Open Eggs Toggle
    sections.Farming_Hatching:CreateToggle({
        Name = "Enable Auto Open Eggs",
        CurrentValue = false,
        Flag = "AutoOpenEggs",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoOpenEggs'
                return
            end
            o.new('AutoOpenEggs', function()
                while task.wait(0.016666666666666665) do
                    local selectedEgg = am.Value
                    if not selectedEgg then continue end
                    local requiredMap = m.Eggs[selectedEgg.Value].requiredMap
                    if requiredMap and not T.data.maps[requiredMap] then continue end
                    local maxAffordable = m.Util.eggUtils.getMaxAffordable(B, T.data, selectedEgg.Value)
                    if m.Util.eggUtils.hasEnoughToOpen(T.data, selectedEgg.Value, maxAffordable) then
                        J.openEgg:Fire(selectedEgg.Value, maxAffordable)
                        task.wait(4.15 / m.Values.hatchSpeed(B, T.data))
                    end
                end
            end):Start()
        end
    })
end

-- Farming Tab: Upgrade Management Section
do
    -- Upgrade Dropdown
    local upgradeOptions = {}
    for upgradeName, upgradeData in pairs(m.Upgrades) do
        table.insert(upgradeOptions, { Name = V.toPascal(upgradeName), Value = upgradeName })
    end

    sections.Farming_Upgrades:CreateDropdown({
        Name = "Select Upgrades",
        Options = upgradeOptions,
        CurrentOption = {},
        MultiSelection = true,
        Flag = "UpgradesDropdown",
        Callback = function(selectedUpgrades)
            print("Selected Upgrades:", selectedUpgrades)
        end
    })

    -- Auto Buy Upgrades Toggle
    sections.Farming_Upgrades:CreateToggle({
        Name = "Enable Auto Buy Upgrades",
        CurrentValue = false,
        Flag = "AutoUpgradeToggle",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoUpgradeToggle'
                return
            end
            o.new('AutoUpgradeToggle', function()
                while task.wait(0.5) do
                    local selectedUpgrades = ap.Value
                    if l.GetDictionarySize(selectedUpgrades) < 1 then continue end
                    for _, upgrade in ipairs(selectedUpgrades) do
                        local upgradeName, upgradeValue = upgrade.Name, upgrade.Value
                        local upgradeData = m.Upgrades[upgradeValue]
                        if upgradeData.requiredMap and not T.data.maps[upgradeData.requiredMap] then continue end
                        local currentLevel = (T.data.upgrades[upgradeValue] or 0) + 1
                        local nextUpgrade = upgradeData.upgrades[currentLevel]
                        if not nextUpgrade then continue end
                        if nextUpgrade.cost > T.data.gems then continue end
                        if L:upgrade(upgradeValue) == "success" then
                            Rayfield:Notify({
                                Title = "Upgrade Purchased",
                                Content = string.format("Bought %s at level %s.", tostring(upgradeName), tostring(currentLevel)),
                                Duration = 1.5
                            })
                        end
                    end
                end
            end):Start()
        end
    })
end

-- Crops Tab: Crop Collection Section
do
    -- Crop Dropdown
    local cropOptions = {}
    for farmName, farmData in pairs(m.Farms) do
        if not farmData.isNotFarm then
            table.insert(cropOptions, { Name = V.toPascal(farmName), Value = farmName, IsAFarm = true })
        end
    end

    sections.Crops_Claim:CreateDropdown({
        Name = "Select Crops",
        Options = cropOptions,
        CurrentOption = {},
        MultiSelection = true,
        Flag = "CropDropdown",
        Callback = function(selectedCrops)
            print("Selected Crops:", selectedCrops)
        end
    })

    -- Auto Claim Crops Toggle
    sections.Crops_Claim:CreateToggle({
        Name = "Enable Auto Claim Crops",
        CurrentValue = false,
        Flag = "AutoClaimCrops",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoClaimCrops'
                return
            end
            o.new('AutoClaimCrops', function()
                while task.wait(0.5) do
                    local selectedCrops = ag.Value
                    if l.GetDictionarySize(selectedCrops) == 0 then continue end
                    for _, crop in ipairs(selectedCrops) do
                        local cropName, cropValue = crop.Name, crop.Value
                        if not T.data.farms[cropValue] then continue end
                        if S:getTimeLeft(cropValue) > 0 then continue end
                        if K:claim(cropValue) == "success" then
                            Rayfield:Notify({
                                Title = "Crops Claimed",
                                Content = string.format("%s has been claimed!", tostring(cropName)),
                                Duration = 1.5
                            })
                        end
                    end
                end
            end):Start()
        end
    })
end

-- Crops Tab: Crop Upgrades Section
do
    -- Crop Upgrade Dropdown
    local upgradeCropOptions = {}
    for farmName, farmData in pairs(m.Farms) do
        table.insert(upgradeCropOptions, { Name = V.toPascal(farmName), Value = farmName })
    end

    sections.Crops_Upgrade:CreateDropdown({
        Name = "Select Crops",
        Options = upgradeCropOptions,
        CurrentOption = {},
        MultiSelection = true,
        Flag = "UpgradeCropDropdown",
        Callback = function(selectedCrops)
            print("Selected Crops for Upgrade:", selectedCrops)
        end
    })

    -- Auto Upgrade Crops Toggle
    sections.Crops_Upgrade:CreateToggle({
        Name = "Enable Auto Upgrade Crops",
        CurrentValue = false,
        Flag = "AutoUpgradeCrops",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoUpgradeCrops'
                return
            end
            o.new('AutoUpgradeCrops', function()
                while task.wait(0.5) do
                    local selectedCrops = ai.Value
                    if l.GetDictionarySize(selectedCrops) == 0 then continue end
                    for _, crop in ipairs(selectedCrops) do
                        local cropName, cropValue = crop.Name, crop.Value
                        local farmData = T.data.farms[cropValue]
                        if not farmData then
                            local farmInfo = m.Farms[cropValue]
                            local price = farmInfo.price or math.huge
                            if T.data.gems <= price then continue end
                            if K:buy(cropValue) == "success" then
                                Rayfield:Notify({
                                    Title = "Crop Purchased",
                                    Content = string.format("%s has been bought!", tostring(cropName)),
                                    Duration = 1.5
                                })
                                task.wait(0.2)
                            end
                            continue
                        end
                        local currentStage = (farmData.stage or 0) + 1
                        local upgrades = m.Farms[cropValue].upgrades
                        if not upgrades then continue end
                        local nextUpgrade = upgrades[currentStage]
                        if not nextUpgrade then continue end
                        local upgradePrice = nextUpgrade.price or math.huge
                        if T.data.gems <= upgradePrice then continue end
                        if K:upgrade(cropValue) == "success" then
                            Rayfield:Notify({
                                Title = "Crop Upgraded",
                                Content = string.format("%s upgraded to stage %s!", tostring(cropName), tostring(currentStage)),
                                Duration = 1.5
                            })
                        end
                    end
                end
            end):Start()
        end
    })
end

-- Miscellaneous Tab: Chest Handling Section
do
    -- Auto Claim Chests Toggle
    sections.Misc_Chests:CreateToggle({
        Name = "Enable Auto Claim Chests",
        CurrentValue = false,
        Flag = "AutoClaimChests",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoClaimChests'
                return
            end
            o.new('AutoClaimChests', function()
                while task.wait(0.5) do
                    for chestName, chestData in pairs(m.Chests) do
                        if chestData.group and select(2, pcall(B.IsInGroup, B, game.CreatorId)) ~= true then
                            print"Not in group"
                            continue
                        end
                        local lastClaimed = T.data.chests[chestName] or 0
                        if os.time() < lastClaimed + chestData.cooldown then continue end
                        if M:claimChest(chestName) == "success" then
                            Rayfield:Notify({
                                Title = "Chest Claimed",
                                Content = string.format("%s chest has been opened!", tostring(chestName)),
                                Duration = 1.5
                            })
                        end
                    end
                end
            end):Start()
        end
    })

    -- Claim Minichests Button
    sections.Misc_Chests:CreateButton({
        Name = "Claim Minichests",
        Callback = function()
            for _, chest in A:GetTagged'MiniChest' do
                local prompt = D(chest, 'ProximityPrompt', true)
                if not prompt then continue end
                fireproximityprompt(prompt, 0)
                fireproximityprompt(prompt, 1)
            end
        end
    })
end

-- Miscellaneous Tab: Item Usage Section
do
    -- Potions Dropdown
    local potionOptions = {}
    for potionName, potionData in pairs(m.Potions) do
        table.insert(potionOptions, { Name = potionData.name, Layout = potionData.layoutOrder, Value = potionName })
    end
    table.sort(potionOptions, function(a, b) return a.Layout > b.Layout end)

    sections.Misc_Items:CreateDropdown({
        Name = "Select Potions",
        Options = potionOptions,
        CurrentOption = {},
        MultiSelection = true,
        Flag = "PotionsDropdown",
        Callback = function(selectedPotions)
            print("Selected Potions:", selectedPotions)
        end
    })

    -- Auto Use Potions Toggle
    sections.Misc_Items:CreateToggle({
        Name = "Enable Auto Use Potions",
        CurrentValue = false,
        Flag = "AutoUsePotions",
        Callback = function(enabled)
            if not enabled then
                o.TerminateByIndex'AutoUsePotions'
                return
            end
            o.new('AutoUsePotions', function()
                while task.wait(0.5) do
                    local selectedPotions = ag.Value
                    if l.GetDictionarySize(selectedPotions) == 0 then continue end
                    for _, potion in ipairs(selectedPotions) do
                        local potionName, potionValue = potion.Name, potion.Value
                        if T.data.activeBoosts[potionValue] then continue end
                       