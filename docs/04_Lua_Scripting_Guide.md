# Lua Scripting Guide - OTC & TFS

## Podstawy Lua

### Co to jest Lua?
Lua to lekki, szybki język skryptowy zaprojektowany do embedowania w aplikacjach. Jest używany w:
- OTClient (interfejs, moduły, bot)
- TFS (game logic, questy, NPC)
- Wiele gier AAA (World of Warcraft, Roblox, itp.)

### Podstawowa składnia:

```lua
-- Komentarze
-- To jest komentarz jednoliniowy

--[[
  To jest komentarz
  wieloliniowy
]]

-- Zmienne
local zmienna = "wartość"
local liczba = 42
local boolean = true
local tabela = {}

-- Funkcje
function mojaFunkcja(parametr)
  return parametr * 2
end

-- Lub
local mojaFunkcja2 = function(parametr)
  return parametr + 1
end

-- Warunki
if zmienna == "wartość" then
  print("Tak!")
elseif liczba > 50 then
  print("Większa")
else
  print("Nie")
end

-- Pętle
for i = 1, 10 do
  print(i)
end

for index, value in ipairs(tabela) do
  print(index, value)
end

while liczba > 0 do
  liczba = liczba - 1
end

-- Tablice (arrays)
local tablica = {1, 2, 3, 4, 5}
print(tablica[1]) -- 1 (indeksy od 1!)

-- Tabele (dictionaries/objects)
local player = {
  name = "Player",
  level = 100,
  vocation = "Knight"
}
print(player.name) -- "Player"
print(player["level"]) -- 100
```

## Lua w OTClient - Bot Scripting

### 1. Macro System

#### Podstawowa struktura:
```lua
macro(interval, "Nazwa", function()
  -- Kod wykonywany co 'interval' milisekund
end)
```

#### Przykłady:
```lua
-- Auto heal
macro(100, "Auto Heal", function()
  if hppercent() < 50 then
    say("exura gran")
  end
end)

-- Auto attack
macro(500, "Auto Attack", function()
  if not g_game.isAttacking() then
    local target = getClosestMonster()
    if target then
      g_game.attack(target)
    end
  end
end)
```

### 2. Player Functions

```lua
-- Informacje o graczu
player                      -- Obiekt gracza
player:getName()           -- Nazwa
player:getHealth()         -- Aktualne HP
player:getMaxHealth()      -- Max HP
player:getMana()           -- Aktualna mana
player:getMaxMana()        -- Max mana
player:getLevel()          -- Level
player:getPosition()       -- Pozycja {x, y, z}

-- Helper functions
hppercent()                -- % HP (0-100)
manapercent()              -- % Mana (0-100)
posz()                     -- Aktualny poziom (floor)

-- Inventory
player:getInventoryItem(slot) -- Item w slocie

-- Slots:
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
```

### 3. Game Functions

```lua
-- Komunikacja
say(text)                  -- Powiedzenie tekstu
g_game.talk(text)          -- To samo co say()

-- Walka
g_game.attack(creature)    -- Atak na stworzenie
g_game.follow(creature)    -- Podążanie za stworzeniem
g_game.cancelAttack()      -- Anuluj atak
g_game.isAttacking()       -- Czy atakujesz?

-- Target
getTarget()                -- Aktualny target
getClosestMonster()        -- Najbliższy potwór

-- Items
usewith(itemId, target)    -- Użyj item na target
g_game.use(item)           -- Użyj item
g_game.move(item, toPos, count) -- Przenieś item

-- Pozycja dla inventory:
{x=65535, y=slot, z=0}
```

### 4. Map & Creatures

```lua
-- Mapa
g_map.getTiles(z)          -- Wszystkie tile'e na poziomie z
g_map.getTile(pos)         -- Tile na pozycji
g_map.getCreatures()       -- Wszystkie creatures na mapie

-- Tile functions
tile:getPosition()         -- Pozycja tile
tile:getItems()            -- Itemy na tile
tile:getCreatures()        -- Creatures na tile
tile:isWalkable()          -- Czy można chodzić?

-- Creature functions
creature:getName()         -- Nazwa
creature:getHealth()       -- HP
creature:getHealthPercent() -- HP w %
creature:getPosition()     -- Pozycja
creature:isPlayer()        -- Czy to gracz?
creature:isMonster()       -- Czy to potwór?
creature:isNpc()           -- Czy to NPC?
```

