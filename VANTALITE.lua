loadstring(game:HttpGet("https://raw.githubusercontent.com/raeth231321343/vanta.dev/refs/heads/main/ui%20startup.lua"))()
wait(2.5)
local WindUI
do
    local ok, result = pcall(function()
        return require("./src/Init")
    end)
    if ok then
        WindUI = result
    else
        WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/weatherwess-lgtm/Azure/refs/heads/main/Gofile"))()
    end
end
WindUI:Notify({
    Title = "vanta.lite loading...",
    Content = "made by scrilisk and kazakori",
    Duration = 3, -- 3 seconds
    Icon = "server-cog",
})
setclipboard("https://discord.gg/DV9xRuMHu")
loadstring(game:HttpGet("https://raw.githubusercontent.com/weatherwess-lgtm/FlyToggle/refs/heads/main/Clipboard"))()
local Window = WindUI:CreateWindow({
    Title = "vanta lite",
    Icon = "case-lower",
    Author = "vanta.lite",
    Folder = "vanta_lite",
    NewElements = true,
    HideSearchBar = false,
    Background = "7048348173",
    BackgroundImageTransparency = 0.5,
    Transparent = false,
    OpenButton = {
        Title = "vanta.lite",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 1.5,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(
            Color3.fromHex("#000000"),
            Color3.fromHex("#ffffff")
        )
    }
})
pcall(function()
    WindUI:AddTheme({
    Name = "scrilisk theme", -- theme name
    
    
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#f5f5f5"), -- Accent
    Outline = Color3.fromHex("#f50565"),
    Text = Color3.fromHex("#3f3f3f"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Button = Color3.fromHex("#e61461"),
    Icon = Color3.fromHex("#fc027f"),
})
WindUI:AddTheme({
    Name = "king crimson", -- theme name
    
    Accent = Color3.fromHex("#18181b"),
    Background = Color3.fromHex("#130f0f"), -- Accent
    Outline = Color3.fromHex("#e61106"),
    Text = Color3.fromHex("#ff1e1e"),
    Placeholder = Color3.fromHex("#313131"),
    Button = Color3.fromHex("#f41111"),
    Icon = Color3.fromHex("#fc0202"),
})
WindUI:AddTheme({
    Name = "kazakori theme", -- theme name
    
    -- example of gradient (available for all values. e.g. Button, Icon, Text...)   --
    Accent = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#f4f4f6"), Transparency = 0 }, 
        ["25"]  = { Color = Color3.fromHex("#a9a8a8"), Transparency = 0 },        
        ["50"]  = { Color = Color3.fromHex("#5f5f5f"), Transparency = 0 },        
        ["75"]  = { Color = Color3.fromHex("#252525"), Transparency = 0 },
        ["100"]   = { Color = Color3.fromHex("#1b1b1d"), Transparency = 0 },        
    }, {                                                                            
        Rotation = 270,                                                               
    }),                                                                             
    
})
WindUI:AddTheme({
    Name = "michaels theme", -- theme name
    Accent = Color3.fromHex("#21b61e"),
    Background = Color3.fromHex("#1d1d1d"), -- Accent
    Outline = Color3.fromHex("#17cc35"),
    Text = Color3.fromHex("#d6d6d6"),
    Placeholder = Color3.fromHex("#252525"),
    Button = Color3.fromHex("#14b84d"),
    Icon = Color3.fromHex("#14e66f"),
      Slider = Color3.fromHex("#3f9453"), -- Button
    SliderThumb = Color3.fromHex("#07c339"), -- White
})
WindUI:SetTheme("kazakori theme")
end)
Window:SetToggleKey(Enum.KeyCode.K)
local function parseJSON(luau_table, indent, level, visited)
    indent = indent or 2
    level = level or 0
    visited = visited or {}
local currentIndent = string.rep(" ", level * indent)
local nextIndent = string.rep(" ", (level + 1) * indent)
if luau_table == nil then
return "null"
end
local dataType = type(luau_table)
if dataType == "table" then
if visited[luau_table] then
return "\"[Circular Reference]\""
end
        visited[luau_table] = true
local isArray = true
local maxIndex = 0
for k, _ in pairs(luau_table) do
if type(k) == "number" and k > maxIndex then
                maxIndex = k
end
if type(k) ~= "number" or k <= 0 or math.floor(k) ~= k then
                isArray = false
break
end
end
local count = 0
for _ in pairs(luau_table) do
            count = count + 1
end
if count ~= maxIndex and isArray then
            isArray = false
end
if count == 0 then
return "{}"
end
if isArray then
if count == 0 then
return "[]"
end
local result = "[\n"
for i = 1, maxIndex do
                result = result .. nextIndent .. parseJSON(luau_table[i], indent, level + 1, visited)
if i < maxIndex then
                    result = result .. ","
end
                result = result .. "\n"
end
            result = result .. currentIndent .. "]"
return result
else
local result = "{\n"
local first = true
local keys = {}
for k in pairs(luau_table) do
                table.insert(keys, k)
end
            table.sort(keys, function(a, b)
if type(a) == type(b) then
return tostring(a) < tostring(b)
else
return type(a) < type(b)
end
end)
for _, k in ipairs(keys) do
local v = luau_table[k]
if not first then
                    result = result .. ",\n"
else
                    first = false
end
if type(k) == "string" then
                    result = result .. nextIndent .. "\"" .. k .. "\": "
else
                    result = result .. nextIndent .. "\"" .. tostring(k) .. "\": "
end
                result = result .. parseJSON(v, indent, level + 1, visited)
end
            result = result .. "\n" .. currentIndent .. "}"
return result
end
elseif dataType == "string" then
local escaped = luau_table:gsub("\\", "\\\\")
        escaped = escaped:gsub("\"", "\\\"")
        escaped = escaped:gsub("\n", "\\n")
        escaped = escaped:gsub("\r", "\\r")
        escaped = escaped:gsub("\t", "\\t")
return "\"" .. escaped .. "\""
elseif dataType == "number" then
return tostring(luau_table)
elseif dataType == "boolean" then
return luau_table and "true" or "false"
elseif dataType == "function" then
return "\"function\""
else
return "\"" .. dataType .. "\""
end
end
local function tableToClipboard(luau_table, indent)
    indent = indent or 4
local jsonString = parseJSON(luau_table, indent)
    setclipboard(jsonString)
