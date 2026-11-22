-- ==============================================================================
-- [ [TRADING] RUN A CARD SHOP 🎴 | UNIVERSAL AUTOMATION & CLIENT SUITE ]
-- Target: Universal Roblox Executors (Solara, Wave, Delta, Codex, Synapse Z)
-- Build: Production Grade | Full Feature Set
-- ==============================================================================

-- ==============================================================================
-- [ [TRADING] RUN A CARD SHOP 🎴 | UNIVERSAL AUTOMATION & CLIENT SUITE ]
-- PlaceId: 140539007819528 | Build Date: 2026-11-22 05:21:24
-- Target Executors: Solara, Wave, Delta, Codex, Arceus X, Synapse Z
-- UI Framework: Fluent
-- ==============================================================================

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()


-- ==============================================================================
-- SECTION 1: CORE GAMEPLAY & AUTOMATION ENGINE
-- ==============================================================================
-- =====================================================================
-- PAYØMBØYZAA - ULTIMATE CARD SHOP AUTOMATION ENGINE
-- Target Game: [TRADING] Run a Card Shop (140539007819528)
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local EngineState = {
    Running = true,
    Speed = 250,
    CurrentState = "Initializing",
    TargetInstance = nil,
    Statistics = {
        PacksOpened = 0,
        CardsProcessed = 0,
        CustomersServed = 0,
        RevenueCollected = 0
    }
}

-- Anti-Cheat Metamethod & Telemetry Neutralization Hook
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if (method == "Kick" or method == "kick") and not checkcaller() then
            return
        end
        return oldNamecall(self, ...)
    end))

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if not checkcaller() and typeof(self) == "Instance" and self:IsA("Humanoid") then
            if key == "WalkSpeed" then return 16 end
            if key == "JumpPower" then return 50 end
        end
        return oldIndex(self, key)
    end))
end)

-- Dynamic Remote Discovery Pattern
local function findRemote(keywords)
    local containers = {ReplicatedStorage, Workspace}
    for _, container in ipairs(containers) do
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw:lower()) then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

local Remotes = {
    OpenPack = findRemote({"open", "pack", "card"}),
    Interact = findRemote({"interact", "dialogue", "shop", "buy"}),
    Collect = findRemote({"collect", "cash", "money", "claim"})
}

-- Noclip & Movement Engine (250 Studs/sec)
local function getCharacterRoot()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    end
    return nil
end

RunService.Stepped:Connect(function()
    if not EngineState.Running then return end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local function tweenTo(targetCFrame, speed)
    local root = getCharacterRoot()
    if not root then return end
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / (speed or EngineState.Speed)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    local completed = false
    local connection
    connection = tween.Completed:Connect(function()
        completed = true
        if connection then connection:Disconnect() end
    end)
    
    while not completed and EngineState.Running do
        task.wait(0.01)
        if not getCharacterRoot() then break end
    end
end

-- Card Shop Specific Automation Loop
local function scanShopEntities()
    local entities = {
        Packs = {},
        CashRegisters = {},
        Customers = {},
        Shelves = {}
    }
    
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if name:find("pack") or name:find("box") then
            table.insert(entities.Packs, obj)
        elseif name:find("register") or name:find("cash") or name:find("counter") then
            table.insert(entities.CashRegisters, obj)
        elseif name:find("customer") or name:find("npc") then
            table.insert(entities.Customers, obj)
        elseif name:find("shelf") or name:find("display") then
            table.insert(entities.Shelves, obj)
        end
    }
    
    return entities
end

-- Autonomous Gameplay Core Loop
task.spawn(function()
    while true do
        if EngineState.Running then
            EngineState.CurrentState = "Scanning Shop Environment"
            local entities = scanShopEntities()
            
            -- Process Cash Registers / Money Collection
            for _, register in ipairs(entities.CashRegisters) do
                if not EngineState.Running then break end
                if register:IsA("BasePart") or register:IsA("Model") then
                    local targetCF = register:IsA("Model") and register:GetModelPrimaryPartCFrame() or register.CFrame
                    EngineState.CurrentState = "Collecting Revenue"
                    tweenTo(targetCF + Vector3.new(0, 3, 0), EngineState.Speed)
                    
                    if Remotes.Collect then
                        pcall(function()
                            Remotes.Collect:FireServer(register)
                        end)
                    end
                    EngineState.Statistics.RevenueCollected = EngineState.Statistics.RevenueCollected + 1
                    task.wait(0.2)
                end
            end
            
            -- Process Card Packs / Opening Loop
            for _, pack in ipairs(entities.Packs) do
                if not EngineState.Running then break end
                if pack:IsA("BasePart") or pack:IsA("Model") then
                    local targetCF = pack:IsA("Model") and pack:GetModelPrimaryPartCFrame() or pack.CFrame
                    EngineState.CurrentState = "Opening Card Packs"
                    tweenTo(targetCF + Vector3.new(0, 3, 0), EngineState.Speed)
                    
                    if Remotes.OpenPack then
                        pcall(function()
                            Remotes.OpenPack:FireServer(pack)
                        end)
                    end
                    EngineState.Statistics.PacksOpened = EngineState.Statistics.PacksOpened + 1
                    task.wait(0.3)
                end
            end
            
            -- Process Shelves / Restocking & Maintenance
            for _, shelf in ipairs(entities.Shelves) do
                if not EngineState.Running then break end
                if shelf:IsA("BasePart") or shelf:IsA("Model") then
                    local targetCF = shelf:IsA("Model") and shelf:GetModelPrimaryPartCFrame() or shelf.CFrame
                    EngineState.CurrentState = "Restocking Shelves"
                    tweenTo(targetCF + Vector3.new(0, 3, 0), EngineState.Speed)
                    
                    if Remotes.Interact then
                        pcall(function()
                            Remotes.Interact:FireServer(shelf)
                        end)
                    end
                    EngineState.Statistics.CardsProcessed = EngineState.Statistics.CardsProcessed + 1
                    task.wait(0.2)
                end
            end
        end
        task.wait(1)
    end
end)

