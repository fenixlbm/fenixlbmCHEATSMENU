-- FENIX CHEATS v6 - loader protegido
print("[Fenix] 1/4 script recebido")
local __Players = game:GetService("Players")
local function __showError(msg)
    warn("[Fenix] ERRO FATAL:\n"..tostring(msg))
    pcall(function() if setclipboard then setclipboard(tostring(msg)) end end)
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "FenixError" g.ResetOnSpawn = false g.IgnoreGuiInset = true
        g.Parent = __Players.LocalPlayer:WaitForChild("PlayerGui")
        local f = Instance.new("Frame", g)
        f.Size = UDim2.fromOffset(560, 200) f.Position = UDim2.fromOffset(20, 20)
        f.BackgroundColor3 = Color3.fromRGB(40, 10, 10) f.BorderSizePixel = 0
        local t = Instance.new("TextLabel", f)
        t.Size = UDim2.new(1, -16, 1, -16) t.Position = UDim2.fromOffset(8, 8)
        t.BackgroundTransparency = 1 t.TextColor3 = Color3.new(1, 1, 1)
        t.TextWrapped = true t.TextSize = 13 t.Font = Enum.Font.Code
        t.TextXAlignment = Enum.TextXAlignment.Left t.TextYAlignment = Enum.TextYAlignment.Top
        t.Text = "FENIX - erro (copiado para o clipboard):\n"..string.sub(tostring(msg), 1, 700)
    end)
end
local __ok, __err = xpcall(function()

print("[Fenix] 2/4 a arrancar")
local cloneref = cloneref or function(o) return o end
local function svc(n) return cloneref(game:GetService(n)) end

local Players         = svc("Players")
local RunService      = svc("RunService")
local UIS             = svc("UserInputService")
local CAS             = svc("ContextActionService")
local TweenService    = svc("TweenService")
local Workspace       = svc("Workspace")
local HttpService     = svc("HttpService")
local Stats           = svc("Stats")
local Lighting        = svc("Lighting")
local TeleportService = svc("TeleportService")
local VirtualUser     = svc("VirtualUser")
local MarketService   = svc("MarketplaceService")
local ReplicatedStorage = svc("ReplicatedStorage")
local Chat            = svc("Chat")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera
local Mouse       = LocalPlayer:GetMouse()
local env         = (getgenv and getgenv()) or _G

if env.FenixCleanup then pcall(env.FenixCleanup) end

local alive    = true
local menuOpen = true
local aiming   = false
local cleanup

local FX = {
    remotes=nil, remotesT=0, itemFound=nil, itemT=0, rbT=0, ltApplied=false,
    tpOrig=nil, wireOrig={}, reachOrig={}, sj=false,
    lastShot=0, acLastRun=0, hue=0, notifyCount=0,
    kwCache={}, kwN=0, live={},
    espOn=false, aimOn=false, specOn=false, crossOn=false, specT=0,
    btData=setmetatable({}, {__mode="k"}),
    velData=setmetatable({}, {__mode="k"}),
    matChams=setmetatable({}, {__mode="k"}),
    osArrows={}, itemTr={}, pingHist={}, pingLines={}, pingLastT=0,
    hudLines={}, plrListLines={}, plrListT=0, webhookQ={},
    sf={lastVal=nil,lastT=0,idx=1,remotes={}},
    moveToHooked=false, arHooked=false,
    binds={}, listening=nil,
}

function FX.allRemotes()
    local now = os.clock()
    if FX.remotes and now - FX.remotesT < 10 then return FX.remotes end
    local list = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then list[#list+1] = obj end
    end
    FX.remotes, FX.remotesT = list, now
    return list
end

local hasDrawing = false
do
    local ok, obj = pcall(function() return Drawing and Drawing.new("Line") end)
    if ok and obj then hasDrawing = true pcall(function() obj:Remove() end) end
end
local hasFS  = type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function"
local reqFn  = (type(request)=="function" and request) or
               (type(http_request)=="function" and http_request) or
               (syn and syn.request) or nil
local hasHook = type(hookmetamethod)=="function" and type(newcclosure)=="function" and type(checkcaller)=="function"

if type(mouse1click)=="function" then
    FX.clickFn = mouse1click
elseif type(mouse1press)=="function" and type(mouse1release)=="function" then
    FX.clickFn = function() mouse1press() task.wait() mouse1release() end
end

local Accents = {
    Fenix    = Color3.fromRGB(255, 140, 30),
    Azul     = Color3.fromRGB(60,  150, 255),
    Verde    = Color3.fromRGB(70,  220, 120),
    Roxo     = Color3.fromRGB(170, 100, 255),
    Rosa     = Color3.fromRGB(255,  90, 170),
    Vermelho = Color3.fromRGB(255,  70,  80),
    Ciano    = Color3.fromRGB(0,   210, 210),
    Ouro     = Color3.fromRGB(255, 200,  60),
}
local AccentNames = { "Fenix","Azul","Verde","Roxo","Rosa","Vermelho","Ciano","Ouro" }

local Theme = {
    bg      = Color3.fromRGB(14, 14, 17),
    side    = Color3.fromRGB(18, 18, 22),
    panel   = Color3.fromRGB(22, 22, 27),
    bar     = Color3.fromRGB(33, 33, 40),
    barHi   = Color3.fromRGB(52, 52, 62),
    stroke  = Color3.fromRGB(38, 38, 46),
    text    = Color3.fromRGB(222, 222, 228),
    sub     = Color3.fromRGB(128, 128, 140),
    accent  = Accents.Fenix,
    success = Color3.fromRGB(80,  220, 120),
    warning = Color3.fromRGB(255, 200, 60),
    danger  = Color3.fromRGB(215, 60,  70),
}

-- todas as chaves ficam aqui (assim o menu e a config guardada reconhecem tudo)
local Config = {
    Aimbot = {
        Enabled=false, EnabledBind="None",
        Mode="Hold", Key="MouseButton2",
        ShowFOV=true, FOV=120, Smooth=0.25, MaxDistance=1000,
        Part="Head", Sticky=true,
        Prediction=false, PredictionAmount=0.12,
        DeadReckoning=false,
        Backtrack=false, BacktrackFrames=8,
        SilentAim=false, SilentMoveTo=false,
        Triggerbot=false, TriggerDelay=0.08,
        TeamCheck=true, WallCheck=false,
    },
    Combat = {
        Hitbox=false, HitboxSize=8, TeamCheck=true,
        ReachEnabled=false, ReachSize=20,
        KillAura=false, KillAuraRadius=20, KillAuraDelay=0.1,
        AntiKick=false,
        GodMode=false, AntiReport=false,
        FreezePlayer=false, FreezeTarget="",
    },
    ESP = {
        Enabled=false, EnabledBind="None",
        Boxes=true, BoxStyle="Full",
        Names=true, Distance=true, Health=true, Tools=false,
        Skeleton=false, HeadDot=false, Chams=false,
        Tracers=false, TracerOrigin="Bottom",
        TeamColors=true, TeamCheck=true, MaxDistance=2000,
        Radar=false, RadarRange=150, RadarSize=140,
        SnapLine=false,
        OffScreen=false, OffScreenSize=14,
        HealthColor=false,
        MaterialChams=false, MatTransparency=0.5,
        ItemTracers=false,
    },
    Move = {
        Speed=false, SpeedBind="None", SpeedValue=30,
        Fly=false, FlyBind="None", FlySpeed=60,
        Noclip=false, NoclipBind="None",
        InfJump=false, InfJumpBind="None",
        ClickTP=false,
        Gravity=false, GravityValue=60,
        BhopEnabled=false,
        SuperJump=false, SuperJumpPower=100,
        LongJump=false,
    },
    Visual = {
        FOV=false, FOVValue=90,
        Fullbright=false, FullbrightBind="None",
        NoFog=false,
        Crosshair=false, CrossSize=8, CrossGap=4,
        ThirdPerson=false, ThirdPersonDist=8,
        Wireframe=false,
        Nightmode=false,
        Sunrise=false,
        DynamicFOV=false, DynFOVMin=65, DynFOVMax=90,
        PingGraph=false, StreamProof=false, HotkeyHUD=false,
    },
    Exploit = {
        AutoFarmEnabled=false, AutoFarmDelay=0.3, AutoFarmMode="Remote", AutoFarmKeyword="",
        SmartFarm=false, SmartFarmWindow=5,
        InfMoneyEnabled=false, InfMoneyAmount=999999, InfMoneyMode="Value",
        AutoCollect=false, AutoCollectRadius=30, AutoCollectKeyword="",
        AutoSellEnabled=false, AutoSellDelay=1.5,
        AutoQuestEnabled=false, AutoQuestDelay=2.0,
        AutoRebirthEnabled=false, AutoRebirthDelay=3.0,
        AutoClickEnabled=false, AutoClickDelay=0.05, AutoClickMode="Mouse1",
        ItemTPEnabled=false, ItemTPKeyword="",
        SpamRemoteEnabled=false, SpamRemoteDelay=0.1, SpamRemotePath="",
        RemoteSpyEnabled=false,
        StatsPatchEnabled=false,
        WebhookEnabled=false, WebhookURL="",
    },
    Misc = {
        AntiAFK=true,
        AutoRejoin=false,
        ChatSpam=false, ChatSpamMsg="Fenix Cheats", ChatSpamDelay=3,
        BringAll=false, BringAllRadius=50,
        NoAnimations=false,
        SpectatorList=false,
        ChatLogger=false,
        ItemESP=false, ItemESPKeyword="",
        PlayerListDraw=false,
    },
    Menu = {
        Key="RightShift", Accent="Fenix", Watermark=true,
        RainbowAccent=false, RainbowSpeed=2, Scale=1, ShowTips=false,
    },
}

local CONFIG_DIR  = "FenixMenu"
local CONFIG_PATH = CONFIG_DIR .. "/config_v6.json"

local function applyData(data)
    if type(data) ~= "table" then return false end
    for section, tbl in pairs(Config) do
        local saved = data[section]
        if type(saved) == "table" then
            for k, v in pairs(tbl) do
                if type(saved[k]) == type(v) then tbl[k] = saved[k] end
            end
        end
    end
    Theme.accent = Accents[Config.Menu.Accent] or Accents.Fenix
    return true
end

local function saveConfig()
    if not hasFS then return false end
    pcall(function() if makefolder then makefolder(CONFIG_DIR) end end)
    local ok = pcall(function() writefile(CONFIG_PATH, HttpService:JSONEncode(Config)) end)
    return ok
end

local function loadConfig()
    if not hasFS then return false end
    local ok, ex = pcall(isfile, CONFIG_PATH)
    if not (ok and ex) then return false end
    local ok2, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_PATH)) end)
    return ok2 and applyData(data)
end

loadConfig()

function FX.loadLogo(targets)
    task.spawn(function()
        local gca = (type(getcustomasset)=="function" and getcustomasset)
                 or (type(getsynasset)=="function" and getsynasset) or nil
        if not (hasFS and gca and reqFn) then return end
        local path = CONFIG_DIR .. "/logo_v1.png"
        pcall(function() if makefolder then makefolder(CONFIG_DIR) end end)
        local okE, exists = pcall(isfile, path)
        if not (okE and exists) then
            local okR, res = pcall(reqFn, { Url="https://i.postimg.cc/jn617K9V/image.png", Method="GET" })
            if not okR or type(res)~="table" or type(res.Body)~="string" or #res.Body<100 then return end
            if not pcall(writefile, path, res.Body) then return end
        end
        local okA, asset = pcall(gca, path)
        if not okA or not asset or asset=="" then return end
        for _, t in ipairs(targets) do
            if t.img and t.img.Parent then
                t.img.Image = asset
                if t.fallback then t.fallback.Visible = false end
            end
        end
    end)
end

local connections = {}
local function track(c) table.insert(connections, c) return c end

local function new(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end

local function corner(p, r)
    return new("UICorner", { CornerRadius=UDim.new(0, r or 4) }, p)
end

local function tween(o, t, props)
    TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local function sameTeam(plr)
    return plr.Team ~= nil and plr.Team == LocalPlayer.Team
end

local function inputName(i)
    local t = i.UserInputType
    if t == Enum.UserInputType.Keyboard     then return i.KeyCode.Name end
    if t == Enum.UserInputType.MouseButton1 then return "MouseButton1" end
    if t == Enum.UserInputType.MouseButton2 then return "MouseButton2" end
    if t == Enum.UserInputType.MouseButton3 then return "MouseButton3" end
    return nil
end

local function short(n)
    return string.sub((string.gsub(n,"MouseButton","M")),1,10)
end

local function myParts()
    local ch = LocalPlayer.Character
    return ch, ch and ch:FindFirstChild("HumanoidRootPart"), ch and ch:FindFirstChildOfClass("Humanoid")
end

local function newDrawObj(class, props)
    if not hasDrawing then return nil end
    local ok, d = pcall(Drawing.new, class)
    if not ok or not d then return nil end
    for k, v in pairs(props) do pcall(function() d[k] = v end) end
    return d
end

function FX.kwRaw(name, keyword)
    if keyword and keyword ~= "" then
        return string.find(string.lower(name), string.lower(keyword), 1, true) ~= nil
    end
    local low = string.lower(name)
    local defaults = {
        "cash","money","coin","credit","gem","gold","currency","bux","point","dollar",
        "moeda","dinheiro","gema","fichas","stars","token","crystal","diamond",
        "collect","pickup","farm","reward","loot","drop","item","ore","wood","stone",
        "sell","quest","rebirth","prestige","level","xp","exp","score",
    }
    for _, kw in ipairs(defaults) do
        if string.find(low, kw, 1, true) then return true end
    end
    return false
end

local function kwMatch(name, keyword)
    local key = name .. "|" .. (keyword or "")
    local hit = FX.kwCache[key]
    if hit ~= nil then return hit end
    if FX.kwN > 4000 then FX.kwCache = {} FX.kwN = 0 end
    local r = FX.kwRaw(name, keyword)
    FX.kwCache[key] = r
    FX.kwN = FX.kwN + 1
    return r
end

local parentGui = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    local old = parentGui:FindFirstChild("FenixMenuV6")
    if old then old:Destroy() end
end)
local gui = new("ScreenGui", {
    Name="FenixMenuV6", ResetOnSpawn=false, IgnoreGuiInset=true,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling, Enabled=true,
})
pcall(function() gui.DisplayOrder = 999 end)
if not pcall(function() gui.Parent = parentGui end) or not gui.Parent then
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end
local hlFolder = new("Folder", { Name="Chams" }, gui)

local notifyHolder = new("Frame", {
    BackgroundTransparency=1, Size=UDim2.fromOffset(280,340),
    Position=UDim2.new(1,-292,1,-348), ZIndex=200,
}, gui)
new("UIListLayout", {
    Padding=UDim.new(0,4), SortOrder=Enum.SortOrder.LayoutOrder,
    VerticalAlignment=Enum.VerticalAlignment.Bottom,
    HorizontalAlignment=Enum.HorizontalAlignment.Right,
}, notifyHolder)

local function notify(text, color, duration)
    FX.notifyCount += 1
    color    = color    or Theme.accent
    duration = duration or 3.0
    local t = new("Frame", {
        Size=UDim2.fromOffset(270,28), BackgroundColor3=Theme.panel,
        BackgroundTransparency=1, BorderSizePixel=0, LayoutOrder=FX.notifyCount, ZIndex=200,
    }, notifyHolder)
    corner(t, 3)
    local s = new("UIStroke", { Color=Theme.stroke, Thickness=1, Transparency=1 }, t)
    local bar = new("Frame", {
        Size=UDim2.new(0,2,1,-10), Position=UDim2.fromOffset(6,5),
        BackgroundColor3=color, BorderSizePixel=0, BackgroundTransparency=1, ZIndex=201,
    }, t)
    local lbl = new("TextLabel", {
        Text=tostring(text), Font=Enum.Font.SourceSans, TextSize=15, TextColor3=Theme.text,
        TextTransparency=1, BackgroundTransparency=1, TextTruncate=Enum.TextTruncate.AtEnd,
        Position=UDim2.fromOffset(16,0), Size=UDim2.new(1,-22,1,0),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=201,
    }, t)
    tween(t, 0.18, { BackgroundTransparency=0 })
    tween(s, 0.18, { Transparency=0 })
    tween(bar, 0.18, { BackgroundTransparency=0 })
    tween(lbl, 0.18, { TextTransparency=0 })
    task.delay(duration - 0.25, function()
        if not t.Parent then return end
        tween(t, 0.2, { BackgroundTransparency=1 })
        tween(s, 0.2, { Transparency=1 })
        tween(bar, 0.2, { BackgroundTransparency=1 })
        tween(lbl, 0.2, { TextTransparency=1 })
        task.wait(0.25)
        if t.Parent then t:Destroy() end
    end)
end

-- ─── ESP ────────────────────────────────────────────────────────────────────

local espObjects = {}
local radarBG     = newDrawObj("Square",{Filled=true,  Color=Color3.fromRGB(10,10,14),Transparency=0.75,Visible=false})
local radarBorder = newDrawObj("Square",{Filled=false, Thickness=1, Color=Theme.accent, Visible=false})
local radarMe     = newDrawObj("Circle",{Filled=true,  Radius=3, NumSides=16, Color=Theme.accent, Visible=false})

local function createESP(plr)
    if plr == LocalPlayer or espObjects[plr] then return end
    local d = {}
    if hasDrawing then
        d = {
            boxO   = newDrawObj("Square",{Thickness=3,Filled=false,Color=Color3.new(0,0,0),Visible=false}),
            box    = newDrawObj("Square",{Thickness=1,Filled=false,Color=Theme.accent,Visible=false}),
            name   = newDrawObj("Text",{Size=13,Center=true,Outline=true,Color=Color3.new(1,1,1),Visible=false}),
            dist   = newDrawObj("Text",{Size=12,Center=true,Outline=true,Color=Theme.sub,Visible=false}),
            tool   = newDrawObj("Text",{Size=12,Center=true,Outline=true,Color=Color3.fromRGB(255,220,120),Visible=false}),
            hpBG   = newDrawObj("Square",{Filled=true,Color=Color3.new(0,0,0),Visible=false}),
            hp     = newDrawObj("Square",{Filled=true,Color=Color3.fromRGB(80,255,120),Visible=false}),
            tracer = newDrawObj("Line",{Thickness=1,Color=Theme.accent,Visible=false}),
            snap   = newDrawObj("Line",{Thickness=1,Color=Theme.accent,Visible=false}),
            head   = newDrawObj("Circle",{Thickness=1,NumSides=24,Filled=false,Color=Theme.accent,Visible=false}),
            rdot   = newDrawObj("Circle",{Filled=true,Radius=3,NumSides=12,Color=Theme.accent,Visible=false}),
        }
    end
    local ok = hasDrawing
    if hasDrawing then
        for _, k in ipairs({"boxO","box","name","dist","tool","hpBG","hp","tracer","snap","head","rdot"}) do
            if not d[k] then ok = false end
        end
        if not ok then
            for _, v in pairs(d) do pcall(function() v:Remove() end) end
            d = {}
        end
    end
    espObjects[plr] = { d=d, s={}, c={}, hl=nil, ok=ok, hidden=false }
end

local function hideESP(o)
    if o.hidden then return end
    o.hidden = true
    for _, d in pairs(o.d) do d.Visible = false end
    for _, l in ipairs(o.s) do l.Visible = false end
    for _, l in ipairs(o.c) do l.Visible = false end
    if o.hl then o.hl.Enabled = false end
end

local function removeESP(plr)
    local o = espObjects[plr]
    if not o then return end
    for _, d in pairs(o.d) do pcall(function() d:Remove() end) end
    for _, l in ipairs(o.s) do pcall(function() l:Remove() end) end
    for _, l in ipairs(o.c) do pcall(function() l:Remove() end) end
    if o.hl then pcall(function() o.hl:Destroy() end) end
    espObjects[plr] = nil
end

