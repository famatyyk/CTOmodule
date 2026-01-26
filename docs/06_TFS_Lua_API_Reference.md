# TFS Lua API Reference - Complete

## Kompletna dokumentacja Lua API dla The Forgotten Server

---

## 1. PLAYER CLASS

### Basic Functions

```lua
-- Info
player:getName()                    -- Nazwa gracza
player:getGuid()                    -- Global unique ID
player:getAccountId()               -- Account ID
player:getAccountType()             -- Typ konta (1=normal, 2=tutor, 3=seniortutor, 4=gm, 5=god)
player:getIp()                      -- IP address

-- Position
player:getPosition()                -- Position object
player:getTile()                    -- Tile object
player:getTown()                    -- Town object
player:getDepotChest(depotId)       -- Depot chest

-- Level & Experience
player:getLevel()                   -- Level
player:getExperience()              -- Experience
player:addExperience(amount, sendText) -- Dodaj exp
player:removeExperience(amount)     -- Usuń exp
player:getExperienceForLevel(level) -- Exp potrzebne dla levelu

-- Health & Mana
player:getHealth()                  -- HP
player:getMaxHealth()               -- Max HP
player:getMana()                    -- Mana
player:getMaxMana()                 -- Max mana
player:addHealth(health)            -- Dodaj HP
player:addMana(mana)                -- Dodaj manę

-- Soul
player:getSoul()                    -- Soul points
player:addSoul(soul)                -- Dodaj soul
player:getMaxSoul()                 -- Max soul

-- Stamina
player:getStamina()                 -- Stamina (minuty)
player:setStamina(stamina)          -- Ustaw stamina

-- Skills
player:getSkillLevel(skillId)       -- Level skilla
player:addSkillTries(skillId, tries) -- Dodaj tries
player:getSkillTries(skillId)       -- Tries
player:getSkillPercent(skillId)     -- % do next level

-- Skill IDs:
SKILL_FIST = 0
SKILL_CLUB = 1
SKILL_SWORD = 2
SKILL_AXE = 3
SKILL_DISTANCE = 4
SKILL_SHIELD = 5
SKILL_FISHING = 6
SKILL_MAGLEVEL = 7
SKILL_LEVEL = 8

-- Magic Level
player:getMagicLevel()              -- Magic level
player:getBaseMagicLevel()          -- Base (bez bonusów)
player:addManaSpent(amount)         -- Dodaj mana spent

-- Vocation
player:getVocation()                -- Vocation object
player:setVocation(vocationId)      -- Zmień vocation

-- Capacity
player:getCapacity()                -- Free cap
player:setCapacity(capacity)        -- Ustaw cap
player:getFreeCapacity()            -- Wolna cap
```

### Combat Functions

```lua
-- Conditions
player:addCondition(condition)      -- Dodaj condition
player:removeCondition(type)        -- Usuń condition
player:hasCondition(type)           -- Czy ma condition?

-- Condition Types:
CONDITION_NONE = 0
CONDITION_POISON = 1
CONDITION_FIRE = 2
CONDITION_ENERGY = 3
CONDITION_BLEEDING = 4
CONDITION_HASTE = 5
CONDITION_PARALYZE = 6
CONDITION_OUTFIT = 7
CONDITION_INVISIBLE = 8
CONDITION_LIGHT = 9
CONDITION_MANASHIELD = 10
CONDITION_INFIGHT = 11
CONDITION_DRUNK = 12
CONDITION_EXHAUST = 13
CONDITION_REGENERATION = 14
CONDITION_SOUL = 15
CONDITION_DROWN = 16
CONDITION_MUTED = 17
CONDITION_CHANNELMUTEDTICKS = 18
CONDITION_YELLTICKS = 19
CONDITION_ATTRIBUTES = 20
CONDITION_FREEZING = 21
CONDITION_DAZZLED = 22
CONDITION_CURSED = 23

-- Combat
player:getAttackFactor()            -- Attack factor
player:getDefenseFactor()           -- Defense factor
player:addDefense(defense)          -- Dodaj defense
player:addAttack(attack)            -- Dodaj attack

-- PvP
player:getSkull()                   -- Skull
player:setSkull(skull)              -- Ustaw skull

-- Skull Types:
SKULL_NONE = 0
SKULL_YELLOW = 1
SKULL_GREEN = 2
SKULL_WHITE = 3
SKULL_RED = 4
SKULL_BLACK = 5

player:addSkullTime(time)           -- Dodaj skull time
```

