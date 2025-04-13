
-- Auza Hub
-- Made by iKazu
-- Enhanced with Auto Dungeon System

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

-- References
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Create window
local Window = Fluent:CreateWindow({
    Title = "Auza Hub",
    SubTitle = "Made by iKazu",
    TabWidth = 180, -- Fixed: slightly wider tabs
    Size = UDim2.fromOffset(580, 420),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Create tabs individually (correct method)
local MainTab = Window:AddTab({ Title = "Auto Roll", Icon = "refresh-cw" })
local DungeonTab = Window:AddTab({ Title = "Dungeon", Icon = "map" })
local WebhookTab = Window:AddTab({ Title = "Webhook", Icon = "link" })
local MiscellaneousTab = Window:AddTab({ Title = "Miscellaneous", Icon = "tool" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "settings" })

-- Options reference
local Options = Fluent.Options

-- Variables
local isRolling = false
local rollConnection = nil
local rollDelay = 0.1
local isMinimized = false
local miniButton = nil

-- Webhook Tab (Rewritten)
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- Detect request function
local req = http_request or request or (http and http.request) or (fluxus and fluxus.request) or (syn and syn.request)
if not req then
    warn("[AuzaHub] No HTTP request function available!")
    return
end

-- Load Equipment
local Equipment = require(ReplicatedStorage.Modules.Equipment)
local UpdateInventory = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("UpdateInventory")

-- Assets
local thumbnail_url = "https://cdn.discordapp.com/attachments/1354333763168899180/1360508574983262219/standard.gif"
local footer_icon_url = "https://cdn.discordapp.com/attachments/1354333763168899180/1354382778359349392/fdb2369d-bda9-4c04-ae61-0a44c1ba28a0-removebg-preview.png"
local discord_invite_url = "https://discord.gg/REJkGXJtqx"

-- Setup rarity colors
local itemRarity = {}
local rarityColors = {
    Common = 0x808080,
    Uncommon = 0x00FF00,
    Rare = 0x0000FF,
    Epic = 0x800080,
    Legendary = 0xFFD700,
    Mythical = 0xFF4500
}

for rarity, items in pairs(Equipment) do
    for _, item in pairs(items) do
        if item.item_name then
            itemRarity[item.item_name] = rarity
        end
    end
end

-- Webhook file management
local function saveWebhook(url)
    if not isfolder("AuzaHub") then
        makefolder("AuzaHub")
    end
    if isfile("AuzaHub/Webhook.txt") then
        delfile("AuzaHub/Webhook.txt")
    end
    writefile("AuzaHub/Webhook.txt", url)
end

local function getWebhookURL()
    if readfile and isfile and isfile("AuzaHub/Webhook.txt") then
        local content = readfile("AuzaHub/Webhook.txt")
        if content and content ~= "" then
            return content
        end
    end
    warn("[AuzaHub] Webhook.txt missing or empty!")
    return nil
end

-- Send webhook
local function sendWebhook(equipment)
    local webhook = getWebhookURL()
    if not webhook then return end

    local rarity = itemRarity[equipment.item_name] or "Unknown"
    local embedColor = rarityColors[rarity] or 0x00FFFF

    local equipmentEmbed = {
        title = "New Rolled Equipment!",
description = "**Item:** " .. (equipment.item_name or "Unknown") .. "\n"
    .. "**Type:** " .. (equipment.item_type or "Unknown") .. "\n"
    .. "**Rarity:** " .. rarity .. "\n"
    .. "**Level:** " .. tostring(equipment.Level or 1) .. "\n"
    .. "**Stat Multiplier:** " .. string.format("%.2f", equipment.stat_multiplier or 1),

        color = embedColor,
        thumbnail = { url = thumbnail_url },
        footer = { text = "iKazu on Top!", icon_url = footer_icon_url },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    local inviteEmbed = {
        title = "Join our Discord Server!",
        description = "[Click here to join!](" .. discord_invite_url .. ")",
        color = 0x5865F2,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    req({
        Url = webhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ embeds = { equipmentEmbed, inviteEmbed } })
    })
end

-- Track Inventory
local lastUIDs = {}

local function initializeLastUIDs()
    local InventoryRemote = ReplicatedStorage.Remotes:WaitForChild("GetInventory")
    local success, Inventory = pcall(function()
        return InventoryRemote:InvokeServer()
    end)

    if success and type(Inventory) == "table" and Inventory.Equipment then
        for _, equipment in ipairs(Inventory.Equipment) do
            if equipment.UID then
                lastUIDs[equipment.UID] = true
            end
        end
        print("[AuzaHub] Inventory initialized.")
    else
        warn("[AuzaHub] Failed to initialize inventory!")
    end
end

initializeLastUIDs()

-- Hook UpdateInventory
UpdateInventory.OnClientEvent:Connect(function(Inventory, ...)
    if type(Inventory) == "table" and Inventory.Equipment then
        local newUIDs = {}
        for _, equipment in ipairs(Inventory.Equipment) do
            if equipment.UID then
                newUIDs[equipment.UID] = equipment
            end
        end

        for uid, equipment in pairs(newUIDs) do
            if not lastUIDs[uid] then
                sendWebhook(equipment)
                print("[AuzaHub] Sent webhook for:", equipment.item_name)
            end
        end

        lastUIDs = newUIDs
    end
end)

-- WebhookTab UI
local webhookInput = WebhookTab:AddInput("WebhookURL", {
    Title = "Webhook URL",
    Description = "Paste your Discord webhook here.",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default = ""
})

WebhookTab:AddButton({
    Title = "Save Webhook",
    Description = "Save the webhook URL to AuzaHub/Webhook.txt",
    Callback = function()
        local url = webhookInput.Value
        if url and url ~= "" then
            saveWebhook(url)
            Fluent:Notify({
                Title = "Webhook Saved",
                Content = "Your webhook has been saved successfully!",
                Duration = 3
            })
            print("[AuzaHub] Webhook saved:", url)
        else
            warn("[AuzaHub] Please enter a valid webhook URL.")
            Fluent:Notify({
                Title = "Error",
                Content = "Please enter a valid webhook URL!",
                Duration = 3
            })
        end
    end
})
-- Dungeon Variables
local lobbyReady = false
local replayWaitStart = nil
local replayWaitStart = nil
local selectedMap = "DoubleDungeonD"
local selectedDifficulty = "Hard"
local autoDungeonEnabled = false
local dungeonConnection = nil
local isInDungeon = false
local isInLobby = false
local dungeonStarted = false
local lastNotificationTime = 0
local notificationCooldown = 2 -- Cooldown for notifications to prevent spam

-- Anti-AFK Variables
local antiAfkEnabled = false
local afkConnection = nil

-- Player Character Update
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Function to load an image from a Roblox decal asset ID
local function LoadImageFromDecalId(decalId)
    -- Load the decal asset
    local decalAsset = game:GetObjects("rbxassetid://" .. decalId)[1]
    if not decalAsset or not decalAsset:IsA("Decal") then
        warn("Failed to load decal asset!")
        return nil
    end
    -- Get the real image texture ID
    local textureId = decalAsset.Texture
    return textureId
end


-- Full lobby setup: create, set difficulty, start
local function setupLobbyFlow()
    if lobbyReady then return end -- If lobby already setup, skip

    local successCreate = pcall(function()
        ReplicatedStorage.Remotes.createLobby:InvokeServer(selectedMap)
    end)
    if not successCreate then return end
    task.wait(1)

    local successDifficulty = pcall(function()
        ReplicatedStorage.Remotes.LobbyDifficulty:FireServer(selectedDifficulty)
    end)
    if not successDifficulty then return end
    task.wait(1)

    local successStart = pcall(function()
        ReplicatedStorage.Remotes.LobbyStart:FireServer()
    end)
    if not successStart then return end

    lobbyReady = true

    Fluent:Notify({
        Title = "Lobby Ready",
        Content = "Lobby created and ready to go!",
        Duration = 3
    })
end


-- Create mini UI for mobile
local function createMiniUI()
    -- Create ScreenGui for the mini UI
    local miniGui = Instance.new("ScreenGui")
    miniGui.Name = "AuzaHubMini"
    miniGui.ResetOnSpawn = false
    miniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- For mobile support
    if syn and syn.protect_gui then
        syn.protect_gui(miniGui)
    end

    -- Main button frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MiniButton"
    mainFrame.Size = UDim2.new(0, 60, 0, 60) -- Square size
    mainFrame.Position = UDim2.new(0.1, 0, 0.5, 0) -- Position on the screen
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = miniGui

    -- Add stroke for better visibility
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(80, 80, 80)
    uiStroke.Thickness = 2
    uiStroke.Parent = mainFrame

    -- Load image from Roblox decal asset ID
    local decalId = 125145981854078 -- Replace with your decal asset ID
    local textureId = LoadImageFromDecalId(decalId)
    if not textureId then
        warn("Failed to load image for mini UI!")
        return
    end

    -- Add image
    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "Logo"
    logoImage.Size = UDim2.new(0.9, 0, 0.9, 0) -- Slightly smaller than the frame
    logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = textureId -- Use the fetched texture ID
    logoImage.Parent = mainFrame

    -- Click detection
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Toggle between minimized and restored states
            if isMinimized then
                -- Restore the main UI
                isMinimized = false
                Window:Minimize(false)
            else
                -- Minimize the main UI
                isMinimized = true
                Window:Minimize(true)
            end
        end
    end)

    -- Add to PlayerGui
    miniGui.Parent = PlayerGui
    miniGui.Enabled = true -- Ensure the mini UI is visible
    return {
        Gui = miniGui,
        Button = mainFrame
    }
end

-- Function to find closest mob
local function getClosestMob()
    if not workspace:FindFirstChild("Mobs") then return nil end
    
    local closestMob = nil
    local closestDistance = math.huge
    
    for _, mob in pairs(workspace.Mobs:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestMob = mob
            end
        end
    end
    
    return closestMob
end

-- Function to attack enemy
local function attackEnemy()
    if not Character or not HumanoidRootPart then return end
    
    -- Fire combat remote
    pcall(function()
        ReplicatedStorage.Remotes.Combat:FireServer()
    end)
end

-- Modified function to check if player is in dungeon or lobby according to the requirements
local function checkPlayerLocation()
    -- Check if in lobby (if workspace.Map has a child named Lobby)
    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Lobby") then
        isInLobby = true
        isInDungeon = false
        return "lobby"
    end
    
    -- Check if in dungeon (if workspace.Map has a child matching any of the map names)
    if workspace:FindFirstChild("Map") and (
        workspace.Map:FindFirstChild("DoubleDungeonD") or
        workspace.Map:FindFirstChild("GoblinCave") or
        workspace.Map:FindFirstChild("SpiderCavern")
    ) then
        isInLobby = false
        isInDungeon = true
        return "dungeon"
    end
    
    -- In neither dungeon nor lobby
    isInLobby = false
    isInDungeon = false
    return "none"
end

-- Function to create lobby - FIXED
local function createLobby()
    -- Direct call to the remote with proper pcall for error handling
    local success, result = pcall(function()
        return ReplicatedStorage.Remotes.createLobby:InvokeServer(selectedMap)
    end)
    
    if success then
        -- Notify the user
        -- Removed lobby created notification inside createLobby
        return true
    else
        Fluent:Notify({
            Title = "Error",
            Content = "Failed to create lobby! Retrying...",
            Duration = 2
        })
        return false
    end
end

-- Function to set difficulty with notification cooldown
local function setDifficulty()
    -- Check if notification cooldown has passed
    local currentTime = os.time()
    if currentTime - lastNotificationTime < notificationCooldown then
        -- Skip notification if we're still in cooldown
        local success, result = pcall(function()
            return ReplicatedStorage.Remotes.LobbyDifficulty:FireServer(selectedDifficulty)
        end)
        return success
    end
    
    local success, result = pcall(function()
        return ReplicatedStorage.Remotes.LobbyDifficulty:FireServer(selectedDifficulty)
    end)
    
    if success then
        lastNotificationTime = currentTime
        return true
    else
        lastNotificationTime = currentTime
        Fluent:Notify({
            Title = "Error",
            Content = "Failed to set difficulty! Retrying...",
            Duration = 2
        })
        return false
    end
end

-- Function to start lobby with notification cooldown
local function startLobby()
    -- Check if notification cooldown has passed
    local currentTime = os.time()
    if currentTime - lastNotificationTime < notificationCooldown then
        -- Skip notification if we're still in cooldown
        local success = pcall(function()
            ReplicatedStorage.Remotes.LobbyStart:FireServer()
            return true
        end)
        return success
    end
    
    local success, result = pcall(function()
        ReplicatedStorage.Remotes.LobbyStart:FireServer()
        return true
    end)
    
    if success then
        lastNotificationTime = currentTime
        return true
    else
        lastNotificationTime = currentTime
        Fluent:Notify({
            Title = "Error",
            Content = "Failed to start lobby! Retrying...",
            Duration = 2
        })
        return false
    end
end

-- Function to start dungeon with notification cooldown
local function startDungeon()
    -- Check if notification cooldown has passed
    local currentTime = os.time()
    if currentTime - lastNotificationTime < notificationCooldown then
        -- Skip notification if we're still in cooldown
        local success = pcall(function()
            return ReplicatedStorage.Remotes.DungeonStart:FireServer()
        end)
        if success then dungeonStarted = true end
        return success
    end
    
    local success, result = pcall(function()
        return ReplicatedStorage.Remotes.DungeonStart:FireServer()
    end)
    
    if success then
        dungeonStarted = true
        lastNotificationTime = currentTime
        Fluent:Notify({
            Title = "Dungeon Started",
            Content = "Successfully initiated the dungeon.",
            Duration = 2
        })
        return true
    else
        lastNotificationTime = currentTime
        Fluent:Notify({
            Title = "Error",
            Content = "Failed to start dungeon! Retrying...",
            Duration = 2
        })
        return false
    end
end

-- Show welcome notification
task.defer(function()
    task.wait(1)
    Fluent:Notify({
        Title = "Auza Hub",
        Content = "Ready to clap!",
        Duration = 3
    })
end)

-- Auto Roll Tab
do
    MainTab:AddParagraph({
        Title = "Auto Roll",
        Content = "Automates rolling equipment for you. Set it up and let it handle everything."
    })

    -- Roll Status Display
    local StatusParagraph = MainTab:AddParagraph({
        Title = "Status",
        Content = "Idle"
    })

    -- Update status function
    local function updateStatus()
        local status = isRolling and "Rolling" or "Idle"
        StatusParagraph:SetDesc(status)
    end

    -- Auto Roll Toggle
    local Toggle = MainTab:AddToggle("AutoRoll", {
        Title = "Auto Roll Equipment",
        Description = "Automatically rolls equipment for you.",
        Default = false
    })

    Toggle:OnChanged(function()
        isRolling = Options.AutoRoll.Value
        if isRolling then
            -- Start auto rolling
            Fluent:Notify({
                Title = "Auto Roll",
                Content = "Started auto rolling equipment.",
                Duration = 2
            })
            rollConnection = RunService.Heartbeat:Connect(function()
                if not isRolling then return end
                task.wait(rollDelay)
                -- Use pcall to safely execute the remote call
                local success, result = pcall(function()
                    return ReplicatedStorage.Remotes.Roll:InvokeServer()
                end)
                if not success then
                    -- Error handling
                    Fluent:Notify({
                        Title = "Error",
                        Content = "Roll failed! Check console for details.",
                        Duration = 3
                    })
                    print("Auza Hub Error:", tostring(result))
                    -- Disable auto roll on error
                    isRolling = false
                    Options.AutoRoll:SetValue(false)
                    if rollConnection then
                        rollConnection:Disconnect()
                        rollConnection = nil
                    end
                    updateStatus()
                end
            end)
        else
            -- Stop auto rolling
            if rollConnection then
                rollConnection:Disconnect()
                rollConnection = nil
            end
            Fluent:Notify({
                Title = "Auto Roll",
                Content = "Stopped auto rolling equipment.",
                Duration = 2
            })
            updateStatus()
        end
    end)
end

-- Enhanced Dungeon Tab
do
    -- Status display
    local DungeonStatusParagraph = DungeonTab:AddParagraph({
        Title = "Dungeon Status",
        Content = "Idle - Waiting for Auto Dungeon to be enabled"
    })
    
    -- Update dungeon status function
    local function updateDungeonStatus()
        local location = checkPlayerLocation()
        local status = "Idle - Auto Dungeon: " .. (autoDungeonEnabled and "Enabled" or "Disabled")
        
        if autoDungeonEnabled then
            if location == "lobby" then
                status = "In Lobby - Preparing for dungeon"
            elseif location == "dungeon" then
                status = dungeonStarted and "In Dungeon - Farming enemies" or "In Dungeon - Starting dungeon"
            else
                status = "Creating lobby for " .. selectedMap
            end
        end
        
        DungeonStatusParagraph:SetDesc(status)
    end

    -- Map Selection Dropdown
    local MapDropdown = DungeonTab:AddDropdown("MapSelection", {
        Title = "Select Dungeon Map",
        Description = "Choose the map for your dungeon lobby.",
        Values = { "DoubleDungeonD", "GoblinCave", "SpiderCavern" },
        Default = "DoubleDungeonD"
    })

    MapDropdown:OnChanged(function(Value)
        selectedMap = Value
        -- Removed map select notification
    end)
    
    -- Difficulty Selection Dropdown
    local DifficultyDropdown = DungeonTab:AddDropdown("DifficultySelection", {
        Title = "Select Difficulty",
        Description = "Choose the difficulty for your dungeon.",
        Values = { "Easy", "Hard" },
        Default = "Hard"
    })
    
    DifficultyDropdown:OnChanged(function(Value)
        selectedDifficulty = Value
        -- Removed difficulty select notification
    end)

    -- Auto Replay Toggle

    -- Auto Replay Toggle
    DungeonTab:AddToggle("AutoReplay", {
        Title = "Auto Replay Dungeon",
        Description = "Automatically replays the dungeon after clearing.",
        Default = false
    })

    -- Auto Dungeon Toggle
    DungeonTab:AddToggle("AutoDungeon", {
        Title = "Auto Dungeon",
        Description = "Fully automates the dungeon process from lobby creation to farming.",
        Default = false
    })
    
    Options.AutoDungeon:OnChanged(function()
        autoDungeonEnabled = Options.AutoDungeon.Value
        dungeonStarted = false
        
        if autoDungeonEnabled then
            -- Start auto dungeon process
            Fluent:Notify({
                Title = "Auto Dungeon",
                Content = "Auto Dungeon enabled. Managing everything automatically!",
                Duration = 3
            })
            
            dungeonConnection = RunService.Heartbeat:Connect(function()
                if not autoDungeonEnabled then return end
                
                -- Check player location
                local location = checkPlayerLocation()
                updateDungeonStatus()
                
                -- Handle based on location with proper sequence control
                if location == "lobby" then
                    -- Player is in the Lobby map
                    if not isInDungeon then
                        local lobbyCreated = createLobby()
                        task.wait(2)
                        
                        local difficultySet = setDifficulty()
                        if difficultySet then
                            task.wait(1)
                            startLobby()
                        end
                        task.wait(1)
                    end
                elseif location == "lobby" then
                    -- In lobby, set difficulty and start
                    local difficultySet = setDifficulty()
                    if difficultySet then
                        -- Wait for difficulty to be fully applied
                        task.wait(1)
                        
                        -- Try to start lobby
                        startLobby()
                        
                        -- Grouped Notification after setting up lobby
                        Fluent:Notify({
                            Title = "Lobby Ready",
                            Content = "Lobby created, difficulty set, and ready to start!",
                            Duration = 3
                        })

                    end
                    
                    -- Wait after lobby operations
                    task.wait(1)
                elseif location == "dungeon" and not dungeonStarted then
                    -- In dungeon but not started, start it
                    startDungeon()
                    
                    -- Wait for dungeon to fully start
                    task.wait(1)
                elseif location == "dungeon" and dungeonStarted then
                    -- In dungeon and started, handle combat
                    local target = getClosestMob()
                    
                    if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                        -- Teleport 8 studs above enemy (fixed height)
                        local targetPosition = target.HumanoidRootPart.Position + Vector3.new(0, 8, 0)
                        if HumanoidRootPart then
                            HumanoidRootPart.CFrame = CFrame.new(targetPosition, target.HumanoidRootPart.Position)
                            attackEnemy()
                        end
                    end
                end

                -- Handle auto replay after dungeon clear
                if Options.AutoReplay and Options.AutoReplay.Value then
                    if workspace:FindFirstChild("Mobs") and #workspace.Mobs:GetChildren() == 0 then
                        if not replayWaitStart then
                            replayWaitStart = tick()
                        elseif tick() - replayWaitStart >= 7 then
                            -- Replay Dungeon
                            pcall(function()
                                game:GetService("ReplicatedStorage").Remotes.ReplayDungeon:FireServer()
                            end)
                            replayWaitStart = nil
                        end
                    else
                        replayWaitStart = nil
                    end
                end

            end)
        else
            -- Stop auto dungeon process
            if dungeonConnection then
                dungeonConnection:Disconnect()
                dungeonConnection = nil
            end
            Fluent:Notify({
                Title = "Auto Dungeon",
                Content = "Auto Dungeon disabled.",
                Duration = 2
            })
            updateDungeonStatus()
        end
    end)
    
    -- Manual Lobby Creation Button for testing
    DungeonTab:AddButton({
        Title = "Create Lobby Manually",
        Description = "Manually create a lobby with the selected map",
        Callback = function()
            -- Direct call to create lobby
            ReplicatedStorage.Remotes.createLobby:InvokeServer(selectedMap)
            Fluent:Notify({
                Title = "Manual Lobby Creation",
                Content = "Created a lobby for: " .. selectedMap,
                Duration = 2
            })
        end
    })
end


-- FPS Boost Button
MiscellaneousTab:AddButton({
    Title = "Boost FPS",
    Description = "Run FPS optimization script.",
    Callback = function()
        _G.Settings = {
            Players = {
                ["Ignore Me"] = true,
                ["Ignore Others"] = false
            },
            Meshes = {
                Destroy = false,
                LowDetail = true
            },
            Images = {
                Invisible = true,
                LowDetail = false,
                Destroy = false
            },
            ["No Particles"] = true,
            ["No Camera Effects"] = true,
            ["No Explosions"] = true,
            ["No Clothes"] = true,
            ["Low Water Graphics"] = true,
            ["No Shadows"] = true,
            ["Low Rendering"] = true,
            ["Low Quality Parts"] = true
        }
        loadstring(game:HttpGet("https://raw.githubusercontent.com/definitelynotkazu/Auza/refs/heads/main/fps%20boost"))()
    end
})

-- Anti-AFK Toggle
local AntiAfkToggle = MiscellaneousTab:AddToggle("AntiAFK", {
    Title = "Anti-AFK",
    Description = "Prevents you from being kicked for being idle.",
    Default = false
})

local VirtualUser = game:GetService("VirtualUser")
local AntiAFKConnection

Options.AntiAFK:OnChanged(function()
    if Options.AntiAFK.Value then
        AntiAFKConnection = Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    else
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        end
    end
end)


-- Add the Save Manager to the Settings tab
SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("AuzaHub")
SaveManager:BuildConfigSection(SettingsTab)

-- Add the Interface Manager to the Settings tab
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("AuzaHub")
InterfaceManager:BuildInterfaceSection(SettingsTab)

-- Create the mini UI for mobile
miniButton = createMiniUI()

-- Initialize with loaded settings
SaveManager:LoadAutoloadConfig()