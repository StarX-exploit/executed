-- Pastikan HttpService diaktifkan di game settings!
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalPlayer = Players.LocalPlayer

-- Webhook URL
local webhookURL = "https://discord.com/api/webhooks/1317750984029634594/azgdO7VVYbYsD3AIyJKKyxrW9XMaUKMhfqUDY5HoT6PLgZg1APw7QrrZS_w6s9iGknZb"

-- Fungsi untuk mendapatkan nama game dari MarketplaceService
local function getGameName(gameId)
    local success, gameInfo = pcall(function()
        return MarketplaceService:GetProductInfo(gameId)
    end)

    if success and gameInfo and gameInfo.Name then
        return gameInfo.Name
    end

    return "Unknown Game"
end

-- Fungsi untuk mendapatkan data pemain
local function getPlayerData()
    local gameId = game.PlaceId
    local gameName = getGameName(gameId)

    local data = {
        username = LocalPlayer.Name,
        userId = LocalPlayer.UserId,
        accountAge = LocalPlayer.AccountAge, -- Dalam hari
        premium = LocalPlayer.MembershipType == Enum.MembershipType.Premium and "✅ Premium" or "❌ Not Premium",
        gameId = gameId,
        gameName = gameName,
        executor = identifyexecutor and identifyexecutor() or "❓ Unknown",
        avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    }
    return data
end

-- Fungsi untuk mengirim data ke webhook
local function sendToWebhook(data)
    -- Membuat payload JSON dengan embed
    local payload = {
        ["content"] = "🚨 Player data detected and sent to the Webhook.",
        ["embeds"] = {{
            ["title"] = "🕵️ Player Information",
            ["fields"] = {
                { ["name"] = "🧑 Username", ["value"] = data.username, ["inline"] = true },
                { ["name"] = "🆔 UserID", ["value"] = tostring(data.userId), ["inline"] = true },
                { ["name"] = "📅 Account Age (days)", ["value"] = tostring(data.accountAge), ["inline"] = true },
                { ["name"] = "💎 Premium", ["value"] = data.premium, ["inline"] = true },
                { ["name"] = "🎮 Game ID", ["value"] = tostring(data.gameId), ["inline"] = true },
                { ["name"] = "🎮 Game Name", ["value"] = data.gameName, ["inline"] = true },
                { ["name"] = "⚙️ Executor", ["value"] = data.executor, ["inline"] = true }
            },
            ["thumbnail"] = { ["url"] = data.avatarUrl },
            ["color"] = 65280 -- Green color
        }}
    }

    -- Mengonversi tabel menjadi JSON string
    local payloadJSON = HttpService:JSONEncode(payload)

    -- Mengirimkan data ke webhook menggunakan http_request
    local success, errorMessage = pcall(function()
        http_request({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json" -- Header yang benar untuk JSON
            },
            Body = payloadJSON -- Data JSON yang dikirim
        })
    end)

    if success then
        print("Data successfully sent to webhook.")
    else
        warn("Failed to send data to webhook: " .. tostring(errorMessage))
    end
end

-- Mendapatkan data pemain dan mengirim ke webhook
local playerData = getPlayerData()
sendToWebhook(playerData)