### 5. Advanced Bot Examples

#### Auto Heal & Mana:
```lua
local healSpell = "exura gran"
local healHP = 50
local manaSpell = "exura"
local manaHP = 80
local manaPotion = 268 -- great mana potion
local manaPotionPercent = 30

macro(100, "Auto Heal & Mana", function()
  local hp = hppercent()
  local mana = manapercent()
  
  if hp < healHP and mana > manaHP then
    say(healSpell)
  elseif mana < manaPotionPercent then
    usewith(manaPotion, player)
  end
end)
```

#### Smart Targeting:
```lua
local targetList = {
  "Dragon",
  "Dragon Lord",
  "Demon"
}

local blacklist = {
  "Rat",
  "Cave Rat"
}

macro(200, "Smart Target", function()
  if g_game.isAttacking() then
    return -- Już atakujemy
  end
  
  local creatures = g_map.getCreatures()
  
  -- Najpierw szukamy priority targets
  for _, creature in ipairs(creatures) do
    local name = creature:getName()
    
    if table.contains(targetList, name) then
      g_game.attack(creature)
      return
    end
  end
  
  -- Potem atakujemy cokolwiek (poza blacklistą)
  for _, creature in ipairs(creatures) do
    local name = creature:getName()
    
    if creature:isMonster() and not table.contains(blacklist, name) then
      g_game.attack(creature)
      return
    end
  end
end)
```

#### Auto Loot:
```lua
local lootList = {
  3031, -- gold coin
  3035, -- platinum coin
  3043, -- crystal coin
  3046, -- magic light wand
  3081, -- stone skin amulet
  -- Dodaj więcej item ID
}

macro(200, "Auto Loot", function()
  local playerPos = player:getPosition()
  
  for _, tile in ipairs(g_map.getTiles(posz())) do
    for _, item in ipairs(tile:getItems()) do
      if table.contains(lootList, item:getId()) then
        local itemPos = item:getPosition()
        
        -- Sprawdź czy item jest blisko
        if math.abs(itemPos.x - playerPos.x) <= 1 and 
           math.abs(itemPos.y - playerPos.y) <= 1 then
          
          g_game.move(item, {x=65535, y=SlotBackpack, z=0}, item:getCount())
        end
      end
    end
  end
end)
```

#### Walker/Cavebot:
```lua
local waypoints = {
  {x=1000, y=1000, z=7, label="hunt_start"},
  {x=1010, y=1000, z=7},
  {x=1010, y=1010, z=7},
  {x=1020, y=1010, z=7, label="hunt_end"},
}

local currentWaypoint = 1
local isWalking = false

macro(1000, "Walker", function()
  if g_game.isAttacking() then
    return -- Nie chodź podczas walki
  end
  
  local playerPos = player:getPosition()
  local targetPos = waypoints[currentWaypoint]
  
  if playerPos.x == targetPos.x and 
     playerPos.y == targetPos.y and 
     playerPos.z == targetPos.z then
    
    -- Dotarliśmy do waypointa
    currentWaypoint = currentWaypoint + 1
    
    if currentWaypoint > #waypoints then
      currentWaypoint = 1 -- Loop
    end
    
    return
  end
  
  -- Idź do waypointa
  if not isWalking then
    autoWalk(targetPos)
    isWalking = true
  end
end)

-- Reset walking flag
onPlayerPositionChange(function()
  isWalking = false
end)
```

## Lua w TFS - Server Scripting

### 1. CreatureScripts

#### onLogin:
```lua
function onLogin(player)
  player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "Welcome " .. player:getName() .. "!")
  
  -- Register events
  player:registerEvent("PlayerDeath")
  player:registerEvent("DropLoot")
  
  return true
end
```

#### onDeath:
```lua
function onDeath(player, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
  print(player:getName() .. " died!")
  
  -- Teleport to temple
  player:teleportTo(player:getTown():getTemplePosition())
  player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
  
  return true
end
```

### 2. Actions (Item Usage)

```lua
local action = Action()

function action.onUse(player, item, fromPosition, target, toPosition, isHotkey)
  local level = player:getLevel()
  
  if level < 50 then
    player:sendCancelMessage("You need level 50 to use this item.")
    return false
  end
  
  player:addHealth(1000)
  player:sendTextMessage(MESSAGE_HEALED, "You healed 1000 HP!")
  item:remove(1)
  
  return true
end

action:id(2345) -- Item ID
action:register()
```