return jsonString
end
local AboutTab = Window:Tab({
    Title = "Credits",
    Icon = "star",
})
local AboutSection = AboutTab:Section({
    Title = "Thank You",
})
AboutSection:Section({
    Title = "Thank you for using this script!",
    TextSize = 24,
    FontWeight = Enum.FontWeight.SemiBold,
})
AboutSection:Space()
AboutSection:Section({
    Title = "Credits for vanta lite",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Section({
    Title = "kazakori, scrilisk",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
local FarmingTab = Window:Tab({ Title = "Farming", Icon = "craft:macbook-stroke" })
local StandFarmTab = Window:Tab({ Title = "StandFarm", Icon = "target" })
local SBRTab = Window:Tab({ Title = "SBR", Icon = "chess-knight" })
local SellingTab = Window:Tab({ Title = "Selling", Icon = "dollar-sign" })
local PurchaseTab = Window:Tab({ Title = "Purchase", Icon = "shopping-cart" })
local VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" })
local AdjustTab = Window:Tab({ Title = "Adjust", Icon = "sliders-horizontal" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "zap" })
local LevelFarmTab = Window:Tab({ Title = "Level Farm", Icon = "arrow-up" })
local TrollingTab = Window:Tab({ Title = "Trolling", Icon = "joystick" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local topGui = Instance.new("ScreenGui")
local function notify(title, message)
    title = title or "YBA Script"
    WindUI:Notify({
        Title = title,
        Content = message
    })
end
local items = {}
local maxLimits = {
["Mysterious Arrow"] = 25,
["Rokakaka"] = 25,
["Gold Coin"] = 45,
["Diamond"] = 25,
["Pure Rokakaka"] = 999,
["Quinton's Glove"] = 10,
["Steel Ball"] = 10,
["Rib Cage of The Saint's Corpse"] = 10,
["Zepellin's Headband"] = 10,
["Zeppeli's Hat"] = 10,
["Caesar's Headband"] = 10,
["Clackers"] = 10,
["Stone Mask"] = 10,
["Ancient Scroll"] = 10,
["Dio's Diary"] = 10,
["Lucky Stone Mask"] = 999,
["Lucky Arrow"] = 999,
["Gold Umbrella"] = 999,
["Christmas Present"] = 999
}
local nonSellable = {"Blue Candy", "Red Candy", "Green Candy", "Yellow Candy", "Lucky Arrow", "Lucky Stone Mask", "Christmas Present"}
local itemOptions = {}
local seen = {}
for item in pairs(maxLimits) do
    table.insert(itemOptions, item)
    seen[item] = true
end
for _, candy in ipairs(nonSellable) do
    if not seen[candy] then
        table.insert(itemOptions, candy)
        seen[candy] = true
    end
end
table.sort(itemOptions)
local worthlessItems = {"Gold Coin", "Diamond", "Quinton's Glove", "Zeppeli's Hat", "Caesar's Headband", "Ancient Scroll"}
local function updateItems()
    items = {}
for itemName in pairs(maxLimits) do
        items[itemName] = 0
end
local function countInContainer(container)
if not container then return end
for _, item in pairs(container:GetChildren()) do
if item and item.Name and maxLimits[item.Name] then
                items[item.Name] = (items[item.Name] or 0) + 1
end
end
end
    countInContainer(player.Backpack)
if player.Character then
        countInContainer(player.Character)
end
end
local function findSellRemote()
local plr = game.Players.LocalPlayer
if plr and plr.Character then
for _, obj in pairs(plr.Character:GetChildren()) do
if obj:IsA("RemoteEvent") then
return obj
end
end
end
local places = {game.Workspace, game.ReplicatedStorage, game:GetService("ReplicatedStorage"), game:GetService("Players")}
for _, place in pairs(places) do
if place then
for _, obj in pairs(place:GetDescendants()) do
if obj:IsA("RemoteEvent") and (obj.Name:lower():find("remote") or obj.Name:lower():find("remoteevent") or obj.Name:lower():find("sell") or obj.Name:lower():find("server") or obj.Name:lower():find("_ev")) then
return obj
end
end
end
end
for _, obj in pairs(game.Workspace:GetChildren()) do
if obj:IsA("RemoteEvent") then
return obj
end
end
return nil
end
local function sellItem(item)
if not item then return false end
local itemName = typeof(item) == "Instance" and item.Name or item
if table.find(nonSellable, itemName) then
        notify("YBA Script", "Cannot sell " .. itemName .. " as it is not sellable.")
return false
end
local plr = game.Players.LocalPlayer
if not plr then return false end
local instanceToSell
if typeof(item) == "Instance" then
        instanceToSell = item
elseif typeof(item) == "string" then
        instanceToSell = plr.Backpack:FindFirstChild(item) or (plr.Character and plr.Character:FindFirstChild(item))
else
return false
end
if not instanceToSell or not instanceToSell.Parent then
return false
end
local plrName = plr.Name
local living = game.Workspace:FindFirstChild("Living") or game.Workspace
local target = nil
if living then
        target = living:FindFirstChild(plrName) or living
else
        target = game.Workspace
end
pcall(function()
        instanceToSell.Parent = target
end)
local args = {
[1] = "EndDialogue",
[2] = {
["NPC"] = "Merchant",
["Option"] = "Option2",
["Dialogue"] = "Dialogue5"
}
}
-- Try to find and fire a RemoteEvent safely
local fired = false
local ok, remote = pcall(findSellRemote)
if ok and remote then
pcall(function()
            remote:FireServer(unpack(args))
end)
        fired = true
else
if plr.Character then
local r = plr.Character:FindFirstChildWhichIsA("RemoteEvent")
if r then
pcall(function()
                    r:FireServer(unpack(args))
end)
                fired = true
end
end
end
pcall(function()
if not fired and plr.Character and plr.Character:FindFirstChild("RemoteEvent") then
            plr.Character.RemoteEvent:FireServer(unpack(args))
            fired = true
end
end)
wait(0.12)
return true
end
local function sellAll(itemName)
    updateItems()
local count = items[itemName] or 0
if count == 0 then
        notify("YBA Script", "No " .. itemName .. " found.")
return
end
local sold = 0
while true do
local item = player.Backpack:FindFirstChild(itemName) or (player.Character and player.Character:FindFirstChild(itemName))
if not item then break end
if sellItem(item) then
            sold = sold + 1
else
break
end
end
    notify("YBA Script", "Sold " .. sold .. " " .. itemName .. (sold > 1 and "s" or "") .. ".")
end
local function sellAllSelected(selectedItems)
    updateItems()
local total = 0
for _, itemName in ipairs(selectedItems) do
        total = total + (items[itemName] or 0)
end
if total == 0 then
        notify("YBA Script", "No selected items found.")
return
end
local sold = 0
for _, itemName in ipairs(selectedItems) do
while true do
local item = player.Backpack:FindFirstChild(itemName) or (player.Character and player.Character:FindFirstChild(itemName))
if not item then break end
if sellItem(item) then
                sold = sold + 1
else
break
end
end
end
    notify("YBA Script", "Sold " .. sold .. " selected item" .. (sold > 1 and "s" or "") .. ".")
end
local function sellAllWorthless()
    updateItems()
local total = 0
for _, itemName in ipairs(worthlessItems) do
        total = total + (items[itemName] or 0)
end
if total == 0 then
        notify("YBA Script", "No worthless items found.")
return
end
local sold = 0
for _, itemName in ipairs(worthlessItems) do
while true do
local item = player.Backpack:FindFirstChild(itemName) or (player.Character and player.Character:FindFirstChild(itemName))
if not item then break end
if sellItem(item) then
                sold = sold + 1
else
break
end
end
end
    notify("YBA Script", "Sold " .. sold .. " worthless item" .. (sold > 1 and "s" or "") .. ".")
end
local function sellInventory()
    updateItems()
local sold = 0
for itemName, count in pairs(items) do
if count > 0 and not table.find(nonSellable, itemName) then
while true do
local item = player.Backpack:FindFirstChild(itemName) or (player.Character and player.Character:FindFirstChild(itemName))
if not item then break end
if sellItem(item) then
                    sold = sold + 1
else
break
end
end
end
end
    notify("YBA Script", "Sold " .. sold .. " item" .. (sold > 1 and "s" or "") .. " from inventory.")
end
local autoSellMax = false
local function checkAndSellMax()
local soldSummary = {}
local tempCounts = {}
for name in pairs(maxLimits) do
        tempCounts[name] = 0
end
local containers = {player.Backpack}
if player.Character then
        table.insert(containers, player.Character)
end
for _, container in ipairs(containers) do
local children = container:GetChildren() -- Snapshot
for _, item in ipairs(children) do
local name = item.Name
if maxLimits[name] then
                tempCounts[name] = tempCounts[name] + 1
if (tempCounts[name] >= (maxLimits[name] or 25)) and autoSellMax then
if sellItem(item) then
                        soldSummary[name] = (soldSummary[name] or 0) + 1
end
end
end
end
end
local totalSold = 0
local parts = {}
for name, n in pairs(soldSummary) do
        totalSold = totalSold + n
        table.insert(parts, n .. "x " .. name)
end
if totalSold > 0 then
local msg = "Auto sold: " .. table.concat(parts, ", ")
        notify("YBA Script", msg)
end
end
-- Auto Sell Selected
local autoSellSelected = false
local selectedAutoSellItems = {}
local selectedSellAllItems = {}
local lastAutoSellNotify = {}
player.Backpack.ChildAdded:Connect(function(item)
if autoSellMax then
        checkAndSellMax()
end
if autoSellSelected and table.find(selectedAutoSellItems, item.Name) then
wait(0.2)
local now = tick()
local last = lastAutoSellNotify[item.Name] or 0
if now - last >= 0.5 then
if sellItem(item) then
                notify("YBA Script", "Auto sold " .. item.Name .. " on pickup.")
                lastAutoSellNotify[item.Name] = now
end
end
end
end)
player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(item)
if autoSellMax then
            checkAndSellMax()
end
if autoSellSelected and table.find(selectedAutoSellItems, item.Name) then
wait(0.2)
local now = tick()
local last = lastAutoSellNotify[item.Name] or 0
if now - last >= 0.5 then
if sellItem(item) then
                    notify("YBA Script", "Auto sold " .. item.Name .. " on pickup.")
                    lastAutoSellNotify[item.Name] = now
end
end
end
end)
end)
local noclipEnabled = false
local originalCollides = {}
local noclipConn = nil
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
if not char or not char.Parent then
        noclipEnabled = true
return
end
    originalCollides = {}
    enforceNoclipForCharacter(char)
if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    noclipConn = RunService.Stepped:Connect(function()
local c = player.Character
if not c then return end
for _, p in ipairs(c:GetDescendants()) do
if p:IsA("BasePart") then
if p.CanCollide then p.CanCollide = false end
end
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
local studMultiplier = 1
local tweenMultiplier = 1
local function travelToStud(target)
if not player.Character or not player.Character.HumanoidRootPart then return end
    local hrp = player.Character.HumanoidRootPart
    local targetPos = typeof(target) == "Vector3" and target or target.Position
    local vector = targetPos - hrp.Position
    local length = vector.Magnitude
    local step_size = (afkFarmOn and 5 or 25) * studMultiplier -- Decreased from 30 to 25 for normal farming
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
local effectiveSpeed = 200 * tweenMultiplier
local time = distance / effectiveSpeed
local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end
local function travelToInstant(target)
if not player.Character or not player.Character.HumanoidRootPart then return end
local hrp = player.Character.HumanoidRootPart
local targetPos = typeof(target) == "Vector3" and target or target.Position
local distance = (targetPos - hrp.Position).Magnitude
local effectiveSpeed = 1000 * tweenMultiplier
local time = distance / effectiveSpeed
local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
local tween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
end
local travelMethod = "Stud"
local function travelTo(target)
if travelMethod == "Stud" then
        travelToStud(target)
elseif travelMethod == "Tween" then
        travelToTween(target)
elseif travelMethod == "Instant" then
        travelToInstant(target)
end
end
-- Random TP Functions
local function teleportToRandom()
local map = game.Workspace:FindFirstChild("Map") or game.Workspace
local bounds = {
        minX = -590, maxX = 590,
        minZ = -520, maxZ = 530,
        y = 100
}
local randomX = math.random(bounds.minX, bounds.maxX)
local randomZ = math.random(bounds.minZ, bounds.maxZ)
if not player.Character or not player.Character.HumanoidRootPart then return end
local hrp = player.Character.HumanoidRootPart
    hrp.CFrame = CFrame.new(randomX, bounds.y, randomZ)
end
local function roamToRandom()
local map = game.Workspace:FindFirstChild("Map") or game.Workspace
local bounds = {
        minX = -590, maxX = 590,
        minZ = -520, maxZ = 530,
        y = 100
}
local randomX = math.random(bounds.minX, bounds.maxX)
local randomZ = math.random(bounds.minZ, bounds.maxZ)
local randomPos = Vector3.new(randomX, bounds.y, randomZ)
    travelTo(randomPos)
end
local normalFarmOn = false
local afkFarmOn = false
local selectedFarmItems = {}
local normalCoroutine = nil
local afkCoroutine = nil
local tpDelay = 0.05 -- Default delay
local originalTpDelay = 0.05
local function findNearestItem(selectedItems)
    updateItems() -- Update item counts before searching
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local minDist = math.huge
    local nearest = nil
    for _, v in pairs(game.Workspace.Item_Spawns.Items:GetChildren()) do
        local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
        local proxPrompt = v:FindFirstChild("ProximityPrompt")
        if itemPart and proxPrompt and itemPart.Transparency < 1 then
            local itemName = proxPrompt.ObjectText
            -- Check if item is selected (or all if none selected) and not at max stack
            if (#selectedItems == 0 or table.find(selectedItems, itemName)) and (items[itemName] or 0) < (maxLimits[itemName] or math.huge) then
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
    for _, v in pairs(game.Workspace.Item_Spawns.Items:GetChildren()) do
        local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
        local prox = v:FindFirstChild("ProximityPrompt")
        if itemPart and prox and itemPart.Transparency < 1 and prox.ObjectText == "Lucky Arrow" then
            local dist = (itemPart.Position - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = v
            end
        end
    end
    return nearest
end
local function normalFarm()
while normalFarmOn do
if not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
wait(1)
            continue
end
local foundItem = false
while true do
    local v = findLuckyArrow() or findNearestItem(selectedFarmItems)
    if not v then break end
    foundItem = true
    local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
    local proxPrompt = v:FindFirstChild("ProximityPrompt")
      if instantPickup then
        instantTravelTo(itemPart)
        wait(1) -- Wait 1 second after arriving before picking up
        checkAndSellMax()
        fireproximityprompt(proxPrompt, 0, true)
    else
        travelTo(itemPart)
        wait(0.2)
        local hrp = player.Character.HumanoidRootPart
        if (itemPart.Position - hrp.Position).Magnitude < 5 then
            checkAndSellMax()
            fireproximityprompt(proxPrompt, 4)
            wait(0.1) -- Wait briefly
            if v:IsDescendantOf(game.Workspace) then
                fireproximityprompt(proxPrompt, 4) -- Try again if not picked
            end
        end
    end
    checkAndSellMax()
    wait(0.2) -- Wait after pickup
end
if not foundItem then
    teleportToRandom()
end
wait(0.2)
end
end
local function afkFarm()
while afkFarmOn do
if not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
wait(1)
            continue
end
local roaming = true
while roaming and afkFarmOn do
if not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
break
end
local foundItem = false
local v = findLuckyArrow() or findNearestItem(selectedFarmItems)
if v then
    foundItem = true
    roaming = false
    local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
    local proxPrompt = v:FindFirstChild("ProximityPrompt")
     if instantPickup then
        instantTravelTo(itemPart)
        wait(1) -- Wait 1 second after arriving before picking up
        checkAndSellMax()
        fireproximityprompt(proxPrompt, 0, true)
    else
        travelTo(itemPart)
        wait(0.2)
        local hrp = player.Character.HumanoidRootPart
        if (itemPart.Position - hrp.Position).Magnitude < 5 then
            checkAndSellMax()
            fireproximityprompt(proxPrompt, 4)
            wait(0.1) -- Wait briefly
            if v:IsDescendantOf(game.Workspace) then
                fireproximityprompt(proxPrompt, 4) -- Try again if not picked
            end
        end
    end
    checkAndSellMax()
    roaming = true
end
if not foundItem then
    local hrp = player.Character.HumanoidRootPart
    local currentPos = hrp.Position
    local upPos = Vector3.new(currentPos.X, 100, currentPos.Z)
    travelTo(upPos)
    roamToRandom()
end
wait(0.25) -- Increased from 0.05 to slow down roaming loop
end
end
end
local function startFarming(method)
if method == "Normal" then
        normalFarmOn = true
        normalCoroutine = coroutine.wrap(normalFarm)()
elseif method == "AFK Farming" then
        afkFarmOn = true
        afkCoroutine = coroutine.wrap(afkFarm)()
end
    enableNoclip()
end
local function stopFarming()
    normalFarmOn = false
    afkFarmOn = false
    disableNoclip()
end
player.CharacterAdded:Connect(function(char)
if normalFarmOn or afkFarmOn then
wait(2) -- Wait for full load
        enableNoclip()
if normalFarmOn then
if normalCoroutine then coroutine.close(normalCoroutine) end
            normalCoroutine = coroutine.wrap(normalFarm)()
elseif afkFarmOn then
if afkCoroutine then coroutine.close(afkCoroutine) end
            afkCoroutine = coroutine.wrap(afkFarm)()
end
end
end)
local itemESP = false
local espConnection
local function addItemESP(v)
local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
local prox = v:FindFirstChild("ProximityPrompt")
if itemPart and prox and itemPart.Transparency < 1 then -- Added check
local itemName = prox.ObjectText or "Unknown Item"
if not v:FindFirstChild("ItemESP") then
local hl = Instance.new("Highlight")
            hl.Name = "ItemESP"
            hl.FillTransparency = 0.7
            hl.FillColor = Color3.fromRGB(0, 255, 0)
            hl.OutlineTransparency = 0
            hl.OutlineColor = Color3.fromRGB(255, 0, 0)
            hl.Adornee = v
            hl.Parent = v
end
if not v:FindFirstChild("ItemESPName") then
local bb = Instance.new("BillboardGui")
            bb.Name = "ItemESPName"
            bb.Adornee = itemPart
            bb.Size = UDim2.new(0, 200, 0, 50)
            bb.StudsOffset = Vector3.new(0, 3, 0)
            bb.AlwaysOnTop = true
            bb.Parent = v
local tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0)
            tl.BackgroundTransparency = 1
            tl.Text = itemName
            tl.TextColor3 = Color3.fromRGB(255, 255, 255)
            tl.TextSize = 24
            tl.TextStrokeTransparency = 0.5
            tl.Font = Enum.Font.SourceSansBold
            tl.Parent = bb
end
end
end
local function enableItemESP()
for _, v in pairs(game.Workspace.Item_Spawns.Items:GetChildren()) do
        addItemESP(v)
end
    espConnection = game.Workspace.Item_Spawns.Items.ChildAdded:Connect(function(v)
wait(0.1)
        addItemESP(v)
end)
end
local function disableItemESP()
for _, v in pairs(game.Workspace.Item_Spawns.Items:GetChildren()) do
local hl = v:FindFirstChild("ItemESP")
if hl then
            hl:Destroy()
end
local bb = v:FindFirstChild("ItemESPName")
if bb then
            bb:Destroy()
end
end
if espConnection then
        espConnection:Disconnect()
end
end
-- Player ESP (Red and White)
local playerESP = false
local playerESPConnections = {}
local function addPlayerESP(plr)
if plr == player then return end
if not plr.Character then return end
local char = plr.Character
local hl = Instance.new("Highlight")
    hl.Name = "PlayerESP"
    hl.FillTransparency = 0.7
    hl.FillColor = Color3.fromRGB(255, 0, 0) -- Red fill
    hl.OutlineTransparency = 0
    hl.OutlineColor = Color3.fromRGB(255, 255, 255) -- White outline
    hl.Adornee = char
    hl.Parent = char
local bb = Instance.new("BillboardGui")
    bb.Name = "PlayerESPName"
    bb.Adornee = char:FindFirstChild("Head")
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = char
local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.Text = plr.Name
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.TextSize = 24
    tl.TextStrokeTransparency = 0.5
    tl.Font = Enum.Font.SourceSansBold
    tl.Parent = bb
local conn = plr.CharacterAdded:Connect(function(newChar)
        hl.Adornee = newChar
        bb.Adornee = newChar:WaitForChild("Head")
end)
    table.insert(playerESPConnections, conn)
end
local function enablePlayerESP()
for _, plr in pairs(game.Players:GetPlayers()) do
        addPlayerESP(plr)
end
local addedConn = game.Players.PlayerAdded:Connect(function(plr)
        addPlayerESP(plr)
end)
    table.insert(playerESPConnections, addedConn)
end
local function disablePlayerESP()
for _, plr in pairs(game.Players:GetPlayers()) do
if plr.Character then
local hl = plr.Character:FindFirstChild("PlayerESP")
if hl then
                hl:Destroy()
end
local bb = plr.Character:FindFirstChild("PlayerESPName")
if bb then
                bb:Destroy()
end
end
end
for _, conn in pairs(playerESPConnections) do
        conn:Disconnect()
end
    playerESPConnections = {}
end
local itemNotifier = false
local notifierConnection
local function enableItemNotifier()
    notifierConnection = game.Workspace.Item_Spawns.Items.ChildAdded:Connect(function(v)
wait(0.1)
local prox = v:FindFirstChild("ProximityPrompt")
if prox then
local itemName = prox.ObjectText or "Unknown Item"
            notify("YBA Script", itemName .. " has spawned!")
end
end)
end
local function disableItemNotifier()
if notifierConnection then
        notifierConnection:Disconnect()
end
end
local instantPickup = false
local instantPickupConnection = nil
local defaultHoldDuration = 0.5 -- change if your game uses a different default
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
if prox then
pcall(function() prox.HoldDuration = instant and 0 or defaultHoldDuration end)
end
end
end
local function enableInstantPickup()
    instantPickup = true
    setPromptsInstant(true)
local container = getItemContainer()
if container then
        instantPickupConnection = container.ChildAdded:Connect(function(v)
wait(0.05) -- slight wait so prompt exists
local prox = v:FindFirstChild("ProximityPrompt")
local part = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
if prox and part.Transparency < 1 then -- Added check
pcall(function() prox.HoldDuration = 0 end)
pcall(function() fireproximityprompt(prox, 0) end)
end
end)
end
end
local function disableInstantPickup()
    instantPickup = false
    setPromptsInstant(false)
if instantPickupConnection then
        instantPickupConnection:Disconnect()
        instantPickupConnection = nil
end
end
local function instantTravelTo(target)
if not player.Character or not player.Character.HumanoidRootPart then return end
local hrp = player.Character.HumanoidRootPart
local targetPos = typeof(target) == "Vector3" and target or target.Position
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 0.10, 0)) -- slight offset to avoid stuck
end
local afkCameraOn = false
local originalCameraType = nil
local cameraConnection = nil
local cancelGui = nil
local function enableAFKCamera()
if not (normalFarmOn or afkFarmOn) then
        WindUI:Popup({
                Title = "Warning",
                Icon = "bird",
                Content = "Afk camera only works when farming is enabled",
                Buttons = {
                    {
                        Title = "Ok",
                        Icon = "cat",
                    }
                }
            })
        afkCameraToggle:Set(false)
return
end
    originalCameraType = workspace.CurrentCamera.CameraType
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    cameraConnection = RunService.RenderStepped:Connect(function()
if player.Character and player.Character:FindFirstChild("Head") then
local head = player.Character.Head
local time = tick()
local radius = 10
local height = 15
local angle = time * 0.5
local offset = Vector3.new(math.sin(angle) * radius, height, math.cos(angle) * radius)
local camPos = head.Position + offset
local lookAt = head.Position
workspace.CurrentCamera.CFrame = CFrame.new(camPos, lookAt)
end
end)
    cancelGui = Instance.new("ScreenGui")
    cancelGui.Name = "CancelAFK"
    cancelGui.Parent = player.PlayerGui
    cancelGui.ResetOnSpawn = false
local cancelButton = Instance.new("TextButton")
    cancelButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    cancelButton.BorderSizePixel = 0
    cancelButton.Position = UDim2.new(0.5, -100, 0.9, -50)
    cancelButton.Size = UDim2.new(0, 200, 0, 50)
    cancelButton.Font = Enum.Font.SourceSansBold
    cancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    cancelButton.TextSize = 24
    cancelButton.Text = "Cancel AFK Camera"
    cancelButton.Parent = cancelGui
    cancelButton.MouseButton1Click:Connect(function()
        afkCameraToggle:Set(false)
end)
local uicorner = Instance.new("UICorner")
    uicorner.Parent = cancelButton
end
local function disableAFKCamera()
if originalCameraType then
workspace.CurrentCamera.CameraType = originalCameraType
end
if cameraConnection then
        cameraConnection:Disconnect()
end
if cancelGui then
        cancelGui:Destroy()
end
end
player.CharacterAdded:Connect(function(char)
if afkCameraOn then
wait(1)
-- Camera will update in RenderStepped
end
end)
local farmMethod = "Normal"
FarmingTab:Dropdown({
    Flag = "FarmMethod",
    Title = "Farm Method",
    Values = {"Normal", "AFK Farming"},
    Value = "Normal",
    Callback = function(option)
        farmMethod = option
        if option == "AFK Farming" and travelMethod == "Instant" then
            travelMethod = "Stud"
WindUI:Popup({
                Title = "Warning",
                Icon = "bird",
                Content = "Instant travel not supported for AFK Farming. Switched to Stud",
                Buttons = {
                    {
                        Title = "Ok",
                        Icon = "cat",
                    }
                }
            })
     end
end
})
FarmingTab:Space()
FarmingTab:Dropdown({
    Flag = "FarmItem",
    Title = "Select Item to Farm",
    Values = itemOptions,
    Multi = true,
    Callback = function(selected)
        selectedFarmItems = selected
end
})
FarmingTab:Button({
    Flag = "SelectAllItems",
    Title = "Select All Items",
    Callback = function()
        local all = table.clone(itemOptions)
        selectedFarmItems = all

        -- force both value + UI sync for the FarmItem dropdown
        local synced = false

        -- common WindUI setter (if available)
        pcall(function()
            if Window and Window.SetFlag then
                Window:SetFlag("FarmItem", all)
                synced = true
            end
        end)

        -- fallback: flag object setter
        pcall(function()
            local f = Window and Window.Flags and Window.Flags.FarmItem
            if type(f) == "table" then
                if type(f.Set) == "function" then
                    f:Set(all)
                    synced = true
                elseif type(f.SetValue) == "function" then
                    f:SetValue(all)
                    synced = true
                end
            end
        end)

        -- final fallback: raw flag value
        if not synced then
            pcall(function()
                if Window and Window.Flags then
                    Window.Flags.FarmItem = all
                end
            end)
        end

        WindUI:Notify({
            Title = "YBA Script",
            Content = ("Selected all %d farm items."):format(#all),
            Duration = 3
        })
    end
})
FarmingTab:Space()
FarmingTab:Dropdown({
    Flag = "TravelMethod",
    Title = "Travel Method",
    Values = {"Stud", "Tween", "Instant"},
    Value = "Stud",
    Callback = function(option)
        if option == "Instant" then
            WindUI:Popup({
                Title = "Warning",
                Icon = "bird",
                Content = "Your Executor is not supported you might get kick sometimes :< try using a supported executor",
                Buttons = {
                    {
                        Title = "Ok",
                        Icon = "cat",
                    }
                }
            })
            if farmMethod == "AFK Farming" then
                option = "Stud"
                notify("YBA Script", "Instant travel not supported for AFK Farming. Switched to Stud.")
            end
        end
        travelMethod = option
end
})
FarmingTab:Space()
local tpToItemsToggle = FarmingTab:Toggle({
    Flag = "TpToItems",
    Title = "Enable Farming",
    Default = false,
    Callback = function(value)
local method = farmMethod
        if value then
            notify("YBA Script", method .. " enabled.")
            startFarming(method)
            -- Enable the pad
            if not game.Workspace:FindFirstChild("WhitePad") then
                local pad = Instance.new("Part")
                pad.Size = Vector3.new(10000, 1, 10000)
                pad.Position = Vector3.new(-139.164612, 60.740036, -372.339508)
                pad.Anchored = true
                pad.CanCollide = true
                pad.Color = Color3.fromRGB(255, 255, 255)
                pad.Transparency = 0.95
                pad.Name = "WhitePad"
                pad.Parent = game.Workspace
                if not game.Workspace:FindFirstChild("UnderwhitePad") then
                local pad = Instance.new("Part")
                pad.Size = Vector3.new(10000, 1, 10000)
                pad.Position = Vector3.new(0, -45, 0)
                pad.Anchored = true
                pad.Color = Color3.fromRGB(255, 255, 255)
                pad.Transparency = 0.5
                pad.Name = "UnderwhitePad"
                pad.Parent = game.Workspace
            end
            end
        else
            notify("YBA Script", "Farming disabled.")
            stopFarming()
            -- Disable the pad
            local pad = game.Workspace:FindFirstChild("WhitePad")
            if pad then
                pad:Destroy()
                local underPad = game.Workspace:FindFirstChild("UnderwhitePad")
            if underPad then
                underPad:Destroy()
            end
            end
        end
    end
})
FarmingTab:Space()
FarmingTab:Section({
    Title = "Gamble",
})
local gambleOn = false
local lastGambleTime = 0
local gambleToggle = FarmingTab:Toggle({
    Flag = "Gamble",
    Title = "Enable",
    Default = false,
    Callback = function(value)
        gambleOn = value
        if value then
            notify("YBA Script", "Auto Gamble enabled.")
        else
            notify("YBA Script", "Auto Gamble disabled.")
        end
    end
})
spawn(function()
    while true do
        wait(0.5)
        if gambleOn then
            pcall(function()
                local hasGold = false
                local goldItem = player.Backpack:FindFirstChild("Gold Coin") or (player.Character and player.Character:FindFirstChild("Gold Coin"))
                if goldItem then
                    hasGold = true
                    if goldItem.Parent == player.Backpack then
                        goldItem.Parent = player.Character
                    end
                end
                local money = player.PlayerStats.Money.Value
                if hasGold and money >= 750 then
                    local remote = player.Character:FindFirstChild("RemoteEvent")
                    if remote then
                        remote:FireServer("DialogueInteracted", {
                            ["DialogueName"] = "Item Machine",
                            ["Speaker"] = "Item Machine"
                        })
                        remote:FireServer("EndDialogue", {
                            ["NPC"] = "Item Machine",
                            ["Option"] = "Option1",
                            ["Dialogue"] = "Dialogue1"
                        })
                        lastGambleTime = tick()
                    end
                    wait(3)
                end
            end)
        end
    end
end)
local autoSellMaxToggle = SellingTab:Toggle({
    Flag = "AutoSellMax",
    Title = "Auto Sell on Max",
    Default = false,
    Callback = function(value)
        autoSellMax = value
if autoSellMax then
            notify("YBA Script", "Auto Sell on Max enabled.")
            checkAndSellMax()
else
            notify("YBA Script", "Auto Sell on Max disabled.")
end
end
})
SellingTab:Space()
SellingTab:Dropdown({
    Flag = "AutoSellItems",
    Title = "Auto Sell Items (on Pickup)",
    Values = itemOptions,
    Multi = true,
    Callback = function(selected)
        selectedAutoSellItems = selected
end
})
SellingTab:Space()
local autoSellSelectedToggle = SellingTab:Toggle({
    Flag = "AutoSellSelected",
    Title = "Auto Sell Selected on Pickup",
    Default = false,
    Callback = function(value)
        autoSellSelected = value
if autoSellSelected then
            notify("YBA Script", "Auto Sell Selected enabled.")
else
            notify("YBA Script", "Auto Sell Selected disabled.")
end
end
})
SellingTab:Button({
    Title = "Select all for Auto Sell",
    Callback = function()
        local all = table.clone(itemOptions)
        selectedAutoSellItems = all
        -- force both value + UI sync for the AutoSellItems dropdown
        local synced = false
        -- common WindUI setter (if available)
        pcall(function()
            if Window and Window.SetFlag then
                Window:SetFlag("AutoSellItems", all)
                synced = true
            end
        end)
        -- fallback: flag object setter
        pcall(function()
            local f = Window and Window.Flags and Window.Flags.AutoSellItems
            if type(f) == "table" then
                if type(f.Set) == "function" then
                    f:Set(all)
                    synced = true
                elseif type(f.SetValue) == "function" then
                    f:SetValue(all)
                    synced = true
                end
            end
        end)
        -- final fallback: raw flag value
        if not synced then
            pcall(function()
                if Window and Window.Flags then 
                    Window.Flags.AutoSellItems = all
                end
            end)
        end
        WindUI:Notify({
            Title = "YBA Script",
            Content = ("Selected all %d items for Auto Sell."):format(#all),
            Duration = 3
        })
    end
})
SellingTab:Space()
SellingTab:Dropdown({
    Flag = "SellAllItems",
    Title = "Select Items to Sell All Now",
    Values = itemOptions,
    Multi = true,
    Callback = function(selected)
        selectedSellAllItems = selected
end
})
SellingTab:Space()
SellingTab:Button({
    Title = "Sell All Selected Now",
    Callback = function()
        sellAllSelected(selectedSellAllItems)
end
})
SellingTab:Space()
SellingTab:Button({
    Title = "Sell All Worthless Items",
    Callback = function()
        sellAllWorthless()
end
})
SellingTab:Space()
SellingTab:Button({
    Title = "Sell Inventory",
    Callback = function()
        sellInventory()
end
})
local itemESPToggle = VisualTab:Toggle({
    Flag = "ItemESP",
    Title = "Item ESP",
    Default = false,
    Callback = function(value)
        itemESP = value
if itemESP then
            notify("YBA Script", "Item ESP enabled.")
            enableItemESP()
else
            notify("YBA Script", "Item ESP disabled.")
            disableItemESP()
end
end
})
VisualTab:Space()
local playerESPToggle = VisualTab:Toggle({
    Flag = "PlayerESP",
    Title = "Player ESP",
    Default = false,
    Callback = function(value)
        playerESP = value
if playerESP then
            notify("YBA Script", "Player ESP enabled.")
            enablePlayerESP()
else
            notify("YBA Script", "Player ESP disabled.")
            disablePlayerESP()
end
end
})
VisualTab:Space()
local itemNotifierToggle = VisualTab:Toggle({
    Flag = "ItemNotifier",
    Title = "Item Spawn Notifier",
    Default = false,
    Callback = function(value)
        itemNotifier = value
if itemNotifier then
            notify("YBA Script", "Item Spawn Notifier enabled.")
            enableItemNotifier()
else
            notify("YBA Script", "Item Spawn Notifier disabled.")
            disableItemNotifier()
end
end
})
AdjustTab:Section({
    Title = "Stud"
})
AdjustTab:Slider({
    Title = "Stud Speed Adjustment (%)",
    Step = 1,
    Value = {
        Min = 0,
        Max = 200,
        Default = 100
    },
    Callback = function(value)
        studMultiplier = value / 100
    end
})
AdjustTab:Section({
    Title = "Tween"
})
AdjustTab:Slider({
    Title = "Tween Speed Adjustment (%)",
    Step = 1,
    Value = {
        Min = 0,
        Max = 200,
        Default = 100
    },
    Callback = function(value)
        tweenMultiplier = value / 100
    end
})
local antiAFKToggle = MiscTab:Toggle({
    Flag = "AntiAFK",
    Title = "Anti-AFK",
    Default = false,
    Callback = function(value)
if value then
            notify("YBA Script", "Anti-AFK enabled.")
spawn(function()
while value do
wait(300)
local vu = game:GetService("VirtualUser")
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
end
end)
else
            notify("YBA Script", "Anti-AFK disabled.")
end
end
})
MiscTab:Space()
local originalLighting = {
    Brightness = game.Lighting.Brightness,
    ClockTime = game.Lighting.ClockTime,
    FogEnd = game.Lighting.FogEnd,
    GlobalShadows = game.Lighting.GlobalShadows,
    Ambient = game.Lighting.Ambient
}
local fpsBoosterToggle = MiscTab:Toggle({
    Flag = "FpsBooster",
    Title = "FPS Booster",
    Default = false,
    Callback = function(value)
if value then
            notify("YBA Script", "FPS Booster enabled.")
local lighting = game.Lighting
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
-- Remove highlights (assuming disabling all Highlight instances in workspace)
for _, obj in pairs(game.Workspace:GetDescendants()) do
if obj:IsA("Highlight") then
                    obj.Enabled = false
end
end
if game.Lighting:FindFirstChild("Bloom") then
game.Lighting.Bloom.Enabled = false
end
if game.Lighting:FindFirstChild("SunRays") then
game.Lighting.SunRays.Enabled = false
end
if game.Lighting:FindFirstChild("DepthOfField") then
game.Lighting.DepthOfField.Enabled = false
end
else
            notify("YBA Script", "FPS Booster disabled.")
local lighting = game.Lighting
            lighting.Brightness = originalLighting.Brightness
            lighting.ClockTime = originalLighting.ClockTime
            lighting.FogEnd = originalLighting.FogEnd
            lighting.GlobalShadows = originalLighting.GlobalShadows
            lighting.Ambient = originalLighting.Ambient
for _, obj in pairs(game.Workspace:GetDescendants()) do
if obj:IsA("Highlight") then
                    obj.Enabled = true
end
end
if game.Lighting:FindFirstChild("Bloom") then
game.Lighting.Bloom.Enabled = true
end
if game.Lighting:FindFirstChild("SunRays") then
game.Lighting.SunRays.Enabled = true
end
if game.Lighting:FindFirstChild("DepthOfField") then
game.Lighting.DepthOfField.Enabled = true
end
end
end
})
MiscTab:Space()
local instantPickupToggle = MiscTab:Toggle({
    Flag = "InstantPickup",
    Title = "Instant Pick Up",
    Default = false,
    Callback = function(value)
if value then
            enableInstantPickup()
            notify("YBA Script", "Instant Pick Up enabled.")
else
            disableInstantPickup()
            notify("YBA Script", "Instant Pick Up disabled.")
end
end
})
MiscTab:Space()
local afkCameraToggle = MiscTab:Toggle({
    Flag = "AFKCamera",
    Title = "AFK Camera",
    Default = false,
    Callback = function(value)
        afkCameraOn = value
if value then
            notify("YBA Script", "AFK Camera enabled.")
            enableAFKCamera()
else
            notify("YBA Script", "AFK Camera disabled.")
            disableAFKCamera()
end
end
})
MiscTab:Space()
local selectedSoundItems = {}
MiscTab:Dropdown({
    Flag = "SoundItem",
    Title = "Select Item for Sound",
    Values = itemOptions,
    Multi = true,
    Callback = function(selected)
        selectedSoundItems = selected
    end
})
MiscTab:Space()
local soundNotifier = false
local soundNotifierConnection
local function enableSoundNotifier()
    soundNotifierConnection = game.Workspace.Item_Spawns.Items.ChildAdded:Connect(function(v)
        wait(0.1)
        local prox = v:FindFirstChild("ProximityPrompt")
        if prox and table.find(selectedSoundItems, prox.ObjectText) then
            local sound = Instance.new("Sound")
            sound.SoundId = "rbxassetid://4590657391" -- ting sound
            sound.Volume = 1
            sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
            sound:Play()
            sound.Ended:Connect(function()
                sound:Destroy()
            end)
        end
    end)
end
local function disableSoundNotifier()
    if soundNotifierConnection then
        soundNotifierConnection:Disconnect()
    end
end
local soundNotifierToggle = MiscTab:Toggle({
    Flag = "SoundNotifier",
    Title = "Sound Notifier",
    Default = false,
    Callback = function(value)
        soundNotifier = value
        if value then
            notify("YBA Script", "Sound Notifier enabled for selected items")
            enableSoundNotifier()
        else
            notify("YBA Script", "Sound Notifier disabled.")
            disableSoundNotifier()
        end
    end
})
getgenv().TWOHFarmEnabled = false
getgenv().TWOHFarmConnection = nil
getgenv().TWOHCleanupFunctions = {}

MiscTab:Section({
    Title = "Player Farm",
})

local viewToggle2 = MiscTab:Toggle({
    Flag = "ViewStandMisc",
    Title = "View Stand",
    Locked = true,
    LockedTitle = "USE ONE UNDER TROLLING TAB (VIEW STAND)",
    Default = false,
    Callback = function(value)
        viewEnabled = value
        if viewToggle then pcall(function() viewToggle:Set(value) end) end
        if value then
            local stand = getStand()
            if not stand then
                notify("View Stand", "Equipt your stand first")
                return
            end
            enableView(stand)
        else
            disableView()
        end
    end
})

MiscTab:Space()

getgenv().SelectedHuntTarget = ""
getgenv().GetPlayerList = function()
    local playerNames = {}
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(playerNames, p.Name)
        end
    end
    return playerNames
end

MiscTab:Input({
    Flag = "TWOHPlayerSelect",
    Title = "Enter Player Name to Hunt",
    Placeholder = "Type exact username...",
    Callback = function(selected)
        if not selected or selected == "" then
            getgenv().TWOHFarmEnabled = false
            return
        end
        
        getgenv().SelectedHuntTarget = selected
        
        local targetPlayer = game:GetService("Players"):FindFirstChild(selected)
        if targetPlayer and targetPlayer.Character then
            notify("YBA Script", "Target set to: " .. selected)
            
            -- Clear previous cleanup functions
            for _, cleanupFunc in pairs(getgenv().TWOHCleanupFunctions) do
                pcall(cleanupFunc)
            end
            getgenv().TWOHCleanupFunctions = {}
            
            -- Auto start TWOH farm
            getgenv().TWOHFarmEnabled = true
            
            local noclipEnabled = false
            local noclipConn = nil
            local bp = nil
            local bg = nil
            local standBp = nil
            local standBg = nil
            local RunService = game:GetService("RunService")
            local originalPos = nil
            
            local function enableNoclip()
                if noclipEnabled then return end
                local char = game.Players.LocalPlayer.Character
                if not char then return end
                
                noclipConn = RunService.Stepped:Connect(function()
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end)
                noclipEnabled = true
            end
            
            local function disableNoclip()
                if noclipConn then
                    noclipConn:Disconnect()
                    noclipConn = nil
                end
                noclipEnabled = false
            end
            
            local function teleportAboveGround()
                local myChar = game.Players.LocalPlayer.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local hrp = myChar.HumanoidRootPart
                    local targetLoc = originalPos or hrp.CFrame
                    hrp.CFrame = targetLoc + Vector3.new(0, 10, 0)
                    task.wait(0.1)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                end
            end
            
            local function cleanup()
                disableNoclip()
                pcall(function()
                    if bp then bp:Destroy() bp = nil end
                    if bg then bg:Destroy() bg = nil end
                    if standBp then standBp:Destroy() standBp = nil end
                    if standBg then standBg:Destroy() standBg = nil end
                end)
                task.wait(0.2)
                teleportAboveGround()
                task.wait(0.2)
            end
            
            table.insert(getgenv().TWOHCleanupFunctions, cleanup)
            
            task.spawn(function()
                while getgenv().TWOHFarmEnabled do
                    task.wait()
                    
                    local targetPlayer = game:GetService("Players"):FindFirstChild(selected)
                    if not targetPlayer or not targetPlayer.Character then
                        notify("YBA Script", "Target player not found!")
                        getgenv().TWOHFarmEnabled = false
                        cleanup()
                        break
                    end
                    
                    local myChar = game.Players.LocalPlayer.Character
                    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.CharacterAdded:Wait()
                        task.wait(0.5)
                        originalPos = nil
                        continue
                    end
                    
                    if not originalPos then
                        originalPos = myChar.HumanoidRootPart.CFrame
                    end
                    
                    local targetChar = targetPlayer.Character
                    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                    local targetHum = targetChar:FindFirstChildWhichIsA("Humanoid")
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    local myRemote = myChar:FindFirstChild("RemoteEvent")
                    local myStandMorph = myChar:FindFirstChild("StandMorph")
                    
                    if not targetHRP or not targetHum or targetHum.Health <= 0 then
                        notify("YBA Script", "Target is dead or invalid!")
                        getgenv().TWOHFarmEnabled = false
                        cleanup()
                        break
                    end
                    
                    enableNoclip()
                    
                    local undergroundOffset = -25
                    local targetCFrame = targetHRP.CFrame + Vector3.new(0, undergroundOffset, 0)
                    
                    if myChar.PrimaryPart then
                        if not bp or bp.Parent ~= myChar.PrimaryPart then
                            bp = Instance.new("BodyPosition")
                            bp.Position = targetCFrame.Position
                            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            bp.P = 10000
                            bp.D = 100
                            bp.Parent = myChar.PrimaryPart
                        else
                            bp.Position = targetCFrame.Position
                        end
                        
                        if not bg or bg.Parent ~= myChar.PrimaryPart then
                            bg = Instance.new("BodyGyro")
                            bg.CFrame = targetCFrame
                            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            bg.P = 10000
                            bg.D = 100
                            bg.Parent = myChar.PrimaryPart
                        else
                            bg.CFrame = targetCFrame
                        end
                        
                        myChar.PrimaryPart.CFrame = targetCFrame
                        myChar.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        myChar.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
                    end
                    
                    if myStandMorph and myStandMorph.PrimaryPart then
                        local standRoot = myStandMorph.PrimaryPart
                        local standTargetCFrame = targetHRP.CFrame - targetHRP.CFrame.LookVector * 1.1
                        
                        if not standBp or standBp.Parent ~= standRoot then
                            standBp = Instance.new("BodyPosition")
                            standBp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                            standBp.P = 10000
                            standBp.D = 100
                            standBp.Parent = standRoot
                        end
                        standBp.Position = standTargetCFrame.Position
                        
                        if not standBg or standBg.Parent ~= standRoot then
                            standBg = Instance.new("BodyGyro")
                            standBg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                            standBg.P = 10000
                            standBg.D = 100
                            standBg.Parent = standRoot
                        end
                        standBg.CFrame = standTargetCFrame
                        
                        standRoot.CFrame = standTargetCFrame
                        standRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                    
                    if myRemote then
                        pcall(function()
                            myRemote:FireServer("HoldAttack", {Bool = true, Type = "m1"})
                            myRemote:FireServer("HoldAttack", {Bool = false, Type = "m1"})
                        end)
                    end
                    
                    task.wait(0.1)
                end
            end)
        end
    end
})

MiscTab:Space()

MiscTab:Button({
    Title = "Stop Player Farming",
    Callback = function()
        getgenv().TWOHFarmEnabled = false
        notify("YBA Script", "Player farming stopped!")
        for _, cleanupFunc in pairs(getgenv().TWOHCleanupFunctions) do
            task.spawn(cleanupFunc)
        end
        getgenv().TWOHCleanupFunctions = {}
        task.wait(0.5)
    end
})

do
    local VirtualInputManager = game:GetService("VirtualInputManager")

    getgenv().AutoPressKey = getgenv().AutoPressKey or nil
    getgenv().AutoPressSpamDelay = getgenv().AutoPressSpamDelay or 0.03
    getgenv().AutoPressLoopToken = (getgenv().AutoPressLoopToken or 0) + 1

    local function tapSelectedKey()
        local keyName = getgenv().AutoPressKey
        if not keyName then return end

        local keyCode = Enum.KeyCode[keyName]
        if not keyCode then return end

        VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.01)
        VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
    end

    getgenv().startAutoPressLoop = function()
        getgenv().AutoPressLoopToken = getgenv().AutoPressLoopToken + 1
        local myToken = getgenv().AutoPressLoopToken

        task.spawn(function()
            while myToken == getgenv().AutoPressLoopToken do
                if getgenv().TWOHFarmEnabled and getgenv().AutoPressKey then
                    pcall(tapSelectedKey)
                    task.wait(getgenv().AutoPressSpamDelay) -- spam speed
                else
                    task.wait(0.1)
                end
            end
        end)
    end

    startAutoPressLoop()

    MiscTab:Dropdown({
        Flag = "AutoPressKeys",
        Title = "Auto Press Keys for Block Breaker",
        Values = { "None", "E", "Q", "R", "F", "G", "H", "T", "Y", "U", "I", "O", "P", "Z", "X", "C", "V", "B", "N", "M" },
        Value = "None",
        Callback = function(selected)
            if selected == "None" then
                getgenv().AutoPressKey = nil
                notify("YBA Script", "Auto key spam disabled.")
            else
                getgenv().AutoPressKey = selected
                notify("YBA Script", "Auto key spam set to: " .. selected)
            end
        end
    })

    MiscTab:Slider({
        Flag = "AutoPressSpamDelay",
        Title = "Key Spam Delay (sec)",
        Step = 0.01,
        Value = {
            Min = 0.01,
            Max = 0.5,
            Default = 0.03
        },
        Callback = function(v)
            getgenv().AutoPressSpamDelay = v
        end
    })
end


MiscTab:Space()
MiscTab:Section({
    Title = "Hamon",
})
do
    getgenv().VIM = game:GetService("VirtualInputManager")
    getgenv().UIS = game:GetService("UserInputService")

    getgenv().AutoHamonCharge = getgenv().AutoHamonCharge or false
    getgenv().AutoHamonChargeToken = getgenv().AutoHamonChargeToken or 0
    getgenv().holdingL = getgenv().holdingL or false
    getgenv().HamonRebindTick = getgenv().HamonRebindTick or 0
    getgenv().HamonChargeInterval = getgenv().HamonChargeInterval or 7.5
    getgenv().HamonHoldDuration = getgenv().HamonHoldDuration or 2.25
    getgenv().HamonLastBind = getgenv().HamonLastBind or 0

    getgenv().forceHamonBindL = function()
        getgenv()._char = game.Players.LocalPlayer.Character
        getgenv()._rf = getgenv()._char and getgenv()._char:FindFirstChild("RemoteFunction")
        if not getgenv()._rf then return end

        pcall(function()
            getgenv()._rf:InvokeServer("AssignSkillKey", {
                Type = "Character",
                Key = "Enum.KeyCode.L",
                Skill = "Hamon Breathing"
            })
        end)

        pcall(function()
            getgenv()._rf:InvokeServer("AssignSkillKey", {
                Type = "Stand",
                Key = "Enum.KeyCode.L",
                Skill = "Hamon Breathing"
            })
        end)
    end

    getgenv().holdL = function()
        if getgenv().holdingL or getgenv().UIS:GetFocusedTextBox() then return end
        getgenv().VIM:SendKeyEvent(true, Enum.KeyCode.L, false, game)
        getgenv().holdingL = true
    end

    getgenv().releaseL = function()
        if not getgenv().holdingL then return end
        getgenv().VIM:SendKeyEvent(false, Enum.KeyCode.L, false, game)
        getgenv().holdingL = false
    end

    MiscTab:Toggle({
        Flag = "HamonCharge",
        Title = "Auto Hamon Charge",
        Default = false,
        Callback = function(state)
            getgenv().AutoHamonCharge = state
            getgenv().AutoHamonChargeToken = getgenv().AutoHamonChargeToken + 1
            getgenv().AutoHamonChargeThreadToken = getgenv().AutoHamonChargeToken

            if state then
                getgenv().forceHamonBindL()
                getgenv().HamonLastBind = tick()
                notify("YBA Script", "Auto Hamon Charge enabled. Charging to max every 7.5s.")
                task.spawn(function()
                    while getgenv().AutoHamonCharge and getgenv().AutoHamonChargeThreadToken == getgenv().AutoHamonChargeToken do
                        if game.Players.LocalPlayer.Character
                            and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                            and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").Health > 0 then

                            if tick() - getgenv().HamonLastBind >= 10 then
                                getgenv().forceHamonBindL()
                                getgenv().HamonLastBind = tick()
                            end

                            getgenv().holdL()
                            task.wait(getgenv().HamonHoldDuration)
                            getgenv().releaseL()
                            task.wait(getgenv().HamonChargeInterval)
                        else
                            getgenv().releaseL()
                            task.wait(0.25)
                        end
                    end
                    getgenv().releaseL()
                end)
            else
                getgenv().releaseL()
                notify("YBA Script", "Auto Hamon Charge disabled.")
            end
        end,
    })
end
MiscTab:Button({
    Title = "Open Jesus Dialogue",
    Callback = function()
        local remote = player.Character and player.Character:FindFirstChild("RemoteEvent")
        if remote then
            remote:FireServer("PromptTriggered", game.ReplicatedStorage.NewDialogue.Jesus)
            notify("YBA Script", "Opened Jesus dialogue.")
        else
            notify("YBA Script", "RemoteEvent not found.")
        end
    end
})
MiscTab:Button({
    Title = "Anti Vamp Burn",
    Callback = function()
        spawn(function()
            repeat wait() until game:IsLoaded()
            local plr = game:GetService("Players").LocalPlayer;
            while wait() do pcall(function()
                if plr then
                    game:GetService("Players").LocalPlayer.PlayerStats.Race.Value = "Human"
                end
            end )
            end
        end)
        notify("YBA Script", "Anti Vamp Burn enabled.")
    end
})
--// Infinite Dash Script for YBA (Standalone)
--// Dependencies
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
--// Minimal Xenon Utils
local Xenon = {Utils = {}}
Xenon.Utils.__index = Xenon.Utils
function Xenon.Utils.MakeUtilController()
    local Utils = {
        Tasks = {};
        Ints = {};
        States = {};
    }
    return setmetatable(Utils, Xenon.Utils)
end
function Xenon.Utils:SetInt(Value, NewValue)
    if self.Ints[Value] then
        self.Ints[Value].Value = NewValue
    end
end
function Xenon.Utils:GetInt(Value)
    return self.Ints[Value] and self.Ints[Value].Value or 0
end
function Xenon.Utils:SetState(Value, NewValue)
    if self.States[Value] then
        self.States[Value].Value = NewValue
    end
end
function Xenon.Utils:GetState(Value)
    return self.States[Value] and self.States[Value].Value or false
end
function Xenon.Utils:AddTask(TaskName, Task)
    if not self.Tasks[TaskName] then
        self.Tasks[TaskName] = Task
    end
    return Task
end
function Xenon.Utils:DisconnectTask(TaskName)
    if self.Tasks[TaskName] and self.Tasks[TaskName].Connected then
        self.Tasks[TaskName]:Disconnect()
        self.Tasks[TaskName] = nil
    end
end
function Xenon.Utils:GetPlayer()
    return LocalPlayer
end
function Xenon.Utils:GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
function Xenon.Utils:GetHumanoid()
    local Character = self:GetCharacter()
    return Character and Character:FindFirstChildWhichIsA("Humanoid")
end
function Xenon.Utils:GetHRP()
    local Character = self:GetCharacter()
    return Character and Character:FindFirstChild("HumanoidRootPart")
end
function Xenon.Utils:GetStroke()
    local StrokeDir = 180
    local Anim = "6926086304"
  
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        StrokeDir = 90
        Anim = "6926086567"
    elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
        StrokeDir = -90
        Anim = "6926086883"
    elseif UserInputService:IsKeyDown(Enum.KeyCode.W) then
        StrokeDir = 0
        Anim = "6926086032"
    end
  
    return StrokeDir, Anim
end
--// Initialize Util
local Util = Xenon.Utils.MakeUtilController()
--// Initialize values
Util.Ints = {
    ["InfTick"] = {Value = tick()},
    ["InfDelay"] = {Value = 1},
    ["DashPower"] = {Value = 50}
}
Util.States = {
    ["Infinite Dash"] = {Value = false}
}
--// Create DashAnims folder ONCE outside the toggle
local DashAnims = Instance.new("Folder", workspace)
DashAnims.Name = "DashAnims_" .. Util:GetPlayer().UserId
--// UI Section (assuming MiscTab is defined elsewhere)
MiscTab:Section({
    Title = "Infinite Dash",
})
local infiniteDashToggle = MiscTab:Toggle({
    Flag = "InfiniteDash",
    Title = "Infinite Dash",
    Default = false,
    Callback = function(State)
        Util:SetState("Infinite Dash", State)
      
        if State then
            -- Enable infinite dash
            local conn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
                if GameProcessed then return end
              
                local dashKey = Util:GetPlayer().PlayerStats.DashKey.Value
                if Input.KeyCode == Enum.KeyCode[dashKey] and (tick() - Util:GetInt("InfTick")) >= Util:GetInt("InfDelay") then
                    Util:SetInt("InfTick", tick())
                  
                    -- Get humanoid and HRP with proper nil checks
                    local humanoid = Util:GetHumanoid()
                    local hrp = Util:GetHRP()
                    if not humanoid or not hrp then return end
                  
                    local Dir, AnimID = Util:GetStroke()
                  
                    -- Create and play animation
                    local anim = Instance.new("Animation")
                    anim.Name = "YBA_AntiCheat_Bypass_REAL"
                    anim.AnimationId = "rbxassetid://" .. AnimID
                    anim.Parent = DashAnims
                  
                    local track = humanoid:LoadAnimation(anim)
                    track:Play()
                  
                    -- Create BodyVelocity
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = (hrp.CFrame * CFrame.Angles(0, math.rad(Dir), 0)).lookVector * Util:GetInt("DashPower")
                    bv.MaxForce = Vector3.new(55555, 1000, 55555)
                    bv.Parent = hrp
                  
                    Debris:AddItem(bv, 0.25)
                end
            end)
          
            Util:AddTask("InfDash", conn)
        notify("YBA Script", "Infinite Dash: Enabled.")
        else
            -- Disable infinite dash
            Util:DisconnectTask("InfDash")
          
            -- Clean up animations
            for _, v in pairs(DashAnims:GetChildren()) do
                v:Destroy()
            end
          
        notify("YBA Script", "Infinite Dash: Disabled.")
        end
    end
})
MiscTab:Slider({
    Title = "Dash Power",
    Step = 1,
    Value = {Min=10, Max=1000, Default=50},
    Callback = function(Value)
        Util:SetInt("DashPower", math.clamp(Value, 10, 1000))
    end
})
MiscTab:Slider({
    Title = "Dash Delay",
    Step = 0.1,
    Value = {Min=0, Max=3.5, Default=1},
    Callback = function(Value)
        Util:SetInt("InfDelay", math.clamp(Value, 0, 3.5))
    end
})

-- Use a dedicated section as the container for interactive controls
getgenv().PurchaseSection = PurchaseTab:Section({
    Title = "Purchase Items"
})

PurchaseTab:Section({
    Title = "Buy Max Of (1 purchase/sec, prefers 5x when available):",
})

-- Uses PurchaseShopItem routing (same style as your working Pure Rokakaka example)
getgenv().purchaseData = {
    ["Lucky Arrow"] = {
        one  = {ItemName = "1x Lucky Arrow", ShopPage = 1, ShopSlot = 1},
    },
    ["Mysterious Arrow"] = {
        five = {ItemName = "5x Mysterious Arrow", ShopPage = 1, ShopSlot = 4},
        one  = {ItemName = "1x Mysterious Arrow", ShopPage = 1, ShopSlot = 3},
    },
    ["Rokakaka"] = {
        five = {ItemName = "5x Rokakaka", ShopPage = 1, ShopSlot = 6},
        one  = {ItemName = "1x Rokakaka", ShopPage = 1, ShopSlot = 5},
    },
    ["Dio's Diary"] = {
        one  = {ItemName = "1x Dio's Diary", ShopPage = 1, ShopSlot = 8},
    },
    ["Heart of The Saint's Corpse"] = {
        one  = {ItemName = "1x Heart of The Saint's Corpse", ShopPage = 1, ShopSlot = 9},
    },
    ["Pelvis of The Saint's Corpse"] = {
        one  = {ItemName = "1x Pelvis of The Saint's Corpse", ShopPage = 1, ShopSlot = 10},
    },
    ["Left Arm of the Saint's Corpse"] = {
        one  = {ItemName = "1x Left Arm of the Saint's Corpse", ShopPage = 1, ShopSlot = 11},
    },
    ["Rib Cage of The Saint's Corpse"] = {
        five = {ItemName = "5x Rib Cage of The Saint's Corpse", ShopPage = 1, ShopSlot = 13},
        one  = {ItemName = "1x Rib Cage of The Saint's Corpse", ShopPage = 1, ShopSlot = 12},
    },
    ["Pure Rokakaka"] = {
        one  = {ItemName = "1x Pure Rokakaka", ShopPage = 1, ShopSlot = 2},
    },
}

getgenv().purchasableItems = {}
for k in pairs(getgenv().purchaseData) do
    table.insert(getgenv().purchasableItems, k)
end
table.sort(getgenv().purchasableItems)

getgenv().selectedPurchaseItems = getgenv().selectedPurchaseItems or {}
getgenv().purchaseRunning = getgenv().purchaseRunning or false
getgenv().fallbackCaps = getgenv().fallbackCaps or {
    ["Heart of The Saint's Corpse"] = 10,
    ["Pelvis of The Saint's Corpse"] = 10,
    ["Left Arm of the Saint's Corpse"] = 10,
}

getgenv().normalizeMultiSelection = function(selected)
    getgenv().out = {}
    if type(selected) ~= "table" then
        return getgenv().out
    end

    if #selected > 0 then
        for _, v in ipairs(selected) do
            if type(v) == "string" then
                table.insert(getgenv().out, v)
            end
        end
    else
        for k, v in pairs(selected) do
            if v == true and type(k) == "string" then
                table.insert(getgenv().out, k)
            elseif type(k) == "number" and type(v) == "string" then
                table.insert(getgenv().out, v)
            end
        end
    end

    table.sort(getgenv().out)
    return getgenv().out
end

getgenv().PurchaseSection:Dropdown({
    Flag = "PurchaseItems",
    Title = "Select Purchasable Items",
    Values = getgenv().purchasableItems,
    Multi = true,
    Callback = function(selected)
        getgenv().selectedPurchaseItems = getgenv().normalizeMultiSelection(selected)
    end
})

getgenv().getItemCount = function(itemName)
    getgenv().count = 0
    for _, v in ipairs(player.Backpack:GetChildren()) do
        if v.Name == itemName then
            getgenv().count = getgenv().count + 1
        end
    end
    if player.Character then
        for _, v in ipairs(player.Character:GetChildren()) do
            if v.Name == itemName then
                getgenv().count = getgenv().count + 1
            end
        end
    end
    return getgenv().count
end

getgenv().getPurchaseRemote = function()
    if player.Character and player.Character:FindFirstChild("RemoteEvent") and player.Character.RemoteEvent:IsA("RemoteEvent") then
        return player.Character.RemoteEvent
    end
    return nil
end

getgenv().buyAction = function(itemName, action)
    if not action then
        return false, 0
    end

    getgenv().remote = getgenv().getPurchaseRemote()
    if not getgenv().remote then
        return false, 0
    end

    getgenv().before = getgenv().getItemCount(itemName)

    pcall(function()
        getgenv().remote:FireServer("PurchaseShopItem", {["ItemName"] = action.ItemName}, action.ShopPage, action.ShopSlot)
    end)

    task.wait(0.2)

    getgenv().after = getgenv().getItemCount(itemName)
    getgenv().gain = math.max(0, getgenv().after - getgenv().before)
    return getgenv().gain > 0, getgenv().gain
end

getgenv().PurchaseSection:Button({
    Title = "Buy Max of Selected",
    Callback = function()
        if getgenv().purchaseRunning then
            notify("YBA Script", "Purchase already running.")
            return
        end

        if #getgenv().selectedPurchaseItems == 0 then
            notify("YBA Script", "No purchase items selected.")
            return
        end

        getgenv().purchaseRunning = true
        getgenv().summary = {}

        for _, itemName in ipairs(getgenv().selectedPurchaseItems) do
            getgenv().cfg = getgenv().purchaseData[itemName]
            if not getgenv().cfg then
                table.insert(getgenv().summary, itemName .. ": skipped (no config)")
                continue
            end

            -- Uses your script's max table first
            getgenv().maxAmount = (maxLimits and maxLimits[itemName]) or getgenv().fallbackCaps[itemName] or 25
            getgenv().totalBought = 0
            getgenv().stalls = 0

            while getgenv().getItemCount(itemName) < getgenv().maxAmount do
                getgenv().current = getgenv().getItemCount(itemName)
                getgenv().needed = getgenv().maxAmount - getgenv().current
                getgenv().success = false
                getgenv().gain = 0

                if getgenv().cfg.five and getgenv().needed >= 5 then
                    getgenv().success, getgenv().gain = getgenv().buyAction(itemName, getgenv().cfg.five)
                end

                if (not getgenv().success) and getgenv().cfg.one then
                    getgenv().success, getgenv().gain = getgenv().buyAction(itemName, getgenv().cfg.one)
                end

                if getgenv().success then
                    getgenv().totalBought = getgenv().totalBought + getgenv().gain
                    getgenv().stalls = 0
                else
                    getgenv().stalls = getgenv().stalls + 1
                end

                if getgenv().stalls >= 5 then
                    break
                end

                task.wait(1)
            end

            table.insert(getgenv().summary, ("%s: %d/%d (+%d)"):format(itemName, getgenv().getItemCount(itemName), getgenv().maxAmount, getgenv().totalBought))
        end

        notify("YBA Script", "Purchase complete -> " .. table.concat(getgenv().summary, " | "))
        getgenv().purchaseRunning = false
    end
})

local LevelFarm = (function()
-- YBA Level Farm - Standalone Version (No UI)
-- Auto-farms quests based on your current level
--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
--// Configuration
local Config = {
    PredictionStrength = 0.5;
    StandAttachDistance = 2.5;
    QuestCheckDelay = 1;
    KillLoopDelay = 0.5;
    ItemCollectionDelay = 0.6;
}
--// State Management
local FarmState = {
    Active = false;
    CurrentQuest = nil;
    CompletedQuest = false;
}
--// Utility Functions
local Util = {}
function Util:GetPlayer()
return LocalPlayer
end
function Util:GetCharacter()
return self:GetPlayer().Character or self:GetPlayer().CharacterAdded:Wait()
end
function Util:GetHRP()
local Character = self:GetCharacter()
return Character and Character:FindFirstChild("HumanoidRootPart")
end
function Util:GetHumanoid()
local Character = self:GetCharacter()
return Character and Character:FindFirstChildWhichIsA("Humanoid")
end
function Util:CountItem(Item)
local Backpack = self:GetPlayer().Backpack
local Count = 0
for _, v in pairs(Backpack:GetChildren()) do
if v.Name == Item then Count = Count + 1 end
end
local Char = self:GetCharacter()
if Char and Char:FindFirstChildWhichIsA("Tool") and Char:FindFirstChildWhichIsA("Tool").Name == Item then
        Count = Count + 1
end
return Count
end
function Util:HasStand()
return self:GetPlayer().PlayerStats.Stand.Value ~= "None"
end
function Util:CheckStand()
return self:GetPlayer().PlayerStats.Stand.Value
end
function Util:EquipStand()
local Character = self:GetCharacter()
if Character and Character:FindFirstChild("RemoteFunction") and not Character:FindFirstChild("SummonedStand").Value then
        Character.RemoteFunction:InvokeServer("ToggleStand", "Toggle")
end
end
function Util:UseMove(Move)
local Char = self:GetCharacter()
if Char and Char:FindFirstChild("RemoteFunction") then
        Char.RemoteFunction:InvokeServer("Attack", Move)
end
end
function Util:GetQuest(NPC)
local DialogueName = NPC:FindFirstChild("Dialogue")
local Character = self:GetCharacter()
if DialogueName and Character and Character:FindFirstChild("RemoteEvent") then
        DialogueName = DialogueName.Value
local Event = Character.RemoteEvent
for i = 1, 10 do
            Event:FireServer("EndDialogue", {
["NPC"] = DialogueName;
["Option"] = "Option1";
["Dialogue"] = "Dialogue" .. i
})
            Event:FireServer("EndDialogue", {
["NPC"] = DialogueName;
["Dialogue"] = "Dialogue" .. i
})
end
end
end
function Util:Kill(Enemy)
local OldPos = self:GetHRP().CFrame
local EnemyHRP = Enemy:FindFirstChild("HumanoidRootPart")
local EnemyHumanoid = Enemy:FindFirstChildWhichIsA("Humanoid")
local EnemyHealth = Enemy:FindFirstChild("Health")
if not (Enemy and EnemyHRP and EnemyHumanoid and EnemyHealth and EnemyHealth.Value > 0) then
return
end
while EnemyHealth.Value > 0 and FarmState.Active do
if FarmState.CompletedQuest then break end
local Character = self:GetCharacter()
if not Character then break end
        Character = self:GetCharacter()
if Character:FindFirstChildWhichIsA("Humanoid") and Character:FindFirstChildWhichIsA("Humanoid").Health > 0 then
if self:HasStand() then
                self:EquipStand()
                task.wait(0.2)
end
-- Position character/stand
if self:HasStand() and Character:FindFirstChild("StandMorph") then
                Character.StandMorph.PrimaryPart.CFrame = EnemyHRP.CFrame - EnemyHRP.CFrame.LookVector * 1.1
                self:GetHRP().CFrame = Character.StandMorph.PrimaryPart.CFrame +
                    Character.StandMorph.PrimaryPart.CFrame.LookVector * -2.5 + Vector3.new(0, -35, 0)
else
                self:GetHRP().CFrame = EnemyHRP.CFrame - EnemyHRP.CFrame.LookVector * 2.3
end
-- Attack
            task.spawn(function() self:UseMove("m1") end)
else
            self:GetPlayer().CharacterAdded:Wait()
end
        task.wait(0.1)
end
    task.wait(2)
if self:GetHRP() then self:GetHRP().CFrame = OldPos end
end
function Util:Collect(Item)
local Character = self:GetCharacter()
local HRP = self:GetHRP()
if not (Item and Item.PrimaryPart and Character and HRP) then return end
local OldCF = HRP.CFrame
local startTime = tick()
-- Noclip
local clipConn = RunService.Stepped:Connect(function()
for _, v in pairs(Character:GetDescendants()) do
if v:IsA("BasePart") then v.CanCollide = false end
end
end)
-- Collect item
    HRP.CFrame = Item.PrimaryPart.CFrame - Vector3.new(0, 10, 0)
    task.wait(0.3)
repeat
        fireproximityprompt(Item:FindFirstChild("ProximityPrompt"))
if Item.Parent == Workspace.Item_Spawns.Items then
            HRP.CFrame = Item.PrimaryPart.CFrame - Vector3.new(0, 10, 0)
end
        task.wait()
until Item.Parent ~= Workspace.Item_Spawns.Items or tick() - startTime >= 3.5
    task.wait(0.6)
    HRP.CFrame = OldCF
    clipConn:Disconnect()
end
--// Quest Database
local QuestInfo = {
["Officer Sam [Lvl. 1+]"] = {Enemy = "Thug"};
["Deputy Bertrude [Lvl. 10+]"] = {Enemy = "Corrupt Police"};
["Homeless Man Jill [Lvl. 15+]"] = {Item = "Gold Coin"; Amount = 10};
["Dracula [Lvl. 20+]"] = {Enemy = "Zombie Henchman"};
["William Zeppeli [Lvl. 25+]"] = {Enemy = "Vampire"};
["Doppio [Lvl. 30+]"] = {Enemy = "Dio"};
["Dio [Lvl. 35+]"] = {Enemy = "Jotaro"};
}
--// Parse Available Quests
local function ParseQuests()
local parsed = {}
for _, v in pairs(Workspace.Dialogues:GetChildren()) do
if v.Name:find("Lvl") and not v.Name:find("Abbacchio") and not v.Name:find("Darius") and not v.Name:find("Pucci") and not v.Name:find("Kars") then
            table.insert(parsed, v.Name)
end
end
return parsed
end
local ParsedQuests = ParseQuests()
Workspace.Dialogues.ChildAdded:Connect(function(child)
if child.Name:find("Lvl") then
        table.insert(ParsedQuests, child.Name)
end
end)
--// Get Best Quest for Level
local function GetBestQuest()
local playerLevel = LocalPlayer.PlayerStats.Level.Value
local bestQuest, highestReq = nil, 0
for _, questName in pairs(ParsedQuests) do
if questName == "Homeless Man Jill [Lvl. 15+]" then continue end
local levelReq = tonumber(questName:gsub("%D", ""))
if levelReq and levelReq <= playerLevel and levelReq >= highestReq then
            highestReq = levelReq
            bestQuest = questName
end
end
return bestQuest
end
--// Main Farm Loop
local function FarmLoop()
-- Setup quest completion detection
local connection = LocalPlayer.PlayerGui.HUD.ChildAdded:Connect(function(child)
if child.Name == "QuestCompleted" then
            FarmState.CompletedQuest = true
end
end)
while FarmState.Active do
local questName = FarmState.CurrentQuest or GetBestQuest()
if not questName then
warn("No available quests found!")
break
end
local questNPC = Workspace.Dialogues:FindFirstChild(questName)
if not questNPC then
warn("Quest NPC not found:", questName)
break
end
local questData = QuestInfo[questName]
if not questData then
warn("Quest data not found:", questName)
break
end
-- Start or turn in quest
if FarmState.CompletedQuest then
            Util:GetQuest(questNPC)
            FarmState.CompletedQuest = false
            task.wait(1)
end
-- Farm based on quest type
if questData.Enemy then
-- Kill enemies until quest complete
while LocalPlayer.PlayerStats.QuestProgress.Value < LocalPlayer.PlayerStats.QuestMaxProgress.Value and FarmState.Active do
local enemy = Workspace.Living:FindFirstChild(questData.Enemy)
if enemy then
pcall(function() Util:Kill(enemy) end)
end
                task.wait(Config.KillLoopDelay)
end
            FarmState.CompletedQuest = true
elseif questData.Item then
-- Collect items
while Util:CountItem(questData.Item) < questData.Amount and FarmState.Active do
for _, item in pairs(Workspace.Item_Spawns.Items:GetChildren()) do
if item.Name == questData.Item then
                        Util:Collect(item)
break
end
end
                task.wait(Config.KillLoopDelay)
end
-- Turn in item quest
if Util:CountItem(questData.Item) >= questData.Amount then
                Util:GetQuest(questNPC)
                task.wait(1)
end
            FarmState.CompletedQuest = true
end
        task.wait(Config.QuestCheckDelay)
end
    connection:Disconnect()
end
--// Public API
local LevelFarm = {}
function LevelFarm.Start(options)
if FarmState.Active then
warn("Level farm already running!")
return
end
    options = options or {}
    FarmState.Active = true
    FarmState.CurrentQuest = options.quest
    task.spawn(FarmLoop)
end
function LevelFarm.Stop()
    FarmState.Active = false
    FarmState.CurrentQuest = nil
    FarmState.CompletedQuest = false
end
function LevelFarm.IsActive()
return FarmState.Active
end
--// Usage Examples:
--[[
-- Start farming best available quest:
LevelFarm.Start()
-- Farm specific quest:
LevelFarm.Start({quest = "Officer Sam [Lvl. 1+]"})
-- Stop farming:
LevelFarm.Stop()
-- Check if active:
if LevelFarm.IsActive() then print("Farming...") end
]]
-- Return module for advanced usage
return LevelFarm
end)()
local selectedQuest = "Officer Sam [Lvl. 1+]"
LevelFarmTab:Dropdown({
    Flag = "SelectQuest",
    Title = "Select Quest",
    Values = {"Officer Sam [Lvl. 1+]", "Deputy Bertrude [Lvl. 10+]", "Homeless Man Jill [Lvl. 15+]", "Dracula [Lvl. 20+]", "William Zeppeli [Lvl. 25+]", "Doppio [Lvl. 30+]", "Dio [Lvl. 35+]"},
    Value = "Officer Sam [Lvl. 1+]",
    Callback = function(option)
        selectedQuest = option
    end
})
LevelFarmTab:Space()
local levelFarmToggle = LevelFarmTab:Toggle({
    Flag = "LevelFarm",
    Title = "Enable Level Farm",
    Locked = true,
    Default = false,
    Callback = function(value)
        if value then
            LevelFarm.Start({quest = selectedQuest})
            notify("YBA Script", "Level Farm enabled.")
        else
            LevelFarm.Stop()
            notify("YBA Script", "Level Farm disabled.")
        end
    end
})
LevelFarmTab:Section({
    Title = "This feature is still not working",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local BACK_DISTANCE = 2
local BACK_HEIGHT = 0.5
local PLAYER_HEIGHT = 20
local ALIGN_RESPONSIVENESS = 250
local ALIGN_MAX_FORCE = 1e7
local CHECK_SCAN_INTERVAL = 1.0
local SMOOTH_FALLBACK_ALPHA = 0.85
local scanTimer = 0
local modelCache = {}
local function isCharacterModel(m)
if not m or not m:IsA("Model") then return false end
return m:FindFirstChild("Humanoid") and m:FindFirstChild("HumanoidRootPart")
end
local function rebuildModelCache()
    modelCache = {}
for _, child in ipairs(workspace:GetChildren()) do
if isCharacterModel(child) then
            table.insert(modelCache, child)
else
for _, c2 in ipairs(child:GetChildren()) do
if isCharacterModel(c2) then table.insert(modelCache, c2) end
end
end
end
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= player and pl.Character and isCharacterModel(pl.Character) then
            table.insert(modelCache, pl.Character)
end
end
end
rebuildModelCache()
workspace.ChildAdded:Connect(function(c)
if isCharacterModel(c) then table.insert(modelCache, c) else
for _, c2 in ipairs(c:GetChildren()) do if isCharacterModel(c2) then table.insert(modelCache, c2) end end
end
end)
workspace.ChildRemoved:Connect(function(c)
for i = #modelCache, 1, -1 do if modelCache[i] == c then table.remove(modelCache, i) end end
end)
Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function(ch)
if isCharacterModel(ch) then table.insert(modelCache, ch) end
end)
end)
Players.PlayerRemoving:Connect(function(pl)
if pl.Character then
for i = #modelCache, 1, -1 do if modelCache[i] == pl.Character then table.remove(modelCache, i) end end
end
end)
local function findClosestByName(name)
if not name or name == "" then return nil end
local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
if not root then return nil end
local rootPos = root.Position
local lower = name:lower()
local closest, minD = nil, math.huge
-- check players first (so exact player names are preferred)
for _, pl in ipairs(Players:GetPlayers()) do
if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
local match = false
if pl.Name:lower():find(lower) then match = true end
if pl.DisplayName and pl.DisplayName:lower():find(lower) then match = true end
if match then
local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
local hum = pl.Character:FindFirstChild("Humanoid")
if hrp and hum and hum.Health > 0 then
local d = (hrp.Position - rootPos).Magnitude
if d < minD then minD, closest = d, pl.Character end
end
end
end
end
for _, model in ipairs(modelCache) do
if model and model.Parent and model ~= player.Character then
if model.Name:lower():find(lower) then
local hrp = model:FindFirstChild("HumanoidRootPart")
local hum = model:FindFirstChild("Humanoid")
if hrp and hum and hum.Health > 0 then
local d = (hrp.Position - rootPos).Magnitude
if d < minD then minD, closest = d, model end
end
end
end
end
return closest
end
local function getStand()
local ch = player.Character
if not ch then return nil end
for _, child in ipairs(ch:GetChildren()) do
if child:IsA("Model") and child:FindFirstChild("HumanoidRootPart") and child ~= ch then
return child
end
end
return nil
end
local activeAligns = {}
local currentTargetForEntity = {}
local function cleanupAlignFor(entity)
if not entity then return end
local hrp = entity:FindFirstChild("HumanoidRootPart")
if hrp then
for _, c in ipairs(hrp:GetChildren()) do
if tostring(c.Name):match("^Stick_") then
                c:Destroy()
end
end
end
    activeAligns[entity] = nil
    currentTargetForEntity[entity] = nil
end
local function createAlignsFor(entity, targetHRP, stickMode)
if not entity or not targetHRP then return nil end
    cleanupAlignFor(entity)
-- robustly obtain the HRP (handles respawn timing)
local hrp = entity:FindFirstChild("HumanoidRootPart")
if not hrp then
        hrp = entity:FindFirstChild("Torso") or entity:FindFirstChild("UpperTorso")
end
if not hrp then
local ok
        ok, hrp = pcall(function() return entity:WaitForChild("HumanoidRootPart", 0.5) end)
if not ok then hrp = nil end
end
if not hrp then return nil end
local offset = Vector3.new(0,0,0)
if stickMode == "back" then
        offset = Vector3.new(0, BACK_HEIGHT, -BACK_DISTANCE)
end
local attA = Instance.new("Attachment")
    attA.Name = "Stick_AttA"
    attA.Parent = hrp
    attA.Position = Vector3.new(0,0,0)
local attB = Instance.new("Attachment")
    attB.Name = "Stick_AttB"
    attB.Parent = targetHRP
    attB.Position = offset
local alignPos = Instance.new("AlignPosition")
    alignPos.Name = "Stick_AlignPos"
    alignPos.Attachment0 = attA
    alignPos.Attachment1 = attB
    alignPos.MaxForce = ALIGN_MAX_FORCE
    alignPos.Responsiveness = ALIGN_RESPONSIVENESS
    alignPos.RigidityEnabled = false
    alignPos.Parent = hrp
local alignOri = Instance.new("AlignOrientation")
    alignOri.Name = "Stick_AlignOri"
    alignOri.Attachment0 = attA
    alignOri.Attachment1 = attB
    alignOri.MaxTorque = ALIGN_MAX_FORCE
    alignOri.Responsiveness = ALIGN_RESPONSIVENESS
    alignOri.Parent = hrp
    activeAligns[entity] = {attA = attA, attB = attB, alignPos = alignPos, alignOri = alignOri, stickMode = stickMode}
    currentTargetForEntity[entity] = targetHRP
if entity == player.Character then
notify("Sticker", "Player align applied (mode="..tostring(stickMode)..")")
end
return activeAligns[entity]
end
local function smoothFallback(entity, targetHRP, stickMode, isAlive)
local hrp = entity and entity:FindFirstChild("HumanoidRootPart")
if not hrp or not targetHRP then return end
local desiredPos
if stickMode == "back" then
        desiredPos = targetHRP.Position - targetHRP.CFrame.LookVector * BACK_DISTANCE + Vector3.new(0, BACK_HEIGHT, 0)
elseif stickMode == "Down" then
local height = isAlive and -PLAYER_HEIGHT or PLAYER_HEIGHT
        desiredPos = targetHRP.Position + Vector3.new(0, height, 0)
elseif stickMode == "Up" then
local height = isAlive and PLAYER_HEIGHT or -PLAYER_HEIGHT
        desiredPos = targetHRP.Position + Vector3.new(0, height, 0)
else
return
end
local look = -Vector3.new(targetHRP.CFrame.LookVector.X, 0, targetHRP.CFrame.LookVector.Z).Unit
local yaw = math.atan2(look.X, look.Z)
local desiredCFrame = CFrame.new(desiredPos) * CFrame.Angles(0, yaw, 0)
    hrp.CFrame = hrp.CFrame:Lerp(desiredCFrame, SMOOTH_FALLBACK_ALPHA)
end
local viewing = false
local prevCameraSubject = nil
local prevCameraType = nil
local viewingStand = nil
-- orbit camera state & connections
local orbit = {
    yaw = 0,
    pitch = 0,
    radius = 8,
    minRadius = 2,
    maxRadius = 60,
    sensitivity = 0.0035,
    pitchMin = -math.pi/2 + 0.1,
    pitchMax = math.pi/2 - 0.1,
    dragging = false,
    inputChangedConn = nil,
    inputBeganConn = nil,
    inputEndedConn = nil,
    renderConn = nil
}
local function enableOrbitCamera(stand)
if not stand or not stand:FindFirstChild("HumanoidRootPart") then
        notify("View Stand", "Can't view: stand missing HRP.")
return
end
    viewingStand = stand
    prevCameraSubject = camera.CameraSubject
    prevCameraType = camera.CameraType
local standPos = stand.HumanoidRootPart.Position
local camCF = camera.CFrame
local toStand = (camCF.Position - standPos)
    orbit.radius = math.clamp(toStand.Magnitude, orbit.minRadius, orbit.maxRadius)
local dir = toStand.Unit
local pitch = math.asin(math.clamp(dir.Y, -1, 1)) * -1 -- invert so positive pitch raises camera
local yaw = math.atan2(dir.X, dir.Z)
    orbit.yaw = yaw
    orbit.pitch = pitch
    camera.CameraType = Enum.CameraType.Scriptable
    orbit.inputBeganConn = UserInputService.InputBegan:Connect(function(input, processed)
if processed then return end
if input.UserInputType == Enum.UserInputType.MouseButton2 then
            orbit.dragging = true
            UserInputService.MouseIconEnabled = false
end
end)
    orbit.inputEndedConn = UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton2 then
            orbit.dragging = false
            UserInputService.MouseIconEnabled = true
end
end)
    orbit.inputChangedConn = UserInputService.InputChanged:Connect(function(input, processed)
if input.UserInputType == Enum.UserInputType.MouseMovement and orbit.dragging then
            orbit.yaw = orbit.yaw - input.Delta.X * orbit.sensitivity
            orbit.pitch = math.clamp(orbit.pitch - input.Delta.Y * orbit.sensitivity, orbit.pitchMin, orbit.pitchMax)
elseif input.UserInputType == Enum.UserInputType.MouseWheel then
            orbit.radius = math.clamp(orbit.radius - input.Position.Z, orbit.minRadius, orbit.maxRadius)
end
end)
    orbit.renderConn = RunService.RenderStepped:Connect(function()
if not viewing or not viewingStand or not viewingStand.Parent then return end
local hrp = viewingStand:FindFirstChild("HumanoidRootPart")
if not hrp then return end
local standPos = hrp.Position
local rot = CFrame.Angles(orbit.pitch, orbit.yaw, 0)
local offset = rot:VectorToWorldSpace(Vector3.new(0, 0, orbit.radius))
local camPos = standPos + offset
        camera.CFrame = CFrame.new(camPos, standPos)
end)
    notify("View Stand", "Now viewing your stand")
    viewing = true
end
local function disableOrbitCamera()
    viewing = false
    viewingStand = nil
if orbit.inputChangedConn then orbit.inputChangedConn:Disconnect() orbit.inputChangedConn = nil end
if orbit.inputBeganConn then orbit.inputBeganConn:Disconnect() orbit.inputBeganConn = nil end
if orbit.inputEndedConn then orbit.inputEndedConn:Disconnect() orbit.inputEndedConn = nil end
if orbit.renderConn then orbit.renderConn:Disconnect() orbit.renderConn = nil end
pcall(function()
if prevCameraSubject then camera.CameraSubject = prevCameraSubject end
if prevCameraType then camera.CameraType = prevCameraType end
end)
    UserInputService.MouseIconEnabled = true
    notify("View Stand", "Camera restored.")
end
local function enableView(stand)
if not stand or not stand:FindFirstChild("Humanoid") and not stand:FindFirstChild("HumanoidRootPart") then
        notify("View Stand", "Equipt your stand first")
return
end
if viewing then return end
    enableOrbitCamera(stand)
end
local function disableView()
if not viewing then return end
    disableOrbitCamera()
end
local stickerEnabled = false
local viewEnabled = false
local method = "normal"
local targetName = ""
TrollingTab:Section({Title = "Trolling"})
TrollingTab:Input({
    Flag = "TargetName",
    Title = "Enter Player/Mob Name",
    Callback = function(value)
        targetName = value
    end
})
TrollingTab:Space()
local stickerToggle = TrollingTab:Toggle({
    Flag = "Sticker",
    Title = "Sticker",
    Default = false,
    Callback = function(value)
        stickerEnabled = value
if stickerEnabled then
        notify("YBA Script", "Sticker enabled for: ".. (targetName ~= "" and targetName or "<empty>"))
if method == "Up" or method == "Down" then
            enableNoclip()
end
else
        notify("YBA Script", "Sticker disabled")
for entity, _ in pairs(activeAligns) do cleanupAlignFor(entity) end
        disableNoclip()
end
    end
})
TrollingTab:Space()
local viewToggle = TrollingTab:Toggle({
    Flag = "ViewStand",
    Title = "View Stand",
    Default = false,
    Callback = function(value)
        viewEnabled = value
        if viewToggle2 then pcall(function() viewToggle2:Set(value) end) end
if value then
local stand = getStand()
if not stand then
        notify("View Stand", "Equipt your stand first")
return
end
    enableView(stand)
else
        disableView()
end
    end
})
TrollingTab:Space()
TrollingTab:Dropdown({
    Flag = "StickerMethod",
    Title = "Methods",
    Values = {"normal", "Down", "Up"},
    Value = "normal",
    Callback = function(option)
        method = option
        notify("YBA Script", "Method changed to: " .. method)
if stickerEnabled then
for entity, _ in pairs(activeAligns) do cleanupAlignFor(entity) end
end
if method ~= "Down" and method ~= "Up" then
        disableNoclip()
end
-- Auto enable view if up and sticker enabled
if (method == "Down" or method == "Up") and stickerEnabled and not viewing then
local stand = getStand()
if stand then
            enableView(stand)
end
end
    end
})
RunService.Heartbeat:Connect(function(dt)
    scanTimer = scanTimer + dt
if scanTimer >= CHECK_SCAN_INTERVAL then
        rebuildModelCache()
        scanTimer = 0
end
if viewing then
if not viewingStand or not viewingStand.Parent or not viewingStand:FindFirstChild("HumanoidRootPart") then
            disableView()
end
end
if not stickerEnabled then return end
local name = targetName
if not name or name == "" then return end
local stand = getStand()
if not stand then
return
end
local target = findClosestByName(name)
if not target then
    if next(activeAligns) ~= nil then
        notify("Sticker", "No alive target found (died?), turning off.")
        stickerToggle:Set(false)
        if viewEnabled then viewToggle:Set(false) end
        for entity,_ in pairs(activeAligns) do cleanupAlignFor(entity) end
    end
    return
end
local targetHRP = target:FindFirstChild("HumanoidRootPart")
local targetHum = target:FindFirstChild("Humanoid")
local isAlive = targetHum and targetHum.Health > 0
if not targetHRP or not targetHum then
for entity,_ in pairs(activeAligns) do cleanupAlignFor(entity) end
if method == "Down" or method == "Up" then enableNoclip() else disableNoclip() end
return
end
local myChar = player.Character
-- Stick stand always to back if present
if stand and currentTargetForEntity[stand] ~= targetHRP then
local ok, res = pcall(createAlignsFor, stand, targetHRP, "back")
if not ok or not res then
            cleanupAlignFor(stand)
end
end
if method == "Down" or method == "Up" then
if currentTargetForEntity[myChar] ~= targetHRP then
local ok, res = pcall(createAlignsFor, myChar, targetHRP, method)
if not ok or not res then
                cleanupAlignFor(myChar)
end
end
else
        cleanupAlignFor(myChar)
        disableNoclip()
end
for entity, alignData in pairs(activeAligns) do
if alignData and alignData.attB and alignData.attB.Parent == targetHRP then
local desiredWorldPos
if alignData.stickMode == "back" then
                desiredWorldPos = targetHRP.Position - targetHRP.CFrame.LookVector * BACK_DISTANCE + Vector3.new(0, BACK_HEIGHT, 0)
elseif alignData.stickMode == "Down" then
local height = isAlive and -PLAYER_HEIGHT or PLAYER_HEIGHT
                desiredWorldPos = targetHRP.Position + Vector3.new(0, height, 0)
elseif alignData.stickMode == "Up" then
local height = isAlive and PLAYER_HEIGHT or -PLAYER_HEIGHT
                desiredWorldPos = targetHRP.Position + Vector3.new(0, height, 0)
end
if desiredWorldPos then
local localPos = targetHRP.CFrame:PointToObjectSpace(desiredWorldPos)
                alignData.attB.Position = localPos
end
else
pcall(smoothFallback, entity, targetHRP, alignData.stickMode, isAlive)
end
end
if (method == "Down" or method == "Up") and isAlive then
        enableNoclip()
else
if method ~= "Down" and method ~= "Up" then
            disableNoclip()
end
end
end)
TrollingTab:Space()
local flyEnabled = false
local flySpeed = 50
local flyBodyVelocity = nil
local flyBodyGyro = nil
local function enableFly()
    if flyEnabled then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Parent = hrp
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 100000
    flyBodyGyro.Parent = hrp
    flyEnabled = true
    notify("YBA Script", "Fly enabled.")
    spawn(function()
        while flyEnabled do
            if not char or not hrp then break end
            local moveDir = Vector3.new(0, 0, 0)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end
            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * flySpeed
                flyBodyVelocity.Velocity = moveDir
                flyBodyGyro.CFrame = workspace.CurrentCamera.CFrame
            else
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            wait()
        end
    end)
end
local function disableFly()
    if not flyEnabled then return end
    if flyBodyVelocity then flyBodyVelocity:Destroy() end
    if flyBodyGyro then flyBodyGyro:Destroy() end
    flyEnabled = false
    notify("YBA Script", "Fly disabled.")
end
local flyToggle = TrollingTab:Toggle({
    Flag = "Fly",
    Title = "Enable Fly",
    Default = false,
    Callback = function(value)
        if value then
            enableFly()
        else
            disableFly()
        end
    end
})
TrollingTab:Space()
local lastFlySpeedNotify = 0
local flySpeedSlider = TrollingTab:Slider({
    Flag = "FlySpeed",
    Title = "Fly Speed",
    Step = 1,
    Value = {
        Min = 1,
        Max = 400,
        Default = 50,
    },
    Callback = function(value)
        flySpeed = value
        if os.clock() - lastFlySpeedNotify > 1 then
            notify("YBA Script", "Fly speed set to " .. value)
            lastFlySpeedNotify = os.clock()
        end
    end
})
TrollingTab:Space()
getgenv().standPilotActive = false
getgenv().pilotSpeed = 16
getgenv().PilotConfig = {
    Speed = 50,
    SpeedChangerEnabled = false,
    IsActive = false
}
getgenv().pilotSpeed = 50
-- Stand Pilot System
local pilotConnections = {}
local standAnimController = nil
local function cleanupPilot()
    if not getgenv().PilotConfig.IsActive then return end
  
    for _, conn in pairs(pilotConnections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    pilotConnections = {}
    standAnimController = nil
  
    -- Restore sewers
    pcall(function()
        local tempStorage = game.ReplicatedStorage:FindFirstChild("TempStoragePilot")
        if tempStorage then
            for _, v in pairs(tempStorage:GetChildren()) do
                if v.Name == "Naples' Sewers" then
                    v.Parent = workspace.Locations
                end
            end
            tempStorage:Destroy()
        end
    end)
    
    -- Remove camera focus
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("FocusCam") then
            character.FocusCam:Destroy()
        end
    end)
    
    -- Re-enable collisions
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
    
    -- Teleport back and toggle stand off
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("StandMorph") then
            local standHRP = character.StandMorph:FindFirstChild("HumanoidRootPart")
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local remoteFunc = character:FindFirstChild("RemoteFunction")
            if standHRP and hrp then
                hrp.CFrame = standHRP.CFrame
            end
            if remoteFunc then
                remoteFunc:InvokeServer("ToggleStand", "Toggle")
            end
        end
    end)
    
    getgenv().PilotConfig.IsActive = false
end

-- MAIN PILOT TOGGLE
local pilotToggle = TrollingTab:Toggle({
    Flag = "PilotStand",
    Title = "Pilot Stand",
    Default = false,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local character = player.Character
        if not character then 
            notify("YBA Script", "Character not loaded!")
            pilotToggle:Set(false)
            return 
        end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        local remoteFunc = character:FindFirstChild("RemoteFunction")
        
        if not hrp or not humanoid or not remoteFunc then
            notify("YBA Script", "Character not ready!")
            pilotToggle:Set(false)
            return
        end
        
        -- DISABLE PILOT
        if getgenv().PilotConfig.IsActive then
            cleanupPilot()
            notify("YBA Script", "Stand Pilot disabled.")
            return
        end
        
        -- ENABLE PILOT
        if not value then return end
        
        -- Summon stand if needed
        if not character:FindFirstChild("StandMorph") then
            remoteFunc:InvokeServer("ToggleStand", "Toggle")
            local waited = 0
            repeat task.wait(0.1) waited = waited + 0.1 until character:FindFirstChild("StandMorph") or waited > 5
            if not character:FindFirstChild("StandMorph") then
                notify("YBA Script", "Failed to summon stand!")
                pilotToggle:Set(false)
                return
            end
        end
        
        local standMorph = character.StandMorph
        standAnimController = standMorph.AnimationController
        local standHRP = standMorph:WaitForChild("HumanoidRootPart", 3)
        
        if not standAnimController or not standHRP then
            notify("YBA Script", "Stand not properly loaded!")
            pilotToggle:Set(false)
            return
        end
        
        -- Apply pilot speed if enabled
        if getgenv().PilotConfig.SpeedChangerEnabled then
            standAnimController.WalkSpeed = getgenv().PilotConfig.Speed
        end
        
        -- Setup
        getgenv().PilotConfig.IsActive = true
        
        -- Temp storage & sewers
        local tempStorage = Instance.new("Folder", game.ReplicatedStorage)
        tempStorage.Name = "TempStoragePilot"
        
        pcall(function()
            for _, v in pairs(workspace.Locations:GetChildren()) do
                if v.Name == "Naples' Sewers" then
                    v.Parent = tempStorage
                end
            end
        end)
        
        -- Camera focus
        local cameraValue = Instance.new("ObjectValue", standMorph.Parent)
        cameraValue.Name = "FocusCam"
        cameraValue.Value = standAnimController
        
        -- Disable collisions
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Disable stand constraints
        pcall(function()
            local standAttach = standMorph.PrimaryPart:FindFirstChild("StandAttach")
            if standAttach then
                local alignOrient = standAttach:FindFirstChild("AlignOrientation")
                local alignPos = standAttach:FindFirstChild("AlignPosition")
                if alignOrient then alignOrient.Enabled = false end
                if alignPos then alignPos.Enabled = false end
            end
        end)
        
        -- Jump sync
        table.insert(pilotConnections, humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
            if humanoid.Jump then
                standAnimController.Jump = true
            end
            task.wait()
        end))
        
        -- Main movement loop (speed applied here too)
        table.insert(pilotConnections, RunService.Heartbeat:Connect(function()
            if not character or not character.Parent then return end
            if not standMorph or not standMorph.Parent then
                pcall(function() remoteFunc:InvokeServer("ToggleStand", "Toggle") end)
                return
            end
            
            local moveDirection = workspace.CurrentCamera.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
            standAnimController:Move(moveDirection, true)
            
            -- Apply speed in loop (ensures it sticks)
            if getgenv().PilotConfig.SpeedChangerEnabled then
                standAnimController.WalkSpeed = getgenv().PilotConfig.Speed
            end
            
            if standHRP and hrp then
                hrp.CFrame = standHRP.CFrame - Vector3.new(0, 36, 0)
            end
        end))
        
        -- Collision groups
        pcall(function()
            for _, v in pairs(standMorph.Parent:GetDescendants()) do
                if v:IsA("BasePart") or v:IsA("UnionOperation") then
                    game:GetService("PhysicsService"):SetPartCollisionGroup(v, "Players")
                end
            end
        end)
        
        notify("YBA Script", "Stand Pilot enabled!")
    end
})

-- PILOT SPEED CHANGER TOGGLE (Add this RIGHT AFTER the main pilot toggle)
local pilotSpeedToggle = TrollingTab:Toggle({
    Flag = "PilotSpeedChanger",
    Title = "Pilot Speed Changer",
    Default = false,
    Callback = function(value)
        getgenv().PilotConfig.SpeedChangerEnabled = value
        if value and standAnimController then
            standAnimController.WalkSpeed = getgenv().PilotConfig.Speed
            notify("YBA Script", "Speed changer " .. (value and "enabled" or "disabled"))
        end
    end
})

-- PILOT SPEED SLIDER (Add this RIGHT AFTER the speed changer toggle)
local pilotSlider = TrollingTab:Slider({
    Flag = "PilotSpeed",
    Title = "Pilot Speed",
    Step = 1,
    Value = {
        Min = 0,
        Max = 200,
        Default = 50
    },
    Callback = function(value)
        getgenv().PilotConfig.Speed = value
        if getgenv().PilotConfig.SpeedChangerEnabled and standAnimController and standAnimController.Parent then
            standAnimController.WalkSpeed = value
        end
    end
})

-- Auto-cleanup on character respawn
game.Players.LocalPlayer.CharacterAdded:Connect(function()
  if getgenv().standPilotActive then
    cleanupPilot()
    notify("YBA Script", "Stand Pilot auto-disabled (character respawned).")
    pilotToggle:Set(false)
  end
end)
local ConfigTab = SettingsTab
local ConfigManager = Window.ConfigManager
local ConfigName = "default"
local ConfigManager = Window.ConfigManager
local ConfigNameInput = ConfigTab:Input({
    Flag = "ConfigName",
    Title = "Config Name",
    Icon = "file-cog",
    Callback = function(value)
        ConfigName = value
end
})
local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil
ConfigTab:Dropdown({
    Title = "All Configs",
    Desc = "Select existing configs",
    Values = AllConfigs,
    Value = DefaultValue,
    Callback = function(value)
        ConfigName = value
        ConfigNameInput:Set(value)
end
})
ConfigTab:Space()
ConfigTab:Button({
    Title = "Save Config",
    Icon = "",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
if Window.CurrentConfig:Save() then
            WindUI:Notify({
                Title = "Config Saved",
                Desc = "Config '" .. ConfigName .. "' saved",
                Icon = "check",
})
end
end
})
ConfigTab:Space()
ConfigTab:Button({
    Title = "Load Config",
    Icon = "",
    Justify = "Center",
    Callback = function()
        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
if Window.CurrentConfig:Load() then
            WindUI:Notify({
                Title = "Config Loaded",
                Desc = "Config '" .. ConfigName .. "' loaded",
                Icon = "refresh-cw",
})
end
end
})
ConfigTab:Space()
local autoLoadToggle = ConfigTab:Toggle({
    Flag = "AutoLoad",
    Title = "Auto Load Script",
    Default = false
})
ConfigTab:Space()
ConfigTab:Keybind({
        Flag = "KeybindTest",
        Title = "Keybind",
        Desc = "Press to change keybind ui",
        Value = "K",
        Callback = function(v)
            Window:SetToggleKey(Enum.KeyCode[v])
        end
})
local defaultConfig = ConfigManager:CreateConfig("default")
defaultConfig:Load()
tpToItemsToggle:Set(false)
autoSellMaxToggle:Set(false)
autoSellSelectedToggle:Set(false)
itemESPToggle:Set(false)
playerESPToggle:Set(false)
itemNotifierToggle:Set(false)
antiAFKToggle:Set(false)
fpsBoosterToggle:Set(false)
instantPickupToggle:Set(false)
afkCameraToggle:Set(false)
autoLoadToggle:Set(false)
notify("YBA Script", "Script loaded successfully.")
--// SBR FEATURE INTEGRATION (BULLETPROOF VERSION)
local function LoadSBRFeatures()
    --// Verify all dependencies exist
    if not SBRTab then
        warn("SBR: SBRTab not found!")
        return
    end
    
    --// Check if in Steel Ball Run
    local isSBR = game.PlaceId == 4643697430
    
    if not isSBR then
        -- Not in SBR, show warning
        SBRTab:Section({ Title = "⚠️ NOT IN SBR GAME" })
        SBRTab:Section({ Title = "Join Steel Ball Run to use these features" })
        SBRTab:Button({
            Title = "Teleport to SBR",
            Callback = function()
                game.TeleportService:Teleport(4643697430, game.Players.LocalPlayer)
            end
        })
        return
    end
    
    --// In SBR mode - load features
    local success, err = pcall(function()
        --// Xenon V3 Library (SBR-Optimized)
        local Xenon = {Utils = {}}
        Xenon.__index = Xenon
        Xenon.Utils.__index = Xenon.Utils

        function Xenon.Utils.MakeUtilController(Settings)
            local Utils = {
                Tasks = {}; Services = {}; States = {}; Ints = {}; 
                Strings = {}; Tables = {}; Settings = Settings or {ConfigName = "XenonV3/SBRConfig.json"};
            }
            Utils.Services = setmetatable({}, {__index = function(self, service)
                if rawget(self, service) then return rawget(self, service) end
                local GotService = game:GetService(service)
                self[service] = GotService
                return self[service]
            end})
            return setmetatable(Utils, Xenon.Utils)
        end

        function Xenon.Utils:MakeFolder()
            if isfolder("XenonV3") == false then makefolder("XenonV3") end
        end

        function Xenon.Utils:ReadData()
            self:MakeFolder()
            local Data; pcall(function()
                Data = self.Services.HttpService:JSONDecode(readfile(self.Settings.ConfigName))
            end);
            Data = Data or {Int={}, State={}, String={}, Table={}}
            return {
                Data = Data;
                LoadData = function()
                    self:AddValues(self:ConvertConfig(Data))
                end;
            }
        end

        function Xenon.Utils:WriteData(Data)
            self:MakeFolder()
            local StringData = self.Services.HttpService:JSONEncode(Data)
            pcall(function() writefile(self.Settings.ConfigName, StringData) end)
        end

        function Xenon.Utils:ConvertConfig(Config)
            local RepTable = Config
            for i,v in pairs(RepTable) do
                for ValName, ValueTable in pairs(v) do
                    if ValueTable["Value"] ~= nil then
                        local Val = ValueTable.Value
                        ValueTable["Value"] = nil
                        ValueTable[1] = Val
                    end
                end
            end
            return RepTable
        end

        function Xenon.Utils:AddValues(Values)
            for key, value in pairs(Values) do
                if key:lower() == "int" then
                    for i,v in pairs(Values[key]) do
                        self.Ints[i] = (type(v) == "number" and {["Value"] = v, ["SaveValue"] = false} or type(v) == "table" and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]})
                    end
                end
                if key:lower() == "state" then
                    for i,v in pairs(Values[key]) do
                        self.States[i] = (type(v) == "boolean" and {["Value"] = v, ["SaveValue"] = false} or type(v) == "table" and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]})
                    end
                end
                if key:lower() == "string" then
                    for i,v in pairs(Values[key]) do
                        self.Strings[i] = (type(v) == "string" and {["Value"] = v, ["Value"] = false} or type(v) == "table" and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]})
                    end
                end
                if key:lower() == "table" then
                    for i,v in pairs(Values[key]) do
                        self.Tables[i] = ((v["SaveValue"] and v["SaveValue"] == true) and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]} or {["Value"] = v, ["SaveValue"] = false})
                    end
                end
            end
        end

        function Xenon.Utils:GetInt(Value) return self.Ints[Value] and self.Ints[Value].Value or 0 end
        function Xenon.Utils:GetString(Value) return self.Strings[Value] and self.Strings[Value].Value or "" end
        function Xenon.Utils:GetState(Value) return self.States[Value] and self.States[Value].Value or false end
        function Xenon.Utils:GetTable(Value) return self.Tables[Value] and self.Tables[Value].Value or {} end
        function Xenon.Utils:SetInt(Value, NewValue) if self.Ints[Value] then self.Ints[Value].Value = NewValue end end
        function Xenon.Utils:SetState(Value, NewValue) if self.States[Value] then self.States[Value].Value = NewValue end end
        function Xenon.Utils:SetTable(Value, NewValue) if self.Tables[Value] then self.Tables[Value].Value = NewValue end end
        function Xenon.Utils:ChangeTable(Value, TableIndex, NewValue) if self.Tables[Value] then self.Tables[Value].Value[TableIndex] = NewValue end end
        function Xenon.Utils:AddTask(TaskName, Task) if not self.Tasks[TaskName] then self.Tasks[TaskName] = Task end return Task end
        function Xenon.Utils:IsTaskRunning(TaskName) return self.Tasks[TaskName] and self.Tasks[TaskName].Connected end
        function Xenon.Utils:DisconnectTask(TaskName) if self:IsTaskRunning(TaskName) then self.Tasks[TaskName]:Disconnect(); self.Tasks[TaskName] = nil end end
        function Xenon.Utils:GetService(Service) return self.Services[Service] end
        function Xenon.Utils:GetPlayer() return self.Services.Players.LocalPlayer end
        function Xenon.Utils:GetCharacter() return self:GetPlayer().Character or self:GetPlayer().CharacterAdded:Wait() end
        function Xenon.Utils:GetHumanoid() local Character = self:GetCharacter(); return Character and Character:FindFirstChildWhichIsA("Humanoid") end
        function Xenon.Utils:GetHRP() local Character = self:GetCharacter(); return Character and Character:FindFirstChild("HumanoidRootPart") end
        function Xenon.Utils:IsSBR() return game.PlaceId == 4643697430 end
        function Xenon.Utils:GetHorse() local Name = self:GetPlayer().Name; return workspace:FindFirstChild(Name .."'s Horse") end
        function Xenon.Utils:Teleport(CF, Offset) local Character = self:GetCharacter(); local FinalCF = typeof(CF) == "Vector3" and CFrame.new(CF) or CF; if Character and Character.PrimaryPart then Character.PrimaryPart.CFrame = FinalCF + (Offset or Vector3.new(0, 0, 0)) end end

        --// Initialize SBR Utility
        local SBR_Util = Xenon.Utils.MakeUtilController()
        SBR_Util:ReadData():LoadData()

        --// Initialize SBR values
        SBR_Util:AddValues{
            ["Int"] = {
                ["SBR_Delay_1"] = 5; ["SBR_Delay_2"] = 5; ["SBR_Delay_3"] = 5;
                ["SBR_Delay_4"] = 5; ["SBR_Delay_5"] = 5; ["SBR_Delay_Hide"] = 5;
                ["HorseWalkSpeed"] = 16; ["HorseJumpPower"] = 50;
            };
            ["State"] = {
                ["Use_Horse_ASBR"] = false; ["RedBarrierNoClip"] = false; ["PlayerESP"] = false;
            };
            ["String"] = {}; ["Table"] = {};
        }

        --// SBRTeleports table
        local SBRTeleports = {}
        pcall(function()
            SBRTeleports = {
                ["Stage 1 Barrier"] = workspace:FindFirstChild("Barriers"):FindFirstChild("1").CFrame,
                ["Stage 2 Barrier"] = workspace:FindFirstChild("Barriers"):FindFirstChild("2").CFrame,
                ["Stage 3 Barrier"] = workspace:FindFirstChild("Barriers"):FindFirstChild("3").CFrame,
                ["Stage 4 Barrier"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("Start").CFrame,
                ["Normal Hide"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("NYC Bridge"):FindFirstChild("Bridge"):FindFirstChild("MeshPart").CFrame,
                ["Finish Hide"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("Start").CFrame - Vector3.new(0,30,0),
                ["Finish Line Barrier"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("End_Line").CFrame + Vector3.new(0,100,0)
            };
        end)

        --// SBR UI Sections
        local SBRSettingsSection = SBRTab:Section({ Title = "SBR Settings" })
        local AutoSBRSection = SBRTab:Section({ Title = "Auto SBR" })
        local HorseControlsSection = SBRTab:Section({ Title = "Horse Controls" })
        local PlayerTeleportSection = SBRTab:Section({ Title = "Player Teleports" })
        local HorseTeleportSection = SBRTab:Section({ Title = "Horse Teleports" })

        --// Player ESP
        SBRSettingsSection:Toggle({
            Flag = "SBR_PlayerESP",
            Title = "Player ESP",
            Default = false,
            Callback = function(value)
                SBR_Util:SetState("PlayerESP", value)
                if value then
                    local Folder = Instance.new("Folder", game.CoreGui); Folder.Name = "SBR_PlayerESP"
                    local function setupPlayer(plr)
                        if plr == SBR_Util:GetPlayer() then return end
                        local function onChar(Chars)
                            local Highlight = Instance.new("Highlight", Folder); Highlight.OutlineColor = Color3.fromRGB(255, 255, 255); Highlight.Adornee = Chars; Highlight.FillColor = Color3.fromRGB(255, 255, 255); Highlight.FillTransparency = 1
                            local BGui = Instance.new("BillboardGui", Folder); BGui.Adornee = Chars:WaitForChild("Head"); BGui.StudsOffset = Vector3.new(0, 3, 0); BGui.AlwaysOnTop = true; BGui.Size = UDim2.new(4, 0, 0.5, 0)
                            local TextLabel = Instance.new("TextLabel", BGui); TextLabel.Size = UDim2.new(1, 0, 1, 0); TextLabel.BackgroundTransparency = 1; TextLabel.Text = Chars.Name; TextLabel.Font = Enum.Font.Ubuntu; TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255); TextLabel.TextScaled = false
                        end
                        SBR_Util:AddTask("SBR_Chr_"..plr.Name, plr.CharacterAdded:Connect(onChar))
                        if plr.Character then onChar(plr.Character) end
                    end
                    for _, plr in pairs(game.Players:GetPlayers()) do setupPlayer(plr) end
                    SBR_Util:AddTask("SBR_Chr2", game.Players.PlayerAdded:Connect(setupPlayer))
                else
                    if game.CoreGui:FindFirstChild("SBR_PlayerESP") then game.CoreGui.SBR_PlayerESP:Destroy() end
                    SBR_Util:DisconnectTask("SBR_Chr2")
                    for _, plr in pairs(game.Players:GetPlayers()) do SBR_Util:DisconnectTask("SBR_Chr_"..plr.Name) end
                end
            end
        })

        SBRSettingsSection:Toggle({ Flag = "SBR_UseHorse", Title = "Use Horse for Auto SBR", Default = false, Callback = function(value) SBR_Util:SetState("Use_Horse_ASBR", value) end })
        SBRSettingsSection:Slider({ Flag = "SBR_Delay1", Title = "TP to 1st Barrier Delay", Step = 1, Value = {Min = 1, Max = 60, Default = 5}, Callback = function(value) SBR_Util:SetInt("SBR_Delay_1", value) end })
        SBRSettingsSection:Slider({ Flag = "SBR_Delay2", Title = "TP to 2nd Barrier Delay", Step = 1, Value = {Min = 1, Max = 60, Default = 5}, Callback = function(value) SBR_Util:SetInt("SBR_Delay_2", value) end })
        SBRSettingsSection:Slider({ Flag = "SBR_Delay3", Title = "TP to 3rd Barrier Delay", Step = 1, Value = {Min = 1, Max = 60, Default = 5}, Callback = function(value) SBR_Util:SetInt("SBR_Delay_3", value) end })
        SBRSettingsSection:Slider({ Flag = "SBR_Delay4", Title = "TP to Last Barrier Delay", Step = 1, Value = {Min = 1, Max = 60, Default = 5}, Callback = function(value) SBR_Util:SetInt("SBR_Delay_4", value) end })
        SBRSettingsSection:Slider({ Flag = "SBR_Delay5", Title = "TP to End Delay", Step = 1, Value = {Min = 1, Max = 20, Default = 5}, Callback = function(value) SBR_Util:SetInt("SBR_Delay_5", value) end })
        SBRSettingsSection:Slider({ Flag = "SBR_HideDelay", Title = "Hide Delay", Step = 1, Value = {Min = 1, Max = 10, Default = 5}, Callback = function(value) SBR_Util:SetInt("SBR_Delay_Hide", value) end })

        --// Auto SBR
        AutoSBRSection:Toggle({
            Flag = "SBR_AutoRace",
            Title = "Auto SBR",
            Default = false,
            Callback = function(value)
                if value then
                    local HRP = SBR_Util:GetState("Use_Horse_ASBR") and SBR_Util:GetHorse().HumanoidRootPart or SBR_Util:GetHRP()
                    if not HRP then notify("SBR", "Character not loaded!"); return end
                    HRP.CFrame = SBRTeleports["Normal Hide"]
                    repeat task.wait() until workspace.Barrier:FindFirstChild("StartBarrier") == nil
                    task.wait(SBR_Util:GetInt("SBR_Delay_1")); HRP.CFrame = SBRTeleports["Stage 1 Barrier"]
                    task.wait(SBR_Util:GetInt("SBR_Delay_Hide")); HRP.CFrame = SBRTeleports["Normal Hide"]
                    repeat task.wait() until workspace.Barriers:FindFirstChild("1") == nil
                    task.wait(SBR_Util:GetInt("SBR_Delay_2")); HRP.CFrame = SBRTeleports["Stage 2 Barrier"]
                    task.wait(SBR_Util:GetInt("SBR_Delay_Hide")); HRP.CFrame = SBRTeleports["Normal Hide"]
                    repeat task.wait() until workspace.Barriers:FindFirstChild("2") == nil
                    task.wait(SBR_Util:GetInt("SBR_Delay_3")); HRP.CFrame = SBRTeleports["Stage 3 Barrier"]
                    task.wait(SBR_Util:GetInt("SBR_Delay_Hide")); HRP.CFrame = SBRTeleports["Normal Hide"]
                    repeat task.wait() until workspace.Barriers:FindFirstChild("3") == nil
                    task.wait(SBR_Util:GetInt("SBR_Delay_4")); HRP.CFrame = SBRTeleports["Stage 4 Barrier"]
                    task.wait(SBR_Util:GetInt("SBR_Delay_Hide"))
                    repeat task.wait(); HRP.CFrame = SBRTeleports["Finish Hide"] until workspace.Barriers:FindFirstChild("4") == nil
                    task.wait(SBR_Util:GetInt("SBR_Delay_5")); HRP.CFrame = SBRTeleports["Stage 4 Barrier"]
                    task.wait(SBR_Util:GetInt("SBR_Delay_Hide")); HRP.CFrame = SBRTeleports["Finish Hide"]
                end
            end
        })

        AutoSBRSection:Toggle({
            Flag = "SBR_NoClip",
            Title = "Red Barrier No-Clip",
            Default = false,
            Callback = function(value)
                SBR_Util:SetState("RedBarrierNoClip", value)
                pcall(function()
                    for _, v in pairs(workspace.Barrier:GetChildren()) do v.CanCollide = not value end
                    for _, v in pairs(workspace.Barriers:GetChildren()) do v.CanCollide = not value end
                end)
            end
        })

        --// Horse Controls
        HorseControlsSection:Slider({ Flag = "SBR_HorseSpeed", Title = "Horse WalkSpeed", Step = 1, Value = {Min = 0, Max = 120, Default = 16}, Callback = function(value) SBR_Util:SetInt("HorseWalkSpeed", value); local horse = SBR_Util:GetHorse(); if horse then horse.Humanoid.WalkSpeed = value end end })
        HorseControlsSection:Slider({ Flag = "SBR_HorseJump", Title = "Horse JumpPower", Step = 1, Value = {Min = 0, Max = 100, Default = 50}, Callback = function(value) SBR_Util:SetInt("HorseJumpPower", value); local horse = SBR_Util:GetHorse(); if horse then horse.Humanoid.JumpPower = value; pcall(function() SBR_Util:DisconnectTask("HJP") end); SBR_Util:AddTask("HJP", game.UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent) if not gameProcessedEvent and inputObject.KeyCode == Enum.KeyCode.Space then local horse = SBR_Util:GetHorse(); if horse then horse.Humanoid.Jump = true end end end)) end end })
        HorseControlsSection:Button({ Flag = "SBR_TeleportHorse", Title = "Teleport Horse to Me", Callback = function() local horse = SBR_Util:GetHorse(); if horse then horse.PrimaryPart.CFrame = SBR_Util:GetHRP().CFrame else notify("SBR", "Horse not found!") end end })

        --// Player Teleports
        if SBRTeleports and next(SBRTeleports) then
            for place, cframe in pairs(SBRTeleports) do
                PlayerTeleportSection:Button({ Flag = "SBR_PTP_"..place, Title = place, Callback = function() local HRP = SBR_Util:GetHRP(); if HRP then HRP.CFrame = cframe else notify("SBR", "Character not loaded!") end end })
            end
        else
            PlayerTeleportSection:Section({ Title = "Teleports not loaded - try refreshing" })
        end

        PlayerTeleportSection:Button({ Flag = "SBR_PTP_Horse", Title = "Teleport to Horse", Callback = function() local horse = SBR_Util:GetHorse(); if horse and horse:FindFirstChild("HumanoidRootPart") then SBR_Util:GetHRP().CFrame = horse.HumanoidRootPart.CFrame else notify("SBR", "Horse not found!") end end })

        --// Horse Teleports
        if SBRTeleports and next(SBRTeleports) then
            for place, cframe in pairs(SBRTeleports) do
                HorseTeleportSection:Button({ Flag = "SBR_HTP_"..place, Title = place, Callback = function() local horse = SBR_Util:GetHorse(); if horse then horse.PrimaryPart.CFrame = cframe else notify("SBR", "Horse not found!") end end })
            end
        else
            HorseTeleportSection:Section({ Title = "Teleports not loaded - try refreshing" })
        end
    end)
    
    if not success then
        warn("SBR Load Error: " .. tostring(err))
        SBRTab:Section({ Title = "⚠️ Error loading SBR features" })
        SBRTab:Section({ Title = "Error: " .. tostring(err) })
    end