### Item Functions

```lua
-- Inventory
player:getSlotItem(slot)            -- Item w slocie
player:getItemCount(itemId, subType) -- Liczba itemów
player:getItemById(itemId, deepSearch, subType) -- Znajdź item

-- Slot IDs:
CONST_SLOT_HEAD = 1
CONST_SLOT_NECKLACE = 2
CONST_SLOT_BACKPACK = 3
CONST_SLOT_ARMOR = 4
CONST_SLOT_RIGHT = 5
CONST_SLOT_LEFT = 6
CONST_SLOT_LEGS = 7
CONST_SLOT_FEET = 8
CONST_SLOT_RING = 9
CONST_SLOT_AMMO = 10

-- Add/Remove
player:addItem(itemId, count, canDropOnMap, subType, slot)
player:removeItem(itemId, count, subType, ignoreEquipped)

-- Container
player:getContainerById(containerId) -- Container object
player:getContainerIndex(containerId) -- Index
```

### Communication

```lua
-- Messages
player:sendTextMessage(type, text)  -- Wyślij wiadomość
player:sendCancelMessage(text)      -- Cancel message
player:sendPrivateMessage(speaker, text, type) -- Prywatna

-- Message Types:
MESSAGE_STATUS_CONSOLE_BLUE = 4
MESSAGE_STATUS_CONSOLE_RED = 13
MESSAGE_STATUS_DEFAULT = 17
MESSAGE_STATUS_WARNING = 18
MESSAGE_EVENT_ADVANCE = 19
MESSAGE_EVENT_DEFAULT = 20
MESSAGE_STATUS_SMALL = 21
MESSAGE_INFO_DESCR = 22
MESSAGE_DAMAGE_DEALT = 23
MESSAGE_DAMAGE_RECEIVED = 24
MESSAGE_HEALED = 25
MESSAGE_EXPERIENCE = 26
MESSAGE_DAMAGE_OTHERS = 27
MESSAGE_HEALED_OTHERS = 28
MESSAGE_EXPERIENCE_OTHERS = 29
MESSAGE_EVENT_ORANGE = 36
MESSAGE_STATUS_CONSOLE_ORANGE = 37

-- Channels
player:getChannels()                -- Lista kanałów
player:openChannel(channelId)       -- Otwórz kanał

-- Modal Window
player:showTextDialog(itemId, text) -- Pokaż text dialog
player:sendChannelMessage(author, text, type, channelId)
```

### Movement Functions

```lua
-- Teleport
player:teleportTo(position, pushMovement) -- Teleport
player:getPosition():sendMagicEffect(effectId) -- Efekt

-- Walk
player:isWalking()                  -- Czy chodzi?
player:getSpeed()                   -- Prędkość
player:setSpeed(speed)              -- Ustaw prędkość
player:getBaseSpeed()               -- Bazowa prędkość

-- Direction
player:getDirection()               -- Kierunek
player:setDirection(direction)      -- Ustaw kierunek

-- Directions:
DIRECTION_NORTH = 0
DIRECTION_EAST = 1
DIRECTION_SOUTH = 2
DIRECTION_WEST = 3
```

### Storage Functions

```lua
-- Storage Values
player:setStorageValue(key, value)  -- Ustaw storage
player:getStorageValue(key)         -- Pobierz storage
```

### Party & Guild

```lua
-- Party
player:getParty()                   -- Party object
player:isInParty()                  -- Czy w party?

-- Guild
player:getGuild()                   -- Guild object
player:getGuildLevel()              -- Guild level (rank)
player:getGuildNick()               -- Guild nickname
player:setGuildNick(nick)           -- Ustaw guild nick
```

### Other Functions