local skelR15 = {
    {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
    {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
    {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
    {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
    {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
}
local skelR6 = {
    {"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},
    {"Torso","Left Leg"},{"Torso","Right Leg"},
}

local function updateSkeleton(o, char, color)
    local rig = char:FindFirstChild("UpperTorso") and skelR15 or skelR6
    while #o.s < #rig do
        local l = newDrawObj("Line",{Thickness=1,Color=color,Visible=false})
        if l then table.insert(o.s,l) else break end
    end
    for i, pair in ipairs(rig) do
        local line = o.s[i]
        if not line then break end
        local a,b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
        if a and b then
            local pa,oa = Camera:WorldToViewportPoint(a.Position)
            local pb,ob = Camera:WorldToViewportPoint(b.Position)
            if oa and ob then
                line.From = Vector2.new(pa.X,pa.Y)
                line.To   = Vector2.new(pb.X,pb.Y)
                line.Color = color
                line.Visible = true
            else line.Visible = false end
        else line.Visible = false end
    end
    for i = #rig+1, #o.s do o.s[i].Visible = false end
end

local function drawCorners(o, x, y, w, h, color)
    while #o.c < 8 do
        local l = newDrawObj("Line",{Thickness=1,Color=color,Visible=false})
        if l then table.insert(o.c,l) else break end
    end
    local lw, lh = w/4, h/4
    local segs = {
        {x,y,x+lw,y},{x,y,x,y+lh},
        {x+w,y,x+w-lw,y},{x+w,y,x+w,y+lh},
        {x,y+h,x+lw,y+h},{x,y+h,x,y+h-lh},
        {x+w,y+h,x+w-lw,y+h},{x+w,y+h,x+w,y+h-lh},
    }
    for i, seg in ipairs(segs) do
        local l = o.c[i]
        if not l then break end
        l.From  = Vector2.new(seg[1],seg[2])
        l.To    = Vector2.new(seg[3],seg[4])
        l.Color = color
        l.Visible = true
    end
end

local function updateOneESP(plr, o, c, vp, camPos, mouse, radarCF, center)
    local char = plr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not (c.Enabled and root and hum and hum.Health>0) or (c.TeamCheck and sameTeam(plr)) then
        hideESP(o) return
    end
    local dist = (camPos - root.Position).Magnitude
    if dist > c.MaxDistance then hideESP(o) return end
    o.hidden = false
    local ratio = math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
    local color
    if c.HealthColor then
        color = FX.healthCol(ratio)
    else
        color = (c.TeamColors and plr.Team) and plr.TeamColor.Color or Theme.accent
    end

    if c.Chams and not c.MaterialChams then
        if not o.hl then
            o.hl = new("Highlight",{
                FillTransparency=0.55, OutlineTransparency=0,
                DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,
            }, hlFolder)
        end
        o.hl.Adornee = char
        o.hl.FillColor = color
        o.hl.OutlineColor = color
        o.hl.Enabled = true
    elseif o.hl then
        o.hl.Enabled = false
    end

    if not hasDrawing or not o.ok then return end
    local d = o.d

    -- radar (fica visivel mesmo com o jogador fora do ecra)
    if c.Radar then
        local rel  = radarCF:PointToObjectSpace(root.Position)
        local half = c.RadarSize/2
        local sc   = half/math.max(c.RadarRange,1)
        local rx   = math.clamp(rel.X*sc,-half+3,half-3)
        local ry   = math.clamp(rel.Z*sc,-half+3,half-3)
        d.rdot.Position = center + Vector2.new(rx,ry)
        d.rdot.Color    = color
        d.rdot.Visible  = true
    else d.rdot.Visible = false end

    local pos,on = Camera:WorldToViewportPoint(root.Position)
    if not on then
        for k, dr in pairs(d) do if k ~= "rdot" then dr.Visible = false end end
        for _, l in ipairs(o.s) do l.Visible = false end
        for _, l in ipairs(o.c) do l.Visible = false end
        if o.hl and not c.Chams then o.hl.Enabled = false end
        return
    end

    local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,2.7,0))
    local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3.1,0))
    local h   = math.abs(bot.Y - top.Y)
    local w   = h/1.8
    local x,y = pos.X - w/2, top.Y

    local full = c.Boxes and c.BoxStyle=="Full"
    d.boxO.Visible = full
    d.box.Visible  = full
    if full then
        d.boxO.Position=Vector2.new(x,y) d.boxO.Size=Vector2.new(w,h)
        d.box.Position =Vector2.new(x,y) d.box.Size =Vector2.new(w,h)
        d.box.Color=color
    end
    if c.Boxes and c.BoxStyle=="Corner" then
        drawCorners(o,x,y,w,h,color)
    else
        for _, l in ipairs(o.c) do l.Visible=false end
    end

    d.name.Visible=c.Names
    if c.Names then d.name.Text=plr.DisplayName d.name.Position=Vector2.new(pos.X,y-16) end

    local below = y+h+2
    d.dist.Visible=c.Distance
    if c.Distance then d.dist.Text=string.format("%dm",math.floor(dist)) d.dist.Position=Vector2.new(pos.X,below) below+=13 end

    local toolInst = c.Tools and char:FindFirstChildOfClass("Tool") or nil
    d.tool.Visible = toolInst~=nil
    if toolInst then d.tool.Text=toolInst.Name d.tool.Position=Vector2.new(pos.X,below) end

    d.hpBG.Visible=c.Health d.hp.Visible=c.Health
    if c.Health then
        d.hpBG.Position=Vector2.new(x-6,y)              d.hpBG.Size=Vector2.new(4,h)
        d.hp.Position  =Vector2.new(x-6,y+h*(1-ratio))  d.hp.Size  =Vector2.new(4,h*ratio)
        d.hp.Color=Color3.fromRGB(255,70,70):Lerp(Color3.fromRGB(80,255,120),ratio)
    end

    d.tracer.Visible=c.Tracers
    if c.Tracers then
        local origin=Vector2.new(vp.X/2,vp.Y)
        if c.TracerOrigin=="Centro" then origin=Vector2.new(vp.X/2,vp.Y/2)
        elseif c.TracerOrigin=="Rato" then origin=mouse end
        d.tracer.From=origin d.tracer.To=Vector2.new(pos.X,y+h) d.tracer.Color=color
    end
    d.snap.Visible=c.SnapLine
    if c.SnapLine then d.snap.From=Vector2.new(vp.X/2,vp.Y) d.snap.To=Vector2.new(pos.X,y+h) d.snap.Color=Color3.fromRGB(255,255,80) end

    local head2 = c.HeadDot and char:FindFirstChild("Head") or nil
    d.head.Visible=false
    if head2 then
        local hp2,hon=Camera:WorldToViewportPoint(head2.Position)
        if hon then d.head.Position=Vector2.new(hp2.X,hp2.Y) d.head.Radius=math.max(h*0.07,2) d.head.Color=color d.head.Visible=true end
    end
    if c.Skeleton then updateSkeleton(o,char,color)
    else for _, l in ipairs(o.s) do l.Visible=false end end
end

local function updateESP()
    local c = Config.ESP
    if not c.Enabled then
        if FX.espOn then
            FX.espOn = false
            if radarBG then radarBG.Visible=false radarBorder.Visible=false radarMe.Visible=false end
            for _, o in pairs(espObjects) do hideESP(o) end
        end
        return
    end
    FX.espOn = true
    local vp    = Camera.ViewportSize
    local camCF = Camera.CFrame
    local camPos= camCF.Position
    local mouse = UIS:GetMouseLocation()
    local look  = camCF.LookVector
    local flat  = Vector3.new(look.X,0,look.Z)
    local radarCF = flat.Magnitude>0.01 and CFrame.lookAt(camPos,camPos+flat) or camCF
    local half  = c.RadarSize/2
    local center= Vector2.new(vp.X-24-half,80+half)

    if radarBG then
        local show = c.Radar
        radarBG.Visible=show radarBorder.Visible=show radarMe.Visible=show
        if show then
            local sz=Vector2.new(c.RadarSize,c.RadarSize)
            radarBG.Size=sz     radarBG.Position    =center-Vector2.new(half,half)
            radarBorder.Size=sz radarBorder.Position=center-Vector2.new(half,half)
            radarBorder.Color=Theme.accent radarMe.Position=center radarMe.Color=Theme.accent
        end
    end
    for plr, o in pairs(espObjects) do
        pcall(updateOneESP,plr,o,c,vp,camPos,mouse,radarCF,center)
    end
end

-- ─── AIMBOT ─────────────────────────────────────────────────────────────────

local lockedPlr = nil
local silentPart= nil

local fovCircle = newDrawObj("Circle",{Thickness=1,NumSides=64,Filled=false,Color=Theme.accent,Visible=false})

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
local trigParams = RaycastParams.new()
trigParams.FilterType = Enum.RaycastFilterType.Exclude

local partSets = {
    Head    = {"Head"},
    Torso   = {"UpperTorso","Torso"},
    Root    = {"HumanoidRootPart"},
    Closest = {"Head","UpperTorso","Torso","LowerTorso","HumanoidRootPart"},
}

local function buildFilter()
    local list={}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then table.insert(list,p.Character) end
    end
    return list
end

local function isVisible(part, camPos)
    return Workspace:Raycast(camPos,part.Position-camPos,rayParams)==nil
end

local function aimPoint(part, c, plr)
    if c.DeadReckoning then return FX.aimPointDR(part, plr, c) end
    if c.Prediction then return part.Position + part.AssemblyLinearVelocity*c.PredictionAmount end
    return part.Position
end

local function validChar(plr, c)
    if plr==LocalPlayer then return nil end
    if c.TeamCheck and sameTeam(plr) then return nil end
    local char=plr.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health<=0 then return nil end
    return char
end

local function pickPart(char, c, mouse, camPos, plr)
    local best,bestD=nil,math.huge
    for _, n in ipairs(partSets[c.Part] or partSets.Head) do
        local p=char:FindFirstChild(n)
        if p and p:IsA("BasePart") and (camPos-p.Position).Magnitude<=c.MaxDistance then
            local sp,on=Camera:WorldToViewportPoint(aimPoint(p, c, plr))
            if on then
                local d=(Vector2.new(sp.X,sp.Y)-mouse).Magnitude
                if d<bestD and (not c.WallCheck or isVisible(p,camPos)) then
                    best,bestD=p,d
                end
            end
        end
    end
    return best,bestD
end

local function getBest(c, mouse, camPos)
    local bestPlr,bestPart,bestD=nil,nil,c.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        local char=validChar(plr,c)
        if char then
            local part,d=pickPart(char,c,mouse,camPos,plr)
            if part and d<bestD then bestPlr,bestPart,bestD=plr,part,d end
        end
    end
    return bestPlr,bestPart
end

local function resolveTarget(c, mouse, camPos)
    if c.Sticky and lockedPlr then
        local char=validChar(lockedPlr,c)
        if char then
            local part=pickPart(char,c,mouse,camPos,lockedPlr)
            if part then return part,lockedPlr end
        end
        lockedPlr=nil
    end
    local plr,part=getBest(c,mouse,camPos)
    lockedPlr=c.Sticky and plr or nil
    return part,plr
end

local silentHooked=false
local function ensureSilentHook()
    if silentHooked or not hasHook then return end
    silentHooked=true
    pcall(function()
        local oldIndex
        oldIndex=hookmetamethod(game,"__index",newcclosure(function(self,key)
            if alive and silentPart and not checkcaller() and self==Mouse then
                if key=="Hit"    then return CFrame.new(silentPart.Position) end
                if key=="Target" then return silentPart end
            end
            return oldIndex(self,key)
        end))
    end)
end

local function updateAimbot(dt)
    local c=Config.Aimbot
    if not c.Enabled then
        if FX.aimOn then
            FX.aimOn=false
            if fovCircle then fovCircle.Visible=false end
        end
        silentPart=nil lockedPlr=nil
        return
    end
    FX.aimOn=true
    local mouse=UIS:GetMouseLocation()
    if fovCircle then
        fovCircle.Visible=c.ShowFOV and not menuOpen
        fovCircle.Radius=c.FOV
        fovCircle.Position=mouse
        fovCircle.Color=lockedPlr and Color3.fromRGB(80,255,120) or Theme.accent
    end
    silentPart=nil
    if menuOpen then aiming=false lockedPlr=nil return end
    local camPos=Camera.CFrame.Position
    if c.WallCheck then rayParams.FilterDescendantsInstances=buildFilter() end

    if c.SilentAim then
        ensureSilentHook()
        local _,p=getBest(c,mouse,camPos)
        silentPart=p
    end

    if c.Mode=="Always" or aiming then
        local part,owner
        if c.Backtrack then
            local plr,rawPart=getBest(c,mouse,camPos)
            local btPos=plr and FX.getBTPos(plr)
            if btPos then
                local s=math.clamp(c.Smooth,0.01,1)
                local alpha=1-(1-s)^(math.min(dt,0.1)*60)
                Camera.CFrame=Camera.CFrame:Lerp(CFrame.lookAt(camPos,btPos),alpha)
                return
            end
            part,owner=rawPart,plr
        else
            part,owner=resolveTarget(c,mouse,camPos)
        end
        if part then
            local goal =CFrame.lookAt(camPos,aimPoint(part,c,owner))
            local s    =math.clamp(c.Smooth,0.01,1)
            local alpha=1-(1-s)^(math.min(dt,0.1)*60)
            Camera.CFrame=Camera.CFrame:Lerp(goal,alpha)
        end
    else
        lockedPlr=nil
    end
end

-- triggerbot: raio a partir do cursor, respeita paredes
local function updateTrigger()
    local c=Config.Aimbot
    if not c.Triggerbot or menuOpen then return end
    local fire=FX.clickFn
    if not fire then return end
    local ch=LocalPlayer.Character
    if not ch then return end
    trigParams.FilterDescendantsInstances={ch}
    local m=UIS:GetMouseLocation()
    local ray=Camera:ViewportPointToRay(m.X,m.Y)
    local hit=Workspace:Raycast(ray.Origin,ray.Direction*c.MaxDistance,trigParams)
    if not hit then return end
    local model=hit.Instance:FindFirstAncestorOfClass("Model")
    local plr=model and Players:GetPlayerFromCharacter(model)
    if not plr or not validChar(plr,c) then return end
    if os.clock()-FX.lastShot<c.TriggerDelay then return end
    FX.lastShot=os.clock()
    task.spawn(pcall,fire)
end

-- ─── COMBAT ─────────────────────────────────────────────────────────────────

local killAuraConn = nil
local function startKillAura()
    if killAuraConn then killAuraConn:Disconnect() killAuraConn=nil end
    local c=Config.Combat
    if not c.KillAura then return end
    local lastHit=0
    killAuraConn=RunService.Heartbeat:Connect(function()
        if not c.KillAura then return end
        local nowT=os.clock()
        if nowT-lastHit<math.max(c.KillAuraDelay,0.03) then return end
        lastHit=nowT
        local _, root=myParts()
        if not root then return end
        local pos=root.Position
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer and not (c.TeamCheck and sameTeam(plr)) then
                local ch=plr.Character
                local er=ch and ch:FindFirstChild("HumanoidRootPart")
                local eh=ch and ch:FindFirstChildOfClass("Humanoid")
                if er and eh and eh.Health>0 then
                    if (pos-er.Position).Magnitude<=c.KillAuraRadius then
                        local tool=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        if tool then
                            local activated=tool:FindFirstChildOfClass("RemoteEvent")
                            if activated then pcall(function() cloneref(activated):FireServer() end) end
                            pcall(function()
                                for _, rr in ipairs(FX.allRemotes()) do
                                    if rr:IsA("RemoteEvent") and rr:IsDescendantOf(ReplicatedStorage) then
                                        local nm=string.lower(rr.Name)
                                        if nm:find("damage") or nm:find("attack") or nm:find("hit") then
                                            cloneref(rr):FireServer(er,1)
                                        end
                                    end
                                end
                            end)
                        end
                        pcall(function() eh:TakeDamage(math.huge) end)
                    end
                end
            end
        end
    end)
end

local hbOriginal = setmetatable({},{ __mode="k" })

local function restoreHitbox(part)
    local o=hbOriginal[part]
    if o and part.Parent then
        pcall(function() part.Size=o[1] part.Transparency=o[2] part.CanCollide=o[3] end)
    end
    hbOriginal[part]=nil
end

local function restoreHitboxes()
    for part in pairs(hbOriginal) do restoreHitbox(part) end
end

local function updateHitbox()
    local c=Config.Combat
    if not c.Hitbox then
        if next(hbOriginal) then restoreHitboxes() end
        return
    end
    local s=Vector3.new(c.HitboxSize,c.HitboxSize,c.HitboxSize)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr~=LocalPlayer then
            local char=plr.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health>0 and not (c.TeamCheck and sameTeam(plr)) then
                if not hbOriginal[root] then
                    hbOriginal[root]={ root.Size, root.Transparency, root.CanCollide }
                end
                root.Size=s root.Transparency=0.7 root.CanCollide=false
            elseif root and hbOriginal[root] then
                restoreHitbox(root)
            end
        end
    end
end

-- ─── MOVE ───────────────────────────────────────────────────────────────────

local flyActive,gravApplied=false,false
local origGravity=Workspace.Gravity

local clickParams=RaycastParams.new()
clickParams.FilterType=Enum.RaycastFilterType.Exclude

local function updateMove(dt)
    local m=Config.Move

    if m.Gravity then
        gravApplied=true Workspace.Gravity=m.GravityValue
    elseif gravApplied then
        gravApplied=false Workspace.Gravity=origGravity
    end

    local _,root,hum=myParts()
    if not (root and hum) then flyActive=false return end

    if m.Fly then
        if not flyActive then flyActive=true hum.PlatformStand=true end
        local cf=Camera.CFrame
        local dir=Vector3.zero
        local typing=UIS:GetFocusedTextBox()~=nil
        if not typing and not menuOpen then
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=cf.LookVector  end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=cf.LookVector  end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space)     then dir+=Vector3.yAxis end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                dir-=Vector3.yAxis
            end
        end
        if dir.Magnitude>0 then dir=dir.Unit end
        root.AssemblyLinearVelocity =dir*m.FlySpeed
        root.AssemblyAngularVelocity=Vector3.zero
        local flat=Vector3.new(cf.LookVector.X,0,cf.LookVector.Z)
        if flat.Magnitude>0.01 then
            root.CFrame=CFrame.lookAt(root.Position,root.Position+flat)
        end
    elseif flyActive then
        flyActive=false hum.PlatformStand=false
        root.AssemblyLinearVelocity=Vector3.zero
    end

    if m.Speed and not m.Fly then
        local md=hum.MoveDirection
        if md.Magnitude>0 then root.CFrame=root.CFrame+md*(m.SpeedValue*dt) end
    end

    if m.BhopEnabled then
        if hum:GetState()==Enum.HumanoidStateType.Landed then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    if m.SuperJump then
        FX.sj=true hum.UseJumpPower=true hum.JumpPower=m.SuperJumpPower
    elseif FX.sj then
        FX.sj=false hum.JumpPower=50
    end

    if m.LongJump and UIS:IsKeyDown(Enum.KeyCode.Space) and not menuOpen then
        local fd=Vector3.new(Camera.CFrame.LookVector.X,0,Camera.CFrame.LookVector.Z)
        if fd.Magnitude>0 then
            root.AssemblyLinearVelocity=root.AssemblyLinearVelocity+fd.Unit*40
        end
    end
end

track(RunService.Stepped:Connect(function()
    if not Config.Move.Noclip then return end
    local ch=LocalPlayer.Character
    if not ch then return end
    for _, p in ipairs(ch:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false end
    end
end))

track(UIS.JumpRequest:Connect(function()
    if not Config.Move.InfJump then return end
    local _,_,hum=myParts()
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

track(LocalPlayer.Idled:Connect(function()
    if not Config.Misc.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end))

local function clickTeleport()
    local _, root=myParts()
    if not root then return end
    local m=UIS:GetMouseLocation()
    local ray=Camera:ViewportPointToRay(m.X,m.Y)
    clickParams.FilterDescendantsInstances={ LocalPlayer.Character }
    local hit=Workspace:Raycast(ray.Origin,ray.Direction*5000,clickParams)
    if hit then root.CFrame=CFrame.new(hit.Position+Vector3.new(0,4,0)) end
end

-- ─── VISUAL ─────────────────────────────────────────────────────────────────

local lightOrig={
    Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime,
    GlobalShadows=Lighting.GlobalShadows, Ambient=Lighting.Ambient,
    OutdoorAmbient=Lighting.OutdoorAmbient,
}
local fogOrig   =Lighting.FogEnd
local atmOrig   =nil
local fbApplied =false
local fogApplied=false
local fovOrig   =nil
local tpActive  =false
local crossLines={}
do
    for i=1,4 do
        local l=newDrawObj("Line",{Thickness=1,Color=Theme.accent,Visible=false})
        if l then crossLines[i]=l end
    end
end

local function restoreFullbright()
    for k,v in pairs(lightOrig) do pcall(function() Lighting[k]=v end) end
    fbApplied=false
end

local function restoreFog()
    Lighting.FogEnd=fogOrig
    local atm=Lighting:FindFirstChildOfClass("Atmosphere")
    if atm and atmOrig then atm.Density=atmOrig end
    fogApplied=false
end

local wireConns={}
local function applyWireframe(on)
    for _,c in ipairs(wireConns) do pcall(function() c:Disconnect() end) end
    wireConns={}
    for part, o in pairs(FX.wireOrig) do
        if part.Parent then pcall(function() part.Material=o[1] part.Transparency=o[2] end) end
        FX.wireOrig[part]=nil
    end
    if not on then return end
    local function wireChar(ch)
        if not ch then return end
        for _, p in ipairs(ch:GetDescendants()) do
            if p:IsA("BasePart") then
                if not FX.wireOrig[p] then FX.wireOrig[p]={ p.Material, p.Transparency } end
                p.Material=Enum.Material.Neon p.Transparency=0.9
            end
        end
    end
    wireChar(LocalPlayer.Character)
    table.insert(wireConns,LocalPlayer.CharacterAdded:Connect(wireChar))
end

local function updateVisual()
    local v=Config.Visual
    if not (v.Fullbright or v.NoFog or v.Nightmode or v.Sunrise or v.FOV or v.ThirdPerson or v.Crosshair
            or fbApplied or fogApplied or FX.ltApplied or fovOrig or tpActive or FX.crossOn) then
        return
    end

    if v.Fullbright then
        fbApplied=true
        Lighting.Brightness=2 Lighting.ClockTime=14
        Lighting.GlobalShadows=false
        Lighting.Ambient=Color3.fromRGB(180,180,180)
        Lighting.OutdoorAmbient=Color3.fromRGB(180,180,180)
    elseif fbApplied then restoreFullbright() end

    if v.NoFog then
        fogApplied=true Lighting.FogEnd=1e6
        local atm=Lighting:FindFirstChildOfClass("Atmosphere")
        if atm then if not atmOrig then atmOrig=atm.Density end atm.Density=0 end
    elseif fogApplied then restoreFog() end

    if v.Nightmode then
        FX.ltApplied=true
        Lighting.Brightness=0 Lighting.ClockTime=0 Lighting.Ambient=Color3.fromRGB(10,10,30)
    elseif v.Sunrise then
        FX.ltApplied=true
        Lighting.ClockTime=6 Lighting.Brightness=1.2
    elseif FX.ltApplied then
        FX.ltApplied=false
        if not v.Fullbright then restoreFullbright() end
    end

    if v.DynamicFOV then
        -- tratado em FX.updateDynFOV
    elseif v.FOV then
        if not fovOrig then fovOrig=Camera.FieldOfView end
        Camera.FieldOfView=v.FOVValue
    elseif fovOrig then
        Camera.FieldOfView=fovOrig fovOrig=nil
    end

    if v.ThirdPerson then
        if not tpActive then
            FX.tpOrig={ LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance }
        end
        tpActive=true
        local d=v.ThirdPersonDist
        if LocalPlayer.CameraMinZoomDistance~=d or LocalPlayer.CameraMaxZoomDistance~=d then
            LocalPlayer.CameraMode=Enum.CameraMode.Classic
            LocalPlayer.CameraMinZoomDistance=0.5
            LocalPlayer.CameraMaxZoomDistance=d
            LocalPlayer.CameraMinZoomDistance=d
        end
    elseif tpActive then
        tpActive=false
        if FX.tpOrig then
            LocalPlayer.CameraMinZoomDistance=FX.tpOrig[1]
            LocalPlayer.CameraMaxZoomDistance=FX.tpOrig[2]
        end
    end

    local show=hasDrawing and v.Crosshair
    FX.crossOn = show and true or false
    if hasDrawing then
        local vp=Camera.ViewportSize
        local cx,cy=vp.X/2,vp.Y/2
        local g,s2=v.CrossGap,v.CrossSize
        local pts={
            {cx-g-s2,cy,cx-g,cy},{cx+g,cy,cx+g+s2,cy},
            {cx,cy-g-s2,cx,cy-g},{cx,cy+g,cx,cy+g+s2},
        }
        for i,l in ipairs(crossLines) do
            l.Visible=show
            if show then
                local p=pts[i]
                l.From=Vector2.new(p[1],p[2]) l.To=Vector2.new(p[3],p[4]) l.Color=Theme.accent
            end
        end
    end
end

-- ─── EXPLOIT (modulo isolado) ───────────────────────────────────────────────
do
    local farmConn, infMoneyConn, autoClickConn
    local sellTh, questTh, rebirthTh, spamTh
    local spyHooked = false
    local acBusy = false
    local spyLog = {}
    FX.spyLog = spyLog

    local function fireRemote(r, ...)
        pcall(function(...)
            if r:IsA("RemoteEvent") then cloneref(r):FireServer(...)
            elseif r:IsA("RemoteFunction") then cloneref(r):InvokeServer(...) end
        end, ...)
    end

    function FX.scanRemotes(keyword)
        local found={}
        for _, obj in ipairs(FX.allRemotes()) do
            local par=obj.Parent
            if par and (kwMatch(obj.Name, keyword) or kwMatch(par.Name, keyword)) then
                table.insert(found,obj)
            end
        end
        return found
    end

    function FX.scanValues(keyword)
        local found={}
        for _, v in ipairs(LocalPlayer:GetDescendants()) do
            if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("IntConstrainedValue") then
                if kwMatch(v.Name, keyword) then table.insert(found,v) end
            end
        end
        local ls=LocalPlayer:FindFirstChild("leaderstats")
        if ls then
            for _, v in ipairs(ls:GetChildren()) do
                if (v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("IntConstrainedValue")) and not table.find(found, v) then
                    table.insert(found,v)
                end
            end
        end
        return found
    end

    function FX.startRemoteSpy()
        if spyHooked or not hasHook then return end
        spyHooked=true
        pcall(function()
            local oldNC
            oldNC=hookmetamethod(game,"__namecall",newcclosure(function(self,...)
                if alive and Config.Exploit.RemoteSpyEnabled and not checkcaller() then
                    local method=getnamecallmethod and getnamecallmethod() or ""
                    if method=="FireServer" or method=="InvokeServer" then
                        local ok,isR=pcall(function() return self:IsA("RemoteEvent") or self:IsA("RemoteFunction") end)
                        if ok and isR then
                            table.insert(spyLog,1,{ time=os.clock(), remote=self:GetFullName(), method=method, args={...} })
                            if #spyLog>200 then table.remove(spyLog) end
                        end
                    end
                end
                return oldNC(self,...)
            end))
        end)
    end

    function FX.startAutoFarm()
        if farmConn then farmConn:Disconnect() farmConn=nil end
        local c=Config.Exploit
        if not c.AutoFarmEnabled then return end
        local delay=math.max(c.AutoFarmDelay,0.05)
        local last=0
        farmConn=RunService.Heartbeat:Connect(function()
            if not c.AutoFarmEnabled then return end
            local now=os.clock()
            if now-last < delay then return end
            last=now
            local kw=c.AutoFarmKeyword~="" and c.AutoFarmKeyword or nil
            if c.AutoFarmMode=="Remote" or c.AutoFarmMode=="Both" then
                for _, r in ipairs(FX.scanRemotes(kw)) do fireRemote(r) end
            end
            if c.AutoFarmMode=="Touch" or c.AutoFarmMode=="Both" then
                local _,root=myParts()
                if root then
                    local n=0
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and kwMatch(obj.Name, kw) then
                            pcall(function()
                                if (root.Position-obj.Position).Magnitude<600 then
                                    root.CFrame=CFrame.new(obj.Position)
                                    n+=1
                                end
                            end)
                            if n>=3 then break end
                        end
                    end
                end
            end
        end)
    end

    function FX.startInfMoney()
        if infMoneyConn then infMoneyConn:Disconnect() infMoneyConn=nil end
        local c=Config.Exploit
        if not c.InfMoneyEnabled then return end
        local lastT=0
        infMoneyConn=RunService.Heartbeat:Connect(function()
            if not c.InfMoneyEnabled then return end
            local nowT=os.clock()
            if nowT-lastT<0.25 then return end
            lastT=nowT
            if c.InfMoneyMode=="Value" or c.InfMoneyMode=="Both" then
                for _, v in ipairs(FX.scanValues(nil)) do
                    pcall(function() if v.Value<c.InfMoneyAmount then v.Value=c.InfMoneyAmount end end)
                end
            end
            if c.InfMoneyMode=="Remote" or c.InfMoneyMode=="Both" then
                for _, r in ipairs(FX.scanRemotes(nil)) do
                    local nm=string.lower(r.Name)
                    if nm:find("give") or nm:find("add") or nm:find("earn") then
                        if r:IsA("RemoteEvent") then fireRemote(r, c.InfMoneyAmount) end
                    end
                end
            end
        end)
    end

    function FX.doAutoCollect()
        if acBusy then return end
        acBusy=true
        task.spawn(function()
            pcall(function()
                local c=Config.Exploit
                local _,root=myParts()
                if not root then return end
                local pos=root.Position
                local kw=c.AutoCollectKeyword~="" and c.AutoCollectKeyword or nil
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and kwMatch(obj.Name, kw) then
                        local opos=obj.Position
                        if (pos-opos).Magnitude<=c.AutoCollectRadius then
                            local rem=obj.Parent and obj.Parent:FindFirstChildOfClass("RemoteEvent")
                            if rem then pcall(function() cloneref(rem):FireServer() end) end
                            root.CFrame=CFrame.new(opos)
                            task.wait(0.05)
                        end
                    end
                end
            end)
            acBusy=false
        end)
    end

    local function loopByName(flag, delayKey, minDelay, names, label)
        return task.spawn(function()
            local c=Config.Exploit
            while c[flag] and alive do
                local n=0
                for _, obj in ipairs(FX.allRemotes()) do
                    local nm=string.lower(obj.Name)
                    for _, k in ipairs(names) do
                        if nm:find(k) then fireRemote(obj) n+=1 break end
                    end
                end
                if label and n>0 then notify(label..": "..n.." remote(s) disparados.", Theme.success, 2) end
                task.wait(math.max(c[delayKey],minDelay))
            end
        end)
    end

    function FX.startAutoSell()
        if sellTh then pcall(task.cancel, sellTh) sellTh=nil end
        if not Config.Exploit.AutoSellEnabled then return end
        sellTh=loopByName("AutoSellEnabled","AutoSellDelay",0.5,{"sell"},"Auto Sell")
    end
    function FX.startAutoQuest()
        if questTh then pcall(task.cancel, questTh) questTh=nil end
        if not Config.Exploit.AutoQuestEnabled then return end
        questTh=loopByName("AutoQuestEnabled","AutoQuestDelay",0.5,{"quest","task","mission","objective"})
    end
    function FX.startAutoRebirth()
        if rebirthTh then pcall(task.cancel, rebirthTh) rebirthTh=nil end
        if not Config.Exploit.AutoRebirthEnabled then return end
        rebirthTh=loopByName("AutoRebirthEnabled","AutoRebirthDelay",1,{"rebirth","prestige","ascend","reset"})
    end

    function FX.startAutoClick()
        if autoClickConn then autoClickConn:Disconnect() autoClickConn=nil end
        local c=Config.Exploit
        if not c.AutoClickEnabled then return end
        local lastC=0
        autoClickConn=RunService.Heartbeat:Connect(function()
            if not c.AutoClickEnabled then return end
            local nowT=os.clock()
            if nowT-lastC<c.AutoClickDelay then return end
            lastC=nowT
            if c.AutoClickMode=="Mouse1" then
                if FX.clickFn and not menuOpen then task.spawn(pcall,FX.clickFn) end
            else
                for _, r in ipairs(FX.scanRemotes("click")) do
                    if r:IsA("RemoteEvent") then fireRemote(r) end
                end
            end
        end)
    end

    function FX.doItemTeleport()
        local c=Config.Exploit
        local _,root=myParts()
        if not root then notify("Personagem nao encontrada.") return end
        local keyword=c.ItemTPKeyword
        if keyword=="" then notify("Define a keyword do item primeiro.") return end
        local count=0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if (obj:IsA("BasePart") or obj:IsA("Model") or obj:IsA("Tool")) and kwMatch(obj.Name, keyword) then
                local pos
                if obj:IsA("BasePart") then pos=obj.Position
                elseif obj:IsA("Model") and obj.PrimaryPart then pos=obj.PrimaryPart.Position
                elseif obj:IsA("Tool") and obj:FindFirstChild("Handle") then pos=obj.Handle.Position end
                if pos then
                    root.CFrame=CFrame.new(pos+Vector3.new(0,3,0))
                    task.wait(0.1) count+=1
                    if count>=5 then break end
                end
            end
        end
        notify(count>0 and "Teleportado para "..count.." item(ns)." or "Item nao encontrado.", count>0 and Theme.success or Theme.warning)
    end

    function FX.startSpamRemote()
        if spamTh then pcall(task.cancel, spamTh) spamTh=nil end
        local c=Config.Exploit
        if not c.SpamRemoteEnabled or c.SpamRemotePath=="" then return end
        spamTh=task.spawn(function()
            while c.SpamRemoteEnabled and alive do
                local remote=game:FindFirstChild(c.SpamRemotePath, true)
                if remote and remote:IsA("RemoteEvent") then fireRemote(remote) end
                task.wait(math.max(c.SpamRemoteDelay, 0.05))
            end
        end)
    end

    function FX.patchStats()
        local ls=LocalPlayer:FindFirstChild("leaderstats")
        if not ls then notify("Sem leaderstats.") return end
        local patched=0
        for _, v in ipairs(ls:GetChildren()) do
            if v:IsA("IntValue") or v:IsA("NumberValue") or v:IsA("IntConstrainedValue") then
                pcall(function() v.Value=Config.Exploit.InfMoneyAmount end)
                patched+=1
            end
        end
        notify(patched>0 and "Stats patchados: "..patched.." valor(es)." or "Nenhum stat encontrado.", patched>0 and Theme.success or Theme.warning)
    end

    function FX.getServerInfo()
        local info={ placeId=tostring(game.PlaceId), jobId=game.JobId, players=#Players:GetPlayers(), ping=0 }
        pcall(function() info.ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        return info
    end

    function FX.stopExploit()
        for _, c in ipairs({farmConn, infMoneyConn, autoClickConn}) do pcall(function() c:Disconnect() end) end
        farmConn, infMoneyConn, autoClickConn = nil, nil, nil
        for _, t in ipairs({sellTh, questTh, rebirthTh, spamTh}) do pcall(task.cancel, t) end
        sellTh, questTh, rebirthTh, spamTh = nil, nil, nil, nil
    end
end

-- ─── MISC (modulo isolado) ──────────────────────────────────────────────────
do
    local chatSpamTh=nil
    local chatLogConns={}
    local chatLog={}
    FX.chatLog=chatLog
    local itemESPObjs={}
    local specLabel=hasDrawing and newDrawObj("Text",{Size=13,Color=Theme.text,Outline=true,Visible=false}) or nil

    function FX.startChatSpam()
        if chatSpamTh then pcall(task.cancel, chatSpamTh) chatSpamTh=nil end
        if not Config.Misc.ChatSpam then return end
        chatSpamTh=task.spawn(function()
            while Config.Misc.ChatSpam and alive do
                pcall(function()
                    Chat:Chat(LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head"),Config.Misc.ChatSpamMsg)
                end)
                task.wait(math.max(Config.Misc.ChatSpamDelay,1))
            end
        end)
    end

    function FX.startChatLogger()
        for _, c in ipairs(chatLogConns) do pcall(function() c:Disconnect() end) end
        chatLogConns={}
        if not Config.Misc.ChatLogger then return end
        local function hook(plr)
            table.insert(chatLogConns, plr.Chatted:Connect(function(msg)
                if not Config.Misc.ChatLogger then return end
                table.insert(chatLog,1,{ plr=plr.Name, msg=msg, t=os.clock() })
                if #chatLog>100 then table.remove(chatLog) end
            end))
        end
        for _, plr in ipairs(Players:GetPlayers()) do hook(plr) end
        table.insert(chatLogConns, Players.PlayerAdded:Connect(hook))
    end

    function FX.bringAllPlayers()
        local _,root=myParts()
        if not root then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr~=LocalPlayer then
                local proot=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if proot and (root.Position-proot.Position).Magnitude>2 then
                    pcall(function()
                        proot.CFrame=CFrame.new(root.Position+Vector3.new(math.random(-3,3),0,math.random(-3,3)))
                    end)
                end
            end
        end
    end

    function FX.updateSpectatorList()
        if not specLabel then return end
        if not Config.Misc.SpectatorList then
            if FX.specOn then FX.specOn=false specLabel.Visible=false end
            return
        end
        FX.specOn=true
        local nowS=os.clock()
        if nowS-FX.specT<1.5 then return end
        FX.specT=nowS
        local lines={}
        for _, cam in ipairs(Workspace:GetChildren()) do
            if cam:IsA("Camera") then
                local subject=cam.CameraSubject
                if subject then
                    local char=subject:IsA("Humanoid") and subject.Parent or
                               subject:IsA("BasePart") and subject.Parent or nil
                    local plr=char and Players:GetPlayerFromCharacter(char)
                    if plr and plr~=LocalPlayer then table.insert(lines, "> "..plr.DisplayName) end
                end
            end
        end
        if #lines==0 then specLabel.Visible=false return end
        specLabel.Text=table.concat(lines,"\n")
        specLabel.Position=Vector2.new(6,120)
        specLabel.Visible=true
    end

    function FX.updateItemESP()
        if not hasDrawing or not Config.Misc.ItemESP then
            for _, d in ipairs(itemESPObjs) do pcall(function() d:Remove() end) end
            itemESPObjs={}
            return
        end
        local keyword=Config.Misc.ItemESPKeyword
        local found=FX.itemFound
        local scanNow=(not found) or (os.clock()-FX.itemT>3)
        if scanNow then
            found={} FX.itemFound=found FX.itemT=os.clock()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if (obj:IsA("BasePart") or obj:IsA("Model")) and kwMatch(obj.Name, keyword~="" and keyword or nil) then
                    local pos
                    if obj:IsA("BasePart") then pos=obj.Position
                    elseif obj.PrimaryPart then pos=obj.PrimaryPart.Position end
                    if pos then table.insert(found,{ name=obj.Name, pos=pos }) end
                    if #found>=50 then break end
                end
            end
        end
        local camPos = Camera.CFrame.Position
        if scanNow then
            table.sort(found, function(a, b)
                return (camPos - a.pos).Magnitude < (camPos - b.pos).Magnitude
            end)
        end
        while #itemESPObjs < #found do
            local nd = newDrawObj("Text",{Size=11,Center=true,Outline=true,Color=Color3.fromRGB(255,220,80),Visible=false})
            if not nd then break end
            table.insert(itemESPObjs, nd)
        end
        for i, info in ipairs(found) do
            local lbl=itemESPObjs[i]
            if lbl then
                local sp,on=Camera:WorldToViewportPoint(info.pos)
                if on then
                    lbl.Text=info.name.." ["..math.floor((camPos-info.pos).Magnitude).."m]"
                    lbl.Position=Vector2.new(sp.X,sp.Y)
                    lbl.Visible=true
                else lbl.Visible=false end
            end
        end
        for i=#found+1, #itemESPObjs do itemESPObjs[i].Visible=false end
    end

    function FX.stopMisc()
        pcall(task.cancel, chatSpamTh) chatSpamTh=nil
        for _, c in ipairs(chatLogConns) do pcall(function() c:Disconnect() end) end
        if specLabel then pcall(function() specLabel:Remove() end) end
        for _, d in ipairs(itemESPObjs) do pcall(function() d:Remove() end) end
    end
end

-- ─── WATERMARK ──────────────────────────────────────────────────────────────
do
    local wm=new("Frame",{
        Size=UDim2.fromOffset(250,24), Position=UDim2.fromOffset(10,10),
        BackgroundColor3=Theme.bg, BorderSizePixel=0, Visible=Config.Menu.Watermark,
    },gui)
    corner(wm,3)
    new("UIStroke",{Color=Theme.stroke,Thickness=1},wm)
    local stripe=new("Frame",{Size=UDim2.new(0,2,1,-8),Position=UDim2.fromOffset(5,4),BorderSizePixel=0,BackgroundColor3=Theme.accent},wm)
    local lbl=new("TextLabel",{
        Text="FenixCheats", Font=Enum.Font.SourceSansSemibold, TextSize=15, TextColor3=Theme.text,
        BackgroundTransparency=1, Position=UDim2.fromOffset(14,0), Size=UDim2.new(1,-18,1,0),
        TextXAlignment=Enum.TextXAlignment.Left,
    },wm)
    FX.wm=wm
    local acc,frames=0,0
    function FX.updateWatermark(dt)
        frames+=1 acc+=dt
        if acc<0.5 then return end
        local fps=math.floor(frames/acc+0.5)
        frames,acc=0,0
        local ping=0
        pcall(function() ping=math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()+0.5) end)
        lbl.Text=string.format("FenixCheats  |  %d fps  |  %d ms", fps, ping)
        stripe.BackgroundColor3=Theme.accent
    end
end

print("[Fenix] 3/4 a construir menu")

-- ─── MENU ───────────────────────────────────────────────────────────────────
;(function()

local FONT  = Enum.Font.SourceSans
local FONTB = Enum.Font.SourceSansBold
local FONTS = Enum.Font.SourceSansSemibold
local LEFT  = Enum.TextXAlignment.Left
local YAUTO = Enum.AutomaticSize.Y
local SORT  = Enum.SortOrder.LayoutOrder

local refreshers = {}
local function reg(fn) fn() table.insert(refreshers, fn) end
local function refreshAll() for _, f in ipairs(refreshers) do pcall(f) end end
local function accentReg(inst, prop)
    local f = function() inst[prop] = Theme.accent end
    reg(f)
    table.insert(FX.live, f)
end
FX.refreshAll = refreshAll

local counters = setmetatable({}, {__mode="k"})
local function order(p) counters[p] = (counters[p] or 0) + 1 return counters[p] end
local function clean(t) return (string.gsub(t, " — .*$", "")) end

local pages, tabButtons, pageNames, searchIndex = {}, {}, {}, {}
local currentTab = nil
local tabOrd = 0
local chevOf = setmetatable({}, {__mode="k"})
local binds = FX.binds

-- ─── janela principal ───────────────────────────────────────────────────────
local MW, MH = 860, 540

local main = new("Frame", {
    Size=UDim2.fromOffset(MW, MH), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
    BackgroundColor3=Theme.bg, BorderSizePixel=0, Visible=true,
}, gui)
corner(main, 5)
new("UIStroke", { Color=Theme.stroke, Thickness=1 }, main)
local mainScale = new("UIScale", { Scale=1 }, main)

function FX.calcScale()
    local vp = Camera.ViewportSize
    local fit = math.min(1, (vp.X - 24) / MW, (vp.Y - 24) / MH)
    return math.max(0.5, fit) * (Config.Menu.Scale or 1)
end

-- camada que apanha cliques fora do menu e liberta o rato (Modal)
local modal = new("TextButton", {
    Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Position=UDim2.fromScale(0,0),
    AutoButtonColor=false, Active=true, ZIndex=0, Visible=false, BorderSizePixel=0,
}, gui)
local cursor = new("Frame", {
    Size=UDim2.fromOffset(8,8), AnchorPoint=Vector2.new(0.5,0.5), BackgroundColor3=Color3.new(1,1,1),
    BorderSizePixel=0, ZIndex=500, Visible=false,
}, gui)
corner(cursor, 4)
accentReg(new("UIStroke", { Thickness=1.5 }, cursor), "Color")

-- ─── barra de titulo ────────────────────────────────────────────────────────
local title = new("Frame", {
    Size=UDim2.new(1,0,0,34), BackgroundColor3=Theme.side, BorderSizePixel=0, ZIndex=2,
}, main)
corner(title, 5)
new("Frame", { Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,1,-6), BackgroundColor3=Theme.side, BorderSizePixel=0, ZIndex=2 }, title)
local titleLine = new("Frame", {
    Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,0), BorderSizePixel=0, BackgroundTransparency=0.35, ZIndex=3,
}, title)
accentReg(titleLine, "BackgroundColor3")

local logoImg = new("ImageLabel", {
    Size=UDim2.fromOffset(24,24), Position=UDim2.fromOffset(8,5), BackgroundTransparency=1,
    Image="", ScaleType=Enum.ScaleType.Fit, ZIndex=4,
}, title)
local logoText = new("TextLabel", {
    Text="FX", Font=FONTB, TextSize=15, BackgroundTransparency=1,
    Size=UDim2.fromOffset(24,24), Position=UDim2.fromOffset(8,5), ZIndex=3,
}, title)
accentReg(logoText, "TextColor3")
new("TextLabel", {
    Text='Fenix<font color="rgb(255,200,60)">Cheats</font>', RichText=true,
    Font=FONTB, TextSize=17, TextColor3=Color3.new(1,1,1), BackgroundTransparency=1,
    Position=UDim2.fromOffset(40,0), Size=UDim2.fromOffset(120,34), TextXAlignment=LEFT, ZIndex=3,
}, title)
local gameNameLabel = new("TextLabel", {
    Font=FONT, TextSize=14, TextColor3=Theme.sub, BackgroundTransparency=1, Text="",
    Position=UDim2.fromOffset(168,0), Size=UDim2.new(1,-290,1,0), TextXAlignment=LEFT,
    TextTruncate=Enum.TextTruncate.AtEnd, ZIndex=3,
}, title)
task.spawn(function()
    local ok, gi = pcall(MarketService.GetProductInfo, MarketService, game.PlaceId)
    if ok and gi and gameNameLabel.Parent then FX.gameName = gi.Name gameNameLabel.Text = gi.Name or "" end
end)
local hintLabel = new("TextLabel", {
    Font=FONT, TextSize=13, TextColor3=Theme.sub, BackgroundTransparency=1,
    Position=UDim2.new(1,-150,0,0), Size=UDim2.fromOffset(110,34), TextXAlignment=Enum.TextXAlignment.Right, ZIndex=3,
}, title)
reg(function() hintLabel.Text = "[" .. Config.Menu.Key .. "]" end)

local closeBtn = new("TextButton", {
    Text="X", Font=FONTB, TextSize=14, TextColor3=Theme.sub, BackgroundTransparency=1,
    Size=UDim2.fromOffset(30,26), Position=UDim2.new(1,-34,0.5,-13), AutoButtonColor=false, ZIndex=4,
}, title)
corner(closeBtn, 3)
track(closeBtn.MouseEnter:Connect(function() tween(closeBtn,0.1,{BackgroundTransparency=0,BackgroundColor3=Theme.danger,TextColor3=Color3.new(1,1,1)}) end))
track(closeBtn.MouseLeave:Connect(function() tween(closeBtn,0.1,{BackgroundTransparency=1,TextColor3=Theme.sub}) end))

do -- arrastar pela barra
    local dragging, startPos, startInput = false, nil, nil
    track(title.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true startPos=main.Position startInput=i.Position
        end
    end))
    track(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=(i.Position-startInput)/math.max(mainScale.Scale,0.1)
            main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
        end
    end))
    track(UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end))
end

-- ─── barra lateral ──────────────────────────────────────────────────────────
local SIDE_W = 160
local side = new("Frame", {
    Size=UDim2.new(0,SIDE_W,1,-35), Position=UDim2.fromOffset(0,35),
    BackgroundColor3=Theme.side, BorderSizePixel=0,
}, main)
corner(side, 5)
new("Frame", { Size=UDim2.new(1,0,0,8), BackgroundColor3=Theme.side, BorderSizePixel=0 }, side)
new("Frame", { Size=UDim2.new(0,8,1,0), Position=UDim2.new(1,-8,0,0), BackgroundColor3=Theme.side, BorderSizePixel=0 }, side)
new("Frame", { Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0), BackgroundColor3=Theme.stroke, BorderSizePixel=0 }, side)

local sbBox = new("TextBox", {
    PlaceholderText="pesquisar (Ctrl+F)", Text="", Font=FONT, TextSize=14, TextColor3=Theme.text,
    PlaceholderColor3=Theme.sub, BackgroundColor3=Theme.bar, Size=UDim2.new(1,-20,0,26),
    Position=UDim2.fromOffset(8,8), ClearTextOnFocus=false, BorderSizePixel=0, TextXAlignment=LEFT,
}, side)
corner(sbBox, 3)
new("UIPadding", { PaddingLeft=UDim.new(0,8) }, sbBox)

local tabList = new("ScrollingFrame", {
    Size=UDim2.new(1,-1,1,-96), Position=UDim2.fromOffset(0,40), BackgroundTransparency=1,
    BorderSizePixel=0, ScrollBarThickness=0, CanvasSize=UDim2.new(), AutomaticCanvasSize=YAUTO,
}, side)
new("UIListLayout", { Padding=UDim.new(0,1), SortOrder=SORT }, tabList)
new("UIPadding", { PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6) }, tabList)