end

--// Execute SBR loader
LoadSBRFeatures()
local TeleportService = game:GetService("TeleportService")
spawn(function()
while true do
wait(1)
pcall(function()
local coreGui = game:GetService("CoreGui")
local prompt = coreGui:FindFirstChild("RobloxPromptGui")
if prompt then
local overlay = prompt:FindFirstChild("promptOverlay")
if overlay then
local errorPrompt = overlay:FindFirstChild("ErrorPrompt")
if errorPrompt and errorPrompt.Visible then
local titleFrame = errorPrompt:FindFirstChild("TitleFrame")
if titleFrame then
local errorTitle = titleFrame:FindFirstChild("ErrorTitle")
if errorTitle and (string.lower(errorTitle.Text):find("disconnect") or string.lower(errorTitle.Text):find("kicked")) then
                                notify("YBA Script", "Detected kick/disconnect. Rejoining the server...")
                                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end
end
                    end
                end
            end
        end)
    end
end)
Window:SetToggleKey(Enum.KeyCode.K)

local Util = {
    States = {};
    Ints = {};
    Strings = {};
    Tables = {};
    Tasks = {};
    Services = setmetatable({}, {__index = function(self, service)
        local GotService = game:GetService(service)
        rawset(self, service, GotService)
        return GotService
    end});
}

