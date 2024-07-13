-- Import Libraries
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/UI-Libraries/main/Vynixius/Source.lua"))()
local plr = game.Players.LocalPlayer
local keysfr = game:GetService("VirtualInputManager")
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = game.Players.LocalPlayer.Character.Humanoid
local ProximityPromptService = game:GetService("ProximityPromptService")
local entitynames = {"RushMoving","AmbushMoving","Snare","A60","A120"}
local Players = game:GetService("Players"):GetChildren()
local RunService = game:GetService("RunService")

-- Create Window
local Window = Library:AddWindow({
    title = {"Shadow Scripts", "Doors Script v1.0"},
    theme = {
        Accent = Color3.fromRGB(0, 255, 0)
    },
    key = Enum.KeyCode.RightControl,
    default = true
})

-- Create Main Tab
local MainTab = Window:AddTab("Main", {default = true})

-- Create Main Section
local MainSection = MainTab:AddSection("Main Controls", {default = true})

-- Create SubSection for ESP
local ESPSubSection = MainSection:AddSubSection("ESP")

-- Initialize ESP
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
ESP.Players = false
ESP.Boxes = false
ESP.Names = true
ESP.Tracers = false
ESP:Toggle(true)

-- ESP Toggles
ESPSubSection:AddToggle("ESP Players", {flag = "ESPPlayers", default = ESP.Players}, function(bool)
    ESP.Players = bool
end)

ESPSubSection:AddToggle("ESP Boxes", {flag = "ESPBoxes", default = ESP.Boxes}, function(bool)
    ESP.Boxes = bool
end)

ESPSubSection:AddToggle("ESP Names", {flag = "ESPNames", default = ESP.Names}, function(bool)
    ESP.Names = bool
end)

ESPSubSection:AddToggle("ESP Tracers", {flag = "ESPTracers", default = ESP.Tracers}, function(bool)
    ESP.Tracers = bool
end)

local esptable = {
    doors = {},
    keys = {},
    entity = {},
    lockers = {},
    chests = {}
}

-- Door ESP Toggle
MainSection:AddToggle("Door ESP", {flag = "DoorESP", default = false}, function(bool)
    ESP.DoorESPEnabled = bool
    if bool then
        local function setup(room)
            local door = room:WaitForChild("Door")
            task.wait(0.1)
            ESP:AddObjectListener(door, {
                Name = "Door",
                CustomName = "Door [".. door.Sign.Stinker.Text .. "]",
                Color = Color3.fromRGB(255, 240, 0),
                IsEnabled = "DoorESPEnabled"
            })
            table.insert(esptable.doors, door)
            
            door:WaitForChild("Door"):WaitForChild("Open").Played:Connect(function()
                -- Hide the door ESP when door opens
                print("Ong door open")
                local doorBox = ESP:GetBox(door)
                if doorBox then
                    doorBox:Remove()
                end
            end)
        end

        local addconnect
        addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
            setup(room)
        end)
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            if room:FindFirstChild("Assets") then
                setup(room) 
            end
        end
    else
        ESP.DoorESPEnabled = false
        for _, door in pairs(esptable.doors) do
            local doorBox = ESP:GetBox(door)
            if doorBox then
                doorBox:Remove()
            end
        end
        esptable.doors = {} -- Clear the table of doors
    end
end)


-- Entity Notifier Toggle
MainSection:AddToggle("Entity Notifier", {flag = "EntityNotifierToggle", default = false}, function(bool)
    if bool then
        Library:Notify({title = "Entity Notifier", text = "enabled", duration = 1, color = Color3.fromRGB(115, 50, 50)})
        addconnect = workspace.ChildAdded:Connect(function(v)
            if table.find(entitynames, v.Name) then
                repeat task.wait() until plr:DistanceFromCharacter(v:GetPivot().Position) < 1000 or not v:IsDescendantOf(workspace)
                
                if v:IsDescendantOf(workspace) then
                    Library:Notify({title = "Entity Notifier", text = (v.Name:gsub("Moving", ""):lower() .. " is coming go hide"), duration = 10, color = Color3.fromRGB(115, 50, 50)})
                end
            end
        end)
    else
        if addconnect then
            addconnect:Disconnect()
            addconnect = nil
        end
        print("Entity Notifier disabled")
        Library:Notify({title = "Entity Notifier", text = "disabled", duration = 1, color = Color3.fromRGB(115, 50, 50)})
    end
end)
 print("no")

