# Quick Start Guide - Bot & Scripts Examples

## Kompletny przewodnik po tworzeniu botów i skryptów dla Tibia OTC/TFS

---

## 1. PODSTAWOWE BOT SCRIPTY (OTClientV8)

### Auto Heal - Prosty

```lua
-- Prosty auto heal
macro(100, "Auto Heal", function()
  if hppercent() < 60 then
    say("exura gran")
  end
end)
```

### Auto Heal - Zaawansowany

```lua
-- Zaawansowany auto heal z configiem
local CONFIG = {
  healSpell = "exura gran",
  healHP = 50,
  manaHP = 80,
  lightHealSpell = "exura",
  lightHealHP = 70,
  lightManaHP = 40
}

macro(100, "Smart Heal", function()
  local hp = hppercent()
  local mana = manapercent()
  
  -- Heavy heal jeśli niskie HP i jest mana
  if hp < CONFIG.healHP and mana > CONFIG.manaHP then
    say(CONFIG.healSpell)
    return
  end
  
  -- Light heal jeśli średnie HP
  if hp < CONFIG.lightHealHP and mana > CONFIG.lightManaHP then
    say(CONFIG.lightHealSpell)
    return
  end
end)
```

### Auto Mana Potions

```lua
-- Auto picie mana potions
local MANA_POTION = 268  -- great mana potion ID
local MIN_MANA = 30      -- Pij gdy poniżej 30%

macro(150, "Auto Mana", function()
  if manapercent() < MIN_MANA then
    usewith(MANA_POTION, player)
  end
end)
```

### Auto Health Potions

```lua
-- Auto picie health potions
local HEALTH_POTION = 266  -- great health potion ID
local MIN_HP = 40          -- Pij gdy poniżej 40%

macro(150, "Auto Health", function()
  if hppercent() < MIN_HP then
    usewith(HEALTH_POTION, player)
  end
end)
```

---

## 2. AUTO ATTACK & TARGETING

### Basic Auto Attack

```lua
-- Podstawowy auto attack
macro(500, "Auto Attack", function()
  if not g_game.isAttacking() then
    local target = getClosestMonster()
    if target then
      g_game.attack(target)
    end
  end
end)
```

### Priority Targeting

```lua
-- Targeting z listą priorytetów
local PRIORITY_LIST = {
  "Dragon Lord",
  "Dragon",
  "Demon"
}

local BLACKLIST = {
  "Rat",
  "Cave Rat",
  "Spider"
}

macro(200, "Smart Target", function()
  if g_game.isAttacking() then
    local current = getTarget()
    -- Sprawdź czy target jest OK
    if current and not table.contains(BLACKLIST, current:getName()) then
      return -- Keep attacking
    end
    g_game.cancelAttack()
  end
  
  local creatures = g_map.getCreatures()
  
  -- Najpierw priority targets
  for _, priority in ipairs(PRIORITY_LIST) do
    for _, creature in ipairs(creatures) do
      if creature:isMonster() and creature:getName() == priority then
        g_game.attack(creature)
        return
      end
    end
  end
  
  -- Potem inne (bez blacklisty)
  for _, creature in ipairs(creatures) do
    if creature:isMonster() then
      local name = creature:getName()
      if not table.contains(BLACKLIST, name) then
        g_game.attack(creature)
        return
      end
    end
  end
end)
```

### Distance Targeting

```lua
-- Atakuj tylko w określonej odległości
local MAX_DISTANCE = 3

macro(300, "Close Target", function()
  if g_game.isAttacking() then
    local target = getTarget()
    if target then
      local playerPos = player:getPosition()
      local targetPos = target:getPosition()
      local dist = math.abs(playerPos.x - targetPos.x) + 
                   math.abs(playerPos.y - targetPos.y)
      
      if dist > MAX_DISTANCE then
        g_game.cancelAttack() -- Za daleko
      end
      return
    end
  end
  
  -- Znajdź najbliższego
  local closest = nil
  local minDist = 999
  local playerPos = player:getPosition()
  
  for _, creature in ipairs(g_map.getCreatures()) do
    if creature:isMonster() then
      local cPos = creature:getPosition()
      local dist = math.abs(playerPos.x - cPos.x) + 
                   math.abs(playerPos.y - cPos.y)
      
      if dist <= MAX_DISTANCE and dist < minDist then
        closest = creature
        minDist = dist
      end
    end
  end
  
  if closest then
    g_game.attack(closest)
  end
end)
```

---

## 3. AUTO LOOTING

### Basic Loot

