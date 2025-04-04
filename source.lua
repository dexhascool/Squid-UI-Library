local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local UILib = {}
UILib.__index = UILib

local function addHoverTween(inst, targetColor)
	local origColor = inst.BackgroundColor3
	inst.MouseEnter:Connect(function()
		local tween = TweenService:Create(inst, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
		tween:Play()
	end)
	inst.MouseLeave:Connect(function()
		local tween = TweenService:Create(inst, TweenInfo.new(0.2), {BackgroundColor3 = origColor})
		tween:Play()
	end)
end

UILib.WindowMethods = {}

function UILib.WindowMethods:MakeTab(options)
	options = options or {}
	local tab = {}
	tab.Name = options.Name or "Tab"
	tab.TabButton = Instance.new("TextButton")
	tab.TabButton.Name = options.Name or "Tab1"
	tab.TabButton.Parent = self.Tablist
	tab.TabButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
	tab.TabButton.BorderColor3 = Color3.fromRGB(0,0,0)
	tab.TabButton.Position = UDim2.new(0,17,0,0)
	tab.TabButton.Size = UDim2.new(1,-13,0,30)
	tab.TabButton.Font = Enum.Font.Ubuntu
	tab.TabButton.Text = options.Name or "Tab"
	tab.TabButton.TextColor3 = Color3.fromRGB(230,230,230)
	tab.TabButton.TextSize = 15
	addHoverTween(tab.TabButton, Color3.fromRGB(125,25,26))
	tab.Indicator = Instance.new("Frame")
	tab.Indicator.Name = "Indicator"
	tab.Indicator.Parent = tab.TabButton
	tab.Indicator.BackgroundColor3 = Color3.fromRGB(126,25,26)
	tab.Indicator.BorderColor3 = Color3.fromRGB(0,0,0)
	tab.Indicator.Position = UDim2.new(0,-10,0,1)
	tab.Indicator.Size = UDim2.new(0,10,1,-2)
	tab.Indicator.Visible = false
	tab.Content = Instance.new("Frame")
	tab.Content.Name = "TabContent"
	tab.Content.Parent = self.Contentframe
	tab.Content.BackgroundTransparency = 1
	tab.Content.Size = UDim2.new(1,0,1,0)
	tab.Content.Visible = false
	local uiList = Instance.new("UIListLayout")
	uiList.Parent = tab.Content
	uiList.SortOrder = Enum.SortOrder.LayoutOrder
	uiList.Padding = UDim.new(0,6)
	tab.Elements = {}
	table.insert(self.Tabs, tab)
	tab.TabButton.MouseButton1Click:Connect(function()
		for _, t in ipairs(self.Tabs) do
			t.Content.Visible = false
			if t.Indicator then
				t.Indicator.Visible = false
			end
		end
		tab.Content.Visible = true
		tab.Indicator.Visible = true
	end)
	setmetatable(tab, {__index = UILib.TabMethods})
	return tab
end

UILib.TabMethods = {}

function UILib.TabMethods:MakeSection(options)
	options = options or {}
	local section = {}
	section.Name = options.Name or "Section One"
	section.Frame = Instance.new("Frame")
	section.Frame.Name = "Sectionframe"
	section.Frame.Parent = self.Content
	section.Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	section.Frame.BorderColor3 = Color3.fromRGB(0,0,0)
	section.Frame.Size = UDim2.new(1,0,0,95)
	section.Sectiontitlelabel = Instance.new("TextLabel")
	section.Sectiontitlelabel.Name = "Sectiontitlelabel"
	section.Sectiontitlelabel.Parent = section.Frame
	section.Sectiontitlelabel.BackgroundColor3 = Color3.fromRGB(40,40,40)
	section.Sectiontitlelabel.BorderColor3 = Color3.fromRGB(0,0,0)
	section.Sectiontitlelabel.Size = UDim2.new(1,0,0,25)
	section.Sectiontitlelabel.Font = Enum.Font.Ubuntu
	section.Sectiontitlelabel.Text = section.Name
	section.Sectiontitlelabel.TextColor3 = Color3.fromRGB(230,230,230)
	section.Sectiontitlelabel.TextSize = 15
	section.Content = Instance.new("Frame")
	section.Content.Name = "Contentframe"
	section.Content.Parent = section.Frame
	section.Content.BackgroundColor3 = Color3.fromRGB(255,255,255)
	section.Content.BackgroundTransparency = 1
	section.Content.BorderColor3 = Color3.fromRGB(0,0,0)
	section.Content.BorderSizePixel = 0
	section.Content.Position = UDim2.new(0,3,0,28)
	section.Content.Size = UDim2.new(1,-6,1,-31)
	local list = Instance.new("UIListLayout")
	list.Parent = section.Content
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0,4)
	list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		section.Frame.Size = UDim2.new(1,0,0,25 + list.AbsoluteContentSize.Y + 6)
	end)
	section.Elements = {}
	setmetatable(section, {__index = UILib.SectionMethods})
	return section
