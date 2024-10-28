-- URL webhook Discord Anda
local webhookURL = "https://discord.com/api/webhooks/1300441554837700629/Phl3fFjaZahAZvE6v_WRL_JciUZBWdrp0-mI4aoUWOKM4Ap_7GNskmrlmb1EhbUkUNfM"

-- Mendapatkan informasi pemain
local player = game:GetService("Players").LocalPlayer
local username = player.Name
local userId = player.UserId
local accountAge = player.AccountAge

-- Deteksi executor yang digunakan
local executor = "Unknown Executor" -- Default jika tidak terdeteksi

if syn then
    executor = "Synapse X"
elseif KRNL_LOADED then
    executor = "KRNL"
elseif fluxus then
    executor = "Fluxus"
elseif evon then
    executor = "Evon"
elseif Arceus then
    executor = "Arceus X"
elseif wave then
    executor = "Wave"
elseif codex then
    executor = "Codex"
elseif vega_x then
    executor = "Vega X"
elseif delta then
    executor = "Delta"
elseif solara then
    executor = "Solara"
elseif cryptic then
    executor = "Cryptic"
elseif trigon then
    executor = "Trigon"
elseif MantiPWF then
    executor = "MantiPWF"
else
    -- Alternatif: Jika ada fungsi umum seperti identifyexecutor atau getexecutorname
    if identifyexecutor then
        executor = identifyexecutor()
    elseif getexecutorname then
        executor = getexecutorname()
    end
end

-- Fungsi untuk mengirim notifikasi ke Discord
local function sendToDiscord(message)
    local request = http_request or request or syn.request or http.request
    if not request then
        warn("Executor tidak mendukung HTTP Requests.")
        return
    end

    local data = {
        ["content"] = message,
        ["embeds"] = {{
            ["title"] = "Roblox Executor Notification",
            ["fields"] = {
                {["name"] = "User:", ["value"] = username, ["inline"] = true},
                {["name"] = "User ID:", ["value"] = tostring(userId), ["inline"] = true},
                {["name"] = "User Age:", ["value"] = tostring(accountAge), ["inline"] = true},
                {["name"] = "Executor", ["value"] = executor, ["inline"] = true}
            },
            ["color"] = 16711680 -- Warna merah
        }}
    }

    request({
        Url = webhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end

-- Eksekusi notifikasi saat script dijalankan
sendToDiscord("New Execute! ")