### 3. TalkActions (Commands)

```lua
local talkaction = TalkAction("!teleport")

function talkaction.onSay(player, words, param)
  if not player:getGroup():getAccess() then
    return false -- Only GM
  end
  
  local params = param:split(",")
  local x = tonumber(params[1])
  local y = tonumber(params[2])
  local z = tonumber(params[3])
  
  if not x or not y or not z then
    player:sendCancelMessage("Usage: !teleport x,y,z")
    return false
  end
  
  player:teleportTo(Position(x, y, z))
  player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
  
  return false
end

talkaction:separator(" ")
talkaction:register()
```

### 4. Spells

```lua
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)

function onGetFormulaValues(player, level, magicLevel)
  local min = (level / 5) + (magicLevel * 1.5) + 10
  local max = (level / 5) + (magicLevel * 2.5) + 20
  return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
  return combat:execute(creature, variant)
end

spell:name("exori")
spell:words("exori")
spell:group("attack")
spell:vocation("knight;true", "elite knight;true")
spell:id(60)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(20)
spell:mana(40)
spell:isPremium(true)
spell:range(1)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:register()
```

### 5. GlobalEvents

```lua
local globalevent = GlobalEvent("ServerSave")

function globalevent.onThink(interval)
  -- Broadcast message
  Game.broadcastMessage("Server save in 5 minutes!", MESSAGE_STATUS_WARNING)
  
  -- Schedułuj save
  addEvent(function()
    saveServer()
    Game.broadcastMessage("Server has been saved!", MESSAGE_STATUS_WARNING)
  end, 5 * 60 * 1000) -- 5 minut
  
  return true
end

globalevent:interval(60 * 60 * 1000) -- Co godzinę
globalevent:register()
```

### 6. Movements

```lua
local movement = MoveEvent()

function movement.onStepIn(creature, item, position, fromPosition)
  local player = creature:getPlayer()
  if not player then
    return true
  end
  
  -- Teleport tile
  local destination = Position(1000, 1000, 7)
  player:teleportTo(destination)
  destination:sendMagicEffect(CONST_ME_TELEPORT)
  
  return true
end

movement:type("stepin")
movement:aid(1234) -- Action ID
movement:register()
```

## Przydatne funkcje pomocnicze

### Table functions:
```lua
-- Sprawdź czy element jest w tablicy
function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

-- Find index
function table.find(table, element)
  for index, value in pairs(table) do
    if value == element then
      return index
    end
  end
  return nil
end

-- Remove by value
function table.removeByValue(table, value)
  for i, v in ipairs(table) do
    if v == value then
      table.remove(table, i)
      return true
    end
  end
  return false
end
```

### String functions:
```lua
-- Split string
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

-- Trim whitespace
function string:trim()
  return self:match("^%s*(.-)%s*$")
end
```

### Math functions:
```lua
-- Distance między punktami
function getDistanceBetween(pos1, pos2)
  local dx = pos1.x - pos2.x
  local dy = pos1.y - pos2.y
  return math.sqrt(dx * dx + dy * dy)
end

-- Random number w zakresie
function math.random_range(min, max)
  return math.random() * (max - min) + min
end
```

## Best Practices

### 1. Zawsze używaj `local`:
```lua
-- ✅ Dobrze
local zmienna = 10

-- ❌ Źle (global)
zmienna = 10
```

### 2. Komentuj kod:
```lua
-- Sprawdź HP gracza przed healem
if hppercent() < 50 then
  say("exura gran")
end
```

### 3. Używaj meaningful names:
```lua
-- ✅ Dobrze
local healingSpell = "exura gran"
local minimumHealthPercent = 50

-- ❌ Źle
local hs = "exura gran"
local mhp = 50
```

### 4. Unikaj magic numbers:
```lua
-- ✅ Dobrze
local GOLD_COIN_ID = 3031
if item:getId() == GOLD_COIN_ID then

-- ❌ Źle
if item:getId() == 3031 then
```

### 5. Error handling:
```lua
local success, result = pcall(function()
  -- Kod który może error
  riskyFunction()
end)

if not success then
  print("Error: " .. result)
end
```

---

*Ostatnia aktualizacja: 25 stycznia 2026*