local function category(txt)
    tabOrd += 1
    local l = new("TextLabel", {
        Text=txt, Font=FONTB, TextSize=11, TextColor3=Theme.sub, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,24), TextXAlignment=LEFT, LayoutOrder=tabOrd,
    }, tabList)
    new("UIPadding", { PaddingLeft=UDim.new(0,8), PaddingTop=UDim.new(0,8) }, l)
end

-- perfil
local profile = new("TextButton", {
    Text="", AutoButtonColor=false, Size=UDim2.new(1,-17,0,40), Position=UDim2.new(0,8,1,-48),
    BackgroundColor3=Theme.panel, BorderSizePixel=0,
}, side)
corner(profile, 4)
new("UIStroke", { Color=Theme.stroke, Thickness=1 }, profile)
local avatar = new("ImageLabel", {
    Size=UDim2.fromOffset(28,28), Position=UDim2.fromOffset(6,6), BackgroundColor3=Theme.bar, BorderSizePixel=0,
}, profile)
corner(avatar, 14)
new("TextLabel", {
    Text=LocalPlayer.DisplayName, Font=FONTS, TextSize=14, TextColor3=Theme.text, BackgroundTransparency=1,
    Position=UDim2.fromOffset(40,4), Size=UDim2.new(1,-44,0,16), TextXAlignment=LEFT, TextTruncate=Enum.TextTruncate.AtEnd,
}, profile)
new("TextLabel", {
    Text="@"..LocalPlayer.Name, Font=FONT, TextSize=12, TextColor3=Theme.sub, BackgroundTransparency=1,
    Position=UDim2.fromOffset(40,20), Size=UDim2.new(1,-44,0,14), TextXAlignment=LEFT, TextTruncate=Enum.TextTruncate.AtEnd,
}, profile)
task.spawn(function()
    local ok,img=pcall(Players.GetUserThumbnailAsync,Players,LocalPlayer.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
    if ok and avatar.Parent then avatar.Image=img end
end)

local lsPanel = new("Frame", {
    Size=UDim2.new(1,-17,0,0), AutomaticSize=YAUTO, AnchorPoint=Vector2.new(0,1), Position=UDim2.new(0,8,1,-52),
    BackgroundColor3=Theme.panel, BorderSizePixel=0, Visible=false, ZIndex=5,
}, side)
corner(lsPanel, 4)
new("UIStroke", { Color=Theme.stroke, Thickness=1 }, lsPanel)
new("UIListLayout", { SortOrder=SORT }, lsPanel)
new("UIPadding", { PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4), PaddingLeft=UDim.new(0,8) }, lsPanel)
do
    local lsRows, lastT = {}, 0
    track(profile.MouseButton1Click:Connect(function() lsPanel.Visible = not lsPanel.Visible lastT = 0 end))
    track(RunService.Heartbeat:Connect(function()
        if not lsPanel.Visible then return end
        local now = os.clock()
        if now - lastT < 1 then return end
        lastT = now
        for _, l in ipairs(lsRows) do l:Destroy() end
        table.clear(lsRows)
        local ls = LocalPlayer:FindFirstChild("leaderstats")
        local items = {}
        if ls then for _, v in ipairs(ls:GetChildren()) do table.insert(items, v.Name..": "..tostring(v.Value)) end end
        if #items == 0 then items = {"sem leaderstats"} end
        for i, txt in ipairs(items) do
            table.insert(lsRows, new("TextLabel", {
                Text=txt, Font=FONT, TextSize=14, TextColor3=Theme.text, BackgroundTransparency=1,
                Size=UDim2.new(1,0,0,16), TextXAlignment=LEFT, LayoutOrder=i,
            }, lsPanel))
        end
    end))
