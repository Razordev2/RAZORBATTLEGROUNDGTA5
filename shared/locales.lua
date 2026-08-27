Locales = Locales or {}

Locales.Dictionary = {
    ['id'] = {
        ['room_created'] = "Room %s berhasil dibuat!",
        ['room_joined'] = "Anda bergabung ke room %s",
        ['room_left'] = "Anda telah keluar dari room",
        ['wrong_password'] = "Password room salah!",
        ['match_started'] = "Pertandingan Battleground telah dimulai!",
        ['countdown_go'] = "GO! LOMPAT DARI PESAWAT!",
        ['loot_picked'] = "Mengambil %s",
        ['revive_started'] = "Merawat teman tim...",
        ['revived_success'] = "Teman tim berhasil dipulihkan!",
        ['team_eliminated'] = "TIM %s TERELIMINASI!",
        ['victory_title'] = "VICTORY BATTLEGROUND!",
        ['code_invalid'] = "Kode redeem tidak valid atau telah kadaluarsa!",
        ['code_claimed'] = "Berhasil mengklaim reward: %s!",
        ['no_permission'] = "Anda tidak memiliki akses perintah ini."
    },
    ['en'] = {
        ['room_created'] = "Room %s successfully created!",
        ['room_joined'] = "Joined room %s",
        ['room_left'] = "Left the room",
        ['wrong_password'] = "Incorrect room password!",
        ['match_started'] = "Battleground match has started!",
        ['countdown_go'] = "GO! EJECT FROM THE PLANE!",
        ['loot_picked'] = "Picked up %s",
        ['revive_started'] = "Reviving teammate...",
        ['revived_success'] = "Teammate revived successfully!",
        ['team_eliminated'] = "TEAM %s ELIMINATED!",
        ['victory_title'] = "BATTLEGROUND VICTORY!",
        ['code_invalid'] = "Invalid or expired redeem code!",
        ['code_claimed'] = "Successfully claimed reward: %s!",
        ['no_permission'] = "You do not have permission to use this command."
    }
}

function _L(key, ...)
    local lang = (Config and Config.Locale) or 'id'
    local dict = Locales.Dictionary[lang] or Locales.Dictionary['id']
    local str = dict[key] or key
    if select('#', ...) > 0 then
        return string.format(str, ...)
    end
    return str
end
