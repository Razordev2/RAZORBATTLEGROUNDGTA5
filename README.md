# 🏆 FiveM Battleground Esports Resource (Standalone)

Resource **FiveM Battleground Esports** server-authoritative tingkat turnamen profesional dengan tampilan Pro-Esports Frosted Glass UI, Loading Screen terpisah, Peta Taktis Interactive Map, animasi selebrasi pemenang 3 tahap, sistem pesawat & parasut, looting tanah dinamis, spectate real-time, voice dual-mode, penanda musuh tombol `Z`, integrasi Discord Webhook Match Report, `.env.example` untuk GitHub, dan Database SQL (XAMPP / MySQL).

---

## 🌟 Daftar Fitur Terbaru (Latest Features List)

1. **🎮 Dedicated Esports Loading Screen (`loadingscreen/index.html`)**:
   - Tampilan loading screen terpisah yang terdaftar secara natif di `fxmanifest.lua` (`loadingscreen 'loadingscreen/index.html'`).
   - Desain profesional kelas eksekutif turnamen esports dengan tabel tombol kontrol cepat (`<kbd>Z</kbd>`, `<kbd>B</kbd>`, `<kbd>M</kbd>`, dll), petunjuk taktis berganti otomatis setiap 5 detik, dan bar progres hijau emerald real-time (`0%` -> `100%`).

2. **🗺️ Tactical Battleground Interactive Map Overlay (`#map-container`)**:
   - Ditekan via tombol **`M`** atau perintah **`/map`**.
   - Fitur **Zoom In / Zoom Out** via Roda Scroll Mouse atau tombol UI (`75%` s/d `250%`).
   - **Drag & Pan Navigation**: Tahan dan geser mouse untuk mengarahkan pandangan peta.
   - Menampilkan area **Safezone Aktif** (lingkaran cyan bercahaya), **Safezone Berikutnya** (lingkaran emas putus-putus), penanda **Lokasi Pemain** (`YOU`), **Airdrop Supply** (`🪂`), dan **Penanda Musuh** (`🎯`).

3. **💀 Tournament Broadcaster Kill FX & Dynamic Kill Feed**:
   - **Center-Screen Kill FX Banner (`#kill-fx-overlay`)**: Banner selebrasi kill tengah layar bercahaya neon crimson (`💀 HEADSHOT ELIMINATION 💀`) yang dipemicu otomatis saat pemain melakukan kill, lengkap dengan efek suara dentuman Web Audio API.
   - **Top-Right Kill Feed (`#killfeed-container`)**: Kartu kaca gelap kontras tinggi dengan logo animasi GIF `gif/ACADEMIPGCE.gif`. Bersih 100% secara default (tanpa dummy) dan hanya muncul saat peristiwa kill terjadi in-game.
   - Perintah Uji Coba: `/testkill`.

4. **💬 Real-Time Pure Chat UI (`#chat-container`)**:
   - Bebas dari teks dummy/simulasi saat baru masuk game.
   - Menampilkan pesan chat real-time yang diketik pemain/admin via tombol **`T`** dengan label LED `[ADMIN]`, `[TEAM]`, `[PLAYER]`, dan `[SYSTEM]`.

5. **👥 Squad List HUD Auto-Hide & Multi-Player Scroll (`#team-hud`)**:
   - Tersembunyi secara default saat baru spawn/masuk game (belum masuk tim).
   - Otomatis muncul saat membuat/bergabung tim dengan dukungan fitur **vertical auto-scroll** (`max-height: 215px`) jika jumlah anggota tim lebih dari 5 pemain.

6. **🚘 Dynamic Single-Type Vehicle Spawner**:
   - Memilih **1 jenis tipe mobil acak** per pertandingan (misal khusus `wrangler24` atau `sultan`) untuk disebar di 30+ titik lokasi map secara unlocked & siap pakai.

7. **📢 Discord Webhook Match Report Integration**:
   - Setiap kali pertandingan selesai, laporan resmi hasil match (Nama Tim Juara, Total Kills, Peringkat Top 5 Leaderboards, Kills & Damage) otomatis dikirimkan ke Discord Webhook via Discord Rich Embed.

8. **🔐 Keamanan GitHub (.env.example & .gitignore)**:
   - Dilengkapi template `.env.example` dan `.gitignore` untuk mengamankan kredensial database dan token webhook rahasia saat di-upload ke repository GitHub.

---

## 🗄️ Tutorial Pemasangan Database XAMPP (phpMyAdmin)

