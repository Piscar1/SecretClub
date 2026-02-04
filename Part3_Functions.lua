-- ============================================
-- SecretClub GUI - ЧАСТЬ 3: STAND ATTACH & FUNCTIONS
-- ============================================

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

-- ESP Variables
local espBoxEnabled = false
local espNameEnabled = false
local espDistanceEnabled = false
local espTracerEnabled = false
local espBoxColor = Color3.fromRGB(60, 140, 220)
local espFontSize = 14

local flyEnabled = false
local flySpeed = 50
local flyKeybind = Enum.KeyCode.F
local waitingForFlyKey = false
local bv, bg = nil, nil
local noclipEnabled = false
local speedHackEnabled = false
local walkSpeed = 16
local jumpHackEnabled = false
local jumpPower = 50

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SecretClubGUI_Complete"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 692, 0, 558)
MainFrame.Position = UDim2.new(0.5, -346, 0.5, -279)
MainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

-- Custom Dragging
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
TopBar.Active = true

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local mousePos = UserInputService:GetMouseLocation()
        local clickedOnButton = false
        
        for _, child in pairs(TopBar:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                local childPos = child.AbsolutePosition
                local childSize = child.AbsoluteSize
                if mousePos.X >= childPos.X and mousePos.X <= childPos.X + childSize.X and
                   mousePos.Y >= childPos.Y and mousePos.Y <= childPos.Y + childSize.Y then
                    clickedOnButton = true
                    break
                end
            end
        end
        
        if not clickedOnButton then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- SECRETCLUB Logo
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(0, 150, 1, 0)
Logo.Position = UDim2.new(0, 24, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "SECRETCLUB"
Logo.Font = Enum.Font.GothamBold
Logo.TextSize = 18
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.Parent = TopBar

-- Save Button
local SaveButton = Instance.new("TextButton")
SaveButton.Size = UDim2.new(0, 70, 0, 28)
SaveButton.Position = UDim2.new(0, 190, 0, 16)
SaveButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
SaveButton.Text = "💾  Save"
SaveButton.Font = Enum.Font.Gotham
SaveButton.TextSize = 12
SaveButton.TextColor3 = Color3.fromRGB(160, 160, 160)
SaveButton.BorderSizePixel = 0
SaveButton.Parent = TopBar

local SaveCorner = Instance.new("UICorner")
SaveCorner.CornerRadius = UDim.new(0, 20)
SaveCorner.Parent = SaveButton

SaveButton.MouseEnter:Connect(function()
    TweenService:Create(SaveButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play()
end)
SaveButton.MouseLeave:Connect(function()
    TweenService:Create(SaveButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(32, 32, 32)}):Play()
end)

-- Config Dropdown
local ConfigDropdown = Instance.new("TextButton")
ConfigDropdown.Size = UDim2.new(0, 120, 0, 28)
ConfigDropdown.Position = UDim2.new(0, 270, 0, 16)
ConfigDropdown.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
ConfigDropdown.Text = "Global                 ▼"
ConfigDropdown.Font = Enum.Font.Gotham
ConfigDropdown.TextSize = 12
ConfigDropdown.TextColor3 = Color3.fromRGB(160, 160, 160)
ConfigDropdown.BorderSizePixel = 0
ConfigDropdown.Parent = TopBar

local ConfigCorner = Instance.new("UICorner")
ConfigCorner.CornerRadius = UDim.new(0, 20)
ConfigCorner.Parent = ConfigDropdown

-- Settings Icon
local SettingsBtn = Instance.new("TextButton")
SettingsBtn.Size = UDim2.new(0, 32, 0, 28)
SettingsBtn.Position = UDim2.new(1, -42, 0, 16)
SettingsBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
SettingsBtn.Text = "⚙"
SettingsBtn.Font = Enum.Font.GothamBold
SettingsBtn.TextSize = 16
SettingsBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
SettingsBtn.BorderSizePixel = 0
SettingsBtn.Parent = TopBar

local SettingsCorner = Instance.new("UICorner")
SettingsCorner.CornerRadius = UDim.new(0, 20)
SettingsCorner.Parent = SettingsBtn

-- Left Sidebar
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 175, 1, -60)
Sidebar.Position = UDim2.new(0, 0, 0, 60)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 4
Sidebar.ScrollBarImageColor3 = Color3.fromRGB(60, 140, 220)
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 550)
Sidebar.Parent = MainFrame

local allButtons = {}
local currentActiveButton = nil

