local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sidhsksjsjsh/VAPE-UI-MODDED/main/.lua"))()
local wndw = lib:Window("VIP Turtle Hub V4")
local T1 = wndw:Tab("Main")
local T2 = wndw:Tab("Hatch")

local user = {
  self = game:GetService("Players").LocalPlayer,
  all = game:GetService("Players")
}

local workspace = game:GetService("Workspace")
local cg = game:GetService("CoreGui")
local var = {
  click = false,
  tp = false,
  egg = {
    table = {},
    toggle = false,
    s = "Basic",
    d = {}
  },
  gates = {},
  remote = {
    target = "Workspace",
    class = "BindableEvent",
    list = ""
  },
  alre = false
}

lib:AddTable(workspace.Eggs,var.egg.table)
lib:AddTable(workspace.Gates,var.gates)

T2:Dropdown("Choose egg",var.egg.table,function(value)
    var.egg.s = value
end)

T2:Toggle("Auto hatch",false,function(value)
    var.egg.toggle = value
    while wait() do
    if var.egg.toggle == false then break end
      game:GetService("ReplicatedStorage")["RemoteEvents"]["EggOpened"]:InvokeServer(var.egg.s,"Single",var.egg.d)
    end
end)

T1:Toggle("Auto click attack",false,function(value)
    var.click = value
    while wait() do
      if var.click == false then break end
      user.self["PlayerGui"]["RemoteEvents"]["Click"]:FireServer()
    end
end)

local ts = 0
T1:Toggle("Auto teleport / farm",false,function(value)
    var.tp = value
    if value == false then
      ts = 0
    end
    
    while wait(1.5) do
      if var.tp == false then break end
      ts = ts + 1
      if workspace.Race.Enemies:FindFirstChild(ts) then
        user.self.Character.HumanoidRootPart.CFrame = workspace["Race"]["Enemies"][ts]["MainPart"].CFrame
      else
        user.self.Character.HumanoidRootPart.CFrame = workspace["NPC"][ts]["Skin"]["HumanoidRootPart"].CFrame
      end
    end
end)

T1:Button("Destroy gates",function()
    for i,v in pairs(workspace.Gates:GetChildren()) do
      v:Destroy()
    end
end)

if player.self.Name == "Rivanda_Cheater" then
local T99 = wndw:Tab("Developer",true)
  --lib:synapse(bool)
T99:Button("Dex",function()
      if var.alre == false then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
      else
        lib:notify(lib:ColorFonts("Alr executed","Red"),10)
      end
end)
  
T99:Button("Turtle Explorer",function()
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/main/bundle.lua"))().Init(cg)
local PropertyAPIDump = game.HttpService:JSONDecode(game:HttpGet("https://anaminus.github.io/rbx/json/api/latest.json"))

local function GetPropertiesForInstance(Instance)
    local Properties = {}
    for i,v in next, PropertyAPIDump do
        if v.Class == Instance.ClassName and v.type == "Property" then
            pcall(function()
                Properties[v.Name] = {
                    Value = Instance[v.Name],
                    Type = v.ValueType,
                }
            end)
        end
    end
    return Properties
end

local ScriptContent = [[]]
local SelectedInstance = nil
local Properties = {}

local function CrawlInstances(Inst)
    for _, Instance in next, Inst:GetChildren() do
        local InstTree = Iris.Tree({Instance.Name})

        Iris.SameLine() do
            if Instance:IsA("LocalScript") or Instance:IsA("ModuleScript") then
                if Iris.SmallButton({"View Script"}).clicked then
                    ScriptContent = decompile(Instance)
                end
            end
            if Iris.SmallButton({"View and Copy Properties"}).clicked then
                SelectedInstance = Instance
                Properties = GetPropertiesForInstance(Instance)
                setclipboard(SelectedInstance and SelectedInstance:GetFullName() or "UNKNOWN INSTANCE")
                lib:notify("Copied to the clipboard",10)
            end
            Iris.End()
        end

        if InstTree.state.isUncollapsed.value then
            CrawlInstances(Instance)
        end
        Iris.End()
    end
end

Iris:Connect(function()
    local InstanceViewer = Iris.State(false)
    local PropertyViewer = Iris.State(false)
    local ScriptViewer = Iris.State(false)
    local CopyProp = Iris.State(false)

    Iris.Window({"Turtle Explorer Settings", [Iris.Args.Window.NoResize] = true}, {size = Iris.State(Vector2.new(400, 75)), position = Iris.State(Vector2.new(0, 0))}) do
        Iris.SameLine() do
            Iris.Checkbox({"Instance Viewer"}, {isChecked = InstanceViewer})
            Iris.Checkbox({"Property Viewer"}, {isChecked = PropertyViewer})
            Iris.Checkbox({"Script Viewer"}, {isChecked = ScriptViewer})
            Iris.End()
        end
        Iris.End()
    end

    if InstanceViewer.value then
        Iris.Window({"Turtle Explorer Instance Viewer", [Iris.Args.Window.NoClose] = true}, {size = Iris.State(Vector2.new(400, 300)), position = Iris.State(Vector2.new(0, 75))}) do
            CrawlInstances(game)
            Iris.End()
        end
    end

    if PropertyViewer.value then
        Iris.Window({"Turtle Explorer Property Viewer", [Iris.Args.Window.NoClose] = true}, {size = Iris.State(Vector2.new(400, 200)), position = Iris.State(Vector2.new(0, 375))}) do
            Iris.Text({("Viewing Properties For: %s"):format(
                SelectedInstance and SelectedInstance:GetFullName() or "UNKNOWN INSTANCE"
            )})
            Iris.Table({3, [Iris.Args.Table.RowBg] = true}) do
                for PropertyName, PropDetails in next, Properties do
                    Iris.Text({PropertyName})
                    Iris.NextColumn()
                    Iris.Text({PropDetails.Type})
                    Iris.NextColumn()
                    Iris.Text({tostring(PropDetails.Value)})
                    Iris.NextColumn()
                end
                Iris.End()
            end
        end
        Iris.End()
    end

    if ScriptViewer.value then
        Iris.Window({"Turtle Explorer Script Viewer", [Iris.Args.Window.NoClose] = true}, {size = Iris.State(Vector2.new(600, 575)), position = Iris.State(Vector2.new(400, 0))}) do
            if Iris.Button({"Copy Script"}).clicked then
                setclipboard(ScriptContent)
                lib:notify("Copied to the clipboard",10)
            end
            local Lines = ScriptContent:split("\n")
            for I, Line in next, Lines do
                Iris.Text({Line})
            end
            Iris.End()
        end
    end
end)
end)
  