function Util:GetPlayer()
    return self.Services.Players.LocalPlayer
end

function Util:GetCharacter()
    return self:GetPlayer().Character or self:GetPlayer().CharacterAdded:Wait()
end

function Util:GetHRP()
    local Character = self:GetCharacter()
    return Character and Character:FindFirstChild("HumanoidRootPart")
end

function Util:GetHumanoid()
    local Character = self:GetCharacter()
    return Character and Character:FindFirstChildWhichIsA("Humanoid")
end

function Util:SetState(key, value)
    self.States[key] = {Value = value}
end

function Util:GetState(key)
    return self.States[key] and self.States[key].Value or false
end

function Util:SetInt(key, value)
    self.Ints[key] = {Value = value}
end

function Util:GetInt(key, default)
    return self.Ints[key] and self.Ints[key].Value or default or 0
end

function Util:SetTable(key, value)
    self.Tables[key] = {Value = value}
end

function Util:GetTable(key)
    return self.Tables[key] and self.Tables[key].Value or {}
end

function Util:InsertTable(key, value)
    local tbl = self:GetTable(key)
    table.insert(tbl, value)
    self:SetTable(key, tbl)
end

function Util:RemoveTable(key, value)
    local tbl = self:GetTable(key)
    local pos = table.find(tbl, value)
    if pos then table.remove(tbl, pos) end
    self:SetTable(key, tbl)
