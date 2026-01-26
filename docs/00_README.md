# Dokumentacja OTC/TFS - Spis Treści

## 📚 Kompletna dokumentacja do tworzenia skryptów i botów dla Tibia

Utworzone: 25 stycznia 2026

---

## 📖 Lista wszystkich dokumentów:

### 1. 📄 [01_OTC_Overview.md](01_OTC_Overview.md)
**OTClient - Podstawowy przegląd**
- Co to jest OTClient?
- Główne funkcje i możliwości
- Struktura projektu
- Wersje i kompilacja
- Community & support

### 2. 📄 [02_TFS_Forgotten_Server.md](02_TFS_Forgotten_Server.md)
**The Forgotten Server - Dokumentacja**
- Co to jest TFS?
- Struktura projektu
- System skryptowania Lua
- Typy skryptów (Actions, Spells, TalkActions, etc.)
- Konfiguracja serwera
- Extended Opcodes

### 3. 📄 [03_OTClientV8_Bot.md](03_OTClientV8_Bot.md)
**OTClientV8 - Kompletny przewodnik po botowaniu**
- Co to jest OTClientV8?
- Wbudowany system bota
- GUI Bot Features
- Scripts/Macros system
- Layouts
- Wiki & Community
- Przykłady skryptów bot

### 4. 📄 [04_Lua_Scripting_Guide.md](04_Lua_Scripting_Guide.md)
**Lua - Przewodnik programowania**
- Podstawy Lua
- Lua w OTClient (bot scripting)
- Lua w TFS (server scripting)
- Player, Creature, Item functions
- Map & Game API
- Przykłady zaawansowanych skryptów
- Best practices

### 5. 📄 [05_OTClient_API_Reference.md](05_OTClient_API_Reference.md)
**OTClient Lua API - Kompletna dokumentacja**
- Player API
- Game API
- Map API
- Creature API
- Item API
- UI API
- Resources API
- HTTP/WebSocket API (OTCv8)
- Storage & Settings
- Extended Opcodes
- Event Callbacks
- Utility Functions

### 6. 📄 [06_TFS_Lua_API_Reference.md](06_TFS_Lua_API_Reference.md)
**TFS Lua API - Kompletna dokumentacja**
- Player Class
- Creature Class
- Monster Class
- NPC Class
- Item Class
- Position Class
- Game Class
- Combat Class
- Condition Class
- Spell Class (RevScripts)
- Utility Functions

### 7. 📄 [07_Quick_Start_Examples.md](07_Quick_Start_Examples.md)
**Quick Start - Przykłady i tutoriale**
- Podstawowe bot scripty
  - Auto Heal
  - Auto Mana/Health Potions
- Auto Attack & Targeting
  - Priority targeting
  - Distance targeting
- Auto Looting
  - Basic loot
  - Advanced loot z kategoriami
- Cavebot/Walker
  - Simple walker
  - Advanced cavebot z akcjami
- Utility & Tools
  - Anti-idle
  - Auto training
  - Auto fishing
- TFS Server Scripts
  - Actions
  - TalkActions
  - CreatureScripts
  - Spells
  - GlobalEvents
  - Movements
- Extended Opcodes przykłady
- Kompletny przykład bota

### 8. 🧩 [08_CTOmodule_Dev_Setup.md](08_CTOmodule_Dev_Setup.md)
**CTOmodule — Setup developerski (Windows) + hot-reload**
- Junction/symlink: lokalne pliki “live” w folderze modułów OTClient
- Typowe błędy ścieżek (podwójne `modules/CTOmodule/...`) i jak ich unikać
- Test: `dofile(...)` + hotkey `Ctrl+Shift+C`

### 9. 📄 [00_README.md](00_README.md) (ten plik)

**Spis treści i nawigacja**

---

## 🎯 Szybki Start:

### Dla Bot Userów:
1. Zacznij od **03_OTClientV8_Bot.md** - poznaj możliwości OTCv8
2. Przejdź do **07_Quick_Start_Examples.md** - gotowe przykłady
3. Pogłęb wiedzę w **05_OTClient_API_Reference.md** - pełne API

### Dla Server Ownerów:
1. Zacznij od **02_TFS_Forgotten_Server.md** - podstawy TFS
2. Przejdź do **06_TFS_Lua_API_Reference.md** - pełne API
3. Zobacz przykłady w **07_Quick_Start_Examples.md** - server scripts

### Dla Programistów:
1. **04_Lua_Scripting_Guide.md** - podstawy Lua
2. **05_OTClient_API_Reference.md** + **06_TFS_Lua_API_Reference.md** - pełne API
3. **07_Quick_Start_Examples.md** - praktyczne przykłady

---

## 🔗 Przydatne linki:

### OTClient:
- **GitHub**: https://github.com/edubart/otclient
- **Wiki**: https://github.com/edubart/otclient/wiki
- **Forum**: https://otland.net/forums/otclient.494/

