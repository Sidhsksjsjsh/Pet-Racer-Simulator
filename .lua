local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sidhsksjsjsh/VAPE-UI-MODDED/main/.lua"))()
local wndw = lib:Window("VIP Turtle Hub V4")
local T1 = wndw:Tab("Main")
local T2 = wndw:Tab("Hatch")

local user = {
  self = game:GetService("Players").LocalPlayer,
  all = game:GetService("Players")
}

local workspace = game:GetService("Workspace")

local var = {
  click = false,
  tp = false,
  egg = {
    table = {},
    toggle = false,
    s = "Basic",
    d = {}
  },
  gates = {}
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

lib:HookFunction(function(method,self,args)
    if method == "InvokeServer" and self == "EggOpened" then
      var.egg.d = args[3]
    end
end)