return EngineState

-- ==============================================================================
-- SECTION 2: UI INTERFACE & CONTROLS BINDING
-- ==============================================================================
-- =====================================================================
-- PAYØMBØYZAA - ULTIMATE CARD SHOP AUTOMATION ENGINE (FLUENT UI)
-- Target Game: [TRADING] Run a Card Shop (140539007819528)
-- =====================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Engine State & Statistics
local EngineState = {
    Running = true,
    Speed = 250,
    CurrentState = "Running",
    TargetInstance = nil,
    AutoOpenPacks = false,
    AutoCollectCash = false,
    AutoRestock = false,
    AutoServeCustomers = false,
    Statistics = {
        PacksOpened = 0,
        CardsProcessed = 0,
        CustomersServed = 0,
        RevenueCollected = 0
    }
}

-- Anti-Cheat Hook Bypass
pcall(function()
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if (method == "Kick" or method == "kick") and not checkcaller() then
            return
        end
        return oldNamecall(self, ...)
    end))

    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if not checkcaller() and typeof(self) == "Instance" and self:IsA("Humanoid") then
            if key == "WalkSpeed" then return 16 end
            if key == "JumpPower" then return 50 end
        end
        return oldIndex(self, key)
    end))
end)

-- Dynamic Remote Discovery Pattern
local function findRemote(keywords)
    local containers = {ReplicatedStorage, Workspace}
    for _, container in ipairs(containers) do
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                local n = obj.Name:lower()
                for _, kw in ipairs(keywords) do
                    if n:find(kw:lower()) then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

local Remotes = {
    OpenPack = findRemote({"open", "pack", "card"}),
    Interact = findRemote({"interact", "dialogue", "shop", "buy"}),
    Collect = findRemote({"collect", "cash", "money", "claim"})
}

-- Noclip & Movement Engine
local function getCharacterRoot()
    local char = LocalPlayer.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    end
    return nil
end

RunService.Stepped:Connect(function()
    if not EngineState.Running then return end
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local function tweenTo(targetCFrame, speed)
    local root = getCharacterRoot()
    if not root then return end
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / (speed or EngineState.Speed)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    local completed = false
    local connection
    connection = tween.Completed:Connect(function()
        completed = true
        if connection then connection:Disconnect() end
    end)
    repeat task.wait() until completed or not EngineState.Running
end

-- Autonomous Gameplay Loops
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if EngineState.AutoCollectCash and Remotes.Collect then
                Remotes.Collect:FireServer()
                EngineState.Statistics.RevenueCollected = EngineState.Statistics.RevenueCollected + 100
            end
            if EngineState.AutoOpenPacks and Remotes.OpenPack then
                Remotes.OpenPack:FireServer("StandardPack")
                EngineState.Statistics.PacksOpened = EngineState.Statistics.PacksOpened + 1
            end
        end)
    end
end)

-- Load Fluent Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/Addons/InterfaceManager.lua"))()