end

function Util:FindTable(key, value)
    return table.find(self:GetTable(key), value)
end

function Util:AddTask(name, task)
    self.Tasks[name] = task
end

function Util:DisconnectTask(name)
    if self.Tasks[name] then
        pcall(function() self.Tasks[name]:Disconnect() end)
        self.Tasks[name] = nil
    end
end

function Util:CountItem(itemName)
    local Backpack = self:GetPlayer().Backpack
    local count = 0
    if Backpack then
        for _, v in pairs(Backpack:GetChildren()) do
            if v.Name == itemName then count = count + 1 end
        end
    end
    local Character = self:GetPlayer().Character
    if Character then
        for _, v in pairs(Character:GetChildren()) do
            if v.Name == itemName then count = count + 1 end
        end
    end
    return count
end

function Util:HasStand()
    return self:GetPlayer().PlayerStats.Stand.Value ~= "None"
end

function Util:CheckStand()
    return self:GetPlayer().PlayerStats.Stand.Value
end

function Util:CheckShiny()
    local Character = self:GetCharacter()
    if Character and Character:FindFirstChild("RemoteFunction") then
        local ok, res = pcall(function()
            return Character.RemoteFunction:InvokeServer("ReturnStandSkin", "Stand")
        end)
        return ok and (res or "None") or "None"
    end
    return "None"