```lua
-- Premium
player:isPremium()                  -- Czy premium?
player:setPremiumDays(days)         -- Ustaw premium days
player:getPremiumDays()             -- Pozostałe dni

-- Bank
player:getBankBalance()             -- Saldo banku
player:setBankBalance(balance)      -- Ustaw saldo

-- Outfit
player:getOutfit()                  -- Outfit table
player:setOutfit(outfit)            -- Ustaw outfit
player:addOutfit(lookType)          -- Dodaj outfit
player:removeOutfit(lookType)       -- Usuń outfit
player:hasOutfit(lookType, addon)   -- Czy ma outfit?
player:addOutfitAddon(lookType, addon) -- Dodaj addon

-- Mounts
player:hasMount(mountId)            -- Czy ma mount?
player:addMount(mountId)            -- Dodaj mount
player:removeMount(mountId)         -- Usuń mount
player:toggleMount(mount)           -- Toggle mount
player:isOnMount()                  -- Czy na mount?

-- Special
player:save()                       -- Zapisz gracza
player:remove()                     -- Usuń z gry
player:isPzLocked()                 -- Czy PZ locked?
player:sendPing()                   -- Wyślij ping
player:resetIdleTime()              -- Reset idle
```

---

## 2. CREATURE CLASS

### Basic Functions

```lua
-- Info
creature:getName()                  -- Nazwa
creature:getId()                    -- ID
creature:isRemoved()                -- Czy usunięty?

-- Type checks
creature:isPlayer()                 -- Czy gracz?
creature:isMonster()                -- Czy potwór?
creature:isNpc()                    -- Czy NPC?

-- Health
creature:getHealth()                -- HP
creature:getMaxHealth()             -- Max HP
creature:setMaxHealth(health)       -- Ustaw max HP
creature:addHealth(health)          -- Dodaj HP

-- Position
creature:getPosition()              -- Pozycja
creature:getTile()                  -- Tile
creature:getDirection()             -- Kierunek
creature:setDirection(direction)    -- Ustaw kierunek

-- Movement
creature:teleportTo(position)       -- Teleport
creature:getSpeed()                 -- Prędkość
creature:setSpeed(speed)            -- Ustaw prędkość
creature:getBaseSpeed()             -- Bazowa prędkość

-- Target
creature:getTarget()                -- Target creature
creature:setTarget(target)          -- Ustaw target
creature:getFollowCreature()        -- Follow target
creature:setFollowCreature(creature) -- Ustaw follow

-- Master (dla summonów)
creature:getMaster()                -- Master creature
creature:setMaster(master)          -- Ustaw master

-- Combat
creature:getOutfit()                -- Outfit
creature:setOutfit(outfit)          -- Ustaw outfit
creature:getLight()                 -- Światło
creature:setLight(color, level)     -- Ustaw światło

-- Conditions
creature:getCondition(type)         -- Pobierz condition
creature:addCondition(condition)    -- Dodaj condition
creature:removeCondition(type)      -- Usuń condition
creature:hasCondition(type)         -- Czy ma condition?

-- Say
creature:say(text, type)            -- Powiedz

-- Speech Types:
TALKTYPE_SAY = 1
TALKTYPE_WHISPER = 2
TALKTYPE_YELL = 3
TALKTYPE_PRIVATE_FROM = 4
TALKTYPE_PRIVATE_TO = 5
TALKTYPE_CHANNEL_Y = 6
TALKTYPE_CHANNEL_O = 7
TALKTYPE_SPELL = 8
TALKTYPE_PRIVATE_NP = 9
TALKTYPE_PRIVATE_PN = 10
TALKTYPE_BROADCAST = 11
TALKTYPE_CHANNEL_R1 = 12
TALKTYPE_PRIVATE_RED_FROM = 13
TALKTYPE_PRIVATE_RED_TO = 14
TALKTYPE_MONSTER_SAY = 16
TALKTYPE_MONSTER_YELL = 17

-- Remove
creature:remove()                   -- Usuń creature

-- Skull & Shields
creature:getSkull()                 -- Skull
creature:setSkull(skull)            -- Ustaw skull
```

---

## 3. MONSTER CLASS