```lua
-- Podstawowy auto loot
local LOOT_LIST = {
  3031, -- gold coin
  3035, -- platinum coin
  3043, -- crystal coin
}

macro(200, "Auto Loot", function()
  local playerPos = player:getPosition()
  
  for _, tile in ipairs(g_map.getTiles(posz())) do
    for _, item in ipairs(tile:getItems()) do
      if table.contains(LOOT_LIST, item:getId()) then
        local itemPos = item:getPosition()
        
        -- Sprawdź odległość
        if math.abs(itemPos.x - playerPos.x) <= 1 and 
           math.abs(itemPos.y - playerPos.y) <= 1 then
          
          g_game.move(item, {x=65535, y=SlotBackpack, z=0}, item:getCount())
        end
      end
    end
  end
end)
```

### Advanced Loot with Categories

```lua
-- Zaawansowany loot z kategoriami
local LOOT_CONFIG = {
  gold = {3031, 3035, 3043},      -- Coins
  valuables = {3046, 3081, 3098}, -- Valuable items
  quest = {2230, 2231},           -- Quest items
  distance = 1,                    -- Max distance to loot
  containerSlot = SlotBackpack
}

local function shouldLoot(itemId)
  for category, items in pairs(LOOT_CONFIG) do
    if type(items) == "table" then
      if table.contains(items, itemId) then
        return true
      end
    end
  end
  return false
end

macro(200, "Smart Loot", function()
  local playerPos = player:getPosition()
  local maxDist = LOOT_CONFIG.distance
  
  for _, tile in ipairs(g_map.getTiles(posz())) do
    for _, item in ipairs(tile:getItems()) do
      if shouldLoot(item:getId()) then
        local itemPos = item:getPosition()
        local dist = math.abs(itemPos.x - playerPos.x) + 
                     math.abs(itemPos.y - playerPos.y)
        
        if dist <= maxDist then
          g_game.move(item, 
            {x=65535, y=LOOT_CONFIG.containerSlot, z=0}, 
            item:getCount())
        end
      end
    end
  end
end)
```

### Loot and Stack

```lua
-- Loot i automatyczne stackowanie
local LOOT_LIST = {3031, 3035, 3043}

local function findItemInBackpack(itemId)
  local backpack = player:getInventoryItem(SlotBackpack)
  if not backpack then return nil end
  
  -- Search in backpack
  -- (Simplified - full implementation would search recursively)
  return nil
end

macro(200, "Loot & Stack", function()
  local playerPos = player:getPosition()
  
  for _, tile in ipairs(g_map.getTiles(posz())) do
    for _, item in ipairs(tile:getItems()) do
      if table.contains(LOOT_LIST, item:getId()) then
        local itemPos = item:getPosition()
        
        if math.abs(itemPos.x - playerPos.x) <= 1 and 
           math.abs(itemPos.y - playerPos.y) <= 1 then
          
          -- Try to find existing stack
          local existing = findItemInBackpack(item:getId())
          
          if existing then
            -- Move to existing stack
            g_game.move(item, existing:getPosition(), item:getCount())
          else
            -- Move to backpack
            g_game.move(item, {x=65535, y=SlotBackpack, z=0}, item:getCount())
          end
        end
      end
    end
  end
end)
```

---

## 4. CAVEBOT / WALKER

### Simple Walker

```lua
-- Prosty walker po waypointach
local WAYPOINTS = {
  {x=1000, y=1000, z=7},
  {x=1010, y=1000, z=7},
  {x=1010, y=1010, z=7},
  {x=1000, y=1010, z=7},
}

local currentWP = 1
local isWalking = false

macro(1000, "Walker", function()
  -- Nie chodź podczas walki
  if g_game.isAttacking() then
    return
  end
  
  local playerPos = player:getPosition()
  local targetPos = WAYPOINTS[currentWP]
  
  -- Sprawdź czy dotarliśmy
  if playerPos.x == targetPos.x and 
     playerPos.y == targetPos.y and 
     playerPos.z == targetPos.z then
    
    currentWP = currentWP + 1
    if currentWP > #WAYPOINTS then
      currentWP = 1 -- Loop
    end
    
    isWalking = false
    return
  end
  
  -- Idź do waypointa
  if not isWalking then
    autoWalk(targetPos)
    isWalking = true
  end
end)
```

### Advanced Cavebot

