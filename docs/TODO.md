# TODO (Roadmap 100 zadań)
1. Zdefiniuj cel MVP v1.0 i zakres funkcji. Test: przegląd specyfikacji w docs.
2. Spisz założenia legalne/bezpieczne (brak RE, tylko publiczne API). Test: akceptacja przez zespół.
3. Ustal strukturę folderów dla 2 plików (collector + module builder). Test: weryfikacja drzewka.
4. Dodaj opis architektury w docs/DESIGN.md. Test: review.
5. Dodaj sekcję “API Output Contract” w docs. Test: review.
6. Zdefiniuj format danych wyjściowych (json/lua table). Test: walidacja przykładu.
7. Dodaj schemat wersjonowania danych (version field). Test: odczyt przez parser.
8. Dodaj zestaw przykładów danych wej/wyj. Test: manual check.
9. Zaprojektuj mechanizm opt-in (użytkownik uruchamia skan). Test: brak auto-start.
10. Zaprojektuj ograniczenia dostępu (only module dir). Test: brak zapisu poza module.

11. Dodaj plan testów manualnych i automatycznych. Test: lista testów.
12. Zdefiniuj poziomy logowania (info/warn/error). Test: output w logu.
13. Dodaj zasady anonimizacji danych. Test: brak danych wrażliwych.
14. Zdefiniuj minimalny zakres danych “privacy mode”. Test: mniej pól.
15. Dodaj opis zależności i kompatybilności klienta. Test: tabela w docs.
16. Dodaj diagram przepływu danych (collector -> storage -> builder). Test: review.
17. Dodaj checklistę bezpieczeństwa. Test: podpisana.
18. Dodaj procedurę rollback. Test: opis w docs.
19. Dodaj konwencję nazewnictwa plików output. Test: zgodność nazw.
20. Dodaj politykę retencji danych. Test: limity w config.

21. Stwórz plik collector (Lua) – inicjalizacja i rejestracja. Test: brak błędów w logu.
22. Dodaj bezpieczny dostęp do g_ui/g_game z fallback. Test: działa na brak API.
23. Dodaj enumerację widżetów z g_ui. Test: lista elementów.
24. Dodaj zbieranie metadanych widżetu (id, size, anchors). Test: poprawne pola.
25. Dodaj zbieranie stylów OTUI (jeśli dostępne). Test: brak crash.
26. Dodaj zbieranie listy okien/okienek. Test: liczba okien >0.
27. Dodaj zbieranie hotkey bindings. Test: zgodność z g_keyboard.
28. Dodaj zbieranie stanu gracza (minimalne, publiczne). Test: brak null.
29. Dodaj zbieranie stanu mapy (bez danych prywatnych). Test: brak crash.
30. Dodaj zbieranie stanu ping/online. Test: wartości w logu.

31. Dodaj walidację danych collector (pcall + sanity). Test: brak panic.
32. Dodaj throttle (limit częstotliwości). Test: 1 zapis/sek.
33. Dodaj deduplikację (hash) aby nie zapisywać duplikatów. Test: brak nadmiaru.
34. Dodaj zapis do pliku w modules/CTOmodule/config/. Test: plik istnieje.
35. Dodaj rotację plików (max size). Test: rotacja po limicie.
36. Dodaj logowanie etapów (perror/print). Test: czytelny log.
37. Dodaj tryb dry-run. Test: brak zapisu plików.
38. Dodaj wyłącznik (stop) i cleanup. Test: brak event leak.
39. Dodaj komendę konsoli do start/stop. Test: komenda działa.
40. Dodaj wersję “minimal data” (privacy). Test: mniej pól w output.

41. Dodaj zbieranie listy modułów klienta (publiczne). Test: lista modułów.
42. Dodaj zbieranie aktywnych okien/modalek. Test: wykryte okna.
43. Dodaj zbieranie layoutu UI (hierarchia). Test: poprawny tree.
44. Dodaj zbieranie rozmiarów ekranu. Test: wartości w output.
45. Dodaj zbieranie mapy skrótów klawiszowych. Test: brak duplikatów.
46. Dodaj zbieranie statusu połączenia. Test: online/offline.
47. Dodaj wskaźnik jakości danych (score). Test: score w output.
48. Dodaj znacznik czasu (UTC). Test: poprawny format.
49. Dodaj kompresję zapisu (opcjonalną). Test: mniejszy plik.
50. Dodaj podpis kontrolny (checksum). Test: weryfikacja ok.