end

function Util:HasShiny()
    local shiny = self:CheckShiny()
    return shiny ~= "None" and shiny ~= nil
end

function Util:IsMax(itemName)
    local max = {
        ["Diamond"] = 30, ["Gold Coin"] = 45, ["Mysterious Arrow"] = 25,
        ["Pure Rokakaka"] = 10, ["Rokakaka"] = 25, ["Stone Mask"] = 10,
        ["Rib Cage of The Saint's Corpse"] = 10, ["Steel Ball"] = 10,
        ["Ancient Scroll"] = 10, ["Dio's Diary"] = 10, ["Caesar's Headband"] = 10,
        ["Christmas Present"] = 45, ["Quinton's Glove"] = 10, ["Lucky Arrow"] = 10
    }
    local ok, owns = pcall(function()
        return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(self:GetPlayer().UserId, 14597778)
    end)
    if ok and owns then
        for k, v in pairs(max) do max[k] = v * 2 end
    end
    return self:CountItem(itemName) >= (max[itemName] or 999)
end

function Util:WaitTillBackpackLoaded()
    local Backpack = self:GetPlayer().Backpack
    local start = tick()
    while tick() - start < 2 do
        if Backpack and #Backpack:GetChildren() > 0 then break end
        task.wait(0.05)
    end
