ServerRedeem = ServerRedeem or {}

function ServerRedeem.RedeemCode(src, codeStr)
    local player = PlayerManager.GetPlayer(src)
    if not player then return false, "Player session not found" end

    -- Rate limit cooldown check
    local now = os.time()
    if now - (player.lastRedeemTime or 0) < (Config.RedeemCooldown or 3) then
        return false, "Please wait a few seconds before redeeming again."
    end
    player.lastRedeemTime = now

    codeStr = string.upper(Utils.SanitizeText(codeStr or ""))
    local codeObj = ServerState.RedeemCodes[codeStr]

    if not codeObj then
        return false, _L("code_invalid")
    end

    if not codeObj.enabled then
        return false, "This code is currently disabled."
    end

    if codeObj.maxUses and codeObj.maxUses > 0 and codeObj.currentUses >= codeObj.maxUses then
        return false, "Redeem code maximum usage limit reached."
    end

    codeObj.claimedBy = codeObj.claimedBy or {}
    if codeObj.claimedBy[player.identifier] then
        return false, "You have already redeemed this code!"
    end

    -- Atomic claim logic
    codeObj.currentUses = codeObj.currentUses + 1
    codeObj.claimedBy[player.identifier] = true

    if codeObj.rewardType == "KILLMESSAGE" then
        if not table.contains(player.ownedKillMessages, codeObj.rewardId) then
            table.insert(player.ownedKillMessages, codeObj.rewardId)
        end
        player.activeKillMessage = codeObj.rewardId
    end

    print(string.format("[Battleground] Player %s redeemed code %s (Reward: %s)", player.name, codeStr, codeObj.rewardId))
    return true, _L("code_claimed", codeObj.rewardId)
end

function table.contains(tbl, val)
    for _, v in ipairs(tbl) do if v == val then return true end end
    return false
end

RegisterNetEvent("battleground:sv:redeemCode", function(codeStr)
    local src = source
    local success, msg = ServerRedeem.RedeemCode(src, codeStr)
    if success then
        TriggerClientEvent("battleground:cl:notification", src, msg, "success")
    else
        TriggerClientEvent("battleground:cl:notification", src, msg, "error")
    end
end)
