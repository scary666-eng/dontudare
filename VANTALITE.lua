local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/scary666-eng/dontudare/refs/heads/main/udray"))()

local Window = Rayfield:CreateWindow({
    Name             = "vanta.dev | VANTA LITE",
    LoadingTitle     = "vanta.dev",
    LoadingSubtitle  = "VANTA LITE",
    ConfigurationSaving = { Enabled = false },
    KeySystem        = false,
})

-- ── Bypass ────────────────────────────────────────────────────────────────────

local bypassSuccess, bypassError = pcall(function()
    local oldMagnitude = hookmetamethod(Vector3.new(), "__index", newcclosure(function(self, index)
        local CallingScript = tostring(getcallingscript())
        if not checkcaller() and index == "magnitude" and CallingScript == "ItemSpawn" then
            return 0
        end
        return oldMagnitude(self, index)
    end))
    local oldNc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        if not checkcaller() and rawequal(self.Name, "Returner") and rawequal(Args[1], "idklolbrah2de") then
            return "  ___XP DE KEY"
        end
        return oldNc(self, ...)
    end))
    getgenv().oldMagnitude = oldMagnitude
    getgenv().oldNc = oldNc
end)
if bypassSuccess then
    print("[vanta] Bypass loaded!")
else
    warn("[vanta] Bypass failed: " .. tostring(bypassError))
end

-- ── Services ──────────────────────────────────────────────────────────────────

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace    = game:GetService("Workspace")
local player       = Players.LocalPlayer
local LocalPlayer  = player

-- ── Item limits ───────────────────────────────────────────────────────────────

local maxLimits = {
    ["Mysterious Arrow"]                  = 25,
    ["Rokakaka"]                          = 25,
    ["Gold Coin"]                         = 45,
    ["Diamond"]                           = 25,
    ["Pure Rokakaka"]                     = 999,
    ["Quinton's Glove"]                   = 10,
    ["Steel Ball"]                        = 10,
    ["Rib Cage of The Saint's Corpse"]    = 10,
    ["Zeppeli's Hat"]                     = 10,
    ["Caesar's Headband"]                 = 10,
    ["Clackers"]                          = 10,
    ["Stone Mask"]                        = 10,
    ["Ancient Scroll"]                    = 10,
    ["Dio's Diary"]                       = 10,
    ["Lucky Stone Mask"]                  = 999,
    ["Lucky Arrow"]                       = 999,
    ["Gold Umbrella"]                     = 999,
    ["Christmas Present"]                 = 999,
    ["Zepellin's Headband"]               = 10,
}

local itemOptions = {}
for k in pairs(maxLimits) do table.insert(itemOptions, k) end
table.sort(itemOptions)

-- ── Farm State ────────────────────────────────────────────────────────────────

local items             = {}
local normalFarmOn      = false
local afkFarmOn         = false
local selectedFarmItems = {}
local travelMethod      = "Stud"
local studMultiplier    = 1
local tweenMultiplier   = 1
local tpDelay           = 0.05
local instantPickup     = false
local noclipEnabled     = false
local noclipConn        = nil
local originalCollides  = {}
local autoSellMax       = false
local instantPickupConn = nil

-- ── Farm Helpers ──────────────────────────────────────────────────────────────

local function updateItems()
    items = {}
    for itemName in pairs(maxLimits) do items[itemName] = 0 end
    local function countIn(container)
        if not container then return end
        for _, item in pairs(container:GetChildren()) do
            if item and item.Name and maxLimits[item.Name] then
                items[item.Name] = (items[item.Name] or 0) + 1
            end
        end
    end
    countIn(player.Backpack)
    if player.Character then countIn(player.Character) end
end

local function enforceNoclipForCharacter(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCollides[part] = part.CanCollide
            part.CanCollide = false
        end
    end
end

local function enableNoclip()
    if noclipEnabled then return end
    local char = player.Character
    if not char or not char.Parent then noclipEnabled = true return end
    originalCollides = {}
    enforceNoclipForCharacter(char)
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    noclipConn = RunService.Stepped:Connect(function()
        local c = player.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end)
    noclipEnabled = true
end

local function disableNoclip()
    if not noclipEnabled then return end
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    for part, val in pairs(originalCollides) do
        if part and part.Parent and part:IsA("BasePart") then
            pcall(function() part.CanCollide = val end)
        end
    end
    originalCollides = {}
    noclipEnabled = false
end

-- ── Travel ────────────────────────────────────────────────────────────────────

local function travelToStud(target)
    if not player.Character or not player.Character.HumanoidRootPart then return end
    local hrp = player.Character.HumanoidRootPart
    local targetPos = typeof(target) == "Vector3" and target or target.Position
    local vector = targetPos - hrp.Position
    local length = vector.Magnitude
    local step_size = 25 * studMultiplier
    local num_tp = math.ceil(length / step_size)
    if num_tp < 1 then num_tp = 1 end
    for i = 1, num_tp do
        if not player.Character or not player.Character.HumanoidRootPart then return end
        hrp.CFrame = hrp.CFrame + vector / num_tp
        wait(tpDelay)
    end
end

local function travelToTween(target)
    if not player.Character or not player.Character.HumanoidRootPart then return end
    local hrp = player.Character.HumanoidRootPart
    local targetPos = typeof(target) == "Vector3" and target or target.Position
    local distance = (targetPos - hrp.Position).Magnitude
    local time = distance / (200 * tweenMultiplier)
    local tween = TweenService:Create(hrp, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end

local function travelToInstant(target)
    if not player.Character or not player.Character.HumanoidRootPart then return end
    local hrp = player.Character.HumanoidRootPart
    local targetPos = typeof(target) == "Vector3" and target or target.Position
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 0.10, 0))
end

