# CTOmodule — Setup developerski (Windows) + hot-reload

Data: 26 stycznia 2026

Ten dokument opisuje konfigurację, która pozwala edytować pliki modułu **na żywo** w `C:\dev\CTOmodule`,
a OTClient widzi je tak, jakby były w swoim katalogu `...\mklauncher\althea\modules\CTOmodule`.

---

## 1) Cel: “live files” przez Junction (/J)

**Źródło (repo):**
- `C:\dev\CTOmodule\modules\CTOmodule`

**Cel (OTClient / mklauncher):**
- `C:\Users\<USER>\AppData\Roaming\mklauncher\althea\modules\CTOmodule`

Tworzymy połączenie typu **Junction** (nie wymaga Developer Mode i zwykle nie wymaga admina).

### Komenda (PowerShell → CMD)

> Uwaga: folder `...\mklauncher\althea\modules` musi istnieć, a w ścieżce musi być poprawna nazwa użytkownika.

```bat
cmd /c mklink /J "C:\Users\<USER>\AppData\Roaming\mklauncher\althea\modules\CTOmodule" "C:\dev\CTOmodule\modules\CTOmodule"
```

### Jak sprawdzić, że działa

```powershell
dir "C:\Users\<USER>\AppData\Roaming\mklauncher\althea\modules\CTOmodule"
```

Powinieneś zobaczyć pliki modułu (`CTOmodule.otmod`, `init.lua`, `module.lua`, `ui\...`, `config\...`).

---

## 2) Najczęstsze błędy i szybkie fixy

### “System nie może odnaleźć określonej ścieżki.”
- Zwykle oznacza, że **parent folder** nie istnieje (np. `...\mklauncher\althea\modules`), albo podany jest zły użytkownik (`zycie` vs `Famatyk`).

### “Nazwa pliku, nazwa katalogu lub składnia etykiety woluminu jest niepoprawna.”
- Najczęściej: złe cudzysłowy, ukryty znak, albo ścieżka z `"` w środku.
- W `mklink` trzymaj się prostego formatu jak w przykładzie.

---

## 3) OTClient: ścieżki wewnątrz modułu (ważne)

W OTClient, **`init.lua` wykonuje się “w kontekście folderu modułu”**.

To oznacza:
- ✅ `dofile('module.lua')`
- ✅ `g_ui.loadUI('ui/main.otui', parent)`
- ❌ `dofile('modules/CTOmodule/module.lua')` (robi się podwójna ścieżka)
- ❌ `g_ui.loadUI('modules/CTOmodule/ui/main.otui', parent)` (to samo)

---

## 4) Test w konsoli OTClient

1) Załaduj skrypt:
```lua
dofile('modules/CTOmodule/init.lua')
init()
```

2) Powinien pojawić się print:
- `[CTOmodule] loaded (Ctrl+Shift+C)`

3) Hotkey:
- `Ctrl+Shift+C` przełącza okno modułu.

---

## 5) Co commitujemy do repo

Minimalnie:
- `modules/CTOmodule/init.lua`
- `modules/CTOmodule/module.lua`
- `docs/*` (ta dokumentacja)