```lua
-- Type
monster:getType()                   -- Monster type object
monster:getName()                   -- Nazwa
monster:setName(name)              -- Zmień nazwę

-- Master
monster:getMaster()                 -- Master (jeśli summon)
monster:isSummon()                  -- Czy summon?

-- Target
monster:selectTarget(creature)      -- Wybierz target
monster:searchTarget(searchType)    -- Szukaj targetu

-- Search Types:
TARGETSEARCH_DEFAULT = 0
TARGETSEARCH_RANDOM = 1
TARGETSEARCH_ATTACKRANGE = 2
TARGETSEARCH_NEAREST = 3

-- Loot
monster:getSpawnPosition()          -- Spawn position

-- Other
monster:isImmune(combatType)        -- Czy immune na typ?
```

---

## 4. NPC CLASS

```lua
-- Info
npc:getName()                       -- Nazwa
npc:setMasterPos(position)          -- Ustaw pozycję spawnu

-- Speech
npc:say(text, type, target)         -- Powiedz

-- Focus
npc:turnToCreature(creature)        -- Obróć się do creature
```

---

## 5. ITEM CLASS

### Basic Functions

```lua
-- Info
item:getId()                        -- Item ID
item:getName()                      -- Nazwa
item:getType()                      -- Item type
item:getCount()                     -- Count (stackable)
item:getSubType()                   -- Sub type
item:getCharges()                   -- Charges

-- Position
item:getPosition()                  -- Pozycja
item:getTile()                      -- Tile
item:getParent()                    -- Parent (container/player)

-- Attributes
item:getAttribute(key)              -- Pobierz atrybut
item:setAttribute(key, value)       -- Ustaw atrybut
item:removeAttribute(key)           -- Usuń atrybut

-- Common Attributes:
ITEM_ATTRIBUTE_DESCRIPTION = 1
ITEM_ATTRIBUTE_TEXT = 2
ITEM_ATTRIBUTE_DATE = 3
ITEM_ATTRIBUTE_WRITER = 4
ITEM_ATTRIBUTE_NAME = 5
ITEM_ATTRIBUTE_ARTICLE = 6
ITEM_ATTRIBUTE_PLURALNAME = 7
ITEM_ATTRIBUTE_WEIGHT = 8
ITEM_ATTRIBUTE_ATTACK = 9
ITEM_ATTRIBUTE_DEFENSE = 10
ITEM_ATTRIBUTE_EXTRADEFENSE = 11
ITEM_ATTRIBUTE_ARMOR = 12
ITEM_ATTRIBUTE_HITCHANCE = 13
ITEM_ATTRIBUTE_SHOOTRANGE = 14
ITEM_ATTRIBUTE_OWNER = 15
ITEM_ATTRIBUTE_DURATION = 16

-- Actions
item:clone()                        -- Klon
item:split(count)                   -- Podziel stack
item:remove(count)                  -- Usuń
item:transform(itemId, count)       -- Transform
item:decay()                        -- Decay (zniszczenie)

-- Movement
item:moveTo(position)               -- Przenieś

-- Checks
item:isItem()                       -- Czy to item?
item:isContainer()                  -- Czy container?
item:isTeleport()                   -- Czy teleport?
item:isMovable()                    -- Czy ruchomy?
```

### Container Functions

```lua
-- Container specific
item:getSize()                      -- Rozmiar
item:getCapacity()                  -- Pojemność
item:getEmptySlots()                -- Wolne sloty
item:getItem(index)                 -- Item na index
item:getItems()                     -- Wszystkie itemy
item:getItemHoldingCount()          -- Liczba wszystkich items
item:addItem(itemId, count, index)  -- Dodaj item
item:addItemEx(item, index)         -- Dodaj istniejący item
```

### Teleport Functions

```lua
-- Teleport specific
item:getDestination()               -- Destination position
item:setDestination(position)       -- Ustaw destination
```

---

## 6. POSITION CLASS

