-- Jael Library Reforged (Instance.new Edition)
-- Fully compatible rewrite of the original Drawing Library
-- Supports: Windows, Tabs, Buttons, Toggles, Sliders, Dropdowns, Keybinds, Labels, Bars
-- Credits: TrollLexBR (Original Design), Reforged by JaelX

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Parent Determination
local Parent = CoreGui
if gethui then Parent = gethui() end

function Library:NewWindow(hubName, gameName, version, discord)
    hubName = hubName or "Jael Library"
    gameName = gameName or "Game"
    version = version or "v1.0"
    discord = discord or "discord.gg/..."

    -- Cleanup
    for _, v in pairs(Parent:GetChildren()) do
        if v.Name == "JaelLibraryReforged" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "JaelLibraryReforged"
    ScreenGui.Parent = Parent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Window Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -341, 0.5, -232)
    MainFrame.Size = UDim2.new(0, 683, 0, 464)
    MainFrame.ClipsDescendants = false -- Allow shadow/glow if added

    -- Dragging Logic
    local Dragging, DragInput, DragStart, StartPos
    local function Update(input)
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)

    -- SideBar
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Parent = MainFrame
    SideBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    SideBar.BorderSizePixel = 0
    SideBar.Size = UDim2.new(0, 189, 1, 0)

    -- Hub Info
    local HubLabel = Instance.new("TextLabel")
    HubLabel.Parent = SideBar
    HubLabel.BackgroundTransparency = 1
    HubLabel.Position = UDim2.new(0, 15, 0, 15)
    HubLabel.Size = UDim2.new(0, 150, 0, 25)
    HubLabel.Font = Enum.Font.GothamBold
    HubLabel.Text = hubName
    HubLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    HubLabel.TextSize = 20
    HubLabel.TextXAlignment = Enum.TextXAlignment.Left

    local GameLabel = Instance.new("TextLabel")
    GameLabel.Parent = SideBar
    GameLabel.BackgroundTransparency = 1
    GameLabel.Position = UDim2.new(0, 15, 0, 40)
    GameLabel.Size = UDim2.new(0, 150, 0, 20)
    GameLabel.Font = Enum.Font.Gotham
    GameLabel.Text = gameName
    GameLabel.TextColor3 = Color3.fromRGB(102, 5, 172)
    GameLabel.TextSize = 16
    GameLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    TopBar.BorderSizePixel = 0
    TopBar.Position = UDim2.new(0, 189, 0, 0)
    TopBar.Size = UDim2.new(1, -189, 0, 41)

    local DiscordLabel = Instance.new("TextLabel")
    DiscordLabel.Parent = TopBar
    DiscordLabel.BackgroundTransparency = 1
    DiscordLabel.Position = UDim2.new(1, -160, 0, 0)
    DiscordLabel.Size = UDim2.new(0, 150, 1, 0)
    DiscordLabel.Font = Enum.Font.Gotham
    DiscordLabel.Text = discord
    DiscordLabel.TextColor3 = Color3.fromRGB(120, 138, 255)
    DiscordLabel.TextSize = 14
    DiscordLabel.TextXAlignment = Enum.TextXAlignment.Right

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Parent = TopBar
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Position = UDim2.new(1, -210, 0, 0)
    VersionLabel.Size = UDim2.new(0, 50, 1, 0)
    VersionLabel.Font = Enum.Font.Gotham
    VersionLabel.Text = version
    VersionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    VersionLabel.TextSize = 12
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Home Button
    local HomeBtn = Instance.new("TextButton")
    HomeBtn.Name = "HomeButton"
    HomeBtn.Parent = SideBar
    HomeBtn.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
    HomeBtn.BorderSizePixel = 0
    HomeBtn.Position = UDim2.new(0, 27, 0, 100)
    HomeBtn.Size = UDim2.new(0, 135, 0, 35)
    HomeBtn.Font = Enum.Font.Gotham
    HomeBtn.Text = "Home"
    HomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    HomeBtn.TextSize = 14
    HomeBtn.AutoButtonColor = false

    -- Home Content (Welcome)
    local HomeFrame = Instance.new("Frame")
    HomeFrame.Name = "HomeFrame"
    HomeFrame.Parent = MainFrame
    HomeFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    HomeFrame.BorderSizePixel = 0
    HomeFrame.Position = UDim2.new(0, 189, 0, 41)
    HomeFrame.Size = UDim2.new(1, -189, 1, -41)
    HomeFrame.Visible = true

    local WelcomeLabel = Instance.new("TextLabel")
    WelcomeLabel.Parent = HomeFrame
    WelcomeLabel.BackgroundTransparency = 1
    WelcomeLabel.Position = UDim2.new(0, 20, 0, 20)
    WelcomeLabel.Size = UDim2.new(1, -40, 0, 30)
    WelcomeLabel.Font = Enum.Font.GothamBold
    WelcomeLabel.Text = "Welcome, " .. LocalPlayer.DisplayName .. "!"
    WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    WelcomeLabel.TextSize = 18
    WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left

    local Separator = Instance.new("Frame")
    Separator.Parent = HomeFrame
    Separator.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
    Separator.BorderSizePixel = 0
    Separator.Position = UDim2.new(0, 20, 0, 60)
    Separator.Size = UDim2.new(1, -40, 0, 1)

    local FeaturesFrame = Instance.new("ScrollingFrame")
    FeaturesFrame.Parent = HomeFrame
    FeaturesFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
    FeaturesFrame.BorderSizePixel = 0
    FeaturesFrame.Position = UDim2.new(0, 20, 0, 70)
    FeaturesFrame.Size = UDim2.new(1, -40, 1, -90)
    FeaturesFrame.ScrollBarThickness = 2

    local FeaturesLayout = Instance.new("UIListLayout")
    FeaturesLayout.Parent = FeaturesFrame
    FeaturesLayout.Padding = UDim.new(0, 5)

    -- Tab Container (Buttons)
    local TabButtonsContainer = Instance.new("ScrollingFrame")
    TabButtonsContainer.Parent = SideBar
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.BorderSizePixel = 0
    TabButtonsContainer.Position = UDim2.new(0, 0, 0, 150)
    TabButtonsContainer.Size = UDim2.new(1, 0, 1, -160)
    TabButtonsContainer.ScrollBarThickness = 0

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabButtonsContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 10)
    TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- Logic for Home/Tabs
    local Tabs = {}

    HomeBtn.MouseButton1Click:Connect(function()
        HomeFrame.Visible = true
        HomeBtn.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
        HomeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        for _, tab in pairs(Tabs) do
            tab.Frame.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            tab.Button.TextColor3 = Color3.fromRGB(117, 117, 117)
        end
    end)

    local WindowObj = {}

    function WindowObj:FeatureNewGame(text)
        local Lbl = Instance.new("TextLabel")
        Lbl.Parent = FeaturesFrame
        Lbl.BackgroundTransparency = 1
        Lbl.Size = UDim2.new(1, 0, 0, 25)
        Lbl.Font = Enum.Font.Gotham
        Lbl.Text = text
        Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        Lbl.TextSize = 16
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
    end

    function WindowObj:FeatureNewFeature(text)
        local Lbl = Instance.new("TextLabel")
        Lbl.Parent = FeaturesFrame
        Lbl.BackgroundTransparency = 1
        Lbl.Size = UDim2.new(1, 0, 0, 20)
        Lbl.Font = Enum.Font.Gotham
        Lbl.Text = "  " .. text
        Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        Lbl.TextSize = 14
        Lbl.TextXAlignment = Enum.TextXAlignment.Left
    end

    function WindowObj:NewTab(name)
        local TabObj = {}
        
        -- Tab Button
        local TabBtn = Instance.new("TextButton")
        TabBtn.Parent = TabButtonsContainer
        TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        TabBtn.BorderSizePixel = 0
        TabBtn.Size = UDim2.new(0, 135, 0, 35)
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.Text = name
        TabBtn.TextColor3 = Color3.fromRGB(117, 117, 117)
        TabBtn.TextSize = 14
        TabBtn.AutoButtonColor = false

        -- Tab Content Frame
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Parent = MainFrame
        TabFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        TabFrame.BorderSizePixel = 0
        TabFrame.Position = UDim2.new(0, 189, 0, 41)
        TabFrame.Size = UDim2.new(1, -189, 1, -41)
        TabFrame.Visible = false
        TabFrame.ScrollBarThickness = 4
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Parent = TabFrame
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 5)
        
        local TabPadding = Instance.new("UIPadding")
        TabPadding.Parent = TabFrame
        TabPadding.PaddingTop = UDim.new(0, 10)
        TabPadding.PaddingLeft = UDim.new(0, 10)

        table.insert(Tabs, {Button = TabBtn, Frame = TabFrame})

        TabBtn.MouseButton1Click:Connect(function()
            -- Hide Home
            HomeFrame.Visible = false
            HomeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            HomeBtn.TextColor3 = Color3.fromRGB(117, 117, 117)

            -- Reset all tabs
            for _, t in pairs(Tabs) do
                t.Frame.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                t.Button.TextColor3 = Color3.fromRGB(117, 117, 117)
            end

            -- Activate this tab
            TabFrame.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        -- Elements
        function TabObj:NewLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = TabFrame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -20, 0, 25)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
        end

        function TabObj:NewButton(text, callback)
            callback = callback or function() end
            local BtnFrame = Instance.new("Frame")
            BtnFrame.Parent = TabFrame
            BtnFrame.BackgroundTransparency = 1
            BtnFrame.Size = UDim2.new(1, -20, 0, 40)

            local Btn = Instance.new("TextButton")
            Btn.Parent = BtnFrame
            Btn.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
            Btn.BorderSizePixel = 0
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = "  " .. text
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 14
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.AutoButtonColor = false

            Btn.MouseButton1Click:Connect(function()
                Btn.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
                callback()
                wait(0.1)
                Btn.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
            end)
        end

        function TabObj:NewToggle(text, callback)
            callback = callback or function() end
            local Enabled = false

            local TogFrame = Instance.new("Frame")
            TogFrame.Parent = TabFrame
            TogFrame.BackgroundTransparency = 1
            TogFrame.Size = UDim2.new(1, -20, 0, 40)

            local Bg = Instance.new("Frame")
            Bg.Parent = TogFrame
            Bg.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
            Bg.BorderSizePixel = 0
            Bg.Size = UDim2.new(1, 0, 0, 35)

            local Label = Instance.new("TextLabel")
            Label.Parent = Bg
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.Size = UDim2.new(1, -70, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local SwitchBg = Instance.new("Frame")
            SwitchBg.Parent = Bg
            SwitchBg.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            SwitchBg.BorderSizePixel = 0
            SwitchBg.Position = UDim2.new(1, -60, 0.5, -10)
            SwitchBg.Size = UDim2.new(0, 50, 0, 20)

            local Indicator = Instance.new("Frame")
            Indicator.Parent = SwitchBg
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 81, 81)
            Indicator.BorderSizePixel = 0
            Indicator.Position = UDim2.new(0, 25, 0, 0)
            Indicator.Size = UDim2.new(0, 25, 1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = Bg
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            Trigger.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                if Enabled then
                    Indicator.BackgroundColor3 = Color3.fromRGB(2, 255, 108)
                    Indicator.Position = UDim2.new(0, 0, 0, 0)
                else
                    Indicator.BackgroundColor3 = Color3.fromRGB(255, 81, 81)
                    Indicator.Position = UDim2.new(0, 25, 0, 0)
                end
                callback(Enabled)
            end)
        end

        function TabObj:NewSlider(text, min, max, default, callback)
            callback = callback or function() end
            default = default or min
            
            local SldFrame = Instance.new("Frame")
            SldFrame.Parent = TabFrame
            SldFrame.BackgroundTransparency = 1
            SldFrame.Size = UDim2.new(1, -20, 0, 60)

            local Bg = Instance.new("Frame")
            Bg.Parent = SldFrame
            Bg.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
            Bg.BorderSizePixel = 0
            Bg.Size = UDim2.new(1, 0, 0, 55)

            local Label = Instance.new("TextLabel")
            Label.Parent = Bg
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.Size = UDim2.new(1, -20, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left

            local ValLabel = Instance.new("TextLabel")
            ValLabel.Parent = Bg
            ValLabel.BackgroundTransparency = 1
            ValLabel.Position = UDim2.new(1, -50, 0, 5)
            ValLabel.Size = UDim2.new(0, 40, 0, 20)
            ValLabel.Font = Enum.Font.Gotham
            ValLabel.Text = tostring(default)
            ValLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ValLabel.TextSize = 14
            ValLabel.TextXAlignment = Enum.TextXAlignment.Right

            local Track = Instance.new("Frame")
            Track.Parent = Bg
            Track.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
            Track.BorderSizePixel = 0
            Track.Position = UDim2.new(0, 10, 0, 30)
            Track.Size = UDim2.new(1, -20, 0, 15)

            local Fill = Instance.new("Frame")
            Fill.Parent = Track
            Fill.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
            Fill.BorderSizePixel = 0
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)

            local Trigger = Instance.new("TextButton")
            Trigger.Parent = Bg
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            local isDragging = false
            
            local function Update(input)
                local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + ((max - min) * pos))
                ValLabel.Text = tostring(val)
                callback(val)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = true
                    Update(input)
                end
            end)

            Trigger.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    isDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)
        end

        function TabObj:NewDropdown(text, items, defaultIndex, callback)
            -- Cycler Style
            callback = callback or function() end
            items = items or {}
            local Index = defaultIndex or 1
            if Index > #items then Index = 1 end
            local current = items[Index] or "None"

            local DropFrame = Instance.new("Frame")
            DropFrame.Parent = TabFrame
            DropFrame.BackgroundTransparency = 1
            DropFrame.Size = UDim2.new(1, -20, 0, 40)

            local Btn = Instance.new("TextButton")
            Btn.Parent = DropFrame
            Btn.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
            Btn.BorderSizePixel = 0
            Btn.Size = UDim2.new(1, 0, 0, 35)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = "  " .. text .. ": " .. tostring(current)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 14
            Btn.TextXAlignment = Enum.TextXAlignment.Left
            Btn.AutoButtonColor = false

            Btn.MouseButton1Click:Connect(function()
                Index = Index + 1
                if Index > #items then Index = 1 end
                current = items[Index] or "None"
                Btn.Text = "  " .. text .. ": " .. tostring(current)
                callback(items[Index])
            end)
        end

        function TabObj:NewBar()
            local BarFrame = Instance.new("Frame")
            BarFrame.Parent = TabFrame
            BarFrame.BackgroundTransparency = 1
            BarFrame.Size = UDim2.new(1, -20, 0, 10)

            local Line = Instance.new("Frame")
            Line.Parent = BarFrame
            Line.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
            Line.BorderSizePixel = 0
            Line.Position = UDim2.new(0, 0, 0.5, 0)
            Line.Size = UDim2.new(1, 0, 0, 2)
        end

        return TabObj
    end

    function WindowObj:ToggleUI()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    return WindowObj
end

return Library
