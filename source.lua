--// Variables
math.randomseed(os.time())

local function randomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, length do
        local randIndex = math.random(1, #chars)
        result = result .. chars:sub(randIndex, randIndex)
    end
    return result
end

local UILibrary = {}
UILibrary.Windows = {}

--// Functions
function UILibrary:MakeWindow(config)
    local window = {}
    window.Name = config.Name or "Main UI"
    window.Config = config or {}
    window.Tabs = {}

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = randomString(8)
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game:GetService("CoreGui")

    -- Create MainFrame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = randomString(8)
    mainFrame.Parent = screenGui
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 350, 0, 250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    mainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

    -- Create TopBar
    local topBar = Instance.new("Frame")
    topBar.Name = randomString(8)
    topBar.Parent = mainFrame
    topBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.ZIndex = 2

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = randomString(8)
    titleLabel.Parent = topBar
    titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.BorderSizePixel = 0
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.Font = Enum.Font.SourceSans
    titleLabel.Text = window.Name
    titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local padding = Instance.new("UIPadding")
    padding.Name = randomString(8)
    padding.Parent = titleLabel
    padding.PaddingLeft = UDim.new(0, 10)

    -- Dragging Functionality
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, dragStart, startPos

    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = randomString(8)
    contentFrame.Parent = mainFrame
    contentFrame.Position = UDim2.new(0, 100, 0, 40)
    contentFrame.Size = UDim2.new(1, -100, 1, -40)
    contentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    contentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    contentFrame.Active = true
    contentFrame.ScrollBarThickness = 0

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Name = randomString(8)
    contentLayout.Parent = contentFrame
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y)
    end)

    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = randomString(8)
    tabFrame.Parent = mainFrame
    tabFrame.Position = UDim2.new(0, 0, 0, 40)
    tabFrame.Size = UDim2.new(0, 100, 1, -40)
    tabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    tabFrame.Active = true
    tabFrame.ScrollBarThickness = 0

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Name = randomString(8)
    tabLayout.Parent = tabFrame
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
    end)

    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.ContentFrame = contentFrame
    window.TabFrame = tabFrame
    window.TopBar = topBar

    -- Destroy method
    function window:Destroy()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
            self.ScreenGui = nil
        end
    end

    -- Function to add a tab to the window
    function window:MakeTab(tabConfig)
        local tab = {}
        tab.Name = tabConfig.Name or "Tab"
        tab.Buttons = {}
        tab.Config = tabConfig

        local tabButton = Instance.new("TextButton")
        tabButton.Name = randomString(8)
        tabButton.Parent = window.TabFrame
        tabButton.Size = UDim2.new(1, 0, 0, 25)
        tabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Text = tab.Name
        tabButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        tabButton.TextSize = 14
        tab.ButtonTabButton = tabButton

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = randomString(8)
        tabContent.Parent = window.ContentFrame
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.Active = true
        tabContent.Visible = false
        tab.Content = tabContent

        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Name = randomString(8)
        tabContentLayout.Parent = tabContent
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Padding = UDim.new(0, 10)
        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
        end)

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(window.Tabs) do
                if t.Content then
                    t.Content.Visible = false
                end
            end
            tabContent.Visible = true
        end)

        function tab:AddButton(buttonConfig)
            local button = {}
            button.Name = buttonConfig.Name or "Button"
            button.Callback = buttonConfig.Callback or function()
                print("No callback defined for " .. button.Name)
            end

            table.insert(tab.Buttons, button)

            local buttonUI = Instance.new("TextButton")
            buttonUI.Name = randomString(8)
            buttonUI.Parent = tab.Content
            buttonUI.Size = UDim2.new(1, 0, 0, 35)
            buttonUI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            buttonUI.BorderColor3 = Color3.fromRGB(0, 0, 0)
            buttonUI.Font = Enum.Font.SourceSans
            buttonUI.Text = button.Name
            buttonUI.TextColor3 = Color3.fromRGB(0, 0, 0)
            buttonUI.TextSize = 14

            buttonUI.MouseButton1Click:Connect(function()
                button.Callback()
            end)

            return button
        end

        function tab:AddToggle(toggleConfig)
            local toggle = {}
            toggle.Name = toggleConfig.Name or "Toggle"
            toggle.State = toggleConfig.Default or false
            toggle.Callback = toggleConfig.Callback or function(state)
                print("Toggle state:", state)
            end

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = randomString(8)
            toggleFrame.Parent = tab.Content
            toggleFrame.Size = UDim2.new(1, 0, 0, 35)
            toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Name = randomString(8)
            toggleLabel.Parent = toggleFrame
            toggleLabel.Size = UDim2.new(0.5, 0, 1, 0)
            toggleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            toggleLabel.BorderSizePixel = 0
            toggleLabel.Font = Enum.Font.SourceSans
            toggleLabel.Text = toggle.Name
            toggleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            toggleLabel.TextSize = 14

            local toggleButton = Instance.new("TextButton")
            toggleButton.Name = randomString(8)
            toggleButton.Parent = toggleFrame
            toggleButton.Position = UDim2.new(1, -125, 0, 0)
            toggleButton.Size = UDim2.new(0.5, 0, 1, 0)
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
            toggleButton.BorderSizePixel = 0
            toggleButton.Font = Enum.Font.SourceSans
            toggleButton.Text = toggle.State and "ON" or "OFF"
            toggleButton.TextColor3 = toggle.State and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
            toggleButton.TextSize = 14

            toggleButton.MouseButton1Click:Connect(function()
                toggle.State = not toggle.State
                toggleButton.Text = toggle.State and "ON" or "OFF"
                toggleButton.TextColor3 = toggle.State and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                toggle.Callback(toggle.State)
            end)

            return toggle
        end

        function tab:AddSlider(sliderConfig)
            local slider = {}
            slider.Name = sliderConfig.Name or "Slider"
            slider.Min = sliderConfig.Min or 0
            slider.Max = sliderConfig.Max or 100
            slider.Value = sliderConfig.Default or slider.Min
            slider.Increment = sliderConfig.Increment or 1
            slider.Callback = sliderConfig.Callback or function(val) print(val) end

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = randomString(8)
            sliderFrame.Parent = tab.Content
            sliderFrame.Size = UDim2.new(1, 0, 0, 44)
            sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)

            local sliderBar = Instance.new("Frame")
            sliderBar.Name = randomString(8)
            sliderBar.Parent = sliderFrame
            sliderBar.Position = UDim2.new(0, 0, 1, -22)
            sliderBar.Size = UDim2.new(1, 0, 0.5, 0)
            sliderBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderBar.BorderColor3 = Color3.fromRGB(0, 0, 0)

            local fillPercent = math.clamp((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1)
            local fillBar = Instance.new("Frame")
            fillBar.Name = randomString(8)
            fillBar.Parent = sliderBar
            fillBar.Size = UDim2.new(fillPercent, 0, 1, 0)
            fillBar.BackgroundColor3 = sliderConfig.Color or Color3.fromRGB(0, 170, 0)
            fillBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
            fillBar.BorderSizePixel = 0

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Name = randomString(8)
            sliderLabel.Parent = sliderFrame
            sliderLabel.Size = UDim2.new(1, 0, 0.5, 0)
            sliderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sliderLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            sliderLabel.Font = Enum.Font.SourceSans
            sliderLabel.Text = slider.Name .. " (" .. slider.Value .. (sliderConfig.ValueName or "") .. ")"
            sliderLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            sliderLabel.TextSize = 14

            local draggingSlider = false

            local function updateSlider(mouseX)
                local relativeX = mouseX - sliderBar.AbsolutePosition.X
                local percent = math.clamp(relativeX / sliderBar.AbsoluteSize.X, 0, 1)
                local rawValue = slider.Min + (slider.Max - slider.Min) * percent
                local snappedValue = math.floor(rawValue / slider.Increment + 0.5) * slider.Increment
                snappedValue = math.clamp(snappedValue, slider.Min, slider.Max)
                percent = (snappedValue - slider.Min) / (slider.Max - slider.Min)
                fillBar.Size = UDim2.new(percent, 0, 1, 0)
                slider.Value = snappedValue
                sliderLabel.Text = slider.Name .. " (" .. snappedValue .. (sliderConfig.ValueName or "") .. ")"
                slider.Callback(snappedValue)
            end

            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    updateSlider(input.Position.X)
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            draggingSlider = false
                        end
                    end)
                end
            end)

            sliderBar.InputChanged:Connect(function(input)
                if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input.Position.X)
                end
            end)

            return slider
        end

        function tab:AddLabel(labelConfig)
            local label = {}
            label.Name = labelConfig.Name or "Label"
            local labelUI = Instance.new("TextLabel")
            labelUI.Name = randomString(8)
            labelUI.Parent = tab.Content
            labelUI.Size = labelConfig.Size or UDim2.new(1, 0, 0, 25)
            labelUI.BackgroundColor3 = labelConfig.BackgroundColor or Color3.fromRGB(255, 255, 255)
            labelUI.BorderColor3 = labelConfig.BorderColor or Color3.fromRGB(0, 0, 0)
            labelUI.Font = labelConfig.Font or Enum.Font.SourceSans
            labelUI.Text = labelConfig.Text or label.Name
            labelUI.TextColor3 = labelConfig.TextColor or Color3.fromRGB(0, 0, 0)
            labelUI.TextSize = labelConfig.TextSize or 14
            labelUI.TextWrapped = true
            labelUI.ClipsDescendants = true
            return label
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    table.insert(self.Windows, window)
    return window
end

return UILibrary