-- Key / Lever ESP Toggle
MainSection:AddToggle("Key / Lever ESP", {flag = "KeyLeverESP", default = false}, function(bool)
    ESP.PuzzleItemesp = bool
            local function check(v)
                    if v:IsA("Model") and (v.Name == "LeverForGate" or v.Name == "KeyObtain") then
                        task.wait(0.1)
                        if v.Name == "KeyObtain" then
                            local hitbox = v:WaitForChild("Hitbox")
                            local parts = hitbox:GetChildren()
                            
                            ESP:AddObjectListener(v, {
                            Name = "Hitbox",
                            CustomName = "Key",
                            Color = Color3.fromRGB(255, 240, 0),
                            IsEnabled = "PuzzleItemesp"
                            })
                            table.insert(esptable.keys, hitbox)
                            
                        elseif v.Name == "LeverForGate" then
                            table.insert(esptable.keys,v)
                            ESP:AddObjectListener(v, {
                            Name = v.PrimaryPart.Name,
                            CustomName = "Lever",
                            Color = Color3.fromRGB(255, 240, 0),
                            IsEnabled = "PuzzleItemesp"
                        })
                            
                            
                        end
                    end
                end
                    local function setup(room)
                    local assets = room:WaitForChild("Assets")
                    
                    assets.DescendantAdded:Connect(function(v)
                        check(v) 
                    end)
                        
                    for i,v in pairs(assets:GetDescendants()) do
                        check(v)
                    end 
                end
                
                local addconnect
                addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
                    setup(room)
                end)
                
                for i,room in pairs(workspace.CurrentRooms:GetChildren()) do
                    if room:FindFirstChild("Assets") then
                        setup(room) 
                    end
                end
                
                repeat task.wait() until not ESP.PuzzleItemesp
                addconnect:Disconnect()
                
                esptable.keys = {}
end)

-- Entity ESP Toggle
MainSection:AddToggle("Entity ESP", {flag = "MonsterESP", default = false}, function(bool)
    ESP.RushEspAmbushEspAndShit = bool
    if bool then
        local addconnect
        addconnect = workspace.ChildAdded:Connect(function(v)
            if table.find(entitynames, v.Name) then
                task.wait(0.1)
                ESP:AddObjectListener(v, {
                    Name = v.PrimaryPart.Name,
                    CustomName = v.Name:gsub("Moving", ""),
                    Color = Color3.fromRGB(255, 0, 0),
                    PrimaryPart = v.PrimaryPart,
                    IsEnabled = "RushEspAmbushEspAndShit"
                })
                table.insert(esptable.entity, v)
            end
        end)
        
        local function setup(room)
            if room.Name == "50" or room.Name == "100" then
                local figuresetup = room:WaitForChild("FigureSetup")
                if figuresetup then
                    local fig = figuresetup:WaitForChild("FigureRagdoll")
                    task.wait(0.1)
                        ESP:AddObjectListener(fig, {
                        Name = fig.PrimaryPart.Name,
                        CustomName = "Figure",
                        Color = Color3.fromRGB(255, 25, 25),
                        PrimaryPart = fig.PrimaryPart,
                        IsEnabled = "RushEspAmbushEspAndShit"
                    })
                    table.insert(esptable.entity, fig)
                end
            else
                local assets = room:WaitForChild("Assets")
                local function check(v)
                    if v:IsA("Model") and table.find(entitynames, v.Name) then
                        task.wait(0.1)
                         ESP:AddObjectListener(v, {
                            Name = v.PrimaryPart.Name,
                            CustomName = "Snare",
                            Color = Color3.fromRGB(255, 0, 0),
                            IsEnabled = "RushEspAmbushEspAndShit"
                        })
                        table.insert(esptable.entity, v)
                    end
                end
                
                assets.DescendantAdded:Connect(function(v)
                    check(v)
                end)
                
                for _, v in pairs(assets:GetDescendants()) do
                    check(v)
                end
            end
        end
        
        local roomconnect
        roomconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
            setup(room)
        end)
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            setup(room)
        end
        
        repeat task.wait() until not ESP.RushEspAmbushEspAndShit
        addconnect:Disconnect()
        roomconnect:Disconnect()
        
        esptable.entity = {}
    end
end)