```lua
-- Creation
Position(x, y, z)                   -- Nowa pozycja
local pos = Position(100, 100, 7)

-- Components
position.x                          -- X coordinate
position.y                          -- Y coordinate
position.z                          -- Z coordinate (floor)

-- Effects
position:sendMagicEffect(effectId)  -- Efekt magiczny
position:sendDistanceEffect(toPosition, distanceEffectId)

-- Magic Effects:
CONST_ME_NONE = 0
CONST_ME_DRAWBLOOD = 1
CONST_ME_LOSEENERGY = 2
CONST_ME_POFF = 3
CONST_ME_BLOCKHIT = 4
CONST_ME_EXPLOSIONAREA = 5
CONST_ME_EXPLOSIONHIT = 6
CONST_ME_FIREAREA = 7
CONST_ME_YELLOW_RINGS = 8
CONST_ME_GREEN_RINGS = 9
CONST_ME_HITAREA = 10
CONST_ME_TELEPORT = 11
CONST_ME_ENERGYHIT = 12
CONST_ME_MAGIC_BLUE = 13
CONST_ME_MAGIC_RED = 14
CONST_ME_MAGIC_GREEN = 15
CONST_ME_HITBYFIRE = 16
CONST_ME_HITBYPOISON = 17
CONST_ME_MORTAREA = 18
CONST_ME_SOUND_GREEN = 19
CONST_ME_SOUND_RED = 20
CONST_ME_POISONAREA = 21
CONST_ME_SOUND_YELLOW = 22
CONST_ME_SOUND_PURPLE = 23
CONST_ME_SOUND_BLUE = 24
CONST_ME_SOUND_WHITE = 25

-- Distance Effects:
CONST_ANI_SPEAR = 1
CONST_ANI_BOLT = 2
CONST_ANI_ARROW = 3
CONST_ANI_FIRE = 4
CONST_ANI_ENERGY = 5
CONST_ANI_POISONARROW = 6
CONST_ANI_BURSTARROW = 7
CONST_ANI_THROWINGSTAR = 8
CONST_ANI_THROWINGKNIFE = 9
CONST_ANI_SMALLSTONE = 10
CONST_ANI_DEATH = 11
CONST_ANI_LARGEROCK = 12
CONST_ANI_SNOWBALL = 13
CONST_ANI_POWERBOLT = 14
CONST_ANI_POISON = 15
CONST_ANI_INFERNALBOLT = 16
CONST_ANI_HUNTINGSPEAR = 17
CONST_ANI_ENCHANTEDSPEAR = 18
CONST_ANI_ASSASSINSTAR = 19
CONST_ANI_GREENSTAR = 20
CONST_ANI_ROYALSPEAR = 21
CONST_ANI_SNIPERARROW = 22
CONST_ANI_ONYXARROW = 23
CONST_ANI_PIERCINGBOLT = 24
CONST_ANI_WHIRLWINDSWORD = 25
CONST_ANI_WHIRLWINDAXE = 26
CONST_ANI_WHIRLWINDCLUB = 27
CONST_ANI_ETHEREALSPEAR = 28
CONST_ANI_ICE = 29
CONST_ANI_EARTH = 30
CONST_ANI_HOLY = 31
CONST_ANI_SUDDENDEATH = 32
CONST_ANI_FLASHARROW = 33
CONST_ANI_FLAMMINGARROW = 34
CONST_ANI_SHIVERARROW = 35
CONST_ANI_ENERGYBALL = 36
CONST_ANI_SMALLICE = 37
CONST_ANI_SMALLHOLY = 38
CONST_ANI_SMALLEARTH = 39
CONST_ANI_EARTHARROW = 40
CONST_ANI_EXPLOSION = 41
CONST_ANI_CAKE = 42

-- Tile
position:getTile()                  -- Tile object
position:getCreatures()             -- Creatures na pozycji

-- Checks
position:isSightClear(toPosition, sameFloor) -- Czy widoczny?

-- Comparisons
position == otherPosition           -- Czy równe?

-- Math
position:getDistance(otherPosition) -- Dystans
position:getPathTo(toPosition, minTargetDist, maxTargetDist, fullPathSearch, clearSight, maxSearchDist)
```

---

## 7. GAME CLASS

