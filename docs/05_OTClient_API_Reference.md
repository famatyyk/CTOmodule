# OTClient Lua API Reference

## Kompletna dokumentacja API dla OTClient i OTClientV8

---

## 1. PLAYER API

### Player Object

```lua
player                          -- Główny obiekt gracza

-- Basic Info
player:getId()                  -- ID gracza
player:getName()                -- Nazwa gracza
player:getLevel()               -- Level
player:getExperience()          -- Experience
player:getVocation()            -- Vocation ID

-- Health & Mana
player:getHealth()              -- Aktualne HP
player:getMaxHealth()           -- Max HP
player:getMana()                -- Aktualna mana
player:getMaxMana()             -- Max mana
player:getSoul()                -- Soul points

-- Helper functions
hppercent()                     -- HP w % (0-100)
manapercent()                   -- Mana w % (0-100)

-- Position
player:getPosition()            -- {x, y, z}
player:getDirection()           -- 0=North, 1=East, 2=South, 3=West
posz()                          -- Aktualny floor (z)

-- Skills
player:getSkillLevel(skill)     -- Level skilla
player:getSkillBaseLevel(skill) -- Base level (bez bonusów)
player:getSkillPercent(skill)   -- % do następnego levelu

-- Skill IDs:
Skill_Fist = 0
Skill_Club = 1
Skill_Sword = 2
Skill_Axe = 3
Skill_Distance = 4
Skill_Shielding = 5
Skill_Fishing = 6
Skill_CriticalChance = 7
Skill_CriticalDamage = 8
Skill_LifeLeechChance = 9
Skill_LifeLeechAmount = 10
Skill_ManaLeechChance = 11
Skill_ManaLeechAmount = 12

-- Inventory
player:getInventoryItem(slot)  -- Item w slocie

-- Inventory Slots:
SlotHead = 1
SlotNecklace = 2
SlotBackpack = 3
SlotArmor = 4
SlotRight = 5
SlotLeft = 6
SlotLegs = 7
SlotFeet = 8
SlotRing = 9
SlotAmmo = 10

-- States
player:isPremium()              -- Czy ma premium?
player:isDead()                 -- Czy jest martwy?
player:isAutoWalking()          -- Czy auto-chodzi?
player:hasState(state)          -- Czy ma state (poisoned, etc)?

-- States:
PlayerStates = {
  Poison = 1,
  Burn = 2,
  Energy = 4,
  Drunk = 8,
  ManaShield = 16,
  Paralyze = 32,
  Haste = 64,
  Swords = 128,
  Drowning = 256,
  Freezing = 512,
  Dazzled = 1024,
  Cursed = 2048,
  Strengthened = 4096,
  ProtectionZone = 8192,
  NoPvpZone = 16384
}

-- Light
player:getLightColor()          -- Kolor światła
player:getLightIntensity()      -- Intensywność światła

-- Outfit
player:getOutfit()              -- Tabela z outfit
-- {
--   type = 128,
--   head = 0-132,
--   body = 0-132,
--   legs = 0-132,
--   feet = 0-132,
--   addons = 0-3
-- }

-- Speed
player:getSpeed()               -- Prędkość chodzenia
player:getBaseSpeed()           -- Bazowa prędkość
```

---

## 2. GAME API

### Game Functions

