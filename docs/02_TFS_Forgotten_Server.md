# TFS (The Forgotten Server) - Comprehensive Documentation

## Co to jest TFS?

The Forgotten Server to darmowy i otwarty emulator serwera MMORPG napisany w C++. Jest forkiem projektu OpenTibia Server.

### Podstawowe informacje:
- **Język**: C++
- **Język skryptowy**: Lua
- **Licencja**: GPL-2.0
- **Platform**: Windows, Linux, Mac OS X
- **Baza danych**: MySQL/MariaDB
- **Stars**: 1.8k+
- **Forks**: 1.1k+

## Główne repozytoria:

### 1. OTLand/forgottenserver
- https://github.com/otland/forgottenserver
- Oficjalne repozytorium TFS
- Aktywnie rozwijane
- Najnowsza wersja: 1.6 (Czerwiec 2024)

## Struktura projektu TFS:

```
forgottenserver/
├── data/                # Dane serwera
│   ├── scripts/        # Skrypty Lua
│   ├── XML/            # Pliki konfiguracyjne XML
│   ├── actions/        # Akcje (używanie itemów)
│   ├── creaturescripts/# Skrypty stworzeń
│   ├── globalevents/   # Eventy globalne
│   ├── movements/      # Ruchy (wejście na tile)
│   ├── npcs/           # NPC
│   ├── spells/         # Czary
│   ├── talkactions/    # Komendy tekstowe
│   └── weapons/        # Broń
├── src/                # Kod źródłowy C++
├── schema.sql          # Schemat bazy danych
├── config.lua.dist     # Przykładowa konfiguracja
└── CMakeLists.txt      # Konfiguracja CMake
```

## System skryptowania Lua:

### Główne typy skryptów:

#### 1. Actions (Akcje)
- Używanie itemów
- Klikanie na przedmioty
- Przykład: używanie shovel do kopania

#### 2. CreatureScripts (Skrypty stworzeń)
- onLogin - przy logowaniu
- onLogout - przy wylogowaniu
- onDeath - przy śmierci
- onKill - przy zabiciu
- onAdvance - przy awansie levelu

#### 3. GlobalEvents (Eventy globalne)
- Eventy czasowe
- Server save
- Eventy startowe serwera
- Eventy cykliczne

#### 4. Movements (Ruchy)
- StepIn - wejście na pole
- StepOut - wyjście z pola
- AddItem - dodanie itemu
- RemoveItem - usunięcie itemu

#### 5. NPCs
- Skrypty dialogowe NPC
- System handlu
- Questy
- Custom interactions

#### 6. Spells (Czary)
- Attack spells - czary atakujące
- Healing spells - czary leczące
- Support spells - czary wsparcia
- Rune spells - runy

#### 7. TalkActions (Komendy tekstowe)
- Komendy gracza (!command)
- Komendy GM (/command)
- System komendy

#### 8. Weapons (Broń)
- Distance weapons - broń dystansowa
- Wand weapons - różdżki
- Melee weapons - broń bliskiego zasięgu

## Lua API - Główne funkcje:

### Player Functions:
```lua
-- Podstawowe
player:getName()
player:getGuid()
player:getLevel()
player:getExperience()
player:addExperience(amount)
player:getHealth()
player:getMana()
player:getSoul()

-- Pozycja
player:getPosition()
player:teleportTo(position)

-- Inventory
player:addItem(itemId, count)
player:removeItem(itemId, count)
player:getItemCount(itemId)

-- Storage
player:setStorageValue(key, value)
player:getStorageValue(key)

-- Komunikacja
player:sendTextMessage(type, text)
player:sendCancelMessage(text)

-- Walka
player:addHealth(amount)
player:addMana(amount)
player:getAttackSpeed()
```

### Creature Functions:
```lua
creature:getHealth()
creature:getMaxHealth()
creature:getName()
creature:getPosition()
creature:teleportTo(position)
creature:say(text, type)
creature:remove()
```

### Item Functions:
```lua
item:getId()
item:getCount()
item:getPosition()
item:remove()
item:moveTo(position)
item:transform(newId)
item:decay()
```

### Game Functions:
```lua
Game.getPlayers()
Game.createMonster(name, position)
Game.createItem(id, count, position)
Game.createNpc(name, position)
Game.getExperienceStage(level)
```

