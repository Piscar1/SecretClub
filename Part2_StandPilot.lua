-- ============================================
-- SecretClub GUI - ЧАСТЬ 2: STAND PILOT SYSTEM
-- ============================================

-- Variables
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ========================================
-- ТОЧНО ИЗ ВТОРОГО СКРИПТА: Variables + Settings + PilotStand + UnPilotStand
-- ========================================

local Player = game.Players.LocalPlayer
Player.CharacterAdded:Connect(function()
    task.wait(1)
    Character = Player.Character
end)

local Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
local StandMorph = Character:FindFirstChild("StandMorph")
local RemoteEvent = Character:FindFirstChild("RemoteEvent") or Character:WaitForChild("RemoteEvent")
local RemoteFunction = Character:FindFirstChild("RemoteFunction") or Character:WaitForChild("RemoteFunction")
local CurrentCamera = workspace.CurrentCamera

local TempStore = Instance.new("Folder", game.ReplicatedStorage)
TempStore.Name = "TempStorage"
local StayInPilot = Instance.new("BoolValue", workspace)
StayInPilot.Value = false

getgenv().settings = {
    ["cachedbodyparts"] = {},
    ["noclip"] = false,
    ["invisenabled"] = nil,
    ["antits"] = nil,
    ["inviskey"] = Enum.KeyCode.L,
    ["oldpos"] = nil,
    ["delay"] = 0.8,
    ["crasher"] = false,
    ["customval"] = 2000,
    ["standspeed"] = 1.5,
    ["pilotjumppower"] = 1.5,
    ["hidebody"] = true,
    ["tpbodytostand"] = true,
    ["bodydistance"] = 37,
    ["pilotkey"] = Enum.KeyCode.H,
    ["currentargs"] = nil,
    ["flingtarget"] = nil,
    ["animationlist"] = {},
    ["1"] = nil,
    ["2"] = nil,
    ["3"] = nil,
    ["4"] = nil,
    ["5"] = nil,
    ["6"] = nil,
    ["7"] = nil,
    ["8"] = nil,
    ["9"] = nil,
    ["target"] = nil,
    ["attach"] = false,
    ["distancefr"] = 2,
    ["god"] = nil,
    ["kidnaptarget"] = nil,
    ["teleportpos"] = CFrame.new(0, -500, 0),
    ["movementpredictionstrength"] = 0.35,
    ["timeout"] = 1,
    ["useinvis"] = true
}

-- Stand Attach Settings (для GUI)
getgenv().AttachSettings = {
    target = nil,
    attach = false,
    distance = 2,
    height = 0,
}

local SummonedStand, StandHumanoid, Camera

local function UpdateIndex()
	CurrentCharacter = Player.Character
	Humanoid = CurrentCharacter:FindFirstChild("Humanoid") or CurrentCharacter:WaitForChild("Humanoid")
	SummonedStand = CurrentCharacter:FindFirstChild("SummonedStand") or CurrentCharacter:WaitForChild("SummonedStand")
	
	StandMorph = CurrentCharacter:FindFirstChild("StandMorph")
	StandHumanoid = StandMorph:FindFirstChild("AnimationController") or StandMorph:WaitForChild("AnimationController")
	
	Camera = workspace.CurrentCamera
end	