end

-- area de conteudo
local content = new("Frame", {
    Size=UDim2.new(1,-SIDE_W,1,-35), Position=UDim2.fromOffset(SIDE_W,35), BackgroundTransparency=1, ClipsDescendants=true,
}, main)

-- ─── tabs ───────────────────────────────────────────────────────────────────
local function styleTabs(t)
    for n, b in pairs(tabButtons) do
        local active = n == currentTab
        pages[n].sf.Visible = active
        tween(b, t, { BackgroundTransparency = active and 0 or 1, TextColor3 = active and Theme.text or Theme.sub })
        local ind = b:FindFirstChild("Ind")
        if ind then ind.Visible = active end
    end
end

local results -- definido mais abaixo
local function setTab(name)
    currentTab = name
    styleTabs(0.12)
    if results then results.Visible = false end
end
function FX.cycleTab(dir)
    local idx = table.find(pageNames, currentTab) or 1
    idx = ((idx - 1 + dir) % #pageNames) + 1
    setTab(pageNames[idx])
end

local function addPage(name)
    local sf = new("ScrollingFrame", {
        Size=UDim2.new(1,-12,1,-12), Position=UDim2.fromOffset(6,6), BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=3, CanvasSize=UDim2.new(), AutomaticCanvasSize=YAUTO, Visible=false,
        ScrollingDirection=Enum.ScrollingDirection.Y,
    }, content)
    accentReg(sf, "ScrollBarImageColor3")
    local cols = {}
    for i = 1, 2 do
        local col = new("Frame", {
            BackgroundTransparency=1, Size=UDim2.new(0.5,-4,0,0), Position=UDim2.new((i-1)*0.5,(i-1)*4,0,0), AutomaticSize=YAUTO,
        }, sf)
        new("UIListLayout", { Padding=UDim.new(0,8), SortOrder=SORT }, col)
        cols[i] = col
    end
    local P = { name=name, sf=sf, cols=cols, h={0,0} }
    pages[name] = P
    table.insert(pageNames, name)

    tabOrd += 1
    local btn = new("TextButton", {
        Text=name, Font=FONTS, TextSize=15, TextColor3=Theme.sub, Size=UDim2.new(1,0,0,28),
        BackgroundColor3=Theme.panel, BackgroundTransparency=1, AutoButtonColor=false, BorderSizePixel=0,
        LayoutOrder=tabOrd, TextXAlignment=LEFT,
    }, tabList)
    corner(btn, 3)
    new("UIPadding", { PaddingLeft=UDim.new(0,14) }, btn)
    local ind = new("Frame", { Name="Ind", Size=UDim2.fromOffset(2,14), Position=UDim2.new(0,-9,0.5,-7), BorderSizePixel=0, Visible=false }, btn)
    accentReg(ind, "BackgroundColor3")
    tabButtons[name] = btn
    track(btn.MouseButton1Click:Connect(function() setTab(name) end))
    track(btn.MouseEnter:Connect(function() if name ~= currentTab then tween(btn,0.1,{BackgroundTransparency=0.6,BackgroundColor3=Theme.bar}) end end))
    track(btn.MouseLeave:Connect(function() if name ~= currentTab then tween(btn,0.1,{BackgroundTransparency=1}) end end))
    table.insert(searchIndex, { label=name, page=P, tab=true })
    return P
end

-- ─── pesquisa global ────────────────────────────────────────────────────────
results = new("ScrollingFrame", {
    Size=UDim2.fromOffset(340,30), Position=UDim2.fromOffset(SIDE_W+10,40), BackgroundColor3=Theme.panel,
    BorderSizePixel=0, Visible=false, ZIndex=40, ScrollBarThickness=2, CanvasSize=UDim2.new(), AutomaticCanvasSize=YAUTO,
}, main)
corner(results, 4)
new("UIStroke", { Color=Theme.barHi, Thickness=1 }, results)
new("UIListLayout", { SortOrder=SORT }, results)

local function goTo(e)
    setTab(e.page.name)
    if e.tab or not e.row then return end
    if e.body and not e.body.Visible then
        e.body.Visible = true
        if chevOf[e.body] then chevOf[e.body].Text = "-" end
    end
    task.delay(0.06, function()
        local sf = e.page.sf
        local y = (e.row.AbsolutePosition.Y - sf.AbsolutePosition.Y) / math.max(mainScale.Scale, 0.1) + sf.CanvasPosition.Y - 24
        sf.CanvasPosition = Vector2.new(0, math.max(0, y))
        e.row.BackgroundColor3 = Theme.accent
        e.row.BackgroundTransparency = 0.55
        tween(e.row, 1.1, { BackgroundTransparency = 1 })
        task.delay(1.2, function() if e.row.Parent then e.row.BackgroundColor3 = Theme.bar end end)
    end)
end

local firstHit
local function rebuildResults()
    for _, c in ipairs(results:GetChildren()) do if c:IsA("GuiButton") or c:IsA("TextLabel") then c:Destroy() end end
    firstHit = nil
    local q = string.lower(sbBox.Text)
    if q == "" then results.Visible = false return end
    local n = 0
    for _, e in ipairs(searchIndex) do
        if string.find(string.lower(e.label), q, 1, true) or string.find(string.lower(e.page.name), q, 1, true) then
            n += 1
            if n > 14 then break end
            firstHit = firstHit or e
            local b = new("TextButton", {
                Text=e.tab and ("  "..e.label.."  (tab)") or ("  "..e.page.name.."  >  "..e.label),
                Font=FONT, TextSize=14, TextColor3=Theme.text, BackgroundColor3=Theme.bar, BackgroundTransparency=1,
                Size=UDim2.new(1,0,0,24), AutoButtonColor=false, BorderSizePixel=0, TextXAlignment=LEFT,
                TextTruncate=Enum.TextTruncate.AtEnd, LayoutOrder=n, ZIndex=41,
            }, results)
            track(b.MouseEnter:Connect(function() b.BackgroundTransparency = 0.3 end))
            track(b.MouseLeave:Connect(function() b.BackgroundTransparency = 1 end))
            track(b.MouseButton1Click:Connect(function() sbBox.Text = "" goTo(e) end))
        end
    end
    if n == 0 then
        new("TextLabel", {
            Text="  sem resultados", Font=FONT, TextSize=14, TextColor3=Theme.sub, BackgroundTransparency=1,
            Size=UDim2.new(1,0,0,24), TextXAlignment=LEFT, ZIndex=41,
        }, results)
        n = 1
    end
    results.Size = UDim2.fromOffset(340, math.min(n, 12) * 24 + 2)
    results.Visible = true
end
track(sbBox:GetPropertyChangedSignal("Text"):Connect(rebuildResults))
track(sbBox.FocusLost:Connect(function(enter)
    if enter and firstHit then local e = firstHit sbBox.Text = "" goTo(e) end
    task.delay(0.3, function() if sbBox.Text == "" then results.Visible = false end end)
end))
function FX.focusSearch() sbBox:CaptureFocus() end

-- ─── grupos e widgets ───────────────────────────────────────────────────────
local function section(P, text, col)
    local idx = col or ((P.h[1] <= P.h[2]) and 1 or 2)
    local column = P.cols[idx]
    local g = new("Frame", {
        Size=UDim2.new(1,0,0,0), AutomaticSize=YAUTO, BackgroundColor3=Theme.panel, BorderSizePixel=0,
        LayoutOrder=order(column),
    }, column)
    corner(g, 4)
    new("UIStroke", { Color=Theme.stroke, Thickness=1 }, g)
    new("UIListLayout", { SortOrder=SORT }, g)
    local head = new("TextButton", {
        Text="", Size=UDim2.new(1,0,0,26), BackgroundTransparency=1, AutoButtonColor=false, LayoutOrder=0,
    }, g)
    local pip = new("Frame", { Size=UDim2.fromOffset(2,12), Position=UDim2.fromOffset(8,7), BorderSizePixel=0 }, head)
    accentReg(pip, "BackgroundColor3")
    new("TextLabel", {
        Text=string.upper(text), Font=FONTB, TextSize=13, TextColor3=Theme.text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(16,0), Size=UDim2.new(1,-40,1,0), TextXAlignment=LEFT,
    }, head)
    local chev = new("TextLabel", {
        Text="-", Font=FONTB, TextSize=16, TextColor3=Theme.sub, BackgroundTransparency=1,
        Position=UDim2.new(1,-24,0,0), Size=UDim2.fromOffset(16,26),
    }, head)
    local body = new("Frame", { Size=UDim2.new(1,0,0,0), AutomaticSize=YAUTO, BackgroundTransparency=1, LayoutOrder=1 }, g)
    new("UIListLayout", { Padding=UDim.new(0,1), SortOrder=SORT }, body)
    new("UIPadding", { PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), PaddingBottom=UDim.new(0,6) }, body)
    chevOf[body] = chev
    track(head.MouseButton1Click:Connect(function()
        body.Visible = not body.Visible
        chev.Text = body.Visible and "-" or "+"
    end))
    P.cur, P.curCol = body, idx
    P.h[idx] += 34