```lua
-- Connection
g_game.isOnline()               -- Czy zalogowany?
g_game.isConnectionOk()         -- Czy połączenie OK?
g_game.getPing()                -- Ping w ms

-- World
g_game.getWorldName()           -- Nazwa świata
g_game.getGMActions()           -- GM actions (jeśli GM)

-- Attack & Follow
g_game.attack(creature)         -- Atak na creature
g_game.follow(creature)         -- Follow creature
g_game.cancelAttack()           -- Anuluj atak
g_game.cancelFollow()           -- Anuluj follow
g_game.isAttacking()            -- Czy atakujesz?
g_game.isFollowing()            -- Czy followujesz?

-- Target
getTarget()                     -- Aktualny target (creature)

-- Movement
g_game.walk(direction)          -- Idź w kierunku
-- Directions:
North = 0
East = 1
South = 2
West = 3
NorthEast = 4
SouthEast = 5
SouthWest = 6
NorthWest = 7

g_game.turn(direction)          -- Obróć się
autoWalk(position)              -- Auto-walk do pozycji
g_game.stop()                   -- Zatrzymaj chodzenie

-- Items
g_game.use(item)                -- Użyj item
g_game.useWith(item, target)    -- Użyj item na target
usewith(itemId, target)         -- Helper function
g_game.move(item, toPos, count) -- Przenieś item
g_game.rotate(item)             -- Obróć item (jeśli rotatable)

-- Look
g_game.look(thing)              -- Look at thing
g_game.open(item, container)    -- Otwórz container

-- Communication
g_game.talk(message)            -- Powiedzenie
say(text)                       -- Helper function
g_game.talkChannel(type, channel, message)  -- Kanał
g_game.talkPrivate(type, name, message)     -- Prywatna wiadomość

-- Message Types:
MessageSay = 1
MessageWhisper = 2
MessageYell = 3
MessagePrivateFrom = 4
MessagePrivateTo = 5
MessageChannelManagement = 6
MessageChannel = 7
MessageChannelHighlight = 8
MessageSpell = 9
MessageNpcFrom = 10
MessageNpcTo = 11
MessageGamemasterBroadcast = 12
MessageGamemasterChannel = 13
MessageGamemasterPrivateFrom = 14
MessageGamemasterPrivateTo = 15
MessageLogin = 16
MessageWarning = 17
MessageGame = 18
MessageFailure = 19
MessageLook = 20
MessageDamageDealed = 21
MessageDamageReceived = 22
MessageHeal = 23
MessageExp = 24
MessageDamageOthers = 25
MessageHealOthers = 26
MessageExpOthers = 27
MessageStatus = 28
MessageLoot = 29
MessageTradeNpc = 30
MessageGuild = 31
MessagePartyManagement = 32
MessageParty = 33
MessageBarkLow = 34
MessageBarkLoud = 35
MessageReport = 36
MessageHotkeyUse = 37
MessageTutorialHint = 38
MessageThankyou = 39
MessageMarket = 40

-- Channels
g_game.joinChannel(channelId)   -- Dołącz do kanału
g_game.leaveChannel(channelId)  -- Opuść kanał

-- Party
g_game.partyInvite(playerId)    -- Zaproś do party
g_game.partyJoin(playerId)      -- Dołącz do party
g_game.partyRevokeInvitation(playerId) -- Odwołaj zaproszenie
g_game.partyPassLeadership(playerId)   -- Przekaż leadership
g_game.partyLeave()             -- Opuść party
g_game.partyShareExperience(enabled)   -- Share exp

-- VIP
g_game.addVip(name)             -- Dodaj VIP
g_game.removeVip(playerId)      -- Usuń VIP

-- Container
g_game.openContainer(item)      -- Otwórz container
g_game.closeContainer(containerId) -- Zamknij
g_game.refreshContainer(containerId) -- Odśwież

-- Shop (NPC)
g_game.buyItem(item, amount, ignoreCapacity, inBackpacks)
g_game.sellItem(item, amount, ignoreEquipped)
g_game.closeNpcTrade()          -- Zamknij trade

-- Rule Violations
g_game.reportRuleViolation(target, reason, comment, statement, action)
```

---

## 3. MAP API

### Map Functions

```lua
-- Get objects
g_map.getTiles(z)               -- Wszystkie tiles na floor z
g_map.getTile(position)         -- Tile na pozycji
g_map.getCreatures()            -- Wszystkie creatures
g_map.getSpectators(position, multiFloor) -- Creatures wokół pozycji

-- Helpers
getClosestMonster()             -- Najbliższy potwór
getDistanceBetween(pos1, pos2)  -- Dystans między pozycjami

-- Clean
g_map.clean()                   -- Wyczyść mapę
g_map.cleanTile(position)       -- Wyczyść tile
```

### Tile Object

