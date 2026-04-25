# ZAPCORE — Anti-DPI Bypass Tool

ZAPCORE - однострочный инструмент для обхода DPI (Deep Packet Inspection) на Windows.
Работает через фрагментацию пакетов, подмену TTL и отправку фиктивных дубликатов.

Поддержка: Windows 10/11
Лицензия: MIT
Размер: 8KB

-------------------------------------------------------------------------------

Быстрый старт

1. Скачать zapcore.bat
2. Запустить от имени Администратора
3. Выбрать режим (1-10)
4. Работать в обход блокировок

-------------------------------------------------------------------------------

Установка

curl -o zapcore.bat https://raw.githubusercontent.com/yourname/zapcore/main/zapcore.bat

При первом запуске WinDivert скачается автоматически.

-------------------------------------------------------------------------------

Меню

[1]  START - SYN + TTL SPOOF
[2]  START - FRAGMENT MODE (MTU 128)
[3]  START - FRAGMENT MODE (MTU 1400)
[4]  START - FULL BYPASS
[5]  START - TURBO MODE (mtu