end

UILib.CommonElementMethods = {}

function UILib.CommonElementMethods:AddButton(options)
	options = options or {}
	local button = Instance.new("TextButton")
	button.Name = options.Name or "Button"
	button.BackgroundColor3 = Color3.fromRGB(50,50,50)
	button.BorderColor3 = Color3.fromRGB(0,0,0)
	button.Size = UDim2.new(1,0,0,30)
	button.Font = Enum.Font.Ubuntu
	button.Text = options.Name or "Button"
	button.TextColor3 = Color3.fromRGB(230,230,230)
	button.TextSize = 15
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.AutoButtonColor = false
	button.Parent = self.Content
	local pad = Instance.new("UIPadding")
	pad.Parent = button
	pad.PaddingLeft = UDim.new(0,10)
	addHoverTween(button, Color3.fromRGB(125,25,26))
	button.MouseButton1Click:Connect(function()
		if options.Callback then options.Callback() end
	end)
	table.insert(self.Elements, button)
	return button
end

function UILib.CommonElementMethods:AddToggle(options)
	options = options or {}
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = "Toggle"
	toggleFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
	toggleFrame.BorderColor3 = Color3.fromRGB(0,0,0)
	toggleFrame.Size = UDim2.new(1,0,0,30)
	toggleFrame.Parent = self.Content
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "TextLabel"
	textLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
	textLabel.BackgroundTransparency = 1
	textLabel.BorderColor3 = Color3.fromRGB(0,0,0)
	textLabel.BorderSizePixel = 0
	textLabel.Size = UDim2.new(1,-30,1,0)
	textLabel.Font = Enum.Font.Ubuntu
	textLabel.Text = options.Name or "Toggle"
	textLabel.TextColor3 = Color3.fromRGB(230,230,230)
	textLabel.TextSize = 15
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Parent = toggleFrame
	local pad = Instance.new("UIPadding")
	pad.Parent = textLabel
	pad.PaddingLeft = UDim.new(0,10)
	
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "Togglebutton"
	toggleButton.Parent = toggleFrame
	toggleButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
	toggleButton.BorderColor3 = Color3.fromRGB(0,0,0)
	toggleButton.Position = UDim2.new(1,-27,0,3)
	toggleButton.Size = UDim2.new(0,24,0,24)
	toggleButton.AutoButtonColor = false
	toggleButton.Font = Enum.Font.SourceSans
	toggleButton.Text = ""
	toggleButton.TextColor3 = Color3.fromRGB(0,0,0)
	toggleButton.TextSize = 14
	toggleButton.TextTransparency = 1
	toggleButton.MouseEnter:Connect(function()
		if not options.Default then
			local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(125,25,26)})
			tween:Play()
		end
	end)
	toggleButton.MouseLeave:Connect(function()
		if not options.Default then
			local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,80,80)})
			tween:Play()
		else
			toggleButton.BackgroundColor3 = Color3.fromRGB(126,25,27)
		end
	end)
	local toggled = options.Default or false
	if toggled then
		toggleButton.BackgroundColor3 = Color3.fromRGB(126,25,27)
	end
	toggleButton.MouseButton1Click:Connect(function()
		toggled = not toggled
		options.Default = toggled
		local targetColor = toggled and Color3.fromRGB(126,25,27) or Color3.fromRGB(80,80,80)
		local tween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = targetColor})
		tween:Play()
		if options.Callback then options.Callback(toggled) end
	end)
	table.insert(self.Elements, toggleFrame)
	return toggleFrame
end