local function travelTo(target)
    if travelMethod == "Stud" then travelToStud(target)
    elseif travelMethod == "Tween" then travelToTween(target)
    elseif travelMethod == "Instant" then travelToInstant(target) end
end

local function teleportToRandom()
    if not player.Character or not player.Character.HumanoidRootPart then return end
    local hrp = player.Character.HumanoidRootPart
    hrp.CFrame = CFrame.new(math.random(-590,590), 100, math.random(-520,530))
end

local function roamToRandom()
    travelTo(Vector3.new(math.random(-590,590), 100, math.random(-520,530)))
end

-- ── Sell ──────────────────────────────────────────────────────────────────────

local function sellItem(item)
    if not item then return false end
    local instanceToSell
    if typeof(item) == "Instance" then
        instanceToSell = item
    else
        instanceToSell = player.Backpack:FindFirstChild(item) or (player.Character and player.Character:FindFirstChild(item))
    end
    if not instanceToSell or not instanceToSell.Parent then return false end
    local args = {[1] = "EndDialogue", [2] = {["NPC"] = "Merchant", ["Option"] = "Option2", ["Dialogue"] = "Dialogue5"}}
    if player.Character then
        local r = player.Character:FindFirstChildWhichIsA("RemoteEvent")
        if r then pcall(function() r:FireServer(table.unpack(args)) end) end
    end
    wait(0.12)
    return true
end

local function checkAndSellMax()
    if not autoSellMax then return end
    local tempCounts = {}
    for name in pairs(maxLimits) do tempCounts[name] = 0 end
    local containers = {player.Backpack}
    if player.Character then table.insert(containers, player.Character) end
    for _, container in ipairs(containers) do
        for _, item in ipairs(container:GetChildren()) do
            local name = item.Name
            if maxLimits[name] then
                tempCounts[name] = tempCounts[name] + 1
                if tempCounts[name] >= (maxLimits[name] or 25) then
                    sellItem(item)
                end
            end
        end
    end
end

-- ── Item finding ──────────────────────────────────────────────────────────────

