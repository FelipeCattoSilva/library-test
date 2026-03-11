local Library = {}

-- Services
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Função GetXY corrigida
local function GetXY(GuiObject)
    local mousePos = UserInputService:GetMouseLocation()
    local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
    local Px, Py = math.clamp(mousePos.X - GuiObject.AbsolutePosition.X, 0, Max), 
                   math.clamp(mousePos.Y - GuiObject.AbsolutePosition.Y, 0, May)
    return Px/Max, Py/May
end


function Library:ToggleUI()
	if game.CoreGui["Jael Library"].Enabled then
		game.CoreGui["Jael Library"].Enabled = false
	else
		game.CoreGui["Jael Library"].Enabled = true
	end
end

function Library:NewWindow(hubName, gameName, version, discord)

	if CoreGui:FindFirstChild("Jael Library") then
		CoreGui:FindFirstChild("Jael Library"):Destroy()
	end

	hubName = hubName or "Jael Library"
	gameName = gameName or "Baseplate"
	version = version or "v1.0"
	discord = discord or "discord/00000"

	local GUI = {}

	-- Render
	do
		-- StarterGui.JaelLibrary
		GUI["1"] = Instance.new("ScreenGui", CoreGui);
		GUI["1"]["Name"] = "Jael Library";
		GUI["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;
		GUI["1"]["ResetOnSpawn"] = false

		-- StarterGui.JaelLibrary.MainFrame
		GUI["2"] = Instance.new("Frame", GUI["1"]);
		GUI["2"]["BackgroundColor3"] = Color3.fromRGB(26, 26, 26);
		GUI["2"]["Size"] = UDim2.new(0, 683, 0, 464);
		GUI["2"]["Position"] = UDim2.new(0.23853209614753723, 0, 0.21358025074005127, 0);
		GUI["2"]["Name"] = [[MainFrame]];
		GUI["2"]["Active"] = true;
		GUI["2"]["Draggable"] = true;

		-- StarterGui.JaelLibrary.MainFrame.Tabs
		GUI["18"] = Instance.new("Frame", GUI["2"]);
		GUI["18"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["18"]["BackgroundTransparency"] = 1;
		GUI["18"]["Size"] = UDim2.new(0, 490, 0, 419);
		GUI["18"]["Position"] = UDim2.new(0.28257685899734497, 0, 0.09698276221752167, 0);
		GUI["18"]["Name"] = [[Tabs]];

		-- StarterGui.JaelLibrary.MainFrame.MainFrameUICorner
		GUI["3"] = Instance.new("UICorner", GUI["2"]);
		GUI["3"]["Name"] = [[MainFrameUICorner]];
		GUI["3"]["CornerRadius"] = UDim.new(0, 5);

		-- StarterGui.JaelLibrary.MainFrame.SideBar
		GUI["4"] = Instance.new("Frame", GUI["2"]);
		GUI["4"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
		GUI["4"]["Size"] = UDim2.new(0, 189, 0, 464);
		GUI["4"]["Name"] = [[SideBar]];

		-- StarterGui.JaelLibrary.MainFrame.SideBar.SideBarUICorner
		GUI["5"] = Instance.new("UICorner", GUI["4"]);
		GUI["5"]["Name"] = [[SideBarUICorner]];
		GUI["5"]["CornerRadius"] = UDim.new(0, 5);

		-- StarterGui.JaelLibrary.MainFrame.SideBar.NameFrame
		GUI["6"] = Instance.new("Frame", GUI["4"]);
		GUI["6"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["6"]["BackgroundTransparency"] = 1;
		GUI["6"]["Size"] = UDim2.new(0, 189, 0, 100);
		GUI["6"]["Name"] = [[NameFrame]];

		-- StarterGui.JaelLibrary.MainFrame.SideBar.NameFrame.GameNameLabel
		GUI["7"] = Instance.new("TextLabel", GUI["6"]);
		GUI["7"]["TextWrapped"] = true;
		GUI["7"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["7"]["TextYAlignment"] = Enum.TextYAlignment.Top;
		GUI["7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["7"]["TextSize"] = 20;
		GUI["7"]["TextColor3"] = Color3.fromRGB(102, 5, 172);
		GUI["7"]["Size"] = UDim2.new(0, 173, 0, 41);
		GUI["7"]["Text"] = gameName;
		GUI["7"]["Name"] = [[GameNameLabel]];
		GUI["7"]["Font"] = Enum.Font.Gotham;
		GUI["7"]["BackgroundTransparency"] = 1;
		GUI["7"]["Position"] = UDim2.new(0.038922831416130066, 0, 0.4142857491970062, 0);

		-- StarterGui.JaelLibrary.MainFrame.SideBar.NameFrame.HubNameLabel
		GUI["8"] = Instance.new("TextLabel", GUI["6"]);
		GUI["8"]["TextWrapped"] = true;
		GUI["8"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["8"]["TextScaled"] = true;
		GUI["8"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["8"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["8"]["TextSize"] = 27;
		GUI["8"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["8"]["Size"] = UDim2.new(0, 174, 0, 35);
		GUI["8"]["Text"] = hubName;
		GUI["8"]["Name"] = [[HubNameLabel]];
		GUI["8"]["Font"] = Enum.Font.Gotham;
		GUI["8"]["BackgroundTransparency"] = 1;
		GUI["8"]["Position"] = UDim2.new(0.038922831416130066, 0, 0.0657142624258995, 0);

		-- StarterGui.JaelLibrary.MainFrame.SideBar.ButtonsHolder
		GUI["9"] = Instance.new("Frame", GUI["4"]);
		GUI["9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["9"]["BackgroundTransparency"] = 1;
		GUI["9"]["Size"] = UDim2.new(0, 135, 0, 310);
		GUI["9"]["Position"] = UDim2.new(0.1404874324798584, 0, 0.2877081632614136, 0);
		GUI["9"]["Name"] = [[ButtonsHolder]];

		-- StarterGui.JaelLibrary.MainFrame.SideBar.ButtonsHolder.UIListLayout
		GUI["a"] = Instance.new("UIListLayout", GUI["9"]);
		GUI["a"]["Padding"] = UDim.new(0.014000000432133675, 0);
		GUI["a"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

		-- StarterGui.JaelLibrary.MainFrame.TopBar
		GUI["14"] = Instance.new("Frame", GUI["2"]);
		GUI["14"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
		GUI["14"]["Size"] = UDim2.new(0, 490, 0, 41);
		GUI["14"]["Position"] = UDim2.new(0.28257685899734497, 0, 0, 0);
		GUI["14"]["Name"] = [[TopBar]];

		-- StarterGui.JaelLibrary.MainFrame.TopBar.TopBarUICorner
		GUI["15"] = Instance.new("UICorner", GUI["14"]);
		GUI["15"]["Name"] = [[TopBarUICorner]];
		GUI["15"]["CornerRadius"] = UDim.new(0, 5);

		-- StarterGui.JaelLibrary.MainFrame.TopBar.DiscordLabel
		GUI["16"] = Instance.new("TextLabel", GUI["14"]);
		GUI["16"]["TextWrapped"] = true;
		GUI["16"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["16"]["TextScaled"] = true;
		GUI["16"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["16"]["TextStrokeColor3"] = Color3.fromRGB(120, 138, 255);
		GUI["16"]["TextSize"] = 27;
		GUI["16"]["TextColor3"] = Color3.fromRGB(120, 138, 255);
		GUI["16"]["Size"] = UDim2.new(0, 100, 0, 35);
		GUI["16"]["Text"] = discord;
		GUI["16"]["Name"] = [[DiscordLabel]];
		GUI["16"]["Font"] = Enum.Font.Gotham;
		GUI["16"]["BackgroundTransparency"] = 1;
		GUI["16"]["Position"] = UDim2.new(0.779591978, 0, 0.0657143965, 0);

		-- StarterGui.JaelLibrary.MainFrame.TopBar.VersionLabel
		GUI["17"] = Instance.new("TextLabel", GUI["14"]);
		GUI["17"]["TextWrapped"] = true;
		GUI["17"]["TextXAlignment"] = Enum.TextXAlignment.Right;
		GUI["17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["17"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["17"]["TextSize"] = 10;
		GUI["17"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["17"]["Size"] = UDim2.new(0, 38, 0, 35);
		GUI["17"]["Text"] = version;
		GUI["17"]["Name"] = [[VersionLabel]];
		GUI["17"]["Font"] = Enum.Font.Gotham;
		GUI["17"]["BackgroundTransparency"] = 1;
		GUI["17"]["Position"] = UDim2.new(0.685714424, 0, 0.0657143965, 0);



		------------------------------------

		-- StarterGui.JaelLibrary.MainFrame.SideBar.HomeButton
		GUI["11"] = Instance.new("TextButton", GUI["4"]);
		GUI["11"]["TextSize"] = 17;
		GUI["11"]["BackgroundColor3"] = Color3.fromRGB(102, 5, 172);
		GUI["11"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["11"]["Size"] = UDim2.new(0.7142857313156128, 0, 0, 35);
		GUI["11"]["Name"] = [[HomeButton]];
		GUI["11"]["Text"] = [[]];
		GUI["11"]["Font"] = Enum.Font.SourceSans;
		GUI["11"]["Position"] = UDim2.new(0.13519643247127533, 0, 0.2, 2);
		GUI["11"].MouseButton1Click:Connect(function()
			for i, v in pairs(GUI["18"]:GetChildren()) do
				v.Visible = false
				GUI["19"]["Visible"] = true
			end

			for i, v in pairs(GUI["9"]:GetChildren()) do
				if v:IsA("TextButton") then
					v.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
					v.TextLabel.TextColor3 = Color3.fromRGB(116, 116, 116)
				end
			end
			
			GUI["11"].BackgroundColor3 = Color3.fromRGB(101, 4, 171)
			GUI["11"].homeTextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		end)

		-- StarterGui.JaelLibrary.MainFrame.SideBar.HomeButton.homeUICorner
		GUI["12"] = Instance.new("UICorner", GUI["11"]);
		GUI["12"]["Name"] = [[homeUICorner]];
		GUI["12"]["CornerRadius"] = UDim.new(0, 4);

		-- StarterGui.JaelLibrary.MainFrame.SideBar.HomeButton.homeTextLabel
		GUI["13"] = Instance.new("TextLabel", GUI["11"]);
		GUI["13"]["TextWrapped"] = true;
		GUI["13"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["13"]["TextScaled"] = true;
		GUI["13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["13"]["TextSize"] = 15;
		GUI["13"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["13"]["Size"] = UDim2.new(0, 122, 0, 13);
		GUI["13"]["Text"] = [[Home]];
		GUI["13"]["Name"] = [[homeTextLabel]];
		GUI["13"]["Font"] = Enum.Font.Gotham;
		GUI["13"]["BackgroundTransparency"] = 1;
		GUI["13"]["Position"] = UDim2.new(0.0962962955236435, 0, 0.3142857253551483, 0);

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame
		GUI["19"] = Instance.new("Frame", GUI["18"]);
		GUI["19"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
		GUI["19"]["Size"] = UDim2.new(0, 490, 0, 419);
		GUI["19"]["Visible"] = true;
		GUI["19"]["Name"] = [[HomeFrame]];

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.HomeFrameUICorner
		GUI["1a"] = Instance.new("UICorner", GUI["19"]);
		GUI["1a"]["Name"] = [[HomeFrameUICorner]];
		GUI["1a"]["CornerRadius"] = UDim.new(0, 5);

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.WelcomeLabel
		GUI["1b"] = Instance.new("TextLabel", GUI["19"]);
		GUI["1b"]["TextWrapped"] = true;
		GUI["1b"]["TextXAlignment"] = Enum.TextXAlignment.Left;
		GUI["1b"]["TextScaled"] = true;
		GUI["1b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["1b"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["1b"]["TextSize"] = 27;
		GUI["1b"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["1b"]["Size"] = UDim2.new(0, 477, 0, 42);
		GUI["1b"]["Text"] = "Welcome, "..LocalPlayer.DisplayName.."!";
		GUI["1b"]["Name"] = [[WelcomeLabel]];
		GUI["1b"]["Font"] = Enum.Font.Gotham;
		GUI["1b"]["BackgroundTransparency"] = 1;
		GUI["1b"]["Position"] = UDim2.new(0.012392254546284676, 0, 0.008435014635324478, 0);

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.Bar
		GUI["1c"] = Instance.new("Frame", GUI["19"]);
		GUI["1c"]["BorderSizePixel"] = 0;
		GUI["1c"]["BackgroundColor3"] = Color3.fromRGB(102, 5, 172);
		GUI["1c"]["Size"] = UDim2.new(0, 477, 0, 1);
		GUI["1c"]["Position"] = UDim2.new(0.01224489789456129, 0, 0.10739856958389282, 0);
		GUI["1c"]["Name"] = [[Bar]];

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.FeaturesFrame
		GUI["1d"] = Instance.new("Frame", GUI["19"]);
		GUI["1d"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
		GUI["1d"]["Size"] = UDim2.new(0, 477, 0, 353);
		GUI["1d"]["Position"] = UDim2.new(0.01224489789456129, 0, 0.13722334802150726, 0);
		GUI["1d"]["Name"] = [[FeaturesFrame]];

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.FeaturesFrame.FeaturesFrameUICorner
		GUI["1e"] = Instance.new("UICorner", GUI["1d"]);
		GUI["1e"]["Name"] = [[FeaturesFrameUICorner]];
		GUI["1e"]["CornerRadius"] = UDim.new(0, 5);

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.FeaturesFrame.FeaturesScrolling
		GUI["1f"] = Instance.new("ScrollingFrame", GUI["1d"]);
		GUI["1f"]["Active"] = true;
		GUI["1f"]["BorderSizePixel"] = 0;
		GUI["1f"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
		GUI["1f"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
		GUI["1f"]["ScrollBarThickness"] = 0;
		GUI["1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
		GUI["1f"]["BackgroundTransparency"] = 1;
		GUI["1f"]["Size"] = UDim2.new(1, 0, 1, 0);
		GUI["1f"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
		GUI["1f"]["ScrollBarThickness"] = 0;
		GUI["1f"]["Name"] = [[FeaturesScrolling]];

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.FeaturesFrame.FeaturesScrooling.UIListLayout
		GUI["20"] = Instance.new("UIListLayout", GUI["1f"]);
		GUI["20"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

		-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.FeaturesFrame.FeaturesScrooling.UIPadding
		GUI["22"] = Instance.new("UIPadding", GUI["1f"]);
		GUI["22"]["PaddingRight"] = UDim.new(0, 5);
		GUI["22"]["PaddingBottom"] = UDim.new(0, 5);
		GUI["22"]["PaddingLeft"] = UDim.new(0, 5);


		-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.HomeFrameUICorner
		GUI["25"] = Instance.new("UICorner", GUI["24"]);
		GUI["25"]["Name"] = [[HomeFrameUICorner]];
		GUI["25"]["CornerRadius"] = UDim.new(0, 5);
	end

	function GUI:FeatureNewGame(gameName)

		gameName = gameName or "- New Game"

		local NewGame = {}

		do
			-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.FeaturesFrame.FeaturesScrooling.FeatureGameName
			NewGame["21"] = Instance.new("TextLabel", GUI["1f"]);
			NewGame["21"]["TextWrapped"] = true;
			NewGame["21"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			NewGame["21"]["TextScaled"] = true;
			NewGame["21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			NewGame["21"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
			NewGame["21"]["TextSize"] = 27;
			NewGame["21"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			NewGame["21"]["Size"] = UDim2.new(0, 471, 0, 42);
			NewGame["21"]["Text"] = gameName;
			NewGame["21"]["Name"] = [[FeatureGameName]];
			NewGame["21"]["Font"] = Enum.Font.Gotham;
			NewGame["21"]["BackgroundTransparency"] = 1;
		end

		return NewGame
	end

	function GUI:FeatureNewFeature(featureLabel)
		featureLabel = featureLabel or "- New Feature"

		local feature = {}

		do
			-- StarterGui.JaelLibrary.MainFrame.Tabs.HomeFrame.FeaturesFrame.FeaturesScrooling.NewFeature
			feature["23"] = Instance.new("TextLabel", GUI["1f"]);
			feature["23"]["TextWrapped"] = true;
			feature["23"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			feature["23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			feature["23"]["TextStrokeColor3"] = Color3.fromRGB(255, 255, 255);
			feature["23"]["TextSize"] = 20;
			feature["23"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
			feature["23"]["Size"] = UDim2.new(0, 471, 0, 24);
			feature["23"]["Text"] = featureLabel;
			feature["23"]["Name"] = [[NewFeature]];
			feature["23"]["Font"] = Enum.Font.Gotham;
			feature["23"]["BackgroundTransparency"] = 1;
			feature["23"]["Position"] = UDim2.new(0, 0, 0.12068965286016464, 0);
		end

		return feature
	end

	function GUI:NewTab(tabName)

		tabName = tabName or "New Tab"

		local Tab = {}

		-- Render
		do
			-- StarterGui.JaelLibrary.MainFrame.SideBar.ButtonsHolder.Button
			Tab["e"] = Instance.new("TextButton", GUI["9"]);
			Tab["e"]["TextSize"] = 17;
			Tab["e"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			Tab["e"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["e"]["Size"] = UDim2.new(1, 0, 0, 35);
			Tab["e"]["Name"] = [[Button]];
			Tab["e"]["Text"] = [[]];
			Tab["e"]["Font"] = Enum.Font.SourceSans;

			-- StarterGui.JaelLibrary.MainFrame.SideBar.ButtonsHolder.Diactvated.mainUICorner
			Tab["f"] = Instance.new("UICorner", Tab["e"]);
			Tab["f"]["Name"] = [[mainUICorner]];
			Tab["f"]["CornerRadius"] = UDim.new(0, 4);

			-- StarterGui.JaelLibrary.MainFrame.SideBar.ButtonsHolder.Diactvated.TextLabel
			Tab["10"] = Instance.new("TextLabel", Tab["e"]);
			Tab["10"]["TextWrapped"] = true;
			Tab["10"]["TextXAlignment"] = Enum.TextXAlignment.Left;
			Tab["10"]["TextScaled"] = true;
			Tab["10"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["10"]["TextSize"] = 15;
			Tab["10"]["TextColor3"] = Color3.fromRGB(117, 117, 117);
			Tab["10"]["Size"] = UDim2.new(0, 122, 0, 13);
			Tab["10"]["Text"] = tabName;
			Tab["10"]["Font"] = Enum.Font.Gotham;
			Tab["10"]["BackgroundTransparency"] = 1;
			Tab["10"]["Position"] = UDim2.new(0.0962962955236435, 0, 0.3142857253551483, 0);

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab
			Tab["24"] = Instance.new("Frame", GUI["18"]);
			Tab["24"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
			Tab["24"]["Size"] = UDim2.new(0, 490, 0, 419);
			Tab["24"]["ClipsDescendants"] = true;
			Tab["24"]["Visible"] = false
			Tab["24"]["Name"] = [[Newtab]];

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling
			Tab["26"] = Instance.new("ScrollingFrame", Tab["24"]);
			Tab["26"]["Active"] = true;
			Tab["26"]["BorderSizePixel"] = 0;
			Tab["26"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
			Tab["26"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
			Tab["26"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
			Tab["26"]["BackgroundTransparency"] = 1;
			Tab["26"]["Size"] = UDim2.new(1, 0, 1, 0);
			Tab["26"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
			Tab["26"]["ScrollBarThickness"] = 0;
			Tab["26"]["Name"] = [[TabScrolling]];

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.TabScrollingUIPadding
			Tab["27"] = Instance.new("UIPadding", Tab["26"]);
			Tab["27"]["PaddingTop"] = UDim.new(0, 5);
			Tab["27"]["Name"] = [[TabScrollingUIPadding]];
			Tab["27"]["PaddingRight"] = UDim.new(0, 5);
			Tab["27"]["PaddingBottom"] = UDim.new(0, 5);
			Tab["27"]["PaddingLeft"] = UDim.new(0, 5);

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.TabScrollingUIListLayout
			Tab["28"] = Instance.new("UIListLayout", Tab["26"]);
			Tab["28"]["Name"] = [[TabScrollingUIListLayout]];
			Tab["28"]["Padding"] = UDim.new(0, 5);
			Tab["28"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Button.MainButton.MainButtonUICorner
			Tab["19bbb"] = Instance.new("UICorner", Tab["24"]);
			Tab["19bbb"]["Name"] = [[MainButtonUICorner]];
			Tab["19bbb"]["CornerRadius"] = UDim.new(0, 5);

			Tab["e"].MouseButton1Click:Connect(function()
				for i, v in pairs(GUI["18"]:GetChildren()) do
					v.Visible = false
					Tab["24"].Visible = true
				end

				for i, v in pairs(GUI["9"]:GetChildren()) do
					if v:IsA("TextButton") then
						v.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
						v.TextLabel.TextColor3 = Color3.fromRGB(116, 116, 116)
					end
				end
				
				GUI["11"].BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				GUI["11"].homeTextLabel.TextColor3 = Color3.fromRGB(116, 116, 116)
				
				Tab["e"].BackgroundColor3 = Color3.fromRGB(101, 4, 171)
				Tab["e"].TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			end)
		end

		function Tab:NewLabel(label)

			label = label or "New Label"

			local Label = {}

			-- Render
			do
				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Label
				Label["29"] = Instance.new("TextLabel", Tab["26"]);
				Label["29"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Label["29"]["TextSize"] = 14;
				Label["29"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Label["29"]["Size"] = UDim2.new(0, 478, 0, 35);
				Label["29"]["Name"] = [[Label]];
				Label["29"]["Font"] = Enum.Font.Gotham;
				Label["29"]["Text"] = label


				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Label.LabelUICorner
				Label["2a"] = Instance.new("UICorner", Label["29"]);
				Label["2a"]["Name"] = [[LabelUICorner]];
				Label["2a"]["CornerRadius"] = UDim.new(0, 5);
			end

			return Label
		end

		function Tab:NewButton(label, callback)

			label = label or "New Button"
			callback = callback or function(v) print(v) end

			local Button = {}

			-- Render
			do
				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Button
				Button["2b"] = Instance.new("Frame", Tab["26"]);
				Button["2b"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Button["2b"]["Size"] = UDim2.new(0, 478, 0, 50);
				Button["2b"]["Name"] = [[Button]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Button.ButtonUICorner
				Button["2c"] = Instance.new("UICorner", Button["2b"]);
				Button["2c"]["Name"] = [[ButtonUICorner]];
				Button["2c"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Button.ButtonLabel
				Button["2d"] = Instance.new("TextLabel", Button["2b"]);
				Button["2d"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Button["2d"]["TextSize"] = 14;
				Button["2d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Button["2d"]["Size"] = UDim2.new(1, 0, 1, 0);
				Button["2d"]["Text"] = label;
				Button["2d"]["Name"] = [[ButtonLabel]];
				Button["2d"]["Font"] = Enum.Font.Gotham;
				Button["2d"]["BackgroundTransparency"] = 1;

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Button.MainButton
				Button["2e"] = Instance.new("TextButton", Button["2b"]);
				Button["2e"]["TextSize"] = 14;
				Button["2e"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Button["2e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Button["2e"]["Size"] = UDim2.new(1, 0, 1, 0);
				Button["2e"]["Name"] = [[MainButton]];
				Button["2e"]["Text"] = [[]];
				Button["2e"]["Font"] = Enum.Font.Gotham;
				Button["2e"]["BackgroundTransparency"] = 1;

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Button.MainButton.MainButtonUICorner
				Button["2f"] = Instance.new("UICorner", Button["2e"]);
				Button["2f"]["Name"] = [[MainButtonUICorner]];
				Button["2f"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Button.ButtonUIStroke
				Button["30"] = Instance.new("UIStroke", Button["2b"]);
				Button["30"]["Color"] = Color3.fromRGB(102, 5, 172);
				Button["30"]["Thickness"] = 0;
				Button["30"]["Name"] = [[ButtonUIStroke]];

				local inOut = false

				Button["2e"].MouseEnter:Connect(function()
					Button["30"].Thickness = 1
					inOut = true
				end)

				Button["2e"].MouseLeave:Connect(function()
					Button["30"].Thickness = 0
					inOut = false
				end)

				Button["2e"].MouseButton1Click:Connect(function()
					Button["30"].Thickness = 3
					callback()
					
					wait(.15)
					Button["30"].Thickness = 0
				end)

			end

			return Button
		end

		function Tab:NewSlider(label, min, max, default, callback)

			label = label or "New Slider"
			min = min or 0
			max = max or 100
			default = default or 16
			callback = callback or function(v) print(v) end

			if min > min then
				local ValueBefore = min
				min, max = max, ValueBefore
			end

			local SliderDef = math.clamp(default, min, max) or math.clamp(50, min, max)
			local DefaultScale =  (SliderDef - min) / (max - min)

			local Slider = {}

			-- Render
			do
				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider
				Slider["31"] = Instance.new("Frame", Tab["26"]);
				Slider["31"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Slider["31"]["Size"] = UDim2.new(0, 478, 0, 55);
				Slider["31"]["Position"] = UDim2.new(0, 0, 0.26894864439964294, 0);
				Slider["31"]["Name"] = [[Slider]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.ButtonUICorner
				Slider["32"] = Instance.new("UICorner", Slider["31"]);
				Slider["32"]["Name"] = [[ButtonUICorner]];
				Slider["32"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.ButtonLabel
				Slider["33"] = Instance.new("TextLabel", Slider["31"]);
				Slider["33"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Slider["33"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Slider["33"]["TextSize"] = 14;
				Slider["33"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["33"]["Size"] = UDim2.new(0.8451882600784302, 0, 0.49115437269210815, 0);
				Slider["33"]["Text"] = label;
				Slider["33"]["Name"] = [[ButtonLabel]];
				Slider["33"]["Font"] = Enum.Font.Gotham;
				Slider["33"]["BackgroundTransparency"] = 1;
				Slider["33"]["Position"] = UDim2.new(0.02301255241036415, 0, 0, 0);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.ButtonLabel
				Slider["34"] = Instance.new("TextLabel", Slider["31"]);
				Slider["34"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Slider["34"]["TextSize"] = 14;
				Slider["34"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Slider["34"]["Size"] = UDim2.new(0.11924700438976288, 0, 0.49115437269210815, 0);
				Slider["34"]["Text"] = tostring(SliderDef);
				Slider["34"]["Name"] = [[ButtonLabel]];
				Slider["34"]["Font"] = Enum.Font.Gotham;
				Slider["34"]["BackgroundTransparency"] = 1;
				Slider["34"]["Position"] = UDim2.new(0.8682008385658264, 0, 0, 0);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.Background
				Slider["35"] = Instance.new("Frame", Slider["31"]);
				Slider["35"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
				Slider["35"]["Size"] = UDim2.new(0, 454, 0, 19);
				Slider["35"]["Position"] = UDim2.new(0.02301255241036415, 0, 0.5175759196281433, 0);
				Slider["35"]["Name"] = [[Background]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.Background.BackgroundUICorner
				Slider["36"] = Instance.new("UICorner", Slider["35"]);
				Slider["36"]["Name"] = [[BackgroundUICorner]];
				Slider["36"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.Background.SliderButton
				Slider["37"] = Instance.new("TextButton", Slider["35"]);
				Slider["37"]["TextSize"] = 14;
				Slider["37"]["BackgroundColor3"] = Color3.fromRGB(102, 5, 172);
				Slider["37"]["TextColor3"] = Color3.fromRGB(0, 0, 0);
				Slider["37"]["Size"] = UDim2.new(1, 0, 1, 0);
				Slider["37"]["Name"] = [[SliderButton]];
				Slider["37"]["Text"] = [[]];
				Slider["37"]["Font"] = Enum.Font.SourceSans;
				Slider["37"]["BackgroundTransparency"] = 1;

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.Background.SliderButton.MainSlider
				Slider["38"] = Instance.new("Frame", Slider["37"]);
				Slider["38"]["BackgroundColor3"] = Color3.fromRGB(102, 5, 172);
				Slider["38"]["Size"] = UDim2.new(1, 0, 1, 0);
				Slider["38"]["Name"] = [[MainSlider]];
				Slider["38"]["BorderSizePixel"] = 0

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Slider.Background.SliderButton.MainSlider.SliderUICorner
				Slider["39"] = Instance.new("UICorner", Slider["38"]);
				Slider["39"]["Name"] = [[SliderUICorner]];
				Slider["39"]["CornerRadius"] = UDim.new(0, 5);

				local MinSize = 10
				local MaxSize = 36

				local SizeFromScale = (MinSize +  (MaxSize - MinSize)) * DefaultScale
				SizeFromScale = SizeFromScale - (SizeFromScale % 2)

				Slider["38"].Size = UDim2.new(0, math.clamp(Mouse.X - Slider["38"].AbsolutePosition.X, 0, 454), 1, 0)

				Slider["37"].MouseButton1Down:Connect(function()
					local MouseMove, MouseKill
					MouseMove = Mouse.Move:Connect(function()
						local Px = GetXY(Slider["37"])
						local SizeFromScale = (MinSize +  (MaxSize - MinSize)) * Px
						local Value = math.floor(min + ((max - min) * Px))
						SizeFromScale = SizeFromScale - (SizeFromScale % 2)
						Slider["38"].Size = UDim2.new(0, math.clamp(Mouse.X - Slider["38"].AbsolutePosition.X, 0, 454), 1, 0)
						--Library:tween(Slider["38"], {Size = UDim2.fromScale(Px, 1)})
						Slider["34"].Text = tostring(Value)
						callback(Value)
					end)
					MouseKill = UserInputService.InputEnded:Connect(function(UserInput)
						if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then
							MouseMove:Disconnect()
							MouseKill:Disconnect()
						end
					end)
				end)

				Slider["37"].MouseButton1Down:Connect(function()
					local MouseMove, MouseKill

					local Px = GetXY(Slider["37"])
					local SizeFromScale = (MinSize +  (MaxSize - MinSize)) * Px
					local Value = math.floor(min + ((max - min) * Px))
					SizeFromScale = SizeFromScale - (SizeFromScale % 2)
					Slider["38"].Size = UDim2.new(0, math.clamp(Mouse.X - Slider["38"].AbsolutePosition.X, 0, 454), 1, 0)
					--Library:tween(Slider["38"], {Size = UDim2.fromScale(Px, 1)})
					Slider["34"].Text = tostring(Value)
					callback(Value)

					MouseKill = UserInputService.InputEnded:Connect(function(UserInput)
						if UserInput.UserInputType == Enum.UserInputType.MouseButton1 then

							MouseKill:Disconnect()
						end
					end)
				end)


			end

			return Slider
		end

		function Tab:NewToggle(label, callback)

			local State = false

			label = label or "New Toggle"
			callback = callback or function() end


			local Toggle = {}

			-- Render
			do
				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle
				Toggle["47"] = Instance.new("Frame", Tab["26"]);
				Toggle["47"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Toggle["47"]["Size"] = UDim2.new(0, 478, 0, 50);
				Toggle["47"]["Name"] = [[Toggle]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleUICorner
				Toggle["48"] = Instance.new("UICorner", Toggle["47"]);
				Toggle["48"]["Name"] = [[ToggleUICorner]];
				Toggle["48"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleLabel
				Toggle["49"] = Instance.new("TextLabel", Toggle["47"]);
				Toggle["49"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Toggle["49"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Toggle["49"]["TextSize"] = 14;
				Toggle["49"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Toggle["49"]["Size"] = UDim2.new(0.8012552857398987, 0, 1, 0);
				Toggle["49"]["Text"] = label;
				Toggle["49"]["Name"] = [[ToggleLabel]];
				Toggle["49"]["Font"] = Enum.Font.Gotham;
				Toggle["49"]["BackgroundTransparency"] = 1;
				Toggle["49"]["Position"] = UDim2.new(0.02301255241036415, 0, 0, 0);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleMainButton
				Toggle["4a"] = Instance.new("TextButton", Toggle["47"]);
				Toggle["4a"]["TextSize"] = 14;
				Toggle["4a"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
				Toggle["4a"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Toggle["4a"]["Size"] = UDim2.new(0.12275687605142593, 0, 0.5199999809265137, 0);
				Toggle["4a"]["Name"] = [[ToggleMainButton]];
				Toggle["4a"]["Text"] = [[]];
				Toggle["4a"]["Font"] = Enum.Font.Gotham;
				Toggle["4a"]["Position"] = UDim2.new(0.8646907806396484, 0, 0.23999999463558197, 0);
				Toggle["4a"]["BackgroundTransparency"] = 1;

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleMainButton.Background
				Toggle["4b"] = Instance.new("Frame", Toggle["4a"]);
				Toggle["4b"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
				Toggle["4b"]["Size"] = UDim2.new(1, 0, 1, 0);
				Toggle["4b"]["Name"] = [[Background]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleMainButton.Background.MainButtonUICorner
				Toggle["4c"] = Instance.new("UICorner", Toggle["4b"]);
				Toggle["4c"]["Name"] = [[MainButtonUICorner]];
				Toggle["4c"]["CornerRadius"] = UDim.new(0, 5);



				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleMainButton.Background.Frame.MainButtonUICorner
				Toggle["4e"] = Instance.new("UICorner", Toggle["4d"]);
				Toggle["4e"]["Name"] = [[MainButtonUICorner]];
				Toggle["4e"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleMainButton.Background.ToggleIndicator
				Toggle["4f"] = Instance.new("Frame", Toggle["4b"]);
				Toggle["4f"]["BackgroundColor3"] = Color3.fromRGB(255, 81, 81);
				Toggle["4f"]["Size"] = UDim2.new(0, 20, 0, 20);
				Toggle["4f"]["Position"] = UDim2.new(0, 34, 0.11538461595773697, 0);
				Toggle["4f"]["Name"] = [[ToggleIndicator]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ToggleMainButton.Background.ToggleIndicator.MainButtonUICorner
				Toggle["50"] = Instance.new("UICorner", Toggle["4f"]);
				Toggle["50"]["Name"] = [[MainButtonUICorner]];
				Toggle["50"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Toggle.ButtonUIStroke
				Toggle["51"] = Instance.new("UIStroke", Toggle["47"]);
				Toggle["51"]["Color"] = Color3.fromRGB(102, 5, 172);
				Toggle["51"]["Thickness"] = 0;
				Toggle["51"]["Name"] = [[ButtonUIStroke]];

				Toggle["4a"].MouseButton1Click:Connect(function()
					if not State then
						Toggle["4f"].Position = UDim2.new(0, 4, 0.11538461595773697, 0)
						Toggle["4f"].BackgroundColor3 = Color3.fromRGB(2, 255, 108)
						State = true
						callback(State)
					else
						Toggle["4f"].Position = UDim2.new(0, 34, 0.11538461595773697, 0)
						Toggle["4f"].BackgroundColor3 = Color3.fromRGB(255, 81, 81)
						State = false
						callback(State)
					end
				end)

			end

			return Toggle
		end

		function Tab:NewDropdown(label, itemList, callback)

			label = label or "New Dropdown"
			itemList = itemList or {}
			callback = callback or function() end

			local itemNumber = 0
			local pageSize = 0
			local dropOpened = false

			local Dropdown = {}

			-- Render
			do
				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown
				Dropdown["3a"] = Instance.new("Frame", Tab["26"]);
				Dropdown["3a"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Dropdown["3a"]["Size"] = UDim2.new(0, 478, 0, 50);
				Dropdown["3a"]["ClipsDescendants"] = true;
				Dropdown["3a"]["Position"] = UDim2.new(0, 0, 0.23716381192207336, 0);
				Dropdown["3a"]["Name"] = [[Dropdown]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropdownUICorner
				Dropdown["3b"] = Instance.new("UICorner", Dropdown["3a"]);
				Dropdown["3b"]["Name"] = [[DropdownUICorner]];
				Dropdown["3b"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropdownLabel
				Dropdown["3c"] = Instance.new("TextLabel", Dropdown["3a"]);
				Dropdown["3c"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Dropdown["3c"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Dropdown["3c"]["TextSize"] = 14;
				Dropdown["3c"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["3c"]["Size"] = UDim2.new(0.8451884388923645, 0, 0, 50);
				Dropdown["3c"]["Text"] = label;
				Dropdown["3c"]["Name"] = [[DropdownLabel]];
				Dropdown["3c"]["Font"] = Enum.Font.Gotham;
				Dropdown["3c"]["BackgroundTransparency"] = 1;
				Dropdown["3c"]["Position"] = UDim2.new(-0.005065329372882843, 0, 0, 0);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropdownLabel.SliderButton
				Dropdown["3d"] = Instance.new("TextButton", Dropdown["3c"]);
				Dropdown["3d"]["TextWrapped"] = true;
				Dropdown["3d"]["TextSize"] = 20;
				Dropdown["3d"]["BackgroundColor3"] = Color3.fromRGB(102, 5, 172);
				Dropdown["3d"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["3d"]["Size"] = UDim2.new(0.10962668806314468, 0, 0, 50);
				Dropdown["3d"]["Name"] = [[SliderButton]];
				Dropdown["3d"]["Text"] = [[>]];
				Dropdown["3d"]["Rotation"] = -90;
				Dropdown["3d"]["Font"] = Enum.Font.SourceSans;
				Dropdown["3d"]["Position"] = UDim2.new(-0.005024068523198366, 420, 0, 0);
				Dropdown["3d"]["BackgroundTransparency"] = 1;

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropdownLabel.DropdownSelected
				Dropdown["3e"] = Instance.new("TextLabel", Dropdown["3c"]);
				Dropdown["3e"]["TextXAlignment"] = Enum.TextXAlignment.Right;
				Dropdown["3e"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Dropdown["3e"]["TextSize"] = 14;
				Dropdown["3e"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["3e"]["Size"] = UDim2.new(0.34505757689476013, 0, 0, 50);
				Dropdown["3e"]["Text"] = [[None]];
				Dropdown["3e"]["Name"] = [[DropdownSelected]];
				Dropdown["3e"]["Font"] = Enum.Font.Gotham;
				Dropdown["3e"]["BackgroundTransparency"] = 1;
				Dropdown["3e"]["Position"] = UDim2.new(0.7232027053833008, 0, 0, 0);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropdownUIStroke
				Dropdown["3f"] = Instance.new("UIStroke", Dropdown["3a"]);
				Dropdown["3f"]["Color"] = Color3.fromRGB(102, 5, 172);
				Dropdown["3f"]["Thickness"] = 0;
				Dropdown["3f"]["Name"] = [[DropdownUIStroke]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropdownUIPadding
				Dropdown["40"] = Instance.new("UIPadding", Dropdown["3a"]);
				Dropdown["40"]["Name"] = [[DropdownUIPadding]];
				Dropdown["40"]["PaddingRight"] = UDim.new(0, 2);
				Dropdown["40"]["PaddingBottom"] = UDim.new(0, 2);
				Dropdown["40"]["PaddingLeft"] = UDim.new(0, 13);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll
				Dropdown["41"] = Instance.new("ScrollingFrame", Dropdown["3a"]);
				Dropdown["41"]["Active"] = true;
				Dropdown["41"]["BorderSizePixel"] = 0;
				Dropdown["41"]["CanvasSize"] = UDim2.new(0, 0, 0, 0);
				Dropdown["41"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
				Dropdown["41"]["AutomaticCanvasSize"] = Enum.AutomaticSize.Y;
				Dropdown["41"]["BackgroundTransparency"] = 1;
				Dropdown["41"]["Size"] = UDim2.new(0, 477, 0, 253);
				Dropdown["41"]["ScrollBarImageColor3"] = Color3.fromRGB(0, 0, 0);
				Dropdown["41"]["ScrollBarThickness"] = 0;
				Dropdown["41"]["Position"] = UDim2.new(-0.028077753260731697, 0, 0.18343046307563782, 0);
				Dropdown["41"]["Visible"] = false;
				Dropdown["41"]["Name"] = [[DropBTsScroll]];



				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropBTsScrollUIListLayout
				Dropdown["48"] = Instance.new("UIListLayout", Dropdown["41"]);
				Dropdown["48"]["Name"] = [[DropBTsScrollUIListLayout]];
				Dropdown["48"]["Padding"] = UDim.new(0, 5);
				Dropdown["48"]["SortOrder"] = Enum.SortOrder.LayoutOrder;

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropBTsScrollUIPadding
				Dropdown["49"] = Instance.new("UIPadding", Dropdown["41"]);
				Dropdown["49"]["PaddingTop"] = UDim.new(0, 3);
				Dropdown["49"]["Name"] = [[DropBTsScrollUIPadding]];
				Dropdown["49"]["PaddingRight"] = UDim.new(0, 2);
				Dropdown["49"]["PaddingBottom"] = UDim.new(0, 2);
				Dropdown["49"]["PaddingLeft"] = UDim.new(0, 13);





				for i, v in next, itemList do
					itemNumber = itemNumber + 1
					pageSize = pageSize + 60

					-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropButton
					Dropdown["42"] = Instance.new("Frame", Dropdown["41"]);
					Dropdown["42"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
					Dropdown["42"]["Size"] = UDim2.new(0, 450, 0, 50);
					Dropdown["42"]["Name"] = [[DropButton]];

					-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropButton.DropdownButtonUICorner
					Dropdown["43"] = Instance.new("UICorner", Dropdown["42"]);
					Dropdown["43"]["Name"] = [[DropdownButtonUICorner]];
					Dropdown["43"]["CornerRadius"] = UDim.new(0, 5);

					-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropButton.DropdownButtonLabel
					Dropdown["44"] = Instance.new("TextLabel", Dropdown["42"]);
					Dropdown["44"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
					Dropdown["44"]["TextSize"] = 14;
					Dropdown["44"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown["44"]["Size"] = UDim2.new(1, 0, 1, 0);
					Dropdown["44"]["Text"] = [[Button]];
					Dropdown["44"]["Name"] = [[DropdownButtonLabel]];
					Dropdown["44"]["Font"] = Enum.Font.Gotham;
					Dropdown["44"]["BackgroundTransparency"] = 1;

					-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropButton.DropdownMainButton
					Dropdown["45"] = Instance.new("TextButton", Dropdown["42"]);
					Dropdown["45"]["TextSize"] = 14;
					Dropdown["45"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
					Dropdown["45"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
					Dropdown["45"]["Size"] = UDim2.new(1, 0, 1, 0);
					Dropdown["45"]["Name"] = [[DropdownMainButton]];
					Dropdown["45"]["Text"] = [[]];
					Dropdown["45"]["Font"] = Enum.Font.Gotham;
					Dropdown["45"]["BackgroundTransparency"] = 1;

					-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropButton.DropdownMainButton.MainButtonUICorner
					Dropdown["46"] = Instance.new("UICorner", Dropdown["45"]);
					Dropdown["46"]["Name"] = [[MainButtonUICorner]];
					Dropdown["46"]["CornerRadius"] = UDim.new(0, 5);

					-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Dropdown.DropBTsScroll.DropButton.DropdownButtonUIStroke
					Dropdown["47"] = Instance.new("UIStroke", Dropdown["42"]);
					Dropdown["47"]["Color"] = Color3.fromRGB(102, 5, 172);
					Dropdown["47"]["Name"] = [[DropdownButtonUIStroke]];
					Dropdown["47"]["Thickness"] = 1

					Dropdown["44"].Text = v

					Dropdown["45"].MouseButton1Click:Connect(function()
						Dropdown["3e"].Text = v
						pcall(callback,v)
						Dropdown["47"].Thickness = 3
						wait(0.1)
						Dropdown["47"].Thickness = 1
						Dropdown["3a"].Size = UDim2.new(0, 478, 0, 50)
						Dropdown["3d"].Rotation = -90
						Dropdown["41"]["Visible"] = false
						dropOpened = false
					end)
				end
			end

			Dropdown["3d"].MouseButton1Click:Connect(function()
				if dropOpened then
					Dropdown["3a"].Size = UDim2.new(0, 478, 0, 50)
					Dropdown["3d"].Rotation = -90
					Dropdown["41"]["Visible"] = false
				else
					Dropdown["3a"].Size = UDim2.new(0, 478, 0, 310)
					Dropdown["3d"].Rotation = 90
					Dropdown["41"]["Visible"] = true
				end
				dropOpened = not dropOpened
			end)



			return Dropdown
		end



		function Tab:NewBar()

			local Bar = {}

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Bar
			Bar["7e"] = Instance.new("Frame", Tab["26"]);
			Bar["7e"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
			Bar["7e"]["Size"] = UDim2.new(0, 478, 0, 7);
			Bar["7e"]["Name"] = [[Bar]];

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Bar.BarUICorner
			Bar["7f"] = Instance.new("UICorner", Bar["7e"]);
			Bar["7f"]["Name"] = [[BarUICorner]];
			Bar["7f"]["CornerRadius"] = UDim.new(0, 5);

			-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Bar.UIStroke
			Bar["80"] = Instance.new("UIStroke", Bar["7e"]);
			Bar["80"]["Color"] = Color3.fromRGB(102, 5, 172);

			return Bar
		end

		function Tab:NewKeybind(label, key, callback)

			key = key or "Unknow"
			label = label or "New Keybind"
			callback = callback or function() end


			local closeKeys = {
				Enum.KeyCode.Backspace,Enum.KeyCode.Escape
			}

			local blacklistedKeys = { --add or remove keys if you find the need to
				Enum.KeyCode.Unknown,Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Slash,Enum.KeyCode.Tab,Enum.KeyCode.Backspace,Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four,Enum.KeyCode.Five,Enum.KeyCode.Six,Enum.KeyCode.Seven,Enum.KeyCode.Eight,Enum.KeyCode.Nine,Enum.KeyCode.Zero,Enum.KeyCode.Escape,Enum.KeyCode.F1,Enum.KeyCode.F2,Enum.KeyCode.F3,Enum.KeyCode.F4,Enum.KeyCode.F5,Enum.KeyCode.F6,Enum.KeyCode.F7,Enum.KeyCode.F8,Enum.KeyCode.F9,Enum.KeyCode.F10,Enum.KeyCode.F11,Enum.KeyCode.F12
			}

			local whitelistedMouse = { --add or remove mouse inputs if you find the need to
				Enum.UserInputType.MouseButton1,Enum.UserInputType.MouseButton2,Enum.UserInputType.MouseButton3
			}

			local Keybind = {}

			do
				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Keybind
				Keybind["81"] = Instance.new("Frame", Tab["26"]);
				Keybind["81"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Keybind["81"]["Size"] = UDim2.new(0, 478, 0, 50);
				Keybind["81"]["Name"] = [[Keybind]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Keybind.KeybindUICorner
				Keybind["82"] = Instance.new("UICorner", Keybind["81"]);
				Keybind["82"]["Name"] = [[KeybindUICorner]];
				Keybind["82"]["CornerRadius"] = UDim.new(0, 5);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Keybind.KeybindLabel
				Keybind["83"] = Instance.new("TextLabel", Keybind["81"]);
				Keybind["83"]["TextXAlignment"] = Enum.TextXAlignment.Left;
				Keybind["83"]["BackgroundColor3"] = Color3.fromRGB(41, 41, 41);
				Keybind["83"]["TextSize"] = 14;
				Keybind["83"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Keybind["83"]["Size"] = UDim2.new(0.8012552857398987, 0, 1, 0);
				Keybind["83"]["Text"] = label;
				Keybind["83"]["Name"] = [[KeybindLabel]];
				Keybind["83"]["Font"] = Enum.Font.Gotham;
				Keybind["83"]["BackgroundTransparency"] = 1;
				Keybind["83"]["Position"] = UDim2.new(0.02301255241036415, 0, 0, 0);

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Keybind.KeybindUIStroke
				Keybind["84"] = Instance.new("UIStroke", Keybind["81"]);
				Keybind["84"]["Color"] = Color3.fromRGB(102, 5, 172);
				Keybind["84"]["Thickness"] = 0;
				Keybind["84"]["Name"] = [[KeybindUIStroke]];

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Keybind.KeyButton
				Keybind["85"] = Instance.new("TextButton", Keybind["81"]);
				Keybind["85"]["TextSize"] = 14;
				Keybind["85"]["BackgroundColor3"] = Color3.fromRGB(36, 36, 36);
				Keybind["85"]["TextColor3"] = Color3.fromRGB(255, 255, 255);
				Keybind["85"]["Size"] = UDim2.new(0, 76, 0, 26);
				Keybind["85"]["Name"] = [[KeyButton]];
				Keybind["85"]["Text"] = key;
				Keybind["85"]["Font"] = Enum.Font.Gotham;
				Keybind["85"]["Position"] = UDim2.new(0.8240000009536743, 0, 0.23999999463558197, 0);
				Keybind["85"].MouseButton1Click:Connect(function(input)
					Keybind["85"].Text = "..."
				end)

				Keybind["85"].MouseButton1Click:Connect(function()
					Keybind["85"].Text = "..."
					local inputwait = game:GetService("UserInputService").InputBegan:wait()
					if inputwait.KeyCode.Name ~= "Unknown" then
						Keybind["85"].Text = inputwait.KeyCode.Name
						key = inputwait.KeyCode.Name
					else
						Keybind["85"].Text = "Unknown"
						key = nil
					end
				end)

				game:GetService("UserInputService").InputBegan:Connect(function(current, pressed)
					if not pressed then
						if current.KeyCode.Name == key then
							--pcall(callback)
							callback(key)
						else

						end
					end
				end
				)

				-- StarterGui.JaelLibrary.MainFrame.Tabs.Newtab.TabScrolling.Keybind.KeyButton.MainBoxUICorner
				Keybind["86"] = Instance.new("UICorner", Keybind["85"]);
				Keybind["86"]["Name"] = [[MainBoxUICorner]];
				Keybind["86"]["CornerRadius"] = UDim.new(0, 5);

			end
			return Keybind
		end

		return Tab
	end
	return GUI
end
return Library
