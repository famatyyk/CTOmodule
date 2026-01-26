# OTClientV8 - Complete Bot & Client Documentation

## Co to jest OTClientV8?

OTClientV8 to wysoce zoptymalizowany, wieloplatformowy klient i framework do gry Tibia z **wbudowanym botem**. Jest to fork oryginalnego OTClient stworzony przez **kondra**.

### Podstawowe informacje:
- **Twórca**: kondra
- **Repozytorium**: https://github.com/OTCv8/otclientv8
- **Discord**: https://discord.gg/feySup6
- **Forum**: https://otland.net/forums/otclient.494/
- **Website**: http://otclient.ovh
- **Instalacje**: 1+ milion (w tym 250k na Android)
- **Status**: Open-source (od 2023)
- **Stars**: 278+

## Platformy:

### Wspierane systemy:
1. **Windows** (min. Windows 7)
   - Wymaga: VC Redist x86 (https://aka.ms/vs/16/release/vc_redist.x86.exe)
   - DirectX9/DirectX11
   
2. **Android** (min. 5.0)
   - Plik: otclientv8.apk
   
3. **Linux**
   - Plik: otclient_linux
   
4. **Mac OS**
   - Wymaga: XQuartz (https://www.xquartz.org/)
   - Plik: otclient_mac

## Wersje wykonywalne:

### Windows:
1. **otclient_dx.exe** - DirectX version (zalecana)
2. **otclient_gl.exe** - OpenGL version

### Wymagane DLL dla DirectX:
- libEGL.dll
- libGLESv2.dll
- d3dcompiler_47.dll

## Główne funkcje (FEATURES):

### 1. Rendering & Graphics
- ✅ Przepisany i zoptymalizowany rendering
- ✅ 60 FPS na 11-letnim komputerze
- ✅ DirectX9 i DirectX11 support
- ✅ Adaptive rendering (automatyczne optymalizacje)
- ✅ Przepisane renderowanie światła
- ✅ Crosshair, floor fading
- ✅ Extra health/mana bars i panele

### 2. Pathfinding & Movement
- ✅ Przepisany pathfinding i auto walking
- ✅ System chodzenia z animacjami
- ✅ Płynniejszy ruch

### 3. Network & API
- ✅ HTTP/HTTPS Lua API z JSON support
- ✅ WebSocket Lua API
- ✅ Nowy HTTP login protocol
- ✅ Support dla proxy (niższe latency, DDoS protection)

### 4. Bot System
- ✅ **Advanced bot** - wbudowany!
- ✅ Scripts/macros support
- ✅ Auto healing, attacking, looting
- ✅ Targeting system
- ✅ Walker/Cavebot
- ✅ Custom scripts w Lua

### 5. Interface
- ✅ Odświeżony interfejs
- ✅ Updated hotkey manager
- ✅ Zoptymalizowana battle list
- ✅ Więcej opcji klienta
- ✅ Layouts system
- ✅ Ingame shop

### 6. System & Stability
- ✅ Auto updater z failsafe mode
- ✅ Nowy filesystem
- ✅ Szyfrowanie i kompresja plików
- ✅ Automatyczny system diagnostyczny
- ✅ Nowy crash i error handler

### 7. Server Features
- ✅ Full Tibia 11.00 support
- ✅ Layouts
- ✅ Nowy login server
- ✅ Ingame tworzenie konta i postaci

### 8. Inne
- ✅ Usunięto dużo niepotrzebnych rzeczy
- ✅ Setki małych optymalizacji i bugfixów

## Konfiguracja (init.lua):

### Podstawowa konfiguracja:
```lua
-- CONFIG
APP_NAME = "otclientv8"  -- Nazwa dla config dir w appdata
APP_VERSION = 1337       -- Wersja klienta dla updater i login

DEFAULT_LAYOUT = "retro" -- Domyślny layout (retro/modern)

-- Serwisy
Services = {
  website = "http://otclient.ovh",
  updater = "http://otclient.ovh/api/updater.php",
  news = "http://otclient.ovh/api/news.php",
  stats = "",
  crash = "http://otclient.ovh/api/crash.php",
  feedback = "http://otclient.ovh/api/feedback.php"
}

-- Serwery
Servers = {
  MyServer = "http://myserver.com/api/login.php",
  MyServerProxy = "http://myserver.com/api/login.php?proxy=1",
  ClassicServer = "myserver.com:7171:1099",
  FeatureServer = "myserver.com:7171:1099:25:30:80:90",
}

ALLOW_CUSTOM_SERVERS = true -- Opcja "ANOTHER" na liście serwerów
-- CONFIG END
```

### Format serwera z parametrami:
```
ip:port:version:featA:featB:featC:featD
```
Przykład:
```
myserver.com:7171:1099:25:30:80:90
```

## Bot System - Scripts/Macros:

### Struktura bota:
OTClientV8 ma **wbudowany system botowania** z GUI i możliwością tworzenia custom skryptów.

### Typy skryptów:

#### 1. **Healing (Auto Heal)**
```lua
-- Auto heal przy określonym HP/Mana
macro(100, "Auto Heal", function()
  if hppercent() < 50 then
    say("exura gran")
  end
  if manapercent() < 30 then
    usewith(mana_potion_id, player)
  end
end)
```

#### 2. **Attacking (Auto Attack)**
```lua
-- Auto attack najbliższego potwora
macro(500, "Auto Attack", function()
  local target = getClosestMonster()
  if target then
    g_game.attack(target)
    say("exori")
  end
end)
```

#### 3. **Looting (Auto Loot)**
```lua
-- Auto zbieranie itemów
local lootList = {3031, 3035, 3043} -- gold, platinum, crystal

macro(200, "Auto Loot", function()
  for i, tile in ipairs(g_map.getTiles(posz())) do
    for j, item in ipairs(tile:getItems()) do
      if table.contains(lootList, item:getId()) then
        g_game.move(item, {x=65535, y=SlotBack, z=0}, item:getCount())
      end
    end
  end
end)
```

#### 4. **Walker/Cavebot**
```lua
-- Chodzenie po określonej ścieżce
local waypoints = {
  {x=100, y=100, z=7},
  {x=105, y=100, z=7},
  {x=105, y=105, z=7},
}

macro(1000, "Walker", function()
  -- Implementacja chodzenia
end)
```

#### 5. **Targeting**
```lua
-- Target określonych potworów
macro(100, "Target Dragon", function()
  for _, creature in pairs(g_map.getCreatures()) do
    if creature:getName() == "Dragon" then
      g_game.attack(creature)
      break
    end
  end
end)
```

### Popularne komendy bot API:

```lua
-- Player info
player                    -- Obiekt gracza
player:getName()         -- Nazwa gracza
player:getHealth()       -- HP
player:getMaxHealth()    -- Max HP
hppercent()             -- % HP
manapercent()           -- % Mana
player:getPosition()    -- Pozycja

-- Target & Attack
g_game.attack(creature) -- Atak
getClosestMonster()     -- Najbliższy potwór
getTarget()             -- Aktualny target

-- Items
usewith(itemId, target) -- Użyj item na target
g_game.move(item, pos, count) -- Przenieś item

-- Map & Tiles
g_map.getTiles(z)       -- Pobierz tile'e na poziomie z
posz()                  -- Aktualny poziom

-- Communication
say(text)               -- Powiedz tekst
```

### GUI Bot Features:
- ✅ **Healing** - Auto heal, mana refill
- ✅ **Targeting** - Target wybór, priority list
- ✅ **Attacking** - Auto attack, spells rotation
- ✅ **Looting** - Lista itemów do loot
- ✅ **Walker** - Waypoints, cavebot
- ✅ **Tools** - Various tools i helpery

## Layouts System:

### Dostępne layouty:
1. **Retro** - Klasyczny layout (Tibia 7.x-8.x style)
2. **Modern** - Nowoczesny layout (Tibia 11.x+ style)
3. **Custom** - Możliwość tworzenia własnych

### Zmiana layoutu:
```lua
DEFAULT_LAYOUT = "retro" -- w init.lua
```

Lub w grze przez menu.

## Wiki & Documentation:

### Oficjalna Wiki:
- https://github.com/OTCv8/otclientv8/wiki

### Tematy w Wiki:
- How to activate new features
- Bot configuration
- Custom scripts
- Extended opcodes
- Server configuration

## Developer Resources:

### Dev Repository:
- https://github.com/OTCv8/otcv8-dev
- Dla developerów chcących kontrybuować
- Kod źródłowy C++

### TFS with OTCv8 features:
- https://github.com/OTCv8/forgottenserver
- TFS 1.3 z funkcjami OTCv8
- Extended opcodes
- Custom features

### Tools:
- https://github.com/OTCv8/otcv8-tools
- Updater
- Tutorials
- Narzędzia pomocnicze

## Bot Scripts Repository:

### Community Scripts:
**Thread**: https://otland.net/threads/scripts-macros-for-kondras-otclientv8-bot.267394/
- 136+ replies
- 519k+ views
- Setki gotowych skryptów
- Healing, attacking, looting, walking
- Advanced macros

### Popularne skrypty:
1. **Auto Heal & Mana**
2. **Auto Attack & Target**
3. **Auto Loot & Stack**
4. **Cavebot/Walker**
5. **Auto Training**
6. **Auto Fishing**
7. **Anti-Idle**
8. **And many more!**

## Extended Opcodes:

### Server-Client Communication:
OTCv8 wspiera extended opcodes do komunikacji między serwerem a klientem.

### Przykład:
```lua
-- Server side (TFS)
player:sendExtendedOpcode(opcode, data)

-- Client side (OTCv8)
function onExtendedOpcode(opcode, data)
  -- Obsługa custom komunikacji
end
```

### Użycie:
- Custom UI
- Bot protection
- Custom features
- Server events

## Bezpieczeństwo & Bot Protection:

### Dla właścicieli serwerów:
- Extended opcodes dla wykrywania botów
- Custom protokoły
- Server-side validation
- Anti-bot mechanizmy

### OTCv8 TFS:
Specjalna wersja TFS z funkcjami OTCv8 i bot protection.

## Updater System:

### Auto-update:
- Automatyczne pobieranie aktualizacji
- Failsafe (recovery) mode
- Update przez HTTP
- Version checking

### Konfiguracja:
```lua
Services = {
  updater = "http://myserver.com/api/updater.php",
}
```

## Files & Structure:

### Główne pliki:
```
otclientv8/
├── otclient_dx.exe      # DirectX version
├── otclient_gl.exe      # OpenGL version
├── init.lua             # Main config
├── data/                # Client data
│   └── things/          # Sprites & dat files
├── layouts/             # UI layouts
├── modules/             # Client modules
│   └── game_*/          # Game features
└── mods/                # Custom modifications
    └── game_healthbars/ # Example mod
```

### Wymagane pliki w data/things/:
```
data/things/1099/
├── Tibia.spr
└── Tibia.dat
```

## Version Compatibility:

### Wspierane wersje Tibia:
- 7.x
- 8.x
- 9.x
- 10.x
- 11.x (full support 11.00)
- 12.x (w nowszych wersjach)

## Community:

### Discord Server:
- https://discord.gg/feySup6
- Pomoc, wsparcie
- Scripts sharing
- Updates & news

### OTLand Forum:
- https://otland.net/forums/otclient.494/
- Tutorials
- Showoff
- Problems & solutions
- 89 stron wątków!

### Trending Topics:
1. **OTClientV8 BOT** - 71 replies
2. **Scripts/macros** - 136 replies
3. **OTClientV8 is now open-source** - 53 replies
4. **Auras and wings** - 94 replies
5. **Voice Chat System (VOIP)** - 72 replies

## Quick Start Guide:

### Dla graczy:
1. Pobierz repository
2. Uruchom otclient_dx.exe lub otclient_gl.exe
3. Zaloguj się na serwer
4. Gotowe!

### Dla właścicieli serwerów:
1. Edytuj init.lua
2. Ustaw APP_NAME i APP_VERSION
3. Skonfiguruj Services (updater, news, etc.)
4. Dodaj serwery do Servers
5. Dodaj Tibia.spr i Tibia.dat do data/things/
6. Dystrybuuj klientowi!

### Dla bot userów:
1. Uruchom OTCv8
2. Zaloguj się
3. Otwórz Bot Panel (zazwyczaj Ctrl+B)
4. Skonfiguruj healing, targeting, looting
5. Włącz skrypty/macros
6. Bot działa!

## Różnice OTCv8 vs standard OTClient:

| Feature | OTClient | OTCv8 |
|---------|----------|-------|
| Bot | ❌ Brak | ✅ Wbudowany |
| Performance | Średni | ✅ Zoptymalizowany |
| DirectX | ❌ Brak | ✅ Full support |
| Android | ❌ Brak | ✅ Support |
| Layouts | ❌ Brak | ✅ Multiple |
| Auto-updater | ❌ Brak | ✅ Built-in |
| HTTP/WS API | ❌ Brak | ✅ Full API |

## Advanced Bot Examples:

### 1. Smart Healing:
```lua
local healSpell = "exura gran"
local healHP = 50
local manaHP = 90

macro(100, "Smart Heal", function()
  if hppercent() < healHP and manapercent() > manaHP then
    say(healSpell)
  end
end)
```

### 2. Auto Mana Potion:
```lua
macro(100, "Mana Pot", function()
  if manapercent() < 30 then
    local manaPotion = 268 -- great mana potion
    usewith(manaPotion, player)
  end
end)
```

### 3. Multi-Target:
```lua
local targets = {"Dragon", "Dragon Lord", "Demon"}

macro(200, "Multi Target", function()
  if not g_game.isAttacking() then
    for _, name in ipairs(targets) do
      for _, creature in pairs(g_map.getCreatures()) do
        if creature:getName() == name then
          g_game.attack(creature)
          return
        end
      end
    end
  end
end)
```

## Tips & Tricks:

### Performance:
- Użyj DirectX version (otclient_dx.exe)
- Włącz adaptive rendering
- Wyłącz niepotrzebne efekty
- Zmniejsz light rendering quality

### Bot:
- Nie ustawiaj zbyt niskich intervalów w macro()
- Używaj warunków aby oszczędzać CPU
- Loguj działania dla debug
- Testuj skrypty na test serverze

### Bezpieczeństwo:
- Nie udostępniaj account data
- Używaj proxy dla dodatkowego bezpieczeństwa
- Sprawdzaj server rules odnośnie botowania
- Backup character regularnie

---

*Ostatnia aktualizacja: 25 stycznia 2026*