T99:Button("3rd executor",function()
      lib:synapse(true)
end)
  
local T100 = wndw:Tab("Remote Finder")
local lab = T100:Label(var.remote.list)
  
T100:Dropdown("Target detection",{"Workspace","ReplicatedStorage","Players"},function(value)
      var.remote.target = value
end)

T100:Dropdown("Remote type",{"BindableEvent","BindableFunction","RemoteEvent","RemoteFunction","LocalScript","ModuleScript"},function(value)
      var.remote.class = value
end)

T100:Button("Start detect",function()
      lab:EditLabel("Loading... 'require()'")
      wait(1)
      lab:EditLabel("")
      for i,v in pairs(game:GetService(var.remote.target):GetDescendants()) do
        if v:IsA(var.remote.class) then
          if var.remote.class == "BindableEvent" then
            var.remote.list = var.remote.list .. "\n" .. lib:ColorFonts(v.Parent.Name .. "." .. v.Name,"Red") .. ":" .. lib:ColorFonts("Fire()","Yellow")
          elseif var.remote.class == "BindableFunction" then
            var.remote.list = var.remote.list .. "\n" .. lib:ColorFonts(v.Parent.Name .. "." .. v.Name,"Red") .. ":" .. lib:ColorFonts("Invoke()","Blue")
          elseif var.remote.class == "RemoteEvent" then
            var.remote.list = var.remote.list .. "\n" .. lib:ColorFonts(v.Parent.Name .. "." .. v.Name,"Red") .. ":" .. lib:ColorFonts("FireServer()","Yellow")
          elseif var.remote.class == "RemoteFunction" then
            var.remote.list = var.remote.list .. "\n" .. lib:ColorFonts(v.Parent.Name .. "." .. v.Name,"Red") .. ":" .. lib:ColorFonts("InvokeServer()","Blue")
          elseif var.remote.class == "LocalScript" then
            var.remote.list = var.remote.list .. "\n" .. lib:ColorFonts(v.Parent.Name .. "." .. v.Name,"Red") .. " -> " .. lib:ColorFonts("LocalScript","Green")
          elseif var.remote.class == "ModuleScript" then
            var.remote.list = var.remote.list .. "\n" .. lib:ColorFonts(v.Parent.Name .. "." .. v.Name,"Red") .. " -> " .. lib:ColorFonts("ModuleScript","Green")
          end
        end
      end
      lab:EditLabel(var.remote.list)
end)
end

lib:HookFunction(function(method,self,args)
    if method == "InvokeServer" and self == "EggOpened" then
      var.egg.d = args[3]
    end
end)
