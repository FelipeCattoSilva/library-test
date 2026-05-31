local Library = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
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

	-- Config flag registry: flag -> {get=fn, set=fn}
	GUI.Flags = {}
	local ConfigRegistry = {}
	local function RegisterFlag(flag, getter, setter)
		if flag == nil then return end
		local base, i = flag, 2
		while ConfigRegistry[flag] do flag = base .. "_" .. i; i = i + 1 end
		ConfigRegistry[flag] = {get = getter, set = setter}
		return flag
	end

	-- Main ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "Jael Library"
	ScreenGui.Parent = Parent
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	-- ── Tooltip ────────────────────────────────────────────────────
	local Tooltip = Instance.new("Frame")
	Tooltip.Name = "JaelTooltip"
	Tooltip.Parent = ScreenGui
	Tooltip.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Tooltip.AutomaticSize = Enum.AutomaticSize.XY
	Tooltip.Visible = false
	Tooltip.ZIndex = 200
	Tooltip.BorderSizePixel = 0
	local _ttC = Instance.new("UICorner"); _ttC.CornerRadius = UDim.new(0, 4); _ttC.Parent = Tooltip
	local _ttS = Instance.new("UIStroke"); _ttS.Color = Color3.fromRGB(102, 5, 172); _ttS.Thickness = 1; _ttS.Parent = Tooltip
	local _ttP = Instance.new("UIPadding")
	_ttP.PaddingLeft = UDim.new(0, 8); _ttP.PaddingRight = UDim.new(0, 8)
	_ttP.PaddingTop = UDim.new(0, 4); _ttP.PaddingBottom = UDim.new(0, 4); _ttP.Parent = Tooltip
	local TooltipLabel = Instance.new("TextLabel")
	TooltipLabel.Parent = Tooltip; TooltipLabel.BackgroundTransparency = 1
	TooltipLabel.AutomaticSize = Enum.AutomaticSize.XY
	TooltipLabel.Size = UDim2.new(0, 0, 0, 0)
	TooltipLabel.Font = Enum.Font.Gotham; TooltipLabel.Text = ""
	TooltipLabel.TextColor3 = Color3.fromRGB(200, 200, 200); TooltipLabel.TextSize = 11
	TooltipLabel.ZIndex = 201

	local _ttConn
	local function showTooltip(text)
		TooltipLabel.Text = text
		Tooltip.Visible = true
		if _ttConn then _ttConn:Disconnect() end
		_ttConn = RunService.RenderStepped:Connect(function()
			local mp = UserInputService:GetMouseLocation()
			Tooltip.Position = UDim2.new(0, mp.X + 6, 0, mp.Y + 20)
		end)
	end
	local function hideTooltip()
		Tooltip.Visible = false
		if _ttConn then _ttConn:Disconnect(); _ttConn = nil end
	end

	-- ── Notifications ───────────────────────────────────────────────
	local notifCorner = "BottomRight"
	local NotifContainer = Instance.new("Frame")
	NotifContainer.Name = "JaelNotifs"
	NotifContainer.Parent = ScreenGui
	NotifContainer.BackgroundTransparency = 1
	NotifContainer.BorderSizePixel = 0
	NotifContainer.Size = UDim2.new(0, 280, 1, -20)
	NotifContainer.ZIndex = 150
	local NotifList = Instance.new("UIListLayout")
	NotifList.Parent = NotifContainer
	NotifList.Padding = UDim.new(0, 6)
	NotifList.SortOrder = Enum.SortOrder.LayoutOrder

	local function updateNotifLayout()
		local isRight = notifCorner == "TopRight" or notifCorner == "BottomRight"
		local isBottom = notifCorner == "BottomLeft" or notifCorner == "BottomRight"
		NotifContainer.Position = UDim2.new(isRight and 1 or 0, isRight and -288 or 8, 0, 10)
		NotifList.VerticalAlignment = isBottom and Enum.VerticalAlignment.Bottom or Enum.VerticalAlignment.Top
		NotifList.HorizontalAlignment = isRight and Enum.HorizontalAlignment.Right or Enum.HorizontalAlignment.Left
	end
	updateNotifLayout()

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

	-- ── GUI:Notify ─────────────────────────────────────────────────
	function GUI:Notify(title, body, duration)
		title = title or "Notification"
		body = (body and body ~= "") and body or nil
		duration = duration or 3
		local isRight = notifCorner == "TopRight" or notifCorner == "BottomRight"
		local cardH = body and 70 or 48
		local offX = isRight and 300 or -300

		local Wrapper = Instance.new("Frame")
		Wrapper.Parent = NotifContainer
		Wrapper.BackgroundTransparency = 1
		Wrapper.BorderSizePixel = 0
		Wrapper.Size = UDim2.new(1, 0, 0, cardH)

		local Card = Instance.new("Frame")
		Card.Parent = Wrapper
		Card.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
		Card.BorderSizePixel = 0
		Card.Size = UDim2.new(1, 0, 0, cardH)
		Card.Position = UDim2.new(0, offX, 0, 0)
		local _nc = Instance.new("UICorner"); _nc.CornerRadius = UDim.new(0, 6); _nc.Parent = Card
		local _ns = Instance.new("UIStroke"); _ns.Color = Color3.fromRGB(102, 5, 172); _ns.Thickness = 1; _ns.Parent = Card

		local Acc = Instance.new("Frame")
		Acc.Parent = Card; Acc.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
		Acc.BorderSizePixel = 0; Acc.Size = UDim2.new(0, 3, 1, 0)
		local _ac = Instance.new("UICorner"); _ac.CornerRadius = UDim.new(0, 6); _ac.Parent = Acc

		local TLbl = Instance.new("TextLabel")
		TLbl.Parent = Card; TLbl.BackgroundTransparency = 1
		TLbl.Position = UDim2.new(0, 10, 0, 8)
		TLbl.Size = UDim2.new(1, -14, 0, 15)
		TLbl.Font = Enum.Font.GothamBold; TLbl.Text = title
		TLbl.TextColor3 = Color3.fromRGB(255, 255, 255); TLbl.TextSize = 12
		TLbl.TextXAlignment = Enum.TextXAlignment.Left

		if body then
			local BLbl = Instance.new("TextLabel")
			BLbl.Parent = Card; BLbl.BackgroundTransparency = 1
			BLbl.Position = UDim2.new(0, 10, 0, 26)
			BLbl.Size = UDim2.new(1, -14, 0, 22)
			BLbl.Font = Enum.Font.Gotham; BLbl.Text = body
			BLbl.TextColor3 = Color3.fromRGB(180, 180, 180); BLbl.TextSize = 11
			BLbl.TextXAlignment = Enum.TextXAlignment.Left; BLbl.TextWrapped = true
		end

		local ProgBg = Instance.new("Frame")
		ProgBg.Parent = Card; ProgBg.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
		ProgBg.BorderSizePixel = 0
		ProgBg.Position = UDim2.new(0, 10, 0, cardH - 10)
		ProgBg.Size = UDim2.new(1, -20, 0, 4)
		local _pbc = Instance.new("UICorner"); _pbc.CornerRadius = UDim.new(0, 2); _pbc.Parent = ProgBg
		local ProgFill = Instance.new("Frame")
		ProgFill.Parent = ProgBg; ProgFill.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
		ProgFill.BorderSizePixel = 0; ProgFill.Size = UDim2.new(1, 0, 1, 0)
		local _pfc = Instance.new("UICorner"); _pfc.CornerRadius = UDim.new(0, 2); _pfc.Parent = ProgFill

		TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, 0, 0, 0)
		}):Play()

		task.spawn(function()
			task.wait(0.4)
			TweenService:Create(ProgFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
				Size = UDim2.new(0, 0, 1, 0)
			}):Play()
			task.wait(duration)
			TweenService:Create(Card, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				Position = UDim2.new(0, offX, 0, 0)
			}):Play()
			task.wait(0.35)
			Wrapper:Destroy()
		end)
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

		local FullScroll = Instance.new("ScrollingFrame")
		FullScroll.Name = "FullColumn"
		FullScroll.Parent = TabFrame
		FullScroll.BackgroundTransparency = 1
		FullScroll.BorderSizePixel = 0
		FullScroll.Position = UDim2.new(0, PAD, 0, PAD)
		FullScroll.Size = UDim2.new(0, COL_W * 2 + GAP, 1, -PAD * 2)
		FullScroll.ScrollBarThickness = 0
		FullScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		FullScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		FullScroll.ZIndex = 2

		local FullLayout = Instance.new("UIListLayout")
		FullLayout.Parent = FullScroll
		FullLayout.Padding = UDim.new(0, 6)
		FullLayout.SortOrder = Enum.SortOrder.LayoutOrder

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

		-- NewSection: creates a named card in Left, Right, or Full column
		function Tab:NewSection(name, side)
			name = name or "Section"
			local sideStr = (tostring(side or "left")):lower()
			local col = sideStr == "right" and RightScroll
				or sideStr == "full" and FullScroll
				or LeftScroll
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
			local function applyTooltip(frame, tip)
				if not tip or tip == "" then return end
				frame.MouseEnter:Connect(function() showTooltip(tip) end)
				frame.MouseLeave:Connect(function() hideTooltip() end)
			end

			-- ── NewLabel ──────────────────────────────────────────────────
			function Section:NewLabel(text, tooltip)
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
				applyTooltip(f, tooltip)
				return {Instance = f}
			end

			-- ── NewButton ─────────────────────────────────────────────────
			function Section:NewButton(text, callback, tooltip)
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
				applyTooltip(Frame, tooltip)
				return {Instance = Frame}
			end

			-- ── NewToggle ─────────────────────────────────────────────────
			function Section:NewToggle(text, callback, tooltip)
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
				Ind.Position = UDim2.new(0, 4, 0.1, 0); Ind.Size = UDim2.new(0, 16, 0.8, 0)
				mkCorner(3, Ind)
				local function ApplyToggleVisual(s)
					if s then
						TweenService:Create(Ind, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0.1, 0), BackgroundColor3 = Color3.fromRGB(2, 255, 108)}):Play()
					else
						TweenService:Create(Ind, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.1, 0), BackgroundColor3 = Color3.fromRGB(255, 81, 81)}):Play()
					end
				end
				TogBtn.MouseButton1Click:Connect(function()
					State = not State
					ApplyToggleVisual(State)
					callback(State)
				end)
				local self = {Instance = Frame}
				function self:SetState(s)
					State = s
					ApplyToggleVisual(State)
					callback(State)
				end
				RegisterFlag(tabName .. "/" .. name .. "/" .. text,
					function() return State end,
					function(v) self:SetState(v and true or false) end)
				applyTooltip(Frame, tooltip)
				return self
			end

			-- ── NewSlider ─────────────────────────────────────────────────
			function Section:NewSlider(text, min, max, default, callback, tooltip)
				text = text or "Slider"; min = min or 0; max = max or 100
				default = default or min; callback = callback or function() end
				local current = default
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
						current = val
						Fill.Size = UDim2.new(pct, 0, 1, 0); ValLbl.Text = tostring(val); callback(val)
					end)
					mk = UserInputService.InputEnded:Connect(function(inp)
						if inp.UserInputType == Enum.UserInputType.MouseButton1 then
							if mm then mm:Disconnect() end; if mk then mk:Disconnect() end
						end
					end)
				end)
				local self = {Instance = Frame}
				function self:SetValue(val)
					val = math.clamp(math.floor(val), min, max)
					current = val
					local pct = (val - min) / (max - min)
					Fill.Size = UDim2.new(pct, 0, 1, 0)
					ValLbl.Text = tostring(val)
					callback(val)
				end
				RegisterFlag(tabName .. "/" .. name .. "/" .. text,
					function() return current end,
					function(v) self:SetValue(tonumber(v) or current) end)
				applyTooltip(Frame, tooltip)
				return self
			end

			-- ── NewDropdown ───────────────────────────────────────────────
			function Section:NewDropdown(text, items, callback, tooltip)
				text = text or "Dropdown"; items = items or {}; callback = callback or function() end
				local Opened = false
				local selected = nil
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
				local function BuildItems()
					for _, child in pairs(ItemsFrame:GetChildren()) do
						if child:IsA("Frame") then child:Destroy() end
					end
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
							selected = item; SelLbl.Text = tostring(item); ToggleDrop(); callback(item)
						end)
					end
				end
				BuildItems()
				local self = {Instance = Frame}
				function self:UpdateItems(newItems)
					items = newItems or {}
					if Opened then ToggleDrop() end
					BuildItems()
					selected = nil
					SelLbl.Text = "None"
				end
				function self:SetSelected(item)
					selected = item
					SelLbl.Text = item ~= nil and tostring(item) or "None"
				end
				RegisterFlag(tabName .. "/" .. name .. "/" .. text,
					function() return selected end,
					function(v)
						selected = v
						SelLbl.Text = v ~= nil and tostring(v) or "None"
						if v ~= nil then callback(v) end
					end)
				applyTooltip(Frame, tooltip)
				return self
			end

			-- ── NewKeybind ────────────────────────────────────────────────
			function Section:NewKeybind(text, key, callback, tooltip)
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
				local self = {Instance = Frame}
				function self:SetKey(keyCode)
					if typeof(keyCode) == "EnumItem" and keyCode.EnumType == Enum.KeyCode then
						bindType = "Keyboard"; bindKey = keyCode; bindMouseName = nil; KBtn.Text = keyCode.Name
					end
				end
				function self:SetMouseBind(mouseName)
					if type(mouseName) == "string" and mouseName:find("MouseButton") then
						bindType = "Mouse"; bindMouseName = mouseName; bindKey = nil
						KBtn.Text = friendlyNames[mouseName] or mouseName
					end
				end
				function self:GetKey()
					return bindType == "Keyboard" and bindKey or nil
				end
				function self:GetBindInfo()
					return {type = bindType, key = bindKey, mouseName = bindMouseName}
				end
				RegisterFlag(tabName .. "/" .. name .. "/" .. text,
					function()
						return {
							type = bindType,
							key = (bindType == "Keyboard" and bindKey and bindKey ~= Enum.KeyCode.Unknown) and bindKey.Name or nil,
							mouseName = bindMouseName,
						}
					end,
					function(info)
						if type(info) ~= "table" then return end
						if info.type == "Keyboard" and info.key then
							local ok, kc = pcall(function() return Enum.KeyCode[info.key] end)
							if ok and kc then self:SetKey(kc) end
						elseif info.type == "Mouse" and info.mouseName then
							self:SetMouseBind(info.mouseName)
						end
					end)
				applyTooltip(Frame, tooltip)
				return self
			end

			-- ── NewInput ──────────────────────────────────────────────────
			function Section:NewInput(text, placeholder, callback, tooltip)
				text = text or "Input"; placeholder = placeholder or "..."; callback = callback or function() end
				local Frame = Instance.new("Frame")
				Frame.Parent = Content; Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Frame.Size = UDim2.new(1, 0, 0, 34); mkCorner(4, Frame)
				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 8, 0, 0); Lbl.Size = UDim2.new(0.44, 0, 1, 0)
				Lbl.Font = Enum.Font.Gotham; Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left
				local Box = Instance.new("TextBox")
				Box.Parent = Frame
				Box.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
				Box.Position = UDim2.new(0.44, 4, 0.5, -11); Box.Size = UDim2.new(0.56, -12, 0, 22)
				Box.Font = Enum.Font.Gotham; Box.Text = ""
				Box.PlaceholderText = placeholder
				Box.TextColor3 = Color3.fromRGB(255, 255, 255)
				Box.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
				Box.TextSize = 11; Box.ClearTextOnFocus = false
				mkCorner(4, Box)
				mkStroke(Color3.fromRGB(102, 5, 172), 0, Box)
				local Stroke = Box:FindFirstChildOfClass("UIStroke")
				Box.Focused:Connect(function() if Stroke then Stroke.Thickness = 1 end end)
				Box.FocusLost:Connect(function(enter)
					if Stroke then Stroke.Thickness = 0 end
					callback(Box.Text, enter)
				end)
				local self = {Instance = Frame}
				function self:GetValue() return Box.Text end
				function self:SetValue(v) Box.Text = tostring(v or "") end
				RegisterFlag(tabName .. "/" .. name .. "/" .. text,
					function() return Box.Text end,
					function(v) Box.Text = tostring(v or ""); callback(Box.Text, false) end)
				applyTooltip(Frame, tooltip)
				return self
			end

			-- ── NewColorPicker ────────────────────────────────────────────
			function Section:NewColorPicker(text, default, callback, tooltip)
				text = text or "Color"; callback = callback or function() end
				default = default or Color3.fromRGB(255, 255, 255)
				local h, s, v = default:ToHSV()
				local Opened = false

				local Frame = Instance.new("Frame")
				Frame.Parent = Content; Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Frame.Size = UDim2.new(1, 0, 0, 34); Frame.ClipsDescendants = true; mkCorner(4, Frame)

				local Lbl = Instance.new("TextLabel")
				Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1
				Lbl.Position = UDim2.new(0, 8, 0, 0); Lbl.Size = UDim2.new(1, -50, 0, 34)
				Lbl.Font = Enum.Font.Gotham; Lbl.Text = text
				Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
				Lbl.TextXAlignment = Enum.TextXAlignment.Left

				-- Swatch (click to open)
				local Swatch = Instance.new("TextButton")
				Swatch.Parent = Frame; Swatch.Text = ""
				Swatch.Position = UDim2.new(1, -38, 0.5, -9); Swatch.Size = UDim2.new(0, 30, 0, 18)
				Swatch.BackgroundColor3 = default; mkCorner(4, Swatch)
				mkStroke(Color3.fromRGB(80, 80, 80), 1, Swatch)

				-- SV square
				local SV = Instance.new("ImageLabel")
				SV.Parent = Frame; SV.Position = UDim2.new(0, 8, 0, 40)
				SV.Size = UDim2.new(1, -16, 0, 90)
				SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				SV.Image = "rbxassetid://4155801252" -- white->transparent gradient (sat)
				SV.BorderSizePixel = 0; mkCorner(4, SV)
				local SVdark = Instance.new("ImageLabel")
				SVdark.Parent = SV; SVdark.BackgroundTransparency = 1
				SVdark.Size = UDim2.new(1, 0, 1, 0)
				SVdark.Image = "rbxassetid://3641079629" -- black gradient (value)
				mkCorner(4, SVdark)
				local SVcursor = Instance.new("Frame")
				SVcursor.Parent = SV; SVcursor.Size = UDim2.new(0, 6, 0, 6)
				SVcursor.AnchorPoint = Vector2.new(0.5, 0.5)
				SVcursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				mkStroke(Color3.fromRGB(0, 0, 0), 1, SVcursor)
				SVcursor.Position = UDim2.new(s, 0, 1 - v, 0)
				local cpc = Instance.new("UICorner"); cpc.CornerRadius = UDim.new(1, 0); cpc.Parent = SVcursor

				-- Hue slider
				local Hue = Instance.new("Frame")
				Hue.Parent = Frame; Hue.Position = UDim2.new(0, 8, 0, 136)
				Hue.Size = UDim2.new(1, -16, 0, 12); Hue.BorderSizePixel = 0; mkCorner(4, Hue)
				local HueGrad = Instance.new("UIGradient")
				HueGrad.Parent = Hue
				HueGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
				})
				local HueCursor = Instance.new("Frame")
				HueCursor.Parent = Hue; HueCursor.Size = UDim2.new(0, 3, 1, 2)
				HueCursor.AnchorPoint = Vector2.new(0.5, 0.5)
				HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
				HueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueCursor.BorderSizePixel = 0; mkStroke(Color3.fromRGB(0, 0, 0), 1, HueCursor)

				local function fireColor()
					local col = Color3.fromHSV(h, s, v)
					Swatch.BackgroundColor3 = col
					SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
					SVcursor.Position = UDim2.new(s, 0, 1 - v, 0)
					HueCursor.Position = UDim2.new(h, 0, 0.5, 0)
					callback(col)
				end

				-- SV drag
				local SVbtn = Instance.new("TextButton")
				SVbtn.Parent = SV; SVbtn.BackgroundTransparency = 1
				SVbtn.Size = UDim2.new(1, 0, 1, 0); SVbtn.Text = ""
				SVbtn.MouseButton1Down:Connect(function()
					local mm, mk
					local function stepSV()
						local px, py = GetXY(SV)
						s = px; v = 1 - py; fireColor()
					end
					stepSV()
					mm = Mouse.Move:Connect(stepSV)
					mk = UserInputService.InputEnded:Connect(function(inp)
						if inp.UserInputType == Enum.UserInputType.MouseButton1 then
							if mm then mm:Disconnect() end; if mk then mk:Disconnect() end
						end
					end)
				end)

				-- Hue drag
				local Huebtn = Instance.new("TextButton")
				Huebtn.Parent = Hue; Huebtn.BackgroundTransparency = 1
				Huebtn.Size = UDim2.new(1, 0, 1, 0); Huebtn.Text = ""
				Huebtn.MouseButton1Down:Connect(function()
					local mm, mk
					local function stepHue()
						local px = GetXY(Hue)
						h = math.clamp(px, 0, 0.999); fireColor()
					end
					stepHue()
					mm = Mouse.Move:Connect(stepHue)
					mk = UserInputService.InputEnded:Connect(function(inp)
						if inp.UserInputType == Enum.UserInputType.MouseButton1 then
							if mm then mm:Disconnect() end; if mk then mk:Disconnect() end
						end
					end)
				end)

				Swatch.MouseButton1Click:Connect(function()
					Opened = not Opened
					Frame:TweenSize(UDim2.new(1, 0, 0, Opened and 156 or 34), "Out", "Quad", 0.2, true)
				end)

				local self = {Instance = Frame}
				function self:SetColor(col)
					if typeof(col) ~= "Color3" then return end
					h, s, v = col:ToHSV(); fireColor()
				end
				function self:GetColor() return Color3.fromHSV(h, s, v) end
				RegisterFlag(tabName .. "/" .. name .. "/" .. text,
					function()
						local col = Color3.fromHSV(h, s, v)
						return {math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5)}
					end,
					function(val)
						if type(val) == "table" and #val >= 3 then
							self:SetColor(Color3.fromRGB(val[1], val[2], val[3]))
						end
					end)
				applyTooltip(Frame, tooltip)
				return self
			end

			-- ── NewBar ────────────────────────────────────────────────────
			function Section:NewBar()
				local f = Instance.new("Frame")
				f.Parent = Content; f.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
				f.BorderSizePixel = 0; f.Size = UDim2.new(1, 0, 0, 1)
				return {Instance = f}
			end

			-- ── NewDivider ────────────────────────────────────────────────
			-- thin separator line with vertical padding (gap above/below)
			function Section:NewDivider()
				local holder = Instance.new("Frame")
				holder.Parent = Content; holder.BackgroundTransparency = 1
				holder.Size = UDim2.new(1, 0, 0, 9)
				local line = Instance.new("Frame")
				line.Parent = holder; line.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				line.BorderSizePixel = 0
				line.AnchorPoint = Vector2.new(0.5, 0.5)
				line.Position = UDim2.new(0.5, 0, 0.5, 0)
				line.Size = UDim2.new(1, -8, 0, 1)
				return {Instance = holder}
			end

			Section.Content = Content
			Section.Container = SectionFrame
			return Section
		end


		Tab.Frame = TabFrame
		Tab.Left = LeftScroll
		Tab.Right = RightScroll
		Tab.Full = FullScroll
		Tab.Button = TabBtn
		return Tab
	end

	-- ════════════════ CONFIG SYSTEM ════════════════
	do
		local CFG_ROOT = "JaelHub"
		local CFG_DIR = CFG_ROOT .. "/" .. tostring(game.PlaceId)

		local function ensureFolders()
			pcall(function() if not isfolder(CFG_ROOT) then makefolder(CFG_ROOT) end end)
			pcall(function() if not isfolder(CFG_DIR) then makefolder(CFG_DIR) end end)
		end

		local function listConfigs()
			local out = {}
			pcall(function()
				if isfolder(CFG_DIR) then
					for _, f in ipairs(listfiles(CFG_DIR)) do
						if f:sub(-5) == ".json" then
							local nm = f:match("[\\/]([^\\/]+)%.json$")
							if nm then table.insert(out, nm) end
						end
					end
				end
			end)
			table.sort(out)
			return out
		end

		local function saveConfig(nm)
			if not nm or nm == "" then return false end
			ensureFolders()
			local data = {}
			for flag, h in pairs(ConfigRegistry) do
				local ok, val = pcall(h.get)
				if ok and val ~= nil then data[flag] = val end
			end
			local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
			if not ok then return false end
			return (pcall(function() writefile(CFG_DIR .. "/" .. nm .. ".json", json) end))
		end

		local function loadConfig(nm)
			if not nm or nm == "" then return false end
			local path = CFG_DIR .. "/" .. nm .. ".json"
			local exists = false
			pcall(function() exists = isfile(path) end)
			if not exists then return false end
			local ok, content = pcall(function() return readfile(path) end)
			if not ok then return false end
			local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
			if not ok2 or type(data) ~= "table" then return false end
			for flag, val in pairs(data) do
				local h = ConfigRegistry[flag]
				if h and h.set then pcall(h.set, val) end
			end
			return true
		end

		local function deleteConfig(nm)
			if not nm or nm == "" then return false end
			return (pcall(function() delfile(CFG_DIR .. "/" .. nm .. ".json") end))
		end

		-- Build Config tab (always last in sidebar via high LayoutOrder)
		local ConfigTab = GUI:NewTab("Configs")
		ConfigTab.Button.LayoutOrder = 9999

		local function mkCorner(r, p)
			local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = p
		end

		local function mkCard(parent, title)
			local Card = Instance.new("Frame")
			Card.Parent = parent
			Card.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
			Card.BorderSizePixel = 0
			Card.Size = UDim2.new(1, 0, 0, 0)
			Card.AutomaticSize = Enum.AutomaticSize.Y
			mkCorner(6, Card)
			local Header = Instance.new("Frame")
			Header.Parent = Card; Header.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
			Header.BorderSizePixel = 0; Header.Size = UDim2.new(1, 0, 0, 28)
			mkCorner(6, Header)
			local HFill = Instance.new("Frame")
			HFill.Parent = Header; HFill.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
			HFill.BorderSizePixel = 0; HFill.Position = UDim2.new(0, 0, 0.5, 0); HFill.Size = UDim2.new(1, 0, 0.5, 0)
			local HTitle = Instance.new("TextLabel")
			HTitle.Parent = Header; HTitle.BackgroundTransparency = 1
			HTitle.Position = UDim2.new(0, 10, 0, 0); HTitle.Size = UDim2.new(1, -10, 1, 0)
			HTitle.Font = Enum.Font.GothamBold; HTitle.Text = title
			HTitle.TextColor3 = Color3.fromRGB(255, 255, 255); HTitle.TextSize = 12
			HTitle.TextXAlignment = Enum.TextXAlignment.Left
			local Accent = Instance.new("Frame")
			Accent.Parent = Card; Accent.BackgroundColor3 = Color3.fromRGB(102, 5, 172)
			Accent.BorderSizePixel = 0; Accent.Position = UDim2.new(0, 0, 0, 28); Accent.Size = UDim2.new(1, 0, 0, 2)
			local Content = Instance.new("Frame")
			Content.Parent = Card; Content.BackgroundTransparency = 1
			Content.Position = UDim2.new(0, 0, 0, 30); Content.Size = UDim2.new(1, 0, 0, 0)
			Content.AutomaticSize = Enum.AutomaticSize.Y
			local CPad = Instance.new("UIPadding")
			CPad.Parent = Content
			CPad.PaddingLeft = UDim.new(0, 6); CPad.PaddingRight = UDim.new(0, 6)
			CPad.PaddingTop = UDim.new(0, 6); CPad.PaddingBottom = UDim.new(0, 8)
			local CList = Instance.new("UIListLayout")
			CList.Parent = Content; CList.Padding = UDim.new(0, 5); CList.SortOrder = Enum.SortOrder.LayoutOrder
			return Content
		end

		local Content = mkCard(ConfigTab.Right, "Configuration")

		-- Name input
		local NameBox = Instance.new("TextBox")
		NameBox.Parent = Content
		NameBox.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
		NameBox.Size = UDim2.new(1, 0, 0, 28)
		NameBox.Font = Enum.Font.Gotham; NameBox.Text = ""
		NameBox.PlaceholderText = "Config name..."
		NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		NameBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 110)
		NameBox.TextSize = 12; NameBox.ClearTextOnFocus = false
		NameBox.LayoutOrder = 1
		mkCorner(4, NameBox)
		local NBPad = Instance.new("UIPadding"); NBPad.Parent = NameBox; NBPad.PaddingLeft = UDim.new(0, 8)

		-- Status label
		local Status = Instance.new("TextLabel")
		Status.Parent = Content; Status.BackgroundTransparency = 1
		Status.Size = UDim2.new(1, 0, 0, 14); Status.LayoutOrder = 2
		Status.Font = Enum.Font.Gotham; Status.Text = ""
		Status.TextColor3 = Color3.fromRGB(180, 180, 180); Status.TextSize = 11
		Status.TextXAlignment = Enum.TextXAlignment.Left
		local function setStatus(txt, good)
			Status.Text = txt
			Status.TextColor3 = good and Color3.fromRGB(2, 255, 108) or Color3.fromRGB(255, 120, 120)
		end

		local refreshList -- fwd decl

		local function makeButton(txt, order, cb)
			local Frame = Instance.new("Frame")
			Frame.Parent = Content; Frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			Frame.Size = UDim2.new(1, 0, 0, 30); Frame.LayoutOrder = order
			mkCorner(4, Frame)
			local Lbl = Instance.new("TextLabel")
			Lbl.Parent = Frame; Lbl.BackgroundTransparency = 1; Lbl.Size = UDim2.new(1, 0, 1, 0)
			Lbl.Font = Enum.Font.Gotham; Lbl.Text = txt
			Lbl.TextColor3 = Color3.fromRGB(255, 255, 255); Lbl.TextSize = 12
			local Btn = Instance.new("TextButton")
			Btn.Parent = Frame; Btn.BackgroundTransparency = 1; Btn.Size = UDim2.new(1, 0, 1, 0); Btn.Text = ""
			local Stroke = Instance.new("UIStroke")
			Stroke.Parent = Frame; Stroke.Color = Color3.fromRGB(102, 5, 172); Stroke.Thickness = 0
			Btn.MouseEnter:Connect(function() Stroke.Thickness = 1 end)
			Btn.MouseLeave:Connect(function() Stroke.Thickness = 0 end)
			Btn.MouseButton1Click:Connect(function() Stroke.Thickness = 2; task.spawn(cb); task.wait(0.12); Stroke.Thickness = 0 end)
			return Frame
		end

		makeButton("Create", 3, function()
			local nm = NameBox.Text
			if nm == "" then setStatus("Enter a name first", false) return end
			if saveConfig(nm) then setStatus("Created '" .. nm .. "'", true); refreshList()
			else setStatus("Failed to create", false) end
		end)
		makeButton("Save", 4, function()
			local nm = NameBox.Text
			if nm == "" then setStatus("Enter a name first", false) return end
			if saveConfig(nm) then setStatus("Saved '" .. nm .. "'", true); refreshList()
			else setStatus("Failed to save", false) end
		end)
		makeButton("Load", 5, function()
			local nm = NameBox.Text
			if nm == "" then setStatus("Enter a name first", false) return end
			if loadConfig(nm) then setStatus("Loaded '" .. nm .. "'", true)
			else setStatus("Config not found", false) end
		end)
		makeButton("Delete", 6, function()
			local nm = NameBox.Text
			if nm == "" then setStatus("Enter a name first", false) return end
			if deleteConfig(nm) then setStatus("Deleted '" .. nm .. "'", true); NameBox.Text = ""; refreshList()
			else setStatus("Failed to delete", false) end
		end)

		-- ── UI Toggle Keybind ─────────────────────────────────────────
		local KeyContent = mkCard(ConfigTab.Right, "Settings")
		do
			local toggleKey = Enum.KeyCode.RightControl

			local Row = Instance.new("Frame")
			Row.Parent = KeyContent; Row.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			Row.Size = UDim2.new(1, 0, 0, 34); mkCorner(4, Row)
			local RLbl = Instance.new("TextLabel")
			RLbl.Parent = Row; RLbl.BackgroundTransparency = 1
			RLbl.Position = UDim2.new(0, 8, 0, 0); RLbl.Size = UDim2.new(0.5, 0, 1, 0)
			RLbl.Font = Enum.Font.Gotham; RLbl.Text = "Toggle UI Key"
			RLbl.TextColor3 = Color3.fromRGB(255, 255, 255); RLbl.TextSize = 12
			RLbl.TextXAlignment = Enum.TextXAlignment.Left
			local KBtn = Instance.new("TextButton")
			KBtn.Parent = Row; KBtn.BackgroundColor3 = Color3.fromRGB(51, 51, 51)
			KBtn.Position = UDim2.new(1, -78, 0.5, -11); KBtn.Size = UDim2.new(0, 72, 0, 22)
			KBtn.Font = Enum.Font.Gotham; KBtn.Text = toggleKey.Name
			KBtn.TextColor3 = Color3.fromRGB(255, 255, 255); KBtn.TextSize = 11
			mkCorner(4, KBtn)

			KBtn.MouseButton1Click:Connect(function()
				KBtn.Text = "..."
				local done, conn = false, nil
				local function finish(input)
					if done then return end; done = true; if conn then conn:Disconnect() end
					if input and input.UserInputType == Enum.UserInputType.Keyboard then
						toggleKey = input.KeyCode
					end
					KBtn.Text = toggleKey.Name
				end
				conn = UserInputService.InputBegan:Connect(finish)
				task.delay(2, function() finish(nil) end)
			end)

			UserInputService.InputBegan:Connect(function(input, gp)
				if gp then return end
				if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == toggleKey then
					ScreenGui.Enabled = not ScreenGui.Enabled
				end
			end)

			RegisterFlag("UI/ToggleKey",
				function() return toggleKey.Name end,
				function(v)
					if type(v) ~= "string" then return end
					local ok, kc = pcall(function() return Enum.KeyCode[v] end)
					if ok and kc then toggleKey = kc; KBtn.Text = kc.Name end
				end)

			-- Notif corner dropdown
			local corners = {"BottomRight", "BottomLeft", "TopRight", "TopLeft"}
			local cornerOpened = false
			local CDrop = Instance.new("Frame")
			CDrop.Parent = KeyContent; CDrop.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			CDrop.Size = UDim2.new(1, 0, 0, 34); CDrop.ClipsDescendants = true; mkCorner(4, CDrop)
			local CDLbl = Instance.new("TextLabel")
			CDLbl.Parent = CDrop; CDLbl.BackgroundTransparency = 1
			CDLbl.Position = UDim2.new(0, 8, 0, 0); CDLbl.Size = UDim2.new(0.55, 0, 0, 34)
			CDLbl.Font = Enum.Font.Gotham; CDLbl.Text = "Notif Corner"
			CDLbl.TextColor3 = Color3.fromRGB(255, 255, 255); CDLbl.TextSize = 12
			CDLbl.TextXAlignment = Enum.TextXAlignment.Left
			local CDSel = Instance.new("TextLabel")
			CDSel.Parent = CDrop; CDSel.BackgroundTransparency = 1
			CDSel.Position = UDim2.new(0.5, 0, 0, 0); CDSel.Size = UDim2.new(0.4, -28, 0, 34)
			CDSel.Font = Enum.Font.Gotham; CDSel.Text = notifCorner
			CDSel.TextColor3 = Color3.fromRGB(180, 180, 180); CDSel.TextSize = 11
			CDSel.TextXAlignment = Enum.TextXAlignment.Right
			local CDArrow = Instance.new("TextButton")
			CDArrow.Parent = CDrop; CDArrow.BackgroundTransparency = 1
			CDArrow.Position = UDim2.new(1, -28, 0, 0); CDArrow.Size = UDim2.new(0, 28, 0, 34)
			CDArrow.Font = Enum.Font.SourceSans; CDArrow.Text = ">"
			CDArrow.TextSize = 16; CDArrow.TextColor3 = Color3.fromRGB(255, 255, 255); CDArrow.Rotation = -90
			local CDItems = Instance.new("Frame")
			CDItems.Parent = CDrop; CDItems.BackgroundTransparency = 1
			CDItems.Position = UDim2.new(0, 4, 0, 39); CDItems.Size = UDim2.new(1, -8, 0, 0)
			CDItems.AutomaticSize = Enum.AutomaticSize.Y; CDItems.Visible = false
			local CDIL = Instance.new("UIListLayout"); CDIL.Parent = CDItems
			CDIL.Padding = UDim.new(0, 3); CDIL.SortOrder = Enum.SortOrder.LayoutOrder
			local function toggleCornerDrop()
				cornerOpened = not cornerOpened
				local totalH = cornerOpened and (34 + 5 + #corners * 28 + math.max(0, #corners-1) * 3 + 6) or 34
				CDrop:TweenSize(UDim2.new(1, 0, 0, totalH), "Out", "Quad", 0.2, true)
				TweenService:Create(CDArrow, TweenInfo.new(0.2), {Rotation = cornerOpened and 90 or -90}):Play()
				CDItems.Visible = cornerOpened
			end
			CDArrow.MouseButton1Click:Connect(toggleCornerDrop)
			for _, corner in ipairs(corners) do
				local IF = Instance.new("Frame")
				IF.Parent = CDItems; IF.BackgroundColor3 = Color3.fromRGB(41, 41, 41)
				IF.Size = UDim2.new(1, 0, 0, 28); mkCorner(4, IF)
				local IS = Instance.new("UIStroke"); IS.Color = Color3.fromRGB(102, 5, 172); IS.Thickness = 1; IS.Parent = IF
				local IB = Instance.new("TextButton")
				IB.Parent = IF; IB.BackgroundTransparency = 1; IB.Size = UDim2.new(1, 0, 1, 0)
				IB.Font = Enum.Font.Gotham; IB.Text = corner
				IB.TextColor3 = Color3.fromRGB(255, 255, 255); IB.TextSize = 12
				IB.MouseButton1Click:Connect(function()
					notifCorner = corner; CDSel.Text = corner
					updateNotifLayout(); toggleCornerDrop()
				end)
			end
			RegisterFlag("UI/NotifCorner",
				function() return notifCorner end,
				function(v)
					for _, c in ipairs(corners) do
						if c == v then notifCorner = v; CDSel.Text = v; updateNotifLayout(); break end
					end
				end)

			-- Anti-AFK
			local VirtualUser = game:GetService("VirtualUser")
			local afkConn
			local AntiAfkRow = Instance.new("Frame")
			AntiAfkRow.Parent = KeyContent; AntiAfkRow.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
			AntiAfkRow.Size = UDim2.new(1, 0, 0, 34); mkCorner(4, AntiAfkRow)
			local AALbl = Instance.new("TextLabel")
			AALbl.Parent = AntiAfkRow; AALbl.BackgroundTransparency = 1
			AALbl.Position = UDim2.new(0, 8, 0, 0); AALbl.Size = UDim2.new(1, -58, 1, 0)
			AALbl.Font = Enum.Font.Gotham; AALbl.Text = "Anti-AFK"
			AALbl.TextColor3 = Color3.fromRGB(255, 255, 255); AALbl.TextSize = 12
			AALbl.TextXAlignment = Enum.TextXAlignment.Left
			local AABtn = Instance.new("TextButton")
			AABtn.Parent = AntiAfkRow; AABtn.BackgroundTransparency = 1
			AABtn.Position = UDim2.new(1, -50, 0.5, -11)
			AABtn.Size = UDim2.new(0, 44, 0, 22); AABtn.Text = ""
			local AABg = Instance.new("Frame")
			AABg.Parent = AABtn; AABg.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
			AABg.Size = UDim2.new(1, 0, 1, 0); mkCorner(4, AABg)
			local AAInd = Instance.new("Frame")
			AAInd.Parent = AABg; AAInd.BackgroundColor3 = Color3.fromRGB(255, 81, 81)
			AAInd.Position = UDim2.new(0, 4, 0.1, 0); AAInd.Size = UDim2.new(0, 16, 0.8, 0)
			mkCorner(3, AAInd)
			local aaState = false
			local function setAntiAfk(enabled)
				aaState = enabled
				if enabled then
					TweenService:Create(AAInd, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0.1, 0), BackgroundColor3 = Color3.fromRGB(2, 255, 108)}):Play()
					if afkConn then afkConn:Disconnect() end
					afkConn = Players.LocalPlayer.Idled:Connect(function()
						VirtualUser:CaptureController()
						VirtualUser:ClickButton2(Vector2.new())
						GUI:Notify("Anti-AFK", "Prevented AFK kick", 3)
					end)
				else
					TweenService:Create(AAInd, TweenInfo.new(0.2), {Position = UDim2.new(0, 4, 0.1, 0), BackgroundColor3 = Color3.fromRGB(255, 81, 81)}):Play()
					if afkConn then afkConn:Disconnect(); afkConn = nil end
				end
			end
			AABtn.MouseButton1Click:Connect(function() setAntiAfk(not aaState) end)
			RegisterFlag("UI/AntiAfk",
				function() return aaState end,
				function(v) setAntiAfk(v and true or false) end)
		end

		-- Saved configs list card
		local ListContent = mkCard(ConfigTab.Left, "Saved Configs")
		-- list lives in LEFT column; Configuration + Settings in RIGHT

		refreshList = function()
			for _, ch in ipairs(ListContent:GetChildren()) do
				if ch:IsA("Frame") or ch:IsA("TextLabel") then ch:Destroy() end
			end
			local cfgs = listConfigs()
			if #cfgs == 0 then
				local Empty = Instance.new("TextLabel")
				Empty.Parent = ListContent; Empty.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Empty.Size = UDim2.new(1, 0, 0, 26)
				Empty.Font = Enum.Font.Gotham; Empty.Text = "No saved configs"
				Empty.TextColor3 = Color3.fromRGB(150, 150, 150); Empty.TextSize = 11
				mkCorner(4, Empty)
				return
			end
			for _, nm in ipairs(cfgs) do
				local Item = Instance.new("Frame")
				Item.Parent = ListContent; Item.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
				Item.Size = UDim2.new(1, 0, 0, 28)
				mkCorner(4, Item)
				local ILbl = Instance.new("TextLabel")
				ILbl.Parent = Item; ILbl.BackgroundTransparency = 1
				ILbl.Position = UDim2.new(0, 8, 0, 0); ILbl.Size = UDim2.new(1, -16, 1, 0)
				ILbl.Font = Enum.Font.Gotham; ILbl.Text = nm
				ILbl.TextColor3 = Color3.fromRGB(255, 255, 255); ILbl.TextSize = 12
				ILbl.TextXAlignment = Enum.TextXAlignment.Left
				local IBtn = Instance.new("TextButton")
				IBtn.Parent = Item; IBtn.BackgroundTransparency = 1; IBtn.Size = UDim2.new(1, 0, 1, 0); IBtn.Text = ""
				local IStroke = Instance.new("UIStroke")
				IStroke.Parent = Item; IStroke.Color = Color3.fromRGB(102, 5, 172); IStroke.Thickness = 0
				IBtn.MouseEnter:Connect(function() IStroke.Thickness = 1 end)
				IBtn.MouseLeave:Connect(function() IStroke.Thickness = 0 end)
				IBtn.MouseButton1Click:Connect(function()
					NameBox.Text = nm -- click config => selected in input for save/load/delete
					setStatus("Selected '" .. nm .. "'", true)
				end)
			end
		end

		ensureFolders()
		refreshList()
	end

	return GUI
end

return Library