```lua
tile:getPosition()              -- {x, y, z}
tile:getGround()                -- Ground item
tile:getItems()                 -- Wszystkie itemy
tile:getCreatures()             -- Wszystkie creatures
tile:getTopThing()              -- Najwyższa rzecz
tile:getTopUseThing()           -- Top use thing
tile:getTopCreature()           -- Top creature
tile:getTopMoveThing()          -- Top move thing

-- Checks
tile:isWalkable()               -- Czy można chodzić?
tile:isEmpty()                  -- Czy pusty?
tile:isFullGround()             -- Czy pełny ground?
tile:getGroundSpeed()           -- Prędkość na ground
tile:hasCreature()              -- Czy ma creature?

-- Counts
tile:getCreatureCount()         -- Liczba creatures
tile:getItemCount()             -- Liczba items
tile:getThingCount()            -- Liczba wszystkiego
```

---

## 4. CREATURE API

### Creature Object

```lua
-- Basic Info
creature:getId()                -- ID creature
creature:getName()              -- Nazwa
creature:getHealthPercent()     -- HP w % (0-100)
creature:getPosition()          -- Pozycja
creature:getDirection()         -- Kierunek
creature:getSpeed()             -- Prędkość
creature:getSkull()             -- Skull (PvP)
creature:getShield()            -- Shield (party/guild)
creature:getEmblem()            -- Emblem (guild)
creature:getType()              -- Type of creature
creature:getIcon()              -- Icon

-- Types
creature:isPlayer()             -- Czy gracz?
creature:isMonster()            -- Czy potwór?
creature:isNpc()                -- Czy NPC?

-- States
creature:isDead()               -- Czy martwy?
creature:canShoot(toPosition)   -- Czy może strzelić?

-- Outfit
creature:getOutfit()            -- Outfit data

-- Light
creature:getLightColor()        -- Kolor światła
creature:getLightIntensity()    -- Intensywność

-- Distance
creature:getStepDuration()      -- Czas kroku
creature:getStepProgress()      -- Progress kroku
creature:getWalkOffsetY()       -- Y offset podczas chodzenia
```

---

## 5. ITEM API

### Item Object

```lua
-- Basic Info
item:getId()                    -- Item ID
item:getServerId()              -- Server ID (może być inny)
item:getClientId()              -- Client ID
item:getCount()                 -- Liczba stackowalnych
item:getCountOrSubType()        -- Count lub subtype
item:getSubType()               -- Subtype (np. charges)
item:getPosition()              -- Pozycja
item:getContainerId()           -- Container ID (jeśli w containerze)

-- Properties
item:getDescription()           -- Opis itemu
item:isStackable()              -- Czy stackowalny?
item:isMarketable()             -- Czy na markecie?
item:isNotMoveable()            -- Czy niemożliwy do przeniesienia?

-- Container
item:isContainer()              -- Czy to container?
item:getSize()                  -- Rozmiar (jeśli container)
item:getCapacity()              -- Pojemność (jeśli container)
item:getItemsCount()            -- Liczba items (jeśli container)
item:getItem(index)             -- Item w containerze
item:getItems()                 -- Wszystkie items w containerze

-- Fluid
item:isFluidContainer()         -- Czy fluid container?
item:getFluidType()             -- Typ fluidu

-- Checks
item:canDraw()                  -- Czy można rysować? (jeśli ground)
```

---

## 6. UI API

### UI Functions

```lua
-- Modules
g_modules.getModule(name)       -- Pobierz moduł
g_modules.discoverModule(path)  -- Odkryj moduł
g_modules.loadModules()         -- Załaduj wszystkie moduły
g_modules.autoLoadModules(path) -- Auto load z path

-- Windows
g_window.setTitle(title)        -- Ustaw tytuł okna
g_window.setIcon(icon)          -- Ustaw ikonę
g_window.setMinimumSize(size)   -- Min rozmiar
g_window.setMaximumSize(size)   -- Max rozmiar
g_window.resize(size)           -- Zmień rozmiar
g_window.show()                 -- Pokaż
g_window.hide()                 -- Ukryj
g_window.minimize()             -- Minimalizuj
g_window.maximize()             -- Maksymalizuj

-- UI Root
g_ui.getRootWidget()            -- Root widget
g_ui.loadUI(file, parent)       -- Załaduj UI z pliku
g_ui.displayUI(file)            -- Display UI

-- Keyboard
g_window.setFocusedWidget(widget) -- Focus na widget
```

---

## 7. RESOURCES API

### Resources Functions

