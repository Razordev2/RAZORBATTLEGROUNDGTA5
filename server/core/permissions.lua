PermissionsManager = PermissionsManager or {}

function PermissionsManager.IsAdmin(src)
    if src == 0 then return true end -- Server Console is always admin

    -- 1. Check Config.AdminIdentifiers list (Steam Hex, Discord ID, License)
    if Config.AdminIdentifiers and #Config.AdminIdentifiers > 0 then
        for _, id in ipairs(GetPlayerIdentifiers(src) or {}) do
            for _, adminId in ipairs(Config.AdminIdentifiers) do
                if string.lower(id) == string.lower(adminId) then
                    return true
                end
            end
        end
    end

    -- 2. Check FiveM ACE Permissions
    if IsPlayerAceAllowed(tostring(src), Config.AdminPermission or "battleground.admin") then
        return true
    end

    if IsPlayerAceAllowed(tostring(src), "command") or IsPlayerAceAllowed(tostring(src), "group.admin") then
        return true
    end

    return false
end
