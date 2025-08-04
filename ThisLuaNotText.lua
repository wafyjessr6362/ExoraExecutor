-- Exora V1.0.0 – Elite Delta-Style Executor GUI
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Theme definitions
local Themes = {
  Dark = { bg = Color3.fromRGB(25,25,25), panel = Color3.fromRGB(40,40,40), text = Color3.new(1,1,1), button = Color3.fromRGB(0,120,255) },
  Light = { bg = Color3.fromRGB(240,240,240), panel = Color3.fromRGB(220,220,220), text = Color3.new(0,0,0), button = Color3.fromRGB(0,120,255) }
}
local currentTheme = Themes.Dark

local function roundify(obj, rad)
  local uic = Instance.new("UICorner")
  uic.CornerRadius = UDim.new(0, rad or 8)
  uic.Parent = obj
end

-- Main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExoraExecutor"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 360)
mainFrame.Position = UDim2.new(0, -510, 0.5, -180)
mainFrame.BackgroundColor3 = currentTheme.bg
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
roundify(mainFrame, 10)

-- Title bar with drag-to-move and pin lock
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,32)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8,0,1,0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🌀 Exora V1.0.0"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextColor3 = currentTheme.text
titleLabel.Parent = titleBar

local pinBtn = Instance.new("TextButton")
pinBtn.Size = UDim2.new(0,24,0,24)
pinBtn.Position = UDim2.new(1,-34,0,4)
pinBtn.Text = "📌"
pinBtn.BackgroundTransparency = 1
pinBtn.TextSize = 18
pinBtn.TextColor3 = currentTheme.text
pinBtn.Parent = titleBar

-- Tween animations
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Position = UDim2.new(0,10,0.5,-180)})
local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Position = UDim2.new(0,-510,0.5,-180)})

local pinned = false
local hovering = false

mainFrame.MouseEnter:Connect(function() hovering = true end)
mainFrame.MouseLeave:Connect(function() hovering = false end)

pinBtn.MouseButton1Click:Connect(function()
  pinned = not pinned
  pinBtn.TextColor3 = pinned and Color3.new(1,0.5,0) or currentTheme.text
end)

RunService.RenderStepped:Connect(function()
  if pinned then return end
  if hovering or mouse.X < 10 then
    openTween:Play()
  else
    closeTween:Play()
  end
end)

-- Drag to move functionality
local dragging, dragOffset = false, Vector2.new()
titleBar.InputBegan:Connect(function(inp)
  if inp.UserInputType == Enum.UserInputType.MouseButton1 then
    dragging = true
    dragOffset = mainFrame.AbsolutePosition - Vector2.new(mouse.X, mouse.Y)
  end
end)
titleBar.InputEnded:Connect(function(inp)
  if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
RunService.RenderStepped:Connect(function()
  if dragging then
    mainFrame.Position = UDim2.new(0, mouse.X + dragOffset.X, 0, mouse.Y + dragOffset.Y)
  end
end)

-- Sidebar Tabs Setup
local tabs = {"Executor", "ScriptHub", "Settings"}
local tabFrames = {}

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0,120,1,0)
sidebar.BackgroundColor3 = currentTheme.panel
sidebar.Parent = mainFrame
roundify(sidebar,6)

local layout = Instance.new("UIListLayout", sidebar)
layout.Padding = UDim.new(0,6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

for _, name in ipairs(tabs) do
  local btn = Instance.new("TextButton")
  btn.Size = UDim2.new(0.9,0,0,36)
  btn.Text = name
  btn.BackgroundColor3 = currentTheme.button
  btn.TextColor3 = currentTheme.text
  btn.Font = Enum.Font.SourceSansBold
  btn.TextSize = 16
  btn.Parent = sidebar
  roundify(btn,6)

  local frame = Instance.new("Frame")
  frame.Size = UDim2.new(1,-130,1,-42)
  frame.Position = UDim2.new(0,130,0,32)
  frame.BackgroundColor3 = currentTheme.panel
  frame.Visible = false
  frame.Parent = mainFrame
  roundify(frame,6)
  tabFrames[name] = frame

  btn.MouseButton1Click:Connect(function()
    for _, f in pairs(tabFrames) do f.Visible = false end
    frame.Visible = true
  end)
end
tabFrames["Executor"].Visible = true

-- Executor Tab UI
local scriptBox = Instance.new("TextBox")
scriptBox.Size = UDim2.new(1,-20,0,180)
scriptBox.Position = UDim2.new(0,10,0,10)
scriptBox.PlaceholderText = "Paste your Lua script here..."
scriptBox.ClearTextOnFocus = false
scriptBox.MultiLine = true
scriptBox.TextWrapped = true
scriptBox.TextSize = 16
scriptBox.Font = Enum.Font.Code
scriptBox.TextColor3 = currentTheme.text
scriptBox.BackgroundColor3 = currentTheme.bg
scriptBox.Parent = tabFrames["Executor"]
roundify(scriptBox,6)

local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0,120,0,36)
execBtn.Position = UDim2.new(0,10,0,200)
execBtn.Text = "Execute"
execBtn.BackgroundColor3 = currentTheme.button
execBtn.TextColor3 = Color3.new(1,1,1)
execBtn.Font = Enum.Font.SourceSansBold
execBtn.TextSize = 16
execBtn.Parent = tabFrames["Executor"]
roundify(execBtn,6)