local function findNearestItem(selectedItems)
    updateItems()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local minDist = math.huge
    local nearest = nil
    for _, v in pairs(workspace.Item_Spawns.Items:GetChildren()) do
        local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
        local proxPrompt = v:FindFirstChild("ProximityPrompt")
        if itemPart and proxPrompt and itemPart.Transparency < 1 then
            local itemName = proxPrompt.ObjectText
            if (#selectedItems == 0 or table.find(selectedItems, itemName))
            and (items[itemName] or 0) < (maxLimits[itemName] or math.huge) then
                local dist = (itemPart.Position - hrp.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = v
                end
            end
        end
    end
    return nearest
end

local function findLuckyArrow()
    local hrp = player.Character and player.Character.HumanoidRootPart
    if not hrp then return nil end
    local minDist = math.huge
    local nearest = nil
    for _, v in pairs(workspace.Item_Spawns.Items:GetChildren()) do
        local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
        local prox = v:FindFirstChild("ProximityPrompt")
        if itemPart and prox and itemPart.Transparency < 1 and prox.ObjectText == "Lucky Arrow" then
            local dist = (itemPart.Position - hrp.Position).Magnitude
            if dist < minDist then minDist = dist nearest = v end
        end
    end
    return nearest
end

-- ── Instant pickup ────────────────────────────────────────────────────────────

local function getItemContainer()
    local spawns = workspace:FindFirstChild("Item_Spawns")
    if not spawns then return nil end
    return spawns:FindFirstChild("Items")
end

local function setPromptsInstant(instant)
    local container = getItemContainer()
    if not container then return end
    for _, v in pairs(container:GetChildren()) do
        local prox = v:FindFirstChild("ProximityPrompt")
        if prox then pcall(function() prox.HoldDuration = instant and 0 or 0.5 end) end
    end
end

local function enableInstantPickup()
    instantPickup = true
    setPromptsInstant(true)
    local container = getItemContainer()
    if container then
        instantPickupConn = container.ChildAdded:Connect(function(v)
            wait(0.05)
            local prox = v:FindFirstChild("ProximityPrompt")
            local part = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
            if prox and part and part.Transparency < 1 then
                pcall(function() prox.HoldDuration = 0 end)
                pcall(function() fireproximityprompt(prox, 0) end)
            end
        end)
    end
end

local function disableInstantPickup()
    instantPickup = false
    setPromptsInstant(false)
    if instantPickupConn then instantPickupConn:Disconnect() instantPickupConn = nil end
end

-- ── Farm loops ────────────────────────────────────────────────────────────────

local function normalFarm()
    while normalFarmOn do
        if not player.Character or not player.Character:FindFirstChild("Humanoid")
        or player.Character.Humanoid.Health <= 0 then
            wait(1) continue
        end
        local foundItem = false
        while true do
            local v = findLuckyArrow() or findNearestItem(selectedFarmItems)
            if not v then break end
            foundItem = true
            local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
            local proxPrompt = v:FindFirstChild("ProximityPrompt")
            if instantPickup then
                travelToInstant(itemPart)
                wait(1)
                checkAndSellMax()
                fireproximityprompt(proxPrompt, 0, true)
            else
                travelTo(itemPart)
                wait(0.2)
                local hrp = player.Character.HumanoidRootPart
                if (itemPart.Position - hrp.Position).Magnitude < 5 then
                    checkAndSellMax()
                    fireproximityprompt(proxPrompt, 4)
                    wait(0.1)
                    if v:IsDescendantOf(workspace) then
                        fireproximityprompt(proxPrompt, 4)
                    end
                end
            end
            checkAndSellMax()
            wait(0.2)
        end
        if not foundItem then teleportToRandom() end
        wait(0.2)
    end
end

local function afkFarm()
    while afkFarmOn do
        if not player.Character or not player.Character:FindFirstChild("Humanoid")
        or player.Character.Humanoid.Health <= 0 then
            wait(1) continue
        end
        local roaming = true
        while roaming and afkFarmOn do
            if not player.Character or not player.Character:FindFirstChild("Humanoid")
            or player.Character.Humanoid.Health <= 0 then break end
            local v = findLuckyArrow() or findNearestItem(selectedFarmItems)
            if v then
                roaming = false
                local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
                local proxPrompt = v:FindFirstChild("ProximityPrompt")
                if instantPickup then
                    travelToInstant(itemPart)
                    wait(1)
                    checkAndSellMax()
                    fireproximityprompt(proxPrompt, 0, true)
                else
                    travelTo(itemPart)
                    wait(0.2)
                    local hrp = player.Character.HumanoidRootPart
                    if (itemPart.Position - hrp.Position).Magnitude < 5 then
                        checkAndSellMax()
                        fireproximityprompt(proxPrompt, 4)
                        wait(0.1)
                        if v:IsDescendantOf(workspace) then
                            fireproximityprompt(proxPrompt, 4)
                        end
                    end
                end
                checkAndSellMax()
                roaming = true
            else
                local hrp = player.Character.HumanoidRootPart
                local currentPos = hrp.Position
                travelTo(Vector3.new(currentPos.X, 100, currentPos.Z))
                roamToRandom()
            end
            wait(0.25)
        end
    end
end

local function startFarming(method)
    if method == "Normal" then
        normalFarmOn = true
        task.spawn(normalFarm)
    elseif method == "AFK" then
        afkFarmOn = true
        task.spawn(afkFarm)
    end
    enableNoclip()
end

local function stopFarming()
    normalFarmOn = false
    afkFarmOn = false
    disableNoclip()
end

player.CharacterAdded:Connect(function()
    if normalFarmOn or afkFarmOn then
        wait(2)
        enableNoclip()
        if normalFarmOn then task.spawn(normalFarm)
        elseif afkFarmOn then task.spawn(afkFarm) end
    end
end)

-- ═════════════════════════════════════════════════════════════════════════════
-- TAB 1: ITEM FARM
-- ═════════════════════════════════════════════════════════════════════════════

local FarmTab = Window:CreateTab("Item Farm", 4483362458)

FarmTab:CreateSection("Farm Method")

local farmMethod = "Normal"
FarmTab:CreateDropdown({
    Name          = "Farm Method",
    Options       = {"Normal", "AFK"},
    CurrentOption = {"Normal"},
    Callback      = function(option)
        farmMethod = option[1] or option
    end,
})

FarmTab:CreateSection("Item Selection")

FarmTab:CreateDropdown({
    Name            = "Items to Farm",
    Options         = itemOptions,
    CurrentOption   = {},
    MultipleOptions = true,
    Callback        = function(selected)
        if type(selected) == "table" then
            selectedFarmItems = selected
        end
    end,
})

FarmTab:CreateSection("Controls")

FarmTab:CreateToggle({
    Name         = "Enable Farming",
    CurrentValue = false,
    Callback     = function(v)
        if v then
            Rayfield:Notify({ Title = "vanta.dev", Content = "Farming started (" .. farmMethod .. ")", Duration = 3, Image = 4483362458 })
            startFarming(farmMethod)
        else
            Rayfield:Notify({ Title = "vanta.dev", Content = "Farming stopped.", Duration = 3, Image = 4483362458 })
            stopFarming()
        end
    end,
})

FarmTab:CreateToggle({
    Name         = "Auto Sell on Max",
    CurrentValue = false,
    Callback     = function(v)
        autoSellMax = v
    end,
})

FarmTab:CreateToggle({
    Name         = "Instant Pickup",
    CurrentValue = false,
    Callback     = function(v)
        if v then enableInstantPickup() else disableInstantPickup() end
    end,
})

FarmTab:CreateSection("Travel Settings")

FarmTab:CreateDropdown({
    Name          = "Travel Method",
    Options       = {"Stud", "Tween", "Instant"},
    CurrentOption = {"Stud"},
    Callback      = function(option)
        travelMethod = option[1] or option
    end,
})

FarmTab:CreateSlider({
    Name         = "Stud Speed (%)",
    Range        = {0, 200},
    Increment    = 1,
    CurrentValue = 100,
    Callback     = function(v) studMultiplier = v / 100 end,
})

FarmTab:CreateSlider({
    Name         = "Tween Speed (%)",
    Range        = {0, 200},
    Increment    = 1,
    CurrentValue = 100,
    Callback     = function(v) tweenMultiplier = v / 100 end,
})

FarmTab:CreateSection("Info")
FarmTab:CreateParagraph({
    Title   = "vanta.dev",
    Content = "Item farmer with bypass.\nSelect items, pick method, enable farming.",
})

-- ═════════════════════════════════════════════════════════════════════════════
-- TAB 2: AUTO PARRY
-- ═════════════════════════════════════════════════════════════════════════════

local AutoParryTab = Window:CreateTab("Auto Parry", 6031071057)

AutoParryTab:CreateSection("VANTA Auto Parry")

-- ── Auto Parry Config ─────────────────────────────────────────────────────────

local ParryConfig = {
    Enabled              = false,
    Reblocking           = true,
    KeepBlock            = true,
    Unblocking           = true,
    ProjectilesPriority  = true,
    ColiseumMode         = false,
    BlockBeachBoy        = false,
    PerfectBlockMode     = false,
    BlockRange           = 25,
    ReactionDelay        = 0.05,
    PingCompensation     = true,
    ExtraDelayEnabled    = true,
    ExtraDelayAmount     = 0.05,
    FarTargetDelay       = 0.3,
    DistanceThreshold    = 0.7,
    StandDelay           = 0.02,
}

local ParryState = {
    Blocking         = false,
    LastBlock        = 0,
    BlockActions     = false,
    BlockProcsUntil  = 0,
    LastTarget       = nil,
    HookedPlayers    = {},
    FKeyHeld         = false,
    IsRagdolled      = false,
}

local Camera = Workspace.CurrentCamera

local BlockDatabase = {
    PerfectBlocks = {
        {"rbxassetid://7217913060", {def = 0.2}},
        {"rbxassetid://4725629903", {def = 0.2}},
        {"rbxassetid://6032844827", {def = 0.2}},
        {"rbxassetid://163619849",  {def = 0.2}},
        {"rbxassetid://7217914447", {def = 0, chckfunc = function(parent)
            local stand = parent:FindFirstChild("StandMorph")
            if stand then
                local standName = stand:FindFirstChild("Stand Name")
                return standName and standName.Value == "Star Platinum"
            end
            return false
        end}},
        {"rbxassetid://7217914447", {def = 0, chckfunc = function(parent)
            local stand = parent:FindFirstChild("StandMorph")
            if stand then
                local standName = stand:FindFirstChild("Stand Name")
                return standName and standName.Value ~= "Star Platinum"
            end
            return false
        end}},
    },
    BaseBlocks = {
        {"rbxassetid://6032836072",  {def = 0.3}},
        {"rbxassetid://6034138660",  {def = 0.3}},
        {"rbxassetid://10459370874", {def = 0.35, addw = -0.35, dist = 15}},
        {"rbxassetid://12440326715", {addw = -0.1, dist = 15}},
        {"rbxassetid://74034132845527", {def = 0.4}},
    },
    UnblockTriggers = {
        "rbxassetid://11876873350",
    },
    AnimationBlocks = {
        {"rbxassetid://6048575522", {def = 0, chckfunc = function(_, parent)
            local stand = parent:FindFirstChild("StandMorph")
            if stand then
                local standName = stand:FindFirstChild("Stand Name")
                return standName and standName.Value == "Star Platinum"
            end
            return false
        end}},
        {"rbxassetid://6048575522", {def = 0.3, dist = 20, chckfunc = function(_, parent)
            local stand = parent:FindFirstChild("StandMorph")
            if stand then
                local standName = stand:FindFirstChild("Stand Name")
                return standName and standName.Value ~= "Star Platinum"
            end
            return true
        end}},
        {"rbxassetid://4211804997", {def = 0.3, dist = 20, chckfunc = function(_, parent)
            local stand = parent:FindFirstChild("StandMorph")
            if stand then
                local standName = stand:FindFirstChild("Stand Name")
                return standName and standName.Value ~= "Tusk ACT 4"
            end
            return true
        end}},
        {"rbxassetid://13899360363", {def = 0.4, dist = 20}},
        {"rbxassetid://7189005773",  {def = 0.3, dist = 20}},
        {"rbxassetid://6835249882",  {def = 0.4, dist = 20}},
        {"rbxassetid://11886825775", {def = 0.3, dist = 20}},
        {"rbxassetid://4879759800",  {def = 0.4, dist = 20}},
        {"rbxassetid://4825999731",  {def = 0.5, dist = 160, chckfunc = function()
            return ParryConfig.ColiseumMode
        end}},
        {"rbxassetid://6704817082",  {def = 0.35, dist = 20}},
        {"rbxassetid://6049426097",  {def = 0.3,  dist = 20}},
        {"rbxassetid://6105486059",  {def = 0.35, dist = 20}},
        {"rbxassetid://5303743107",  {def = 0.35, dist = 20}},
        {"rbxassetid://7250792726",  {def = 0.4,  dist = 20}},
        {"rbxassetid://4812642386",  {def = 0.35, dist = 20}},
        {"rbxassetid://6216052429",  {def = 0.3, chckfunc = function(anim, _)
            task.wait()
            return anim.Speed > 1.39
        end}},
        {"rbxassetid://6216052429",  {def = 0.35, dist = 20}},
        {"rbxassetid://4096014941",  {def = 0.4, chckfunc = function(anim, _)
            return anim.Speed > 1.049 and anim.Speed < 1.051
        end}},
        {"rbxassetid://4096014941",  {def = 0.4, chckfunc = function(anim, _)
            return anim.Speed > 1.074 and anim.Speed < 1.076
        end}},
        {"rbxassetid://4096014941",  {def = 0.4, chckfunc = function(anim, parent)
            local stand = parent:FindFirstChild("StandMorph")
            if stand then
                local standName = stand:FindFirstChild("Stand Name")
                if standName and standName.Value == "Magician's Red" then
                    return anim.Speed == 1
                end
            end
            return false
        end}},
        {"rbxassetid://4096014941",  {def = 0.4, chckfunc = function(_, parent)
            local stand = parent:FindFirstChild("StandMorph")
            if stand then
                local standName = stand:FindFirstChild("Stand Name")
                return standName and standName.Value == "Gold Experience"
            end
            return false
        end}},
        {"rbxassetid://4096014941",  {def = 0.3, dist = 75, chckfunc = function(_, parent)
            local stand = parent:FindFirstChild("StandMorph")
            if not stand then return false end
            local standName = stand:FindFirstChild("Stand Name")
            if not standName or standName.Value ~= "The Hand" then return false end
            task.wait()
            for _, child in ipairs(stand:GetChildren()) do
                if child:IsA("Sound") and child.SoundId == "rbxassetid://7217913060" then
                    return false
                end
            end
            return true
        end}},
        {"rbxassetid://4096014941",  {def = 0.4, chckfunc = function(anim, _)
            return anim.Speed > 1.09 and anim.Speed < 1.11
        end}},
        {"rbxassetid://4096014941",  {def = 0.4, chckfunc = function(anim, _)
            return anim.Speed > 0.84 and anim.Speed < 0.86
        end}},
        {"rbxassetid://12733018380", {def = 0.35, dist = 15, addw = 1.1}},
        {"rbxassetid://12733022476", {coliseum = true, dist = 1000, addw = 0.3}},
        {"rbxassetid://4608512208",  {addw = 0.25}},
        {"rbxassetid://5303988283",  {def = 0.2, dist = 20}},
        {"rbxassetid://6780938176",  {def = 0.2, addw = 0.3, dist = 20}},
        {"rbxassetid://12292886724", {def = 0.35, dist = 20}},
        {"rbxassetid://6277192242",  {def = 0.2, dist = 50, addw = 1}},
        {"rbxassetid://6651725175",  {addw = -0.1, dist = 40}},
        {"rbxassetid://6216058630",  {def = 0, coliseum = true, dist = 60, addw = -0.1}},
        {"rbxassetid://10726619714", {def = 0.2, addw = 0.55, dist = 20}},
        {"rbxassetid://12293320463", {def = 0.3, dist = 20}},
        {"rbxassetid://6869896659",  {def = 0.2, addw = 0.75, dist = 20}},
        {"rbxassetid://14174878575", {def = 0.3, dist = 70, addw = -0.1, coliseum = true}},
        {"rbxassetid://7189003645",  {def = 0.3, addw = 0.2, dist = 20}},
        {"rbxassetid://5793968491",  {def = 0.35, dist = 20}},
        {"rbxassetid://4595562165",  {def = 0, addw = 0.3}},
        {"rbxassetid://5227558947",  {def = 0.35, dist = 20}},
        {"rbxassetid://4133363765",  {def = 0.6, dist = 20}},
        {"rbxassetid://4691787301",  {def = 0.25, addw = 0.75, dist = 100, chckfunc = function(_, parent)
            task.wait()
            local grapple = parent:FindFirstChild("RightHand") and parent.RightHand:FindFirstChild("Grapple")
            if grapple then
                return grapple.Attachment1 == LocalPlayer.Character.HumanoidRootPart.RootRigAttachment
            end
            return false
        end}},
        {"rbxassetid://12733016318", {def = 0.325, addw = -0.1, dist = 15, chckfunc = function(anim, _)
            return anim.Speed < 0.75
        end}},
        {"rbxassetid://4096014941",  {def = 0.35, dist = 20}},
        {"rbxassetid://6048575522",  {def = 0.35, dist = 20}},
        {"rbxassetid://4211804997",  {def = 0.35, dist = 20}},
        {"rbxassetid://5303743107",  {def = 0.3,  dist = 20}},
        {"rbxassetid://6105486059",  {def = 0.3,  dist = 20}},
        {"rbxassetid://6049426097",  {def = 0.35, dist = 20}},
    },
    AnimationUnblock = {
        "rbxassetid://12293318922",
        "rbxassetid://13819646949",
        "rbxassetid://6780937804",
        "rbxassetid://6780982308",
        {"rbxassetid://10443019808", {dist = 10}},
    },
    Projectiles = {
        {"VisionPlunderBubble", "Core", 15},
        {"SP Bullet", nil, 20, function(obj) return obj:FindFirstChild("Victim") and true or false end},
        {"Last Shot", nil, 20},
        {"Main", nil, 25, function(obj) return obj:FindFirstChild("BloodTrail") and true or false end},
        {"HomingShard", nil, 20},
        {"Bullet", nil, 20, function(obj)
            if obj.Name:find("SP Bullet") or obj.Name:find("SPBullet") then
                return false
            else
                return not obj:FindFirstChild("Victim")
            end
        end},
        {"CrossFirePiece", nil, 40, function(obj)
            local sparks = obj:FindFirstChild("OnFireSparks")
            return sparks and sparks.Enabled
        end, true, true},
        {"Baseball3", nil, 20},
    },
    SpecialObjects = {
        {"GroundIndicator", function(obj)
            local settings = {def = 0, wt = 0, addw = -0.1}
            local clone = obj:Clone()
            local expandedSize = 15 + 10
            clone.Size = Vector3.new(15 + expandedSize, 5, 40 + expandedSize)
            clone.CFrame = clone.CFrame * CFrame.new(0, 0, -12.5)
            task.wait(0.15)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos = hrp.Position
                local min = clone.Position - clone.Size/2
                local max = clone.Position + clone.Size/2
                if pos.X >= min.X and pos.X <= max.X and
                   pos.Y >= min.Y and pos.Y <= max.Y and
                   pos.Z >= min.Z and pos.Z <= max.Z then
                    RequestParryBlock(settings.def, settings.wt, settings.addw, false)
                end
            end
            clone:Destroy()
            return true
        end},
        {"FloorDash", function(obj)
            if not IsParryInRange(obj.Position, 40) then return false end
            local settings = {def = 0, wt = 0, addw = 0.25}
            task.wait(0.2)
            RequestParryBlock(settings.def, settings.wt, settings.addw, false)
            return true
        end},
    }
}

local function GetParryPing()
    return LocalPlayer:GetNetworkPing()
end

local function IsTimeStop()
    return Workspace:FindFirstChild("TimeStop") or game.Lighting:FindFirstChild("TimeStop")
end

local function IsRagdolledChar(character)
    if not character then return false end
    return character:FindFirstChild("RagdollParts") and true or false
end

local function GetParryCharacter()
    return LocalPlayer.Character
end

local function GetParryHRP()
    local char = GetParryCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function IsParryInRange(position, range)
    local hrp = GetParryHRP()
    if not hrp then return false end
    return (position - hrp.Position).Magnitude <= range
end

local function ParryBlock()
    local char = GetParryCharacter()
    if not char then return end
    local blockingCap = char:FindFirstChild("Blocking_Capacity")
    if blockingCap and blockingCap.Value <= 0 then
        ParryState.Blocking = true
        local remote = char:FindFirstChild("RemoteEvent")
        if remote then
            for i = 1, 3 do
                remote:FireServer("StartBlocking", "pass")
                task.wait()
            end
        end
    end
end

local function ParryUnblock(forced, instant)
    if not ParryConfig.Unblocking and not forced then return end
    if forced and not ParryConfig.Reblocking and not IsRagdolledChar(GetParryCharacter()) then return 42 end
    local char = GetParryCharacter()
    if not char then return end
    if not (forced or instant) and ParryState.FKeyHeld and ParryConfig.KeepBlock and not IsRagdolledChar(char) then
        return
    end
    local remote = char:FindFirstChild("RemoteEvent")
    if remote then
        for i = 1, 5 do
            remote:FireServer("StopBlocking", "pass")
            task.wait()
        end
    end
    ParryState.Blocking = false
    ParryState.BlockActions = false
end

function RequestParryBlock(defense, waitTime, addWait, isPerfect, priority, isStandAttack)
    if not ParryConfig.Enabled then return end
    if ParryState.BlockActions then
        local currentPrio = tonumber(ParryState.BlockActions) or 0
        if priority and priority <= currentPrio then return end
    end
    ParryState.BlockActions = priority or true
    local char = GetParryCharacter()
    if not char then return end
    local remote = char:FindFirstChild("RemoteEvent")
    if remote then
        remote:FireServer("HoldAttack", {Bool = false, Type = "m1"})
    end
    ParryState.LastBlock = ParryState.LastBlock + 1
    local currentBlock = ParryState.LastBlock
    local blockingCap = char:FindFirstChild("Blocking_Capacity")
    if blockingCap and blockingCap.Value > 0 and isPerfect then
        if defense < 0.2 or not ParryConfig.Reblocking then return end
        if ParryUnblock(true) == 42 then return end
    end
    local pingComp = ParryConfig.PingCompensation and GetParryPing() or 0
    local actualWait = math.max(0, defense - pingComp)
    if waitTime and waitTime > actualWait then actualWait = waitTime end
    if ParryConfig.ExtraDelayEnabled then actualWait = actualWait + ParryConfig.ExtraDelayAmount end
    if isStandAttack and ParryConfig.StandDelay > 0 then actualWait = actualWait + ParryConfig.StandDelay end
    task.wait(actualWait)
    if ParryState.LastBlock ~= currentBlock then return end
    if IsTimeStop() then ParryState.BlockActions = false return end
    ParryBlock()
    local unblockDelay = 0.4 + math.max(0.1, GetParryPing()) + (addWait or 0)
    task.wait(unblockDelay)
    if ParryState.LastBlock == currentBlock and not IsTimeStop() then
        ParryState.BlockActions = false
        ParryUnblock(false)
    end
end

local function ProcessBlockTrigger(source, parent, secondaryPart)
    if not ParryConfig.Enabled then return end
    if IsTimeStop() then return end
    if IsRagdolledChar(GetParryCharacter()) then return end
    if ParryState.BlockProcsUntil > tick() then return end
    local isPerfect = false
    local defense = 0.4
    local addWait = 0
    local priority = 0
    local distance = ParryConfig.BlockRange
    local found = false
    local extraWait = 0
    local isStandAttack = false
    local function checkDistance(maxDist)
        local hrp = GetParryHRP()
        if not hrp then return false, 0 end
        local targetPos = secondaryPart and secondaryPart.Position or parent.Position
        local dist = (hrp.Position - targetPos).Magnitude
        if dist > maxDist then
            if secondaryPart then
                dist = (hrp.Position - parent.Position).Magnitude
                if dist > maxDist then return false, dist end
            else
                return false, dist
            end
        end
        if dist > maxDist * ParryConfig.DistanceThreshold then
            extraWait = ParryConfig.FarTargetDelay
            task.wait(extraWait)
            hrp = GetParryHRP()
            if not hrp then return false, dist end
            dist = (hrp.Position - targetPos).Magnitude
            if dist > maxDist then return false, dist end
        end
        return true, dist
    end
    if source:IsA("Sound") then
        for _, blockData in ipairs(BlockDatabase.PerfectBlocks) do
            local id = type(blockData) == "table" and blockData[1] or blockData
            local settings = type(blockData) == "table" and blockData[2] or {}
            if source.SoundId == id then
                if settings.chckfunc and not settings.chckfunc(parent) then continue end
                isPerfect = true
                defense = settings.def or 0.2
                distance = settings.dist or distance
                addWait = settings.addw or addWait
                priority = settings.prio or priority
                found = true
                break
            end
        end
        if not found then
            for _, blockData in ipairs(BlockDatabase.BaseBlocks) do
                local id = type(blockData) == "table" and blockData[1] or blockData
                local settings = type(blockData) == "table" and blockData[2] or {}
                if source.SoundId == id then
                    isPerfect = false
                    defense = settings.def or 0.3
                    distance = settings.dist or distance
                    addWait = settings.addw or addWait
                    found = true
                    break
                end
            end
        end
        if not found then
            for _, id in ipairs(BlockDatabase.UnblockTriggers) do
                if source.SoundId == id and ParryState.LastTarget == parent then
                    ParryState.LastBlock = ParryState.LastBlock + 1
                    ParryState.BlockProcsUntil = tick() + 0.75
                    ParryState.BlockActions = false
                    ParryUnblock(false)
                    return
                end
            end
        end
    end
    if not found and source:IsA("AnimationTrack") then
        local animId = source.Animation and source.Animation.AnimationId
        if animId then
            for _, blockData in ipairs(BlockDatabase.AnimationBlocks) do
                local id = type(blockData) == "table" and blockData[1] or blockData
                local settings = type(blockData) == "table" and blockData[2] or {}
                if type(blockData) == "table" and settings.coliseum and not ParryConfig.ColiseumMode then
                    continue
                end
                if animId == id then
                    if settings.chckfunc and not settings.chckfunc(source, parent) then continue end
                    isPerfect = (settings.def or 0.4) <= 0.2
                    defense = settings.def or 0.3
                    distance = settings.dist or distance
                    addWait = settings.addw or addWait
                    priority = settings.prio or priority
                    found = true
                    if id == "rbxassetid://6048575522" or id == "rbxassetid://4096014941" or
                       id == "rbxassetid://4211804997" or id == "rbxassetid://5303743107" or
                       id == "rbxassetid://6105486059" or id == "rbxassetid://6049426097" then
                        isStandAttack = true
                    end
                    break
                end
            end
        end
    end
    if found then
        ParryState.LastTarget = parent
        local inRange, actualDist = checkDistance(distance)
        if inRange then
            local pingComp = ParryConfig.PingCompensation and GetParryPing() or 0
            local calculatedWait = math.max(0, defense - pingComp) + extraWait
            RequestParryBlock(defense, calculatedWait, addWait, isPerfect, priority, isStandAttack)
        end
    end
end

local function HandleProjectile(obj)
    if not ParryConfig.Enabled then return end
    for _, projData in ipairs(BlockDatabase.Projectiles) do
        local namePattern, childName, range, validator = unpack(projData)
        if obj.Name:find(namePattern) then
            local target = childName and obj:FindFirstChild(childName) or obj
            if validator and not validator(obj) then continue end
            local hrp = GetParryHRP()
            if not hrp then return end
            local function isInRange()
                local pos = target.Position
                local vel = target.AssemblyLinearVelocity
                if vel.Magnitude > 0.01 then
                    local unit = vel.Unit
                    local predictedPos = pos + unit * 10
                    local dist1 = (hrp.Position - pos).Magnitude
                    local dist2 = (hrp.Position - predictedPos).Magnitude
                    return dist1 < range or dist2 < range
                else
                    return (hrp.Position - pos).Magnitude < range
                end
            end
            while obj.Parent and obj:IsDescendantOf(Workspace) do
                if isInRange() and (not ParryState.BlockActions or ParryConfig.ProjectilesPriority) then
                    ParryState.BlockActions = true
                    if ParryConfig.ProjectilesPriority then ParryState.BlockActions = 42000 end
                    ParryBlock()
                    local blockStart = tick()
                    while obj.Parent and (tick() - blockStart < 0.75) do
                        if not isInRange() then break end
                        task.wait()
                    end
                    if tick() - blockStart < 0.432 then
                        task.wait(0.432 - (tick() - blockStart))
                    end
                    if not IsTimeStop() then
                        ParryUnblock(false)
                        ParryState.BlockActions = false
                    end
                    return
                end
                task.wait()
            end
        end
    end
end

local function HandleSpecialObject(obj)
    if not ParryConfig.Enabled then return end
    for _, specialData in ipairs(BlockDatabase.SpecialObjects) do
        local namePattern, handler = unpack(specialData)
        if obj.Name:find(namePattern) then
            handler(obj)
            return
        end
    end
end

local function HookParryPlayer(player2)
    if player2 == LocalPlayer then return end
    if ParryState.HookedPlayers[player2.Name] then return end
    local function setupHooks(character)
        if not character then return end
        local humanoid = character:WaitForChild("Humanoid", 5)
        local animator = humanoid and humanoid:WaitForChild("Animator", 5)
        if animator then
            animator.AnimationPlayed:Connect(function(track)
                ProcessBlockTrigger(track, character.PrimaryPart, nil)
            end)
        end
        character.DescendantAdded:Connect(function(desc)
            if desc:IsA("Sound") then
                task.wait()
                ProcessBlockTrigger(desc, character.PrimaryPart, nil)
            elseif desc:IsA("Model") and desc.Name == "StandMorph" then
                task.wait(0.15)
                local standAnimators = {}
                local standAnimator = desc:FindFirstChild("Animator", true)
                if standAnimator then table.insert(standAnimators, standAnimator) end
                local standHumanoid = desc:FindFirstChildOfClass("Humanoid")
                if standHumanoid then
                    local standHumAnimator = standHumanoid:FindFirstChild("Animator")
                    if standHumAnimator then table.insert(standAnimators, standHumAnimator) end
                end
                local animController = desc:FindFirstChildOfClass("AnimationController")
                if animController then
                    local ctrlAnimator = animController:FindFirstChild("Animator")
                    if ctrlAnimator then table.insert(standAnimators, ctrlAnimator) end
                end
                for _, anim in ipairs(standAnimators) do
                    anim.AnimationPlayed:Connect(function(track)
                        ProcessBlockTrigger(track, character.PrimaryPart, nil)
                    end)
                end
                desc.DescendantAdded:Connect(function(standDesc)
                    if standDesc:IsA("Animator") then
                        task.wait(0.1)
                        standDesc.AnimationPlayed:Connect(function(track)
                            ProcessBlockTrigger(track, character.PrimaryPart, nil)
                        end)
                    end
                end)
            elseif desc:IsA("Animator") then
                task.wait(0.1)
                desc.AnimationPlayed:Connect(function(track)
                    ProcessBlockTrigger(track, character.PrimaryPart, nil)
                end)
            end
        end)
        local existingStand = character:FindFirstChild("StandMorph")
        if existingStand then
            task.wait(0.15)
            local standAnimators = {}
            local standAnimator = existingStand:FindFirstChild("Animator", true)
            if standAnimator then table.insert(standAnimators, standAnimator) end
            local standHumanoid = existingStand:FindFirstChildOfClass("Humanoid")
            if standHumanoid then
                local standHumAnimator = standHumanoid:FindFirstChild("Animator")
                if standHumAnimator then table.insert(standAnimators, standHumAnimator) end
            end
            local animController = existingStand:FindFirstChildOfClass("AnimationController")
            if animController then
                local ctrlAnimator = animController:FindFirstChild("Animator")
                if ctrlAnimator then table.insert(standAnimators, ctrlAnimator) end
            end
            for _, anim in ipairs(standAnimators) do
                anim.AnimationPlayed:Connect(function(track)
                    ProcessBlockTrigger(track, character.PrimaryPart, nil)
                end)
            end
        end
    end
    if player2.Character then setupHooks(player2.Character) end
    player2.CharacterAdded:Connect(setupHooks)
    ParryState.HookedPlayers[player2.Name] = true
end

-- Input listeners for F key (keep block)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.F then
        ParryState.FKeyHeld = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F then
        ParryState.FKeyHeld = false
    end
end)

-- Ragdoll detection for local player
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child.Name == "RagdollParts" then
            ParryState.IsRagdolled = true
            ParryState.LastBlock = ParryState.LastBlock + 1
            ParryState.BlockProcsUntil = tick() + 0.2
            ParryState.BlockActions = false
            ParryUnblock(false)
        end
    end)
    char.ChildRemoved:Connect(function(child)
        if child.Name == "RagdollParts" then
            ParryState.IsRagdolled = false
        end
    end)
