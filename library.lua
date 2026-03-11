-- Jael Library Reborn (Instance.new Edition)
-- Compatible with JaelX Executor
-- Credits: TrollLexBR (Original), Ported by JaelX Assistant

local Library = {}
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

-- Parent Determination
local Parent = CoreGui
if gethui then Parent = gethui() end

function Library:NewWindow(hubName, gameName, version, discord)
    hubName = hubName or "Jael Hub"
    gameName = gameName or "Game"
    version = version or "v1.0"
    discord = discord or "discord.gg/..."

    -- Destroy old GUI
    for _, v in pairs(Parent:GetChildren()) do
        if v.Name == "JaelLibrary" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "JaelLibrary"
    ScreenGui.Parent = Parent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -341, 0.5, -232)
    MainFrame.Size = UDim2.new(0, 683, 0, 464)
    MainFrame.ClipsDescendants = true

    -- Rounded Corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame

    -- Dragging
    local Dragging, DragInput, DragStart, StartPos
    local function Update(input)
        local delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
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
    
    local SideBarCorner = Instance.new("UICorner")
    SideBarCorner.CornerRadius = UDim.new(0, 6)
    SideBarCorner.Parent = SideBar
    
    -- Fix Corner (Cover right side)
    local CornerFix = Instance.new("Frame")
    CornerFix.Parent = SideBar
    CornerFix.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    CornerFix.BorderSizePixel = 0
    CornerFix.Position = UDim2.new(1, -10, 0, 0)
    CornerFix.Size = UDim2.new(0, 10, 1, 0)
    CornerFix.ZIndex = 0

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
    GameLabel.TextSize = 14
    GameLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Parent = MainFrame
    TopBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    TopBar.BorderSizePixel = 0
    TopBar.Position = UDim2.new(0, 189, 0, 0)
    TopBar.Size = UDim2.new(1, -189, 0, 40)
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 6)
    TopBarCorner.Parent = TopBar
    
    local TopBarFix = Instance.new("Frame")
    TopBarFix.Parent = TopBar
    TopBarFix.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
    TopBarFix.BorderSizePixel = 0
    TopBarFix.Position = UDim2.new(0, 0, 1, -10)
    TopBarFix.Size = UDim2.new(1, 0, 0, 10)
    TopBarFix.ZIndex = 0

    local DiscordLabel = Instance.new("TextLabel")
    DiscordLabel.Parent = TopBar
    DiscordLabel.BackgroundTransparency = 1
    DiscordLabel.Position = UDim2.new(1, -160, 0, 0)
    DiscordLabel.Size = UDim2.new(0, 150, 1, 0)
    DiscordLabel.Font = Enum.Font.Gotham
    DiscordLabel.Text = discord
    DiscordLabel.TextColor3 = Color3.fromRGB(120, 138, 255)
    DiscordLabel.TextSize = 13
    DiscordLabel.TextXAlignment = Enum.TextXAlignment.Right

    -- Tab Container (Buttons)
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = SideBar
    TabContainer.Active = true
    TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 100)
    TabContainer.Size = UDim2.new(1, 0, 1, -110)
    TabContainer.ScrollBarThickness = 2

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Parent = TabContainer
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 5)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 199, 0, 50)
    ContentContainer.Size = UDim2.new(1, -209, 1, -60)

    local WindowObj = {}
    local Tabs = {}
    local FirstTab = true

    function WindowObj:NewTab(tabName)
        local TabObj = {}
        local TabButton = Instance.new("TextButton")
        local TabFrame = Instance.new("ScrollingFrame")
        
        -- Tab Button
        TabButton.Name = tabName .. "_Btn"
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = FirstTab and Color3.fromRGB(102, 5, 172) or Color3.fromRGB(35, 35, 35)
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(0, 160, 0, 35)
        TabButton.Font = Enum.Font.GothamBold
        TabButton.Text = tabName
        TabButton.TextColor3 = FirstTab and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        -- Center Button
        local BtnPadding = Instance.new("UIPadding")
        BtnPadding.Parent = TabContainer
        BtnPadding.PaddingLeft = UDim.new(0, 14)

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 4)
        BtnCorner.Parent = TabButton

        -- Tab Content Frame
        TabFrame.Name = tabName .. "_Frame"
        TabFrame.Parent = ContentContainer
        TabFrame.BackgroundTransparency = 1
        TabFrame.BorderSizePixel = 0
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = FirstTab
        TabFrame.ScrollBarThickness = 2
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Parent = TabFrame
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Padding = UDim.new(0, 5)

        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.Parent = TabFrame
        TabContentPadding.PaddingTop = UDim.new(0, 5)
        TabContentPadding.PaddingBottom = UDim.new(0, 5)

        FirstTab = false

        -- Tab Selection Logic
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Frame.Visible = false
                tab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                tab.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            TabFrame.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(Tabs, {Frame = TabFrame, Button = TabButton})

        -- Elements
        function TabObj:NewButton(text, callback)
            callback = callback or function() end
            local ButtonObj = Instance.new("TextButton")
            ButtonObj.Parent = TabFrame
            ButtonObj.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ButtonObj.Size = UDim2.new(1, -10, 0, 35)
            ButtonObj.Font = Enum.Font.Gotham
            ButtonObj.Text = text
            ButtonObj.TextColor3 = Color3.fromRGB(255, 255, 255)
            ButtonObj.TextSize = 14
            ButtonObj.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = ButtonObj

            ButtonObj.MouseButton1Click:Connect(function()
                ButtonObj.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
                callback()
                wait(0.1)
                ButtonObj.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            end)
        end

        function TabObj:NewToggle(text, callback)
            callback = callback or function() end
            local Enabled = false
            
            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Parent = TabFrame
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
            ToggleFrame.Text = ""
            ToggleFrame.AutoButtonColor = false

            local TogCorner = Instance.new("UICorner")
            TogCorner.CornerRadius = UDim.new(0, 4)
            TogCorner.Parent = ToggleFrame

            local Title = Instance.new("TextLabel")
            Title.Parent = ToggleFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(1, -60, 1, 0)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local Indicator = Instance.new("Frame")
            Indicator.Parent = ToggleFrame
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
            Indicator.Position = UDim2.new(1, -35, 0.5, -7)
            Indicator.Size = UDim2.new(0, 15, 0, 15)
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(0, 3)
            IndCorner.Parent = Indicator

            ToggleFrame.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Indicator.BackgroundColor3 = Enabled and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 80, 80)
                callback(Enabled)
            end)
        end
        
        function TabObj:NewSlider(text, min, max, default, callback)
            callback = callback or function() end
            default = default or min
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = TabFrame
            SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            SliderFrame.Size = UDim2.new(1, -10, 0, 50)
            
            local SldCorner = Instance.new("UICorner")
            SldCorner.CornerRadius = UDim.new(0, 4)
            SldCorner.Parent = SliderFrame

            local Title = Instance.new("TextLabel")
            Title.Parent = SliderFrame
            Title.BackgroundTransparency = 1
            Title.Position = UDim2.new(0, 10, 0, 5)
            Title.Size = UDim2.new(1, -20, 0, 20)
            Title.Font = Enum.Font.Gotham
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.TextXAlignment = Enum.TextXAlignment.Left

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = SliderFrame
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -60, 0, 5)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.Text = tostring(default)
            ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            local Bar = Instance.new("Frame")
            Bar.Parent = SliderFrame
            Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Bar.Position = UDim2.new(0, 10, 0, 30)
            Bar.Size = UDim2.new(1, -20, 0, 6)
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(0, 3)
            BarCorner.Parent = Bar

            local Fill = Instance.new("Frame")
            Fill.Parent = Bar
            Fill.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
            Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(0, 3)
            FillCorner.Parent = Fill
            
            local Trigger = Instance.new("TextButton")
            Trigger.Parent = Bar
            Trigger.BackgroundTransparency = 1
            Trigger.Size = UDim2.new(1, 0, 1, 0)
            Trigger.Text = ""

            local isDragging = false
            
            local function Update(input)
                local pos = UDim2.new(math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                Fill.Size = pos
                local val = math.floor(min + ((max - min) * pos.X.Scale))
                ValueLabel.Text = tostring(val)
                callback(val)
            end

            Trigger.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    Update(input)
                end
            end)

            Trigger.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)
        end
        
        function TabObj:NewDropdown(text, items, defaultIndex, callback)
            -- Simplified Dropdown (Cycler)
            callback = callback or function() end
            local Index = defaultIndex or 1
            
            local DropButton = Instance.new("TextButton")
            DropButton.Parent = TabFrame
            DropButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            DropButton.Size = UDim2.new(1, -10, 0, 35)
            DropButton.Font = Enum.Font.Gotham
            DropButton.Text = text .. ": " .. items[Index]
            DropButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropButton.TextSize = 14
            DropButton.AutoButtonColor = false
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 4)
            DropCorner.Parent = DropButton

            DropButton.MouseButton1Click:Connect(function()
                Index = Index + 1
                if Index > #items then Index = 1 end
                DropButton.Text = text .. ": " .. items[Index]
                callback(items[Index])
            end)
        end
        
        function TabObj:NewBar()
            local BarFrame = Instance.new("Frame")
            BarFrame.Parent = TabFrame
            BarFrame.BackgroundTransparency = 1
            BarFrame.Size = UDim2.new(1, -10, 0, 10)
            
            local Line = Instance.new("Frame")
            Line.Parent = BarFrame
            Line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Line.Position = UDim2.new(0, 10, 0.5, 0)
            Line.Size = UDim2.new(1, -20, 0, 1)
        end
        
        function TabObj:NewLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Parent = TabFrame
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -10, 0, 25)
            Label.Font = Enum.Font.Gotham
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 14
        end

        return TabObj
    end
    
    function WindowObj:FeatureNewGame(text) 
        -- Just display in features
        local Lbl = Instance.new("TextLabel")
        -- Implementation skipped for brevity as it's purely visual
    end
    
    function WindowObj:FeatureNewFeature(text) 
        -- Just display in features
    end

    -- Close Button REMOVED by user request
    --[[
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TopBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    CloseBtn.TextSize = 16
    
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    ]]

    function WindowObj:ToggleUI()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end

    return WindowObj
end

return Library
