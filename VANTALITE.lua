local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/scary666-eng/dontudare/refs/heads/main/udray"))()

local Window = Rayfield:CreateWindow({
    Name             = "vanta.dev | Item Farmer",
    LoadingTitle     = "vanta.dev",
    LoadingSubtitle  = "vanta lite",
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

local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player      = Players.LocalPlayer

-- ── Item limits (from reference) ─────────────────────────────────────────────

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

-- ── State ─────────────────────────────────────────────────────────────────────

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

-- ── Helpers ───────────────────────────────────────────────────────────────────

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
    local itemName = typeof(item) == "Instance" and item.Name or item
    local plr = player
    if not plr then return false end
    local instanceToSell
    if typeof(item) == "Instance" then
        instanceToSell = item
    else
        instanceToSell = plr.Backpack:FindFirstChild(item) or (plr.Character and plr.Character:FindFirstChild(item))
    end
    if not instanceToSell or not instanceToSell.Parent then return false end
    local args = {[1] = "EndDialogue", [2] = {["NPC"] = "Merchant", ["Option"] = "Option2", ["Dialogue"] = "Dialogue5"}}
    local fired = false
    if plr.Character then
        local r = plr.Character:FindFirstChildWhichIsA("RemoteEvent")
        if r then pcall(function() r:FireServer(table.unpack(args)) end) fired = true end
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
-- RAYFIELD UI
-- ═════════════════════════════════════════════════════════════════════════════

local FarmTab = Window:CreateTab("Item Farm", 4483362458)

FarmTab:CreateSection("Farm Method")

local farmMethod = "Normal"
FarmTab:CreateDropdown({
    Name   = "Farm Method",
    Options = {"Normal", "AFK"},
    CurrentOption = {"Normal"},
    Callback = function(option)
        farmMethod = option[1] or option
    end,
})

FarmTab:CreateSection("Item Selection")

FarmTab:CreateDropdown({
    Name        = "Items to Farm",
    Options     = itemOptions,
    CurrentOption = {},
    MultipleOptions = true,
    Callback    = function(selected)
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
    Name    = "Travel Method",
    Options = {"Stud", "Tween", "Instant"},
    CurrentOption = {"Stud"},
    Callback = function(option)
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