execBtn.MouseButton1Click:Connect(function()
  if scriptBox.Text ~= "" then pcall(function() loadstring(scriptBox.Text)() end) end
end)

-- ScriptHub with 10 built-in scripts
local scriptHub = {
  {"Infinite Yield","https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
  {"Bang GUI","https://raw.githubusercontent.com/4gh9/Bang-Script-Gui/main/bang%20gui.lua"},
  {"IDK","https://raw.githubusercontent.com/imalwaysad/universal-gui/main/jerk%20off%20r6"},
  {"TSB","https://raw.githubusercontent.com/yes1nt/yes/main/Trashcan Man"},
  {"Blox Fruit","https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed Hub X.lua"},
  {"Ink Game","https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/InkGame"},
  {"Fling GUI","https://raw.githubusercontent.com/ADSKerOffical/FlingPlayers/main/FlingGUI"},
  {"Grow a Garden","https://raw.githubusercontent.com/Skibidiking123/Fisch1/main/FischMain"},
  {"Steal A Brainrot","https://raw.githubusercontent.com/egor2078f/steal/main/loader.lua"},
  {"Arsenal Script","https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubArsenal"}
}

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-20)
scroll.Position = UDim2.new(0,10,0,10)
scroll.CanvasSize = UDim2.new(0,0,0,#scriptHub*40)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = currentTheme.bg
scroll.Parent = tabFrames["ScriptHub"]
roundify(scroll,6)

local hubLayout = Instance.new("UIListLayout", scroll)
hubLayout.Padding = UDim.new(0,6)
hubLayout.SortOrder = Enum.SortOrder.LayoutOrder

for _, data in ipairs(scriptHub) do
  local b = Instance.new("TextButton")
  b.Size = UDim2.new(1,-10,0,32)
  b.Position = UDim2.new(0,5,0,hubLayout.AbsoluteContentSize)
  b.Text = data[1]
  b.BackgroundColor3 = currentTheme.button
  b.TextColor3 = currentTheme.text
  b.Font = Enum.Font.SourceSans
  b.TextSize = 14
  b.Parent = scroll
  roundify(b,4)

  b.MouseButton1Click:Connect(function()
    pcall(function() loadstring(game:HttpGet(data[2]))() end)
  end)
end

-- Settings Tab with theme toggle
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0,160,0,40)
themeBtn.Position = UDim2.new(0,20,0,20)
themeBtn.Text = "Switch to Light Theme"
themeBtn.Font = Enum.Font.SourceSansBold
themeBtn.TextSize = 14
themeBtn.TextColor3 = currentTheme.text
themeBtn.BackgroundColor3 = currentTheme.button
themeBtn.Parent = tabFrames["Settings"]
roundify(themeBtn,6)

themeBtn.MouseButton1Click:Connect(function()
  currentTheme = (currentTheme == Themes.Dark) and Themes.Light or Themes.Dark
  themeBtn.Text = (currentTheme == Themes.Dark) and "Switch to Light Theme" or "Switch to Dark Theme"

  -- Apply theme colors globally
  mainFrame.BackgroundColor3 = currentTheme.bg
  sidebar.BackgroundColor3 = currentTheme.panel
  titleLabel.TextColor3 = currentTheme.text
  pinBtn.TextColor3 = currentTheme.text
  scriptBox.TextColor3 = currentTheme.text
  scriptBox.BackgroundColor3 = currentTheme.bg
  execBtn.BackgroundColor3 = currentTheme.button

  for _, c in ipairs(sidebar:GetChildren()) do
    if c:IsA("TextButton") then
      c.BackgroundColor3 = currentTheme.button
      c.TextColor3 = currentTheme.text
    end
  end
  for _, f in pairs(tabFrames) do f.BackgroundColor3 = currentTheme.panel end
  for _, obj in ipairs(scroll:GetChildren()) do
    if obj:IsA("TextButton") then
      obj.BackgroundColor3 = currentTheme.button
      obj.TextColor3 = currentTheme.text
    end
  end
end)