```lua
-- Players
Game.getPlayers()                   -- Wszyscy gracze
Game.getPlayerCount()               -- Liczba graczy
Game.getPlayerByName(name)          -- Gracz po nazwie

-- Monsters
Game.getMonsterCount()              -- Liczba potworów

-- NPCs
Game.getNpcCount()                  -- Liczba NPC

-- Creation
Game.createItem(itemId, count, position) -- Stwórz item
Game.createMonster(name, position, extended, force) -- Stwórz potwora
Game.createNpc(name, position, extended, force) -- Stwórz NPC

-- World
Game.getWorldType()                 -- Typ świata
Game.setWorldType(type)             -- Ustaw typ

-- World Types:
WORLD_TYPE_NO_PVP = 1
WORLD_TYPE_PVP = 2
WORLD_TYPE_PVP_ENFORCED = 3

-- Experience
Game.getExperienceStage(level)      -- Stage dla levelu
Game.getExperienceForLevel(level)   -- Exp dla levelu

-- Raids
Game.startRaid(name)                -- Start raid

-- Time
Game.getWorldTime()                 -- Czas w grze
Game.setWorldTime(time)             -- Ustaw czas

-- Houses
Game.getHouseByName(name)           -- Dom po nazwie
Game.getHouses()                    -- Wszystkie domy

-- Towns
Game.getTowns()                     -- Wszystkie miasta
Game.getTownByName(name)            -- Miasto po nazwie

-- Special
Game.loadMap(path)                  -- Załaduj mapę
Game.getReturnMessage(value)        -- Return message
```

---

## 8. COMBAT CLASS

### Creation & Configuration

```lua
-- Create
local combat = Combat()

-- Parameters
combat:setParameter(key, value)

-- Parameter Keys:
COMBAT_PARAM_TYPE = 0               -- Typ combat
COMBAT_PARAM_EFFECT = 1             -- Efekt magiczny
COMBAT_PARAM_DISTANCEEFFECT = 2     -- Distance effect
COMBAT_PARAM_BLOCKSHIELD = 3        -- Czy blokować shield?
COMBAT_PARAM_BLOCKARMOR = 4         -- Czy blokować armor?
COMBAT_PARAM_TARGETCASTERORTOPMOST = 5
COMBAT_PARAM_CREATEITEM = 6         -- Twórz item
COMBAT_PARAM_AGGRESSIVE = 7         -- Agresywny?
COMBAT_PARAM_DISPEL = 8             -- Dispel type

-- Combat Types:
COMBAT_NONE = 0
COMBAT_PHYSICALDAMAGE = 1
COMBAT_ENERGYDAMAGE = 2
COMBAT_EARTHDAMAGE = 4
COMBAT_FIREDAMAGE = 8
COMBAT_UNDEFINEDDAMAGE = 16
COMBAT_LIFEDRAIN = 32
COMBAT_MANADRAIN = 64
COMBAT_HEALING = 128
COMBAT_DROWNDAMAGE = 256
COMBAT_ICEDAMAGE = 512
COMBAT_HOLYDAMAGE = 1024
COMBAT_DEATHDAMAGE = 2048

-- Formula
combat:setFormula(type, min, max)

-- Callback
combat:setCallback(callbackType, function)

-- Callback Types:
CALLBACK_PARAM_SKILLVALUE = 1
CALLBACK_PARAM_TARGETTILE = 2
CALLBACK_PARAM_LEVELMAGICVALUE = 3

-- Example Callback:
function onGetFormulaValues(player, level, magicLevel)
  local min = (level / 5) + (magicLevel * 1.5) + 10
  local max = (level / 5) + (magicLevel * 2.5) + 20
  return -min, -max
end
combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

-- Area
combat:setArea(area)

-- Execute
combat:execute(creature, variant)
```

### Combat Area

```lua
-- Create area
local area = createCombatArea(array)

-- Example arrays:
local arr1 = {
  {0, 1, 0},
  {1, 3, 1},
  {0, 1, 0}
}
-- 0 = nie atakuj
-- 1 = atakuj
-- 2 = atakuj tylko jeśli target
-- 3 = centrum (gracz)

local combat = Combat()
combat:setArea(createCombatArea(arr1))
```

---

## 9. CONDITION CLASS

