local Library = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

local function GetXY(GuiObject)
	local mousePos = UserInputService:GetMouseLocation()
	local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
	local Px, Py = math.clamp(mousePos.X - GuiObject.AbsolutePosition.X, 0, Max), 
				   math.clamp(mousePos.Y - GuiObject.AbsolutePosition.Y, 0, May)
	return Px/Max, Py/May
end

function Library:ToggleUI()
	local Parent = CoreGui
	if gethui then
		Parent = gethui()
	elseif syn and syn.protect_gui then 
		syn.protect_gui(Parent)
	end
	
	if Parent:FindFirstChild("Jael Library") then
		Parent["Jael Library"].Enabled = not Parent["Jael Library"].Enabled
	end
end

function Library:NewWindow(hubName, gameName, version, discord)
	
	-- Safe Parent
	local Parent = CoreGui
	if gethui then
		Parent = gethui()
	elseif syn and syn.protect_gui then 
		syn.protect_gui(Parent)
	end

	if Parent:FindFirstChild("Jael Library") then
		Parent:FindFirstChild("Jael Library"):Destroy()
	end

	hubName = hubName or "Jael Library"
	gameName = gameName or "Baseplate"
	version = version or "v1.0"
	discord = discord or "discord.gg/..."

	local GUI = {}
	
	-- Main ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Jael Library"
	ScreenGui.Parent = Parent
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	-- MainFrame
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
	MainFrame.Position = UDim2.new(0.5, -341, 0.5, -232) -- Centered
	MainFrame.Size = UDim2.new(0, 683, 0, 464)
	MainFrame.Active = true
	
	local MainFrameUICorner = Instance.new("UICorner")
	MainFrameUICorner.CornerRadius = UDim.new(0, 5)
	MainFrameUICorner.Parent = MainFrame

	-- SideBar
	local SideBar = Instance.new("Frame")
	SideBar.Name = "SideBar"
	SideBar.Parent = MainFrame
	SideBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	SideBar.Size = UDim2.new(0, 189, 0, 464)

	local SideBarUICorner = Instance.new("UICorner")
	SideBarUICorner.CornerRadius = UDim.new(0, 5)
	SideBarUICorner.Parent = SideBar

	-- NameFrame (Hub Info)
	local NameFrame = Instance.new("Frame")
	NameFrame.Name = "NameFrame"
	NameFrame.Parent = SideBar
	NameFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	NameFrame.BackgroundTransparency = 1
	NameFrame.Size = UDim2.new(0, 189, 0, 100)

	local GameNameLabel = Instance.new("TextLabel")
	GameNameLabel.Name = "GameNameLabel"
	GameNameLabel.Parent = NameFrame
	GameNameLabel.BackgroundTransparency = 1
	GameNameLabel.Position = UDim2.new(0.039, 0, 0.414, 0)
	GameNameLabel.Size = UDim2.new(0, 173, 0, 41)
	GameNameLabel.Font = Enum.Font.Gotham
	GameNameLabel.Text = gameName
	GameNameLabel.TextColor3 = Color3.fromRGB(102, 5, 172)
	GameNameLabel.TextSize = 20
	GameNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	GameNameLabel.TextYAlignment = Enum.TextYAlignment.Top
	GameNameLabel.TextWrapped = true

	local HubNameLabel = Instance.new("TextLabel")
	HubNameLabel.Name = "HubNameLabel"
	HubNameLabel.Parent = NameFrame
	HubNameLabel.BackgroundTransparency = 1
	HubNameLabel.Position = UDim2.new(0.039, 0, 0.066, 0)
	HubNameLabel.Size = UDim2.new(0, 174, 0, 35)
	HubNameLabel.Font = Enum.Font.Gotham
	HubNameLabel.Text = hubName
	HubNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	HubNameLabel.TextScaled = true
	HubNameLabel.TextSize = 27
	HubNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	HubNameLabel.TextWrapped = true

	-- ButtonsHolder (Tab Buttons)
	local ButtonsHolder = Instance.new("Frame")
	ButtonsHolder.Name = "ButtonsHolder"
	ButtonsHolder.Parent = SideBar
	ButtonsHolder.BackgroundTransparency = 1
	ButtonsHolder.Position = UDim2.new(0.14, 0, 0.288, 0)
	ButtonsHolder.Size = UDim2.new(0, 135, 0, 310)

	local ButtonsListLayout = Instance.new("UIListLayout")
	ButtonsListLayout.Parent = ButtonsHolder
	ButtonsListLayout.Padding = UDim.new(0.014, 0)
	ButtonsListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- TopBar
	local TopBar = Instance.new("Frame")
	TopBar.Name = "TopBar"
	TopBar.Parent = MainFrame
	TopBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	TopBar.Position = UDim2.new(0.283, 0, 0, 0)
	TopBar.Size = UDim2.new(0, 490, 0, 41)
	
	MakeDraggable(TopBar, MainFrame) -- Make draggable by topbar

	local TopBarUICorner = Instance.new("UICorner")
	TopBarUICorner.CornerRadius = UDim.new(0, 5)
	TopBarUICorner.Parent = TopBar

	local DiscordLabel = Instance.new("TextLabel")
	DiscordLabel.Name = "DiscordLabel"
	DiscordLabel.Parent = TopBar
	DiscordLabel.BackgroundTransparency = 1
	DiscordLabel.Position = UDim2.new(0.78, 0, 0.066, 0)
	DiscordLabel.Size = UDim2.new(0, 100, 0, 35)
	DiscordLabel.Font = Enum.Font.Gotham
	DiscordLabel.Text = discord
	DiscordLabel.TextColor3 = Color3.fromRGB(120, 138, 255)
	DiscordLabel.TextScaled = true
	DiscordLabel.TextSize = 27
	DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
	DiscordLabel.TextWrapped = true

	local VersionLabel = Instance.new("TextLabel")
	VersionLabel.Name = "VersionLabel"
	VersionLabel.Parent = TopBar
	VersionLabel.BackgroundTransparency = 1
	VersionLabel.Position = UDim2.new(0.686, 0, 0.066, 0)
	VersionLabel.Size = UDim2.new(0, 38, 0, 35)
	VersionLabel.Font = Enum.Font.Gotham
	VersionLabel.Text = version
	VersionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	VersionLabel.TextSize = 10
	VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
	VersionLabel.TextWrapped = true

	-- Tabs Container
	local TabsContainer = Instance.new("Frame")
	TabsContainer.Name = "Tabs"
	TabsContainer.Parent = MainFrame
	TabsContainer.BackgroundTransparency = 1
	TabsContainer.Position = UDim2.new(0.283, 0, 0.097, 0)
	TabsContainer.Size = UDim2.new(0, 490, 0, 419)

	-- Home Tab
	local HomeFrame = Instance.new("Frame")
	HomeFrame.Name = "HomeFrame"
	HomeFrame.Parent = TabsContainer
	HomeFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	HomeFrame.Size = UDim2.new(0, 490, 0, 419)
	HomeFrame.Visible = true

	local HomeFrameUICorner = Instance.new("UICorner")
	HomeFrameUICorner.CornerRadius = UDim.new(0, 5)
	HomeFrameUICorner.Parent = HomeFrame

	local WelcomeLabel = Instance.new("TextLabel")
	WelcomeLabel.Name = "WelcomeLabel"
	WelcomeLabel.Parent = HomeFrame
	WelcomeLabel.BackgroundTransparency = 1
	WelcomeLabel.Position = UDim2.new(0.012, 0, 0.008, 0)
	WelcomeLabel.Size = UDim2.new(0, 477, 0, 42)
	WelcomeLabel.Font = Enum.Font.Gotham
	WelcomeLabel.Text = "Welcome, " .. LocalPlayer.DisplayName .. "!"
	WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	WelcomeLabel.TextScaled = true
	WelcomeLabel.TextSize = 27
	WelcomeLabel.TextXAlignment = Enum.TextXAlignment.Left
	WelcomeLabel.TextWrapped = true

	local Bar = Instance.new("Frame")
	Bar.Name = "Bar"
	Bar.Parent = HomeFrame
	Bar.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
	Bar.BorderSizePixel = 0
	Bar.Position = UDim2.new(0.012, 0, 0.107, 0)
	Bar.Size = UDim2.new(0, 477, 0, 1)

	local FeaturesFrame = Instance.new("Frame")
	FeaturesFrame.Name = "FeaturesFrame"
	FeaturesFrame.Parent = HomeFrame
	FeaturesFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
	FeaturesFrame.Position = UDim2.new(0.012, 0, 0.137, 0)
	FeaturesFrame.Size = UDim2.new(0, 477, 0, 353)

	local FeaturesFrameUICorner = Instance.new("UICorner")
	FeaturesFrameUICorner.CornerRadius = UDim.new(0, 5)
	FeaturesFrameUICorner.Parent = FeaturesFrame

	local FeaturesScrolling = Instance.new("ScrollingFrame")
	FeaturesScrolling.Name = "FeaturesScrolling"
	FeaturesScrolling.Parent = FeaturesFrame
	FeaturesScrolling.Active = true
	FeaturesScrolling.BackgroundTransparency = 1
	FeaturesScrolling.BorderSizePixel = 0
	FeaturesScrolling.Size = UDim2.new(1, 0, 1, 0)
	FeaturesScrolling.ScrollBarThickness = 0
	FeaturesScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y

	local FeaturesListLayout = Instance.new("UIListLayout")
	FeaturesListLayout.Parent = FeaturesScrolling
	FeaturesListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local FeaturesPadding = Instance.new("UIPadding")
	FeaturesPadding.Parent = FeaturesScrolling
	FeaturesPadding.PaddingBottom = UDim.new(0, 5)
	FeaturesPadding.PaddingLeft = UDim.new(0, 5)
	FeaturesPadding.PaddingRight = UDim.new(0, 5)

	-- Home Button (SideBar)
	local HomeButton = Instance.new("TextButton")
	HomeButton.Name = "HomeButton"
	HomeButton.Parent = SideBar
	HomeButton.BackgroundColor3 = Color3.fromRGB(102, 5, 172) -- Active by default
	HomeButton.Position = UDim2.new(0.135, 0, 0.2, 2)
	HomeButton.Size = UDim2.new(0.714, 0, 0, 35)
	HomeButton.Font = Enum.Font.SourceSans
	HomeButton.Text = ""
	HomeButton.TextSize = 17

	local HomeButtonUICorner = Instance.new("UICorner")
	HomeButtonUICorner.CornerRadius = UDim.new(0, 4)
	HomeButtonUICorner.Parent = HomeButton

	local HomeTextLabel = Instance.new("TextLabel")
	HomeTextLabel.Name = "homeTextLabel"
	HomeTextLabel.Parent = HomeButton
	HomeTextLabel.BackgroundTransparency = 1
	HomeTextLabel.Position = UDim2.new(0.096, 0, 0.314, 0)
	HomeTextLabel.Size = UDim2.new(0, 122, 0, 13)
	HomeTextLabel.Font = Enum.Font.Gotham
	HomeTextLabel.Text = "Home"
	HomeTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	HomeTextLabel.TextScaled = true
	HomeTextLabel.TextSize = 15
	HomeTextLabel.TextXAlignment = Enum.TextXAlignment.Left

	HomeButton.MouseButton1Click:Connect(function()
		-- Switch to Home
		for _, v in pairs(TabsContainer:GetChildren()) do
			v.Visible = false
		end
		HomeFrame.Visible = true

		-- Reset all buttons
		for _, v in pairs(ButtonsHolder:GetChildren()) do
			if v:IsA("TextButton") then
				TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
				if v:FindFirstChild("TextLabel") then
					TweenService:Create(v.TextLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(116, 116, 116)}):Play()
				end
			end
		end

		-- Activate Home Button
		TweenService:Create(HomeButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(101, 4, 171)}):Play()
		TweenService:Create(HomeTextLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)

	-- API Features for Home
	function GUI:FeatureNewGame(name)
		name = name or "- New Game"
		local GameLabel = Instance.new("TextLabel")
		GameLabel.Name = "FeatureGameName"
		GameLabel.Parent = FeaturesScrolling
		GameLabel.BackgroundTransparency = 1
		GameLabel.Size = UDim2.new(0, 471, 0, 42)
		GameLabel.Font = Enum.Font.Gotham
		GameLabel.Text = name
		GameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		GameLabel.TextScaled = true
		GameLabel.TextSize = 27
		GameLabel.TextXAlignment = Enum.TextXAlignment.Left
		GameLabel.TextWrapped = true
		return GameLabel
	end

	function GUI:FeatureNewFeature(featureLabel)
		featureLabel = featureLabel or "- New Feature"
		local FeatureLabel = Instance.new("TextLabel")
		FeatureLabel.Name = "NewFeature"
		FeatureLabel.Parent = FeaturesScrolling
		FeatureLabel.BackgroundTransparency = 1
		FeatureLabel.Size = UDim2.new(0, 471, 0, 24)
		FeatureLabel.Font = Enum.Font.Gotham
		FeatureLabel.Text = featureLabel
		FeatureLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		FeatureLabel.TextSize = 20
		FeatureLabel.TextXAlignment = Enum.TextXAlignment.Left
		FeatureLabel.TextWrapped = true
		return FeatureLabel
	end

	-- Tab Creation
	function GUI:NewTab(tabName)
		tabName = tabName or "New Tab"
		local Tab = {}

		-- Tab Button
		local TabBtn = Instance.new("TextButton")
		TabBtn.Name = tabName .. "_Button"
		TabBtn.Parent = ButtonsHolder
		TabBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		TabBtn.Size = UDim2.new(1, 0, 0, 35)
		TabBtn.Font = Enum.Font.SourceSans
		TabBtn.Text = ""
		TabBtn.TextSize = 17

		local TabBtnUICorner = Instance.new("UICorner")
		TabBtnUICorner.CornerRadius = UDim.new(0, 4)
		TabBtnUICorner.Parent = TabBtn

		local TabBtnLabel = Instance.new("TextLabel")
		TabBtnLabel.Name = "TextLabel"
		TabBtnLabel.Parent = TabBtn
		TabBtnLabel.BackgroundTransparency = 1
		TabBtnLabel.Position = UDim2.new(0.096, 0, 0.314, 0)
		TabBtnLabel.Size = UDim2.new(0, 122, 0, 13)
		TabBtnLabel.Font = Enum.Font.Gotham
		TabBtnLabel.Text = tabName
		TabBtnLabel.TextColor3 = Color3.fromRGB(117, 117, 117)
		TabBtnLabel.TextScaled = true
		TabBtnLabel.TextSize = 15
		TabBtnLabel.TextXAlignment = Enum.TextXAlignment.Left

		-- Tab Content Frame
		local TabFrame = Instance.new("Frame")
		TabFrame.Name = tabName .. "_Frame"
		TabFrame.Parent = TabsContainer
		TabFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		TabFrame.Size = UDim2.new(0, 490, 0, 419)
		TabFrame.ClipsDescendants = true
		TabFrame.Visible = false

		local TabFrameUICorner = Instance.new("UICorner")
		TabFrameUICorner.CornerRadius = UDim.new(0, 5)
		TabFrameUICorner.Parent = TabFrame

		local TabScrolling = Instance.new("ScrollingFrame")
		TabScrolling.Name = "TabScrolling"
		TabScrolling.Parent = TabFrame
		TabScrolling.Active = true
		TabScrolling.BackgroundTransparency = 1
		TabScrolling.BorderSizePixel = 0
		TabScrolling.Size = UDim2.new(1, 0, 1, 0)
		TabScrolling.ScrollBarThickness = 0
		TabScrolling.AutomaticCanvasSize = Enum.AutomaticSize.Y

		local TabPadding = Instance.new("UIPadding")
		TabPadding.Parent = TabScrolling
		TabPadding.PaddingBottom = UDim.new(0, 5)
		TabPadding.PaddingLeft = UDim.new(0, 5)
		TabPadding.PaddingRight = UDim.new(0, 5)
		TabPadding.PaddingTop = UDim.new(0, 5)

		local TabListLayout = Instance.new("UIListLayout")
		TabListLayout.Parent = TabScrolling
		TabListLayout.Padding = UDim.new(0, 5)
		TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		-- Connect Tab Switch
		TabBtn.MouseButton1Click:Connect(function()
			-- Switch to this Tab
			for _, v in pairs(TabsContainer:GetChildren()) do
				v.Visible = false
			end
			TabFrame.Visible = true

			-- Reset all buttons
			for _, v in pairs(ButtonsHolder:GetChildren()) do
				if v:IsA("TextButton") then
					TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
					if v:FindFirstChild("TextLabel") then
						TweenService:Create(v.TextLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(116, 116, 116)}):Play()
					end
				end
			end
			
			-- Reset Home Button
			TweenService:Create(HomeButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
			TweenService:Create(HomeTextLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(116, 116, 116)}):Play()

			-- Activate this button
			TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(101, 4, 171)}):Play()
			TweenService:Create(TabBtnLabel, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)

		-- Components
		function Tab:NewLabel(label)
			label = label or "New Label"
			local Label = {}
			
			local LabelFrame = Instance.new("TextLabel")
			LabelFrame.Name = "Label"
			LabelFrame.Parent = TabScrolling
			LabelFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			LabelFrame.Size = UDim2.new(0, 478, 0, 35)
			LabelFrame.Font = Enum.Font.Gotham
			LabelFrame.Text = label
			LabelFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
			LabelFrame.TextSize = 14

			local LabelUICorner = Instance.new("UICorner")
			LabelUICorner.CornerRadius = UDim.new(0, 5)
			LabelUICorner.Parent = LabelFrame

			Label.Instance = LabelFrame
			return Label
		end

		function Tab:NewButton(label, callback)
			label = label or "New Button"
			callback = callback or function() end
			local Button = {}

			local ButtonFrame = Instance.new("Frame")
			ButtonFrame.Name = "ButtonFrame"
			ButtonFrame.Parent = TabScrolling
			ButtonFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			ButtonFrame.Size = UDim2.new(0, 478, 0, 50)

			local ButtonUICorner = Instance.new("UICorner")
			ButtonUICorner.CornerRadius = UDim.new(0, 5)
			ButtonUICorner.Parent = ButtonFrame

			local ButtonLabel = Instance.new("TextLabel")
			ButtonLabel.Parent = ButtonFrame
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
			ButtonLabel.Font = Enum.Font.Gotham
			ButtonLabel.Text = label
			ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ButtonLabel.TextSize = 14

			local MainButton = Instance.new("TextButton")
			MainButton.Name = "MainButton"
			MainButton.Parent = ButtonFrame
			MainButton.BackgroundTransparency = 1
			MainButton.Size = UDim2.new(1, 0, 1, 0)
			MainButton.Text = ""
			
			local UIStroke = Instance.new("UIStroke")
			UIStroke.Parent = ButtonFrame
			UIStroke.Color = Color3.fromRGB(102, 5, 172)
			UIStroke.Thickness = 0

			MainButton.MouseEnter:Connect(function()
				UIStroke.Thickness = 1
			end)
			MainButton.MouseLeave:Connect(function()
				UIStroke.Thickness = 0
			end)
			MainButton.MouseButton1Click:Connect(function()
				UIStroke.Thickness = 3
				task.spawn(callback)
				task.wait(0.15)
				UIStroke.Thickness = 1
			end)

			Button.Instance = ButtonFrame
			return Button
		end

		function Tab:NewSlider(label, min, max, default, callback)
			label = label or "New Slider"
			min = min or 0
			max = max or 100
			default = default or min
			callback = callback or function() end

			local Slider = {}
			local Value = default

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Name = "SliderFrame"
			SliderFrame.Parent = TabScrolling
			SliderFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			SliderFrame.Size = UDim2.new(0, 478, 0, 55)

			local SliderUICorner = Instance.new("UICorner")
			SliderUICorner.CornerRadius = UDim.new(0, 5)
			SliderUICorner.Parent = SliderFrame

			local Label = Instance.new("TextLabel")
			Label.Parent = SliderFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.023, 0, 0, 0)
			Label.Size = UDim2.new(0.845, 0, 0.491, 0)
			Label.Font = Enum.Font.Gotham
			Label.Text = label
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local ValueLabel = Instance.new("TextLabel")
			ValueLabel.Parent = SliderFrame
			ValueLabel.BackgroundTransparency = 1
			ValueLabel.Position = UDim2.new(0.868, 0, 0, 0)
			ValueLabel.Size = UDim2.new(0.119, 0, 0.491, 0)
			ValueLabel.Font = Enum.Font.Gotham
			ValueLabel.Text = tostring(default)
			ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ValueLabel.TextSize = 14

			local SliderBg = Instance.new("Frame")
			SliderBg.Name = "SliderBg"
			SliderBg.Parent = SliderFrame
			SliderBg.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			SliderBg.Position = UDim2.new(0.023, 0, 0.518, 0)
			SliderBg.Size = UDim2.new(0, 454, 0, 19)

			local SliderBgCorner = Instance.new("UICorner")
			SliderBgCorner.CornerRadius = UDim.new(0, 5)
			SliderBgCorner.Parent = SliderBg

			local SliderFill = Instance.new("Frame")
			SliderFill.Name = "SliderFill"
			SliderFill.Parent = SliderBg
			SliderFill.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
			SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)

			local SliderFillCorner = Instance.new("UICorner")
			SliderFillCorner.CornerRadius = UDim.new(0, 5)
			SliderFillCorner.Parent = SliderFill

			local Trigger = Instance.new("TextButton")
			Trigger.Parent = SliderBg
			Trigger.BackgroundTransparency = 1
			Trigger.Size = UDim2.new(1, 0, 1, 0)
			Trigger.Text = ""

			Trigger.MouseButton1Down:Connect(function()
				local MouseMove, MouseKill
				MouseMove = Mouse.Move:Connect(function()
					local Px = GetXY(SliderBg)
					local Percent = math.clamp(Px, 0, 1)
					local NewValue = math.floor(min + ((max - min) * Percent))
					
					SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
					ValueLabel.Text = tostring(NewValue)
					callback(NewValue)
				end)
				
				MouseKill = UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if MouseMove then MouseMove:Disconnect() end
						if MouseKill then MouseKill:Disconnect() end
					end
				end)
			end)
			
			Slider.Instance = SliderFrame
			return Slider
		end

		function Tab:NewToggle(label, callback)
			label = label or "New Toggle"
			callback = callback or function() end
			local Toggle = {}
			local State = false

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Name = "ToggleFrame"
			ToggleFrame.Parent = TabScrolling
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			ToggleFrame.Size = UDim2.new(0, 478, 0, 50)

			local ToggleUICorner = Instance.new("UICorner")
			ToggleUICorner.CornerRadius = UDim.new(0, 5)
			ToggleUICorner.Parent = ToggleFrame

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Parent = ToggleFrame
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Position = UDim2.new(0.023, 0, 0, 0)
			ToggleLabel.Size = UDim2.new(0.801, 0, 1, 0)
			ToggleLabel.Font = Enum.Font.Gotham
			ToggleLabel.Text = label
			ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			ToggleLabel.TextSize = 14
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

			local ToggleButton = Instance.new("TextButton")
			ToggleButton.Parent = ToggleFrame
			ToggleButton.BackgroundTransparency = 1
			ToggleButton.Position = UDim2.new(0.865, 0, 0.24, 0)
			ToggleButton.Size = UDim2.new(0, 58, 0, 26) -- Adjusted size
			ToggleButton.Text = ""

			local ToggleBg = Instance.new("Frame")
			ToggleBg.Parent = ToggleButton
			ToggleBg.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			ToggleBg.Size = UDim2.new(1, 0, 1, 0)
			
			local ToggleBgCorner = Instance.new("UICorner")
			ToggleBgCorner.CornerRadius = UDim.new(0, 5)
			ToggleBgCorner.Parent = ToggleBg

			local Indicator = Instance.new("Frame")
			Indicator.Parent = ToggleBg
			Indicator.BackgroundColor3 = Color3.fromRGB(255, 81, 81)
			Indicator.Position = UDim2.new(0, 34, 0.115, 0) -- Off position (Right?) Wait, original logic:
			-- Original: Off -> Position 34 (Right), Red. On -> Position 4 (Left), Green.
			-- Usually toggles are Left=Off, Right=On. But I will follow the original logic found in the code.
			-- Wait, re-reading original code:
			-- Click: if not State (turning ON) -> Position 4, Green.
			-- else (turning OFF) -> Position 34, Red.
			-- So 4 is Left (Green/On), 34 is Right (Red/Off). This is inverted from standard toggles?
			-- Let's check original code line 816:
			-- `Toggle["4f"].Position = UDim2.new(0, 4, ...)` for State=true (Green)
			-- `Toggle["4f"].Position = UDim2.new(0, 34, ...)` for State=false (Red)
			-- Standard toggles: Left is usually Off.
			-- But `0, 4` is left. `0, 34` is right.
			-- So ON = Left (Green). OFF = Right (Red).
			-- That is... unique. I will replicate it.
			
			Indicator.Size = UDim2.new(0, 20, 0, 20)
			
			local IndicatorCorner = Instance.new("UICorner")
			IndicatorCorner.CornerRadius = UDim.new(0, 5)
			IndicatorCorner.Parent = Indicator

			ToggleButton.MouseButton1Click:Connect(function()
				State = not State
				if State then
					TweenService:Create(Indicator, TweenInfo.new(0.2), {
						Position = UDim2.new(0, 4, 0.115, 0),
						BackgroundColor3 = Color3.fromRGB(2, 255, 108)
					}):Play()
				else
					TweenService:Create(Indicator, TweenInfo.new(0.2), {
						Position = UDim2.new(0, 34, 0.115, 0),
						BackgroundColor3 = Color3.fromRGB(255, 81, 81)
					}):Play()
				end
				callback(State)
			end)

			Toggle.Instance = ToggleFrame
			return Toggle
		end

		function Tab:NewDropdown(label, itemList, callback)
			label = label or "New Dropdown"
			itemList = itemList or {}
			callback = callback or function() end
			local Dropdown = {}
			local Opened = false

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Name = "DropdownFrame"
			DropdownFrame.Parent = TabScrolling
			DropdownFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			DropdownFrame.Size = UDim2.new(0, 478, 0, 50)
			DropdownFrame.ClipsDescendants = true

			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, 5)
			DropdownCorner.Parent = DropdownFrame

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Parent = DropdownFrame
			DropdownLabel.BackgroundTransparency = 1
			DropdownLabel.Size = UDim2.new(0.845, 0, 0, 50)
			DropdownLabel.Font = Enum.Font.Gotham
			DropdownLabel.Text = label
			DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			DropdownLabel.TextSize = 14
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.Position = UDim2.new(0, 10, 0, 0)

			local SelectedLabel = Instance.new("TextLabel")
			SelectedLabel.Parent = DropdownFrame
			SelectedLabel.BackgroundTransparency = 1
			SelectedLabel.Position = UDim2.new(0.72, 0, 0, 0)
			SelectedLabel.Size = UDim2.new(0.345, -50, 0, 50) -- Adjust to avoid overlapping button
			SelectedLabel.Font = Enum.Font.Gotham
			SelectedLabel.Text = "None"
			SelectedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SelectedLabel.TextSize = 14
			SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right

			local ArrowButton = Instance.new("TextButton")
			ArrowButton.Parent = DropdownFrame
			ArrowButton.BackgroundTransparency = 1
			ArrowButton.Position = UDim2.new(1, -50, 0, 0)
			ArrowButton.Size = UDim2.new(0, 50, 0, 50)
			ArrowButton.Font = Enum.Font.SourceSans
			ArrowButton.Text = ">"
			ArrowButton.TextSize = 20
			ArrowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			ArrowButton.Rotation = -90

			local ItemsScroll = Instance.new("ScrollingFrame")
			ItemsScroll.Parent = DropdownFrame
			ItemsScroll.BackgroundTransparency = 1
			ItemsScroll.BorderSizePixel = 0
			ItemsScroll.Position = UDim2.new(0, 0, 0, 50)
			ItemsScroll.Size = UDim2.new(1, 0, 1, -50)
			ItemsScroll.Visible = false
			ItemsScroll.ScrollBarThickness = 2

			local ItemsListLayout = Instance.new("UIListLayout")
			ItemsListLayout.Parent = ItemsScroll
			ItemsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ItemsListLayout.Padding = UDim.new(0, 5)
			
			local ItemsPadding = Instance.new("UIPadding")
			ItemsPadding.Parent = ItemsScroll
			ItemsPadding.PaddingLeft = UDim.new(0, 10)
			ItemsPadding.PaddingRight = UDim.new(0, 10)
			ItemsPadding.PaddingTop = UDim.new(0, 5)

			local function ToggleDropdown()
				Opened = not Opened
				if Opened then
					DropdownFrame:TweenSize(UDim2.new(0, 478, 0, 310), "Out", "Quad", 0.3, true)
					TweenService:Create(ArrowButton, TweenInfo.new(0.3), {Rotation = 90}):Play()
					ItemsScroll.Visible = true
				else
					DropdownFrame:TweenSize(UDim2.new(0, 478, 0, 50), "Out", "Quad", 0.3, true)
					TweenService:Create(ArrowButton, TweenInfo.new(0.3), {Rotation = -90}):Play()
					task.wait(0.3)
					if not Opened then ItemsScroll.Visible = false end
				end
			end

			ArrowButton.MouseButton1Click:Connect(ToggleDropdown)

			for _, item in pairs(itemList) do
				local ItemFrame = Instance.new("Frame")
				ItemFrame.Parent = ItemsScroll
				ItemFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
				ItemFrame.Size = UDim2.new(1, 0, 0, 50)
				
				local ItemCorner = Instance.new("UICorner")
				ItemCorner.CornerRadius = UDim.new(0, 5)
				ItemCorner.Parent = ItemFrame
				
				local ItemStroke = Instance.new("UIStroke")
				ItemStroke.Parent = ItemFrame
				ItemStroke.Color = Color3.fromRGB(102, 5, 172)
				ItemStroke.Thickness = 1

				local ItemButton = Instance.new("TextButton")
				ItemButton.Parent = ItemFrame
				ItemButton.BackgroundTransparency = 1
				ItemButton.Size = UDim2.new(1, 0, 1, 0)
				ItemButton.Font = Enum.Font.Gotham
				ItemButton.Text = tostring(item)
				ItemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				ItemButton.TextSize = 14

				ItemButton.MouseButton1Click:Connect(function()
					SelectedLabel.Text = tostring(item)
					ToggleDropdown()
					task.spawn(function()
						ItemStroke.Thickness = 3
						task.wait(0.1)
						ItemStroke.Thickness = 1
					end)
					callback(item)
				end)
			end

			Dropdown.Instance = DropdownFrame
			return Dropdown
		end
		
		function Tab:NewBar()
			local Bar = {}
			local BarFrame = Instance.new("Frame")
			BarFrame.Parent = TabScrolling
			BarFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			BarFrame.Size = UDim2.new(0, 478, 0, 7)
			
			local BarCorner = Instance.new("UICorner")
			BarCorner.CornerRadius = UDim.new(0, 5)
			BarCorner.Parent = BarFrame
			
			local BarStroke = Instance.new("UIStroke")
			BarStroke.Parent = BarFrame
			BarStroke.Color = Color3.fromRGB(102, 5, 172)
			BarStroke.Thickness = 1 -- Original had logic but didn't set thickness? Defaults to 1 usually.
			
			Bar.Instance = BarFrame
			return Bar
		end

		function Tab:NewKeybind(label, key, callback)
			label = label or "New Keybind"
			callback = callback or function() end
			local Keybind = {}

			-- bindType: "Keyboard" or "Mouse"
			-- bindKey:  Enum.KeyCode        (used when bindType == "Keyboard")
			-- bindMouseType: Enum.UserInputType (used when bindType == "Mouse")
			local bindType, bindKey, bindMouseType

			local mouseButtonNames = {
				[Enum.UserInputType.MouseButton1] = "MB1",
				[Enum.UserInputType.MouseButton2] = "MB2",
				[Enum.UserInputType.MouseButton3] = "MB3",
				[Enum.UserInputType.MouseButton4] = "MB4",
				[Enum.UserInputType.MouseButton5] = "MB5",
			}

			-- Accept either a KeyCode or a UserInputType as the default bind
			if typeof(key) == "EnumItem" then
				if key.EnumType == Enum.KeyCode then
					bindType = "Keyboard"
					bindKey  = key
				elseif key.EnumType == Enum.UserInputType and mouseButtonNames[key] then
					bindType      = "Mouse"
					bindMouseType = key
				else
					bindType = "Keyboard"
					bindKey  = Enum.KeyCode.Unknown
				end
			else
				bindType = "Keyboard"
				bindKey  = Enum.KeyCode.Unknown
			end

			local function currentBindName()
				if bindType == nil then
					return "None"
				elseif bindType == "Mouse" then
					return mouseButtonNames[bindMouseType] or bindMouseType.Name
				else
					return bindKey.Name
				end
			end

			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Parent = TabScrolling
			KeybindFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			KeybindFrame.Size = UDim2.new(0, 478, 0, 50)

			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, 5)
			KeybindCorner.Parent = KeybindFrame

			local Label = Instance.new("TextLabel")
			Label.Parent = KeybindFrame
			Label.BackgroundTransparency = 1
			Label.Position = UDim2.new(0.023, 0, 0, 0)
			Label.Size = UDim2.new(0.8, 0, 1, 0)
			Label.Font = Enum.Font.Gotham
			Label.Text = label
			Label.TextColor3 = Color3.fromRGB(255, 255, 255)
			Label.TextSize = 14
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local KeyButton = Instance.new("TextButton")
			KeyButton.Parent = KeybindFrame
			KeyButton.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			KeyButton.Position = UDim2.new(0.824, 0, 0.24, 0)
			KeyButton.Size = UDim2.new(0, 76, 0, 26)
			KeyButton.Font = Enum.Font.Gotham
			KeyButton.Text = currentBindName()
			KeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			KeyButton.TextSize = 14

			local KeyButtonCorner = Instance.new("UICorner")
			KeyButtonCorner.CornerRadius = UDim.new(0, 5)
			KeyButtonCorner.Parent = KeyButton

			KeyButton.MouseButton1Click:Connect(function()
				KeyButton.Text = "..."
				local done = false
				local conn

				local function finish(input)
					if done then return end
					done = true
					conn:Disconnect()

					if input == nil then
						-- Timeout: clear bind
						bindType      = nil
						bindKey       = nil
						bindMouseType = nil
					elseif input.UserInputType == Enum.UserInputType.Keyboard then
						bindType = "Keyboard"
						bindKey  = input.KeyCode
					elseif mouseButtonNames[input.UserInputType] then
						bindType      = "Mouse"
						bindMouseType = input.UserInputType
					end
					KeyButton.Text = currentBindName()
				end

				conn = UserInputService.InputBegan:Connect(finish)
				task.delay(1.5, function() finish(nil) end)
			end)

			UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if gameProcessed then return end
				if bindType == "Keyboard" and input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode == bindKey then
						callback(bindKey)
					end
				elseif bindType == "Mouse" and input.UserInputType == bindMouseType then
					callback(bindMouseType)
				end
			end)

			Keybind.Instance = KeybindFrame
			return Keybind
		end

		return Tab
	end

	return GUI
end

return Library
