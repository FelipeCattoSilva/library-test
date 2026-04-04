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

		-- Two-column layout: Left (235px) | gap (6px) | Right (235px) + 7px padding each side = 490
		local COL_W, GAP, PAD = 235, 6, 7

		local LeftScroll = Instance.new("ScrollingFrame")
		LeftScroll.Name = "LeftColumn"
		LeftScroll.Parent = TabFrame
		LeftScroll.BackgroundTransparency = 1
		LeftScroll.BorderSizePixel = 0
		LeftScroll.Position = UDim2.new(0, PAD, 0, PAD)
		LeftScroll.Size = UDim2.new(0, COL_W, 1, -PAD * 2)
		LeftScroll.ScrollBarThickness = 0
		LeftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

		local LeftLayout = Instance.new("UIListLayout")
		LeftLayout.Parent = LeftScroll
		LeftLayout.Padding = UDim.new(0, 6)
		LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local RightScroll = Instance.new("ScrollingFrame")
		RightScroll.Name = "RightColumn"
		RightScroll.Parent = TabFrame
		RightScroll.BackgroundTransparency = 1
		RightScroll.BorderSizePixel = 0
		RightScroll.Position = UDim2.new(0, PAD + COL_W + GAP, 0, PAD)
		RightScroll.Size = UDim2.new(0, COL_W, 1, -PAD * 2)
		RightScroll.ScrollBarThickness = 0
		RightScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

		local RightLayout = Instance.new("UIListLayout")
		RightLayout.Parent = RightScroll
		RightLayout.Padding = UDim.new(0, 6)
		RightLayout.SortOrder = Enum.SortOrder.LayoutOrder

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

		-- NewSection: creates a named card in Left or Right column
		function Tab:NewSection(name, side)
			name = name or "Section"
			local col = (tostring(side or "left")):lower() == "right" and RightScroll or LeftScroll
			local Section = {}

			-- ── Section container (auto-sizes Y) ─────────────────────────
			local SectionFrame = Instance.new("Frame")
			SectionFrame.Parent = col
			SectionFrame.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			SectionFrame.BorderSizePixel = 0
			SectionFrame.Size = UDim2.new(1, 0, 0, 0)
			SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

			local SectionCorner = Instance.new("UICorner")
			SectionCorner.CornerRadius = UDim.new(0, 6)
			SectionCorner.Parent = SectionFrame

			-- Header
			local Header = Instance.new("Frame")
			Header.Parent = SectionFrame
			Header.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
			Header.BorderSizePixel = 0
			Header.Size = UDim2.new(1, 0, 0, 28)

			local HeaderCorner = Instance.new("UICorner")
			HeaderCorner.CornerRadius = UDim.new(0, 6)
			HeaderCorner.Parent = Header

			-- Fill bottom corners of header so accent line sits flush
			local HeaderFill = Instance.new("Frame")
			HeaderFill.Parent = Header
			HeaderFill.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
			HeaderFill.BorderSizePixel = 0
			HeaderFill.Position = UDim2.new(0, 0, 0.5, 0)
			HeaderFill.Size = UDim2.new(1, 0, 0.5, 0)

			local HeaderTitle = Instance.new("TextLabel")
			HeaderTitle.Parent = Header
			HeaderTitle.BackgroundTransparency = 1
			HeaderTitle.Position = UDim2.new(0, 10, 0, 0)
			HeaderTitle.Size = UDim2.new(1, -10, 1, 0)
			HeaderTitle.Font = Enum.Font.GothamBold
			HeaderTitle.Text = name
			HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
			HeaderTitle.TextSize = 12
			HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

			-- Purple accent line below header
			local Accent = Instance.new("Frame")
			Accent.Parent = SectionFrame
			Accent.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
			Accent.BorderSizePixel = 0
			Accent.Position = UDim2.new(0, 0, 0, 28)
			Accent.Size = UDim2.new(1, 0, 0, 2)

			-- Content (auto-sizes Y, elements stacked by UIListLayout)
			local Content = Instance.new("Frame")
			Content.Name = "Content"
			Content.Parent = SectionFrame
			Content.BackgroundTransparency = 1
			Content.Position = UDim2.new(0, 0, 0, 30)
			Content.Size = UDim2.new(1, 0, 0, 0)
			Content.AutomaticSize = Enum.AutomaticSize.Y

			local ContentPad = Instance.new("UIPadding")
			ContentPad.Parent = Content
			ContentPad.PaddingLeft   = UDim.new(0, 6)
			ContentPad.PaddingRight  = UDim.new(0, 6)
			ContentPad.PaddingTop    = UDim.new(0, 6)
			ContentPad.PaddingBottom = UDim.new(0, 8)

			local ContentList = Instance.new("UIListLayout")
			ContentList.Parent = Content
			ContentList.Padding = UDim.new(0, 5)
			ContentList.SortOrder = Enum.SortOrder.LayoutOrder

			-- ── Helpers ───────────────────────────────────────────────────
			local function mkCorner(r, p)
				local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
			end
			local function mkStroke(col2, thick, p)
				local s = Instance.new("UIStroke"); s.Color = col2; s.Thickness = thick; s.Parent = p
			end

			-- ── NewLabel ──────────────────────────────────────────────────
			function Section:NewLabel(text)
				text = text or "Label"
				local f = Instance.new("TextLabel")
				f.Parent = Content
				f.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				f.Size = UDim2.new(1, 0, 0, 26)
				f.Font = Enum.Font.Gotham
				f.Text = text
				f.TextColor3 = Color3.fromRGB(200, 200, 200)
				f.TextSize = 11
				f.TextXAlignment = Enum.TextXAlignment.Left
				local p = Instance.new("UIPadding")
				p.PaddingLeft = UDim.new(0, 8); p.Parent = f
				mkCorner(4, f)
				return {Instance = f}
			end

			-- ── NewButton ─────────────────────────────────────────────────
			function Section:NewButton(text, callback)
				text = text or "Button"; callback = callback or function() end
				local Frame = Instance.new("Frame")
				Frame.Parent = Content
				Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Frame.Size = UDim2.new(1, 0, 0, 32)
				mkCorner(4, Frame)
				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1
				Lbl.Size = UDim2.new(1, 0, 1, 0)
				Lbl.Font = Enum.Font.Gotham; Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
				local Btn = Instance.new("TextButton")
				Btn.Parent = Frame; Btn.BackgroundTransparency = 1
				Btn.Size = UDim2.new(1, 0, 1, 0); Btn.Text = ""
				local Stroke = Instance.new("UIStroke")
				Stroke.Parent = Frame; Stroke.Color = Color3.fromRGB(102, 5, 172); Stroke.Thickness = 0
				Btn.MouseEnter:Connect(function() Stroke.Thickness = 1 end)
				Btn.MouseLeave:Connect(function() Stroke.Thickness = 0 end)
				Btn.MouseButton1Click:Connect(function()
					Stroke.Thickness = 2; task.spawn(callback); task.wait(0.15); Stroke.Thickness = 1
				end)
				return {Instance = Frame}
			end

			-- ── NewToggle ─────────────────────────────────────────────────
			function Section:NewToggle(text, callback)
				text = text or "Toggle"; callback = callback or function() end
				local State = false
				local Frame = Instance.new("Frame")
				Frame.Parent = Content; Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Frame.Size = UDim2.new(1, 0, 0, 34); mkCorner(4, Frame)
				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 8, 0, 0); Lbl.Size = UDim2.new(1, -58, 1, 0)
				Lbl.Font = Enum.Font.Gotham; Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				local TogBtn = Instance.new("TextButton")
				TogBtn.Parent = Frame; TogBtn.BackgroundTransparency = 1
				TogBtn.Position = UDim2.new(1, -50, 0.5, -11)
				TogBtn.Size = UDim2.new(0, 44, 0, 22); TogBtn.Text = ""
				local TogBg = Instance.new("Frame")
				TogBg.Parent = TogBtn; TogBg.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
				TogBg.Size = UDim2.new(1, 0, 1, 0); mkCorner(4, TogBg)
				local Ind = Instance.new("Frame")
				Ind.Parent = TogBg; Ind.BackgroundColor3 = Color3.fromRGB(255, 81, 81)
				Ind.Position = UDim2.new(0, 24, 0.1, 0); Ind.Size = UDim2.new(0, 16, 0.8, 0)
				mkCorner(3, Ind)
				TogBtn.MouseButton1Click:Connect(function()
					State = not State
					if State then
						TweenService:Create(Ind, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.1, 0), BackgroundColor3 = Color3.fromRGB(2, 255, 108)}):Play()
					else
						TweenService:Create(Ind, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0.1, 0), BackgroundColor3 = Color3.fromRGB(255, 81, 81)}):Play()
					end
					callback(State)
				end)
				return {Instance = Frame}
			end

			-- ── NewSlider ─────────────────────────────────────────────────
			function Section:NewSlider(text, min, max, default, callback)
				text = text or "Slider"; min = min or 0; max = max or 100
				default = default or min; callback = callback or function() end
				local Frame = Instance.new("Frame")
				Frame.Parent = Content; Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Frame.Size = UDim2.new(1, 0, 0, 48); mkCorner(4, Frame)
				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 8, 0, 5); Lbl.Size = UDim2.new(0.65, 0, 0, 18)
				Lbl.Font = Enum.Font.Gotham; Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				local ValLbl = Instance.new("TextLabel")
				ValLbl.Parent = Frame; ValLbl.BackgroundTransparency = 1
				ValLbl.Position = UDim2.new(0.65, 0, 0, 5); ValLbl.Size = UDim2.new(0.35, -8, 0, 18)
				ValLbl.Font = Enum.Font.Gotham; ValLbl.Text = tostring(default)
				ValLbl.TextColor3 = Color3.fromRGB(180, 180, 180); ValLbl.TextSize = 11
				ValLbl.TextXAlignment = Enum.TextXAlignment.Right
				local Track = Instance.new("Frame")
				Track.Parent = Frame; Track.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
				Track.Position = UDim2.new(0, 8, 0, 29); Track.Size = UDim2.new(1, -16, 0, 13)
				mkCorner(4, Track)
				local Fill = Instance.new("Frame")
				Fill.Parent = Track; Fill.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
				Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); mkCorner(4, Fill)
				local Trigger = Instance.new("TextButton")
				Trigger.Parent = Track; Trigger.BackgroundTransparency = 1
				Trigger.Size = UDim2.new(1, 0, 1, 0); Trigger.Text = ""
				Trigger.MouseButton1Down:Connect(function()
					local mm, mk
					mm = Mouse.Move:Connect(function()
						local pct = math.clamp(GetXY(Track), 0, 1)
						local val = math.floor(min + (max - min) * pct)
						Fill.Size = UDim2.new(pct, 0, 1, 0); ValLbl.Text = tostring(val); callback(val)
					end)
					mk = UserInputService.InputEnded:Connect(function(inp)
						if inp.UserInputType == Enum.UserInputType.MouseButton1 then
							if mm then mm:Disconnect() end; if mk then mk:Disconnect() end
						end
					end)
				end)
				return {Instance = Frame}
			end

			-- ── NewDropdown ───────────────────────────────────────────────
			function Section:NewDropdown(text, items, callback)
				text = text or "Dropdown"; items = items or {}; callback = callback or function() end
				local Opened = false
				local Frame = Instance.new("Frame")
				Frame.Parent = Content; Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Frame.Size = UDim2.new(1, 0, 0, 34); Frame.ClipsDescendants = true; mkCorner(4, Frame)
				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 8, 0, 0); Lbl.Size = UDim2.new(0.55, 0, 0, 34)
				Lbl.Font = Enum.Font.Gotham; Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				local SelLbl = Instance.new("TextLabel")
				SelLbl.Parent = Frame; SelLbl.BackgroundTransparency = 1
				SelLbl.Position = UDim2.new(0.5, 0, 0, 0); SelLbl.Size = UDim2.new(0.4, -28, 0, 34)
				SelLbl.Font = Enum.Font.Gotham; SelLbl.Text = "None"
				SelLbl.TextColor3 = Color3.fromRGB(180, 180, 180); SelLbl.TextSize = 11
				SelLbl.TextXAlignment = Enum.TextXAlignment.Right
				local Arrow = Instance.new("TextButton")
				Arrow.Parent = Frame; Arrow.BackgroundTransparency = 1
				Arrow.Position = UDim2.new(1, -28, 0, 0); Arrow.Size = UDim2.new(0, 28, 0, 34)
				Arrow.Font = Enum.Font.SourceSans; Arrow.Text = ">"
				Arrow.TextSize = 16; Arrow.TextColor3 = Color3.fromRGB(255, 255, 255); Arrow.Rotation = -90
				local ItemsFrame = Instance.new("Frame")
				ItemsFrame.Parent = Frame; ItemsFrame.BackgroundTransparency = 1
				ItemsFrame.Position = UDim2.new(0, 4, 0, 39)
				ItemsFrame.Size = UDim2.new(1, -8, 0, 0); ItemsFrame.AutomaticSize = Enum.AutomaticSize.Y
				ItemsFrame.Visible = false
				local IL = Instance.new("UIListLayout"); IL.Parent = ItemsFrame
				IL.Padding = UDim.new(0, 3); IL.SortOrder = Enum.SortOrder.LayoutOrder
				local function ToggleDrop()
					Opened = not Opened
					local itemH = 28
					local totalH = Opened and (34 + 5 + #items * itemH + math.max(0, #items - 1) * 3 + 6) or 34
					Frame:TweenSize(UDim2.new(1, 0, 0, totalH), "Out", "Quad", 0.2, true)
					TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = Opened and 90 or -90}):Play()
					ItemsFrame.Visible = Opened
				end
				Arrow.MouseButton1Click:Connect(ToggleDrop)
				for _, item in pairs(items) do
					local IF = Instance.new("Frame")
					IF.Parent = ItemsFrame; IF.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
					IF.Size = UDim2.new(1, 0, 0, 28); mkCorner(4, IF)
					mkStroke(Color3.fromRGB(102, 5, 172), 1, IF)
					local IB = Instance.new("TextButton")
					IB.Parent = IF; IB.BackgroundTransparency = 1
					IB.Size = UDim2.new(1, 0, 1, 0)
					IB.Font = Enum.Font.Gotham; IB.Text = tostring(item)
					IB.TextColor3 = Color3.fromRGB(255, 255, 255); IB.TextSize = 12
					IB.MouseButton1Click:Connect(function()
						SelLbl.Text = tostring(item); ToggleDrop(); callback(item)
					end)
				end
				return {Instance = Frame}
			end

			-- ── NewKeybind ────────────────────────────────────────────────
			function Section:NewKeybind(text, key, callback)
				text = text or "Keybind"; callback = callback or function() end
				local bindType, bindKey, bindMouseName
				local friendlyNames = {MouseButton1="MB1",MouseButton2="MB2",MouseButton3="MB3",MouseButton4="MB4",MouseButton5="MB5"}
				local function getMouseName(t) local ok, n = pcall(function() return t.Name end); return ok and n or nil end
				if typeof(key) == "EnumItem" then
					if key.EnumType == Enum.KeyCode then bindType = "Keyboard"; bindKey = key
					else
						local n = getMouseName(key)
						if n and n:find("MouseButton") then bindType = "Mouse"; bindMouseName = n
						else bindType = "Keyboard"; bindKey = Enum.KeyCode.Unknown end
					end
				else bindType = "Keyboard"; bindKey = Enum.KeyCode.Unknown end
				local function curName()
					if bindType == nil then return "None"
					elseif bindType == "Mouse" then return friendlyNames[bindMouseName] or bindMouseName
					else return bindKey.Name end
				end
				local Frame = Instance.new("Frame")
				Frame.Parent = Content; Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Frame.Size = UDim2.new(1, 0, 0, 34); mkCorner(4, Frame)
				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 8, 0, 0); Lbl.Size = UDim2.new(0.5, 0, 1, 0)
				Lbl.Font = Enum.Font.Gotham; Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				local KBtn = Instance.new("TextButton")
				KBtn.Parent = Frame; KBtn.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
				KBtn.Position = UDim2.new(1, -68, 0.5, -11); KBtn.Size = UDim2.new(0, 62, 0, 22)
				KBtn.Font = Enum.Font.Gotham; KBtn.Text = curName()
				KBtn.TextColor3 = Color3.fromRGB(255, 255, 255); KBtn.TextSize = 11
				mkCorner(4, KBtn)
				KBtn.MouseButton1Click:Connect(function()
					KBtn.Text = "..."
					local done = false; local conn
					local function finish(input)
						if done then return end; done = true; conn:Disconnect()
						if input == nil then bindType = nil; bindKey = nil; bindMouseName = nil
						elseif input.UserInputType == Enum.UserInputType.Keyboard then bindType = "Keyboard"; bindKey = input.KeyCode
						else local n = getMouseName(input.UserInputType); if n and n:find("MouseButton") then bindType = "Mouse"; bindMouseName = n end end
						KBtn.Text = curName()
					end
					conn = UserInputService.InputBegan:Connect(finish)
					task.delay(1.5, function() finish(nil) end)
				end)
				UserInputService.InputBegan:Connect(function(input, gp)
					if gp then return end
					if bindType == "Keyboard" and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == bindKey then callback()
					elseif bindType == "Mouse" then local n = getMouseName(input.UserInputType); if n and n == bindMouseName then callback() end end
				end)
				return {Instance = Frame}
			end

			-- ── NewBar ────────────────────────────────────────────────────
			function Section:NewBar()
				local f = Instance.new("Frame")
				f.Parent = Content; f.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
				f.BorderSizePixel = 0; f.Size = UDim2.new(1, 0, 0, 1)
				return {Instance = f}
			end

			return Section
		end


		return Tab
	end

	return GUI
end

return Library
