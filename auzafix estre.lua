local a = {
    {
        ClassName = "LocalScript",
        Closure = function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end

            if Fluent then
                Fluent.Destroy()
            end

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

            local Z = n.Fluent
            local _ = n.SaveManager
            local aa = n.ThemeManager

            getgenv().Fluent = Z

            local ab = Z:CreateWindow{
                Title = "strelizia.cc",
                SubTitle = "v" .. s.LRM_ScriptVersion,
                TabWidth = 120,
                Size = UDim2.fromOffset(600, 480),
                Resize = true,
                MinSize = Vector2.new(430, 350),
                Acrylic = false,
                Theme = "Darker",
                MinimizeKey = Enum.KeyCode.RightControl
            }

            local ac = {
                Home = ab:CreateTab{ Title = "Home", Icon = "house" },
                Farming = ab:CreateTab{ Title = "Farming", Icon = "egg" },
                Crops = ab:CreateTab{ Title = "Crops", Icon = "wheat" },
                Misc = ab:CreateTab{ Title = "Others", Icon = "circle-ellipsis" },
                Settings = ab:CreateTab{ Title = "Settings", Icon = "settings" },
            }

            local ad = {
                Home_Information = ac.Home:AddSection"↳ Information",
                Home_Credits = ac.Home:AddSection"↳ Credits",
                Farming_Clicking = ac.Farming:AddSection"↳ Clicking",
                Farming_Rebirth = ac.Farming:AddSection"↳ Rebirthing",
                Farming_Hatching = ac.Farming:AddSection"↳ Hatching",
                Farming_Upgrades = ac.Farming:AddSection"↳ Upgrades",
                Crops_Claim = ac.Crops:AddSection"↳ Auto Claim",
                Crops_Upgrade = ac.Crops:AddSection"↳ Auto Upgrade",
                Other_Chests = ac.Misc:AddSection"↳ Chests",
                Other_Items = ac.Misc:AddSection"↳ Items",
                Other_Combining = ac.Misc:AddSection"↳ Combining",
                Other_Misc = ac.Misc:AddSection"↳ Misc"
            }

            do
                local ae = ad.Home_Information:CreateParagraph("ClientUptimeParagraph", {
                    Title = "Client Uptime: nil",
                    TitleAlignment = Enum.TextXAlignment.Center,
                })

                o.new("ClientUptimeParagraph", function(af)
                    while Z.Loaded and task.wait(1) do
                        ae.Instance.TitleLabel.Text = string.format("Script Uptime: %s", r.FormatHms(r.GetUptime()))
                    end
                end):Start()

                local af = ad.Home_Information:CreateParagraph("LuaHeapParagraph", {
                    Title = "Lua Heap (Megabytes): nil",
                    TitleAlignment = Enum.TextXAlignment.Center,
                })

                o.new("LuaHeapParagraph", function(ag)
                    while Z.Loaded and task.wait(1) do
                        af.Instance.TitleLabel.Text = string.format('Lua Heap: %sMB', tostring(r.CommaNumber(math.ceil(gcinfo() / 1000))))
                    end
                end):Start()

                ad.Home_Information:CreateButton{
                    Title = "Join Discord",
                    Description = "prompts discord invite if the user is on pc, copies to clipboard otherwise",
                    Callback = function()
                        r.PromptDiscordJoin('Vf4Wu3Cft7', true)
                        Z:Notify{
                            Title = "Discord Prompted/Copied",
                            Content = "discord invite has been prompted/copied to your clipboard!",
                            Duration = 2
                        }
                    end
                }

                ad.Home_Credits:CreateParagraph("Credits", {
                    Title = "vma, kalas, pryxo (felix was moral support!!)",
                    TitleAlignment = Enum.TextXAlignment.Center,
                })
            end

            do
                local ae = ad.Farming_Clicking:Toggle("AutoClickToggle", {
                    Title = "Auto Click",
                    Default = false,
                    Description = "automatically clicks for you"
                })

                ae:OnChanged(function(af)
                    if not af then
                        o.TerminateByIndex'AutoClickToggle'
                        return
                    end

                    o.new('AutoClickToggle', function(ag)
                        while Z.Loaded and task.wait() do
                            H.click:Fire()
                        end
                    end):Start()
                end)

                local af = i.promisify(V.suffixes)

                local function ag()
                    local ah = q.GetUnlockedRebirthOptions()
                    local ai = {}

                    for aj, ak in ah do
                        local al, am = af(ak):await()
                        table.insert(ai, { Name = string.format('%s Rebirths', tostring(am)), Value = aj })
                    end

                    table.insert(ai, { Name = 'Best Option Unlocked', Value = math.huge })

                    return ai
                end

                local ah = ag()

                local ai = ad.Farming_Rebirth:Dropdown("RebirthsDropdown", {
                    Title = "Rebirth Option",
                    Description = "determines which rebirth option will be bought",
                    Values = ah,
                    Displayer = function(ai)
                        return ai.Name
                    end,
                    Multi = false,
                })

                local aj = i.promisify(function(aj)
                    ai:SetValues(aj)
                end)

                Y:Add(U:OnSet({ 'upgrades' }, function()
                    setthreadcontext(8)
                    setthreadidentity(8)
                    aj(ag()):catch(warn):await()
                end), 'Disconnect')

                local ak = ad.Farming_Rebirth:Toggle("AutoRebirthToggle", {
                    Title = "Auto Rebirth",
                    Default = false,
                    Description = "automatically rebirths for you based on the preference above"
                })

                ak:OnChanged(function(al)
                    if not al then
                        o.TerminateByIndex'AutoRebirthToggle'
                        return
                    end

                    o.new('AutoRebirthToggle', function(am)
                        while Z.Loaded and task.wait(1.6666666666666665E-2) do
                            local an = ai.Value

                            if not an then
                                continue
                            end

                            local ao = (an.Value == math.huge and q.GetBestRebirthOption()) or an.Value

                            if q.CanAffordRebirth(ao) then
                                I:rebirth(ao)
                            end
                        end
                    end):Start()
                end)

                local al = {}

                for am, an in m.Eggs do
                    table.insert(al, { Name = string.format('%s Egg | Price: %s', tostring(am), tostring(V.suffixes(an.cost))), Value = am, Cost = an.cost or 0 })
                end

                table.sort(al, function(am, an)
                    return am.Cost > an.Cost
                end)

                local am = ad.Farming_Hatching:Dropdown("EggDropdown", {
                    Title = "Selected Egg",
                    Description = "determines which egg will be hatched",
                    Values = al,
                    Searchable = true,
                    AutoDeselect = true,
                    Displayer = function(am)
                        return am.Name
                    end,
                    Multi = false,
                })

                r.AssertFunctions({ 'hookfunction' }, function()
                    local an = ad.Farming_Hatching:Toggle("HideHatchAnimation", {
                        Title = "Hide Hatch Animation",
                        Default = false,
                        Description = "prevents the eggs from showing up on screen"
                    })

                    local ao
                    ao = hookfunction(R.eggAnimation, function(ap, ...)
                        if an.Value then
                            return nil
                        end
                        return ao(ap, ...)
                    end)

                    Y:Add(function()
                        hookfunction(R.eggAnimation, ao)
                    end)
                end, function(an)
                    ad.Farming_Hatching:CreateParagraph("MissingFunctionAssertion", {
                        Title = "Unsupported Feature: Hide Hatch Animation",
                        TitleAlignment = Enum.TextXAlignment.Center,
                        Content = string.format([[This feature cannot be used because your executor doesn't support following functions: %s]], tostring(table.concat(an, ', '))),
                        ContentAlignment = Enum.TextXAlignment.Center
                    })
                end)

                local an = ad.Farming_Hatching:Toggle("AutoOpenEggs", {
                    Title = "Auto Open Eggs",
                    Default = false,
                    Description = "automatically opens eggs based on the configuration above"
                })

                an:OnChanged(function(ao)
                    if not ao then
                        o.TerminateByIndex'AutoOpenEggs'
                        return
                    end

                    o.new('AutoOpenEggs', function(ap)
                        while Z.Loaded and task.wait(1.6666666666666665E-2) do
                            local aq = am.Value

                            if not aq then
                                continue
                            end

                            local ar = m.Eggs[aq.Value].requiredMap

                            if ar and (not T.data.maps[ar]) then
                                continue
                            end

                            local as = m.Util.eggUtils.getMaxAffordable(B, T.data, aq.Value)

                            if m.Util.eggUtils.hasEnoughToOpen(T.data, aq.Value, as) then
                                J.openEgg:Fire(aq.Value, as)
                                task.wait(4.15 / m.Values.hatchSpeed(B, T.data))
                            end
                        end
                    end):Start()
                end)

                local ao = l.Map(m.Upgrades, function(ao, ap, aq)
                    table.insert(aq, { Name = V.toPascal(ap), Value = ap })
                end)

                local ap = ad.Farming_Upgrades:Dropdown("UpgradesDropdown", {
                    Title = "Selected Upgrades",
                    Description = "determines which upgrades will be bought",
                    Values = ao,
                    Displayer = function(ap)
                        return ap.Name
                    end,
                    Multi = true,
                    Default = {}
                })

                local aq = ad.Farming_Upgrades:Toggle("AutoUpgradeToggle", {
                    Title = "Auto Buy Upgrades",
                    Default = false,
                    Description = "automatically buys upgrades when possible"
                })

                aq:OnChanged(function(ar)
                    if not ar then
                        o.TerminateByIndex'AutoUpgradeToggle'
                        return
                    end

                    o.new('AutoUpgradeToggle', function(as)
                        while Z.Loaded and task.wait(0.5) do
                            local at = ap.Value

                            if l.GetDictionarySize(at) < 1 then
                                continue
                            end

                            for au in at do
                                local av, aw = au.Name, au.Value
                                local ax = m.Upgrades[aw]

                                if ax.requiredMap and T.data.maps[ax.requiredMap] == nil then
                                    continue
                                end

                                local ay = (T.data.upgrades[aw] or 0) + 1
                                local az = ax.upgrades[ay]

                                if not az then
                                    continue
                                end

                                if az.cost > T.data.gems then
                                    continue
                                end

                                if L:upgrade(aw) == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | bought upgrade",
                                        Content = string.format('upgrade %s is now level %s', tostring(av), tostring(ay)),
                                        Duration = 1.5
                                    }
                                end
                            end
                        end
                    end):Start()
                end)
            end

            do
                local ae = l.Map(m.Farms, function(ae, af, ag)
                    table.insert(ag, { Name = V.toPascal(af), Value = af, IsAFarm = not ae.isNotFarm })
                end)

                local af = l.Map(ae, function(af, ag, ah)
                    if not af.IsAFarm then
                        return
                    end

                    table.insert(ah, af)
                end)

                local ag = ad.Crops_Claim:Dropdown("SelectedClaimFarms", {
                    Title = "Selected Crops",
                    Description = "determines which crops will be auto collected",
                    Values = af,
                    Multi = true,
                    Displayer = function(ag)
                        return ag.Name
                    end,
                    Default = {}
                })

                local ah = ad.Crops_Claim:Toggle("AutoClaimCrops", {
                    Title = "Auto Claim Crops",
                    Default = false,
                    Description = "automatically claim available crops"
                })

                ah:OnChanged(function(ai)
                    if not ai then
                        o.TerminateByIndex'AutoClaimCrops'
                        return
                    end

                    o.new('AutoClaimCrops', function(aj)
                        while Z.Loaded and task.wait(0.5) do
                            local ak = ag.Value

                            if l.GetDictionarySize(ak) == 0 then
                                continue
                            end

                            local al = T.data.farms

                            for am in ak do
                                local an = am.Value
                                local ao = am.Name

                                if not al[an] then
                                    continue
                                end

                                if S:getTimeLeft(an) > 0 then
                                    continue
                                end

                                if K:claim(an) == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | claimed crops",
                                        Content = string.format('%s has been claimed!', tostring(ao)),
                                        Duration = 1.5
                                    }
                                end
                            end
                        end
                    end):Start()
                end)

                local ai = ad.Crops_Upgrade:Dropdown("SelectedUpgradeCrops", {
                    Title = "Selected Upgrades",
                    Description = "determines which crops will be upgraded",
                    Values = ae,
                    Multi = true,
                    Displayer = function(ai)
                        return ai.Name
                    end,
                    Default = {}
                })

                local aj = ad.Crops_Upgrade:Toggle("AutoUpgradeCrops", {
                    Title = "Auto Upgrade Crops",
                    Default = false,
                    Description = "automatically upgrades selected crops"
                })

                aj:OnChanged(function(ak)
                    if not ak then
                        o.TerminateByIndex'AutoUpgradeCrops'
                        return
                    end

                    o.new('AutoUpgradeCrops', function(al)
                        while Z.Loaded and task.wait(0.5) do
                            local am = ai.Value

                            if l.GetDictionarySize(am) == 0 then
                                continue
                            end

                            for an in am do
                                local ao = an.Value
                                local ap = an.Name
                                local aq = T.data.farms[ao]

                                if aq == nil then
                                    local ar = m.Farms[ao]
                                    local as = ar.price or math.huge

                                    if T.data.gems <= as then
                                        continue
                                    end

                                    if K:buy(ao) == "success" then
                                        Z:Notify{
                                            Title = "strelizia.cc | bought crop farm",
                                            Content = string.format('%s has been bought!', tostring(ap)),
                                            Duration = 1.5
                                        }
                                        task.wait(0.2)
                                    end
                                    continue
                                end

                                local ar = (aq.stage or 0) + 1
                                local as = m.Farms[ao].upgrades

                                if not as then
                                    continue
                                end

                                local at = as[ar]

                                if not at then
                                    continue
                                end

                                local au = at.price or math.huge

                                if T.data.gems <= au then
                                    continue
                                end

                                if K:upgrade(ao) == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | upgraded crop farm",
                                        Content = string.format('%s has been upgraded to stage %s!', tostring(ap), tostring(ar)),
                                        Duration = 1.5
                                    }
                                end
                            end
                        end
                    end):Start()
                end)
            end

            do
                local ae = ad.Other_Chests:Toggle("AutoClaimChests", {
                    Title = "Auto Claim Chests",
                    Default = false,
                    Description = "automatically claims chests"
                })

                ae:OnChanged(function(af)
                    if not af then
                        o.TerminateByIndex'AutoClaimChests'
                        return
                    end

                    o.new('AutoClaimChests', function(ag)
                        while Z.Loaded and task.wait(0.5) do
                            for ah, ai in m.Chests do
                                if ai.group and select(2, pcall(B.IsInGroup, B, game.CreatorId)) ~= true then
                                    print'Not in group'
                                    continue
                                end

                                local aj = T.data.chests[ah] or 0

                                if os.time() < aj + ai.cooldown then
                                    continue
                                end

                                if M:claimChest(ah) == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | claimed chest",
                                        Content = string.format('%s chest has been opened!', tostring(ah)),
                                        Duration = 1.5
                                    }
                                end
                            end
                        end
                    end):Start()
                end)

                ad.Other_Chests:Button{
                    Title = "Claim Minichests",
                    Description = "claims all unlocked chests (areawise)",
                    Callback = function()
                        for af, ag in A:GetTagged'MiniChest' do
                            local ah = D(ag, 'ProximityPrompt', true)

                            if not ah then
                                continue
                            end

                            fireproximityprompt(ah, 0)
                            fireproximityprompt(ah, 1)
                        end
                    end
                }

                local af = {}

                for ag, ah in m.Potions do
                    table.insert(af, { Name = ah.name, Layout = ah.layoutOrder, Value = ag })
                end

                table.sort(af, function(ag, ah)
                    return ag.Layout > ah.Layout
                end)

                local ag = ad.Other_Items:Dropdown("PotionsDropdown", {
                    Title = "Select Potions",
                    Description = "determines which potions will be used",
                    Values = af,
                    Multi = true,
                    Displayer = function(ag)
                        return ag.Name
                    end,
                    Default = {}
                })

                local ah = ad.Other_Items:Toggle("AutoUsePotions", {
                    Title = "Auto Use Potions",
                    Default = false,
                    Description = "automatically uses potions (only after current one expires)"
                })

                ah:OnChanged(function(ai)
                    if not ai then
                        o.TerminateByIndex'AutoUsePotions'
                        return
                    end

                    o.new('AutoUsePotions', function(aj)
                        while Z.Loaded and task.wait(0.5) do
                            local ak = ag.Value

                            if l.GetDictionarySize(ak) == 0 then
                                continue
                            end

                            for al in ak do
                                local am = al.Value

                                if T.data.activeBoosts[am] then
                                    continue
                                end

                                local an, ao = q.GetItemByName('potion', am)

                                if not an or not ao.am or ao.am < 1 then
                                    continue
                                end

                                Q:useItem(an, { use = 1 })
                            end
                        end
                    end):Start()
                end)

                local ai = {}

                for aj, ak in m.Boxes do
                    table.insert(ai, { Name = ak.name, Layout = ak.layoutOrder, Value = aj })
                end

                table.sort(ai, function(aj, ak)
                    return aj.Layout > ak.Layout
                end)

                local aj = ad.Other_Items:Dropdown("BoxesDropdown", {
                    Title = "Select Boxes",
                    Description = "determines which boxes will be opened",
                    Values = ai,
                    Multi = true,
                    Displayer = function(aj)
                        return aj.Name
                    end,
                    Default = {}
                })

                local ak = ad.Other_Items:Toggle("AutoOpenBoxes", {
                    Title = "Auto Open Boxes",
                    Default = false,
                    Description = "automatically opens boxes if any are present in the inventory"
                })

                ak:OnChanged(function(al)
                    if not al then
                        o.TerminateByIndex'AutoOpenBoxes'
                        return
                    end

                    o.new('AutoOpenBoxes', function(am)
                        while Z.Loaded and task.wait(0.5) do
                            local an = aj.Value

                            if l.GetDictionarySize(an) == 0 then
                                continue
                            end

                            for ao in an do
                                local ap = ao.Value
                                local aq, ar = q.GetItemByName('box', ap)

                                if not aq or not ar.am or ar.am < 1 then
                                    continue
                                end

                                Q:useItem(aq, { use = ar.am })
                            end
                        end
                    end):Start()
                end)

                local al = {}

                for am, an in m.Tiers do
                    local ao = m.Tiers[am + 1]

                    if not ao then
                        continue
                    end

                    table.insert(al, { Name = string.format('%s -> %s', tostring(an.name), tostring(ao.name)), Value = am, AttributeName = an.attributeName })
                end

                local am = ad.Other_Combining:Dropdown("UpgradeTierDropdown", {
                    Title = "Upgrade Tiers",
                    Description = "determines which tiers will be upgraded",
                    Values = al,
                    Multi = true,
                    Displayer = function(am)
                        return am.Name
                    end,
                    Default = {}
                })

                local an = ad.Other_Combining:Toggle("AutoUpgradeTiers", {
                    Title = "Auto Upgrade Pets",
                    Default = false,
                    Description = "automatically upgrades pets tier based on the configuration above"
                })

                an:OnChanged(function(ao)
                    if not ao then
                        o.TerminateByIndex'AutoUpgradeTiers'
                        return
                    end

                    o.new('AutoUpgradeTiers', function(ap)
                        while Z.Loaded and task.wait(0.5) do
                            local aq = am.Value

                            if l.GetDictionarySize(aq) == 0 then
                                continue
                            end

                            for ar in aq do
                                local as = ar.Value

                                if (not m.Tiers[as + 1]) then
                                    continue
                                end

                                local at = q.GetPetsByTier(as)

                                for au, av in at do
                                    if av:getLocked() then
                                        continue
                                    end

                                    if av:getAmount() < 5 then
                                        continue
                                    end

                                    N:craft({ au }, true)
                                end
                            end
                        end
                    end):Start()
                end)

                local ao = ad.Other_Misc:Toggle("AutoClaimRewards", {
                    Title = "Auto Claim Rewards",
                    Default = false,
                    Description = "automatically claims rewards (Playtime, Daily, Achievements)"
                })

                ao:OnChanged(function(ap)
                    if not ap then
                        o.TerminateByIndex'AutoClaimRewards'
                        return
                    end

                    o.new('AutoClaimRewards', function(aq)
                        while Z.Loaded and task.wait(1) do
                            for ar, as in m.PlaytimeRewards do
                                if table.find(T.data.claimedPlaytimeRewards, ar) then
                                    continue
                                end

                                if as.required - T.data.sessionTime > 0 then
                                    continue
                                end

                                if M:claimPlaytimeReward(ar) == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | claimed playtime reward",
                                        Content = string.format('claimed playtime reward no%s', tostring(ar)),
                                        Duration = 1.5
                                    }
                                end
                            end

                            if (T.data.dayReset - os.time() + 86400) <= 0 then
                                if M:claimDailyReward() == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | claimed daily reward",
                                        Content = "todays daily reward has been claimed",
                                        Duration = 1.5
                                    }
                                end
                            end

                            for ar, as in m.Achievements do
                                local at, au = q.GetNextAchievementByClass(ar)

                                if not at then
                                    continue
                                end

                                if au.amount > as.getValue(T.data) then
                                    continue
                                end

                                if M:claimAchievement(ar) == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | claimed achievement",
                                        Content = string.format('claimed achievement %s (tier %s)', tostring(ar), tostring(at)),
                                        Duration = 1.5
                                    }
                                end
                            end
                        end
                    end):Start()
                end)

                local ap = ad.Other_Misc:Toggle("AutoClaimIndexRewards", {
                    Title = "Auto Claim Index Rewards",
                    Default = false,
                    Description = "automatically claims index rewards"
                })

                ap:OnChanged(function(aq)
                    if not aq then
                        o.TerminateByIndex'AutoClaimIndexRewards'
                        return
                    end

                    o.new('AutoClaimIndexRewards', function(ar)
                        while Z.Loaded and task.wait(1) do
                            for as, at in m.IndexRewards do
                                if table.find(T.data.claimedIndexRewards, as) then
                                    continue
                                end

                                if at.required > m.Util.indexUtils.countIndex(T.data, true) then
                                    continue
                                end

                                if O:claimIndexReward(as) == "success" then
                                    Z:Notify{
                                        Title = "strelizia.cc | claimed index reward",
                                        Content = string.format('claimed index reawrd no%s', tostring(as)),
                                        Duration = 1.5
                                    }
                                end
                            end
                        end
                    end):Start()
                end)

                local aq = ad.Other_Misc:Toggle("AutoPrestigeToggle", {
                    Title = "Auto Prestige",
                    Default = false,
                    Description = "automatically prestiges when possible"
                })

                aq:OnChanged(function(ar)
                    if not ar then
                        o.TerminateByIndex'AutoPrestigeToggle'
                        return
                    end

                    o.new('AutoPrestigeToggle', function(as)
                        while Z.Loaded and task.wait(1) do
                            local at = (T.data.prestige or 0) + 1
                            local au = m.Prestiges[at]

                            if not au then
                                continue
                            end

                            if au.required > T.data.prestigeXp then
                                continue
                            end

                            if P:claim() == "success" then
                                Z:Notify{
                                    Title = "strelizia.cc | prestiged",
                                    Content = string.format('successfully prestiged to prestige %s', tostring(at)),
                                    Duration = 1.5
                                }
                            end
                        end
                    end):Start()
                end)
            end

            do
                _:SetLibrary(Z)
                aa:SetLibrary(Z)
                _:IgnoreThemeSettings()
                _:SetIgnoreIndexes{}
                aa:SetFolder"StreliziaScriptHub"
                _:SetFolder("StreliziaScriptHub/" .. game.PlaceId)
                aa:BuildInterfaceSection(ac.Settings)
                _:BuildConfigSection(ac.Settings)
                ab:SelectTab(1)

                Z:Notify{
                    Title = "strelizia.cc",
                    Content = "script loaded, enjoy <3",
                    Duration = 5
                }

                Z:ToggleTransparency(false)
                _:LoadAutoloadConfig()

                Z.OnUnload:Connect(function()
                    o.TerminateAll()

                    local ae = C(z, 'UIToggle')

                    if ae then
                        ae:Destroy()
                    end
                end)

                do
                    o.new('DiscordJoinPrompt', function(ae)
                        local af = 120

                        while true do
                            local ag, ah = pcall(isfile, 'StreliziaJoinedDiscord')

                            if ag and ah == true then
                                break
                            end

                            task.wait(af)
                            af = af * 3

                            local ai = ab:Dialog{
                                Title = "Discord",
                                Content = "Hey! Want to join our Discord for tons of giveaways, stay updated on script status, and hang out with the community?",
                                Buttons = {
                                    {
                                        Title = "Sure",
                                        Callback = function()
                                            r.PromptDiscordJoin('Vf4Wu3Cft7', true)
                                            pcall(writefile, 'StreliziaJoinedDiscord', 'true')
                                        end
                                    },
                                    {
                                        Title = "No",
                                        Callback = function() end
                                    }
                                }
                            }

                            ai.Closed:Wait()
                        end

                        o.TerminateByIdentifier(ae.Identifier)
                    end):Start()
                end

                r.AntiAFK(true)
            end
        end,
        Properties = {
            Name = "Init"
        },
        Reference = 1,
        Children = {
            {
                ClassName = "ModuleScript",
                Closure = function()
                    return function(a)
                        local aa = {
                            Cache = setmetatable({}, {
                                __index = function(a, aa)
                                    rawset(a, aa, {})
                                    return rawget(a, aa)
                                end,
                            })
                        }

                        function a.SetupLazyLoader(aa, ab)
                            local ac = {}

                            for ad, ae in aa:GetChildren() do
                                ac[ae.Name] = ae
                            end

                            setmetatable(ab, {
                                __index = function(ad, ae)
                                    local af = ac[ae]
                                    assert(af, string.format('[Library]: Cannot find module %s in %s', ae, script.Name))
                                    local ag, ah = pcall(require, af)
                                    assert(ag, string.format('[Library]: Failed to Initalize Module %s in %s: %s', ae, script.Name, tostring(ah)))
                                    assert(typeof(ah) == 'function', string.format('[Library]: Module %s is NOT a Function', ae))
                                    local ai, aj = pcall(ah, a)
                                    assert(ai, string.format('[Library]: Failed to Load Module %s in %s: %s', ae, script.Name, tostring(aj)))
                                    rawset(ad, ae, aj)
                                    return aj
                                end,
                            })
                        end

                        a.SetupLazyLoader(script, a)
                        return a
                    end
                end,
                Properties = {
                    Name = "Library"
                },
                Reference = 2,
                Children = {
                    {
                        ClassName = "ModuleScript",
                        Closure = function()
                            return function(a)
                                local aa = {}
                                a.SetupLazyLoader(script, aa)
                                return aa
                            end
                        end,
                        Properties = {
                            Name = "Functions"
                        },
                        Reference = 3,
                        Children = {
                            {
                                ClassName = "ModuleScript",
                                Closure = function()
                                    return function(a)
                                        local aa = {}
                                        a.SetupLazyLoader(script, aa)
                                        return aa
                                    end
                                end,
                                Properties = {
                                    Name = "Generic"
                                },
                                Reference = 4,
                                Children = {
                                    {
                                        Closure = function()
                                            return function(a)
                                                local aa = a.Services
                                                local ab = aa.Stats
                                                local ac = ab.Network.ServerStatsItem["Data Ping"]
                                                local ad = ac.GetValue
                                                return function()
                                                    local ae, af = pcall(ad, ac)
                                                    return af or 0
                                                end
                                            end
                                        end,
                                        Properties = {
                                            Name = "GetPing"
                                        },
                                        Reference = 26,
                                        ClassName = "ModuleScript"
                                    },
                                    {
                                        Closure = function()
                                            return function(a)
                                                local aa = {}

                                                return function(ab)
                                                    local ac = tostring(ab)
                                                    if aa[ac] then
                                                        return aa[ac]
                                                    end

                                                    local ad = ac:reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
                                                    aa[ac] = ad
                                                    return ad
                                                end
                                            end
                                        end,
                                        Properties = {
                                            Name = "CommaNumber"
                                        },
                                        Reference = 23,
                                        ClassName = "ModuleScript"
                                    },
                                    {
                                        Closure = function()
                                            return function(a)
                                                local aa = a.Services
                                                local ab = aa.Players
                                                local ac = aa.Workspace
                                                local ad = ab.LocalPlayer

                                                return function(ae, af)
                                                    local ai = ad.Character

                                                    if not ai then
                                                        return false
                                                    end

                                                    af = af or {}

                                                    local aj = af.From or workspace.CurrentCamera.CFrame.Position
                                                    local ak = (ae.Position - aj).Unit
                                                    local al = RaycastParams.new()
                                                    al:AddToFilter(ad.Character)
                                                    al.FilterType = Enum.RaycastFilterType.Exclude

                                                    for am, an in af.Ignore or {} do
                                                        al:AddToFilter(an)
                                                    end

                                                    local am = ac:Raycast(aj, ak * 1000, al)

                                                    if am then
                                                        local an = am.Instance

                                                        if an and ((am.Instance == ae) or (af.ParentMatching and am.Instance.Parent == ae.Parent)) then
                                                            return true
                                                        end
                                                    end

                                                    return false
                                                end
                                            end
                                        end,
                                        Properties = {
                                            Name = "IsPartVisible"
                                        },
                                        Reference = 27,
                                        ClassName = "ModuleScript"
                                    },
                                    {
                                        Closure = function()
                                            return function(a)
                                                local aa = {}

                                                return function(ab)
                                                    local ac = aa[tostring(ab)]

                                                    if ac then
                                                        return ac
                                                    end

                                                    local ad = (ab - ab % 60) / 60
                                                    ab = ab - ad * 60
                                                    local ae = (ad - ad % 60) / 60
                                                    ad = ad - ae * 60
                                                    local af = string.format("%02i", ae) .. ":" .. string.format("%02i", ad) .. ":" .. string.format("%02i", ab)
                                                    aa[tostring(ab)] = af
                                                    return af
                                                end
                                            end
                                        end,
                                        Properties = {
                                            Name = "FormatHms"
                                        },
                                        Reference = 18,
                                        ClassName = "ModuleScript"
                                    },
                                    {
                                        Closure = function()
                                            return function(a)
                                                local aa = a.Functions.Generic.HttpRequest
                                                local ab = a.Services
                                                local ac = ab.HttpService

                                                return function(ad, ae)
                                                    if ae then
                                                        setclipboard("https://www.discord.gg/" .. ad)
                                                    end

                                                    if not aa then
                                                        return false
                                                    end

                                                    aa{
                                                        Url = "http://127.0.0.1:6463/rpc?v=1",
                                                        Method = "POST",
                                                        Headers = {
                                                            ["Content-Type"] = "application/json",
                                                            Origin = "https://discord.com"
                                                        },
                                                        Body = ac:JSONEncode{
                                                            cmd = "INVITE_BROWSER",
                                                            args = { code = ad },
                                                            nonce = ac:GenerateGUID(false)
                                                        }
                                                    }

                                                    return true
                                                end
                                            end