end)

-- Workspace projectile/special object watchers
Workspace.DescendantAdded:Connect(function(desc)
    if not ParryConfig.Enabled then return end
    HandleProjectile(desc)
    HandleSpecialObject(desc)
end)
Workspace.ChildAdded:Connect(function(child)
    if ParryConfig.Enabled then
        HandleProjectile(child)
        HandleSpecialObject(child)
    end
end)
if Workspace:FindFirstChild("IgnoreInstances") then
    Workspace.IgnoreInstances.ChildAdded:Connect(function(child)
        if ParryConfig.Enabled then
            HandleProjectile(child)
            HandleSpecialObject(child)
        end
    end)
end

-- Hook existing players
Players.PlayerAdded:Connect(HookParryPlayer)
for _, p in ipairs(Players:GetPlayers()) do
    HookParryPlayer(p)
end

-- ── Auto Parry UI Controls ────────────────────────────────────────────────────

AutoParryTab:CreateSlider({
    Name         = "Block Timing (ms)",
    Range        = {20, 120},
    Increment    = 1,
    CurrentValue = 50,
    Callback     = function(value)
        ParryConfig.ReactionDelay = value / 1000
        ParryConfig.ExtraDelayAmount = value / 1000
    end,
})

AutoParryTab:CreateToggle({
    Name         = "Auto Parry",
    CurrentValue = false,
    Callback     = function(value)
        ParryConfig.Enabled = value
        if value then
            Rayfield:Notify({ Title = "vanta.dev", Content = "Auto Parry enabled!", Duration = 3, Image = 6031071057 })
        else
            Rayfield:Notify({ Title = "vanta.dev", Content = "Auto Parry disabled.", Duration = 3, Image = 6031071057 })
        end
    end,
})