-- Closet ESP Toggle
MainSection:AddToggle("Wardrobe ESP", {flag = "CabinetsESP", default = false}, function(bool)
    ESP.HidingPlaceESPFr = bool
    if bool then
        local function check(v)
            if v:IsA("Model") then
                task.wait(0.1)
                if v.Name == "Wardrobe" then
                        ESP:AddObjectListener(v, {
                        Name = v.PrimaryPart.Name,
                        CustomName = "Wardrobe",
                        Color = Color3.fromRGB(145, 100, 25),
                        IsEnabled = "HidingPlaceESPFr"
                    })
                    table.insert(esptable.lockers, v)
                elseif (v.Name == "Rooms_Locker" or v.Name == "Rooms_Locker_Fridge") then
                    ESP:AddObjectListener(v, {
                        Name = v.PrimaryPart.Name,
                        CustomName = "Locker",
                        Color = Color3.fromRGB(145, 100, 25),
                        IsEnabled = "HidingPlaceESPFr"
                    })
                    table.insert(esptable.lockers, v)
                elseif v.Name == "Toolshed" then
                    ESP:AddObjectListener(v, {
                        Name = v.PrimaryPart.Name,
                        CustomName = "Shed",
                        Color = Color3.fromRGB(145, 100, 25),
                        IsEnabled = "HidingPlaceESPFr"
                    })
                    table.insert(esptable.lockers, v)
                end
            end
        end
        
        local function setup(room)
            local assets = room:WaitForChild("Assets")
            if assets then
                local subaddcon
                subaddcon = assets.DescendantAdded:Connect(function(v)
                    check(v)
                end)
                
                for _, v in pairs(assets:GetDescendants()) do
                    check(v)
                end
                
                task.spawn(function()
                    repeat task.wait() until not ESP.HidingPlaceESPFr
                    subaddcon:Disconnect()
                end)
            end
        end
        
        local addconnect
        addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
            setup(room)
        end)
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            setup(room)
        end
        
        repeat task.wait() until not ESP.HidingPlaceESPFr
        addconnect:Disconnect()
        
        esptable.lockers = {}
    end
end)

-- Chest ESP Toggle
MainSection:AddToggle("Chest ESP", {flag = "TreasureESP", default = false}, function(bool)
    ESP.chestespfrommc = bool
    if bool then
        local function check(v)
            if v:IsA("Model") then
                task.wait(0.1)
                if v.Name == "ChestBox" then
                    ESP:AddObjectListener(v, {
                        Name = v.PrimaryPart.Name,
                        CustomName = "Chest",
                        Color = Color3.fromRGB(205, 120, 255),
                        IsEnabled = "chestespfrommc"
                    })
                    table.insert(esptable.chests, v)
                end
            end
        end
        
        local function setup(room)
            local assets = room:WaitForChild("Assets")
            if assets then
                local subaddcon
                subaddcon = assets.DescendantAdded:Connect(function(v)
                    check(v)
                end)
                
                for _, v in pairs(assets:GetDescendants()) do
                    check(v)
                end
                
                task.spawn(function()
                    repeat task.wait() until not ESP.chestespfrommc
                    subaddcon:Disconnect()
                end)
            end
        end
        
        local addconnect
        addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
            setup(room)
        end)
        
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            setup(room)
        end
        
        repeat task.wait() until not ESP.chestespfrommc
        addconnect:Disconnect()
        
        esptable.chests = {}
    end
end)

Toggle = Section:AddToggle("Books ESP", {flag = "Door100/50Itemesp", default = false}, function(bool)
ESP.Door50BooksEspfr = bool
  local function check(v)
            if v:IsA("Model") and (v.Name == "LiveHintBook" or v.Name == "LiveBreakerPolePickup") then
                task.wait(0.1)
                
                ESP:AddObjectListener(v, {
                        Name = v.PrimaryPart.Name,
                        CustomName = v.Name,
                        Color = Color3.fromRGB(255, 255, 255),
                        IsEnabled = "Door50BooksEspfr"
                    })
                table.insert(esptable.books,v)

            end
        end
        
        local function setup(room)
            if room.Name == "50" or room.Name == "100" then
                room.DescendantAdded:Connect(function(v)
                    check(v) 
                end)
                
                for i,v in pairs(room:GetDescendants()) do
                    check(v)
                end
            end
        end
        
        local addconnect
        addconnect = workspace.CurrentRooms.ChildAdded:Connect(function(room)
            setup(room)
        end)
        
        for i,room in pairs(workspace.CurrentRooms:GetChildren()) do
            setup(room) 
        end
        
        repeat task.wait() until not ESP.Door50BooksEspfr
        addconnect:Disconnect()
        
        for i,v in pairs(esptable.books) do
            esptable.books = {}
        end 
    end)