end

local function rowFrame(P, h, label)
    local body = P.cur
    local r = new("Frame", {
        Size=UDim2.new(1,0,0,h), BackgroundColor3=Theme.bar, BackgroundTransparency=1, BorderSizePixel=0,
        LayoutOrder=order(body),
    }, body)
    corner(r, 3)
    P.h[P.curCol] += h + 1
    if label then table.insert(searchIndex, { label=clean(label), page=P, row=r, body=body }) end
    return r
end

local function hover(r, src)
    track(src.MouseEnter:Connect(function() tween(r, 0.08, { BackgroundTransparency = 0.6 }) end))
    track(src.MouseLeave:Connect(function() tween(r, 0.1,  { BackgroundTransparency = 1 }) end))
end

local function rowLabel(r, text, rightPad)
    return new("TextLabel", {
        Text=clean(text), Font=FONT, TextSize=15, TextColor3=Theme.text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(6,0), Size=UDim2.new(1,-(rightPad or 12),1,0),
        TextXAlignment=LEFT, TextTruncate=Enum.TextTruncate.AtEnd,
    }, r)
end

local function call(fn, ...)
    if not fn then return end
    local ok, err = pcall(fn, ...)
    if not ok then warn("[Fenix] "..tostring(err)) end
end

local function note(P, text)
    local l = new("TextLabel", {
        Text=text, Font=FONT, TextSize=13, TextColor3=Theme.sub, TextWrapped=true, BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,32), TextXAlignment=LEFT, TextYAlignment=Enum.TextYAlignment.Top,
        LayoutOrder=order(P.cur),
    }, P.cur)
    new("UIPadding", { PaddingLeft=UDim.new(0,6), PaddingTop=UDim.new(0,2) }, l)
    reg(function() l.Visible = Config.Menu.ShowTips == true end)
end

local function toggle(P, text, tbl, key, onChange, withBind)
    local r = rowFrame(P, 24, text)
    local hit = new("TextButton", { Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1), AutoButtonColor=false }, r)
    hover(r, hit)
    rowLabel(r, text, withBind and 90 or 30)
    local box = new("Frame", {
        Size=UDim2.fromOffset(14,14), Position=UDim2.new(1,-20,0.5,-7), BackgroundColor3=Theme.bar, BorderSizePixel=0,
    }, r)
    corner(box, 3)
    local bs = new("UIStroke", { Color=Theme.barHi, Thickness=1 }, box)
    local function render(t)
        local on = tbl[key] == true
        tween(box, t, { BackgroundColor3 = on and Theme.accent or Theme.bar })
        tween(bs,  t, { Color = on and Theme.accent or Theme.barHi })
    end
    reg(function() render(0) end)
    table.insert(FX.live, function()
        if tbl[key] == true then box.BackgroundColor3 = Theme.accent bs.Color = Theme.accent end
    end)
    local function flip()
        tbl[key] = not tbl[key]
        render(0.12)
        call(onChange, tbl[key])
    end
    track(hit.MouseButton1Click:Connect(flip))
    if withBind then
        local bk = key .. "Bind"
        local bb = new("TextButton", {
            Font=FONTB, TextSize=12, Size=UDim2.fromOffset(56,16), Position=UDim2.new(1,-82,0.5,-8),
            BackgroundColor3=Theme.bar, AutoButtonColor=false, BorderSizePixel=0,
        }, r)
        corner(bb, 3)
        local function rb()
            local v = tbl[bk] or "None"
            bb.Text = v == "None" and "bind" or short(v)
            bb.TextColor3 = v == "None" and Theme.sub or Theme.accent
        end
        reg(rb)
        table.insert(FX.live, function() if (tbl[bk] or "None") ~= "None" then bb.TextColor3 = Theme.accent end end)
        track(bb.MouseButton1Click:Connect(function()
            if FX.listening then FX.listening(nil) end
            bb.Text = "..."
            FX.listening = function(n) FX.listening = nil if n then tbl[bk] = n end rb() end
        end))
        table.insert(binds, { tbl=tbl, key=key, bk=bk, flip=flip, label=clean(text) })
    end
end

local function slider(P, text, tbl, key, mn, mx, step, onChange)
    local r = rowFrame(P, 36, text)
    local function fmt(v)
        if step < 1 then return string.format("%.2f", v) end
        return tostring(math.floor(v + 0.5))
    end
    new("TextLabel", {
        Text=clean(text), Font=FONT, TextSize=15, TextColor3=Theme.text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(6,1), Size=UDim2.new(1,-72,0,20), TextXAlignment=LEFT, TextTruncate=Enum.TextTruncate.AtEnd,
    }, r)
    local val = new("TextLabel", {
        Font=FONTB, TextSize=14, BackgroundTransparency=1, Position=UDim2.new(1,-68,0,1),
        Size=UDim2.fromOffset(62,20), TextXAlignment=Enum.TextXAlignment.Right,
    }, r)
    accentReg(val, "TextColor3")
    local bar = new("Frame", {
        Position=UDim2.fromOffset(6,26), Size=UDim2.new(1,-12,0,4), BackgroundColor3=Theme.bar, BorderSizePixel=0,
    }, r)
    corner(bar, 2)
    local fill = new("Frame", { Size=UDim2.fromScale(0,1), BorderSizePixel=0 }, bar)
    corner(fill, 2)
    accentReg(fill, "BackgroundColor3")
    local knob = new("Frame", {
        Size=UDim2.fromOffset(6,12), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0,0.5),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, ZIndex=3,
    }, bar)
    corner(knob, 2)
    local hit = new("TextButton", { Text="", BackgroundTransparency=1, Position=UDim2.fromOffset(0,18), Size=UDim2.new(1,0,0,18), AutoButtonColor=false }, r)
    local function render()
        local v = math.clamp(tbl[key], mn, mx)
        local a = (v - mn) / (mx - mn)
        fill.Size = UDim2.fromScale(a, 1)
        knob.Position = UDim2.fromScale(a, 0.5)
        val.Text = fmt(v)
    end
    reg(render)
    local dragging = false
    local function setFromX(x)
        local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
        local v = math.floor((mn + (mx - mn) * a) / step + 0.5) * step
        tbl[key] = math.clamp(v, mn, mx)
        render()
        call(onChange, tbl[key])
    end
    track(hit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging = true setFromX(i.Position.X)
        end
    end))
    track(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            setFromX(i.Position.X)
        end
    end))
    track(UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging = false end
    end))
end