51. Stwórz plik module builder (Lua) – init. Test: ładowanie bez błędów.
52. Dodaj parser danych z pliku collector. Test: poprawny odczyt.
53. Dodaj walidację schematu danych. Test: odrzucenie złych danych.
54. Dodaj cache danych w pamięci. Test: przyspieszenie odczytu.
55. Dodaj generator UI z danych (okna/panele). Test: UI renderuje.
56. Dodaj mapper akcji -> UI (klik, hotkey). Test: akcje działają.
57. Dodaj warstwę “script hooks”. Test: hook wywoływany.
58. Dodaj rejestr akcji (Action Registry). Test: lista akcji.
59. Dodaj edytor akcji (prosty). Test: zapis/odczyt akcji.
60. Dodaj import/eksport akcji (json/lua). Test: roundtrip.

61. Dodaj system tagów dla akcji. Test: filtrowanie działa.
62. Dodaj kategorie UI (tabs). Test: przełączanie tabów.
63. Dodaj status header (ping/online). Test: aktualizacja wartości.
64. Dodaj persist UI state (g_settings). Test: odtwarza się.
65. Dodaj tick loop start/stop (scheduleEvent). Test: działa 10s.
66. Dodaj rate limiting dla akcji. Test: brak spam.
67. Dodaj safe-guards (brak akcji bez gry). Test: blokada.
68. Dodaj obsługę błędów (pcall wrapper). Test: brak crash.
69. Dodaj fallback dla brakujących API. Test: kompatybilność.
70. Dodaj diagnostykę (debug panel). Test: pokazuje dane.

71. Dodaj profiler czasu akcji (opcjonalny). Test: czasy w logu.
72. Dodaj kolejkę akcji (FIFO). Test: kolejka działa.
73. Dodaj priorytety akcji. Test: wyższy priorytet działa.
74. Dodaj tryb “preview” bez wykonywania akcji. Test: brak efektu.
75. Dodaj tryb “safe mode” (tylko UI). Test: brak ingerencji.
76. Dodaj walidację wejścia edytora akcji. Test: nie przyjmuje błędów.
77. Dodaj undo/redo w edytorze. Test: cofanie działa.
78. Dodaj autosave konfiguracji. Test: odtwarza się po restarcie.
79. Dodaj migracje danych (v1 -> v2). Test: migracja ok.
80. Dodaj mechanizm powiadomień UI. Test: toast się pojawia.

81. Dodaj stronę pomocy w UI. Test: otwiera się.
82. Dodaj skróty klawiszowe do głównych akcji. Test: działają.
83. Dodaj panel ustawień (toggle/slider). Test: zapis ustawień.
84. Dodaj eksport raportu diagnostycznego. Test: plik raportu.
85. Dodaj tryb “minimal UI” (compact). Test: mniejszy layout.
86. Dodaj kontrolę uprawnień akcji (whitelist). Test: blokuje nieautoryzowane.
87. Dodaj watchdog stanu modułu. Test: wykrywa brak stanu.
88. Dodaj obsługę błędów IO (brak zapisu). Test: komunikat.
89. Dodaj mechanizm weryfikacji configu. Test: wykrywa błędy.
90. Dodaj wbudowane przykładowe akcje. Test: działają przykłady.

91. Dodaj dokumentację użytkownika (PL/EN). Test: review.
92. Dodaj instrukcję instalacji. Test: działa krok po kroku.
93. Dodaj opis konfiguracji collector. Test: przykłady.
94. Dodaj opis formatu danych. Test: zgodność z parserem.
95. Dodaj checklistę testów manualnych. Test: wykonanie listy.
96. Dodaj scenariusze QA (UI, hotkeys, load). Test: raport.
97. Dodaj minimalny zestaw benchmarków. Test: czas ładowania.
98. Dodaj wersjonowanie modułu w otmod. Test: wyświetla wersję.
99. Dodaj changelog w docs. Test: aktualizacja.
100. Przygotuj release checklist. Test: odhaczone punkty.