function UILib.CommonElementMethods:AddSlider(options)
	options = options or {}
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = "Slider"
	sliderFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
	sliderFrame.BorderColor3 = Color3.fromRGB(0,0,0)
	sliderFrame.Size = UDim2.new(1,0,0,50)
	sliderFrame.Parent = self.Content
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Titlelabel"
	titleLabel.Parent = sliderFrame
	titleLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.BorderColor3 = Color3.fromRGB(0,0,0)
	titleLabel.BorderSizePixel = 0
	titleLabel.Size = UDim2.new(0.400000006,0,0,20)
	titleLabel.Font = Enum.Font.Ubuntu
	titleLabel.Text = options.Name or "Slider"
	titleLabel.TextColor3 = Color3.fromRGB(230,230,230)
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	local pad = Instance.new("UIPadding")
	pad.Parent = titleLabel
	pad.PaddingLeft = UDim.new(0,10)
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Valuelabel"
	valueLabel.Parent = sliderFrame
	valueLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
	valueLabel.BackgroundTransparency = 1
	valueLabel.BorderColor3 = Color3.fromRGB(0,0,0)
	valueLabel.BorderSizePixel = 0
	valueLabel.Position = UDim2.new(0,145,0,0)
	valueLabel.Size = UDim2.new(0.200000003,0,0,20)
	valueLabel.Font = Enum.Font.Ubuntu
	local defaultVal = options.Default or 5
	valueLabel.Text = tostring(defaultVal) .. "/" .. tostring(options.Max or 10)
	valueLabel.TextColor3 = Color3.fromRGB(230,230,230)
	valueLabel.TextSize = 15
	valueLabel.Parent = sliderFrame
	local valueBox = Instance.new("TextBox")
	valueBox.Name = "Valuebox"
	valueBox.Parent = sliderFrame
	valueBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
	valueBox.BackgroundTransparency = 1
	valueBox.BorderColor3 = Color3.fromRGB(0,0,0)
	valueBox.BorderSizePixel = 0
	valueBox.Position = UDim2.new(0,217,0,0)
	valueBox.Size = UDim2.new(0.400000006,0,0,20)
	valueBox.Font = Enum.Font.Ubuntu
	valueBox.PlaceholderText = "Enter value..."
	valueBox.Text = tostring(defaultVal)
	valueBox.TextColor3 = Color3.fromRGB(230,230,230)
	valueBox.TextSize = 15
	valueBox.TextXAlignment = Enum.TextXAlignment.Right
	local pad2 = Instance.new("UIPadding")
	pad2.Parent = valueBox
	pad2.PaddingRight = UDim.new(0,10)
	local sliderBar = Instance.new("Frame")
	sliderBar.Name = "Sliderbar"
	sliderBar.Parent = sliderFrame
	sliderBar.BackgroundColor3 = Color3.fromRGB(80,80,80)
	sliderBar.BorderColor3 = Color3.fromRGB(0,0,0)
	sliderBar.Position = UDim2.new(0,15,0,30)
	sliderBar.Size = UDim2.new(1,-30,0,10)
	local fillBar = Instance.new("Frame")
	fillBar.Name = "Fillbar"
	fillBar.Parent = sliderBar
	fillBar.BackgroundColor3 = Color3.fromRGB(126,25,27)
	fillBar.BorderColor3 = Color3.fromRGB(0,0,0)
	local minVal = options.Min or 0
	local maxVal = options.Max or 10
	local initPercent = (defaultVal - minVal) / (maxVal - minVal)
	fillBar.Size = UDim2.new(initPercent,0,1,0)
	local increment = options.Increment or 1
	local function updateSlider(x)
		local relX = math.clamp(x - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
		local percent = relX / sliderBar.AbsoluteSize.X
		local value = math.floor(minVal + (maxVal - minVal) * percent + 0.5)
		value = math.floor(value / increment + 0.5) * increment
		value = math.clamp(value, minVal, maxVal)
		valueLabel.Text = tostring(value) .. "/" .. tostring(maxVal)
		valueBox.Text = tostring(value)
		local targetSize = UDim2.new((value - minVal)/(maxVal - minVal),0,1,0)
		local tween = TweenService:Create(fillBar, TweenInfo.new(0.2), {Size = targetSize})
		tween:Play()
		if options.Callback then options.Callback(value) end
	end
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateSlider(input.Position.X)
			local moveConn
			moveConn = UserInputService.InputChanged:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					updateSlider(input.Position.X)
				end
			end)
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					moveConn:Disconnect()
				end
			end)
		end
	end)
	valueBox.FocusLost:Connect(function()
		local num = tonumber(valueBox.Text)
		if num then
			num = math.clamp(num, minVal, maxVal)
			valueLabel.Text = tostring(num) .. "/" .. tostring(maxVal)
			local targetSize = UDim2.new((num - minVal)/(maxVal - minVal),0,1,0)
			local tween = TweenService:Create(fillBar, TweenInfo.new(0.2), {Size = targetSize})
			tween:Play()
			if options.Callback then options.Callback(num) end
		else
			valueBox.Text = tostring(defaultVal)
		end
	end)
	table.insert(self.Elements, sliderFrame)
	return sliderFrame
end

function UILib.CommonElementMethods:AddLabel(options)
	options = options or {}
	local label = Instance.new("TextLabel")
	label.Name = options.Name or "Label"
	label.BackgroundColor3 = Color3.fromRGB(50,50,50)
	label.BorderColor3 = Color3.fromRGB(0,0,0)
	label.Size = UDim2.new(1,0,0,22)
	label.Font = Enum.Font.Ubuntu
	label.Text = options.Text or ""
	label.TextColor3 = Color3.fromRGB(230,230,230)
	label.TextSize = 15
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = self.Content
	local pad = Instance.new("UIPadding")
	pad.Parent = label
	pad.PaddingLeft = UDim.new(0,10)
	table.insert(self.Elements, label)
	return label
