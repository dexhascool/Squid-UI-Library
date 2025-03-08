# Kane-UI-Library

This documentation is for the stable release of **Kane UI Library**. It provides a simple and lightweight way to create custom in-game UIs for your script projects.

## Booting the Library

To load the library in your game, simply use:

```lua
local Kane = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Kane-UI-Library/main/source.lua"))()
```

## Creating a Window

Create a new UI window by calling:

```lua
local Window = Kane:MakeWindow({ Name = "My Custom UI" })
```

- Name: (string) The title of the UI window.

## Creating a Tab

Add a tab to your window:

```lua
local Tab = Window:MakeTab({ Name = "Tab 1" })
```

- Name: (string) The name of the tab.

## Creating a Button

Add a button to a tab:

```lua
Tab:AddButton({
    Name = "Click Me",
    Callback = function()
        print("Button pressed!")
    end
})
```

- Name: (string) The button’s label.
- Callback: (function) The function executed when the button is clicked.

## Creating a Toggle

Add a toggle to a tab:

```lua
Tab:AddToggle({
    Name = "Toggle Option",
    Default = false,
    Callback = function(state)
        print("Toggle state:", state)
    end
})
```

- Name: (string) The toggle’s label.
- Default: (bool) The default state (true for ON, false for OFF).
- Callback: (function) A function that receives the current state when toggled.

## Creating a Slider

Add a slider element to a tab:

```lua
Tab:AddSlider({
    Name = "Slider Option",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    ValueName = " units",
    Callback = function(value)
        print("Slider value:", value)
    end
})
```

- Name: (string) The slider’s label.
- Min: (number) The minimum value.
- Max: (number) The maximum value.
- Default: (number) The starting value.
- Increment: (number) The step by which the slider value will change.
- ValueName: (string) Text appended after the value.
- Callback: (function) A function that receives the new value as the slider is adjusted.

## Creating a Label

Add a simple text label to a tab:

```lua
Tab:AddLabel({
    Name = "InfoLabel",
    Text = "This is an informational label",
    Size = UDim2.new(1, 0, 0, 25),
    TextColor = Color3.fromRGB(0, 0, 0),
    TextSize = 14
})
```

- Name: (string) The internal name of the label.
- Text: (string) The text displayed on the label.
- Size: (UDim2) The size of the label.
- TextColor: (Color3) The color of the label's text.
- TextSize: (number) The size of the label’s text.

## Creating a Notification

```lua
UILibrary:MakeNotification({
    Title = "Notification Title",
    Text = "Notification Description",
    Icon = "rbxassetid://1234567890",
    Duration = 5
})
```

- Title: (string) The title of the notification.
- Text: (string) The message displayed in the notification.
- Icon: (string) The asset ID for the notification icon (optional).
- Duration: (number) How long (in seconds) the notification stays on screen (optional).

## Destroying the Interface

When you need to remove the UI from the game, call:

```lua
Kane:Destroy()
```

This will clean up and remove all UI elements associated with the window.