local function PilotStand()
	UpdateIndex()
	
	for i,v in workspace.Locations:GetChildren() do
		if v.Name == "Naples' Sewers" then
			v.Parent = TempStore
		end
	end

	local CameraValue = Instance.new("ObjectValue", StandMorph.Parent)
	local PilotFunctions = {["FocusCam"] = CameraValue, ["CFrame"] = CurrentCharacter.PrimaryPart.CFrame}

	CameraValue.Name = "FocusCam"
	CameraValue.Value = StandHumanoid
	
	for _,v in CurrentCharacter:GetChildren() do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
	
	--//Jumping\\--
	PilotFunctions["JumpSignal"] = Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
		if Humanoid.Jump then
	    	StandHumanoid.Jump = true
	    end
	end)
	
	--//WalkSpeed\\--
	StandHumanoid.WalkSpeed = Humanoid.WalkSpeed*settings["standspeed"]
	PilotFunctions["PilotSpeed"] = Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	    StandHumanoid.WalkSpeed = Humanoid.WalkSpeed*settings["standspeed"]
	end)
	
	
	--//Jump Power\\--
	StandHumanoid.JumpPower = Humanoid.JumpPower*settings["pilotjumppower"]
	PilotFunctions["JumpPower"] = Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
	    StandHumanoid.JumpPower = Humanoid.JumpPower*settings["pilotjumppower"]
	end)
	
	if not settings["hidebody"] then
		CurrentCharacter.PrimaryPart.Anchored = true
	end
	
	--//Walking\\--
	PilotFunctions["LoopTP"] = RunService.Heartbeat:Connect(function()
		local MoveDirection = Camera.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)
		StandHumanoid:Move(MoveDirection, true)
		
		if settings["hidebody"] then
			CurrentCharacter.PrimaryPart.CFrame = StandMorph.PrimaryPart.CFrame+Vector3.new(0,-settings["bodydistance"],0)
		end
	end)
	
	StandMorph:FindFirstChild("AlignOrientation", true).Enabled = false
	StandMorph:FindFirstChild("AlignPosition", true).Enabled = false
	for i,v in StandMorph:GetDescendants() do
	    if v:IsA("BasePart") or v:IsA("UnionOperation") then
	        game:GetService("PhysicsService"):SetPartCollisionGroup(v, "Players")
	    end
	end
	return PilotFunctions
end

local function UnPilotStand(Returned)
	UpdateIndex()
	
	for i,v in game.ReplicatedStorage.TempStorage:GetChildren() do
		if v.Name == "Naples' Sewers" then
			v.Parent = workspace.Locations
		end
	end

	for x,v in Returned do
		if tostring(v) == "Connection" then
			v:Disconnect()
		end
	end
	
	Returned["FocusCam"]:Destroy()
	
	CurrentCharacter.PrimaryPart.Velocity = Vector3.new()
	if settings["tpbodytostand"] then
		CurrentCharacter.PrimaryPart.CFrame = StandMorph.PrimaryPart.CFrame
	else
		CurrentCharacter.PrimaryPart.CFrame = Returned["CFrame"]
	end
	
	StandMorph:FindFirstChild("AlignOrientation", true).Enabled = true
	StandMorph:FindFirstChild("AlignPosition", true).Enabled = true
	for i,v in StandMorph:GetDescendants() do
	    if v:IsA("BasePart") or v:IsA("UnionOperation") then
	        game:GetService("PhysicsService"):SetPartCollisionGroup(v, "Stands")
	    end
	end
	
	if not settings["hidebody"] then
		CurrentCharacter.PrimaryPart.Anchored = false
	end
end

-- EnablePilot / DisablePilot (логика подписок — тоже из второго скрипта)
local function EnablePilot()
    repeat task.wait() until Character:FindFirstChild("StandMorph")
    UpdateIndex()

    settings["1"] = SummonedStand:GetPropertyChangedSignal("Value"):Connect(function()
        if not SummonedStand.Value then
            StayInPilot.Value = false
        end
    end)

    settings["2"] = UserInputService.InputBegan:Connect(function(InputObject)
        if UserInputService:GetFocusedTextBox() then
            return
        end

        if InputObject.KeyCode == settings["pilotkey"] then
            StayInPilot.Value = not StayInPilot.Value
        end
    end)

    settings["3"] = StayInPilot:GetPropertyChangedSignal("Value"):Connect(function()
        if StayInPilot.Value then
            settings["currentargs"] = PilotStand()
        else
            UnPilotStand(settings["currentargs"])
        end
    end)
end

local function DisablePilot()
    if settings["1"] then settings["1"]:Disconnect() end
    if settings["2"] then settings["2"]:Disconnect() end
    if settings["3"] then settings["3"]:Disconnect() end

    if settings["currentargs"] then
        UnPilotStand(settings["currentargs"])
        StayInPilot.Value = false
    end
end

print("✅ [Part 2/4] Stand Pilot System loaded")
