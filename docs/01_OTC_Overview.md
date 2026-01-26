# OTC (OTClient) - Comprehensive Overview

## Co to jest OTClient?

OTClient to alternatywny klient Tibii do użytku z serwerami OTServ. Jest napisany w C++11 i mocno skryptowany w Lua.

### Główne cechy:
- **Modularny system** - każda funkcjonalność to osobny moduł
- **Lua scripting** - cały interfejs gry i funkcjonalność są skryptowane w Lua
- **CSS-podobna składnia** - dla projektowania interfejsu klienta
- **Łatwa customizacja** - użytkownicy mogą modyfikować i dostosowywać wszystko
- **Możliwość tworzenia nowych modów** - rozszerzanie interfejsu gry

### Technologie:
- **Język główny**: C++11
- **Język skryptowy**: Lua
- **Silnik graficzny**: OpenGL 1.1/2.0 ES
- **Platforma**: Windows, Linux, Mac OS X (możliwość portowania na mobile)

## Struktura projektu OTClient

```
otclient/
├── data/              # Dane gry (sprites, things)
├── mods/              # Moduły/dodatki
├── modules/           # Główne moduły klienta
├── src/               # Kod źródłowy C++
└── init.lua           # Główny plik inicjalizacyjny Lua
```

## Główne repozytoria:

1. **edubart/otclient** - Oryginalny OTClient
   - https://github.com/edubart/otclient
   - Uwaga: w community często przewija się “windows build” z commitem `df422c0` (około 2017), ale samo repozytorium ma dużo nowsze commity — traktuj `df422c0` jako historyczny punkt odniesienia, nie “ostatni commit”.
   - Wsparcie wersji Tibii zależy od forka oraz posiadanych plików `spr/dat` w `data/things/<VERSION>/` (np. 1098/1099/itd.).

2. **mehah/otclient** - Fork z nowszymi funkcjami
   - Aktywnie rozwijany
   - Dodatkowe funkcje i poprawki

## Możliwości OTClient:

### 1. System dźwięku
- Obsługa efektów dźwiękowych
- Muzyka w tle

### 2. Efekty graficzne
- Shadery
- Animowane tekstury
- Przezroczystość

### 3. System modułów/dodatków
- Łatwe dodawanie nowych funkcji
- Modułowa architektura

### 4. Wielojęzyczność
- Obsługa wielu języków
- Łatwe tłumaczenia

### 5. Terminal Lua w grze
- Wykonywanie kodu Lua podczas gry
- Debugowanie na żywo

### 6. Elastyczność
- Możliwość tworzenia narzędzi (np. edytory map)
- Framework + API Tibii
- Nie tylko klient, ale platforma do tworzenia

## Wersje klienta:

### Wspierane wersje protokołu Tibia:
- 7.x
- 8.x
- 9.x
- 10.x (do 10.99)
- 11.x (w nowszych forkach)
- 12.x (w nowszych forkach)

## Kompilacja:

### Windows
- Visual Studio
- CMake
- vcpkg (dla zależności)

### Linux
- GCC/Clang
- CMake
- Standardowe biblioteki dev

### Mac OS X
- Xcode
- CMake
- Homebrew (dla zależności)

## Bot Protection:

- Starsze buildy: **OFF** (łatwe botowanie)
- Możliwość włączenia w nowszych wersjach
- Do customizacji przez właściciela serwera

## Pliki wymagane:

### Do działania klienta potrzebne są:
1. **Tibia.spr** - plik sprite'ów
2. **Tibia.dat** - plik danych
3. Umieścić w: `data/things/VERSION/` (np. `data/things/1098/`)

## Linki do builds:

### Windows Builds (gotowe .exe):
- Otland.net: http://otland.net/threads/otclient-builds-windows.217977/
- Najnowszy build: df422c0
- Data: 4 lutego 2017
- Wspiera do: 10.99
- Bot Protection: OFF

## Community & Support:

### Fora:
- OTLand: https://otland.net/forums/otclient.494/
- Gitter Chat: https://gitter.im/edubart/otclient

### GitHub Issues:
- Bug tracker: https://github.com/edubart/otclient/issues

### Wiki:
- https://github.com/edubart/otclient/wiki

## Połączenie z serwerem:

### Do połączenia można użyć:
1. **The Forgotten Server (TFS)** - https://github.com/otland/forgottenserver
2. Inne serwery z listy: https://otservlist.org/

## Licencja:

**MIT License** - całkowicie darmowy, możesz robić co chcesz:
- Użytek komercyjny
- Użytek niekomercyjny
- Kod zamknięty lub otwarty

---

*Ostatnia aktualizacja: 25 stycznia 2026*