```lua
-- Zaawansowany cavebot z akcjami
local WAYPOINTS = {
  {x=1000, y=1000, z=7, action="hunt"},
  {x=1010, y=1000, z=7, action="hunt"},
  {x=1010, y=1010, z=7, action="rope"},
  {x=1010, y=1011, z=6, action="hunt"},
  {x=1000, y=1000, z=7, action="depot"},
}

local state = {
  currentWP = 1,
  isWalking = false,
  shouldReturn = false,
  capToReturn = 50
}

local function executeAction(action)
  if action == "rope" then
    -- Use rope
    local rope = 3003
    usewith(rope, player)
    scheduleEvent(function()
      state.isWalking = false
    end, 1000)
    return true
    
  elseif action == "shovel" then
    -- Use shovel
    local shovel = 3457
    local pos = player:getPosition()
    pos.y = pos.y + 1
    usewith(shovel, pos)
    return true
    
  elseif action == "depot" then
    -- Open depot
    print("Reached depot - open and deposit items")
    return false
    
  elseif action == "hunt" then
    -- Continue hunting
    return false
  end
  
  return false
end

macro(500, "Cavebot", function()
  -- Check capacity
  local cap = player:getFreeCapacity()
  if cap < state.capToReturn then
    state.shouldReturn = true
  end
  
  -- Nie chodź podczas walki (chyba że wracamy)
  if g_game.isAttacking() and not state.shouldReturn then
    return
  end
  
  local playerPos = player:getPosition()
  local targetPos = WAYPOINTS[state.currentWP]
  
  -- Sprawdź czy dotarliśmy
  if playerPos.x == targetPos.x and 
     playerPos.y == targetPos.y and 
     playerPos.z == targetPos.z then
    
    -- Execute action
    if targetPos.action then
      local wait = executeAction(targetPos.action)
      if wait then
        return
      end
    end
    
    state.currentWP = state.currentWP + 1
    if state.currentWP > #WAYPOINTS then
      state.currentWP = 1
      state.shouldReturn = false
    end
    
    state.isWalking = false
    return
  end
  
  -- Idź do waypointa
  if not state.isWalking then
    autoWalk(targetPos)
    state.isWalking = true
  end
end)
```

---

## 5. UTILITKY & TOOLS

### Anti-Idle

```lua
-- Anti-idle - ruszaj się co jakiś czas
local IDLE_TIME = 60000  -- 1 minuta
local lastMove = os.time()

macro(10000, "Anti-Idle", function()
  if os.time() - lastMove > IDLE_TIME / 1000 then
    local dir = math.random(0, 3)
    g_game.walk(dir)
    lastMove = os.time()
  end
end)

onPlayerPositionChange(function()
  lastMove = os.time()
end)
```

### Auto Training

```lua
-- Auto training (np. magic level)
local TRAINING_SPELL = "exura"
local MIN_MANA = 50

macro(1000, "Auto Train", function()
  if manapercent() > MIN_MANA then
    say(TRAINING_SPELL)
  end
end)
```

### Auto Fishing

```lua
-- Auto fishing
local FISHING_ROD = 3483
local FISHING_SPOTS = {
  {x=1000, y=1000, z=7},
  {x=1001, y=1000, z=7},
}

local currentSpot = 1

macro(2000, "Auto Fish", function()
  local spot = FISHING_SPOTS[currentSpot]
  usewith(FISHING_ROD, spot)
  
  -- Rotate spots
  currentSpot = currentSpot + 1
  if currentSpot > #FISHING_SPOTS then
    currentSpot = 1
  end
end)
```

### Food Eater

```lua
-- Auto jedzenie food
local FOOD_LIST = {
  3582, -- ham
  3577, -- meat
  3578, -- fish
}

local MIN_TIME_BETWEEN_FOOD = 5000  -- 5 sekund
local lastEat = 0

macro(1000, "Auto Eat", function()
  if os.time() - lastEat < MIN_TIME_BETWEEN_FOOD / 1000 then
    return
  end
  
  for _, foodId in ipairs(FOOD_LIST) do
    -- Check if we have food (simplified)
    -- In real implementation, search inventory
    g_game.use(foodId) -- This is simplified
    lastEat = os.time()
    return
  end
end)
```

---

## 6. TFS SERVER SCRIPTS

### Simple Action (Use Item)

```lua
-- data/scripts/actions/healing_potion.lua
local healingPotion = Action()

function healingPotion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
  if not target or not target:isPlayer() then
    player:sendCancelMessage("You can only use this on players.")
    return false
  end
  
  local healAmount = math.random(100, 200)
  target:addHealth(healAmount)
  target:sendTextMessage(MESSAGE_HEALED, "You healed " .. healAmount .. " hit points.")
  
  item:remove(1)
  toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
  
  return true
end

healingPotion:id(2345) -- Item ID
healingPotion:register()
```