```lua
-- Files
g_resources.fileExists(path)    -- Czy plik istnieje?
g_resources.readFileContents(path) -- Odczytaj zawartość
g_resources.listDirectoryFiles(path) -- Lista plików
g_resources.guessFilePath(name, type) -- Zgadnij ścieżkę

-- Directories
g_resources.directoryExists(path) -- Czy katalog istnieje?
g_resources.makeDir(path)       -- Stwórz katalog
g_resources.listDirectoryFiles(path) -- Lista plików

-- Search
g_resources.resolvePath(path)   -- Resolve ścieżki
g_resources.getRealDir(path)    -- Prawdziwy katalog
```

---

## 8. HTTP/WEBSOCKET API (OTCv8)

### HTTP Functions

```lua
HTTP.get(url, callback)         -- GET request
HTTP.post(url, data, callback)  -- POST request
HTTP.download(url, path, callback) -- Download file

-- Przykład GET:
HTTP.get("https://api.example.com/data", function(data, err)
  if err then
    print("Error: " .. err)
    return
  end
  
  local json = JSON.decode(data)
  print(json.value)
end)

-- Przykład POST:
local postData = {
  username = "player",
  action = "login"
}

HTTP.post("https://api.example.com/login", 
  JSON.encode(postData), 
  function(response, err)
    if err then
      print("Error: " .. err)
      return
    end
    
    print("Response: " .. response)
  end
)
```

### WebSocket Functions

```lua
local ws = WebSocket.create()

ws:connect(url)                 -- Połącz z WebSocket
ws:send(data)                   -- Wyślij dane
ws:close()                      -- Zamknij połączenie

-- Events:
ws.onOpen = function()
  print("WebSocket connected!")
end

ws.onMessage = function(message)
  print("Received: " .. message)
end

ws.onError = function(error)
  print("Error: " .. error)
end

ws.onClose = function()
  print("WebSocket closed!")
end

-- Przykład:
local ws = WebSocket.create()

ws.onOpen = function()
  ws:send("Hello Server!")
end

ws.onMessage = function(msg)
  print("Server says: " .. msg)
end

ws:connect("ws://localhost:8080")
```

### JSON Functions

```lua
JSON.encode(table)              -- Table -> JSON string
JSON.decode(string)             -- JSON string -> table

-- Przykład:
local data = {
  name = "Player",
  level = 100,
  items = {1234, 5678}
}

local jsonString = JSON.encode(data)
-- '{"name":"Player","level":100,"items":[1234,5678]}'

local decoded = JSON.decode(jsonString)
print(decoded.name) -- "Player"
```

---

## 9. STORAGE & SETTINGS API

### Storage Functions

```lua
g_settings.set(key, value)      -- Zapisz ustawienie
g_settings.get(key, default)    -- Odczytaj ustawienie
g_settings.exists(key)          -- Czy istnieje?
g_settings.remove(key)          -- Usuń
g_settings.save()               -- Zapisz do pliku

-- Przykład:
g_settings.set("autoHeal", true)
g_settings.set("healHP", 50)

if g_settings.get("autoHeal", false) then
  local healHP = g_settings.get("healHP", 60)
  print("Auto heal at " .. healHP .. "%")
end
```

---

## 10. EXTENDED OPCODES API

### Extended Opcode Functions

```lua
-- Wysyłanie (Client -> Server)
g_game.sendExtendedOpcode(opcode, buffer)

-- Odbieranie (Server -> Client)
function parseOpcodes(opcode, buffer)
  if opcode == 1 then
    print("Received opcode 1: " .. buffer)
  elseif opcode == 2 then
    local data = JSON.decode(buffer)
    print("Quest progress: " .. data.progress)
  end
end

-- Register
ExtendedOpcode = {
  ping = 1,
  quest = 2,
  custom = 3,
}

-- Przykład wysyłania:
local data = {
  action = "getQuest",
  questId = 123
}

g_game.sendExtendedOpcode(ExtendedOpcode.quest, JSON.encode(data))
```

---

## 11. EVENT CALLBACKS

### Player Events