local function createSidebarLabel(text, yPos)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -24, 0, 18)
    Label.Position = UDim2.new(0, 24, 0, yPos)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 10
    Label.TextColor3 = Color3.fromRGB(100, 100, 100)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Sidebar
    return Label
end

local function createSidebarButton(iconText, text, yPos, isActive, iconColor, tabPage)
    local Button = Instance.new("TextButton")
    Button.Name = text
    Button.Size = UDim2.new(1, -20, 0, 34)
    Button.Position = UDim2.new(0, 10, 0, yPos)
    Button.BackgroundColor3 = isActive and Color3.fromRGB(35, 35, 38) or Color3.fromRGB(18, 18, 18)
    Button.Text = ""
    Button.BorderSizePixel = 0
    Button.Parent = Sidebar
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 20)
    Corner.Parent = Button
    
    local Icon = Instance.new("TextLabel")
    Icon.Size = UDim2.new(0, 20, 1, 0)
    Icon.Position = UDim2.new(0, 10, 0, 0)
    Icon.BackgroundTransparency = 1
    Icon.Text = iconText
    Icon.Font = Enum.Font.GothamBold
    Icon.TextSize = 14
    Icon.TextColor3 = iconColor or Color3.fromRGB(60, 140, 220)
    Icon.TextXAlignment = Enum.TextXAlignment.Left
    Icon.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 36, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 13
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    table.insert(allButtons, {Button = Button, Page = tabPage})
    
    Button.MouseButton1Click:Connect(function()
        if currentActiveButton then
            TweenService:Create(currentActiveButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 18)}):Play()
        end
        for _, data in pairs(allButtons) do
            if data.Page then data.Page.Visible = false end
        end
        if tabPage then tabPage.Visible = true end
        currentActiveButton = Button
        TweenService:Create(Button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 38)}):Play()
    end)
    
    Button.MouseEnter:Connect(function()
        if Button ~= currentActiveButton then
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(28, 28, 28)}):Play()
        end
    end)
    Button.MouseLeave:Connect(function()
        if Button ~= currentActiveButton then
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(18, 18, 18)}):Play()
        end
    end)
    
    return Button
end

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -175, 1, -60)
ContentArea.Position = UDim2.new(0, 175, 0, 60)
ContentArea.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainFrame

local function createPage()
    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1, -24, 1, -24)
    ScrollFrame.Position = UDim2.new(0, 12, 0, 12)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 0
    ScrollFrame.ScrollingEnabled = true
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 600)
    ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ScrollFrame.Visible = false
    ScrollFrame.Parent = ContentArea
    
    local LeftColumn = Instance.new("Frame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Size = UDim2.new(0.48, 0, 1, 0)
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.Parent = ScrollFrame
    
    local LeftLayout = Instance.new("UIListLayout")
    LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    LeftLayout.Padding = UDim.new(0, 6)
    LeftLayout.Parent = LeftColumn
    
    local RightColumn = Instance.new("Frame")
    RightColumn.Name = "RightColumn"
    RightColumn.Size = UDim2.new(0.48, 0, 1, 0)
    RightColumn.Position = UDim2.new(0.52, 0, 0, 0)
    RightColumn.BackgroundTransparency = 1
    RightColumn.Parent = ScrollFrame
    
    local RightLayout = Instance.new("UIListLayout")
    RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    RightLayout.Padding = UDim.new(0, 6)
    RightLayout.Parent = RightColumn
    
    return ScrollFrame, LeftColumn, RightColumn
end

-- Helper Functions
local function createSectionHeader(text)
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, 0, 0, 28)
    Header.BackgroundTransparency = 1
    Header.Text = text
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 13
    Header.TextColor3 = Color3.fromRGB(240, 240, 240)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    return Header
end

local function createToggle(parent, labelText, defaultValue, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, 0, 0, 24)
    Toggle.BackgroundTransparency = 1
    Toggle.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -25, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = labelText
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(180, 180, 180)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 16, 0, 16)
    Switch.Position = UDim2.new(1, -16, 0.5, -8)
    Switch.BackgroundColor3 = defaultValue and Color3.fromRGB(60, 140, 220) or Color3.fromRGB(50, 50, 50)
    Switch.Text = ""
    Switch.BorderSizePixel = 0
    Switch.Parent = Toggle
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local toggled = defaultValue
    
    Switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        TweenService:Create(Switch, TweenInfo.new(0.15), {
            BackgroundColor3 = toggled and Color3.fromRGB(60, 140, 220) or Color3.fromRGB(50, 50, 50)
        }):Play()
        if callback then callback(toggled) end
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