local function cycle(P, text, tbl, key, options, onChange)
    local r = rowFrame(P, 24, text)
    rowLabel(r, text, 116)
    local btn = new("TextButton", {
        Font=FONTS, TextSize=14, Size=UDim2.fromOffset(104,18), Position=UDim2.new(1,-110,0.5,-9),
        BackgroundColor3=Theme.bar, AutoButtonColor=false, BorderSizePixel=0,
    }, r)
    corner(btn, 3)
    reg(function() btn.Text = tostring(tbl[key]) btn.TextColor3 = Theme.accent end)
    table.insert(FX.live, function() btn.TextColor3 = Theme.accent end)
    local function step(d)
        local idx = table.find(options, tbl[key]) or 1
        tbl[key] = options[((idx - 1 + d) % #options) + 1]
        btn.Text = tostring(tbl[key])
        call(onChange, tbl[key])
    end
    track(btn.MouseButton1Click:Connect(function() step(1) end))
    track(btn.MouseButton2Click:Connect(function() step(-1) end))
end

local function keybind(P, text, tbl, key, onChange)
    local r = rowFrame(P, 24, text)
    rowLabel(r, text, 116)
    local btn = new("TextButton", {
        Font=FONTS, TextSize=14, Size=UDim2.fromOffset(104,18), Position=UDim2.new(1,-110,0.5,-9),
        BackgroundColor3=Theme.bar, AutoButtonColor=false, BorderSizePixel=0,
    }, r)
    corner(btn, 3)
    local function render() btn.Text = tostring(tbl[key]) btn.TextColor3 = Theme.accent end
    reg(render)
    table.insert(FX.live, function() btn.TextColor3 = Theme.accent end)
    track(btn.MouseButton1Click:Connect(function()
        if FX.listening then FX.listening(nil) end
        btn.Text = "..."
        FX.listening = function(n)
            FX.listening = nil
            if n then tbl[key] = n end
            render()
            if n then call(onChange, n) end
        end
    end))
end

local function button(P, text, cb, clr)
    local body = P.cur
    local btn = new("TextButton", {
        Text=text, Font=FONTS, TextSize=15, TextColor3=Theme.text, Size=UDim2.new(1,0,0,26),
        BackgroundColor3=clr or Theme.bar, AutoButtonColor=false, BorderSizePixel=0, LayoutOrder=order(body),
    }, body)
    corner(btn, 3)
    local st = new("UIStroke", { Color=Theme.barHi, Thickness=1 }, btn)
    track(btn.MouseEnter:Connect(function() tween(st, 0.1, { Color=Theme.accent }) end))
    track(btn.MouseLeave:Connect(function() tween(st, 0.1, { Color=Theme.barHi }) end))
    track(btn.MouseButton1Click:Connect(function() call(cb) end))
    P.h[P.curCol] += 28
    table.insert(searchIndex, { label=text, page=P, row=btn, body=body })
end

local function textInput(P, label, placeholder, tbl, key, isNumber)
    local r = rowFrame(P, 26, label)
    local l = rowLabel(r, label, 0)
    l.Size = UDim2.new(0.42, 0, 1, 0)
    local tb = new("TextBox", {
        PlaceholderText=placeholder, Text=tostring(tbl[key] or ""), Font=FONT, TextSize=14, TextColor3=Theme.text,
        PlaceholderColor3=Theme.sub, BackgroundColor3=Theme.bar, Position=UDim2.new(0.44,0,0.5,-10),
        Size=UDim2.new(0.56,-4,0,20), TextXAlignment=LEFT, ClearTextOnFocus=false, BorderSizePixel=0,
        TextTruncate=Enum.TextTruncate.AtEnd,
    }, r)
    corner(tb, 3)
    new("UIPadding", { PaddingLeft=UDim.new(0,6) }, tb)
    track(tb.FocusLost:Connect(function()
        if isNumber then
            local n = tonumber(tb.Text)
            if n then tbl[key] = n end
            tb.Text = tostring(tbl[key])
        else
            tbl[key] = tb.Text
        end
    end))
end

-- ─── rato livre + prioridade do menu ────────────────────────────────────────
local mouseSaved = nil
local function sink() return Enum.ContextActionResult.Sink end

local function lockMouseUI(open)
    if open then
        if not mouseSaved then mouseSaved = { UIS.MouseBehavior, UIS.MouseIconEnabled } end
        modal.Visible = true
        pcall(function() modal.Modal = true end)
        cursor.Visible = true
        pcall(function()
            CAS:BindActionAtPriority("FenixSink", sink, false, 3000,
                Enum.UserInputType.MouseMovement, Enum.UserInputType.MouseWheel,
                Enum.UserInputType.MouseButton1, Enum.UserInputType.MouseButton2, Enum.UserInputType.MouseButton3)
        end)
    else
        pcall(function() CAS:UnbindAction("FenixSink") end)
        pcall(function() modal.Modal = false end)
        modal.Visible = false
        cursor.Visible = false
        if mouseSaved then
            pcall(function() UIS.MouseBehavior = mouseSaved[1] UIS.MouseIconEnabled = mouseSaved[2] end)
            mouseSaved = nil
        end
    end
end
FX.releaseMouse = function() lockMouseUI(false) end

local function mouseStep()
    if not menuOpen then return end
    UIS.MouseBehavior = Enum.MouseBehavior.Default
    UIS.MouseIconEnabled = false
    local m = UIS:GetMouseLocation()
    cursor.Position = UDim2.fromOffset(m.X, m.Y)
end
if not pcall(function() RunService:BindToRenderStep("FenixMouse", Enum.RenderPriority.Last.Value, mouseStep) end) then
    track(RunService.RenderStepped:Connect(mouseStep))
end

local function setMenu(open)
    menuOpen = open
    local sc = FX.calcScale()
    if open then
        main.Visible = true
        mainScale.Scale = sc * 0.95
        tween(mainScale, 0.15, { Scale = sc })
        lockMouseUI(true)
    else
        lockMouseUI(false)
        pcall(function() sbBox:ReleaseFocus() end)
        results.Visible = false
        tween(mainScale, 0.12, { Scale = sc * 0.95 })
        task.delay(0.13, function() if not menuOpen and main.Parent then main.Visible = false end end)
    end
end
FX.setMenu = setMenu
track(closeBtn.MouseButton1Click:Connect(function() setMenu(false) end))

-- botao flutuante (para quem nao usa teclado)
local fab = new("TextButton", {
    Text="FX", Font=FONTB, TextSize=14, Size=UDim2.fromOffset(32,32), Position=UDim2.new(0,6,0.5,-16),
    BackgroundColor3=Theme.bg, AutoButtonColor=false, BorderSizePixel=0, ZIndex=10, TextTransparency=0,
}, gui)
corner(fab, 4)
accentReg(fab, "TextColor3")
accentReg(new("UIStroke", { Thickness=1 }, fab), "Color")
track(fab.MouseButton1Click:Connect(function() setMenu(not menuOpen) end))
FX.loadLogo({ {img=logoImg, fallback=logoText} })

-- ─── PAGINAS ────────────────────────────────────────────────────────────────
local function safe(name, fn)
    local ok, err = xpcall(fn, debug.traceback)
    if not ok then
        warn("[Fenix] erro em '"..name.."': "..tostring(err))
        pcall(notify, "Erro em "..name..": "..string.sub(tostring(err),1,70), Theme.danger, 8)
    end
end

category("COMBATE")
local aimP  = addPage("Aimbot")
local cmbP  = addPage("Combate")
category("VISUAL")
local espP  = addPage("ESP")
local visP  = addPage("Visual")
category("JOGADOR")
local movP  = addPage("Mover")
local plrP  = addPage("Players")
category("EXPLOIT")
local expP  = addPage("Exploit")
local remP  = addPage("Remotes")
category("SISTEMA")
local misP  = addPage("Misc")
local cfgP  = addPage("Config")

safe("Aimbot", function()
local P = aimP
section(P, "aimbot")
toggle(P, "Ativar Aimbot", Config.Aimbot, "Enabled", nil, true)
cycle(P, "Modo (Hold / Toggle / Always)", Config.Aimbot, "Mode", {"Hold","Toggle","Always"}, function() aiming = false end)
keybind(P, "Tecla de mira", Config.Aimbot, "Key")
toggle(P, "Mostrar circulo FOV", Config.Aimbot, "ShowFOV")
slider(P, "FOV — raio do circulo de detecao", Config.Aimbot, "FOV", 30, 500, 5)
slider(P, "Suavidade — 1.0 e instantaneo", Config.Aimbot, "Smooth", 0.05, 1, 0.05)
slider(P, "Distancia maxima (studs)", Config.Aimbot, "MaxDistance", 100, 3000, 50)
cycle(P, "Parte alvo", Config.Aimbot, "Part", {"Head","Torso","Root","Closest"})
toggle(P, "Manter alvo — nao troca enquanto estiver vivo", Config.Aimbot, "Sticky")

section(P, "silent aim")
note(P, "Redireciona Mouse.Hit / Mouse.Target. Precisa de hookmetamethod e so funciona em jogos que usam o Mouse.")
toggle(P, "Silent aim", Config.Aimbot, "SilentAim", function(on)
    if on and not hasHook then notify("Executor sem hookmetamethod - silent aim indisponivel.", Theme.warning, 4) end
end)
toggle(P, "Silent aim via MoveTo", Config.Aimbot, "SilentMoveTo", function(on)
    if on then FX.ensureMoveToHook() end
end)

section(P, "triggerbot")
note(P, "Dispara quando o cursor esta sobre um inimigo visivel. Precisa de mouse1click.")
toggle(P, "Triggerbot", Config.Aimbot, "Triggerbot", function(on)
    if on and not FX.clickFn then notify("Executor sem mouse1click - triggerbot indisponivel.", Theme.warning, 4) end
end)
slider(P, "Atraso entre disparos (s)", Config.Aimbot, "TriggerDelay", 0.02, 0.5, 0.01)

section(P, "predicao")
toggle(P, "Predicao — compensa o movimento do alvo", Config.Aimbot, "Prediction")
slider(P, "Forca da predicao", Config.Aimbot, "PredictionAmount", 0.02, 0.3, 0.01)
toggle(P, "Dead Reckoning — velocidade + aceleracao + ping", Config.Aimbot, "DeadReckoning")
toggle(P, "Backtrack — mira em posicoes antigas", Config.Aimbot, "Backtrack")
slider(P, "Frames de backtrack", Config.Aimbot, "BacktrackFrames", 2, 20, 1)

section(P, "filtros")
toggle(P, "Ignorar equipa", Config.Aimbot, "TeamCheck")
toggle(P, "Verificar paredes — so mira em alvos visiveis", Config.Aimbot, "WallCheck")
end)

safe("Combate", function()
local P = cmbP
section(P, "hitbox")
toggle(P, "Expandir hitbox", Config.Combat, "Hitbox")
slider(P, "Tamanho da hitbox (studs)", Config.Combat, "HitboxSize", 2, 30, 1)
toggle(P, "Ignorar equipa", Config.Combat, "TeamCheck")
section(P, "reach")
toggle(P, "Reach extender", Config.Combat, "ReachEnabled")
slider(P, "Tamanho do reach (studs)", Config.Combat, "ReachSize", 5, 60, 1)
section(P, "kill aura")
toggle(P, "Kill Aura", Config.Combat, "KillAura", function() startKillAura() end)
slider(P, "Raio (studs)", Config.Combat, "KillAuraRadius", 5, 100, 1)
slider(P, "Delay entre ataques (s)", Config.Combat, "KillAuraDelay", 0.03, 1, 0.01)
section(P, "protecao")
toggle(P, "God Mode — repoe a vida em loop", Config.Combat, "GodMode", function() FX.startGodMode() end)
toggle(P, "Anti-Report — bloqueia remotes de report/kick", Config.Combat, "AntiReport", function(on)
    if on then FX.startAntiReport() end
end)
section(P, "freeze & dupe")
toggle(P, "Freeze Player", Config.Combat, "FreezePlayer", function() FX.startFreeze() end)
textInput(P, "Nome do alvo", "nome exato...", Config.Combat, "FreezeTarget", false)
button(P, "Duplicar tool equipada", function() FX.doToolDupe() end)
end)

safe("ESP", function()
local P = espP
section(P, "geral")
toggle(P, "Ativar ESP", Config.ESP, "Enabled", nil, true)
toggle(P, "Ignorar equipa", Config.ESP, "TeamCheck")
toggle(P, "Cores por equipa", Config.ESP, "TeamColors")
slider(P, "Distancia maxima (studs)", Config.ESP, "MaxDistance", 100, 5000, 50)

section(P, "elementos")
toggle(P, "Caixas", Config.ESP, "Boxes")
cycle(P, "Estilo da caixa", Config.ESP, "BoxStyle", {"Full","Corner"})
toggle(P, "Nomes", Config.ESP, "Names")
toggle(P, "Distancia", Config.ESP, "Distance")
toggle(P, "Barra de vida", Config.ESP, "Health")
toggle(P, "Arma equipada", Config.ESP, "Tools")
toggle(P, "Esqueleto", Config.ESP, "Skeleton")
toggle(P, "Ponto na cabeca", Config.ESP, "HeadDot")
toggle(P, "Chams (Highlight)", Config.ESP, "Chams")
toggle(P, "Tracers", Config.ESP, "Tracers")
cycle(P, "Origem dos tracers", Config.ESP, "TracerOrigin", {"Bottom","Centro","Rato"})
toggle(P, "Snap line", Config.ESP, "SnapLine")

section(P, "radar")
note(P, "O radar so aparece com o ESP ativo.")
toggle(P, "Mini-radar", Config.ESP, "Radar")
slider(P, "Alcance (studs)", Config.ESP, "RadarRange", 50, 500, 10)
slider(P, "Tamanho (px)", Config.ESP, "RadarSize", 90, 240, 10)

section(P, "avancado")
toggle(P, "Off-Screen arrows", Config.ESP, "OffScreen")
slider(P, "Tamanho das setas (px)", Config.ESP, "OffScreenSize", 6, 30, 1)
toggle(P, "Cor por vida (verde > vermelho)", Config.ESP, "HealthColor")
toggle(P, "Material chams (Neon)", Config.ESP, "MaterialChams")
slider(P, "Transparencia do material", Config.ESP, "MatTransparency", 0, 0.95, 0.05)
toggle(P, "Item tracers", Config.ESP, "ItemTracers")
end)

safe("Mover", function()
local P = movP
section(P, "voo & velocidade")
toggle(P, "Fly", Config.Move, "Fly", nil, true)
slider(P, "Velocidade do fly (studs/s)", Config.Move, "FlySpeed", 10, 250, 5)
toggle(P, "Speed hack", Config.Move, "Speed", nil, true)
slider(P, "Velocidade extra (studs/s)", Config.Move, "SpeedValue", 5, 300, 1)
section(P, "salto & fisica")
toggle(P, "Noclip", Config.Move, "Noclip", nil, true)
toggle(P, "Pulo infinito", Config.Move, "InfJump", nil, true)
toggle(P, "Bhop", Config.Move, "BhopEnabled")
toggle(P, "Super jump", Config.Move, "SuperJump")
slider(P, "Forca do super jump (padrao 50)", Config.Move, "SuperJumpPower", 50, 500, 10)
toggle(P, "Long jump", Config.Move, "LongJump")
toggle(P, "Gravidade personalizada", Config.Move, "Gravity")
slider(P, "Valor da gravidade (padrao 196)", Config.Move, "GravityValue", 0, 196, 2)
section(P, "teleporte")
note(P, "Click TP: segura Ctrl e clica no chao.")
toggle(P, "Click TP", Config.Move, "ClickTP")
end)

safe("Visual", function()
local P = visP
section(P, "iluminacao")
toggle(P, "Fullbright", Config.Visual, "Fullbright", nil, true)
toggle(P, "Remover nevoeiro", Config.Visual, "NoFog")
toggle(P, "Modo noite", Config.Visual, "Nightmode")
toggle(P, "Modo amanhecer", Config.Visual, "Sunrise")
section(P, "camera")
toggle(P, "Alterar FOV", Config.Visual, "FOV")
slider(P, "Valor do FOV (padrao 70)", Config.Visual, "FOVValue", 40, 140, 1)
toggle(P, "Terceira pessoa", Config.Visual, "ThirdPerson")
slider(P, "Distancia da camera (studs)", Config.Visual, "ThirdPersonDist", 2, 20, 1)
toggle(P, "Dynamic FOV — sobe ao correr", Config.Visual, "DynamicFOV")
slider(P, "FOV minimo (parado)", Config.Visual, "DynFOVMin", 40, 100, 1)
slider(P, "FOV maximo (em movimento)", Config.Visual, "DynFOVMax", 50, 140, 1)
section(P, "overlays")
toggle(P, "Mira personalizada", Config.Visual, "Crosshair")
slider(P, "Tamanho dos tracos", Config.Visual, "CrossSize", 2, 30, 1)
slider(P, "Espaco central", Config.Visual, "CrossGap", 0, 20, 1)
toggle(P, "Wireframe — personagem em neon", Config.Visual, "Wireframe", function(on) applyWireframe(on) end)
toggle(P, "Ping graph", Config.Visual, "PingGraph")
toggle(P, "Hotkey HUD", Config.Visual, "HotkeyHUD")
toggle(P, "Stream Proof", Config.Visual, "StreamProof", function(on) FX.applyStreamProof(on) end)
end)

safe("Exploit", function()
local P = expP
section(P, "status & scan")
do
    local info = rowFrame(P, 50)
    local infoLabel = new("TextLabel", {
        Text="a aguardar scan...", Font=Enum.Font.Code, TextSize=12, TextColor3=Theme.text, BackgroundTransparency=1,
        TextWrapped=true, Position=UDim2.fromOffset(6,2), Size=UDim2.new(1,-12,1,-4), TextXAlignment=LEFT,
        TextYAlignment=Enum.TextYAlignment.Top,
    }, info)
    task.spawn(function()
        while alive and task.wait(6) do
            if not infoLabel.Parent then break end
            if menuOpen and currentTab == "Exploit" then
                local inf = FX.getServerInfo()
                infoLabel.Text = string.format("Ping: %dms  |  Jogadores: %d\nRemotes econ.: %d  |  Valores econ.: %d\nJobId: ...%s",
                    inf.ping, inf.players, #FX.scanRemotes(nil), #FX.scanValues(nil), string.sub(inf.jobId, -8))
            end
        end
    end)
end
button(P, "Escanear agora", function()
    local remotes, vals = FX.scanRemotes(nil), FX.scanValues(nil)
    notify(string.format("Scan: %d remote(s), %d valor(es).", #remotes, #vals), Theme.success)
    for i = 1, math.min(4, #remotes) do task.wait(0.1) notify("R: "..remotes[i].Name, Theme.sub, 2) end
end)

section(P, "auto farm")
toggle(P, "Auto Farm", Config.Exploit, "AutoFarmEnabled", function(on)
    FX.startAutoFarm() notify(on and "Auto Farm ON" or "Auto Farm OFF", on and Theme.success or Theme.sub)
end)
cycle(P, "Modo (Remote / Touch / Both)", Config.Exploit, "AutoFarmMode", {"Remote","Touch","Both"})
slider(P, "Delay entre ciclos (s)", Config.Exploit, "AutoFarmDelay", 0.05, 5, 0.05)
textInput(P, "Keyword do farm", "ex: coin, gem...", Config.Exploit, "AutoFarmKeyword", false)
toggle(P, "Smart Farm — troca de remote se parar de subir", Config.Exploit, "SmartFarm", function(on)
    FX.startSmartFarm() notify(on and "Smart Farm ON" or "Smart Farm OFF", on and Theme.success or Theme.sub)
end)
slider(P, "Janela de detecao (s)", Config.Exploit, "SmartFarmWindow", 2, 30, 1)

section(P, "economia")
toggle(P, "Dinheiro infinito (loop)", Config.Exploit, "InfMoneyEnabled", function(on)
    FX.startInfMoney() notify(on and "Inf Money ON" or "Inf Money OFF", on and Theme.success or Theme.sub)
end)
cycle(P, "Modo (Value / Remote / Both)", Config.Exploit, "InfMoneyMode", {"Value","Remote","Both"})
slider(P, "Valor alvo", Config.Exploit, "InfMoneyAmount", 1000, 999999999, 1000)
button(P, "Forcar patch de stats", function() FX.patchStats() end)
button(P, "Ver valores de economia", function()
    local vals = FX.scanValues(nil)
    if #vals == 0 then notify("Nenhum valor encontrado.") return end
    for i = 1, math.min(5, #vals) do task.wait(0.08) notify(vals[i]:GetFullName().." = "..tostring(vals[i].Value), Theme.accent, 2.5) end
end)

section(P, "coleta & venda")
toggle(P, "Auto Collect", Config.Exploit, "AutoCollect")
slider(P, "Raio de coleta (studs)", Config.Exploit, "AutoCollectRadius", 5, 300, 5)
textInput(P, "Keyword coleta", "ex: ore, chest...", Config.Exploit, "AutoCollectKeyword", false)
toggle(P, "Auto Sell", Config.Exploit, "AutoSellEnabled", function(on)
    FX.startAutoSell() notify(on and "Auto Sell ON" or "Auto Sell OFF", on and Theme.success or Theme.sub)
end)
slider(P, "Delay de venda (s)", Config.Exploit, "AutoSellDelay", 0.5, 10, 0.5)

section(P, "quests & rebirth")
toggle(P, "Auto Quest", Config.Exploit, "AutoQuestEnabled", function(on)
    FX.startAutoQuest() notify(on and "Auto Quest ON" or "Auto Quest OFF", on and Theme.success or Theme.sub)
end)
slider(P, "Delay da quest (s)", Config.Exploit, "AutoQuestDelay", 0.5, 10, 0.5)
toggle(P, "Auto Rebirth", Config.Exploit, "AutoRebirthEnabled", function(on)
    FX.startAutoRebirth() notify(on and "Auto Rebirth ON" or "Auto Rebirth OFF", on and Theme.success or Theme.sub)
end)
slider(P, "Delay do rebirth (s)", Config.Exploit, "AutoRebirthDelay", 1, 30, 1)

section(P, "auto click")
toggle(P, "Auto Click", Config.Exploit, "AutoClickEnabled", function(on)
    FX.startAutoClick() notify(on and "Auto Click ON" or "Auto Click OFF", on and Theme.success or Theme.sub)
end)
cycle(P, "Modo (Mouse1 / Remote)", Config.Exploit, "AutoClickMode", {"Mouse1","Remote"})
slider(P, "Delay entre cliques (s)", Config.Exploit, "AutoClickDelay", 0.01, 1, 0.01)

section(P, "itens & spam")
textInput(P, "Keyword do item", "ex: sword, gem...", Config.Exploit, "ItemTPKeyword", false)
button(P, "Teleportar para item", function() FX.doItemTeleport() end)
toggle(P, "Spam Remote", Config.Exploit, "SpamRemoteEnabled", function(on)
    FX.startSpamRemote() notify(on and "Spam ON" or "Spam OFF", on and Theme.success or Theme.sub)
end)
textInput(P, "Nome do remote", "ex: Give", Config.Exploit, "SpamRemotePath", false)
slider(P, "Delay do spam (s)", Config.Exploit, "SpamRemoteDelay", 0.05, 5, 0.05)

section(P, "remote spy")
toggle(P, "Remote Spy", Config.Exploit, "RemoteSpyEnabled", function(on)
    if on then
        if not hasHook then notify("Executor sem hookmetamethod.", Theme.warning) end
        FX.startRemoteSpy()
    end
    notify(on and "Spy ON" or "Spy OFF")
end)
button(P, "Ultimos 8 remotes", function()
    local log = FX.spyLog
    if #log == 0 then notify("Nenhum remote capturado.") return end
    for i = 1, math.min(8, #log) do task.wait(0.1) notify(string.format("[%s] %s", log[i].method, log[i].remote), Theme.sub, 2.5) end
end)
button(P, "Copiar log do spy", function()
    if type(setclipboard) ~= "function" then notify("Sem clipboard.") return end
    local lines = {}
    for _, e in ipairs(FX.spyLog) do table.insert(lines, string.format("[%.1fs] %s:%s", e.time, e.method, e.remote)) end
    setclipboard(table.concat(lines, "\n"))
    notify("Log copiado ("..#FX.spyLog.." entradas).", Theme.success)
end)
button(P, "Limpar log", function() table.clear(FX.spyLog) notify("Log limpo.") end)

section(P, "dump & webhook")
button(P, "Dumpar scripts (clipboard)", function() FX.doDump() end)
toggle(P, "Webhook logger", Config.Exploit, "WebhookEnabled")
textInput(P, "URL do webhook", "https://discord.com/api/webhooks/...", Config.Exploit, "WebhookURL", false)
button(P, "Testar webhook", function()
    if Config.Exploit.WebhookURL == "" then notify("URL vazia.", Theme.warning) return end
    FX.sendWebhook("Fenix test @ "..os.date("%H:%M:%S"))
    notify("Mensagem de teste enviada.", Theme.success)
end)
end)

safe("Players", function()
local P = plrP
local selected, followActive, followConn, spectateActive = nil, false, nil, false
local function playerNames()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then table.insert(t, p.Name) end end
    table.sort(t)
    return t
end
local function selChar()
    local p = selected and Players:FindFirstChild(selected)
    local ch = p and p.Character
    return ch, ch and ch:FindFirstChild("HumanoidRootPart"), ch and ch:FindFirstChildOfClass("Humanoid")
end
local function need()
    if not selected then notify("Seleciona um jogador primeiro.", Theme.warning) return false end
    return true
end

section(P, "alvo")
do
    local r = rowFrame(P, 34, "Jogador selecionado")
    rowLabel(r, "Jogador selecionado", 190)
    local av = new("ImageLabel", { Size=UDim2.fromOffset(24,24), Position=UDim2.new(1,-168,0.5,-12), BackgroundColor3=Theme.bar, BorderSizePixel=0 }, r)
    corner(av, 12)
    local btn = new("TextButton", {
        Font=FONTS, TextSize=14, Size=UDim2.fromOffset(134,22), Position=UDim2.new(1,-140,0.5,-11),
        BackgroundColor3=Theme.bar, AutoButtonColor=false, BorderSizePixel=0, TextTruncate=Enum.TextTruncate.AtEnd,
        TextColor3=Theme.accent, Text="- nenhum -",
    }, r)
    corner(btn, 3)
    local function pick(d)
        local names = playerNames()
        if #names == 0 then notify("Sem outros jogadores no servidor.", Theme.warning) return end
        local idx = table.find(names, selected) or 0
        selected = names[((idx - 1 + d) % #names) + 1]
        btn.Text = selected
        local p = Players:FindFirstChild(selected)
        if p then task.spawn(function()
            local ok, img = pcall(Players.GetUserThumbnailAsync, Players, p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            if ok and av.Parent then av.Image = img end
        end) end
    end
    track(btn.MouseButton1Click:Connect(function() pick(1) end))
    track(btn.MouseButton2Click:Connect(function() pick(-1) end))
end
section(P, "teleporte")
button(P, "TP para jogador", function()
    if not need() then return end
    local _, tr = selChar() local _, root = myParts()
    if tr and root then root.CFrame = CFrame.new(tr.Position + Vector3.new(0,4,0)) notify("Teleportado para "..selected, Theme.success)
    else notify("Jogador indisponivel.", Theme.warning) end
end)
button(P, "TP furtivo (atras)", function()
    if not need() then return end
    local _, tr = selChar() local _, root = myParts()
    if tr and root then root.CFrame = CFrame.new((tr.CFrame * CFrame.new(0,0,3.5)).Position + Vector3.new(0,2,0)) notify("TP furtivo > "..selected, Theme.success)
    else notify("Jogador indisponivel.", Theme.warning) end
end)
section(P, "controlo")
button(P, "Trazer jogador", function()
    if not need() then return end
    local _, tr = selChar() local _, root = myParts()
    if tr and root then tr.CFrame = CFrame.new(root.Position + Vector3.new(2,0,0)) notify(selected.." trazido.", Theme.success)
    else notify("Jogador indisponivel.", Theme.warning) end
end)
button(P, "Seguir jogador (toggle)", function()
    if not need() then return end
    followActive = not followActive
    if followConn then followConn:Disconnect() followConn = nil end
    if followActive then
        notify("A seguir "..selected, Theme.accent)
        followConn = RunService.Heartbeat:Connect(function()
            local _, tr = selChar() local _, root = myParts()
            if tr and root then
                local target = tr.Position + tr.CFrame.LookVector * -3 + Vector3.new(0,0.5,0)
                root.CFrame = CFrame.new(root.Position:Lerp(target, 0.15))
            end
        end)
    else notify("Seguimento parado.", Theme.sub) end
end)
button(P, "Espiar camera (toggle)", function()
    if not need() then return end
    spectateActive = not spectateActive
    if spectateActive then
        local _, _, hum = selChar()
        if hum then Camera.CameraSubject = hum notify("A espiar "..selected, Theme.accent)
        else notify("Jogador sem personagem.", Theme.warning) spectateActive = false end
    else
        local _, _, myHum = myParts()
        if myHum then Camera.CameraSubject = myHum end
        notify("Camera restaurada.", Theme.sub)
    end
end)
section(P, "informacao")
button(P, "Ver info do jogador", function()
    if not need() then return end
    local p = Players:FindFirstChild(selected)
    if not p then notify("Jogador nao encontrado.", Theme.warning) return end
    local _, root, hum = selChar() local _, myRoot = myParts()
    local dist = (root and myRoot) and math.floor((myRoot.Position - root.Position).Magnitude) or -1
    notify(string.format("%s  (@%s)", p.DisplayName, p.Name), Theme.accent, 4)
    task.wait(0.15)
    notify(string.format("HP: %.0f / %.0f  |  Dist: %dm", hum and hum.Health or 0, hum and hum.MaxHealth or 0, dist), Theme.sub, 4)
    local ls = p:FindFirstChild("leaderstats")
    if ls then for _, v in ipairs(ls:GetChildren()) do task.wait(0.1) notify(v.Name..": "..tostring(v.Value), Theme.text, 3) end end
end)
button(P, "Copiar UserId", function()
    if not need() then return end
    local p = Players:FindFirstChild(selected)
    if p and type(setclipboard) == "function" then setclipboard(tostring(p.UserId)) notify("UserId copiado.", Theme.success)
    else notify("Sem clipboard.", Theme.warning) end
end)
end)

safe("Remotes", function()
local P = remP
section(P, "scanner", 1)
local filterBox
do
    local r = rowFrame(P, 26, "Filtro de remotes")
    rowLabel(r, "Filtro", 0).Size = UDim2.new(0.2, 0, 1, 0)
    filterBox = new("TextBox", {
        PlaceholderText="nome do remote...", Text="", Font=FONT, TextSize=14, TextColor3=Theme.text,
        PlaceholderColor3=Theme.sub, BackgroundColor3=Theme.bar, Position=UDim2.new(0.22,0,0.5,-10),
        Size=UDim2.new(0.78,-4,0,20), ClearTextOnFocus=false, BorderSizePixel=0, TextXAlignment=LEFT,
    }, r)
    corner(filterBox, 3)
    new("UIPadding", { PaddingLeft=UDim.new(0,6) }, filterBox)
end
local countLbl = new("TextLabel", {
    Text="0 remotes", Font=FONT, TextSize=13, TextColor3=Theme.sub, BackgroundTransparency=1,
    Size=UDim2.new(1,0,0,18), TextXAlignment=LEFT, LayoutOrder=order(P.cur),
}, P.cur)
new("UIPadding", { PaddingLeft=UDim.new(0,6) }, countLbl)
local listWrap = new("Frame", {
    Size=UDim2.new(1,0,0,330), BackgroundColor3=Theme.bg, BorderSizePixel=0, LayoutOrder=order(P.cur), ClipsDescendants=true,
}, P.cur)
corner(listWrap, 3)
P.h[P.curCol] += 360
local listSF = new("ScrollingFrame", {
    Size=UDim2.new(1,-4,1,-4), Position=UDim2.fromOffset(2,2), BackgroundTransparency=1, BorderSizePixel=0,
    ScrollBarThickness=3, CanvasSize=UDim2.new(), AutomaticCanvasSize=YAUTO,
}, listWrap)
accentReg(listSF, "ScrollBarImageColor3")
new("UIListLayout", { Padding=UDim.new(0,2), SortOrder=SORT }, listSF)

local cache, rows = {}, {}
local function build()
    for _, r in ipairs(rows) do if r.Parent then r:Destroy() end end
    table.clear(rows)
    local q = string.lower(filterBox.Text)
    local shown = 0
    for _, obj in ipairs(cache) do
        if q == "" or string.find(string.lower(obj.Name), q, 1, true) then
            shown += 1
            if shown > 120 then break end
            local rf = new("Frame", { Size=UDim2.new(1,0,0,26), BackgroundColor3=Theme.panel, BorderSizePixel=0, LayoutOrder=shown }, listSF)
            corner(rf, 3)
            table.insert(rows, rf)
            local isRE = obj:IsA("RemoteEvent")
            local tag = new("TextLabel", {
                Text=isRE and "RE" or "RF", Font=FONTB, TextSize=11,
                TextColor3=isRE and Color3.fromRGB(100,200,255) or Color3.fromRGB(200,150,255),
                BackgroundColor3=Theme.bar, Position=UDim2.fromOffset(4,4), Size=UDim2.fromOffset(22,18), BorderSizePixel=0,
            }, rf)
            corner(tag, 3)
            new("TextLabel", {
                Text=obj.Name, Font=FONT, TextSize=14, TextColor3=Theme.text, BackgroundTransparency=1,
                Position=UDim2.fromOffset(32,0), Size=UDim2.new(1,-118,1,0), TextXAlignment=LEFT, TextTruncate=Enum.TextTruncate.AtEnd,
            }, rf)
            local cp = new("TextButton", {
                Text="copy", Font=FONTB, TextSize=12, TextColor3=Theme.sub, BackgroundColor3=Theme.bar,
                Position=UDim2.new(1,-84,0.5,-9), Size=UDim2.fromOffset(38,18), AutoButtonColor=false, BorderSizePixel=0,
            }, rf)
            corner(cp, 3)
            track(cp.MouseButton1Click:Connect(function()
                if type(setclipboard) == "function" then setclipboard(obj:GetFullName()) notify("Path copiado.", Theme.sub, 1.5) end
            end))
            local fb = new("TextButton", {
                Text="fire", Font=FONTB, TextSize=12, TextColor3=Color3.new(1,1,1), Position=UDim2.new(1,-42,0.5,-9),
                Size=UDim2.fromOffset(38,18), AutoButtonColor=false, BorderSizePixel=0,
            }, rf)
            corner(fb, 3)
            accentReg(fb, "BackgroundColor3")
            track(fb.MouseButton1Click:Connect(function()
                local ok = pcall(function()
                    if obj:IsA("RemoteEvent") then cloneref(obj):FireServer() else cloneref(obj):InvokeServer() end
                end)
                notify((ok and "Fired: " or "Erro: ")..obj.Name, ok and Theme.success or Theme.danger, 1.5)
            end))
        end
    end
    countLbl.Text = shown.." / "..#cache.." remotes"
end
track(filterBox:GetPropertyChangedSignal("Text"):Connect(build))
local function rescan() FX.remotesT = 0 cache = FX.allRemotes() build() end

section(P, "acoes", 2)
button(P, "Escanear agora", function() rescan() notify(#cache.." remotes encontrados.", Theme.success) end)
local auto = false
button(P, "Auto-scan (10s) on/off", function()
    auto = not auto
    notify(auto and "Auto-scan ativo." or "Auto-scan parado.", auto and Theme.accent or Theme.sub)
end)
task.spawn(function()
    task.wait(1.5) rescan()
    while alive do
        task.wait(10)
        if auto and currentTab == "Remotes" then rescan() end
    end
end)
end)

safe("Misc", function()
local P = misP
section(P, "servidor")
toggle(P, "Anti-AFK", Config.Misc, "AntiAFK")
button(P, "Rejoin", function() pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end) end)
button(P, "Server Hop", function()
    if not reqFn then notify("Executor sem suporte a request.") return end
    notify("A procurar servidor...")
    task.spawn(function()
        local ok, res = pcall(reqFn, {
            Url=string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", game.PlaceId),
            Method="GET",
        })
        if not ok or not res or not res.Body then notify("Falha na request.") return end
        local ok2, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
        if not ok2 or type(data) ~= "table" or type(data.data) ~= "table" then notify("Resposta invalida.") return end
        local choices = {}
        for _, s in ipairs(data.data) do
            if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then table.insert(choices, s.id) end
        end
        if #choices == 0 then notify("Sem servidores disponiveis.") return end
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, choices[math.random(#choices)], LocalPlayer) end)
    end)
end)
button(P, "Copiar JobId", function()
    if type(setclipboard) == "function" then setclipboard(game.JobId) notify("JobId copiado.") else notify("Sem clipboard.") end
end)
section(P, "utilitarios")
toggle(P, "Trazer todos os jogadores", Config.Misc, "BringAll", function(on)
    if on then task.spawn(function()
        while Config.Misc.BringAll and alive do pcall(FX.bringAllPlayers) task.wait(1.5) end
    end) end
end)
toggle(P, "Lista de espectadores", Config.Misc, "SpectatorList")
toggle(P, "Sem animacoes", Config.Misc, "NoAnimations")
toggle(P, "Player list (Drawing)", Config.Misc, "PlayerListDraw")
section(P, "item esp")
toggle(P, "Item ESP", Config.Misc, "ItemESP")
textInput(P, "Keyword item ESP", "ex: gem, coin...", Config.Misc, "ItemESPKeyword", false)
section(P, "chat")
toggle(P, "Chat spam", Config.Misc, "ChatSpam", function() FX.startChatSpam() end)
textInput(P, "Mensagem do spam", "mensagem...", Config.Misc, "ChatSpamMsg", false)
slider(P, "Delay do spam (s)", Config.Misc, "ChatSpamDelay", 1, 30, 1)
toggle(P, "Chat logger", Config.Misc, "ChatLogger", function() FX.startChatLogger() end)
button(P, "Ultimas mensagens do chat", function()
    local log = FX.chatLog
    if #log == 0 then notify("Chat log vazio.") return end
    for i = 1, math.min(5, #log) do task.wait(0.1) notify(log[i].plr..": "..log[i].msg, Theme.sub, 3) end
end)
button(P, "Copiar chat log", function()
    if type(setclipboard) ~= "function" then notify("Sem clipboard.") return end
    local lines = {}
    for i = #FX.chatLog, 1, -1 do table.insert(lines, FX.chatLog[i].plr..": "..FX.chatLog[i].msg) end
    setclipboard(table.concat(lines, "\n"))
    notify("Chat log copiado ("..#FX.chatLog.." msgs).", Theme.success)
end)
end)

safe("Config", function()
local P = cfgP
local function applyScale() if menuOpen then mainScale.Scale = FX.calcScale() end end
section(P, "aparencia")
cycle(P, "Cor do menu", Config.Menu, "Accent", AccentNames, function(name)
    Theme.accent = Accents[name] or Accents.Fenix
    refreshAll()
end)
toggle(P, "Rainbow accent", Config.Menu, "RainbowAccent")
slider(P, "Velocidade do rainbow", Config.Menu, "RainbowSpeed", 0.5, 8, 0.5)
toggle(P, "Marca de agua", Config.Menu, "Watermark", function(on) FX.wm.Visible = on end)
toggle(P, "Mostrar dicas", Config.Menu, "ShowTips", function() refreshAll() end)
slider(P, "Tamanho do menu", Config.Menu, "Scale", 0.7, 1.3, 0.05, applyScale)
section(P, "teclas")
keybind(P, "Tecla para abrir/fechar", Config.Menu, "Key", function() refreshAll() end)
note(P, "Ctrl+F pesquisa  |  Ctrl+Setas muda de tab  |  botao direito nos seletores volta atras.")
section(P, "ficheiros")
button(P, "Guardar configuracao", function()
    local ok = saveConfig()
    notify(ok and "Configuracao guardada." or "Executor sem acesso a ficheiros.", ok and Theme.success or Theme.warning)
end)
button(P, "Carregar configuracao", function()
    if loadConfig() then
        FX.wm.Visible = Config.Menu.Watermark aiming = false
        refreshAll() FX.applyAll() applyScale()
        notify("Configuracao carregada.", Theme.success)
    else notify("Nenhuma configuracao encontrada.") end
end)
button(P, "Exportar (clipboard)", function()
    if type(setclipboard) == "function" then setclipboard(HttpService:JSONEncode(Config)) notify("Config copiada.", Theme.success)
    else notify("Sem suporte a clipboard.") end
end)
if type(getclipboard) == "function" then
    button(P, "Importar (clipboard)", function()
        local ok, data = pcall(function() return HttpService:JSONDecode(getclipboard()) end)
        if ok and applyData(data) then
            FX.wm.Visible = Config.Menu.Watermark aiming = false
            refreshAll() FX.applyAll() applyScale()
            notify("Config importada.", Theme.success)
        else notify("Clipboard invalido.", Theme.warning) end
    end)
end
button(P, "Apagar ficheiro de config", function()
    local ok = pcall(function() if isfile and isfile(CONFIG_PATH) then delfile(CONFIG_PATH) end end)
    notify(ok and "Ficheiro apagado." or "Nao foi possivel apagar.", ok and Theme.success or Theme.warning)
end, Theme.danger)
section(P, "sistema")
do
    local function flag(label, ok) note(P, label .. (ok and ": ok" or ": INDISPONIVEL")) end
    local r1 = rowFrame(P, 24) rowLabel(r1, "Drawing API: "..(hasDrawing and "ok" or "indisponivel"), 12)
    local r2 = rowFrame(P, 24) rowLabel(r2, "Ficheiros: "..(hasFS and "ok" or "indisponivel"), 12)
    local r3 = rowFrame(P, 24) rowLabel(r3, "hookmetamethod: "..(hasHook and "ok" or "indisponivel"), 12)
    local r4 = rowFrame(P, 24) rowLabel(r4, "mouse1click: "..(FX.clickFn and "ok" or "indisponivel"), 12)
end
button(P, "Descarregar Fenix", function() notify("A descarregar...") task.wait(0.3) cleanup() end, Theme.danger)
end)

-- ─── arranque do menu ───────────────────────────────────────────────────────
FX.closeMenu = function() setMenu(false) end
reg(function() styleTabs(0) end)
setTab("Aimbot")
FX.menuReady = true

end)()

print("[Fenix] 3/4 menu construido")

-- ─── FX helpers pos-menu ─────────────────────────────────────────────────────

function FX.restoreReach()
    for h, o in pairs(FX.reachOrig) do
        if h.Parent then pcall(function() h.Size=o[1] h.Massless=o[2] end) end
        FX.reachOrig[h]=nil
    end
end

function FX.updateReach()
    local c=Config.Combat
    if not c.ReachEnabled and not next(FX.reachOrig) then return end
    local ch=LocalPlayer.Character
    local tool=ch and ch:FindFirstChildOfClass("Tool")
    local handle=tool and tool:FindFirstChild("Handle")
    if not c.ReachEnabled or not handle or not handle:IsA("BasePart") then
        if next(FX.reachOrig) then FX.restoreReach() end
        return
    end
    if not FX.reachOrig[handle] then
        FX.restoreReach()
        FX.reachOrig[handle]={ handle.Size, handle.Massless }
    end
    local sz=c.ReachSize
    handle.Size=Vector3.new(sz,sz,sz)
    handle.Massless=true
end

function FX.updateNoAnim()
    if not Config.Misc.NoAnimations then return end
    local ch=LocalPlayer.Character
    local hum=ch and ch:FindFirstChildOfClass("Humanoid")
    local anim=hum and hum:FindFirstChildOfClass("Animator")
    if anim then
        for _, t in ipairs(anim:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end
    end
end

function FX.applyAll()
    local list={
        startKillAura, FX.startAutoFarm, FX.startInfMoney, FX.startAutoSell, FX.startAutoQuest,
        FX.startAutoRebirth, FX.startAutoClick, FX.startSpamRemote, FX.startChatLogger,
        FX.startGodMode, FX.startSmartFarm, FX.startFreeze,
        function() applyWireframe(Config.Visual.Wireframe) end,
        function() if Config.Exploit.RemoteSpyEnabled then FX.startRemoteSpy() end end,
        function() if Config.Combat.AntiReport then FX.startAntiReport() end end,
        function() if Config.Aimbot.SilentMoveTo then FX.ensureMoveToHook() end end,
    }
    for _, fn in ipairs(list) do pcall(fn) end
end

-- ─── velocidade / aceleracao por jogador (dead reckoning) ────────────────────
function FX.trackVel(dt)
    if not Config.Aimbot.DeadReckoning then return end
    dt = math.max(dt, 1/240)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local ch = plr.Character
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = root.AssemblyLinearVelocity
                local d = FX.velData[plr]
                if d then
                    local acc = (vel - d.vel) / dt
                    if acc.Magnitude > 200 then acc = acc.Unit * 200 end
                    d.acc = d.acc:Lerp(acc, 0.3)
                    d.vel = vel
                else
                    FX.velData[plr] = { vel=vel, acc=Vector3.zero }
                end
            end
        end
    end
end

function FX.aimPointDR(part, plr, c)
    local d = plr and FX.velData[plr]
    local vel = part.AssemblyLinearVelocity
    local acc = d and d.acc or Vector3.zero
    local ping = 0
    pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
    local t = ping + 0.05
    return part.Position + vel * t + acc * (t * t * 0.5)
end

-- ─── backtrack ───────────────────────────────────────────────────────────────
local BT_BONES = {"Head","HumanoidRootPart","UpperTorso","Torso"}

function FX.recordBT()
    if not Config.Aimbot.Backtrack then return end
    local now = os.clock()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local ch = plr.Character
            if ch then
                local frame = {t=now, b={}}
                for _, bn in ipairs(BT_BONES) do
                    local p = ch:FindFirstChild(bn)
                    if p and p:IsA("BasePart") then frame.b[bn] = p.Position end
                end
                local buf = FX.btData[plr]
                if not buf then buf = {} FX.btData[plr] = buf end
                table.insert(buf, 1, frame)
                while #buf > Config.Aimbot.BacktrackFrames do table.remove(buf) end
            end
        end
    end
end

function FX.getBTPos(plr)
    local buf = FX.btData[plr]
    if not buf or #buf == 0 then return nil end
    local ping = 0
    pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000 end)
    local tgt  = os.clock() - ping - 0.016
    local best, bestD = buf[1], math.huge
    for _, f in ipairs(buf) do
        local d = math.abs(f.t - tgt)
        if d < bestD then best, bestD = f, d end
    end
    local bone = Config.Aimbot.Part == "Head" and "Head" or "HumanoidRootPart"
    return best.b[bone] or best.b["HumanoidRootPart"]
end

-- ─── silent aim via MoveTo ───────────────────────────────────────────────────
function FX.ensureMoveToHook()
    if FX.moveToHooked or type(hookfunction) ~= "function" or not hasHook then return end
    FX.moveToHooked = true
    local function hookHum(ch)
        if not ch then return end
        local hum = ch:WaitForChild("Humanoid", 5)
        if not hum then return end
        pcall(function()
            local orig
            orig = hookfunction(hum.MoveTo, newcclosure(function(self, pos, part)
                if alive and Config.Aimbot.SilentMoveTo and silentPart then
                    return orig(self, silentPart.Position, part)
                end
                return orig(self, pos, part)
            end))
        end)
    end
    task.spawn(hookHum, LocalPlayer.Character)
    track(LocalPlayer.CharacterAdded:Connect(function(ch) task.spawn(hookHum, ch) end))
end

-- ─── off-screen arrows ───────────────────────────────────────────────────────
function FX.healthCol(ratio)
    if ratio >= 0.5 then
        return Color3.fromRGB(255,220,60):Lerp(Color3.fromRGB(80,255,120), (ratio - 0.5) * 2)
    end
    return Color3.fromRGB(255,70,70):Lerp(Color3.fromRGB(255,220,60), ratio * 2)
end

function FX.updateOffScreen()
    local c = Config.ESP
    if not hasDrawing or not c.Enabled or not c.OffScreen then
        for _, a in pairs(FX.osArrows) do
            if a.dot  then pcall(function() a.dot.Visible  = false end) end
            if a.line then pcall(function() a.line.Visible = false end) end
            if a.lbl  then pcall(function() a.lbl.Visible  = false end) end
        end
        return
    end
    local vp     = Camera.ViewportSize
    local cx, cy = vp.X / 2, vp.Y / 2
    local margin = 22
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local ch   = plr.Character
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            local hum  = ch and ch:FindFirstChildOfClass("Humanoid")
            if root and hum and hum.Health > 0 and not (c.TeamCheck and sameTeam(plr)) then
                local sp, on = Camera:WorldToViewportPoint(root.Position)
                if not FX.osArrows[plr] then
                    FX.osArrows[plr] = {
                        dot  = newDrawObj("Circle", {Filled=true, Radius=5, NumSides=16, Visible=false}),
                        line = newDrawObj("Line",   {Thickness=2, Visible=false}),
                        lbl  = newDrawObj("Text",   {Size=11, Center=true, Outline=true, Visible=false}),
                    }
                end
                local a = FX.osArrows[plr]
                if not a.dot then continue end
                if on then
                    a.dot.Visible = false a.line.Visible = false
                    if a.lbl then a.lbl.Visible = false end
                else
                    local dir = Vector2.new(sp.X - cx, sp.Y - cy)
                    if sp.Z < 0 then dir = -dir end
                    local ang = math.atan2(dir.Y, dir.X)
                    local dx, dy = math.cos(ang), math.sin(ang)
                    local tx = dx ~= 0 and math.abs((vp.X/2 - margin) / dx) or math.huge
                    local ty = dy ~= 0 and math.abs((vp.Y/2 - margin) / dy) or math.huge
                    local t  = math.min(tx, ty)
                    local bx = math.clamp(cx + dx * t, margin, vp.X - margin)
                    local by = math.clamp(cy + dy * t, margin, vp.Y - margin)
                    local sz = c.OffScreenSize
                    local ratio = hum.Health / math.max(hum.MaxHealth, 1)
                    local col = c.HealthColor and FX.healthCol(ratio)
                        or ((c.TeamColors and plr.Team) and plr.TeamColor.Color or Theme.accent)
                    a.dot.Position = Vector2.new(bx, by) a.dot.Radius = sz * 0.45 a.dot.Color = col a.dot.Visible = true
                    a.line.From = Vector2.new(bx, by) a.line.To = Vector2.new(bx + dx * sz, by + dy * sz)
                    a.line.Color = col a.line.Visible = true
                    if a.lbl then
                        local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
                        a.lbl.Text = plr.DisplayName .. " " .. dist .. "m"
                        a.lbl.Position = Vector2.new(bx, by - sz - 12)
                        a.lbl.Color = col a.lbl.Visible = true
                    end
                end
            else
                local a = FX.osArrows[plr]
                if a then
                    if a.dot  then a.dot.Visible  = false end
                    if a.line then a.line.Visible = false end
                    if a.lbl  then a.lbl.Visible  = false end
                end
            end
        end
    end
end

-- ─── material chams ──────────────────────────────────────────────────────────
function FX.updateMatChams()
    local c = Config.ESP
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local ch  = plr.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if ch and hum then
                if c.Enabled and c.MaterialChams and not (c.TeamCheck and sameTeam(plr)) then
                    local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
                    local col   = c.HealthColor and FX.healthCol(ratio) or Theme.accent
                    for _, p in ipairs(ch:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                            if not FX.matChams[p] then FX.matChams[p] = {p.Material, p.Color, p.Transparency} end
                            p.Material = Enum.Material.Neon
                            p.Color = col
                            p.Transparency = c.MatTransparency
                        end
                    end
                else
                    for _, p in ipairs(ch:GetDescendants()) do
                        local o = FX.matChams[p]
                        if o and p.Parent then
                            pcall(function() p.Material=o[1] p.Color=o[2] p.Transparency=o[3] end)
                            FX.matChams[p] = nil
                        end
                    end
                end
            end
        end
    end
end

-- ─── item tracers ────────────────────────────────────────────────────────────
function FX.updateItemTracers()
    if not hasDrawing or not Config.ESP.ItemTracers then
        for _, l in ipairs(FX.itemTr) do pcall(function() l:Remove() end) end
        FX.itemTr = {}
        return
    end
    local _, root = myParts()
    if not root then return end
    local found = FX.itemFound or {}
    while #FX.itemTr < #found do
        local l = newDrawObj("Line", {Thickness=1, Color=Color3.fromRGB(255,180,50), Visible=false})
        if not l then break end
        table.insert(FX.itemTr, l)
    end
    local vp = Camera.ViewportSize
    local msp, mon = Camera:WorldToViewportPoint(root.Position)
    local origin = mon and Vector2.new(msp.X, msp.Y) or Vector2.new(vp.X/2, vp.Y)
    for i, info in ipairs(found) do
        local l = FX.itemTr[i]
        if not l then break end
        local sp, on = Camera:WorldToViewportPoint(info.pos)
        if on then l.From = origin l.To = Vector2.new(sp.X, sp.Y) l.Visible = true else l.Visible = false end
    end
    for i = #found + 1, #FX.itemTr do FX.itemTr[i].Visible = false end
end

-- ─── ping graph ──────────────────────────────────────────────────────────────
local PING_CAP = 30
function FX.updatePingGraph()
    if not hasDrawing or not Config.Visual.PingGraph then
        for _, l in ipairs(FX.pingLines) do pcall(function() l:Remove() end) end
        FX.pingLines = {}
        return
    end
    local now = os.clock()
    if now - FX.pingLastT > 0.5 then
        FX.pingLastT = now
        local ping = 0
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        table.insert(FX.pingHist, 1, ping)
        if #FX.pingHist > PING_CAP then table.remove(FX.pingHist) end
    end
    if #FX.pingHist < 2 then return end
    local W, H = 100, 36
    local vp   = Camera.ViewportSize
    local ox, oy = vp.X - W - 8, 48
    local maxP = 200
    for _, v in ipairs(FX.pingHist) do if v > maxP then maxP = v end end
    while #FX.pingLines < #FX.pingHist - 1 do
        local l = newDrawObj("Line", {Thickness=1, Visible=false})
        if not l then break end
        table.insert(FX.pingLines, l)
    end
    for i = 1, #FX.pingHist - 1 do
        local l = FX.pingLines[i]
        if not l then break end
        local p1, p2 = FX.pingHist[i], FX.pingHist[i+1]
        l.From = Vector2.new(ox + (i-1)/(PING_CAP-1)*W, oy + H - (p1/maxP)*H)
        l.To   = Vector2.new(ox + i/(PING_CAP-1)*W,     oy + H - (p2/maxP)*H)
        l.Color = Color3.fromRGB(255, math.floor((1 - math.clamp(p1/300, 0, 1)) * 200), 50)
        l.Visible = true
    end
    for i = #FX.pingHist, #FX.pingLines do FX.pingLines[i].Visible = false end
end

-- ─── dynamic fov ─────────────────────────────────────────────────────────────
function FX.updateDynFOV(dt)
    local v = Config.Visual
    if not v.DynamicFOV then return end
    local _, root = myParts()
    if not root then return end
    local spd = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude
    local tgt = spd > 2 and v.DynFOVMax or v.DynFOVMin
    Camera.FieldOfView = Camera.FieldOfView + (tgt - Camera.FieldOfView) * math.min(dt * 5, 1)
end

-- ─── hotkey hud ──────────────────────────────────────────────────────────────
local HUD_DEFS = {
    {"Fly",    function() return Config.Move.Fly         end},
    {"Speed",  function() return Config.Move.Speed       end},
    {"ESP",    function() return Config.ESP.Enabled      end},
    {"Aim",    function() return Config.Aimbot.Enabled   end},
    {"Noclip", function() return Config.Move.Noclip      end},
    {"God",    function() return Config.Combat.GodMode   end},
    {"BT",     function() return Config.Aimbot.Backtrack end},
}

function FX.updateHUD()
    if not hasDrawing then return end
    local show = Config.Visual.HotkeyHUD
    while #FX.hudLines < #HUD_DEFS do
        local l = newDrawObj("Text", {Size=12, Outline=true, Visible=false})
        if not l then break end
        table.insert(FX.hudLines, l)
    end
    local vp = Camera.ViewportSize
    local y  = vp.Y - (#HUD_DEFS * 16) - 8
    for i, def in ipairs(HUD_DEFS) do
        local l = FX.hudLines[i]
        if not l then break end
        if show then
            local on = def[2]()
            l.Text = def[1] .. ": " .. (on and "ON" or "OFF")
            l.Color = on and Color3.fromRGB(80,255,120) or Color3.fromRGB(130,130,145)
            l.Position = Vector2.new(6, y + (i-1) * 16)
            l.Visible = true
        else
            l.Visible = false
        end
    end
end

-- ─── god mode / freeze / anti-report / dupe ──────────────────────────────────
function FX.startGodMode()
    if FX.godConn then FX.godConn:Disconnect() FX.godConn = nil end
    if not Config.Combat.GodMode then return end
    FX.godConn = RunService.Heartbeat:Connect(function()
        local _, _, hum = myParts()
        if hum then pcall(function() hum.Health = hum.MaxHealth end) end
    end)
end

function FX.startFreeze()
    if FX.freezeConn then FX.freezeConn:Disconnect() FX.freezeConn = nil end
    local c = Config.Combat
    if not c.FreezePlayer or c.FreezeTarget == "" then return end
    FX.freezeConn = RunService.Heartbeat:Connect(function()
        local plr  = Players:FindFirstChild(c.FreezeTarget)
        local root = plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                root.AssemblyLinearVelocity  = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
end

function FX.startAntiReport()
    if FX.arHooked or not hasHook then return end
    FX.arHooked = true
    local KW = {"report","votekick","kick","abuse","ban","flag","warn"}
    pcall(function()
        local oldNC
        oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if alive and Config.Combat.AntiReport and not checkcaller() then
                local m = getnamecallmethod and getnamecallmethod() or ""
                if m == "FireServer" or m == "InvokeServer" then
                    local ok, is = pcall(function() return self:IsA("RemoteEvent") or self:IsA("RemoteFunction") end)
                    if ok and is then
                        local nm = string.lower(self.Name)
                        for _, kw in ipairs(KW) do
                            if nm:find(kw) then return nil end
                        end
                    end
                end
            end
            return oldNC(self, ...)
        end))
    end)
end

function FX.doToolDupe()
    local ch   = LocalPlayer.Character
    local tool = ch and ch:FindFirstChildOfClass("Tool")
    if not tool then notify("Sem tool equipada.", Theme.warning) return end
    tool:Clone().Parent = LocalPlayer.Backpack
    pcall(function()
        for _, r in ipairs(FX.allRemotes()) do
            local nm = string.lower(r.Name)
            if nm:find("equip") or nm:find("give") or nm:find("tool") then
                cloneref(r):FireServer(tool.Name)
                break
            end
        end
    end)
    notify("Duplicada: " .. tool.Name, Theme.success)
end

-- ─── smart farm ──────────────────────────────────────────────────────────────
function FX.startSmartFarm()
    if FX.sfConn then FX.sfConn:Disconnect() FX.sfConn = nil end
    local c = Config.Exploit
    if not c.SmartFarm then return end
    FX.sf.remotes = FX.allRemotes()
    FX.sf.idx, FX.sf.lastVal, FX.sf.lastT = 1, nil, os.clock()
    local lastFire = 0
    FX.sfConn = RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - lastFire < math.max(c.AutoFarmDelay, 0.1) then return end
        lastFire = now
        local ls  = LocalPlayer:FindFirstChild("leaderstats")
        local cur = nil
        if ls then
            for _, v in ipairs(ls:GetChildren()) do
                if v:IsA("NumberValue") or v:IsA("IntValue") then cur = (cur or 0) + v.Value end
            end
        end
        if cur ~= FX.sf.lastVal then
            FX.sf.lastVal, FX.sf.lastT = cur, now
        elseif now - FX.sf.lastT > c.SmartFarmWindow then
            FX.sf.idx   = (FX.sf.idx % math.max(#FX.sf.remotes, 1)) + 1
            FX.sf.lastT = now
            local r = FX.sf.remotes[FX.sf.idx]
            if r then notify("Smart Farm > " .. r.Name, Theme.accent, 1.5) end
        end
        if #FX.sf.remotes == 0 then return end
        local r = FX.sf.remotes[FX.sf.idx]
        if r and r.Parent then
            pcall(function()
                if r:IsA("RemoteEvent") then cloneref(r):FireServer()
                else cloneref(r):InvokeServer() end
            end)
        else
            FX.sf.remotes = FX.allRemotes()
        end
    end)
end

-- ─── script dumper ───────────────────────────────────────────────────────────
function FX.doDump()
    if type(setclipboard) ~= "function" then notify("Sem clipboard.") return end
    local lines = {"-- Fenix Dump @ " .. os.date("%H:%M:%S"), ""}
    local n = 0
    local function tryInfo(s)
        local info = ""
        if type(getscriptbytecode) == "function" then
            local ok, bc = pcall(getscriptbytecode, s)
            if ok and bc and #bc > 0 then info = "[bc:" .. #bc .. "b]" end
        end
        if type(getsenv) == "function" then
            local ok, e = pcall(getsenv, s)
            if ok and type(e) == "table" then
                local ks = {}
                for k in pairs(e) do table.insert(ks, tostring(k)) end
                info = info .. " env:{" .. table.concat(ks, ",") .. "}"
            end
        end
        return info
    end
    if type(getloadedmodules) == "function" then
        local ok, mods = pcall(getloadedmodules)
        if ok and mods then
            for _, m in ipairs(mods) do
                if n >= 80 then break end
                local nm = ""
                pcall(function() nm = m:GetFullName() end)
                if nm == "" then nm = tostring(m) end
                table.insert(lines, "[M] " .. nm .. " " .. tryInfo(m))
                n += 1
            end
        end
    end
    pcall(function()
        for _, v in ipairs(game:GetDescendants()) do
            if n >= 150 then break end
            if v:IsA("LocalScript") or v:IsA("ModuleScript") then
                local info = tryInfo(v)
                if info ~= "" then table.insert(lines, "[S] " .. v:GetFullName() .. " " .. info) n += 1 end
            end
        end
    end)
    setclipboard(table.concat(lines, "\n"))
    notify("Dump: " .. n .. " scripts copiados.", Theme.success)
end

-- ─── webhook ─────────────────────────────────────────────────────────────────
function FX.sendWebhook(text)
    if not Config.Exploit.WebhookEnabled or Config.Exploit.WebhookURL == "" or not reqFn then return end
    table.insert(FX.webhookQ, "[" .. os.date("%H:%M:%S") .. "] " .. text)
end

task.spawn(function()
    while alive do
        task.wait(5)
        if Config.Exploit.WebhookEnabled and Config.Exploit.WebhookURL ~= "" and reqFn and #FX.webhookQ > 0 then
            local msgs = {}
            for i = 1, math.min(#FX.webhookQ, 10) do table.insert(msgs, table.remove(FX.webhookQ, 1)) end
            pcall(reqFn, {
                Url=Config.Exploit.WebhookURL, Method="POST",
                Headers={["Content-Type"]="application/json"},
                Body=HttpService:JSONEncode({ content=string.sub(table.concat(msgs, "\n"), 1, 1990), username="Fenix Logger" }),
            })
        end
    end
end)

-- ─── stream proof ────────────────────────────────────────────────────────────
function FX.applyStreamProof(on)
    if type(setwindowdisplayaffinity) == "function" then
        pcall(setwindowdisplayaffinity, on and 17 or 0)
        notify(on and "Stream Proof ON (nativo)." or "Stream Proof OFF.", on and Theme.success or Theme.sub)
    else
        pcall(function() gui.DisplayOrder = on and 2147483647 or 999 end)
        notify(on and "Stream Proof ON (compatibilidade)." or "Stream Proof OFF.", Theme.warning)
    end
end

-- ─── player list drawing ─────────────────────────────────────────────────────
function FX.updatePlrList()
    if not hasDrawing or not Config.Misc.PlayerListDraw then
        for _, l in ipairs(FX.plrListLines) do pcall(function() l:Remove() end) end
        FX.plrListLines = {}
        return
    end
    local now = os.clock()
    if now - FX.plrListT < 2 then return end
    FX.plrListT = now
    local plrs = Players:GetPlayers()
    while #FX.plrListLines < #plrs + 1 do
        local l = newDrawObj("Text", {Size=11, Outline=true, Visible=false})
        if not l then break end
        table.insert(FX.plrListLines, l)
    end
    local vp = Camera.ViewportSize
    local x, y, rh = vp.X - 295, 90, 14
    local _, myRoot = myParts()
    local h = FX.plrListLines[1]
    if h then
        h.Text = string.format("%-15s %5s %5s %10s", "Nome", "HP%", "Dist", "Tool")
        h.Position = Vector2.new(x, y) h.Color = Theme.accent h.Visible = true
    end
    for i, plr in ipairs(plrs) do
        local l = FX.plrListLines[i + 1]
        if not l then break end
        local ch   = plr.Character
        local hum  = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        local tool = ch and ch:FindFirstChildOfClass("Tool")
        local hp   = hum and math.floor(hum.Health / math.max(hum.MaxHealth, 1) * 100) or 0
        local dist = (root and myRoot) and math.floor((myRoot.Position - root.Position).Magnitude) or -1
        l.Text = string.format("%-15s %4d%% %4dm %-10s", string.sub(plr.DisplayName, 1, 14), hp, dist,
            tool and string.sub(tool.Name, 1, 9) or "-")
        l.Position = Vector2.new(x, y + i * rh)
        l.Color = plr == LocalPlayer and Theme.accent or ((hum and hum.Health <= 0) and Theme.sub or Theme.text)
        l.Visible = true
    end
    for i = #plrs + 2, #FX.plrListLines do FX.plrListLines[i].Visible = false end
end

-- ─── render loop extra ───────────────────────────────────────────────────────
local function patchFrame(dt)
    if not alive then return end
    dt = (type(dt)=="number" and dt>0) and dt or 1/60
    pcall(FX.trackVel, dt)
    pcall(FX.recordBT)
    pcall(FX.updateOffScreen)
    pcall(FX.updateMatChams)
    pcall(FX.updateItemTracers)
    pcall(FX.updatePingGraph)
    pcall(FX.updateDynFOV, dt)
    pcall(FX.updateHUD)
    pcall(FX.updatePlrList)
end
if not pcall(function()
    RunService:BindToRenderStep("FenixV6Patch", Enum.RenderPriority.Camera.Value + 2, patchFrame)
end) then
    track(RunService.Heartbeat:Connect(patchFrame))
end

-- ─── restore / cleanup ───────────────────────────────────────────────────────
local function restoreAll()
    restoreHitboxes()
    if fbApplied    then restoreFullbright() end
    if fogApplied   then restoreFog() end
    if fovOrig      then Camera.FieldOfView=fovOrig fovOrig=nil end
    if gravApplied  then Workspace.Gravity=origGravity gravApplied=false end
    if flyActive then
        local _,root,hum=myParts()
        if hum  then hum.PlatformStand=false end
        if root then root.AssemblyLinearVelocity=Vector3.zero end
        flyActive=false
    end
    applyWireframe(false)
    FX.restoreReach()
    if tpActive and FX.tpOrig then
        pcall(function()
            LocalPlayer.CameraMinZoomDistance=FX.tpOrig[1]
            LocalPlayer.CameraMaxZoomDistance=FX.tpOrig[2]
        end)
    end
    if FX.ltApplied then FX.ltApplied=false restoreFullbright() end
    if killAuraConn then killAuraConn:Disconnect() killAuraConn=nil end
    pcall(FX.stopExploit)
    pcall(FX.stopMisc)
    pcall(function() RunService:UnbindFromRenderStep("FenixV6Patch") end)
    for _, k in ipairs({"godConn","freezeConn","sfConn"}) do
        if FX[k] then pcall(function() FX[k]:Disconnect() end) FX[k]=nil end
    end
    for _, a in pairs(FX.osArrows) do
        for _, k in ipairs({"dot","line","lbl"}) do
            if a[k] then pcall(function() a[k]:Remove() end) end
        end
    end
    for _, list in ipairs({FX.hudLines, FX.pingLines, FX.itemTr, FX.plrListLines}) do
        for _, l in ipairs(list) do pcall(function() l:Remove() end) end
    end
    for p, o in pairs(FX.matChams) do
        if p.Parent then pcall(function() p.Material=o[1] p.Color=o[2] p.Transparency=o[3] end) end
    end
end

function cleanup()
    alive=false
    pcall(function() RunService:UnbindFromRenderStep("FenixV6Frame") end)
    pcall(function() RunService:UnbindFromRenderStep("FenixMouse") end)
    pcall(FX.releaseMouse)
    pcall(restoreAll)
    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    table.clear(connections)
    for plr in pairs(espObjects) do removeESP(plr) end
    if fovCircle then pcall(function() fovCircle:Remove() end) end
    for _, l in ipairs(crossLines) do pcall(function() l:Remove() end) end
    for _, d in ipairs({radarBG,radarBorder,radarMe}) do
        if d then pcall(function() d:Remove() end) end
    end
    if gui and gui.Parent then pcall(function() gui:Destroy() end) end
    env.FenixCleanup=nil
end
env.FenixCleanup=cleanup

-- ─── input ───────────────────────────────────────────────────────────────────
track(UIS.InputBegan:Connect(function(i,gp)
    local name=inputName(i)
    if FX.listening then
        if i.KeyCode==Enum.KeyCode.Escape then FX.listening("None")
        elseif name then FX.listening(name) end
        return
    end
    if not name then return end

    -- atalhos do menu (funcionam mesmo se o jogo "apanhar" a tecla)
    if name==Config.Menu.Key and not UIS:GetFocusedTextBox() then
        FX.setMenu(not menuOpen)
        return
    end
    if menuOpen then
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) and not UIS:GetFocusedTextBox() then
            if name=="F" then FX.focusSearch() return end
            if name=="Right" then FX.cycleTab(1) return end
            if name=="Left"  then FX.cycleTab(-1) return end
        end
        return -- com o menu aberto nenhum atalho do jogo/cheat dispara
    end
    if gp then return end

    for _, b in ipairs(FX.binds) do
        if b.tbl[b.bk]==name then
            b.flip()
            notify(b.label..(b.tbl[b.key] and " ON" or " OFF"))
        end
    end
    local c=Config.Aimbot
    if name==c.Key then
        if c.Mode=="Toggle" then aiming=not aiming
        elseif c.Mode=="Hold" then aiming=true end
    end
    if name=="MouseButton1" and Config.Move.ClickTP and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        pcall(clickTeleport)
    end
end))

track(UIS.InputEnded:Connect(function(i)
    if Config.Aimbot.Mode=="Hold" and inputName(i)==Config.Aimbot.Key then aiming=false end
end))

-- ─── rainbow ─────────────────────────────────────────────────────────────────
local function updateRainbow(dt)
    if not Config.Menu.RainbowAccent then return end
    FX.hue=(FX.hue+dt*Config.Menu.RainbowSpeed/6)%1
    FX.rbT=FX.rbT+dt
    if FX.rbT<0.08 then return end
    FX.rbT=0
    Theme.accent=Color3.fromHSV(FX.hue,1,1)
    for _, f in ipairs(FX.live) do pcall(f) end
end

-- ─── frame loop ──────────────────────────────────────────────────────────────
local function onFrame(dt)
    if type(dt)~="number" or dt<=0 then dt=1/60 end
    Camera=Workspace.CurrentCamera
    if not Camera or not alive then return end
    local now=os.clock()
    pcall(updateAimbot,dt)
    pcall(updateTrigger)
    pcall(updateESP)
    pcall(updateMove,dt)
    pcall(updateHitbox)
    pcall(updateVisual)
    pcall(FX.updateWatermark,dt)
    pcall(updateRainbow,dt)
    if Config.Exploit.AutoCollect and now-FX.acLastRun>=1.0 then
        FX.acLastRun=now
        pcall(FX.doAutoCollect)
    end
    pcall(FX.updateSpectatorList)
    pcall(FX.updateItemESP)
    pcall(FX.updateReach)
    pcall(FX.updateNoAnim)
end

if not pcall(function()
    RunService:BindToRenderStep("FenixV6Frame",Enum.RenderPriority.Camera.Value+1,onFrame)
end) then
    track(RunService.Heartbeat:Connect(onFrame))
end

-- ─── init ────────────────────────────────────────────────────────────────────
for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
track(Players.PlayerAdded:Connect(createESP))
track(Players.PlayerRemoving:Connect(function(p)
    removeESP(p)
    FX.velData[p]=nil FX.btData[p]=nil
    local a=FX.osArrows[p]
    if a then
        for _, k in ipairs({"dot","line","lbl"}) do if a[k] then pcall(function() a[k]:Remove() end) end end
        FX.osArrows[p]=nil
    end
    if lockedPlr==p then lockedPlr=nil end
end))

Config.Misc.ChatSpam=false
Config.Misc.BringAll=false
FX.wm.Visible=Config.Menu.Watermark
FX.applyAll()
FX.refreshAll()
FX.setMenu(true)

notify(string.format("Fenix v6 carregado. Ola, %s.", LocalPlayer.DisplayName), Theme.accent, 4)
notify("Abrir/fechar: "..Config.Menu.Key.."  |  Ctrl+F pesquisa", Theme.sub, 4)

print("[Fenix] 4/4 pronto")

end, debug.traceback)
if not __ok then __showError(__err) end