```lua
-- Position change
onPlayerPositionChange(function(newPos, oldPos)
  print("Moved from " .. oldPos.x .. "," .. oldPos.y .. 
        " to " .. newPos.x .. "," .. newPos.y)
end)

-- Health change
onHealthChange(function(health, maxHealth)
  print("HP: " .. health .. "/" .. maxHealth)
end)

-- Mana change
onManaChange(function(mana, maxMana)
  print("Mana: " .. mana .. "/" .. maxMana)
end)

-- Level change
onLevelChange(function(level)
  print("New level: " .. level)
end)

-- States change
onStatesChange(function(states)
  if bit32.band(states, PlayerStates.Poison) ~= 0 then
    print("Poisoned!")
  end
end)
```

### Game Events

```lua
-- Attack
onAttackChange(function(creature)
  if creature then
    print("Attacking: " .. creature:getName())
  else
    print("Stopped attacking")
  end
end)

-- Follow
onFollowChange(function(creature)
  if creature then
    print("Following: " .. creature:getName())
  end
end)

-- Talk
onTalk(function(name, level, mode, text, channelId, pos)
  print(name .. " says: " .. text)
end)

-- Text message
onTextMessage(function(mode, text)
  print("Message: " .. text)
end)

-- Game end
onGameEnd(function()
  print("Game ended!")
end)

-- Game start
onGameStart(function()
  print("Game started!")
end)
```

---

## 12. UTILITY FUNCTIONS

### Math Utilities

```lua
-- Distance
function getDistanceBetween(pos1, pos2)
  local dx = pos1.x - pos2.x
  local dy = pos1.y - pos2.y
  return math.sqrt(dx * dx + dy * dy)
end

-- Manhattan distance (dla tibia pathing)
function getManhattanDistance(pos1, pos2)
  return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

-- In range?
function isInRange(pos1, pos2, range)
  return getManhattanDistance(pos1, pos2) <= range
end
```

### Table Utilities

```lua
-- Contains
function table.contains(tbl, element)
  for _, value in pairs(tbl) do
    if value == element then
      return true
    end
  end
  return false
end

-- Find
function table.find(tbl, element)
  for key, value in pairs(tbl) do
    if value == element then
      return key
    end
  end
  return nil
end

-- Copy
function table.copy(tbl)
  local copy = {}
  for k, v in pairs(tbl) do
    if type(v) == "table" then
      copy[k] = table.copy(v)
    else
      copy[k] = v
    end
  end
  return copy
end

-- Merge
function table.merge(tbl1, tbl2)
  for k, v in pairs(tbl2) do
    tbl1[k] = v
  end
  return tbl1
end

-- Count
function table.count(tbl)
  local count = 0
  for _ in pairs(tbl) do
    count = count + 1
  end
  return count
end
```

### String Utilities

```lua
-- Split
function string:split(delimiter)
  local result = {}
  local from = 1
  local delim_from, delim_to = string.find(self, delimiter, from)
  
  while delim_from do
    table.insert(result, string.sub(self, from, delim_from-1))
    from = delim_to + 1
    delim_from, delim_to = string.find(self, delimiter, from)
  end
  
  table.insert(result, string.sub(self, from))
  return result
end

-- Trim
function string:trim()
  return self:match("^%s*(.-)%s*$")
end

-- Starts with
function string:startsWith(prefix)
  return self:sub(1, #prefix) == prefix
end

-- Ends with
function string:endsWith(suffix)
  return suffix == "" or self:sub(-#suffix) == suffix
end
```

---

## 13. SCHEDULE & TIMERS

### Schedule Functions

```lua
-- Wykonaj po opóźnieniu
scheduleEvent(callback, delay)

-- Przykład:
scheduleEvent(function()
  print("This runs after 5 seconds")
end, 5000)

-- Powtarzające się
local eventId
eventId = scheduleEvent(function()
  print("This runs every second")
  scheduleEvent(eventId, 1000) -- Re-schedule
end, 1000)

-- Anuluj event
removeEvent(eventId)
```

### Cyklic Timer

```lua
-- Macro (z OTCv8)
macro(interval, name, callback)

-- Przykład:
macro(1000, "Timer", function()
  print("Runs every second")
end)

-- Z warunkiem stop
local counter = 0
macro(1000, "Counter", function()
  counter = counter + 1
  print("Count: " .. counter)
  
  if counter >= 10 then
    return false -- Stop macro
  end
end)
```

---

*Ostatnia aktualizacja: 25 stycznia 2026*