AutoParryTab:CreateSection("Parry Settings")

AutoParryTab:CreateToggle({
    Name         = "Reblocking",
    CurrentValue = true,
    Callback     = function(v) ParryConfig.Reblocking = v end,
})

AutoParryTab:CreateToggle({
    Name         = "Keep Block (F Key)",
    CurrentValue = true,
    Callback     = function(v) ParryConfig.KeepBlock = v end,
})

AutoParryTab:CreateToggle({
    Name         = "Auto Unblock",
    CurrentValue = true,
    Callback     = function(v) ParryConfig.Unblocking = v end,
})

AutoParryTab:CreateToggle({
    Name         = "Projectile Priority",
    CurrentValue = true,
    Callback     = function(v) ParryConfig.ProjectilesPriority = v end,
})

AutoParryTab:CreateToggle({
    Name         = "Ping Compensation",
    CurrentValue = true,
    Callback     = function(v) ParryConfig.PingCompensation = v end,
})

AutoParryTab:CreateToggle({
    Name         = "Coliseum Mode",
    CurrentValue = false,
    Callback     = function(v) ParryConfig.ColiseumMode = v end,
})

AutoParryTab:CreateSlider({
    Name         = "Block Range (studs)",
    Range        = {5, 100},
    Increment    = 1,
    CurrentValue = 25,
    Callback     = function(v) ParryConfig.BlockRange = v end,
})

AutoParryTab:CreateParagraph({
    Title   = "vanta.dev",
    Content = "Auto Parry listens for attack sounds & animations\nfrom all players and auto-blocks accordingly.",
})
