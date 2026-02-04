-- ============================================
-- SecretClub GUI - ЧАСТЬ 3: STAND ATTACH & FUNCTIONS
-- ============================================

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Update Character on respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

-- ========================================
-- Stand Attach Functions
-- ========================================
local function GetStand()
    if Character and Character:FindFirstChild("StandMorph") then
        return Character.StandMorph
    end
    return nil
end

local function SearchPlayer(Name)
    local ClosestMatch = nil
    local ClosestLetters = 0
    for i,v in workspace.Living:GetChildren() do
        local matched_letters = 0
        for i = 1, #Name do
            if string.sub(Name:lower(), 1, i) == string.sub(v.Name:lower(), 1, i) then
                matched_letters = i
            end
        end
        if matched_letters > ClosestLetters then
            ClosestLetters = matched_letters
            ClosestMatch = v
        end
    end
    return ClosestMatch
end

-- Invisibility Variables
local Highlight = nil
local UndergroundAnimation = nil
local isInvisible = false

-- Animation Variables
local animPlayerActive = {}
local animPlayerConnections = {}

local animations = {
    {name = "Twerk", id = 12874447851, speed = 1.5, timepos = 3.90, looped = true, freezeonend = false},
    {name = "California Girls", id = 124982597491660, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Helicopter", id = 95301257497525, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Helicopter 2", id = 122951149300674, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Helicopter 3", id = 91257498644328, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Da Hood Dance", id = 108171959207138, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Da Hood Stomp", id = 115048845533448, speed = 1.4, timepos = 0, looped = true, freezeonend = false},
    {name = "Flopping Fish", id = 79075971527754, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Gangnam Style", id = 100531289776679, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Caramelldansen", id = 88315693621494, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Air Circle", id = 94324173536622, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Heart Left", id = 110936682778213, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Heart Right", id = 84671941093489, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "67", id = 115439144505157, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "6", id = 115439144505157, speed = 0, timepos = 0.2, looped = false, freezeonend = false},
    {name = "7", id = 115439144505157, speed = 0, timepos = 1.2, looped = false, freezeonend = false},
    {name = "Dog", id = 78195344190486, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "MM2 Zen", id = 86872878957632, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Default Dance", id = 88455578674030, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Sit", id = 97185364700038, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Kazotsky Kick", id = 119264600441310, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Fight Stance", id = 116763940575803, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Oh Who Is You", id = 81389876138766, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Sway Sit", id = 130995344283026, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Sway Sit 2", id = 131836270858895, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "The Worm", id = 90333292347820, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Snake", id = 98476854035224, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Peter Griffin Death", id = 129787664584610, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Walter Scene", id = 113475147402830, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Cute Stomach Lay", id = 80754582835479, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Shadow Dio Pose", id = 92266904563270, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Jotaro Pose", id = 122120443600865, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Jojo Pose", id = 120629563851640, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Float Lay", id = 77840765435893, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Biblically Accurate", id = 109873544976020, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Headless", id = 78837807518622, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "ME!ME!ME!", id = 103235915424832, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Plane", id = 82135680487389, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "XavierSoBased", id = 90802740360125, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Chinese Dance", id = 131758838511368, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Slickback", id = 74288964113793, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Car", id = 108747312576405, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Beat Da Koto Nai", id = 93497729736287, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Tank", id = 94915612757079, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Classic Walk", id = 107806791584829, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Weird Creature", id = 87025086742503, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Skibidi Toilet", id = 127154705636043, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Rolling Crybaby", id = 129699431093711, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Thinking", id = 127088545449493, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Fake Death", id = 88130117312312, speed = 1, timepos = 0, looped = false, freezeonend = true},
    {name = "Laced", id = 135611169366768, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Fit Check", id = 81176957565811, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Surrender", id = 100537772865440, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Assumptions", id = 91294374426630, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Griddy", id = 121966805049108, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Take The L", id = 78653596566468, speed = 1, timepos = 0, looped = true, freezeonend = true},
    {name = "Basketball Head Spin", id = 92854797386719, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Parrot Dance", id = 101810746304426, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Shot", id = 102691551292124, speed = 1, timepos = 0, looped = false, freezeonend = true},
    {name = "Ragdoll", id = 136224735234038, speed = 1, timepos = 0, looped = false, freezeonend = true},
    {name = "Sad Sit", id = 100798804992348, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Soda Pop", id = 105459130960429, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Billy Bounce", id = 137501135905857, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Ballin", id = 119242308765484, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Jackhammer", id = 91423662648449, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Monster Mash", id = 137883764619555, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Fumo Plush", id = 107217181254431, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Rizz Backflip", id = 131205329995035, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Float", id = 89523370947906, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Hi", id = 103041144411206, speed = 1, timepos = 0, looped = false, freezeonend = true},
    {name = "Posessed", id = 90708290447388, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Fuck you!", id = 98289978017308, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Silver Surfer", id = 100663712757148, speed = 0.8, timepos = 0, looped = true, freezeonend = false},
    {name = "Tall Thing Idk", id = 118864464720628, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Cat Sit", id = 99424293618796, speed = 1, timepos = 0, looped = true, freezeonend = false},
    {name = "Black Flash", id = 104767795538635, speed = 1, timepos = 0, looped = true, freezeonend = false},
}

local function stopAllAnimations()
    for key, conn in pairs(animPlayerConnections) do
        if conn and typeof(conn) == "RBXScriptConnection" then
            conn:Disconnect()
        end
    end
    animPlayerConnections = {}
    
    for key, track in pairs(animPlayerActive) do
        if track then
            pcall(function() track:Stop() end)
        end
    end
    animPlayerActive = {}
end

-- Ghost Hub Variables
_G.PredictValue = 0.30
_G.AutoClicker = false
_G.IsResetting = false
local vim = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local gh_selectedPlayer = nil
local gh_isRunning = false
local gh_isFlingActive = false
local gh_isAutoResetEnabled = false
local gh_resetInterval = 5
local gh_currentBV = nil
local autoClickerRunning = false

-- Physics Lab Variables
local seismicActive = false
local vacuumActive = false
local kickActive = false
local spiderMode = false
local airWalk = false
local flying_physics = false
local unshakeable = false
local blackholeActive = false
local airWalkPlate = nil

-- ========================================
-- UI Helper Functions
-- ========================================
local function createToggle(parent, labelText, defaultValue, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 24)
    Toggle.BackgroundTransparency = 1
    Toggle.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.75, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 18)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -9)
    ToggleButton.BackgroundColor3 = defaultValue and Color3.fromRGB(60, 140, 220) or Color3.fromRGB(40, 40, 40)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = Toggle
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleButton
    
    local ToggleDot = Instance.new("Frame")
    ToggleDot.Size = UDim2.new(0, 14, 0, 14)
    ToggleDot.Position = defaultValue and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    ToggleDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleDot.BorderSizePixel = 0
    ToggleDot.Parent = ToggleButton
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = ToggleDot
    
    local isToggled = defaultValue
    
    ToggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = isToggled and Color3.fromRGB(60, 140, 220) or Color3.fromRGB(40, 40, 40)
        }):Play()
        
        TweenService:Create(ToggleDot, TweenInfo.new(0.2), {
            Position = isToggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        
        if callback then callback(isToggled) end
    end)
    
    return Toggle
end

local function createSlider(parent, labelText, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, 0, 0, 24)
    Slider.BackgroundTransparency = 1
    Slider.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.40, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local Value = Instance.new("TextLabel")
    Value.Size = UDim2.new(0, 30, 1, 0)
    Value.Position = UDim2.new(1, -30, 0, 0)
    Value.BackgroundTransparency = 1
    Value.Text = tostring(default)
    Value.Font = Enum.Font.Gotham
    Value.TextSize = 12
    Value.TextColor3 = Color3.fromRGB(120, 120, 120)
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.Parent = Slider
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(0.45, 0, 0, 3)
    SliderBack.Position = UDim2.new(0.43, 0, 0.5, -1.5)
    SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = Slider
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    local SliderDot = Instance.new("Frame")
    SliderDot.Size = UDim2.new(0, 10, 0, 10)
    SliderDot.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
    SliderDot.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    SliderDot.BorderSizePixel = 0
    SliderDot.Parent = SliderBack
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = SliderDot
    
    local sliderDragging = false
    
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation().X
            local sliderPos = SliderBack.AbsolutePosition.X
            local sliderSize = SliderBack.AbsoluteSize.X
            
            local percent = math.clamp((mouse - sliderPos) / sliderSize, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            Value.Text = tostring(value)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            SliderDot.Position = UDim2.new(percent, -5, 0.5, -5)
            
            if callback then callback(value) end
        end
    end)
    
    return Slider
end

local function createTextBox(parent, labelText, placeholderText, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 34)
    Container.BackgroundTransparency = 1
    Container.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.35, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.60, 0, 0, 28)
    TextBox.Position = UDim2.new(0.40, 0, 0.5, -14)
    TextBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    TextBox.Text = ""
    TextBox.PlaceholderText = placeholderText
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 11
    TextBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextBox.BorderSizePixel = 0
    TextBox.Parent = Container
    
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 20)
    TextBoxCorner.Parent = TextBox
    
    if callback then
        TextBox.FocusLost:Connect(function()
            callback(TextBox.Text)
        end)
    end
    
    return Container, TextBox
end

local function createButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    Button.Text = text
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 12
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.BorderSizePixel = 0
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 20)
    ButtonCorner.Parent = Button
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(32, 32, 32)}):Play()
    end)
    
    if callback then
        Button.MouseButton1Click:Connect(callback)
    end
    
    return Button
end

print("✅ [Part 3/4] Stand Attach & Functions loaded")
