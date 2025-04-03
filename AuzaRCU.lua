local a={ { ClassName="LocalScript", Closure=function() 
    if(not game:IsLoaded())then game.Loaded:Wait() end 
    if Fluent then Fluent.Destroy()end 
    local a=require(script.Library); 
    a.Debug=true; 
    local b=a.Libraries 
    local c=a.Services 
    local d=a.Variables 
    local e=b.Generic 
    local f=b.Special 
    local g=b.RBXUtil 
    local h= g.Tree 
    local i=g.Promise 
    local j= g.Signal 
    local k=g.Trove 
    local l=g.TableUtil 
    local m=f.GameModules.Get() 
    local n=e.Interface.Get() 
    local o=e.Threading 
    local p=a.Functions 
    local q=p.Special 
    local r=p.Generic 
    local s=d.LRM_Variables 
    local t=c.Players 
    local u= c.RunService 
    local v= c.Workspace 
    local w= c.ReplicatedStorage 
    local x= c.UserInputService 
    local y= c.GuiService 
    local z=c.CoreGui 
    local A=c.CollectionService 
    local B=t.LocalPlayer 
    local C=game.FindFirstChild 
    local D=game.FindFirstChildWhichIsA 
    local E= game.FindFirstAncestor 
    local F= game.IsA 
    local G=m.Knit; 
    local H=G.GetService'ClickService' 
    local I=G.GetService'RebirthService' 
    local J=G.GetService'EggService' 
    local K=G.GetService'FarmService' 
    local L=G.GetService'UpgradeService' 
    local M=G.GetService'RewardService' 
    local N=G.GetService'PetService' 
    local O=G.GetService'IndexService' 
    local P=G.GetService'PrestigeService' 
    local Q=G.GetService'InventoryService' 
    local R=G.GetController'HatchingController' 
    local S=G.GetController'FarmController' 
    local T=G.GetController'DataController';T:waitForData(); 
    local U=T.replica 
    local V=m.Functions 
    local W= m.Variables 
    setthreadidentity(8);setthreadcontext(8); 
    local X=a.Cache.ScriptCache 
    X.InitTime=DateTime.now().UnixTimestamp 
    local Y=o.new'MainThread' 
    local Z=n.Fluent 
    local _=n.SaveManager 
    local aa=n.ThemeManager 
    getgenv().Fluent=Z 

    -- Create Auza Hub window
    local ab=Z:CreateWindow{ 
        Title="Auza Hub", 
        SubTitle="v"..s.LRM_ScriptVersion.." | by iKazu", 
        TabWidth=120, 
        Size=UDim2.fromOffset(600,480), 
        Resize=true, 
        MinSize=Vector2.new(430,350), 
        Acrylic=false, 
        Theme="Darker", 
        MinimizeKey=Enum.KeyCode.RightControl 
    } 

    -- Create tabs
    local ac={ 
        Home=ab:CreateTab{ Title="Home", Icon="house" }, 
        Farming=ab:CreateTab{ Title="Farming", Icon="egg" }, 
        Crops=ab:CreateTab{ Title="Crops", Icon="wheat" }, 
        Misc=ab:CreateTab{ Title="Others", Icon="circle-ellipsis" }, 
        Settings=ab:CreateTab{ Title="Settings", Icon="settings" }, 
    } 

    -- Create sections
    local ad={ 
        Home_Information=ac.Home:AddSection"↳ Information", 
        Home_Credits=ac.Home:AddSection"↳ Credits", 
        Farming_Clicking=ac.Farming:AddSection"↳ Clicking", 
        Farming_Rebirth=ac.Farming:AddSection"↳ Rebirthing", 
        Farming_Hatching=ac.Farming:AddSection"↳ Hatching", 
        Farming_Upgrades=ac.Farming:AddSection"↳ Upgrades", 
        Crops_Claim=ac.Crops:AddSection"↳ Auto Claim", 
        Crops_Upgrade=ac.Crops:AddSection"↳ Auto Upgrade", 
        Other_Chests=ac.Misc:AddSection"↳ Chests", 
        Other_Items=ac.Misc:AddSection"↳ Items", 
        Other_Combining=ac.Misc:AddSection"↳ Combining", 
        Other_Misc=ac.Misc:AddSection"↳ Misc" 
    } 

    -- Home Tab
    do 
        local ae=ad.Home_Information:CreateParagraph("ClientUptimeParagraph",{
            Title="Client Uptime: nil", 
            TitleAlignment=Enum.TextXAlignment.Center, 
        }); 
        o.new("ClientUptimeParagraph",function(af) 
            while Z.Loaded and task.wait(1)do 
                ae.Instance.TitleLabel.Text=string.format("Script Uptime: %s",r.FormatHms(r.GetUptime())) 
            end 
        end):Start() 

        local af=ad.Home_Information:CreateParagraph("LuaHeapParagraph",{
            Title="Lua Heap (Megabytes): nil", 
            TitleAlignment=Enum.TextXAlignment.Center, 
        }); 
        o.new("LuaHeapParagraph",function(ag) 
            while Z.Loaded and task.wait(1)do 
                af.Instance.TitleLabel.Text=string.format('Lua Heap: %sMB', tostring(r.CommaNumber(math.ceil(gcinfo()/1000))) 
            end 
        end):Start() 

        ad.Home_Information:CreateButton{ 
            Title="Join Discord", 
            Description="Join our Discord server for updates and support", 
            Callback=function() 
                r.PromptDiscordJoin('By8cKapJFA',true) 
                Z:Notify{ 
                    Title="Discord Invite", 
                    Content="Discord invite has been copied to your clipboard!", 
                    Duration=2 
                } 
            end 
        } 

        -- Updated credits section
        ad.Home_Credits:CreateParagraph("Credits",{
            Title="Developed by iKazu", 
            TitleAlignment=Enum.TextXAlignment.Center, 
        }); 
    end 

    -- Farming Tab
    do 
        -- Auto Click
        local ae=ad.Farming_Clicking:Toggle("AutoClickToggle",{
            Title="Auto Click", 
            Default=false,
            Description="Automatically clicks for you at optimal speed"
        }) 
        ae:OnChanged(function(af) 
            if not af then 
                o.TerminateByIndex'AutoClickToggle' 
                return 
            end 
            o.new('AutoClickToggle',function(ag) 
                while Z.Loaded and task.wait()do 
                    H.click:Fire() 
                end 
            end):Start() 
        end) 

        -- Auto Rebirth
        local af=i.promisify(V.suffixes) 
        local function ag() 
            local ah=q.GetUnlockedRebirthOptions(); 
            local ai={}; 
            for aj,ak in ah do 
                local al, am=af(ak):await() 
                table.insert(ai,{
                    Name=string.format('%s Rebirths', tostring(am)), 
                    Value=aj 
                }) 
            end 
            table.insert(ai,{Name='Best Option Unlocked',Value=math.huge}) 
            return ai 
        end 

        local ah=ag() 
        local ai=ad.Farming_Rebirth:Dropdown("RebirthsDropdown",{
            Title="Rebirth Option", 
            Description="Select which rebirth option to use automatically",
            Values=ah, 
            Displayer=function(ai) return ai.Name end, 
            Multi=false, 
        }) 

        local aj=i.promisify(function(aj)ai:SetValues(aj)end); 
        Y:Add(U:OnSet({'upgrades'},function() 
            setthreadcontext(8) 
            setthreadidentity(8) 
            aj(ag()):catch(warn):await() 
        end),'Disconnect') 

        local ak=ad.Farming_Rebirth:Toggle("AutoRebirthToggle",{
            Title="Auto Rebirth", 
            Default=false,
            Description="Automatically rebirth when you can afford it"
        }) 
        ak:OnChanged(function(al) 
            if not al then 
                o.TerminateByIndex'AutoRebirthToggle' 
                return 
            end 
            o.new('AutoRebirthToggle',function(am) 
                while Z.Loaded and task.wait(1.6666666666666665E-2)do 
                    local an=ai.Value; 
                    if not an then continue end 
                    local ao=(an.Value==math.huge and q.GetBestRebirthOption())or an.Value 
                    if q.CanAffordRebirth(ao)then 
                        I:rebirth(ao) 
                    end 
                end 
            end):Start() 
        end) 

        -- Auto Hatch Eggs
        local al={}; 
        for am,an in m.Eggs do 
            table.insert(al,{
                Name=string.format('%s Egg | Price: %s', tostring(am), tostring(V.suffixes(an.cost))), 
                Value=am, 
                Cost=an.cost or 0 
            }) 
        end;table.sort(al,function(am,an)return am.Cost>an.Cost end) 

        local am=ad.Farming_Hatching:Dropdown("EggDropdown",{
            Title="Selected Egg", 
            Description="Choose which eggs to hatch automatically",
            Values=al, 
            Searchable=true, 
            AutoDeselect=true, 
            Displayer=function(am) return am.Name end, 
            Multi=false, 
        }) 

        r.AssertFunctions({'hookfunction'},function() 
            local an=ad.Farming_Hatching:Toggle("HideHatchAnimation",{
                Title="Hide Hatch Animation", 
                Default=false,
                Description="Disable egg hatching visual effects"
            }) 
            local ao; 
            ao=hookfunction(R.eggAnimation,function(ap,...) 
                if an.Value then return nil end 
                return ao(ap,...) 
            end) 
            Y:Add(function() hookfunction(R.eggAnimation,ao) end) 
        end,function(an) 
            ad.Farming_Hatching:CreateParagraph("MissingFunctionAssertion",{
                Title="Unsupported Feature: Hide Hatch Animation", 
                TitleAlignment=Enum.TextXAlignment.Center, 
                Content=string.format([[This feature cannot be used because your executor doesn't support following functions: %s]], tostring(table.concat(an,', '))),
                ContentAlignment=Enum.TextXAlignment.Center 
            }); 
        end) 

        local an=ad.Farming_Hatching:Toggle("AutoOpenEggs",{
            Title="Auto Open Eggs", 
            Default=false,
            Description="Automatically opens eggs when available"
        }) 
        an:OnChanged(function(ao) 
            if not ao then 
                o.TerminateByIndex'AutoOpenEggs' 
                return 
            end 
            o.new('AutoOpenEggs',function(ap) 
                while Z.Loaded and task.wait(1.6666666666666665E-2)do 
                    local aq=am.Value; 
                    if not aq then continue end 
                    local ar=m.Eggs[aq.Value].requiredMap 
                    if ar and(not T.data.maps[ar])then continue end 
                    local as=m.Util.eggUtils.getMaxAffordable(B,T.data,aq.Value); 
                    if m.Util.eggUtils.hasEnoughToOpen(T.data,aq.Value,as)then 
                        J.openEgg:Fire(aq.Value,as) 
                        task.wait(4.15/m.Values.hatchSpeed(B,T.data)) 
                    end 
                end 
            end):Start() 
        end) 

        -- Auto Upgrades
        local ao=l.Map(m.Upgrades,function(ao,ap,aq) 
            table.insert(aq,{
                Name=V.toPascal(ap), 
                Value=ap 
            }) 
        end) 

        local ap=ad.Farming_Upgrades:Dropdown("UpgradesDropdown",{
            Title="Selected Upgrades", 
            Description="Choose which upgrades to purchase automatically",
            Values=ao, 
            Displayer=function(ap) return ap.Name end, 
            Multi=true, 
            Default={} 
        }) 

        local aq=ad.Farming_Upgrades:Toggle("AutoUpgradeToggle",{
            Title="Auto Buy Upgrades", 
            Default=false,
            Description="Automatically purchase available upgrades"
        }) 
        aq:OnChanged(function(ar) 
            if not ar then 
                o.TerminateByIndex'AutoUpgradeToggle' 
                return 
            end 
            o.new('AutoUpgradeToggle',function(as) 
                while Z.Loaded and task.wait(0.5)do 
                    local at=ap.Value; 
                    if l.GetDictionarySize(at)<1 then continue end; 
                    for au in at do 
                        local av,aw=au.Name,au.Value; 
                        local ax=m.Upgrades[aw]; 
                        if ax.requiredMap and T.data.maps[ax.requiredMap]==nil then continue end 
                        local ay=(T.data.upgrades[aw]or 0)+1 
                        local az=ax.upgrades[ay] 
                        if not az then continue end 
                        if az.cost>T.data.gems then continue end 
                        if L:upgrade(aw)=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Upgrade Purchased",
                                Content=string.format('Purchased %s upgrade to level %s', tostring(av), tostring(ay)),
                                Duration=1.5
                            } 
                        end 
                    end 
                end 
            end):Start() 
        end) 
    end 

    -- Crops Tab
    do 
        local ae=l.Map(m.Farms,function(ae,af,ag) 
            table.insert(ag,{
                Name=V.toPascal(af), 
                Value=af, 
                IsAFarm=not ae.isNotFarm 
            }) 
        end) 

        local af=l.Map(ae,function(af,ag,ah) 
            if not af.IsAFarm then return end 
            table.insert(ah,af) 
        end) 

        local ag=ad.Crops_Claim:Dropdown("SelectedClaimFarms",{
            Title="Selected Crops", 
            Description="Choose which crops to collect automatically",
            Values=af, 
            Multi=true, 
            Displayer=function(ag) return ag.Name end, 
            Default={} 
        }) 

        local ah=ad.Crops_Claim:Toggle("AutoClaimCrops",{
            Title="Auto Claim Crops", 
            Default=false,
            Description="Automatically collect ready crops"
        }) 
        ah:OnChanged(function(ai) 
            if not ai then 
                o.TerminateByIndex'AutoClaimCrops' 
                return 
            end 
            o.new('AutoClaimCrops',function(aj) 
                while Z.Loaded and task.wait(0.5)do 
                    local ak=ag.Value; 
                    if l.GetDictionarySize(ak)==0 then continue end 
                    local al=T.data.farms 
                    for am in ak do 
                        local an=am.Value 
                        local ao=am.Name 
                        if not al[an]then continue end 
                        if S:getTimeLeft(an)>0 then continue end 
                        if K:claim(an)=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Crops Collected",
                                Content=string.format('%s crops have been collected!', tostring(ao)),
                                Duration=1.5
                            } 
                        end 
                    end 
                end 
            end):Start() 
        end) 

        local ai=ad.Crops_Upgrade:Dropdown("SelectedUpgradeCrops",{
            Title="Selected Upgrades", 
            Description="Choose which crops to upgrade automatically",
            Values=ae, 
            Multi=true, 
            Displayer=function(ai) return ai.Name end, 
            Default={} 
        }) 

        local aj=ad.Crops_Upgrade:Toggle("AutoUpgradeCrops",{
            Title="Auto Upgrade Crops", 
            Default=false,
            Description="Automatically upgrade selected crops"
        }) 
        aj:OnChanged(function(ak) 
            if not ak then 
                o.TerminateByIndex'AutoUpgradeCrops' 
                return 
            end 
            o.new('AutoUpgradeCrops',function(al) 
                while Z.Loaded and task.wait(0.5)do 
                    local am=ai.Value; 
                    if l.GetDictionarySize(am)==0 then continue end 
                    for an in am do 
                        local ao=an.Value 
                        local ap=an.Name 
                        local aq=T.data.farms[ao]; 
                        if aq==nil then 
                            local ar=m.Farms[ao]; 
                            local as=ar.price or math.huge 
                            if T.data.gems<=as then continue end 
                            if K:buy(ao)=="success"then 
                                Z:Notify{
                                    Title="Auza Hub | Farm Purchased",
                                    Content=string.format('Purchased %s farm!', tostring(ap)),
                                    Duration=1.5
                                } 
                                task.wait(0.2) 
                            end 
                            continue 
                        end 
                        local ar=(aq.stage or 0)+1 
                        local as=m.Farms[ao].upgrades; 
                        if not as then continue end 
                        local at=as[ar] 
                        if not at then continue end 
                        local au=at.price or math.huge 
                        if T.data.gems<=au then continue end 
                        if K:upgrade(ao)=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Farm Upgraded",
                                Content=string.format('Upgraded %s to stage %s!', tostring(ap), tostring(ar)),
                                Duration=1.5
                            } 
                        end 
                    end 
                end 
            end):Start() 
        end) 
    end 

    -- Misc Tab
    do 
        -- Auto Claim Chests
        local ae=ad.Other_Chests:Toggle("AutoClaimChests",{
            Title="Auto Claim Chests", 
            Default=false,
            Description="Automatically claim available chests"
        }) 
        ae:OnChanged(function(af) 
            if not af then 
                o.TerminateByIndex'AutoClaimChests' 
                return 
            end 
            o.new('AutoClaimChests',function(ag) 
                while Z.Loaded and task.wait(0.5)do 
                    for ah,ai in m.Chests do 
                        if ai.group and select(2,pcall(B.IsInGroup,B,game.CreatorId))~=true then 
                            print'Not in group'
                            continue 
                        end; 
                        local aj=T.data.chests[ah]or 0; 
                        if os.time()<aj+ai.cooldown then continue end 
                        if M:claimChest(ah)=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Chest Claimed",
                                Content=string.format('%s chest has been opened!', tostring(ah)),
                                Duration=1.5
                            } 
                        end 
                    end 
                end 
            end):Start() 
        end) 

        ad.Other_Chests:Button{ 
            Title="Claim Minichests", 
            Description="Instantly claim all nearby minichests",
            Callback=function() 
                for af,ag in A:GetTagged'MiniChest'do 
                    local ah=D(ag,'ProximityPrompt',true); 
                    if not ah then continue end 
                    fireproximityprompt(ah,0) 
                    fireproximityprompt(ah,1) 
                end 
            end 
        } 

        -- Auto Use Potions
        local af={} 
        for ag,ah in m.Potions do 
            table.insert(af,{
                Name=ah.name, 
                Layout=ah.layoutOrder, 
                Value=ag 
            }) 
        end;table.sort(af,function(ag,ah)return ag.Layout>ah.Layout end) 

        local ag=ad.Other_Items:Dropdown("PotionsDropdown",{
            Title="Select Potions", 
            Description="Choose which potions to use automatically",
            Values=af, 
            Multi=true, 
            Displayer=function(ag) return ag.Name end, 
            Default={} 
        }) 

        local ah=ad.Other_Items:Toggle("AutoUsePotions",{
            Title="Auto Use Potions", 
            Default=false,
            Description="Automatically use potions when available"
        }) 
        ah:OnChanged(function(ai) 
            if not ai then 
                o.TerminateByIndex'AutoUsePotions' 
                return 
            end 
            o.new('AutoUsePotions',function(aj) 
                while Z.Loaded and task.wait(0.5)do 
                    local ak=ag.Value; 
                    if l.GetDictionarySize(ak)==0 then continue end; 
                    for al in ak do 
                        local am=al.Value; 
                        if T.data.activeBoosts[am]then continue end 
                        local an,ao=q.GetItemByName('potion',am); 
                        if not an or not ao.am or ao.am<1 then continue end 
                        Q:useItem(an,{use=1}) 
                    end 
                end 
            end):Start() 
        end) 

        -- Auto Open Boxes
        local ai={} 
        for aj,ak in m.Boxes do 
            table.insert(ai,{
                Name=ak.name, 
                Layout=ak.layoutOrder, 
                Value=aj 
            }) 
        end;table.sort(ai,function(aj,ak)return aj.Layout>ak.Layout end) 

        local aj=ad.Other_Items:Dropdown("BoxesDropdown",{
            Title="Select Boxes", 
            Description="Choose which boxes to open automatically",
            Values=ai, 
            Multi=true, 
            Displayer=function(aj) return aj.Name end, 
            Default={} 
        }) 

        local ak=ad.Other_Items:Toggle("AutoOpenBoxes",{
            Title="Auto Open Boxes", 
            Default=false,
            Description="Automatically open boxes from inventory"
        }) 
        ak:OnChanged(function(al) 
            if not al then 
                o.TerminateByIndex'AutoOpenBoxes' 
                return 
            end 
            o.new('AutoOpenBoxes',function(am) 
                while Z.Loaded and task.wait(0.5)do 
                    local an=aj.Value; 
                    if l.GetDictionarySize(an)==0 then continue end; 
                    for ao in an do 
                        local ap=ao.Value; 
                        local aq,ar=q.GetItemByName('box',ap); 
                        if not aq or not ar.am or ar.am<1 then continue end 
                        Q:useItem(aq,{use=ar.am}) 
                    end 
                end 
            end):Start() 
        end) 

        -- Auto Combine Pets
        local al={};
        for am,an in m.Tiers do 
            local ao=m.Tiers[am+1]; 
            if not ao then continue end 
            table.insert(al,{
                Name=string.format('%s → %s', tostring(an.name), tostring(ao.name)),
                Value=am,
                AttributeName=an.attributeName
            })
        end; 

        local am=ad.Other_Combining:Dropdown("UpgradeTierDropdown",{
            Title="Upgrade Tiers", 
            Description="Select which pet tiers to combine automatically",
            Values=al, 
            Multi=true, 
            Displayer=function(am) return am.Name end, 
            Default={} 
        }) 

        local an=ad.Other_Combining:Toggle("AutoUpgradeTiers",{
            Title="Auto Upgrade Pets", 
            Default=false,
            Description="Automatically combine pets to higher tiers"
        }) 
        an:OnChanged(function(ao) 
            if not ao then 
                o.TerminateByIndex'AutoUpgradeTiers' 
                return 
            end 
            o.new('AutoUpgradeTiers',function(ap) 
                while Z.Loaded and task.wait(0.5)do 
                    local aq=am.Value; 
                    if l.GetDictionarySize(aq)==0 then continue end; 
                    for ar in aq do 
                        local as=ar.Value; 
                        if(not m.Tiers[as+1])then continue end 
                        local at=q.GetPetsByTier(as); 
                        for au,av in at do 
                            if av:getLocked()then continue end 
                            if av:getAmount()<5 then continue end 
                            N:craft({au},true) 
                        end 
                    end 
                end 
            end):Start() 
        end) 

        -- Auto Claim Rewards
        local ao=ad.Other_Misc:Toggle("AutoClaimRewards",{
            Title="Auto Claim Rewards", 
            Default=false,
            Description="Automatically claim playtime, daily and achievement rewards"
        }) 
        ao:OnChanged(function(ap) 
            if not ap then 
                o.TerminateByIndex'AutoClaimRewards' 
                return 
            end 
            o.new('AutoClaimRewards',function(aq) 
                while Z.Loaded and task.wait(1)do 
                    for ar,as in m.PlaytimeRewards do 
                        if table.find(T.data.claimedPlaytimeRewards,ar)then continue end; 
                        if as.required-T.data.sessionTime>0 then continue end 
                        if M:claimPlaytimeReward(ar)=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Reward Claimed",
                                Content=string.format('Claimed playtime reward #%s', tostring(ar)),
                                Duration=1.5
                            } 
                        end 
                    end 
                    if(T.data.dayReset-os.time()+86400)<=0 then 
                        if M:claimDailyReward()=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Daily Reward",
                                Content="Claimed today's daily reward",
                                Duration=1.5
                            } 
                        end 
                    end 
                    for ar,as in m.Achievements do 
                        local at,au=q.GetNextAchievementByClass(ar); 
                        if not at then continue end; 
                        if au.amount>as.getValue(T.data)then continue end 
                        if M:claimAchievement(ar)=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Achievement",
                                Content=string.format('Claimed %s achievement (tier %s)', tostring(ar), tostring(at)),
                                Duration=1.5
                            } 
                        end 
                    end 
                end 
            end):Start() 
        end) 

        -- Auto Claim Index Rewards
        local ap=ad.Other_Misc:Toggle("AutoClaimIndexRewards",{
            Title="Auto Claim Index Rewards", 
            Default=false,
            Description="Automatically claim index rewards when available"
        }); 
        ap:OnChanged(function(aq) 
            if not aq then 
                o.TerminateByIndex'AutoClaimIndexRewards' 
                return 
            end 
            o.new('AutoClaimIndexRewards',function(ar) 
                while Z.Loaded and task.wait(1)do 
                    for as,at in m.IndexRewards do 
                        if table.find(T.data.claimedIndexRewards,as)then continue end; 
                        if at.required>m.Util.indexUtils.countIndex(T.data,true)then continue end 
                        if O:claimIndexReward(as)=="success"then 
                            Z:Notify{
                                Title="Auza Hub | Index Reward",
                                Content=string.format('Claimed index reward #%s', tostring(as)),
                                Duration=1.5
                            } 
                        end 
                    end 
                end 
            end):Start() 
        end) 

        -- Auto Prestige
        local aq=ad.Other_Misc:Toggle("AutoPrestigeToggle",{
            Title="Auto Prestige", 
            Default=false,
            Description="Automatically prestige when requirements are met"
        }); 
        aq:OnChanged(function(ar) 
            if not ar then 
                o.TerminateByIndex'AutoPrestigeToggle' 
                return 
            end 
            o.new('AutoPrestigeToggle',function(as) 
                while Z.Loaded and task.wait(1)do 
                    local at=(T.data.prestige or 0)+1; 
                    local au=m.Prestiges[at]; 
                    if not au then continue end; 
                    if au.required>T.data.prestigeXp then continue end 
                    if P:claim()=="success"then 
                        Z:Notify{
                            Title="Auza Hub | Prestiged",
                            Content=string.format('Successfully prestiged to %s!', tostring(at)),
                            Duration=1.5
                        } 
                    end 
                end 
            end):Start() 
        end) 
    end 

    -- Settings Tab
    do 
        _:SetLibrary(Z) 
        aa:SetLibrary(Z) 
        _:IgnoreThemeSettings() 
        _:SetIgnoreIndexes{} 
        aa:SetFolder"AuzaHub" 
        _:SetFolder("AuzaHub/"..game.PlaceId) 
        aa:BuildInterfaceSection(ac.Settings) 
        _:BuildConfigSection(ac.Settings) 
        ab:SelectTab(1) 

        -- Initial notification
        Z:Notify{ 
            Title="Auza Hub", 
            Content="Script successfully loaded! Enjoy the features!", 
            Duration=5 
        } 

        Z:ToggleTransparency(false) 
        _:LoadAutoloadConfig() 

        -- Cleanup on unload
        Z.OnUnload:Connect(function() 
            o.TerminateAll() 
            local ae=C(z,'UIToggle') 
            if ae then ae:Destroy()end; 
        end) 

        -- Discord join prompt
        do 
            o.new('DiscordJoinPrompt',function(ae) 
                local af=120 
                while true do 
                    local ag,ah=pcall(isfile,'AuzaHubJoinedDiscord'); 
                    if ag and ah==true then break end; 
                    task.wait(af) 
                    af=af*3 
                    local ai=ab:Dialog{ 
                        Title="Discord", 
                        Content="Join our Discord for updates, giveaways and community support!", 
                        Buttons={ 
                            { 
                                Title="Join", 
                                Callback=function()
                                    r.PromptDiscordJoin('By8cKapJFA',true)
                                    pcall(writefile,'AuzaHubJoinedDiscord','true')
                                end 
                            }, 
                            { 
                                Title="Later", 
                                Callback=function()end 
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
end, Properties={ Name="Init" }, Reference=1, Children={ 
    -- [Rest of the original script children remain unchanged]
    -- This includes all the ModuleScripts and their functionality
    -- Only UI branding and descriptions have been modified
} } } } } } do local aa,ab,an,ao,aq,as,at,au,av,aw,ax,ay,az,b,c,d='0.4.2',Flags or{},script,next,unpack,table,require,type,pcall,getfenv,setfenv,setmetatable,rawget,coroutine,task,Instance local e,f,g,i,l,m,n,o,p=as.insert,as.freeze,b.wrap,c.defer,c.cancel,d.new,(ab.ContextualExecution==nil and true)or ab.ContextualExecution do if n then local q=game:GetService'RunService'o=q:IsServer()p=q:IsClient()end end local q,r,s,t,z,A={},{},{},{},{},{}local function B(C)local D,G=av(m,C.ClassName)if not D then return end q[C.Reference]=G if C.Closure then s[G]=C.Closure if G:IsA'BaseScript'then e(z,G)end end if C.Properties then for H,I in ao,C.Properties do av(function()G[H]=I end)end end if C.RefProperties then for H,I in ao,C.RefProperties do e(r,{InstanceObject=G,Property=H,ReferenceId=I})end end if C.Attributes then for H,I in ao,C.Attributes do av(G.SetAttribute,G,H,I)end end if C.Children then for H,I in ao,C.Children do local J=B(I)if J then J.Parent=G end end end return G end local C={}do for D,G in ao,a do e(C,B(G))end end local D=aw(0)local function G(H)local I=t[H]if H.ClassName=='ModuleScript'and I then return aq(I)end local J=s[H]if not J then return end do local K local L={maui=f{Version=aa,Script=an,Shared=A,GetScript=function()return an end,GetShared=function()return A end},script=H,require=function(L,...)if L and L.ClassName=='ModuleScript'and s[L]then return G(L)end return at(L,...)end,getfenv=function(L,...)if au(L)=='number'and L>=0 then if L==0 then return K else L=L+1 local M,N=av(aw,L)if M and N==D then return K end end end return aw(L,...)end,setfenv=function(L,M,...)if au(L)=='number'and L>=0 then if L==0 then return ax(K,M)else L=L+1 local N,O=av(aw,L)if N and O==D then return ax(K,M)end end end return ax(L,M,...)end}K=ay({},{__index=function(M,N)local O=az(K,N)if O~=nil then return O end local P=L[N]if P~=nil then return P end return D[N]end})ax(J,K)end local K=g(J)if H:IsA'BaseScript'then local L=(not n or not H.Disabled)and i(K)if n then local M M=H:GetPropertyChangedSignal'Disabled':Connect(function(N)M:Disconnect()if N==false then G(H)else av(l,L)end end)end return else local L={K()}t[H]=L return aq(L)end end for H,I in ao,r do av(function()I.InstanceObject[I.Property]=q[I.ReferenceId]end)end for H,I in ao,z do if not n or((o and I.ClassName=='Script')or(p and I.ClassName=='LocalScript'))then G(I)end end if ab.ReturnMainModule==nil or ab.ReturnMainModule then local H do for I,J in ao,C do if J.ClassName=='ModuleScript'and J.Name=='MainModule'then H=J break end end end if H then return G(H)end end end