```lua
-- Create
local condition = Condition(conditionType, id)

-- Configuration
condition:setParameter(key, value)

-- Parameter Keys:
CONDITION_PARAM_OWNER = 1
CONDITION_PARAM_TICKS = 2           -- Czas trwania (ms)
CONDITION_PARAM_HEALTHGAIN = 3
CONDITION_PARAM_HEALTHTICKS = 4
CONDITION_PARAM_MANAGAIN = 5
CONDITION_PARAM_MANATICKS = 6
CONDITION_PARAM_DELAYED = 7
CONDITION_PARAM_SPEED = 8           -- Zmiana prędkości
CONDITION_PARAM_LIGHT_LEVEL = 9
CONDITION_PARAM_LIGHT_COLOR = 10
CONDITION_PARAM_SOULGAIN = 11
CONDITION_PARAM_SOULTICKS = 12
CONDITION_PARAM_MINVALUE = 13
CONDITION_PARAM_MAXVALUE = 14
CONDITION_PARAM_STARTVALUE = 15
CONDITION_PARAM_TICKINTERVAL = 16
CONDITION_PARAM_FORCEUPDATE = 17
CONDITION_PARAM_SKILL_MELEE = 18
CONDITION_PARAM_SKILL_FIST = 19
CONDITION_PARAM_SKILL_CLUB = 20
CONDITION_PARAM_SKILL_SWORD = 21
CONDITION_PARAM_SKILL_AXE = 22
CONDITION_PARAM_SKILL_DISTANCE = 23
CONDITION_PARAM_SKILL_SHIELD = 24
CONDITION_PARAM_SKILL_FISHING = 25
CONDITION_PARAM_STAT_MAXHITPOINTS = 26
CONDITION_PARAM_STAT_MAXMANAPOINTS = 27
CONDITION_PARAM_STAT_SOULPOINTS = 28
CONDITION_PARAM_STAT_MAGICPOINTS = 29
CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT = 30
CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT = 31
CONDITION_PARAM_STAT_SOULPOINTSPERCENT = 32
CONDITION_PARAM_STAT_MAGICPOINTSPERCENT = 33
CONDITION_PARAM_PERIODICDAMAGE = 34
CONDITION_PARAM_SKILL_MELEEPERCENT = 35
CONDITION_PARAM_SKILL_FISTPERCENT = 36
CONDITION_PARAM_SKILL_CLUBPERCENT = 37
CONDITION_PARAM_SKILL_SWORDPERCENT = 38
CONDITION_PARAM_SKILL_AXEPERCENT = 39
CONDITION_PARAM_SKILL_DISTANCEPERCENT = 40
CONDITION_PARAM_SKILL_SHIELDPERCENT = 41
CONDITION_PARAM_SKILL_FISHINGPERCENT = 42
CONDITION_PARAM_BUFF_SPELL = 43
CONDITION_PARAM_SUBID = 44
CONDITION_PARAM_FIELD = 45

-- Example: Poison
local condition = Condition(CONDITION_POISON)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:setParameter(CONDITION_PARAM_MINVALUE, -50)
condition:setParameter(CONDITION_PARAM_MAXVALUE, -120)
condition:setParameter(CONDITION_PARAM_STARTVALUE, -5)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 4000)
condition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

player:addCondition(condition)

-- Example: Haste
local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_SPEED, 500)

player:addCondition(condition)
```

---

## 10. SPELL CLASS (RevScripts)

```lua
local spell = Spell("instant") -- lub "rune"

function spell.onCastSpell(creature, variant)
  -- Kod czaru
  return true
end

-- Configuration
spell:name("exori")
spell:words("exori")
spell:group("attack")
spell:id(60)
spell:cooldown(2000)
spell:groupCooldown(2000)
spell:level(20)
spell:mana(40)
spell:soul(0)
spell:isPremium(true)
spell:range(1)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:needLearn(false)
spell:vocation("knight;true", "elite knight;true")

spell:register()
```

---

## 11. UTILITY FUNCTIONS

### String Functions

```lua
-- String manipulation
string.explode(str, sep)            -- Split string
string.trim(str)                    -- Trim whitespace
```

### Table Functions

```lua
-- Table helpers
table.contains(table, value)        -- Czy zawiera?
table.find(table, value)            -- Znajdź index
table.getPos(table, value)          -- To samo co find
table.isStrIn(txt, str)             -- Czy string w tablicy?
```

### Math Functions

```lua
-- Math helpers
math.random(min, max)               -- Random w zakresie
```

---

*Ostatnia aktualizacja: 25 stycznia 2026*