### Position Functions:
```lua
Position(x, y, z)
position:sendMagicEffect(effect)
position:sendDistanceEffect(toPosition, effect)
position:isSightClear(toPosition)
```

## Konfiguracja (config.lua):

### Podstawowe ustawienia:
```lua
-- Server Config
serverName = "My OTServer"
worldType = "pvp"  -- pvp, no-pvp, pvp-enforced
serverPort = 7172

-- Database
mysqlHost = "localhost"
mysqlUser = "root"
mysqlPass = ""
mysqlDatabase = "otserver"

-- Experience
rateExperience = 5
rateSkill = 3
rateLoot = 2
rateMagic = 3
rateSpawn = 1

-- Account
passwordType = "sha1"  -- plain, sha1, md5
newPlayerLevel = 8
newPlayerMagicLevel = 0
```

## Extended Opcodes:

### System komunikacji Client-Server:
- Umożliwia custom komunikację między klientem a serwerem
- Używane do custom UI, eventów, bot protection
- Protokół rozszerzeń

### Przykład użycia:
```lua
-- Server side
player:sendExtendedOpcode(opcode, buffer)

-- Odbieranie
function onExtendedOpcode(player, opcode, buffer)
    -- Obsługa custom komunikacji
end
```

## RevScripts (Nowy system):

### Wszystko w jednym pliku:
```lua
local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
    -- Kod czaru
    return true
end

spell:name("exori")
spell:words("exori")
spell:level(20)
spell:mana(40)
spell:register()
```

## Baza danych:

### Główne tabele:
- **accounts** - konta graczy
- **players** - postacie graczy
- **player_items** - inventory graczy
- **player_storage** - storage values
- **houses** - domy
- **guilds** - gildie
- **market_offers** - oferty rynku

## Kompilacja:

### Windows:
```bash
# Visual Studio 2017 lub nowszy
cmake -G "Visual Studio 16 2019" .
cmake --build . --config Release
```

### Linux:
```bash
mkdir build && cd build
cmake ..
make -j$(nproc)
```

### Wymagania:
- CMake 3.16+
- C++17 compiler
- MySQL/MariaDB
- Boost
- Crypto++
- LuaJIT
- pugiXML

## Wersje protokołu:

### Wspierane wersje Tibia:
- 7.x
- 8.x
- 9.x
- 10.x
- 11.x
- 12.x
- 13.x (w nowszych wersjach)

## Community Resources:

### Fora:
- OTLand: https://otland.net/
- Support Forum: https://otland.net/forums/support.16/

### Wiki:
- https://github.com/otland/forgottenserver/wiki
- Script Interface: https://github.com/otland/forgottenserver/wiki/Script-Interface

### Discord:
- Różne community discordy (sprawdzaj OTLand)

## Bezpieczeństwo:

### Zabezpieczenia:
- SHA1/MD5 haszowanie haseł
- Account manager
- IP banning system
- Anti-spam protection
- Custom opcodes dla bot protection

## Docker Support:

### Uruchomienie w Docker:
```bash
docker build -t forgottenserver .
docker run -d forgottenserver
```

## Premium Support:

### OTLand Premium:
- Dostęp do premium forum
- Szybsze wsparcie
- Exclusive tutoriale
- Link: https://otland.net/account/upgrades

## Różnice między TFS wersjami:

### TFS 0.x (Legacy)
- Stary system skryptów
- XML configuration
- Brak RevScripts

### TFS 1.x (Current)
- RevScripts support
- Nowoczesny Lua API
- Lepszy performance
- C++17

## Najważniejsze pliki:

### config.lua
- Konfiguracja serwera
- Rate experience/skill/loot
- Database settings
- World type

### schema.sql
- Struktura bazy danych
- Tworzenie tabel
- Initial setup

### key.pem
- RSA private key
- Szyfrowanie komunikacji
- Security

## Przydatne narzędzia:

### Map Editors:
- Remere's Map Editor (RME)
- OT Map Editor

### Database Tools:
- phpMyAdmin
- MySQL Workbench

### Item/Sprite Editors:
- Object Builder
- Tibia Sprite Editor

---

*Ostatnia aktualizacja: 25 stycznia 2026*