1. Buka **XAMPP Control Panel** dan jalankan modul **Apache** & **MySQL**.
2. Buka browser dan pergi ke alamat: `http://localhost/phpmyadmin`.
3. Klik menu tab **Import** pada bagian atas phpMyAdmin.
4. Pilih file **`battleground.sql`** yang berada di dalam folder root resource ini, lalu klik **Go** / **Kirim**.
5. Database `battleground_db` beserta 4 tabel (`battleground_players`, `battleground_matches`, `battleground_match_teams`, `battleground_redeem_codes`) akan otomatis terbuat!

---

## 🔑 Draf Tombol & Kontrol In-Game (Keybinds & Controls)

| Tombol | Fungsi |
| :--- | :--- |
| **`M`** | Membuka / Menutup Tactical Interactive Map (dengan Zoom Scroll & Drag) |
| **`T`** | Membuka Input Custom Chat Esports Real-Time |
| **`Z`** | Menandai Musuh / Enemy Ping (Khusus Squad) |
| **`B`** | Berganti Mode Voice Chat (`[🎙️ SQUAD RADIO]` ⮘⮘⮚ `[📢 PUBLIC PROXIMITY]`) |
| **`SPACE` / `G`** | Terjun Keluar dari Pesawat Cargo (*Eject*) |
| **`◄ Q` / `E ►`** | Berganti Target Rekan Tim saat Mode Spectator |
| **`F2`** | Membuka/Menutup Battleground Inventory |

---

## 🛠️ Pengaturan Role Admin (Steam HEX, Discord ID, License & ACE)

Konfigurasi Role Admin dapat diatur menggunakan **3 Metode Fleksibel**:

### 1. Metode Identifiers (`config/config.lua`)
Buka `config/config.lua` dan tambahkan ID Anda ke dalam tabel `Config.AdminIdentifiers`:

```lua
Config.AdminIdentifiers = {
    "steam:110000100000000",      -- Steam HEX Identifier Anda
    "discord:123456789012345678", -- Discord ID Identifier Anda (Format: discord:ID)
    "license:abcdef1234567890"    -- FiveM License Identifier Anda
}
```

### 2. Metode FiveM ACE Permission (`server.cfg`)
Tambahkan baris berikut di file `server.cfg` server Anda:
```cfg
add_ace group.admin battleground.admin allow
add_principal identifier.discord:123456789012345678 group.admin
add_principal identifier.steam:110000100000000 group.admin
```

### 3. Konsol Server (Server Console)
Seluruh perintah admin dapat langsung dijalankan dari konsol server (`cmd`).

---

## 📜 Perintah Admin & Uji Coba (Commands)

### 🔒 Perintah Khusus Admin (Restricted - Tersembunyi dari Player):
- `/playmanual` : Memulai pertandingan secara manual untuk seluruh tim.
- `/airdropmanual` : Memunculkan Airdrop Supply secara manual.
- `/zonemanual` : Memunculkan notifikasi & sirene Safezone Warning secara manual.
- `/spawnvehiclesmanual` : Memunculkan mobil acak di seluruh map secara manual.
- `/createlootzone [radius] [table]` : Membuat area spawner loot baru.
- `/deletelootzone [id]` : Menghapus area loot zone tertentu.
- `/createcode <code> <rewardType> <rewardId> [maxUses]` : Membuat kode voucher redeem event.

### 🎮 Perintah Uji Coba Player:
- `/map` : Membuka / menutup Tactical Interactive Map.
- `/testkill` : Menguji animasi Tournament Kill FX Banner & Kill Feed.
- `/ping` : Menguji penanda musuh tombol `Z`.
- `/spectate` & `/stopspectate` : Menguji tampilan Spectate Teammate HUD.
- `/voicemode` : Berganti mode voice chat (`SQUAD` / `PUBLIC`).
- `/redeem` : Membuka UI Klaim Kode Voucher Event.

---

## 📂 Tutorial Pemasangan Server Terupdate (Installation Step-by-Step)

1. Pastikan Anda telah meng-import database **`battleground.sql`** ke XAMPP phpMyAdmin (seperti langkah di atas).
2. Salin/Pindahkan seluruh folder resource **`battlegroundpenghancur`** ke dalam direktori `resources/` server FiveM Anda.
3. Buka file **`server.cfg`** server Anda, dan tambahkan urutan `ensure` berikut:
```cfg
ensure pma-voice
ensure illenium-appearance
ensure battlegroundpenghancur
```
4. Restart server FiveM Anda dan nikmati pertandingan Battleground Esports!