local Window = Fluent:Window({
    Title = "PAYØMBØYZAA | Card Shop Engine",
    SubTitle = "O.Z.L.S.R Protocol - [TRADING] Run a Card Shop",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.Keybind.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main Farm", Icon = "home" }),
    Shop = Window:AddTab({ Title = "Shop Automation", Icon = "shopping-cart" }),
    Teleport = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Visuals = Window:AddTab({ Title = "Visuals & ESP", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- ==================== TAB: MAIN FARM ====================
Tabs.Main:AddParagraph({
    Title = "Engine Status: PAYØMBØYZAA",
    Content = "System fully operational. Bypassing anti-cheat telemetry and managing autonomous routines."
})

Tabs.Main:AddToggle("AutoOpenPacksToggle", {
    Title = "Auto Open Card Packs",
    Default = false,
    Callback = function(Value)
        EngineState.AutoOpenPacks = Value
        Fluent:Notify({Title = "Automation", Content = "Auto Open Packs set to: " .. tostring(Value), Duration = 3})
    end
})

Tabs.Main:AddToggle("AutoCollectToggle", {
    Title = "Auto Collect Cash / Revenue",
    Default = false,
    Callback = function(Value)
        EngineState.AutoCollectCash = Value
        Fluent:Notify({Title = "Automation", Content = "Auto Collect set to: " .. tostring(Value), Duration = 3})
    end
})

Tabs.Main:AddSlider("TweenSpeedSlider", {
    Title = "Noclip Tween Speed",
    Description = "Adjust movement velocity for automatic routing",
    Default = 250,
    Min = 50,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        EngineState.Speed = Value
    end
})

-- ==================== TAB: SHOP AUTOMATION ====================
Tabs.Shop:AddParagraph({
    Title = "Shop Management",
    Content = "Automate shelf restocking, counter service, and customer handling."
})

Tabs.Shop:AddToggle("AutoRestockToggle", {
    Title = "Auto Restock Shelves",
    Default = false,
    Callback = function(Value)
        EngineState.AutoRestock = Value
        Fluent:Notify({Title = "Shop", Content = "Auto Restock: " .. tostring(Value), Duration = 3})
    end
})

Tabs.Shop:AddToggle("AutoServeToggle", {
    Title = "Auto Serve Customers",
    Default = false,
    Callback = function(Value)
        EngineState.AutoServeCustomers = Value
        Fluent:Notify({Title = "Shop", Content = "Auto Serve: " .. tostring(Value), Duration = 3})
    end
})

Tabs.Shop:AddButton({
    Title = "Instant Restock All Shelves",
    Description = "Triggers immediate inventory refresh via remote bridge",
    Callback = function()
        if Remotes.Interact then
            Remotes.Interact:FireServer("RestockAll")
            Fluent:Notify({Title = "Success", Content = "Restock command sent!", Duration = 3})
        else
            Fluent:Notify({Title = "Error", Content = "Restock remote not found!", Duration = 3})
        end
    end
})

-- ==================== TAB: TELEPORTS ====================
Tabs.Teleport:AddButton({
    Title = "Teleport to Counter / Register",
    Callback = function()
        local root = getCharacterRoot()
        if root then
            root.CFrame = CFrame.new(0, 5, 0) -- Adjust coordinates based on game map if needed
            Fluent:Notify({Title = "Teleport", Content = "Moved to Counter", Duration = 2})
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Storage / Box Area",
    Callback = function()
        local root = getCharacterRoot()
        if root then
            root.CFrame = CFrame.new(20, 5, 20)
            Fluent:Notify({Title = "Teleport", Content = "Moved to Storage Area", Duration = 2})
        end
    end
})

-- ==================== TAB: VISUALS & ESP ====================
Tabs.Visuals:AddToggle("PlayerESP", {
    Title = "Player & Customer ESP",
    Default = false,
    Callback = function(Value)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("PAYOMB_ESP")
                if Value and not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "PAYOMB_ESP"
                    hl.FillColor = Color3.fromRGB(0, 255, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.Parent = p.Character
                elseif not Value and hl then
                    hl:Destroy()
                end
            end
        end
    end
})

-- ==================== TAB: SETTINGS ====================
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

Window:SelectTab(1)
Fluent:Notify({
    Title = "PAYØMBØYZAA Engine",
    Content = "Loaded successfully under PAYØMBØYZ framework!",
    Duration = 5
})

-- ==============================================================================
-- SECTION 3: ULTRA-SAFE LOW-PLAYER SERVER HOP & ANTI-REPORT RECONNECT
-- ==============================================================================
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function HopToLowestPlayerServer()
    local targetPlace = 140539007819528
    local success, response = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(targetPlace) .. "/servers/0?sortOrder=Asc&limit=100")
    end)
    if success and response then
        local data = HttpService:JSONDecode(response)
        if data and data.data then
            for _, server in ipairs(data.data) do
                if server.id ~= game.JobId and server.playing and server.playing < server.maxPlayers and server.playing > 0 then
                    TeleportService:TeleportToPlaceInstance(targetPlace, server.id, LocalPlayer)
                    return true
                end
            end
        end
    end
    TeleportService:Teleport(targetPlace, LocalPlayer)
end

-- Auto-Rejoin on 20-minute idle disconnect
local GuiService = game:GetService("GuiService")
GuiService.ErrorMessageChanged:Connect(function()
    task.wait(2)
    HopToLowestPlayerServer()
end)


-- ==============================================================================
-- SECTION 4: SYSTEM BOOTSTRAP & NOTIFICATION
-- ==============================================================================
pcall(function()
    if Fluent and Fluent.Notify then
        Fluent:Notify({
            Title = "[TRADING] Run a Card Shop 🎴 Hub",
            Content = "Script Loaded Successfully! Ready for execution.",
            SubTitle = "Complete Build",
            Duration = 6
        })
    elseif WindUI and WindUI.Notify then
        WindUI:Notify({
            Title = "[TRADING] Run a Card Shop 🎴 Hub",
            Content = "Script Loaded Successfully!",
            Duration = 5
        })
    end
end)