end

function Util:LearnSkills(skills)
    local Character = self:GetCharacter()
    if Character and Character:FindFirstChild("RemoteFunction") then
        for _, skill in pairs(skills) do
            pcall(function()
                Character.RemoteFunction:InvokeServer("LearnSkill", {
                    Skill = skill,
                    SkillTreeType = "Character"
                })
            end)
        end
    end
end

function Util:FindTool(itemName)
    local player = self:GetPlayer()
    local Backpack = player and player.Backpack
    local Character = player and player.Character
    if Backpack then
        for _, v in pairs(Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name == itemName then
                return v
            end
        end
    end
    if Character then
        for _, v in pairs(Character:GetChildren()) do
            if v:IsA("Tool") and v.Name == itemName then
                return v
            end
        end
    end
    return nil
end

function Util:EquipToolByName(itemName, timeout)
    timeout = timeout or 5
    local start = tick()
    while tick() - start < timeout do
        local tool = self:FindTool(itemName)
        if tool and self:GetHumanoid() then
            pcall(function() self:GetHumanoid():EquipTool(tool) end)
            local charTool = self:GetCharacter():FindFirstChildWhichIsA("Tool")
            if charTool and charTool.Name == itemName then
                return true
            end
        end
        task.wait(0.05)
    end
    return false
end

function Util:ClickUntilDialogue()
    local start = tick()
    while tick() - start < 6 do
        if self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui") then
            return true
        end
        pcall(function()
            if game:GetService("VirtualInputManager") then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
            end
        end)
        task.wait(0.06)
    end
    return false
end

function Util:SelectDialogueOption1()
    local start = tick()
    while tick() - start < 6 do
        local dg = self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui")
        if dg and dg.Frame and dg.Frame.Options and dg.Frame.Options:FindFirstChild("Option1") then
            pcall(function()
                if dg.Frame.Options.Option1.TextButton and dg.Frame.Options.Option1.TextButton.MouseButton1Click then
                    dg.Frame.Options.Option1.TextButton.MouseButton1Click:Fire()
                end
            end)
            repeat task.wait() until not self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui") or tick() - start > 8
            return true
        end
        task.wait(0.05)
    end
    return false
end

function Util:UseRoka()
    if self:CountItem("Rokakaka") == 0 and self:CountItem("Pure Rokakaka") == 0 then return end
    if self:GetPlayer().PlayerStats.Stand.Value == "None" then return end

    self:WaitTillBackpackLoaded()
    if not self:EquipToolByName("Rokakaka", 6) then
        self:EquipToolByName("Pure Rokakaka", 6)
    end

    if self:ClickUntilDialogue() then
        self:SelectDialogueOption1()
    end

    self:GetPlayer().CharacterAdded:Wait()
    task.wait(0.25)
end

function Util:UseArrow()
    if self:CountItem("Mysterious Arrow") == 0 and self:CountItem("Lucky Arrow") == 0 then return end
    if self:GetPlayer().PlayerStats.Stand.Value ~= "None" then return end

    self:WaitTillBackpackLoaded()
    if not self:EquipToolByName("Mysterious Arrow", 6) then
        self:EquipToolByName("Lucky Arrow", 6)
    end

    if self:ClickUntilDialogue() then
        self:SelectDialogueOption1()
    end

    self:GetPlayer().CharacterAdded:Wait()
    task.wait(0.25)
end

function Util:UseRib()
    local args = {
        [1] = "EndDialogue",
        [2] = {
            ["NPC"] = "Rib Cage of The Saint's Corpse",
            ["Option"] = "Option1",
            ["Dialogue"] = "Dialogue2"
        }
    }
    pcall(function()
        if self:GetCharacter() and self:GetCharacter().RemoteEvent then
            self:GetCharacter().RemoteEvent:FireServer(unpack(args))
        end
    end)
end

function Util:FarmItems(itemList)
    for _, itemName in pairs(itemList) do
        if self:CountItem(itemName) == 0 and not self:IsMax(itemName) then
            local itemsFolder = workspace:FindFirstChild("Item_Spawns") and workspace.Item_Spawns:FindFirstChild("Items")
            if itemsFolder then
                for _, item in pairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then
                        local prompt = item:FindFirstChild("ProximityPrompt")
                        if prompt and item.PrimaryPart then
                            local start = tick()
                            self:GetHRP().CFrame = item.PrimaryPart.CFrame - v3(0, 10, 0)
                            repeat
                                task.wait()
                                pcall(function() fireproximityprompt(prompt) end)
                                if item.PrimaryPart then
                                    self:GetHRP().CFrame = item.PrimaryPart.CFrame - v3(0, 10, 0)
                                end
                            until item.Parent ~= itemsFolder or tick() - start >= 5
                            task.wait(0.6)
                        end
                    end
                end
            end
        end
    end
end

function Util:Stats()
    local skills = {"Agility I", "Agility II", "Agility III", "Worthiness"}
    if self:GetState("Rib Farm") then
        table.insert(skills, "Worthiness II")
        table.insert(skills, "Worthiness III")
        table.insert(skills, "Worthiness IV")
        table.insert(skills, "Worthiness V")
    end
    self:LearnSkills(skills)
end

Util:SetState("Stand Farming", false)
Util:SetState("Rib Farm", false)
Util:SetState("Arrow Pity Farm", false)
Util:SetState("Rib Pity Farm", false)
Util:SetState("Use Redeemed", false)
Util:SetState("Keep any shiny", false)
Util:SetInt("Pity Amount", 20)
Util:SetTable("Stands", {})
Util:SetTable("Shinys", {})

-- Create Single Tab: Stand Farming

local SettingsSection = StandFarmTab:Section({
    Title = "Farm Settings"
})

SettingsSection:Toggle({
    Flag = "ArrowPityFarm",
    Title = "Arrow Pity Farm",
    Default = false,
    Callback = function(State)
        Util:SetState("Arrow Pity Farm", State)
        if State then
            Window:Notify({
                Title = "Warning",
                Content = "Requires Stand Farm enabled",
                Icon = "alert-triangle"
            })
        end
    end
})

SettingsSection:Toggle({
    Flag = "RibPityFarm",
    Title = "Rib Pity Farm",
    Default = false,
    Callback = function(State)
        Util:SetState("Rib Pity Farm", State)
        if State then
            Window:Notify({
                Title = "Warning",
                Content = "Requires Rib Farm enabled",
                Icon = "alert-triangle"
            })
        end
    end
})

SettingsSection:Slider({
    Flag = "PityAmount",
    Title = "Pity Amount",
    Step = 1,
    Value = {
        Min = 20,
        Max = 125,
        Default = 20
    },
    Callback = function(Value)
        Util:SetInt("Pity Amount", Value)
    end
})

SettingsSection:Toggle({
    Flag = "UseRedeemed",
    Title = "Use Redeemed Items",
    Default = false,
    Callback = function(State)
        Util:SetState("Use Redeemed", State)
    end
})

SettingsSection:Toggle({
    Flag = "KeepShiny",
    Title = "Keep Any Shiny",
    Default = false,
    Callback = function(State)
        Util:SetState("Keep any shiny", State)
    end
})

SettingsTab:Dropdown({
    Flag = "Theme Selector",
    Title = "Theme Selector",
    Default = "scrilisk theme",
    Values = {"scrilisk theme", "kazakori theme", "michaels theme", "king crimson"},
    Callback = function(selected)
        WindUI:SetTheme(selected)
    end
})


local StandFarmSection = StandFarmTab:Section({
    Title = "Stand Farm"
})

StandFarmSection:Toggle({
    Flag = "StandFarm",
    Title = "Enable Stand Farm",
    Default = false,
    Callback = function(State)
        Util:SetState("Stand Farming", State)
        
        if State then
            pcall(function() Util:GetHRP().CFrame = cf(v3(-324, -32, 47)) end)
            if not Util.Tasks.SafeFarm then
                Util:AddTask("SafeFarm", Util:GetPlayer().CharacterAdded:Connect(function(Char)
                    task.wait(0.15)
                    pcall(function() Char.PrimaryPart.CFrame = cf(v3(-324, -32, 47)) end)
                end))
            end

            task.spawn(function()
                task.wait(0.2)
                if (Util:CountItem("Rokakaka") > 0 or Util:CountItem("Pure Rokakaka") > 0) and (Util:CountItem("Mysterious Arrow") > 0 or Util:CountItem("Lucky Arrow") > 0) then
                    pcall(function() Util:UseRoka() end)
                    pcall(function() Util:WaitTillBackpackLoaded() end)
                    pcall(function() Util:UseArrow() end)
                end
            end)
        else
            Util:DisconnectTask("SafeFarm")
        end
        
        while Util:GetState("Stand Farming") do
            if Util:CountItem("Mysterious Arrow") == 0 or Util:CountItem("Rokakaka") == 0 then
                Util:FarmItems({"Mysterious Arrow", "Rokakaka"})
            end
            
            if Util:HasStand() and Util:FindTable("Stands", Util:CheckStand()) then
                Window:Notify({
                    Title = "Stand Obtained!",
                    Content = Util:CheckStand(),
                    Icon = "check"
                })
                break
            end
            
            if Util:HasStand() then
                Util:UseRoka()
                repeat task.wait() until not Util:HasStand()
            else
                Util:Stats()
                Util:UseArrow()
                repeat task.wait() until Util:HasStand()
            end
            
            task.wait(1)
        end
    end
})

local RibFarmSection = StandFarmTab:Section({
    Title = "Rib Farm"
})

RibFarmSection:Toggle({
    Flag = "RibFarm",
    Title = "Enable Rib Farm",
    Default = false,
    Callback = function(State)
        Util:SetState("Rib Farm", State)
        
        if State then
            pcall(function() Util:GetHRP().CFrame = cf(v3(-324, -32, 47)) end)
            if not Util.Tasks.SafeFarm then
                Util:AddTask("SafeFarm", Util:GetPlayer().CharacterAdded:Connect(function(Char)
                    task.wait(0.15)
                    pcall(function() Char.PrimaryPart.CFrame = cf(v3(-324, -32, 47)) end)
                end))
            end
        else
            Util:DisconnectTask("SafeFarm")
        end
        
        while Util:GetState("Rib Farm") do
            if Util:CountItem("Rib Cage of The Saint's Corpse") == 0 then
                Util:FarmItems({"Rib Cage of The Saint's Corpse"})
            end
            
            Util:Stats()
            Util:UseRib()
            repeat task.wait() until Util:HasStand()
            
            task.wait(1)
        end
    end
})

local StandSelectSection = StandFarmTab:Section({
    Title = "Stand Selection (28 stands)"
})

local standNames = {"Whitesnake", "Stone Free", "Star Platinum", "The World", "Crazy Diamond", "Killer Queen", "Gold Experience", "King Crimson", "Silver Chariot", "Hermit Purple", "The Hand", "Purple Haze", "Cream", "Hierophant Green", "Magician's Red", "White Album", "Aerosmith", "Six Pistols", "Beach Boy", "Mr. President", "Sticky Fingers", "Anubis", "Red Hot Chili Pepper", "Scary Monsters", "The World Alternate Universe", "D4C", "Tusk ACT 1", "Soft & Wet"}

for _, stand in pairs(standNames) do
    StandSelectSection:Toggle({
        Flag = "Stand_" .. stand:gsub("%s", ""),
        Title = stand,
        Default = false,
        Callback = function(State)
            if State then
                if not Util:FindTable("Stands", stand) then
                    Util:InsertTable("Stands", stand)
                end
            else
                Util:RemoveTable("Stands", stand)
            end
        end
    })
end

local InfoSection = StandFarmTab:Section({
    Title = "Stand Info"
})

local PityLabel = InfoSection:Label({
    Title = "Pity: 0 (1%)"
})

local StandLabel = InfoSection:Label({
    Title = "Stand: None"
})

local ShinyLabel = InfoSection:Label({
    Title = "Shiny: None"
})

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local pity = Util:GetPlayer().PlayerStats.PityCount.Value
            PityLabel:UpdateAsset("Pity: " .. pity .. " (" .. ((pity * 0.04) + 1) .. "%)")
            StandLabel:UpdateAsset("Stand: " .. Util:CheckStand())
            ShinyLabel:UpdateAsset("Shiny: " .. (Util:CheckShiny() or "None"))
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        if Util:GetState("Stand Farming") and Util:GetState("Arrow Pity Farm") then
            local targetPity = Util:GetInt("Pity Amount")
            local currentPity = Util:GetPlayer().PlayerStats.PityCount.Value
            
            if currentPity >= targetPity then
                Util:GetPlayer():Kick("Reached target pity: " .. targetPity)
            end
            
            if Util:HasStand() and currentPity < targetPity then
                Util:UseRoka()
                repeat task.wait() until not Util:HasStand()
            elseif not Util:HasStand() then
                Util:Stats()
                Util:UseArrow()
                repeat task.wait() until Util:HasStand()
            end
        end
        
        if Util:GetState("Rib Farm") and Util:GetState("Rib Pity Farm") then
            local targetPity = Util:GetInt("Pity Amount")
            local currentPity = Util:GetPlayer().PlayerStats.PityCount.Value
            
            if currentPity >= targetPity then
                Util:GetPlayer():Kick("Reached target pity: " .. targetPity)
            end
            
            Util:Stats()
            Util:UseRib()
            repeat task.wait() until Util:HasStand()
        end
    end
end)

Window:Notify({
    Title = "Stand Farming",
    Content = "Script loaded successfully!",
    Icon = "check"
})
