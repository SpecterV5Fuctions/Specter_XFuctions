            --// Carrega a whitelist externa
        local success, listas = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/SpecterV5Fuctions/Specter_XFuctions/main/whitelist.lua"))()
        end)

        if not success or type(listas) ~= "table" then
            warn("Não foi possível carregar a whitelist.")
            return
        end

        --// Referência ao jogador
        local player = game.Players.LocalPlayer
        local userId = player.UserId

        --// Verificação de blacklist
        if listas.blacklist and listas.blacklist[userId] then
            player:Kick("Você está na blacklist. Entre em contato conosco no Discord.")
            return
        end

        --// Verificação de whitelist
        if not (
            (listas.whitelist and listas.whitelist[userId]) or
            (listas.whitelistAdmin and listas.whitelistAdmin[userId]) or
            (listas.whitelistOwner and listas.whitelistOwner[userId])
        ) then
            player:Kick("Você não está na whitelist.")
            return
        end

        --// Detecta Executor
        local function getExecutor()
            local executor = "Desconhecido"
            if syn and syn.protect_gui then
                executor = "Synapse X"
            elseif KRNL_LOADED then
                executor = "KRNL"
            elseif is_sirhurt_closure or pebc_execute then
                executor = "Sirhurt"
            elseif is_fluxus then
                executor = "Fluxus"
            elseif DELTA_LOADED then
                executor = "Delta"
            elseif SWIFT_LOADED then
                executor = "Swift"
            elseif XENO_LOADED then
                executor = "Xeno"
            elseif WAVE_LOADED then
                executor = "Wave"
            elseif KATZEN_LOADED then
                executor = "Katzen"
            elseif identifyexecutor and type(identifyexecutor) == "function" then
                local ok, result = pcall(identifyexecutor)
                if ok and type(result) == "string" then
                    executor = result
                end
            end
            return executor
        end

        --// Mostra loading
        local function showLoading(executor)
            local player = game.Players.LocalPlayer
            local gui = Instance.new("ScreenGui", game.CoreGui)
            gui.Name = "SpecterLoading"
            gui.ResetOnSpawn = false
            local frame = Instance.new("Frame", gui)
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Position = UDim2.new(0.5, 0, 0.5, 0)
            frame.Size = UDim2.new(0, 0, 0, 0)
            frame.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)
            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = Color3.fromRGB(255, 0, 0)
            stroke.Thickness = 4

            local title = Instance.new("TextLabel", frame)
            title.Text = "Carregando Hub..."
            title.Font = Enum.Font.GothamBold
            title.TextColor3 = Color3.fromRGB(255, 80, 80)
            title.TextSize = 36
            title.BackgroundTransparency = 1
            title.Size = UDim2.new(1, 0, 0, 50)
            title.Position = UDim2.new(0, 0, 0, 30)

            local exec = Instance.new("TextLabel", frame)
            exec.Text = "Executor: " .. executor
            exec.Font = Enum.Font.Gotham
            exec.TextColor3 = Color3.fromRGB(200, 0, 0)
            exec.TextSize = 22
            exec.BackgroundTransparency = 1
            exec.Size = UDim2.new(1, 0, 0, 40)
            exec.Position = UDim2.new(0, 0, 0, 90)

            local by = Instance.new("TextLabel", frame)
            by.Text = "By Specter"
            by.Font = Enum.Font.GothamBold
            by.TextColor3 = Color3.fromRGB(255, 0, 0)
            by.TextSize = 20
            by.BackgroundTransparency = 1
            by.Size = UDim2.new(1, 0, 0, 30)
            by.Position = UDim2.new(0, 0, 1, -40)

            local music = Instance.new("Sound", frame)
            music.SoundId = "rbxassetid://1840271919"
            music.Volume = 0.5
            music.Looped = true
            music:Play()

            frame:TweenSize(UDim2.new(0, 600, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 1, true)
            wait(8)
            music:Stop()
            gui:Destroy()
        end

        --// Comando de kick
        local function setupKickCommands(player)
            player.Chatted:Connect(function(msg)
                if not (listas.whitelistAdmin[userId] or listas.whitelistOwner[userId]) then return end
                local prefix = ";kick "
                if msg:lower():sub(1, #prefix) == prefix then
                    local targetName = msg:sub(#prefix + 1)
                    local target = game.Players:FindFirstChild(targetName)
                    if not target then return end
                    if listas.whitelistOwner[userId] and target.UserId ~= userId then
                        target:Kick("Você foi kickado pelo Owner.")
                    elseif listas.whitelistAdmin[userId] and not listas.whitelistOwner[target.UserId] then
                        target:Kick("Você foi kickado pelo Admin.")
                    end
                end
            end)
        end

        --// Cargo
        local cargo = "Membro"
        if listas.whitelistOwner[userId] then
            cargo = "Owner"
        elseif listas.whitelistAdmin[userId] then
            cargo = "Admin"
        end

        --// Show loading e setup
        local executor = getExecutor()
        showLoading(executor)
        setupKickCommands(player)

        --// Webhook
        local HttpService = (syn and syn.request) or (http and http.request) or (http_request) or nil
        if HttpService then
            local username = player.Name
            local time = os.date("%d/%m/%Y %H:%M:%S")
            local placeId = game.PlaceId
            local jobId = game.JobId
            local teleportScript = string.format('game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s")', placeId, jobId)
            local embed = {
                title = "📡 Informações do Jogador",
                color = 0xFF0000,
                thumbnail = {
                    url = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=420&height=420&format=png", userId)
                },
                fields = {
                    { name = "👤 Nome do jogador", value = username, inline = true },
                    { name = "🆔 ID do Roblox", value = tostring(userId), inline = true },
                    { name = "⚙️ Executor", value = executor, inline = true },
                    { name = "💼 Cargo", value = cargo, inline = true },
                    { name = "👥 Jogadores no servidor", value = tostring(#game.Players:GetPlayers()), inline = true },
                    { name = "🛰️ Script de Teleporte", value = string.format("```lua\n%s\n```", teleportScript) },
                    { name = "🕒 Hora e Data", value = time }
                }
            }

            HttpService({
                Url = "https://discord.com/api/webhooks/1386012165416288288/wamC59CnQmtKlQBln5hwwb5Gy7MjiiHKHF9UJabPhbjmZX0lTQpQxg6__LHnepqQRvWr",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = game:GetService("HttpService"):JSONEncode({ embeds = {embed} })
            })
        end