### TalkAction (Command)

```lua
-- data/scripts/talkactions/teleport.lua
local teleportCommand = TalkAction("!tp")

function teleportCommand.onSay(player, words, param)
  if not player:getGroup():getAccess() then
    return false
  end
  
  local params = param:split(",")
  if #params ~= 3 then
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Usage: !tp x,y,z")
    return false
  end
  
  local x = tonumber(params[1])
  local y = tonumber(params[2])
  local z = tonumber(params[3])
  
  if not x or not y or not z then
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Invalid coordinates.")
    return false
  end
  
  local newPos = Position(x, y, z)
  player:teleportTo(newPos)
  newPos:sendMagicEffect(CONST_ME_TELEPORT)
  
  return false
end

teleportCommand:separator(" ")
teleportCommand:register()
```

### CreatureScript (onLogin)

```lua
-- data/scripts/creaturescripts/player_login.lua
local playerLogin = CreatureEvent("PlayerLogin")

function playerLogin.onLogin(player)
  -- Welcome message
  player:sendTextMessage(MESSAGE_STATUS_DEFAULT, 
    "Welcome, " .. player:getName() .. "!")
  
  -- Register other events
  player:registerEvent("PlayerDeath")
  player:registerEvent("DropLoot")
  
  -- Give starter items (for new players)
  if player:getLevel() == 1 then
    player:addItem(3003, 1) -- rope
    player:addItem(3457, 1) -- shovel
    player:addItem(3598, 1) -- bag
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 
      "Here are some starter items!")
  end
  
  return true
end

playerLogin:register()
```

### Spell (Attack)

```lua
-- data/scripts/spells/attack/exori.lua
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_USECHARGES, true)

function onGetFormulaValues(player, level, magicLevel)
  local min = (level / 5) + (magicLevel * 1.4) + 7
  local max = (level / 5) + (magicLevel * 2.2) + 14
  return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
  return combat:execute(creature, variant)
end

spell:name("Exori")
spell:words("exori")
spell:group("attack")
spell:vocation("knight;true", "elite knight;true")
spell:id(60)
spell:cooldown(2000)
spell:groupCooldown(2000)
spell:level(20)
spell:mana(40)
spell:isPremium(false)
spell:range(1)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:register()
```

### GlobalEvent (Server Save)

```lua
-- data/scripts/globalevents/server_save.lua
local serverSave = GlobalEvent("ServerSave")

function serverSave.onThink(interval)
  -- Warning 5 minutes before
  Game.broadcastMessage("Server save in 5 minutes!", MESSAGE_STATUS_WARNING)
  
  -- Schedule actual save
  addEvent(function()
    -- Save all players
    for _, player in ipairs(Game.getPlayers()) do
      player:save()
    end
    
    -- Save houses
    saveServer()
    
    Game.broadcastMessage("Server has been saved!", MESSAGE_STATUS_WARNING)
  end, 5 * 60 * 1000) -- 5 minutes
  
  return true
end

serverSave:interval(60 * 60 * 1000) -- Every hour
serverSave:register()
```

### Movement (Teleport)

```lua
-- data/scripts/movements/teleport.lua
local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
  local player = creature:getPlayer()
  if not player then
    return true
  end
  
  -- Teleport destination
  local destination = Position(1000, 1000, 7)
  
  player:teleportTo(destination)
  destination:sendMagicEffect(CONST_ME_TELEPORT)
  fromPosition:sendMagicEffect(CONST_ME_POFF)
  
  return true
end

teleport:type("stepin")
teleport:aid(1234) -- Action ID na mapie
teleport:register()
```

---

## 7. EXTENDED OPCODES (Client-Server Communication)

### Server Side (TFS)

```lua
-- data/scripts/talkactions/opcode_test.lua
local opcodeTest = TalkAction("!opcode")

function opcodeTest.onSay(player, words, param)
  -- Send custom data to client
  local data = {
    questProgress = 50,
    questName = "Dragon Quest",
    rewardId = 2345
  }
  
  player:sendExtendedOpcode(1, json.encode(data))
  
  return false
end

opcodeTest:register()
```

### Client Side (OTCv8)