### OTClientV8:
- **GitHub**: https://github.com/OTCv8/otclientv8
- **Dev Repo**: https://github.com/OTCv8/otcv8-dev
- **Discord**: https://discord.gg/feySup6
- **Website**: http://otclient.ovh
- **Bot Scripts**: https://otland.net/threads/scripts-macros-for-kondras-otclientv8-bot.267394/

### TFS:
- **GitHub**: https://github.com/otland/forgottenserver
- **Wiki**: https://github.com/otland/forgottenserver/wiki
- **Script Interface**: https://github.com/otland/forgottenserver/wiki/Script-Interface
- **Forum**: https://otland.net/

### Community:
- **OTLand**: https://otland.net/
- **Lua Guide**: https://docs.otland.net/lua-guide/
- **OTS Guide**: https://docs.otland.net/ots-guide/

---

## 📊 Struktura folderów:

```
docs/
├── 00_README.md                      # ⬅️ Ten plik (spis treści)
├── 01_OTC_Overview.md                # OTClient podstawy
├── 02_TFS_Forgotten_Server.md        # TFS dokumentacja
├── 03_OTClientV8_Bot.md              # OTCv8 i bot
├── 04_Lua_Scripting_Guide.md         # Lua programming
├── 05_OTClient_API_Reference.md      # OTC API complete
├── 06_TFS_Lua_API_Reference.md       # TFS API complete
├── 07_Quick_Start_Examples.md        # Przykłady i tutoriale
├── 08_CTOmodule_Dev_Setup.md         # CTOmodule: live-dev (junction) + hot-reload
└── api_output.md                     # Raw dump / generator output
```


---

## 🎓 Jak używać tej dokumentacji?

### 1. Dla początkujących:
- Przeczytaj dokumenty w kolejności 01 → 07
- Rozpocznij od podstaw (Overview)
- Przejdź do przykładów (Quick Start)
- Eksperymentuj z kodem

### 2. Dla średniozaawansowanych:
- Skup się na API Reference (05, 06)
- Studiuj przykłady (07)
- Twórz własne modyfikacje

### 3. Dla zaawansowanych:
- Używaj jako reference podczas kodowania
- Kombinuj różne API calls
- Twórz zaawansowane systemy

---

## 💡 Tips & Tricks:

### Bot Development:
- Zawsze testuj na test serverze
- Używaj `print()` do debugowania
- Nie ustawiaj zbyt niskich intervals w macro()
- Zapisuj często używane funkcje jako helpery

### Server Development:
- Używaj RevScripts dla nowych projektów
- Testuj dokładnie przed deployment
- Backup przed zmianami
- Dokumentuj swoje funkcje

### Learning:
- Czytaj istniejący kod
- Modyfikuj przykłady
- Zadawaj pytania na forum
- Dziel się swoimi rozwiązaniami

---

## 🆘 Wsparcie:

### Gdzie szukać pomocy?
1. **OTLand Forum**: https://otland.net/forums/support.16/
2. **Discord OTCv8**: https://discord.gg/feySup6
3. **GitHub Issues**:
   - OTClient: https://github.com/edubart/otclient/issues
   - TFS: https://github.com/otland/forgottenserver/issues
   - OTCv8: https://github.com/OTCv8/otclientv8/issues

### Przed zadaniem pytania:
- Sprawdź dokumentację
- Szukaj na forum
- Przygotuj przykład kodu
- Opisz dokładnie problem

---

## 🔄 Aktualizacje:

Ta dokumentacja zostanie regularnie aktualizowana o:
- Nowe funkcje API
- Dodatkowe przykłady
- Poprawki i clarifications
- Community contributions

**Ostatnia aktualizacja**: 25 stycznia 2026

---

## 📝 Licencja:

Ta dokumentacja jest udostępniona jako materiał edukacyjny dla społeczności Open Tibia.

### Projekty źródłowe:
- **OTClient**: MIT License
- **TFS**: GPL-2.0 License
- **OTClientV8**: Zobacz repozytorium

---

## 🙏 Credits:

### Twórcy projektów:
- **edubart** - OTClient
- **kondra** - OTClientV8
- **OTLand Team** - The Forgotten Server
- **OTLand Community** - Tutorials & Scripts

### Społeczność:
Wielkie podziękowania dla całej społeczności Open Tibia za:
- Tutorials
- Scripts
- Support
- Inspirację

---

## 🚀 Zaczynajmy!

Wybierz dokument z listy powyżej i zacznij swoją przygodę z tworzeniem skryptów dla Tibia!

### Quick Links:
- 🧩 **CTOmodule Dev Setup** → [08_CTOmodule_Dev_Setup.md](08_CTOmodule_Dev_Setup.md)

- 🎮 **Bot User?** → [03_OTClientV8_Bot.md](03_OTClientV8_Bot.md)
- 🖥️ **Server Owner?** → [02_TFS_Forgotten_Server.md](02_TFS_Forgotten_Server.md)
- 💻 **Programmer?** → [04_Lua_Scripting_Guide.md](04_Lua_Scripting_Guide.md)
- 📖 **Examples?** → [07_Quick_Start_Examples.md](07_Quick_Start_Examples.md)

---

**Happy Scripting! 🎉**