end

UILib.TabMethods.AddButton = UILib.CommonElementMethods.AddButton
UILib.TabMethods.AddToggle = UILib.CommonElementMethods.AddToggle
UILib.TabMethods.AddSlider = UILib.CommonElementMethods.AddSlider
UILib.TabMethods.AddLabel = UILib.CommonElementMethods.AddLabel

UILib.SectionMethods = {}
UILib.SectionMethods.AddButton = UILib.CommonElementMethods.AddButton
UILib.SectionMethods.AddToggle = UILib.CommonElementMethods.AddToggle
UILib.SectionMethods.AddSlider = UILib.CommonElementMethods.AddSlider
UILib.SectionMethods.AddLabel = UILib.CommonElementMethods.AddLabel

function UILib:MakeWindow(options)
	options = options or {}
	local window = {}
	window.Name = options.Name or "Project Jellyfish"
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("CoreGUI")
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	window.ScreenGui = ScreenGui
	local Mainframe = Instance.new("Frame")
	Mainframe.Name = "Mainframe"
	Mainframe.Parent = ScreenGui
	Mainframe.AnchorPoint = Vector2.new(0.5,0.5)
	Mainframe.BackgroundColor3 = Color3.fromRGB(15,15,15)
	Mainframe.BorderColor3 = Color3.fromRGB(0,0,0)
	Mainframe.Position = UDim2.new(0.5,0,0.5,0)
	Mainframe.Size = UDim2.new(0,475,0,335)
	window.Mainframe = Mainframe
	local Topbar = Instance.new("Frame")
	Topbar.Name = "Topbar"
	Topbar.Parent = Mainframe
	Topbar.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Topbar.BorderColor3 = Color3.fromRGB(0,0,0)
	Topbar.Size = UDim2.new(1,0,0,35)
	window.Topbar = Topbar
	local Titlelabel = Instance.new("TextLabel")
	Titlelabel.Name = "Titlelabel"
	Titlelabel.Parent = Topbar
	Titlelabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Titlelabel.BackgroundTransparency = 1
	Titlelabel.BorderColor3 = Color3.fromRGB(0,0,0)
	Titlelabel.BorderSizePixel = 0
	Titlelabel.Size = UDim2.new(0.5,0,1,0)
	Titlelabel.Font = Enum.Font.SourceSans
	Titlelabel.Text = window.Name
	Titlelabel.TextColor3 = Color3.fromRGB(230,230,230)
	Titlelabel.TextSize = 18
	Titlelabel.TextXAlignment = Enum.TextXAlignment.Left
	local pad = Instance.new("UIPadding")
	pad.Parent = Titlelabel
	pad.PaddingLeft = UDim.new(0,10)
	window.Titlelabel = Titlelabel
	local Tablist = Instance.new("Frame")
	Tablist.Name = "Tablist"
	Tablist.Parent = Mainframe
	Tablist.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Tablist.BorderColor3 = Color3.fromRGB(0,0,0)
	Tablist.Position = UDim2.new(0,0,0,36)
	Tablist.Size = UDim2.new(0,100,1,-36)
	local pad2 = Instance.new("UIPadding")
	pad2.Parent = Tablist
	pad2.PaddingRight = UDim.new(0,3)
	pad2.PaddingTop = UDim.new(0,3)
	local list = Instance.new("UIListLayout")
	list.Parent = Tablist
	list.HorizontalAlignment = Enum.HorizontalAlignment.Right
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0,4)
	window.Tablist = Tablist
	local Contentframe = Instance.new("ScrollingFrame")
	Contentframe.Name = "Contentframe"
	Contentframe.Parent = Mainframe
	Contentframe.Active = true
	Contentframe.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Contentframe.BackgroundTransparency = 1
	Contentframe.BorderColor3 = Color3.fromRGB(0,0,0)
	Contentframe.Position = UDim2.new(0,103,0,38)
	Contentframe.Size = UDim2.new(1,-106,1,-41)
	Contentframe.CanvasSize = UDim2.new(0,0,1,-41)
	Contentframe.ScrollBarThickness = 6
	window.Contentframe = Contentframe
	do
		local dragging = false
		local dragStart, startPos
		Topbar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = Mainframe.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		Topbar.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local delta = input.Position - dragStart
				Mainframe.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end
		end)
	end
	window.Tabs = {}
	setmetatable(window, {__index = UILib.WindowMethods})
	return window
end

return UILib