```lua
-- modules/game_bot/opcode_handler.lua
function parseExtendedOpcode(opcode, buffer)
  if opcode == 1 then
    local data = json.decode(buffer)
    print("Quest: " .. data.questName)
    print("Progress: " .. data.questProgress .. "%")
    
    -- Update UI or do something with data
  end
end

-- Register handler
ExtendedOpcode.register(parseExtendedOpcode)

-- Send data to server
local function sendQuestRequest(questId)
  local data = {
    action = "getQuest",
    questId = questId
  }
  
  g_game.sendExtendedOpcode(1, json.encode(data))
end
```

---

## 8. COMPLETE BOT EXAMPLE

### Full Featured Bot

```lua
-- Complete bot with all features
local Bot = {
  -- Configuration
  config = {
    -- Healing
    healSpell = "exura gran",
    healHP = 50,
    healMana = 80,
    
    -- Mana potions
    manaPotionId = 268,
    manaPotionPercent = 30,
    
    -- Targeting
    priorityList = {"Dragon Lord", "Dragon"},
    blacklist = {"Rat"},
    maxDistance = 5,
    
    -- Looting
    lootList = {3031, 3035, 3043},
    lootDistance = 1,
    
    -- Walking
    waypoints = {
      {x=1000, y=1000, z=7},
      {x=1010, y=1000, z=7},
    },
    returnCapacity = 50,
  },
  
  -- State
  state = {
    currentWaypoint = 1,
    isWalking = false,
    shouldReturn = false,
  },
  
  -- Healing module
  heal = function(self)
    local hp = hppercent()
    local mana = manapercent()
    
    if hp < self.config.healHP and mana > self.config.healMana then
      say(self.config.healSpell)
    end
    
    if mana < self.config.manaPotionPercent then
      usewith(self.config.manaPotionId, player)
    end
  end,
  
  -- Targeting module
  target = function(self)
    if g_game.isAttacking() then
      return
    end
    
    local creatures = g_map.getCreatures()
    local playerPos = player:getPosition()
    
    -- Priority first
    for _, name in ipairs(self.config.priorityList) do
      for _, creature in ipairs(creatures) do
        if creature:isMonster() and creature:getName() == name then
          local dist = self:getDistance(playerPos, creature:getPosition())
          if dist <= self.config.maxDistance then
            g_game.attack(creature)
            return
          end
        end
      end
    end
    
    -- Then any monster
    for _, creature in ipairs(creatures) do
      if creature:isMonster() then
        local name = creature:getName()
        if not table.contains(self.config.blacklist, name) then
          local dist = self:getDistance(playerPos, creature:getPosition())
          if dist <= self.config.maxDistance then
            g_game.attack(creature)
            return
          end
        end
      end
    end
  end,
  
  -- Looting module
  loot = function(self)
    local playerPos = player:getPosition()
    
    for _, tile in ipairs(g_map.getTiles(posz())) do
      for _, item in ipairs(tile:getItems()) do
        if table.contains(self.config.lootList, item:getId()) then
          local itemPos = item:getPosition()
          local dist = self:getDistance(playerPos, itemPos)
          
          if dist <= self.config.lootDistance then
            g_game.move(item, {x=65535, y=SlotBackpack, z=0}, item:getCount())
          end
        end
      end
    end
  end,
  
  -- Walking module
  walk = function(self)
    if g_game.isAttacking() and not self.state.shouldReturn then
      return
    end
    
    local playerPos = player:getPosition()
    local targetPos = self.config.waypoints[self.state.currentWaypoint]
    
    if playerPos.x == targetPos.x and 
       playerPos.y == targetPos.y and 
       playerPos.z == targetPos.z then
      
      self.state.currentWaypoint = self.state.currentWaypoint + 1
      if self.state.currentWaypoint > #self.config.waypoints then
        self.state.currentWaypoint = 1
      end
      
      self.state.isWalking = false
      return
    end
    
    if not self.state.isWalking then
      autoWalk(targetPos)
      self.state.isWalking = true
    end
  end,
  
  -- Helper function
  getDistance = function(self, pos1, pos2)
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
  end,
  
  -- Main update
  update = function(self)
    self:heal()
    self:target()
    self:loot()
    self:walk()
  end
}

-- Run bot
macro(100, "Full Bot", function()
  Bot:update()
end)
```

---

## Przydatne linki:

- **OTClientV8 Discord**: https://discord.gg/feySup6
- **OTLand Forum**: https://otland.net/forums/otclient.494/
- **Bot Scripts Thread**: https://otland.net/threads/scripts-macros-for-kondras-otclientv8-bot.267394/
- **TFS GitHub**: https://github.com/otland/forgottenserver
- **OTCv8 GitHub**: https://github.com/OTCv8/otclientv8

---

*Ostatnia aktualizacja: 25 stycznia 2026*
