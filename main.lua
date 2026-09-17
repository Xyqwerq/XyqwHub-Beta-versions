-- ========== XyqwHub - Версия 6.2 ==========
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "XyqwHub", Text = "XyqwHub Loading...", Duration = 3
})
print("[XyqwHub] Loading...")

if getgenv().XyqwHubRunning then
    local msg = "Script re-launch has been blocked!"
    if getgenv().XyqwLanguage == "RU" then msg = "Повторный запуск был заблокирован!" end
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "XyqwHub", Text = msg, Duration = 5})
    print("[XyqwHub] " .. msg)
    return
end
getgenv().XyqwHubRunning = true

local VERSION = "6.2"
local OWNER_IDS = {4396977722, 8527910367}
local BETA_IDS = {9686718765, 3701387385}

local POSSIBLE_WORKSPACES = {
    "/sdcard/Delta/Workspace", "/sdcard/Delta",
    "/storage/emulated/0/Delta/Workspace", "/storage/emulated/0/Delta",
    "/storage/emulated/0/Android/data/com.roblox.client/files/Delta/Workspace",
    "/storage/emulated/0/Android/data/com.roblox.client/files/Delta",
    "/data/user/0/com.roblox.client/files/Delta/Workspace",
    "/data/data/com.roblox.client/files/Delta/Workspace",
    "/storage/emulated/0/Documents/Delta/Workspace",
    "/sdcard/Solara/Workspace", "/storage/emulated/0/Solara/Workspace",
    "/sdcard/Arceus X/Workspace", "/sdcard/ArceusX/Workspace",
    "/storage/emulated/0/Arceus X/Workspace", "/storage/emulated/0/ArceusX/Workspace",
    "/storage/emulated/0/Android/data/com.roblox.client/files/Arceus X/Workspace",
    "/sdcard/Codex/Workspace", "/storage/emulated/0/Codex/Workspace",
    "/sdcard/Xen/Workspace", "/storage/emulated/0/Xen/Workspace",
    "/sdcard/Fluxus/Workspace", "/storage/emulated/0/Fluxus/Workspace",
    "/sdcard/Hydrogen/Workspace", "/storage/emulated/0/Hydrogen/Workspace",
    "/sdcard/Krnl/Workspace", "/sdcard/Triggers/Workspace",
    "/sdcard/Wave/Workspace", "/sdcard/Real/Workspace",
    "/sdcard/VegaX/Workspace", "/sdcard/Fandango/Workspace",
    "/sdcard/Mystic/Workspace", "/sdcard/Anemo/Workspace",
    "/sdcard/KiwiX/Workspace", "/sdcard/Workspace",
    "/storage/emulated/0/Executor/Workspace",
    "/storage/emulated/0/Workspace",
}

local foundWorkspace = nil
for _, path in ipairs(POSSIBLE_WORKSPACES) do
    pcall(function() if isfolder(path) then foundWorkspace = path end end)
    if foundWorkspace then break end
end

if not foundWorkspace then
    pcall(function()
        if writefile then
            writefile("XyqwHub_test.txt", "test")
            if isfile("XyqwHub_test.txt") then
                foundWorkspace = "VIRTUAL"
                delfile("XyqwHub_test.txt")
            end
        end
    end)
end

local CONFIG_FOLDER
if foundWorkspace == "VIRTUAL" then CONFIG_FOLDER = "XyqwHub"
elseif foundWorkspace then CONFIG_FOLDER = foundWorkspace .. "/XyqwHub"
else CONFIG_FOLDER = "XyqwHub" end

local FAV_FOLDER = CONFIG_FOLDER .. "/FavScripts"
local RCT_FOLDER = CONFIG_FOLDER .. "/RctScripts"
local CUSTOM_COLOR_FOLDER = CONFIG_FOLDER .. "/CustomColor"
local AUTOEXEC_FOLDER = CONFIG_FOLDER .. "/AutoExecute"
local BLACKLIST_FOLDER = CONFIG_FOLDER .. "/Blacklist"
local SETTINGS_FOLDER = CONFIG_FOLDER .. "/Settings"

local FAV_FILE = FAV_FOLDER .. "/favorites.json"
local RCT_FILE = RCT_FOLDER .. "/recent.json"
local CUSTOM_COLOR_FILE = CUSTOM_COLOR_FOLDER .. "/custom_color.json"
local AUTOEXEC_FILE = AUTOEXEC_FOLDER .. "/autoexec.json"
local BLACKLIST_FILE = BLACKLIST_FOLDER .. "/blacklist.json"
local SETTINGS_FILE = SETTINGS_FOLDER .. "/settings.json"

pcall(function()
    if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
    if not isfolder(FAV_FOLDER) then makefolder(FAV_FOLDER) end
    if not isfolder(RCT_FOLDER) then makefolder(RCT_FOLDER) end
    if not isfolder(CUSTOM_COLOR_FOLDER) then makefolder(CUSTOM_COLOR_FOLDER) end
    if not isfolder(AUTOEXEC_FOLDER) then makefolder(AUTOEXEC_FOLDER) end
    if not isfolder(BLACKLIST_FOLDER) then makefolder(BLACKLIST_FOLDER) end
    if not isfolder(SETTINGS_FOLDER) then makefolder(SETTINGS_FOLDER) end
end)

local function SaveTable(path, tbl)
    pcall(function()
        if writefile then writefile(path, game:GetService("HttpService"):JSONEncode(tbl)) end
    end)
end

local function LoadTable(path)
    local ok, data = pcall(function()
        if readfile and isfile and isfile(path) then
            return game:GetService("HttpService"):JSONDecode(readfile(path))
        end
        return nil
    end)
    if ok and type(data) == "table" then return data end
    return {}
end

getgenv().XyqwFavorites = LoadTable(FAV_FILE)
getgenv().XyqwRecent = LoadTable(RCT_FILE)
getgenv().XyqwAutoExec = LoadTable(AUTOEXEC_FILE)
getgenv().XyqwBlacklist = LoadTable(BLACKLIST_FILE)
getgenv().XyqwSettings = LoadTable(SETTINGS_FILE)

if not getgenv().XyqwSettings.sortMode then getgenv().XyqwSettings.sortMode = "default" end
if not getgenv().XyqwSettings.autoHideBind then getgenv().XyqwSettings.autoHideBind = "RightShift" end
if not getgenv().XyqwSettings.urlStatus then getgenv().XyqwSettings.urlStatus = {} end

if getgenv().XyqwCustomColor == nil then
    local saved = LoadTable(CUSTOM_COLOR_FILE)
    if saved.r and saved.g and saved.b then
        getgenv().XyqwCustomColor = {
            r = saved.r, g = saved.g, b = saved.b,
            dr = saved.dr or math.floor(saved.r * 0.15),
            dg = saved.dg or math.floor(saved.g * 0.15),
            db = saved.db or math.floor(saved.b * 0.15),
        }
    else
        getgenv().XyqwCustomColor = {r = 255, g = 0, b = 0, dr = 40, dg = 0, db = 0}
    end
end

if getgenv().XyqwLanguage == nil then getgenv().XyqwLanguage = "EN" end
if getgenv().XyqwTheme == nil then getgenv().XyqwTheme = "Red" end
if getgenv().TopBarHidden == nil then getgenv().TopBarHidden = false end

local THEMES = {
    Red = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 0)},
    Blue = {MAIN = Color3.fromRGB(0, 140, 255), DARK = Color3.fromRGB(0, 20, 50), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 10, 25)},
    Green = {MAIN = Color3.fromRGB(0, 220, 90), DARK = Color3.fromRGB(0, 40, 15), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 20, 8)},
    Purple = {MAIN = Color3.fromRGB(180, 0, 255), DARK = Color3.fromRGB(30, 0, 45), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(15, 0, 22)},
    Pink = {MAIN = Color3.fromRGB(255, 20, 147), DARK = Color3.fromRGB(45, 0, 25), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 0, 12)},
    Orange = {MAIN = Color3.fromRGB(255, 140, 0), DARK = Color3.fromRGB(45, 25, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 12, 0)},
    Cyan = {MAIN = Color3.fromRGB(0, 255, 255), DARK = Color3.fromRGB(0, 40, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 20, 20)},
    Yellow = {MAIN = Color3.fromRGB(255, 230, 0), DARK = Color3.fromRGB(45, 40, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 20, 0)},
    Lime = {MAIN = Color3.fromRGB(50, 255, 50), DARK = Color3.fromRGB(0, 45, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(0, 22, 0)},
    Magenta = {MAIN = Color3.fromRGB(255, 0, 255), DARK = Color3.fromRGB(45, 0, 45), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(22, 0, 22)},
    White = {MAIN = Color3.fromRGB(255, 255, 255), DARK = Color3.fromRGB(40, 40, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 20, 20)},
    Rainbow = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 40), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 20)},
    Custom = {MAIN = Color3.fromRGB(255, 0, 0), DARK = Color3.fromRGB(40, 0, 0), BG = Color3.fromRGB(0, 0, 0), TITLE = Color3.fromRGB(20, 0, 0)},
}

local RED_MAIN = THEMES[getgenv().XyqwTheme].MAIN
local RED_DARK = THEMES[getgenv().XyqwTheme].DARK
local RED_BG = THEMES[getgenv().XyqwTheme].BG
local RED_TITLE = THEMES[getgenv().XyqwTheme].TITLE

local URL_OK = Color3.fromRGB(0, 255, 100)
local URL_BAD = Color3.fromRGB(255, 50, 50)
local URL_UNKNOWN = Color3.fromRGB(150, 150, 150)
local URL_CHECKING = Color3.fromRGB(255, 200, 0)

-- ========== ЯЗЫКИ (5 штук, полный ChangeLog для всех) ==========
local LANG = {
    EN = {
        Loaded = "loaded", Error = "error", Search = "Search...",
        CustomPlaceholder = "Paste URL or loadstring...", RunCustom = "Run",
        JobIdCopied = "JobId copied!", ScriptExecuted = "Script executed!",
        OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3",
        TagRemoved = "Tag removed!", HideTopBarOn = "Hide Top Bar: ON", HideTopBarOff = "Hide Top Bar: OFF",
        LangChanged = "Language changed to English",
        FavShared = "Favorites shared! Check clipboard",
        RctShared = "Recent scripts shared! Check clipboard",
        LoadstringCopied = "Loadstring copied, thank you :3",
        ColorReset = "Custom Color reset to Red",
        ColorShared = "Color copied to clipboard!",
        AutoExecOn = "Auto-Execute: ON", AutoExecOff = "Auto-Execute: OFF",
        BlacklistAdded = "Script blacklisted!", BlacklistRemoved = "Script unblacklisted!",
        KeybindChanged = "Auto-Hide keybind: ",
        UrlCheckStarted = "Testing URLs...", UrlCheckDone = "URL test complete!",
        WelcomeTitle = "Welcome to XyqwHub!",
        ClickXToClose = "Click X to close",
        -- UI элементы
        PlayersTitle = "Players", ServerTitle = "Server Info", CustomTitle = "Custom Script",
        CustomColorTitle = "Custom Color", ChangeLogTitle = "ChangeLog", SettingsTitle = "Settings", BlacklistTitle = "Blacklist",
        Apply = "Apply", Reset = "Reset", ShareColor = "Share Color", CopyJobId = "Copy JobId",
        Rejoin = "Rejoin", ServerHop = "ServerHop", TPToSmall = "TP to Small", RemoveTags = "Remove Tags",
        ShareFav = "Share Favorite Scripts", ShareRct = "Share Recent Scripts", ManageBlacklist = "Manage Blacklist",
        TestURLs = "Test URLs", SettingsBtn = "Settings (Auto-Hide bind)", Destroy = "Destroy XyqwHub",
        PlaceId = "PlaceId", JobId = "JobId", Players = "Players", Creator = "Creator",
        BlacklistEmpty = "Blacklist is empty", BlacklistHint = "Click × to unblacklist",
        Presets = "Presets", AutoHideBind = "Auto-Hide keybind:",
        WelcomeFiles = "Files: XyqwHub/FavScripts, RctScripts, CustomColor",
        ShareHub = "Share XyqwHub", HideTopBar = "Hide Top Bar",
        ChangeLogText = [[XyqwHub ChangeLog

Version 6.2
- Fixed blacklist × not removing item
- Fixed Script unblacklisted notification
- Full changelog for all languages
- All UI translated (except social media)

Version 6.1
- Fixed blacklist refreshing

Version 6.0
- 5 languages: EN, RU, UK, BE, KK
- Welcome message restored

Version 5.9
- X in right corner

Version 5.6
- NO rounded corners
- Default tab All

Version 5.5
- Auto Execute, Blacklist, Auto Hide, URL Tester, Sorting

Version 5.0
- Custom Color instant

Version 4.9
- 13 themes

Version 4.7
- Custom Color picker

Version 4.0
- First 4.0 release

Version 1.0
- First release]],
    },
    RU = {
        Loaded = "загружен", Error = "ошибка", Search = "Поиск...",
        CustomPlaceholder = "Ссылка или loadstring...", RunCustom = "Запустить",
        JobIdCopied = "JobId скопирован!", ScriptExecuted = "Скрипт выполнен!",
        OwnerWelcome = "Welcome, my father :3", BetaWelcome = "Glad you're here, tester <3",
        TagRemoved = "Тег убран!", HideTopBarOn = "Скрыть топ бар: вкл", HideTopBarOff = "Скрыть топ бар: выкл",
        LangChanged = "Язык изменён на Русский",
        FavShared = "Избранное скопировано!",
        RctShared = "Недавние скопированы!",
        LoadstringCopied = "Loadstring скопирован, спасибо :3",
        ColorReset = "Custom Color сброшен на Красный",
        ColorShared = "Цвет скопирован!",
        AutoExecOn = "Авто-запуск: ВКЛ", AutoExecOff = "Авто-запуск: ВЫКЛ",
        BlacklistAdded = "Скрипт в чёрном списке!", BlacklistRemoved = "Скрипт убран из чёрного списка!",
        KeybindChanged = "Бинд Auto-Hide: ",
        UrlCheckStarted = "Проверка URL...", UrlCheckDone = "Проверка завершена!",
        WelcomeTitle = "Добро пожаловать в XyqwHub!",
        ClickXToClose = "Нажми X чтобы закрыть",
        PlayersTitle = "Игроки", ServerTitle = "Инфо о сервере", CustomTitle = "Свой скрипт",
        CustomColorTitle = "Свой цвет", ChangeLogTitle = "Ченджлог", SettingsTitle = "Настройки", BlacklistTitle = "Чёрный список",
        Apply = "Применить", Reset = "Сбросить", ShareColor = "Поделиться цветом", CopyJobId = "Копировать JobId",
        Rejoin = "Перезайти", ServerHop = "Сменить сервер", TPToSmall = "ТП в маленький", RemoveTags = "Убрать теги",
        ShareFav = "Поделиться избранным", ShareRct = "Поделиться недавними", ManageBlacklist = "Управление чёрным списком",
        TestURLs = "Проверить URL", SettingsBtn = "Настройки (Бинд Auto-Hide)", Destroy = "Удалить XyqwHub",
        PlaceId = "PlaceId", JobId = "JobId", Players = "Игроки", Creator = "Создатель",
        BlacklistEmpty = "Чёрный список пуст", BlacklistHint = "Нажми × чтобы убрать",
        Presets = "Пресеты", AutoHideBind = "Бинд Auto-Hide:",
        WelcomeFiles = "Файлы: XyqwHub/FavScripts, RctScripts, CustomColor",
        ShareHub = "Поделиться XyqwHub", HideTopBar = "Скрыть топ бар",
        ChangeLogText = [[XyqwHub Ченджлог

Версия 6.2
- Фикс × в чёрном списке (не удалялся)
- Фикс уведомления "Скрипт убран из чёрного списка!"
- Полный ченджлог для всех языков
- Весь UI переведён (кроме соцсетей)

Версия 6.1
- Фикс обновления блеклиста

Версия 6.0
- 5 языков: EN, RU, UK, BE, KK
- Возвращено приветствие

Версия 5.9
- X в правом углу

Версия 5.6
- БЕЗ скруглений
- Базовая вкладка All

Версия 5.5
- Auto Execute, Blacklist, Auto Hide, URL Tester, Sorting

Версия 5.0
- Custom Color мгновенно

Версия 4.9
- 13 тем

Версия 4.7
- Custom Color picker

Версия 4.0
- Первый релиз

Версия 1.0
- Первый релиз]],
    },
    UK = {
        Loaded = "завантажено", Error = "помилка", Search = "Пошук...",
        CustomPlaceholder = "Вставте URL або loadstring...", RunCustom = "Запустити",
        JobIdCopied = "JobId скопійовано!", ScriptExecuted = "Скрипт виконано!",
        OwnerWelcome = "Вітаю, мій батько :3", BetaWelcome = "Радий тебе бачити, тестер <3",
        TagRemoved = "Тег прибрано!", HideTopBarOn = "Верхня панель: УВІМК", HideTopBarOff = "Верхня панель: ВИМК",
        LangChanged = "Мову змінено на Українську",
        FavShared = "Обране скопійовано!",
        RctShared = "Останні скрипти скопійовано!",
        LoadstringCopied = "Loadstring скопійовано, дякую :3",
        ColorReset = "Колір скинуто", ColorShared = "Колір скопійовано!",
        AutoExecOn = "Авто-запуск: УВІМК", AutoExecOff = "Авто-запуск: ВИМК",
        BlacklistAdded = "Скрипт у чорному списку!", BlacklistRemoved = "Скрипт прибрано з чорного списку!",
        KeybindChanged = "Бінд Auto-Hide: ",
        UrlCheckStarted = "Перевірка URL...", UrlCheckDone = "Перевірку завершено!",
        WelcomeTitle = "Ласкаво просимо до XyqwHub!",
        ClickXToClose = "Натисни X щоб закрити",
        PlayersTitle = "Гравці", ServerTitle = "Інфо про сервер", CustomTitle = "Свій скрипт",
        CustomColorTitle = "Свій колір", ChangeLogTitle = "Журнал", SettingsTitle = "Налаштування", BlacklistTitle = "Чорний список",
        Apply = "Застосувати", Reset = "Скинути", ShareColor = "Поділитись кольором", CopyJobId = "Копіювати JobId",
        Rejoin = "Перезайти", ServerHop = "Змінити сервер", TPToSmall = "ТП в маленький", RemoveTags = "Прибрати теги",
        ShareFav = "Поділитись обраним", ShareRct = "Поділитись останніми", ManageBlacklist = "Керування чорним списком",
        TestURLs = "Перевірити URL", SettingsBtn = "Налаштування (Бінд Auto-Hide)", Destroy = "Видалити XyqwHub",
        PlaceId = "PlaceId", JobId = "JobId", Players = "Гравці", Creator = "Творець",
        BlacklistEmpty = "Чорний список порожній", BlacklistHint = "Натисни × щоб прибрати",
        Presets = "Пресети", AutoHideBind = "Бінд Auto-Hide:",
        WelcomeFiles = "Файли: XyqwHub/FavScripts, RctScripts, CustomColor",
        ShareHub = "Поділитись XyqwHub", HideTopBar = "Сховати верхню панель",
        ChangeLogText = [[XyqwHub Журнал

Версія 6.2
- Фікс × у чорному списку (не видалявся)
- Фікс сповіщення "Скрипт прибрано з чорного списку!"
- Повний журнал для всіх мов
- Весь UI перекладено (крім соцмереж)

Версія 6.1
- Фікс оновлення чорного списку

Версія 6.0
- 5 мов: EN, RU, UK, BE, KK
- Повернуто вітальне повідомлення

Версія 5.9
- X у правому куті

Версія 5.6
- Без заокруглень
- Базова вкладка All

Версія 5.5
- Auto Execute, Blacklist, Auto Hide, URL Tester, Sorting

Версія 5.0
- Custom Color миттєво

Версія 4.9
- 13 тем

Версія 4.7
- Custom Color picker

Версія 4.0
- Перший реліз

Версія 1.0
- Перший реліз]],
    },
    BE = {
        Loaded = "загружана", Error = "памылка", Search = "Пошук...",
        CustomPlaceholder = "Устаўце URL або loadstring...", RunCustom = "Запусціць",
        JobIdCopied = "JobId скапіяваны!", ScriptExecuted = "Скрыпт выкананы!",
        OwnerWelcome = "Вітаю, мой бацька :3", BetaWelcome = "Рады цябе бачыць, тэстар <3",
        TagRemoved = "Тэг прыбраны!", HideTopBarOn = "Верхняя панэль: УКЛ", HideTopBarOff = "Верхняя панэль: ВЫКЛ",
        LangChanged = "Мова зменена на Беларускую",
        FavShared = "Абранае скапіявана!",
        RctShared = "Апошнія скрыпты скапіяваны!",
        LoadstringCopied = "Loadstring скапіяваны, дзякуй :3",
        ColorReset = "Колер скінуты", ColorShared = "Колер скапіяваны!",
        AutoExecOn = "Аўта-запуск: УКЛ", AutoExecOff = "Аўта-запуск: ВЫКЛ",
        BlacklistAdded = "Скрыпт у чорным спісе!", BlacklistRemoved = "Скрыпт прыбраны з чорнага спісу!",
        KeybindChanged = "Бінд Auto-Hide: ",
        UrlCheckStarted = "Праверка URL...", UrlCheckDone = "Праверка завершана!",
        WelcomeTitle = "Сардэчна запрашаем у XyqwHub!",
        ClickXToClose = "Націсні X каб зачыніць",
        PlayersTitle = "Гульцы", ServerTitle = "Інфа пра сервер", CustomTitle = "Свой скрыпт",
        CustomColorTitle = "Свой колер", ChangeLogTitle = "Чэйнджлог", SettingsTitle = "Налады", BlacklistTitle = "Чорны спіс",
        Apply = "Ужыць", Reset = "Скінуць", ShareColor = "Падзяліцца колерам", CopyJobId = "Капіяваць JobId",
        Rejoin = "Перазайсці", ServerHop = "Змяніць сервер", TPToSmall = "ТП у маленькі", RemoveTags = "Прыбраць тэгі",
        ShareFav = "Падзяліцца абраным", ShareRct = "Падзяліцца апошнімі", ManageBlacklist = "Кіраванне чорным спісам",
        TestURLs = "Праверыць URL", SettingsBtn = "Налады (Бінд Auto-Hide)", Destroy = "Выдаліць XyqwHub",
        PlaceId = "PlaceId", JobId = "JobId", Players = "Гульцы", Creator = "Стваральнік",
        BlacklistEmpty = "Чорны спіс пусты", BlacklistHint = "Націсні × каб прыбраць",
        Presets = "Прэсеты", AutoHideBind = "Бінд Auto-Hide:",
        WelcomeFiles = "Файлы: XyqwHub/FavScripts, RctScripts, CustomColor",
        ShareHub = "Падзяліцца XyqwHub", HideTopBar = "Схаваць верхнюю панэль",
        ChangeLogText = [[XyqwHub Чэйнджлог

Версія 6.2
- Фікс × у чорным спісе (не выдаляўся)
- Фікс апавяшчэння "Скрыпт прыбраны з чорнага спісу!"
- Поўны чэйнджлог для ўсіх моў
- Увесь UI перакладзены (акрамя сацсетак)

Версія 6.1
- Фікс абнаўлення чорнага спісу

Версія 6.0
- 5 моў: EN, RU, UK, BE, KK
- Вернута прывітальнае паведамленне

Версія 5.9
- X у правым куце

Версія 5.6
- Без заакругленняў
- Базавая ўкладка All

Версія 5.5
- Auto Execute, Blacklist, Auto Hide, URL Tester, Sorting

Версія 5.0
- Custom Color імгненна

Версія 4.9
- 13 тэм

Версія 4.7
- Custom Color picker

Версія 4.0
- Першы рэліз

Версія 1.0
- Першы рэліз]],
    },
    KK = {
        Loaded = "жүктелді", Error = "қате", Search = "Іздеу...",
        CustomPlaceholder = "URL немесе loadstring қойыңыз...", RunCustom = "Іске қосу",
        JobIdCopied = "JobId көшірілді!", ScriptExecuted = "Скрипт орындалды!",
        OwnerWelcome = "Қош келдің, әкем :3", BetaWelcome = "Көргеніме қуаныштымын, тестер <3",
        TagRemoved = "Тег жойылды!", HideTopBarOn = "Жоғарғы тақта: ҚОСУЛЫ", HideTopBarOff = "Жоғарғы тақта: ӨШІРУЛІ",
        LangChanged = "Тіл Қазақшаға өзгертілді",
        FavShared = "Таңдаулылар көшірілді!",
        RctShared = "Соңғы скрипттер көшірілді!",
        LoadstringCopied = "Loadstring көшірілді, рахмет :3",
        ColorReset = "Түс қалпына келтірілді", ColorShared = "Түс көшірілді!",
        AutoExecOn = "Авто-орындау: ҚОСУЛЫ", AutoExecOff = "Авто-орындау: ӨШІРУЛІ",
        BlacklistAdded = "Скрипт қара тізімде!", BlacklistRemoved = "Скрипт қара тізімнен жойылды!",
        KeybindChanged = "Auto-Hide байланысы: ",
        UrlCheckStarted = "URL тексерілуде...", UrlCheckDone = "Тексеру аяқталды!",
        WelcomeTitle = "XyqwHub-қа қош келдіңіз!",
        ClickXToClose = "Жабу үшін X басыңыз",
        PlayersTitle = "Ойыншылар", ServerTitle = "Сервер туралы", CustomTitle = "Өз скрипті",
        CustomColorTitle = "Өз түсі", ChangeLogTitle = "Өзгерістер", SettingsTitle = "Параметрлер", BlacklistTitle = "Қара тізім",
        Apply = "Қолдану", Reset = "Қалпына келтіру", ShareColor = "Түспен бөлісу", CopyJobId = "JobId көшіру",
        Rejoin = "Қайта кіру", ServerHop = "Серверді ауыстыру", TPToSmall = "Кішіге ТП", RemoveTags = "Тегтерді алу",
        ShareFav = "Таңдаулылармен бөлісу", ShareRct = "Соңғылармен бөлісу", ManageBlacklist = "Қара тізімді басқару",
        TestURLs = "URL тексеру", SettingsBtn = "Параметрлер (Auto-Hide байланысы)", Destroy = "XyqwHub жою",
        PlaceId = "PlaceId", JobId = "JobId", Players = "Ойыншылар", Creator = "Жасаушы",
        BlacklistEmpty = "Қара тізім бос", BlacklistHint = "Жою үшін × басыңыз",
        Presets = "Пресеттер", AutoHideBind = "Auto-Hide байланысы:",
        WelcomeFiles = "Файлдар: XyqwHub/FavScripts, RctScripts, CustomColor",
        ShareHub = "XyqwHub-пен бөлісу", HideTopBar = "Жоғарғы тақтаны жасыру",
        ChangeLogText = [[XyqwHub Өзгерістер

6.2 нұсқасы
- × қара тізімде түзетілді (жойылмады)
- "Скрипт қара тізімнен жойылды!" хабарламасы түзетілді
- Барлық тілдер үшін толық өзгерістер
- Барлық UI аударылды (әлеуметтік желілерден басқа)

6.1 нұсқасы
- Қара тізім жаңарту түзетілді

6.0 нұсқасы
- 5 тіл: EN, RU, UK, BE, KK
- Қош келу хабарламасы қалпына келтірілді

5.9 нұсқасы
- X оң жақ бұрышта

5.6 нұсқасы
- Дөңгелектену жоқ
- Негізгі қойынды All

5.5 нұсқасы
- Auto Execute, Blacklist, Auto Hide, URL Tester, Sorting

5.0 нұсқасы
- Custom Color бірден

4.9 нұсқасы
- 13 тақырып

4.7 нұсқасы
- Custom Color picker

4.0 нұсқасы
- Алғашқы шығарылым

1.0 нұсқасы
- Алғашқы шығарылым]],
    },
}

local function _(key)
    local lang = getgenv().XyqwLanguage or "EN"
    return LANG[lang][key] or LANG.EN[key] or key
end

local function ShowRobloxNotification(text, duration)
    duration = duration or 4
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "XyqwHub", Text = text, Duration = duration
        })
    end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local SCRIPTS = {
    {Name = "Blade Ball", Category = "BB", URL = "https://raw.githubusercontent.com/joshhhie/rise/refs/heads/main/loader.lua"},
    {Name = "Blade Ball 2", Category = "BB", URL = "https://wings.ac/loader"},
    {Name = "Blade Ball 3", Category = "BB", URL = "https://raw.githubusercontent.com/2xrW/return/refs/heads/main/hub"},
    {Name = "AntiKillParts", Category = "Misc", URL = "https://raw.githubusercontent.com/sovetskii-shashlik/Anti-kill-parts-updated-/refs/heads/main/Anti%20kill%20parts%20by%20Zephyr"},
    {Name = "PulseHub", Category = "Misc", URL = "https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"},
    {Name = "RUNAWAYS", Category = "Misc", URL = "https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/RUNAWAYS.lua"},
    {Name = "Universal FE", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-Universal-FE-Free-keyless-FE-script-242513"},
    {Name = "UwU hub", Category = "INK", URL = "https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/INK-GAME"},
    {Name = "Ringta (INK)", Category = "INK", URL = "https://rawscripts.net/raw/Universal-Script-RINGTA-best-script-for-ink-game-206674"},
    {Name = "AX Scripts (INK)", Category = "INK", URL = "https://officialaxscripts.vercel.app/scripts/AX-Loader.lua"},
    {Name = "FakeVR", Category = "Misc", URL = "https://pastefy.app/MvKHpycG/raw"},
    {Name = "WallHop", Category = "Misc", URL = "https://raw.githubusercontent.com/ScpGuest666/Random-Roblox-script/refs/heads/main/Roblox%20WallHop%20script"},
    {Name = "RuzHub (MM2)", Category = "MM2", URL = "https://raw.githubusercontent.com/pruzgar242-rgb/Update/refs/heads/main/out.lua%20(17).txt"},
    {Name = "Kiti (MM2)", Category = "MM2", URL = "https://pastefy.app/gPuS4n3Q/raw"},
    {Name = "CandyWare (MM2)", Category = "MM2", URL = "https://raw.githubusercontent.com/Be1for/Scripts/refs/heads/main/candyware.luau"},
    {Name = "RemainsHub V2", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-RemainsHub-V2-50805"},
    {Name = "R6 Emotes", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-r6-emotes-OPEN-SOURCE-69464"},
    {Name = "Jujutsu Sheninagouns", Category = "Misc", URL = "https://raw.githubusercontent.com/peeky-co/scripts/refs/heads/main/tbo"},
    {Name = "Free Cam", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-Free-cam-script-pc-and-mobile-223089"},
    {Name = "Doors (Abysall)", Category = "Misc", URL = "https://rawscripts.net/raw/DOORS-Abysall-hub-OP-205906"},
    {Name = "Doors V2 (Copy)", Category = "Misc", URL = "SPECIAL_COPY_DOORS_V2"},
    {Name = "Doors V3 (Cheesy)", Category = "Misc", URL = "https://raw.githubusercontent.com/doram44/cheesy/refs/heads/main/cheesy.lua"},
    {Name = "Doors v4", Category = "Misc", URL = "https://raw.githubusercontent.com/sillyleo67/Doors/refs/heads/main/Twinkhook.lua"},
    {Name = "Fling Gui", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-fling-gui-99753"},
    {Name = "Infinite Yield", Category = "Misc", URL = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {Name = "Walk on walls", Category = "Misc", URL = "https://rawscripts.net/raw/The-patience-obby-Universal-Walk-on-walls-18129"},
    {Name = "AetherX (Death Penalty)", Category = "Misc", URL = "https://api.luarmor.net/files/v3/loaders/8c08b8f2252eec7dbb77d253d269bb65.lua"},
    {Name = "Voidware (INK/99N/Forsaken)", Category = "Misc", URL = "https://files.vapevoidware.xyz/VapeVoidware/VW-Add/main/loader.lua"},
    {Name = "LaLol Hub (B4ckd0or)", Category = "Misc", URL = "https://raw.githubusercontent.com/Miygteet/Hacker101/refs/heads/main/LALOL-Backdoor-Secure.lua"},
    {Name = "FTAP", Category = "Misc", URL = "https://api.jnkie.com/api/v1/luascripts/public/4078649e4397f0e2cdaddde241d69bfd67b2b7107917891384735129c85cae18/download"},
    {Name = "MinhNat Hub (TSB)", Category = "Misc", URL = "https://rawscripts.net/raw/Universal-Script-MinhNhat-Tsb-62161"},
    {Name = "BC9 (UTG)", Category = "Misc", URL = "https://rawscripts.net/raw/untitled-tag-game-BC9-UTG-MENU-116806"},
    {Name = "FTAP (WITH KEY!!)", Category = "Misc", URL = "https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua"},
    {Name = "RadiumHub (Pressure)", Category = "Misc", URL = "https://rawscripts.net/raw/UPDATE-Pressure-God-Mode-Auto-Loot-ESP-Full-Bright-No-Eyefestation-224409"},
    {Name = "Steal an egg", Category = "Misc", URL = "https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"},
    {Name = "Universal script", Category = "Misc", URL = "https://raw.githubusercontent.com/fleecelolll/Fleece-s-Utility-Panel/refs/heads/main/Script.lua"},
    {Name = "Corridor", Category = "Misc", URL = "https://saga2015.b-cdn.net/corridor.luau"},
    {Name = "BloxStrike", Category = "Misc", URL = "https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/BloxStrike.lua"},
    {Name = "RIVALS", Category = "Misc", URL = "https://raw.githubusercontent.com/imshrak/rivals/refs/heads/main/main"},
    {Name = "Troll script", Category = "Misc", URL = "https://mois7.xyz/loader"},
    {Name = "Death Order [SIMON]", Category = "Misc", URL = "https://rawscripts.net/raw/Death-Order:-Simon-Says-BEST-DEATH-ORDER-SCRIPT-226542"},
    {Name = "DropKick", Category = "Misc", URL = "https://raw.githubusercontent.com/yes-d3v-scripts/drop-kick-fling/refs/heads/main/script"},
    {Name = "Evade", Category = "Misc", URL = "https://github.com/imc72s/LaztDex/raw/refs/heads/main/EvadeScriptLaztDex"},
    {Name = "A dusty trip", Category = "Misc", URL = "https://raw.githubusercontent.com/BalintTheDevXBack/Games/refs/heads/main/aDustyTrip"},
    {Name = "A dusty trip v2", Category = "Misc", URL = "https://raw.githubusercontent.com/VoxlarWIP/Src/refs/heads/main/adustytrip.lua"},
    {Name = "bLockman's minesweaper", Category = "Misc", URL = "https://pastefy.app/T5XIfiMo/raw"},
    {Name = "Cheating during test", Category = "Misc", URL = "https://files.catbox.moe/pkulzc.txt"},
    {Name = "Adopt me", Category = "Misc", URL = "https://raw.githubusercontent.com/JaxRol/ZeroPoint/refs/heads/main/KeySystem"},
}

task.spawn(function()
    task.wait(2)
    for name, enabled in pairs(getgenv().XyqwAutoExec) do
        if enabled then
            for _, data in ipairs(SCRIPTS) do
                if data.Name == name and data.URL ~= "SPECIAL_COPY_DOORS_V2" then
                    pcall(function() loadstring(game:HttpGet(data.URL))() end)
                    print("[XyqwHub] Auto-executed: " .. name)
                    break
                end
            end
        end
    end
end)

local function IsOwner()
    for _, id in ipairs(OWNER_IDS) do
        if Players.LocalPlayer.UserId == id then return true end
    end
    return false
end

local function IsBeta()
    for _, id in ipairs(BETA_IDS) do
        if Players.LocalPlayer.UserId == id then return true end
    end
    return false
end

local tagsEnabled = true
local activeTags = {}

local function GetRole(plr)
    for _, id in ipairs(OWNER_IDS) do if plr.UserId == id then return "OWNER" end end
    for _, id in ipairs(BETA_IDS) do if plr.UserId == id then return "TESTER" end end
    return nil
end

local function CreateTagForPlayer(plr)
    if not tagsEnabled then return end
    local role = GetRole(plr)
    if not role then return end
    if activeTags[plr] and activeTags[plr].Parent then return end
    local char = plr.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "XyqwTag"
    billboard.Size = UDim2.new(0, 160, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 500
    billboard.Adornee = rootPart
    billboard.Parent = char

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 150, 0, 18)
    label.Position = UDim2.new(0.5, -75, 0.5, -9)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeTransparency = 0
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Parent = billboard

    local gradient = Instance.new("UIGradient")
    if role == "OWNER" then
        label.Text = "XyqwHub OWNER"
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 0, 0))
        })
    else
        label.Text = "XyqwHub Tester"
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 120, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 20, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 120, 255))
        })
    end
    gradient.Rotation = 0
    gradient.Parent = label

    local glow = Instance.new("UIStroke")
    glow.Color = role == "OWNER" and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(50, 120, 255)
    glow.Thickness = 1
    glow.Transparency = 0.3
    glow.Parent = label

    task.spawn(function()
        local rotation = 0
        while label.Parent and tagsEnabled do
            rotation = (rotation + 2) % 360
            gradient.Rotation = rotation
            task.wait(0.03)
        end
    end)
    activeTags[plr] = billboard
end

local function RemoveTagForPlayer(plr)
    if activeTags[plr] then activeTags[plr]:Destroy() activeTags[plr] = nil end
end

local function RemoveAllTags()
    tagsEnabled = false
    for plr, tag in pairs(activeTags) do
        if tag and tag.Parent then tag:Destroy() end
    end
    activeTags = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            local oldTag = char:FindFirstChild("XyqwTag")
            if oldTag then oldTag:Destroy() end
        end
    end
end

local function CheckAllPlayers()
    if not tagsEnabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if GetRole(plr) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            CreateTagForPlayer(plr)
        end
    end
end

local function SetupCharacterTag(plr)
    task.spawn(function()
        local char = plr.Character or plr.CharacterAdded:Wait()
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        local oldTag = char:FindFirstChild("XyqwTag")
        if oldTag then oldTag:Destroy() end
        activeTags[plr] = nil
        task.wait(0.5)
        if GetRole(plr) and tagsEnabled then CreateTagForPlayer(plr) end
    end)
end

CheckAllPlayers()
RunService.Heartbeat:Connect(CheckAllPlayers)
Players.PlayerAdded:Connect(function(plr)
    SetupCharacterTag(plr)
    plr.CharacterAdded:Connect(function() SetupCharacterTag(plr) end)
end)
Players.PlayerRemoving:Connect(RemoveTagForPlayer)
for _, plr in ipairs(Players:GetPlayers()) do
    SetupCharacterTag(plr)
    plr.CharacterAdded:Connect(function() SetupCharacterTag(plr) end)
end

local VirtualUser = game:GetService("VirtualUser")
Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local fpsValue = 60
local fpsCounter = 0
local fpsTime = 0
RunService.RenderStepped:Connect(function(dt)
    fpsCounter = fpsCounter + 1
    fpsTime = fpsTime + dt
    if fpsTime >= 1 then fpsValue = fpsCounter fpsCounter = 0 fpsTime = 0 end
end)

local function GetPing()
    local ok, ping = pcall(function() return math.floor(Players.LocalPlayer:GetNetworkPing() * 1000) end)
    return ok and ping or 0
end

local function GetExecutorName()
    local ok, name = pcall(function()
        if identifyexecutor then return identifyexecutor() end
        return "Unknown"
    end)
    return ok and name or "Unknown"
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "XyqwHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 999
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end

local topBar = Instance.new("TextButton")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(0, 420, 0, 24)
topBar.Position = UDim2.new(0.5, -210, 0, 10)
topBar.BackgroundColor3 = RED_BG
topBar.BorderSizePixel = 2
topBar.BorderColor3 = RED_MAIN
topBar.Text = ""
topBar.AutoButtonColor = false
topBar.Active = true
topBar.Parent = screenGui

local topBarText = Instance.new("TextLabel")
topBarText.Size = UDim2.new(1, -50, 1, 0)
topBarText.Position = UDim2.new(0, 5, 0, 0)
topBarText.BackgroundTransparency = 1
topBarText.Font = Enum.Font.GothamBold
topBarText.TextSize = 12
topBarText.TextColor3 = RED_MAIN
topBarText.TextXAlignment = Enum.TextXAlignment.Left
topBarText.Text = "Loading..."
topBarText.Parent = topBar

task.spawn(function()
    while topBarText.Parent do
        topBarText.Text = string.format("%s | %s | FPS: %d | Ping: %d ms",
            GetExecutorName(), Players.LocalPlayer.Name, fpsValue, GetPing())
        task.wait(1)
    end
end)

local hideTopBtn = Instance.new("TextButton")
hideTopBtn.Name = "HideTopBtn"
hideTopBtn.Size = UDim2.new(0, 45, 1, 0)
hideTopBtn.Position = UDim2.new(1, -45, 0, 0)
hideTopBtn.BackgroundColor3 = RED_DARK
hideTopBtn.TextColor3 = RED_MAIN
hideTopBtn.Text = "H"
hideTopBtn.TextScaled = true
hideTopBtn.Font = Enum.Font.GothamBold
hideTopBtn.BorderSizePixel = 1
hideTopBtn.BorderColor3 = RED_MAIN
hideTopBtn.Parent = topBar
hideTopBtn.AutoButtonColor = false

local topBarDragging = false
local topBarDragStart, topBarStartPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if input.Position.X >= (topBar.AbsolutePosition.X + topBar.AbsoluteSize.X - 45) then return end
        topBarDragging = true
        topBarDragStart = input.Position
        topBarStartPos = topBar.Position
    end
end)
topBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        topBarDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if topBarDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - topBarDragStart
        topBar.Position = UDim2.new(topBarStartPos.X.Scale, topBarStartPos.X.Offset + delta.X, topBarStartPos.Y.Scale, topBarStartPos.Y.Offset + delta.Y)
    end
end)

local function UpdateHideTopBtn()
    if getgenv().TopBarHidden then
        hideTopBtn.Text = "S"
        topBar.BackgroundTransparency = 1
        topBar.BorderSizePixel = 0
        topBarText.Visible = false
    else
        hideTopBtn.Text = "H"
        topBar.BackgroundTransparency = 0
        topBar.BorderSizePixel = 2
        topBarText.Visible = true
    end
end
UpdateHideTopBtn()

hideTopBtn.MouseButton1Click:Connect(function()
    getgenv().TopBarHidden = not getgenv().TopBarHidden
    if getgenv().TopBarHidden then
        ShowRobloxNotification(_("HideTopBarOn"), 2)
    else
        ShowRobloxNotification(_("HideTopBarOff"), 2)
    end
    UpdateHideTopBtn()
end)

local mainFrame = nil

local dockButton = Instance.new("TextButton")
dockButton.Name = "DockButton"
dockButton.Size = UDim2.new(0, 90, 0, 26)
dockButton.Position = UDim2.new(0.5, -45, 0.05, 42)
dockButton.BackgroundColor3 = RED_BG
dockButton.TextColor3 = RED_MAIN
dockButton.Text = "XyqwHub"
dockButton.TextScaled = true
dockButton.Font = Enum.Font.GothamBold
dockButton.BorderSizePixel = 2
dockButton.BorderColor3 = RED_MAIN
dockButton.Parent = screenGui
dockButton.Visible = false
dockButton.AutoButtonColor = false
dockButton.Active = true
dockButton.ZIndex = 999

local dockDragging = false
local dockDragStart, dockStartPos
local dockDragMoved = false

dockButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dockDragging = true
        dockDragMoved = false
        dockDragStart = input.Position
        dockStartPos = dockButton.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dockDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dockDragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then dockDragMoved = true end
        if dockDragMoved then
            dockButton.Position = UDim2.new(
                dockStartPos.X.Scale, dockStartPos.X.Offset + delta.X,
                dockStartPos.Y.Scale, dockStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if dockDragging and not dockDragMoved then
            if mainFrame then
                mainFrame.Visible = true
                dockButton.Visible = false
            end
        end
        dockDragging = false
    end
end)

mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 340)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
mainFrame.BackgroundColor3 = RED_BG
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = RED_MAIN
mainFrame.ClipsDescendants = false
mainFrame.Active = true
mainFrame.Parent = screenGui

local clickBlocker = Instance.new("TextButton")
clickBlocker.Name = "ClickBlocker"
clickBlocker.Size = UDim2.new(1, 0, 1, 0)
clickBlocker.BackgroundTransparency = 1
clickBlocker.Text = ""
clickBlocker.Active = true
clickBlocker.AutoButtonColor = false
clickBlocker.ZIndex = 0
clickBlocker.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = RED_TITLE
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 70, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "XyqwHub"
titleLabel.TextColor3 = RED_MAIN
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseBtn"
closeButton.BackgroundColor3 = RED_DARK
closeButton.TextColor3 = RED_MAIN
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 1
closeButton.BorderColor3 = RED_MAIN
closeButton.Parent = titleBar
closeButton.AutoButtonColor = false

local langButton = Instance.new("TextButton")
langButton.Name = "LangBtn"
langButton.BackgroundColor3 = RED_DARK
langButton.TextColor3 = RED_MAIN
langButton.Text = getgenv().XyqwLanguage
langButton.TextScaled = true
langButton.Font = Enum.Font.GothamBold
langButton.BorderSizePixel = 1
langButton.BorderColor3 = RED_MAIN
langButton.Parent = titleBar
langButton.AutoButtonColor = false

local serverBtn = Instance.new("TextButton")
serverBtn.Name = "ServerBtn"
serverBtn.BackgroundColor3 = RED_DARK
serverBtn.TextColor3 = RED_MAIN
serverBtn.Text = "S"
serverBtn.TextScaled = true
serverBtn.Font = Enum.Font.GothamBold
serverBtn.BorderSizePixel = 1
serverBtn.BorderColor3 = RED_MAIN
serverBtn.Parent = titleBar
serverBtn.AutoButtonColor = false

local playerBtn = Instance.new("TextButton")
playerBtn.Name = "PlayerBtn"
playerBtn.BackgroundColor3 = RED_DARK
playerBtn.TextColor3 = RED_MAIN
playerBtn.Text = "P"
playerBtn.TextScaled = true
playerBtn.Font = Enum.Font.GothamBold
playerBtn.BorderSizePixel = 1
playerBtn.BorderColor3 = RED_MAIN
playerBtn.Parent = titleBar
playerBtn.AutoButtonColor = false

local customBtn = Instance.new("TextButton")
customBtn.Name = "CustomBtn"
customBtn.BackgroundColor3 = RED_DARK
customBtn.TextColor3 = RED_MAIN
customBtn.Text = "C"
customBtn.TextScaled = true
customBtn.Font = Enum.Font.GothamBold
customBtn.BorderSizePixel = 1
customBtn.BorderColor3 = RED_MAIN
customBtn.Parent = titleBar
customBtn.AutoButtonColor = false

local changelogButton = Instance.new("TextButton")
changelogButton.Name = "ChLogBtn"
changelogButton.BackgroundColor3 = RED_DARK
changelogButton.TextColor3 = RED_MAIN
changelogButton.Text = "CL"
changelogButton.TextScaled = true
changelogButton.Font = Enum.Font.GothamBold
changelogButton.BorderSizePixel = 1
changelogButton.BorderColor3 = RED_MAIN
changelogButton.Parent = titleBar
changelogButton.AutoButtonColor = false

local themeBtn = Instance.new("TextButton")
themeBtn.Name = "ThemeBtn"
themeBtn.BackgroundColor3 = RED_DARK
themeBtn.TextColor3 = RED_MAIN
themeBtn.Text = "Th"
themeBtn.TextScaled = true
themeBtn.Font = Enum.Font.GothamBold
themeBtn.BorderSizePixel = 1
themeBtn.BorderColor3 = RED_MAIN
themeBtn.Parent = titleBar
themeBtn.AutoButtonColor = false

local colorBtn = Instance.new("TextButton")
colorBtn.Name = "ColorBtn"
colorBtn.BackgroundColor3 = RED_DARK
colorBtn.TextColor3 = RED_MAIN
colorBtn.Text = "CC"
colorBtn.TextScaled = true
colorBtn.Font = Enum.Font.GothamBold
colorBtn.BorderSizePixel = 1
colorBtn.BorderColor3 = RED_MAIN
colorBtn.Parent = titleBar
colorBtn.AutoButtonColor = false

local HEADER_BUTTONS = {themeBtn, colorBtn, changelogButton, customBtn, playerBtn, serverBtn, langButton, closeButton}
local HEADER_SHORT_TEXT = {"Th", "CC", "CL", "C", "P", "S", "EN", "X"}
local HEADER_LONG_TEXT  = {"Theme", "Custom Color", "ChangeLog", "Custom", "Players", "Server", "EN/RU", "X"}
local HEADER_SHORT_W = {22, 24, 26, 22, 22, 22, 28, 22}
local HEADER_LONG_W  = {55, 105, 85, 70, 70, 65, 55, 22}

local function UpdateHeaderLayout()
    local w = mainFrame.AbsoluteSize.X
    local useLong = w >= 550
    local titleW = 70
    local buttons = HEADER_BUTTONS
    local count = #buttons
    local gap = 1

    local widths = {}
    local totalW = titleW + 6
    for i = 1, count do
        local bw = useLong and HEADER_LONG_W[i] or HEADER_SHORT_W[i]
        widths[i] = bw
        totalW = totalW + bw + gap
    end

    if totalW > w then
        useLong = false
        totalW = titleW + 6
        for i = 1, count do
            widths[i] = HEADER_SHORT_W[i]
            totalW = totalW + widths[i] + gap
        end
    end

    local xRight = w - 1
    local xIdx = count
    local xW = widths[xIdx]
    buttons[xIdx].Size = UDim2.new(0, xW, 0.8, 0)
    buttons[xIdx].Position = UDim2.new(1, -xW - 1, 0.1, 0)
    xRight = xRight - xW - gap

    for i = count - 1, 1, -1 do
        local bw = widths[i]
        buttons[i].Size = UDim2.new(0, bw, 0.8, 0)
        buttons[i].Position = UDim2.new(1, -(w - xRight) - bw, 0.1, 0)
        xRight = xRight - bw - gap
    end

    for i = 1, count do
        buttons[i].Text = useLong and HEADER_LONG_TEXT[i] or HEADER_SHORT_TEXT[i]
    end
    langButton.Text = getgenv().XyqwLanguage
end

local searchBar = Instance.new("TextBox")
searchBar.Name = "SearchBar"
searchBar.Size = UDim2.new(1, -50, 0, 24)
searchBar.Position = UDim2.new(0, 5, 0, 35)
searchBar.BackgroundColor3 = RED_DARK
searchBar.PlaceholderText = _("Search")
searchBar.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBar.Text = ""
searchBar.TextColor3 = RED_MAIN
searchBar.TextSize = 12
searchBar.Font = Enum.Font.Gotham
searchBar.TextXAlignment = Enum.TextXAlignment.Left
searchBar.ClearTextOnFocus = false
searchBar.BorderSizePixel = 1
searchBar.BorderColor3 = RED_MAIN
searchBar.Parent = mainFrame

local sortBtn = Instance.new("TextButton")
sortBtn.Name = "SortBtn"
sortBtn.Size = UDim2.new(0, 40, 0, 24)
sortBtn.Position = UDim2.new(1, -45, 0, 35)
sortBtn.BackgroundColor3 = RED_DARK
sortBtn.TextColor3 = RED_MAIN
sortBtn.Text = "A-Z"
sortBtn.TextScaled = true
sortBtn.Font = Enum.Font.GothamBold
sortBtn.BorderSizePixel = 1
sortBtn.BorderColor3 = RED_MAIN
sortBtn.Parent = mainFrame
sortBtn.AutoButtonColor = false

local function UpdateSortBtnText()
    local mode = getgenv().XyqwSettings.sortMode
    if mode == "default" then sortBtn.Text = "A-Z"
    elseif mode == "az" then sortBtn.Text = "A-Z"
    elseif mode == "za" then sortBtn.Text = "Z-A"
    elseif mode == "recent" then sortBtn.Text = "Rct"
    end
end
UpdateSortBtnText()

local tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -10, 0, 24)
tabBar.Position = UDim2.new(0, 5, 0, 64)
tabBar.BackgroundTransparency = 1
tabBar.Parent = mainFrame

local TAB_LIST = {"All", "BB", "MM2", "INK", "Misc", "Fav", "Rct"}
local TAB_LONG = {All = "All", BB = "BladeBall", MM2 = "MM2", INK = "INK", Misc = "Misc", Fav = "Favorite", Rct = "Recent"}
local TAB_SHORT = {All = "All", BB = "BB", MM2 = "MM2", INK = "INK", Misc = "Misc", Fav = "Fav", Rct = "Rct"}
local tabButtons = {}
local currentTab = "All"

local function SwitchTab(name)
    currentTab = name
    if getgenv().XyqwTheme == "Rainbow" then
        if getgenv().RefreshButtons then getgenv().RefreshButtons() end
        return
    end
    for n, btn in pairs(tabButtons) do
        if n == name then
            btn.BackgroundColor3 = RED_MAIN
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            btn.BackgroundColor3 = RED_DARK
            btn.TextColor3 = RED_MAIN
        end
        btn.BorderColor3 = RED_MAIN
    end
    if getgenv().RefreshButtons then getgenv().RefreshButtons() end
end

for i, name in ipairs(TAB_LIST) do
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. name
    btn.BackgroundColor3 = RED_DARK
    btn.TextColor3 = RED_MAIN
    btn.Text = TAB_SHORT[name]
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = RED_MAIN
    btn.Parent = tabBar
    btn.AutoButtonColor = false
    tabButtons[name] = btn
    btn.MouseButton1Click:Connect(function() SwitchTab(name) end)
end

local function UpdateTabLayout()
    local w = mainFrame.AbsoluteSize.X
    local useLong = w >= 500
    local count = #TAB_LIST
    local gap = 1
    local totalGap = (count - 1) * gap
    local eachW = (w - 10 - totalGap) / count
    for i, name in ipairs(TAB_LIST) do
        local btn = tabButtons[name]
        btn.Size = UDim2.new(0, eachW, 1, 0)
        btn.Position = UDim2.new(0, (i - 1) * (eachW + gap), 0, 0)
        btn.Text = useLong and TAB_LONG[name] or TAB_SHORT[name]
    end
end

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ScriptScroll"
scrollFrame.Size = UDim2.new(1, -10, 1, -98)
scrollFrame.Position = UDim2.new(0, 5, 0, 93)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = RED_MAIN
scrollFrame.Parent = mainFrame

local buttons = {}
local buttonHeight = 34

local function UpdateScriptButtonLayout()
    local w = mainFrame.AbsoluteSize.X
    local useLong = w >= 500
    for _, entry in ipairs(buttons) do
        entry.AutoBtn.Text = getgenv().XyqwAutoExec[entry.Data.Name] and (useLong and "On" or "✓") or (useLong and "Auto" or "▶")
        entry.HideBtn.Text = useLong and "Hide" or "⊘"
        entry.Star.Text = getgenv().XyqwFavorites[entry.Data.Name] and (useLong and "Fav+" or "★") or (useLong and "Fav" or "☆")
    end
end

local function CreateScriptButton(data)
    local container = Instance.new("Frame")
    container.Name = "Script_" .. data.Name
    container.Size = UDim2.new(1, -10, 0, 32)
    container.Position = UDim2.new(0, 5, 0, 0)
    container.BackgroundColor3 = RED_BG
    container.BorderSizePixel = 2
    container.BorderColor3 = RED_MAIN
    container.Parent = scrollFrame

    local statusDot = Instance.new("Frame")
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.Position = UDim2.new(0, 3, 0.5, -3)
    statusDot.BackgroundColor3 = URL_UNKNOWN
    statusDot.BorderSizePixel = 0
    statusDot.ZIndex = 2
    statusDot.Parent = container

    local btn = Instance.new("TextButton")
    btn.Name = "MainBtn"
    btn.Size = UDim2.new(1, -90, 1, 0)
    btn.Position = UDim2.new(0, 12, 0, 0)
    btn.BackgroundTransparency = 1
    btn.TextColor3 = RED_MAIN
    btn.Text = data.Name
    btn.TextScaled = false
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextTruncate = Enum.TextTruncate.AtEnd
    btn.Parent = container
    btn.AutoButtonColor = false

    local autoBtn = Instance.new("TextButton")
    autoBtn.Name = "AutoBtn"
    autoBtn.Size = UDim2.new(0, 24, 1, 0)
    autoBtn.Position = UDim2.new(1, -76, 0, 0)
    autoBtn.BackgroundColor3 = RED_BG
    autoBtn.TextColor3 = RED_MAIN
    autoBtn.Text = "▶"
    autoBtn.TextScaled = true
    autoBtn.Font = Enum.Font.GothamBold
    autoBtn.BorderSizePixel = 1
    autoBtn.BorderColor3 = RED_MAIN
    autoBtn.Parent = container
    autoBtn.AutoButtonColor = false
    if getgenv().XyqwAutoExec[data.Name] then
        autoBtn.Text = "✓"
        autoBtn.BackgroundColor3 = RED_MAIN
        autoBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    end
    autoBtn.MouseButton1Click:Connect(function()
        if getgenv().XyqwAutoExec[data.Name] then
            getgenv().XyqwAutoExec[data.Name] = nil
            autoBtn.BackgroundColor3 = RED_BG
            autoBtn.TextColor3 = RED_MAIN
            ShowRobloxNotification(data.Name .. " — " .. _("AutoExecOff"), 3)
        else
            getgenv().XyqwAutoExec[data.Name] = true
            autoBtn.BackgroundColor3 = RED_MAIN
            autoBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            ShowRobloxNotification(data.Name .. " — " .. _("AutoExecOn"), 3)
        end
        SaveTable(AUTOEXEC_FILE, getgenv().XyqwAutoExec)
        UpdateScriptButtonLayout()
    end)

    local hideBtn = Instance.new("TextButton")
    hideBtn.Name = "HideBtn"
    hideBtn.Size = UDim2.new(0, 24, 1, 0)
    hideBtn.Position = UDim2.new(1, -51, 0, 0)
    hideBtn.BackgroundColor3 = RED_BG
    hideBtn.TextColor3 = RED_MAIN
    hideBtn.Text = "⊘"
    hideBtn.TextScaled = true
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.BorderSizePixel = 1
    hideBtn.BorderColor3 = RED_MAIN
    hideBtn.Parent = container
    hideBtn.AutoButtonColor = false
    hideBtn.MouseButton1Click:Connect(function()
        getgenv().XyqwBlacklist[data.Name] = true
        SaveTable(BLACKLIST_FILE, getgenv().XyqwBlacklist)
        print("[XyqwHub] BLACKLISTED: " .. data.Name)
        ShowRobloxNotification(data.Name .. " — " .. _("BlacklistAdded"), 4)
        task.wait(0.05)
        if getgenv().RefreshButtons then getgenv().RefreshButtons() end
    end)

    local star = Instance.new("TextButton")
    star.Name = "Star"
    star.Size = UDim2.new(0, 24, 1, 0)
    star.Position = UDim2.new(1, -26, 0, 0)
    star.BackgroundColor3 = RED_BG
    star.TextColor3 = RED_MAIN
    star.Text = "☆"
    star.TextScaled = true
    star.Font = Enum.Font.GothamBold
    star.BorderSizePixel = 1
    star.BorderColor3 = RED_MAIN
    star.Parent = container
    star.AutoButtonColor = false

    if getgenv().XyqwFavorites[data.Name] then star.Text = "★" end

    star.MouseButton1Click:Connect(function()
        if getgenv().XyqwFavorites[data.Name] then
            getgenv().XyqwFavorites[data.Name] = nil
            star.Text = "☆"
        else
            getgenv().XyqwFavorites[data.Name] = true
            star.Text = "★"
        end
        SaveTable(FAV_FILE, getgenv().XyqwFavorites)
        UpdateScriptButtonLayout()
    end)

    btn.MouseEnter:Connect(function() container.BackgroundColor3 = RED_DARK end)
    btn.MouseLeave:Connect(function() container.BackgroundColor3 = RED_BG end)

    local isRunning = false
    local lastRun = 0
    btn.MouseButton1Click:Connect(function()
        if isRunning then return end
        local now = tick()
        if now - lastRun < 1.5 then return end
        lastRun = now
        isRunning = true
        container.BackgroundColor3 = RED_MAIN

        for i, name in ipairs(getgenv().XyqwRecent) do
            if name == data.Name then table.remove(getgenv().XyqwRecent, i) break end
        end
        table.insert(getgenv().XyqwRecent, 1, data.Name)
        while #getgenv().XyqwRecent > 5 do table.remove(getgenv().XyqwRecent) end
        SaveTable(RCT_FILE, getgenv().XyqwRecent)

        if data.URL == "SPECIAL_COPY_DOORS_V2" then
            local scriptText = 'getgenv().SCRIPT_KEY = "KEYLESS"\nloadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/abd3cc54d2dc7de4a091fb19c8f4ea9e15e939e7ecc88b475e6956e8af94ad6f/download"))()'
            pcall(function() setclipboard(scriptText) end)
            ShowRobloxNotification("Doors V2 - copied", 5)
        else
            local success, err = pcall(function()
                loadstring(game:HttpGet(data.URL))()
            end)
            if success then
                ShowRobloxNotification(data.Name .. " - " .. _("ScriptExecuted"), 3)
            else
                ShowRobloxNotification(data.Name .. " - " .. _("Error"), 5)
            end
        end

        task.wait(0.3)
        container.BackgroundColor3 = RED_BG
        isRunning = false
    end)

    table.insert(buttons, {Container = container, Btn = btn, Star = star, AutoBtn = autoBtn, HideBtn = hideBtn, Data = data, StatusDot = statusDot})
end

for _, data in ipairs(SCRIPTS) do CreateScriptButton(data) end

-- ========== SPECIAL BUTTONS ==========
local removeTagsContainer = Instance.new("Frame")
removeTagsContainer.Name = "RemoveTagsContainer"
removeTagsContainer.Size = UDim2.new(1, -10, 0, 32)
removeTagsContainer.Position = UDim2.new(0, 5, 0, 0)
removeTagsContainer.BackgroundColor3 = RED_BG
removeTagsContainer.BorderSizePixel = 2
removeTagsContainer.BorderColor3 = RED_MAIN
removeTagsContainer.Parent = scrollFrame
removeTagsContainer.Visible = false

local removeTagsBtn = Instance.new("TextButton")
removeTagsBtn.Name = "RemoveTagsBtn"
removeTagsBtn.Size = UDim2.new(1, 0, 1, 0)
removeTagsBtn.BackgroundTransparency = 1
removeTagsBtn.Text = _("RemoveTags")
removeTagsBtn.TextColor3 = RED_MAIN
removeTagsBtn.TextScaled = true
removeTagsBtn.Font = Enum.Font.GothamBold
removeTagsBtn.Parent = removeTagsContainer
removeTagsBtn.AutoButtonColor = false

removeTagsBtn.MouseEnter:Connect(function() removeTagsContainer.BackgroundColor3 = RED_DARK end)
removeTagsBtn.MouseLeave:Connect(function() removeTagsContainer.BackgroundColor3 = RED_BG end)
removeTagsBtn.MouseButton1Click:Connect(function()
    RemoveAllTags()
    ShowRobloxNotification(_("TagRemoved"), 3)
end)

local shareFavContainer = Instance.new("Frame")
shareFavContainer.Name = "ShareFavContainer"
shareFavContainer.Size = UDim2.new(1, -10, 0, 32)
shareFavContainer.Position = UDim2.new(0, 5, 0, 0)
shareFavContainer.BackgroundColor3 = RED_BG
shareFavContainer.BorderSizePixel = 2
shareFavContainer.BorderColor3 = RED_MAIN
shareFavContainer.Parent = scrollFrame
shareFavContainer.Visible = false

local shareFavBtn = Instance.new("TextButton")
shareFavBtn.Name = "ShareFavBtn"
shareFavBtn.Size = UDim2.new(1, 0, 1, 0)
shareFavBtn.BackgroundTransparency = 1
shareFavBtn.Text = _("ShareFav")
shareFavBtn.TextColor3 = RED_MAIN
shareFavBtn.TextScaled = true
shareFavBtn.Font = Enum.Font.GothamBold
shareFavBtn.Parent = shareFavContainer
shareFavBtn.AutoButtonColor = false

shareFavBtn.MouseEnter:Connect(function() shareFavContainer.BackgroundColor3 = RED_DARK end)
shareFavBtn.MouseLeave:Connect(function() shareFavContainer.BackgroundColor3 = RED_BG end)
shareFavBtn.MouseButton1Click:Connect(function()
    local list = {}
    for name, _ in pairs(getgenv().XyqwFavorites) do table.insert(list, name) end
    table.sort(list)
    local text = "XyqwHub - My Favorite Scripts:\n"
    if #list == 0 then text = text .. "(empty)" else
        for i, name in ipairs(list) do text = text .. i .. ". " .. name .. "\n" end
    end
    text = text .. "\nGenerated by XyqwHub " .. VERSION
    pcall(function() setclipboard(text) end)
    ShowRobloxNotification(_("FavShared"), 3)
end)

local shareRctContainer = Instance.new("Frame")
shareRctContainer.Name = "ShareRctContainer"
shareRctContainer.Size = UDim2.new(1, -10, 0, 32)
shareRctContainer.Position = UDim2.new(0, 5, 0, 0)
shareRctContainer.BackgroundColor3 = RED_BG
shareRctContainer.BorderSizePixel = 2
shareRctContainer.BorderColor3 = RED_MAIN
shareRctContainer.Parent = scrollFrame
shareRctContainer.Visible = false

local shareRctBtn = Instance.new("TextButton")
shareRctBtn.Name = "ShareRctBtn"
shareRctBtn.Size = UDim2.new(1, 0, 1, 0)
shareRctBtn.BackgroundTransparency = 1
shareRctBtn.Text = _("ShareRct")
shareRctBtn.TextColor3 = RED_MAIN
shareRctBtn.TextScaled = true
shareRctBtn.Font = Enum.Font.GothamBold
shareRctBtn.Parent = shareRctContainer
shareRctBtn.AutoButtonColor = false

shareRctBtn.MouseEnter:Connect(function() shareRctContainer.BackgroundColor3 = RED_DARK end)
shareRctBtn.MouseLeave:Connect(function() shareRctContainer.BackgroundColor3 = RED_BG end)
shareRctBtn.MouseButton1Click:Connect(function()
    local text = "XyqwHub - My Recent Scripts:\n"
    if #getgenv().XyqwRecent == 0 then text = text .. "(empty)" else
        for i, name in ipairs(getgenv().XyqwRecent) do text = text .. i .. ". " .. name .. "\n" end
    end
    text = text .. "\nGenerated by XyqwHub " .. VERSION
    pcall(function() setclipboard(text) end)
    ShowRobloxNotification(_("RctShared"), 3)
end)

local blacklistBtnContainer = Instance.new("Frame")
blacklistBtnContainer.Name = "BlacklistBtnContainer"
blacklistBtnContainer.Size = UDim2.new(1, -10, 0, 32)
blacklistBtnContainer.Position = UDim2.new(0, 5, 0, 0)
blacklistBtnContainer.BackgroundColor3 = RED_BG
blacklistBtnContainer.BorderSizePixel = 2
blacklistBtnContainer.BorderColor3 = RED_MAIN
blacklistBtnContainer.Parent = scrollFrame
blacklistBtnContainer.Visible = false

local blacklistBtn = Instance.new("TextButton")
blacklistBtn.Name = "BlacklistBtn"
blacklistBtn.Size = UDim2.new(1, 0, 1, 0)
blacklistBtn.BackgroundTransparency = 1
blacklistBtn.Text = _("ManageBlacklist")
blacklistBtn.TextColor3 = RED_MAIN
blacklistBtn.TextScaled = true
blacklistBtn.Font = Enum.Font.GothamBold
blacklistBtn.Parent = blacklistBtnContainer
blacklistBtn.AutoButtonColor = false

blacklistBtn.MouseEnter:Connect(function() blacklistBtnContainer.BackgroundColor3 = RED_DARK end)
blacklistBtn.MouseLeave:Connect(function() blacklistBtnContainer.BackgroundColor3 = RED_BG end)

local urlTestContainer = Instance.new("Frame")
urlTestContainer.Name = "UrlTestContainer"
urlTestContainer.Size = UDim2.new(1, -10, 0, 32)
urlTestContainer.Position = UDim2.new(0, 5, 0, 0)
urlTestContainer.BackgroundColor3 = RED_BG
urlTestContainer.BorderSizePixel = 2
urlTestContainer.BorderColor3 = RED_MAIN
urlTestContainer.Parent = scrollFrame
urlTestContainer.Visible = false

local urlTestBtn = Instance.new("TextButton")
urlTestBtn.Name = "UrlTestBtn"
urlTestBtn.Size = UDim2.new(1, 0, 1, 0)
urlTestBtn.BackgroundTransparency = 1
urlTestBtn.Text = _("TestURLs")
urlTestBtn.TextColor3 = RED_MAIN
urlTestBtn.TextScaled = true
urlTestBtn.Font = Enum.Font.GothamBold
urlTestBtn.Parent = urlTestContainer
urlTestBtn.AutoButtonColor = false

urlTestBtn.MouseEnter:Connect(function() urlTestContainer.BackgroundColor3 = RED_DARK end)
urlTestBtn.MouseLeave:Connect(function() urlTestContainer.BackgroundColor3 = RED_BG end)

local settingsContainer = Instance.new("Frame")
settingsContainer.Name = "SettingsContainer"
settingsContainer.Size = UDim2.new(1, -10, 0, 32)
settingsContainer.Position = UDim2.new(0, 5, 0, 0)
settingsContainer.BackgroundColor3 = RED_BG
settingsContainer.BorderSizePixel = 2
settingsContainer.BorderColor3 = RED_MAIN
settingsContainer.Parent = scrollFrame
settingsContainer.Visible = false

local settingsBtn = Instance.new("TextButton")
settingsBtn.Name = "SettingsBtn"
settingsBtn.Size = UDim2.new(1, 0, 1, 0)
settingsBtn.BackgroundTransparency = 1
settingsBtn.Text = _("SettingsBtn")
settingsBtn.TextColor3 = RED_MAIN
settingsBtn.TextScaled = true
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.Parent = settingsContainer
settingsBtn.AutoButtonColor = false

settingsBtn.MouseEnter:Connect(function() settingsContainer.BackgroundColor3 = RED_DARK end)
settingsBtn.MouseLeave:Connect(function() settingsContainer.BackgroundColor3 = RED_BG end)

local destroyContainer = Instance.new("Frame")
destroyContainer.Name = "DestroyContainer"
destroyContainer.Size = UDim2.new(1, -10, 0, 32)
destroyContainer.Position = UDim2.new(0, 5, 0, 0)
destroyContainer.BackgroundColor3 = RED_BG
destroyContainer.BorderSizePixel = 2
destroyContainer.BorderColor3 = RED_MAIN
destroyContainer.Parent = scrollFrame
destroyContainer.Visible = false

local destroyBtnMain = Instance.new("TextButton")
destroyBtnMain.Name = "DestroyBtn"
destroyBtnMain.Size = UDim2.new(1, 0, 1, 0)
destroyBtnMain.BackgroundTransparency = 1
destroyBtnMain.Text = _("Destroy")
destroyBtnMain.TextColor3 = RED_MAIN
destroyBtnMain.TextScaled = true
destroyBtnMain.Font = Enum.Font.GothamBold
destroyBtnMain.Parent = destroyContainer
destroyBtnMain.AutoButtonColor = false

destroyBtnMain.MouseEnter:Connect(function() destroyContainer.BackgroundColor3 = RED_DARK end)
destroyBtnMain.MouseLeave:Connect(function() destroyContainer.BackgroundColor3 = RED_BG end)
destroyBtnMain.MouseButton1Click:Connect(function()
    ShowRobloxNotification("XyqwHub Destroyed!", 2)
    getgenv().XyqwHubRunning = nil
    screenGui:Destroy()
end)

-- ========== BLACKLIST MANAGER (фикс ×) ==========
local function ShowBlacklistManager()
    local frame = Instance.new("Frame")
    frame.Name = "BlacklistFrame"
    frame.Size = UDim2.new(0, 320, 0, 350)
    frame.Position = UDim2.new(0.5, -160, 0.5, -175)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 50
    frame.Active = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("BlacklistTitle")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 51
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 4)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 51
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -40)
    scroll.Position = UDim2.new(0, 5, 0, 32)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = RED_MAIN
    scroll.ZIndex = 51
    scroll.Parent = frame

    -- ФИКС: собираем имена В ОТДЕЛЬНЫЙ СПИСОК перед итерацией
    local blacklistNames = {}
    for name, _ in pairs(getgenv().XyqwBlacklist) do
        table.insert(blacklistNames, name)
    end
    table.sort(blacklistNames)

    local yPos = 5
    if #blacklistNames == 0 then
        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, -10, 0, 40)
        emptyLbl.Position = UDim2.new(0, 5, 0, 20)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
        emptyLbl.Text = _("BlacklistEmpty")
        emptyLbl.TextScaled = true
        emptyLbl.Font = Enum.Font.Gotham
        emptyLbl.ZIndex = 52
        emptyLbl.Parent = scroll
    else
        for _, name in ipairs(blacklistNames) do
            local item = Instance.new("Frame")
            item.Size = UDim2.new(1, -10, 0, 28)
            item.Position = UDim2.new(0, 5, 0, yPos)
            item.BackgroundColor3 = RED_BG
            item.BorderSizePixel = 1
            item.BorderColor3 = RED_MAIN
            item.ZIndex = 51
            item.Parent = scroll

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -40, 1, 0)
            lbl.Position = UDim2.new(0, 5, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = RED_MAIN
            lbl.Text = name
            lbl.TextScaled = true
            lbl.Font = Enum.Font.Gotham
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 52
            lbl.Parent = item

            local removeBtn = Instance.new("TextButton")
            removeBtn.Size = UDim2.new(0, 30, 1, 0)
            removeBtn.Position = UDim2.new(1, -30, 0, 0)
            removeBtn.BackgroundColor3 = RED_DARK
            removeBtn.TextColor3 = RED_MAIN
            removeBtn.Text = "×"
            removeBtn.TextScaled = true
            removeBtn.Font = Enum.Font.GothamBold
            removeBtn.BorderSizePixel = 0
            removeBtn.ZIndex = 52
            removeBtn.Parent = item
            removeBtn.AutoButtonColor = false
            removeBtn.MouseButton1Click:Connect(function()
                -- Удаляем из blacklist
                getgenv().XyqwBlacklist[name] = nil
                SaveTable(BLACKLIST_FILE, getgenv().XyqwBlacklist)
                print("[XyqwHub] UNBLACKLISTED: " .. name)
                ShowRobloxNotification(name .. " — " .. _("BlacklistRemoved"), 4)
                -- Мгновенно обновляем главный список
                if getgenv().RefreshButtons then getgenv().RefreshButtons() end
                -- Закрываем окно, пересоздаём с обновлёнными данными
                task.wait(0.1)
                frame:Destroy()
                ShowBlacklistManager()
            end)

            yPos = yPos + 30
        end
    end

    scroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)

    closeBtn.MouseButton1Click:Connect(function()
        frame:Destroy()
        task.wait(0.05)
        if getgenv().RefreshButtons then getgenv().RefreshButtons() end
    end)
end
blacklistBtn.MouseButton1Click:Connect(ShowBlacklistManager)

local function ShowSettings()
    local frame = Instance.new("Frame")
    frame.Name = "SettingsFrame"
    frame.Size = UDim2.new(0, 300, 0, 180)
    frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 50
    frame.Active = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 24)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("SettingsTitle")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 51
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 24)
    closeBtn.Position = UDim2.new(1, -30, 0, 4)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 51
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false

    local bindLbl = Instance.new("TextLabel")
    bindLbl.Size = UDim2.new(1, -20, 0, 20)
    bindLbl.Position = UDim2.new(0, 10, 0, 40)
    bindLbl.BackgroundTransparency = 1
    bindLbl.TextColor3 = RED_MAIN
    bindLbl.Text = _("AutoHideBind")
    bindLbl.TextScaled = true
    bindLbl.Font = Enum.Font.GothamBold
    bindLbl.TextXAlignment = Enum.TextXAlignment.Left
    bindLbl.ZIndex = 51
    bindLbl.Parent = frame

    local bindBtn = Instance.new("TextButton")
    bindBtn.Size = UDim2.new(1, -20, 0, 30)
    bindBtn.Position = UDim2.new(0, 10, 0, 64)
    bindBtn.BackgroundColor3 = RED_DARK
    bindBtn.TextColor3 = RED_MAIN
    bindBtn.Text = getgenv().XyqwSettings.autoHideBind .. " — click to change"
    bindBtn.TextScaled = true
    bindBtn.Font = Enum.Font.GothamBold
    bindBtn.BorderSizePixel = 1
    bindBtn.BorderColor3 = RED_MAIN
    bindBtn.ZIndex = 51
    bindBtn.Parent = frame
    bindBtn.AutoButtonColor = false

    local waiting = false
    bindBtn.MouseButton1Click:Connect(function()
        if waiting then return end
        waiting = true
        bindBtn.Text = "Press any key..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = input.KeyCode.Name
                getgenv().XyqwSettings.autoHideBind = keyName
                SaveTable(SETTINGS_FILE, getgenv().XyqwSettings)
                bindBtn.Text = keyName .. " — click to change"
                ShowRobloxNotification(_("KeybindChanged") .. keyName, 2)
                waiting = false
                conn:Disconnect()
            end
        end)
    end)

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
end
settingsBtn.MouseButton1Click:Connect(ShowSettings)

urlTestBtn.MouseButton1Click:Connect(function()
    ShowRobloxNotification(_("UrlCheckStarted"), 2)
    task.spawn(function()
        for _, entry in ipairs(buttons) do
            local data = entry.Data
            if data.URL ~= "SPECIAL_COPY_DOORS_V2" then
                entry.StatusDot.BackgroundColor3 = URL_CHECKING
                local ok = pcall(function()
                    local res = game:HttpGet(data.URL)
                    if res and #res > 0 then return true end
                    return false
                end)
                if ok then
                    entry.StatusDot.BackgroundColor3 = URL_OK
                    getgenv().XyqwSettings.urlStatus[data.Name] = "ok"
                else
                    entry.StatusDot.BackgroundColor3 = URL_BAD
                    getgenv().XyqwSettings.urlStatus[data.Name] = "bad"
                end
                task.wait(0.3)
            end
        end
        SaveTable(SETTINGS_FILE, getgenv().XyqwSettings)
        ShowRobloxNotification(_("UrlCheckDone"), 3)
    end)
end)

sortBtn.MouseButton1Click:Connect(function()
    local modes = {"default", "az", "za", "recent"}
    local idx = 1
    for i, m in ipairs(modes) do
        if m == getgenv().XyqwSettings.sortMode then idx = i break end
    end
    idx = idx + 1
    if idx > #modes then idx = 1 end
    getgenv().XyqwSettings.sortMode = modes[idx]
    SaveTable(SETTINGS_FILE, getgenv().XyqwSettings)
    UpdateSortBtnText()
    if getgenv().RefreshButtons then getgenv().RefreshButtons() end
end)

-- ========== REFRESH ==========
getgenv().RefreshButtons = function()
    local search = string.lower(searchBar.Text)
    local sortMode = getgenv().XyqwSettings.sortMode

    local visibleEntries = {}
    for _, entry in ipairs(buttons) do
        local show = true
        if getgenv().XyqwBlacklist[entry.Data.Name] then show = false end
        if show then
            if currentTab == "Fav" then
                if not getgenv().XyqwFavorites[entry.Data.Name] then show = false end
            elseif currentTab == "Rct" then
                local found = false
                for _, n in ipairs(getgenv().XyqwRecent) do
                    if n == entry.Data.Name then found = true break end
                end
                if not found then show = false end
            elseif currentTab ~= "All" then
                if entry.Data.Category ~= currentTab then show = false end
            end
        end
        if show and search ~= "" and not string.find(string.lower(entry.Data.Name), search, 1, true) then
            show = false
        end
        if show then table.insert(visibleEntries, entry) end
        entry.Container.Visible = show
    end

    if sortMode == "az" then
        table.sort(visibleEntries, function(a, b) return a.Data.Name < b.Data.Name end)
    elseif sortMode == "za" then
        table.sort(visibleEntries, function(a, b) return a.Data.Name > b.Data.Name end)
    elseif sortMode == "recent" then
        table.sort(visibleEntries, function(a, b)
            local aIdx, bIdx = 999, 999
            for i, n in ipairs(getgenv().XyqwRecent) do
                if n == a.Data.Name then aIdx = i end
                if n == b.Data.Name then bIdx = i end
            end
            return aIdx < bIdx
        end)
    end

    local visible = 0
    for _, entry in ipairs(visibleEntries) do
        entry.Container.Position = UDim2.new(0, 5, 0, visible * buttonHeight + 5)
        visible = visible + 1
    end

    local showAll = (currentTab == "All" and search == "")
    local showFav = (currentTab == "Fav")
    local showRct = (currentTab == "Rct")

    removeTagsContainer.Visible = showAll
    blacklistBtnContainer.Visible = showAll
    urlTestContainer.Visible = showAll
    settingsContainer.Visible = showAll
    destroyContainer.Visible = showAll
    shareFavContainer.Visible = showFav
    shareRctContainer.Visible = showRct

    local specialY = visible * buttonHeight + 5
    if showAll then
        removeTagsContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        blacklistBtnContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        urlTestContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        settingsContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        destroyContainer.Position = UDim2.new(0, 5, 0, specialY) specialY = specialY + buttonHeight
        visible = visible + 5
    end
    if showFav then
        shareFavContainer.Position = UDim2.new(0, 5, 0, specialY)
        visible = visible + 1
    end
    if showRct then
        shareRctContainer.Position = UDim2.new(0, 5, 0, specialY)
        visible = visible + 1
    end

    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, visible * buttonHeight + 20)
end

getgenv().RefreshButtons()
searchBar:GetPropertyChangedSignal("Text"):Connect(function()
    if getgenv().RefreshButtons then getgenv().RefreshButtons() end
end)

local function ShowChangeLog()
    local frame = Instance.new("Frame")
    frame.Name = "ChangeLogFrame"
    frame.Size = UDim2.new(0, 350, 0, 350)
    frame.Position = UDim2.new(0.5, -175, 0.5, -175)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 50
    frame.Active = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("ChangeLogTitle")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 51
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 51
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 3000)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = RED_MAIN
    scroll.ZIndex = 51
    scroll.Parent = frame

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -10, 0, 2990)
    text.Position = UDim2.new(0, 5, 0, 5)
    text.BackgroundTransparency = 1
    text.TextColor3 = RED_MAIN
    text.TextWrapped = true
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.TextYAlignment = Enum.TextYAlignment.Top
    text.TextSize = 12
    text.Font = Enum.Font.Gotham
    text.Text = _("ChangeLogText")
    text.ZIndex = 51
    text.Parent = scroll

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
end

changelogButton.MouseButton1Click:Connect(ShowChangeLog)

langButton.MouseButton1Click:Connect(function()
    local langs = {"EN", "RU", "UK", "BE", "KK"}
    local idx = 1
    for i, l in ipairs(langs) do
        if l == getgenv().XyqwLanguage then idx = i break end
    end
    idx = idx + 1
    if idx > #langs then idx = 1 end
    getgenv().XyqwLanguage = langs[idx]
    langButton.Text = getgenv().XyqwLanguage
    searchBar.PlaceholderText = _("Search")
    removeTagsBtn.Text = _("RemoveTags")
    shareFavBtn.Text = _("ShareFav")
    shareRctBtn.Text = _("ShareRct")
    blacklistBtn.Text = _("ManageBlacklist")
    urlTestBtn.Text = _("TestURLs")
    settingsBtn.Text = _("SettingsBtn")
    destroyBtnMain.Text = _("Destroy")
    ShowRobloxNotification(_("LangChanged"), 3)
    UpdateHeaderLayout()
end)

local function ShowPlayerList()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 400)
    frame.Position = UDim2.new(0.5, -175, 0.5, -200)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 50
    frame.Active = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("PlayersTitle") .. " (" .. #Players:GetPlayers() .. ")"
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 51
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 51
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -45)
    scroll.Position = UDim2.new(0, 5, 0, 35)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 25 + 10)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = RED_MAIN
    scroll.ZIndex = 51
    scroll.Parent = frame

    local yPos = 5
    for _, plr in ipairs(Players:GetPlayers()) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 22)
        label.Position = UDim2.new(0, 5, 0, yPos)
        label.BackgroundColor3 = RED_DARK
        label.TextColor3 = RED_MAIN
        label.Text = plr.Name .. " | ID: " .. plr.UserId
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.BorderSizePixel = 1
        label.BorderColor3 = RED_MAIN
        label.ZIndex = 51
        label.Parent = scroll
        yPos = yPos + 25
    end

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
end

local function ShowServerInfo()
    local frame = Instance.new("Frame")
    frame.Name = "ServerInfoFrame"
    frame.Size = UDim2.new(0, 350, 0, 320)
    frame.Position = UDim2.new(0.5, -175, 0.5, -160)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 50
    frame.Active = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("ServerTitle")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 51
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 51
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 110)
    info.Position = UDim2.new(0, 10, 0, 40)
    info.BackgroundTransparency = 1
    info.TextColor3 = RED_MAIN
    info.TextWrapped = true
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.TextSize = 13
    info.Font = Enum.Font.Gotham
    info.Text = _("PlaceId") .. ": " .. game.PlaceId .. "\n" ..
                 _("JobId") .. ": " .. game.JobId .. "\n" ..
                 _("Players") .. ": " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers .. "\n" ..
                 _("Creator") .. ": " .. game.CreatorId
    info.ZIndex = 51
    info.Parent = frame

    local function GetServers()
        local servers = {}
        local ok, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if ok and result and result.data then
            for _, srv in ipairs(result.data) do
                if srv.playing and srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    table.insert(servers, srv)
                end
            end
        end
        return servers
    end

    local function Rejoin()
        ShowRobloxNotification("Rejoining...", 2)
        task.wait(0.5)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer) end)
    end

    local function ServerHop()
        ShowRobloxNotification("Searching for server...", 3)
        local servers = GetServers()
        if #servers == 0 then ShowRobloxNotification("No servers found!", 3) return end
        local target = servers[math.random(1, #servers)]
        ShowRobloxNotification("Hopping...", 2)
        task.wait(0.5)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, target.id, Players.LocalPlayer) end)
    end

    local function TPToSmallServer()
        ShowRobloxNotification("Searching for small server...", 3)
        local servers = GetServers()
        if #servers == 0 then ShowRobloxNotification("No servers found!", 3) return end
        local best = servers[1]
        for _, srv in ipairs(servers) do
            if srv.playing < best.playing then best = srv end
        end
        ShowRobloxNotification("Teleporting to " .. best.playing .. " player server...", 3)
        task.wait(0.5)
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, Players.LocalPlayer) end)
    end

    local rejoinBtn = Instance.new("TextButton")
    rejoinBtn.Size = UDim2.new(1, -20, 0, 30)
    rejoinBtn.Position = UDim2.new(0, 10, 0, 158)
    rejoinBtn.BackgroundColor3 = RED_DARK
    rejoinBtn.TextColor3 = RED_MAIN
    rejoinBtn.Text = _("Rejoin")
    rejoinBtn.TextScaled = true
    rejoinBtn.Font = Enum.Font.GothamBold
    rejoinBtn.BorderSizePixel = 1
    rejoinBtn.BorderColor3 = RED_MAIN
    rejoinBtn.ZIndex = 51
    rejoinBtn.Parent = frame
    rejoinBtn.AutoButtonColor = false
    rejoinBtn.MouseButton1Click:Connect(Rejoin)

    local hopBtn = Instance.new("TextButton")
    hopBtn.Size = UDim2.new(0.5, -13, 0, 30)
    hopBtn.Position = UDim2.new(0, 10, 0, 194)
    hopBtn.BackgroundColor3 = RED_DARK
    hopBtn.TextColor3 = RED_MAIN
    hopBtn.Text = _("ServerHop")
    hopBtn.TextScaled = true
    hopBtn.Font = Enum.Font.GothamBold
    hopBtn.BorderSizePixel = 1
    hopBtn.BorderColor3 = RED_MAIN
    hopBtn.ZIndex = 51
    hopBtn.Parent = frame
    hopBtn.AutoButtonColor = false
    hopBtn.MouseButton1Click:Connect(ServerHop)

    local smallBtn = Instance.new("TextButton")
    smallBtn.Size = UDim2.new(0.5, -13, 0, 30)
    smallBtn.Position = UDim2.new(0.5, 3, 0, 194)
    smallBtn.BackgroundColor3 = RED_DARK
    smallBtn.TextColor3 = RED_MAIN
    smallBtn.Text = _("TPToSmall")
    smallBtn.TextScaled = true
    smallBtn.Font = Enum.Font.GothamBold
    smallBtn.BorderSizePixel = 1
    smallBtn.BorderColor3 = RED_MAIN
    smallBtn.ZIndex = 51
    smallBtn.Parent = frame
    smallBtn.AutoButtonColor = false
    smallBtn.MouseButton1Click:Connect(TPToSmallServer)

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(1, -20, 0, 30)
    copyBtn.Position = UDim2.new(0, 10, 0, 232)
    copyBtn.BackgroundColor3 = RED_MAIN
    copyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    copyBtn.Text = _("CopyJobId")
    copyBtn.TextScaled = true
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.BorderSizePixel = 0
    copyBtn.ZIndex = 51
    copyBtn.Parent = frame
    copyBtn.AutoButtonColor = false

    copyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(game.JobId) end)
        ShowRobloxNotification(_("JobIdCopied"), 2)
    end)

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
end

local function ShowCustomScript()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 175)
    frame.Position = UDim2.new(0.5, -175, 0.5, -87)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 50
    frame.Active = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 28)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("CustomTitle")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 51
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 28)
    closeBtn.Position = UDim2.new(1, -35, 0, 2)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 51
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 36)
    input.Position = UDim2.new(0, 10, 0, 40)
    input.BackgroundColor3 = RED_DARK
    input.TextColor3 = RED_MAIN
    input.PlaceholderText = _("CustomPlaceholder")
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.Text = ""
    input.TextSize = 12
    input.Font = Enum.Font.Gotham
    input.BorderSizePixel = 1
    input.BorderColor3 = RED_MAIN
    input.ZIndex = 51
    input.Parent = frame

    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(1, -20, 0, 36)
    runBtn.Position = UDim2.new(0, 10, 0, 100)
    runBtn.BackgroundColor3 = RED_MAIN
    runBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    runBtn.Text = _("RunCustom")
    runBtn.TextScaled = true
    runBtn.Font = Enum.Font.GothamBold
    runBtn.BorderSizePixel = 0
    runBtn.ZIndex = 51
    runBtn.Parent = frame
    runBtn.AutoButtonColor = false

    local function ExtractURL(text)
        if not text or text == "" then return nil end
        text = text:gsub("^%s+", ""):gsub("%s+$", "")
        local url = text:match('game:HttpGet%s*%(%s*["\']([^"\']+)["\']')
        if url then return url end
        if text:match("^https?://") then return text end
        local quoted = text:match('^["\'](https?://[^"\']+)["\']$')
        if quoted then return quoted end
        return nil
    end

    runBtn.MouseButton1Click:Connect(function()
        local url = ExtractURL(input.Text)
        if not url then ShowRobloxNotification("Invalid URL!", 3) return end
        local success, err = pcall(function() loadstring(game:HttpGet(url))() end)
        if success then
            ShowRobloxNotification("Custom - " .. _("ScriptExecuted"), 3)
        else
            ShowRobloxNotification("Custom - " .. _("Error"), 5)
        end
    end)

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
end

local function ShowCustomColor()
    local frame = Instance.new("Frame")
    frame.Name = "CustomColorFrame"
    frame.Size = UDim2.new(0, 280, 0, 380)
    frame.Position = UDim2.new(0.5, -140, 0.5, -190)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 50
    frame.Active = true
    frame.ClipsDescendants = true
    frame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 22)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("CustomColorTitle")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 51
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 22)
    closeBtn.Position = UDim2.new(1, -28, 0, 4)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 51
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false

    local preview = Instance.new("Frame")
    preview.Size = UDim2.new(1, -20, 0, 36)
    preview.Position = UDim2.new(0, 10, 0, 32)
    preview.BackgroundColor3 = Color3.fromRGB(getgenv().XyqwCustomColor.r, getgenv().XyqwCustomColor.g, getgenv().XyqwCustomColor.b)
    preview.BorderSizePixel = 2
    preview.BorderColor3 = RED_MAIN
    preview.ZIndex = 51
    preview.Parent = frame

    local tempColor = {
        r = getgenv().XyqwCustomColor.r,
        g = getgenv().XyqwCustomColor.g,
        b = getgenv().XyqwCustomColor.b,
    }

    local hexInput, setSliders
    local function UpdateAll()
        preview.BackgroundColor3 = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b)
        if hexInput then
            hexInput.Text = string.format("#%02X%02X%02X", tempColor.r, tempColor.g, tempColor.b)
        end
    end

    local function MakeSlider(label, yPos, channel)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 20, 0, 18)
        lbl.Position = UDim2.new(0, 10, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = RED_MAIN
        lbl.Text = label
        lbl.TextScaled = true
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 51
        lbl.Parent = frame

        local valLbl = Instance.new("TextLabel")
        valLbl.Size = UDim2.new(0, 40, 0, 18)
        valLbl.Position = UDim2.new(1, -50, 0, yPos)
        valLbl.BackgroundTransparency = 1
        valLbl.TextColor3 = RED_MAIN
        valLbl.Text = tostring(tempColor[channel])
        valLbl.TextScaled = true
        valLbl.Font = Enum.Font.Gotham
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.ZIndex = 51
        valLbl.Parent = frame

        local slider = Instance.new("Frame")
        slider.Size = UDim2.new(1, -100, 0, 12)
        slider.Position = UDim2.new(0, 35, 0, yPos + 3)
        slider.BackgroundColor3 = RED_DARK
        slider.BorderSizePixel = 1
        slider.BorderColor3 = RED_MAIN
        slider.ZIndex = 51
        slider.Parent = frame

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new(tempColor[channel] / 255, 0, 1, 0)
        fill.BackgroundColor3 = RED_MAIN
        fill.BorderSizePixel = 0
        fill.ZIndex = 52
        fill.Parent = slider

        local drag = false
        local function UpdateFromX(mouseX)
            local rel = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local v = math.floor(rel * 255)
            tempColor[channel] = v
            fill.Size = UDim2.new(rel, 0, 1, 0)
            valLbl.Text = tostring(v)
            UpdateAll()
        end

        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = true
                UpdateFromX(input.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateFromX(input.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = false
            end
        end)

        return function(v)
            tempColor[channel] = v
            fill.Size = UDim2.new(v / 255, 0, 1, 0)
            valLbl.Text = tostring(v)
        end
    end

    setSliders = {
        R = MakeSlider("R", 76, "r"),
        G = MakeSlider("G", 100, "g"),
        B = MakeSlider("B", 124, "b"),
    }

    local hexLbl = Instance.new("TextLabel")
    hexLbl.Size = UDim2.new(0, 40, 0, 18)
    hexLbl.Position = UDim2.new(0, 10, 0, 150)
    hexLbl.BackgroundTransparency = 1
    hexLbl.TextColor3 = RED_MAIN
    hexLbl.Text = "HEX:"
    hexLbl.TextScaled = true
    hexLbl.Font = Enum.Font.GothamBold
    hexLbl.TextXAlignment = Enum.TextXAlignment.Left
    hexLbl.ZIndex = 51
    hexLbl.Parent = frame

    hexInput = Instance.new("TextBox")
    hexInput.Size = UDim2.new(1, -60, 0, 22)
    hexInput.Position = UDim2.new(0, 50, 0, 148)
    hexInput.BackgroundColor3 = RED_DARK
    hexInput.TextColor3 = RED_MAIN
    hexInput.PlaceholderText = "#FF0000"
    hexInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    hexInput.Text = string.format("#%02X%02X%02X", tempColor.r, tempColor.g, tempColor.b)
    hexInput.TextSize = 12
    hexInput.Font = Enum.Font.Gotham
    hexInput.ClearTextOnFocus = false
    hexInput.BorderSizePixel = 1
    hexInput.BorderColor3 = RED_MAIN
    hexInput.ZIndex = 51
    hexInput.Parent = frame

    local function ParseColor(text)
        if not text then return nil end
        text = text:gsub("^%s+", ""):gsub("%s+$", "")
        local r, g, b = text:match("^[Rr][Gg][Bb]%s*%(%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%)$")
        if r and g and b then
            return math.clamp(tonumber(r), 0, 255), math.clamp(tonumber(g), 0, 255), math.clamp(tonumber(b), 0, 255)
        end
        local hex = text:gsub("#", ""):gsub("%s", "")
        if #hex == 6 then
            local hr = tonumber(hex:sub(1, 2), 16)
            local hg = tonumber(hex:sub(3, 4), 16)
            local hb = tonumber(hex:sub(5, 6), 16)
            if hr and hg and hb then return hr, hg, hb end
        end
        return nil
    end

    hexInput.FocusLost:Connect(function()
        local r, g, b = ParseColor(hexInput.Text)
        if r and g and b then
            tempColor.r = r
            tempColor.g = g
            tempColor.b = b
            if setSliders then
                setSliders.R(r)
                setSliders.G(g)
                setSliders.B(b)
            end
        end
        UpdateAll()
    end)

    local presetLbl = Instance.new("TextLabel")
    presetLbl.Size = UDim2.new(1, -20, 0, 14)
    presetLbl.Position = UDim2.new(0, 10, 0, 178)
    presetLbl.BackgroundTransparency = 1
    presetLbl.TextColor3 = RED_MAIN
    presetLbl.Text = _("Presets") .. ":"
    presetLbl.TextScaled = true
    presetLbl.Font = Enum.Font.GothamBold
    presetLbl.TextXAlignment = Enum.TextXAlignment.Left
    presetLbl.ZIndex = 51
    presetLbl.Parent = frame

    local presets = {
        {name = "Cyan", r = 0, g = 255, b = 255},
        {name = "Pink", r = 255, g = 20, b = 147},
        {name = "Orange", r = 255, g = 140, b = 0},
        {name = "Lime", r = 50, g = 255, b = 50},
        {name = "Gold", r = 255, g = 215, b = 0},
        {name = "White", r = 255, g = 255, b = 255},
    }

    local presetY = 196
    local presetW = 80
    for i, preset in ipairs(presets) do
        local col = (i - 1) % 2
        local row = math.floor((i - 1) / 2)
        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.new(0, presetW, 0, 22)
        pBtn.Position = UDim2.new(0, 10 + col * (presetW + 5), 0, presetY + row * 26)
        pBtn.BackgroundColor3 = Color3.fromRGB(preset.r, preset.g, preset.b)
        pBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        pBtn.Text = preset.name
        pBtn.TextScaled = true
        pBtn.Font = Enum.Font.GothamBold
        pBtn.BorderSizePixel = 1
        pBtn.BorderColor3 = RED_MAIN
        pBtn.ZIndex = 51
        pBtn.Parent = frame
        pBtn.AutoButtonColor = false
        pBtn.MouseButton1Click:Connect(function()
            tempColor.r = preset.r
            tempColor.g = preset.g
            tempColor.b = preset.b
            if setSliders then
                setSliders.R(preset.r)
                setSliders.G(preset.g)
                setSliders.B(preset.b)
            end
            UpdateAll()
        end)
    end

    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0.5, -13, 0, 24)
    resetBtn.Position = UDim2.new(0, 10, 0, 278)
    resetBtn.BackgroundColor3 = RED_DARK
    resetBtn.TextColor3 = RED_MAIN
    resetBtn.Text = _("Reset")
    resetBtn.TextScaled = true
    resetBtn.Font = Enum.Font.GothamBold
    resetBtn.BorderSizePixel = 1
    resetBtn.BorderColor3 = RED_MAIN
    resetBtn.ZIndex = 51
    resetBtn.Parent = frame
    resetBtn.AutoButtonColor = false
    resetBtn.MouseButton1Click:Connect(function()
        tempColor.r = 255
        tempColor.g = 0
        tempColor.b = 0
        if setSliders then
            setSliders.R(255)
            setSliders.G(0)
            setSliders.B(0)
        end
        UpdateAll()
        ShowRobloxNotification(_("ColorReset"), 3)
    end)

    local shareColorBtn = Instance.new("TextButton")
    shareColorBtn.Size = UDim2.new(0.5, -13, 0, 24)
    shareColorBtn.Position = UDim2.new(0.5, 3, 0, 278)
    shareColorBtn.BackgroundColor3 = RED_DARK
    shareColorBtn.TextColor3 = RED_MAIN
    shareColorBtn.Text = _("ShareColor")
    shareColorBtn.TextScaled = true
    shareColorBtn.Font = Enum.Font.GothamBold
    shareColorBtn.BorderSizePixel = 1
    shareColorBtn.BorderColor3 = RED_MAIN
    shareColorBtn.ZIndex = 51
    shareColorBtn.Parent = frame
    shareColorBtn.AutoButtonColor = false
    shareColorBtn.MouseButton1Click:Connect(function()
        local hex = string.format("#%02X%02X%02X", tempColor.r, tempColor.g, tempColor.b)
        local text = "XyqwHub - My Custom Color: " .. hex
        pcall(function() setclipboard(text) end)
        ShowRobloxNotification(_("ColorShared"), 3)
    end)

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(1, -20, 0, 28)
    applyBtn.Position = UDim2.new(0, 10, 0, 308)
    applyBtn.BackgroundColor3 = RED_MAIN
    applyBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    applyBtn.Text = _("Apply")
    applyBtn.TextScaled = true
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.BorderSizePixel = 0
    applyBtn.ZIndex = 51
    applyBtn.Parent = frame
    applyBtn.AutoButtonColor = false

    applyBtn.MouseButton1Click:Connect(function()
        getgenv().XyqwCustomColor = {
            r = tempColor.r, g = tempColor.g, b = tempColor.b,
            dr = math.floor(tempColor.r * 0.15),
            dg = math.floor(tempColor.g * 0.15),
            db = math.floor(tempColor.b * 0.15),
        }
        SaveTable(CUSTOM_COLOR_FILE, getgenv().XyqwCustomColor)
        THEMES.Custom.MAIN = Color3.fromRGB(tempColor.r, tempColor.g, tempColor.b)
        THEMES.Custom.DARK = Color3.fromRGB(math.floor(tempColor.r * 0.15), math.floor(tempColor.g * 0.15), math.floor(tempColor.b * 0.15))
        THEMES.Custom.BG = Color3.fromRGB(0, 0, 0)
        THEMES.Custom.TITLE = Color3.fromRGB(math.floor(tempColor.r * 0.08), math.floor(tempColor.g * 0.08), math.floor(tempColor.b * 0.08))
        if getgenv().XyqwApplyTheme then
            getgenv().XyqwApplyTheme("Custom")
        end
        ShowRobloxNotification("Custom Color applied!", 3)
        frame:Destroy()
    end)

    local colorResizeHandle = Instance.new("TextButton")
    colorResizeHandle.Name = "ColorResizeHandle"
    colorResizeHandle.Size = UDim2.new(0, 14, 0, 14)
    colorResizeHandle.Position = UDim2.new(1, -14, 1, -14)
    colorResizeHandle.BackgroundColor3 = RED_MAIN
    colorResizeHandle.Text = ""
    colorResizeHandle.BorderSizePixel = 0
    colorResizeHandle.ZIndex = 52
    colorResizeHandle.Parent = frame
    colorResizeHandle.AutoButtonColor = false

    local cResize = false
    local cStart, cStartSize
    colorResizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            cResize = true
            cStart = input.Position
            cStartSize = frame.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if cResize and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - cStart
            local newX = math.clamp(cStartSize.X.Offset + delta.X, 240, 500)
            local newY = math.clamp(cStartSize.Y.Offset + delta.Y, 340, 600)
            frame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            cResize = false
        end
    end)

    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)
end

customBtn.MouseButton1Click:Connect(ShowCustomScript)
playerBtn.MouseButton1Click:Connect(ShowPlayerList)
serverBtn.MouseButton1Click:Connect(ShowServerInfo)
colorBtn.MouseButton1Click:Connect(ShowCustomColor)

local themeOrder = {"Red", "Blue", "Green", "Purple", "Pink", "Orange", "Cyan", "Yellow", "Lime", "Magenta", "White", "Rainbow", "Custom"}
local themeIndex = 1
for i, name in ipairs(themeOrder) do
    if name == getgenv().XyqwTheme then themeIndex = i break end
end

local function ApplyTheme(themeName)
    getgenv().XyqwTheme = themeName
    if themeName == "Custom" then
        local cc = getgenv().XyqwCustomColor
        THEMES.Custom.MAIN = Color3.fromRGB(cc.r, cc.g, cc.b)
        THEMES.Custom.DARK = Color3.fromRGB(cc.dr, cc.dg, cc.db)
        THEMES.Custom.BG = Color3.fromRGB(0, 0, 0)
        THEMES.Custom.TITLE = Color3.fromRGB(math.floor(cc.r * 0.08), math.floor(cc.g * 0.08), math.floor(cc.b * 0.08))
    end
    local t = THEMES[themeName]
    RED_MAIN = t.MAIN RED_DARK = t.DARK RED_BG = t.BG RED_TITLE = t.TITLE

    mainFrame.BackgroundColor3 = RED_BG
    mainFrame.BorderColor3 = RED_MAIN
    titleBar.BackgroundColor3 = RED_TITLE
    titleLabel.TextColor3 = RED_MAIN

    for _, btn in ipairs({closeButton, langButton, playerBtn, serverBtn, customBtn, changelogButton, themeBtn, colorBtn, sortBtn}) do
        btn.BackgroundColor3 = RED_DARK
        btn.TextColor3 = RED_MAIN
        btn.BorderColor3 = RED_MAIN
    end

    searchBar.BackgroundColor3 = RED_DARK
    searchBar.TextColor3 = RED_MAIN
    searchBar.BorderColor3 = RED_MAIN
    scrollFrame.ScrollBarImageColor3 = RED_MAIN

    for n, btn in pairs(tabButtons) do
        if n == currentTab then
            btn.BackgroundColor3 = RED_MAIN
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            btn.BackgroundColor3 = RED_DARK
            btn.TextColor3 = RED_MAIN
        end
        btn.BorderColor3 = RED_MAIN
    end

    for _, entry in ipairs(buttons) do
        entry.Container.BackgroundColor3 = RED_BG
        entry.Container.BorderColor3 = RED_MAIN
        entry.Btn.TextColor3 = RED_MAIN
        entry.Star.BackgroundColor3 = RED_BG
        entry.Star.TextColor3 = RED_MAIN
        entry.Star.BorderColor3 = RED_MAIN
        entry.AutoBtn.BorderColor3 = RED_MAIN
        entry.HideBtn.BorderColor3 = RED_MAIN
        if getgenv().XyqwAutoExec[entry.Data.Name] then
            entry.AutoBtn.BackgroundColor3 = RED_MAIN
            entry.AutoBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        else
            entry.AutoBtn.BackgroundColor3 = RED_BG
            entry.AutoBtn.TextColor3 = RED_MAIN
        end
        entry.HideBtn.BackgroundColor3 = RED_BG
        entry.HideBtn.TextColor3 = RED_MAIN
    end

    removeTagsContainer.BackgroundColor3 = RED_BG
    removeTagsContainer.BorderColor3 = RED_MAIN
    shareFavContainer.BackgroundColor3 = RED_BG
    shareFavContainer.BorderColor3 = RED_MAIN
    shareRctContainer.BackgroundColor3 = RED_BG
    shareRctContainer.BorderColor3 = RED_MAIN
    blacklistBtnContainer.BackgroundColor3 = RED_BG
    blacklistBtnContainer.BorderColor3 = RED_MAIN
    urlTestContainer.BackgroundColor3 = RED_BG
    urlTestContainer.BorderColor3 = RED_MAIN
    settingsContainer.BackgroundColor3 = RED_BG
    settingsContainer.BorderColor3 = RED_MAIN
    destroyContainer.BackgroundColor3 = RED_BG
    destroyContainer.BorderColor3 = RED_MAIN
    removeTagsBtn.TextColor3 = RED_MAIN
    shareFavBtn.TextColor3 = RED_MAIN
    shareRctBtn.TextColor3 = RED_MAIN
    blacklistBtn.TextColor3 = RED_MAIN
    urlTestBtn.TextColor3 = RED_MAIN
    settingsBtn.TextColor3 = RED_MAIN
    destroyBtnMain.TextColor3 = RED_MAIN

    topBar.BackgroundColor3 = RED_BG
    topBar.BorderColor3 = RED_MAIN
    topBarText.TextColor3 = RED_MAIN
    hideTopBtn.BackgroundColor3 = RED_DARK
    hideTopBtn.TextColor3 = RED_MAIN
    hideTopBtn.BorderColor3 = RED_MAIN

    dockButton.BackgroundColor3 = RED_BG
    dockButton.TextColor3 = RED_MAIN
    dockButton.BorderColor3 = RED_MAIN

    local sl = mainFrame:FindFirstChild("SizeLabel")
    if sl then sl.TextColor3 = RED_MAIN end
    local rh = mainFrame:FindFirstChild("ResizeHandle")
    if rh then rh.BackgroundColor3 = RED_MAIN end

    if themeName ~= "Rainbow" then ShowRobloxNotification("Theme: " .. themeName, 2) end
end

getgenv().XyqwApplyTheme = ApplyTheme

themeBtn.MouseButton1Click:Connect(function()
    themeIndex = themeIndex + 1
    if themeIndex > #themeOrder then themeIndex = 1 end
    ApplyTheme(themeOrder[themeIndex])
    if getgenv().XyqwTheme == "Rainbow" then ShowRobloxNotification("Theme: Rainbow", 2) end
end)

task.spawn(function()
    local hue = 0
    while screenGui.Parent do
        if getgenv().XyqwTheme == "Rainbow" then
            hue = (hue + 0.008) % 1
            local c = Color3.fromHSV(hue, 1, 1)
            local darkHue = Color3.fromHSV(hue, 1, 0.18)
            mainFrame.BorderColor3 = c
            titleBar.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.08)
            titleLabel.TextColor3 = c
            for _, btn in ipairs({closeButton, langButton, playerBtn, serverBtn, customBtn, changelogButton, themeBtn, colorBtn, sortBtn}) do
                btn.BackgroundColor3 = darkHue
                btn.TextColor3 = c
                btn.BorderColor3 = c
            end
            searchBar.TextColor3 = c
            searchBar.BorderColor3 = c
            searchBar.BackgroundColor3 = darkHue
            scrollFrame.ScrollBarImageColor3 = c
            for n, btn in pairs(tabButtons) do
                if n == currentTab then
                    btn.BackgroundColor3 = c
                    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
                    btn.BorderColor3 = c
                else
                    btn.BackgroundColor3 = darkHue
                    btn.TextColor3 = c
                    btn.BorderColor3 = c
                end
            end
            for _, entry in ipairs(buttons) do
                entry.Container.BorderColor3 = c
                entry.Btn.TextColor3 = c
                entry.Star.TextColor3 = c
                entry.Star.BorderColor3 = c
                entry.Star.BackgroundColor3 = darkHue
                entry.AutoBtn.BorderColor3 = c
                entry.HideBtn.BorderColor3 = c
                if getgenv().XyqwAutoExec[entry.Data.Name] then
                    entry.AutoBtn.BackgroundColor3 = c
                    entry.AutoBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                else
                    entry.AutoBtn.BackgroundColor3 = darkHue
                    entry.AutoBtn.TextColor3 = c
                end
                entry.HideBtn.BackgroundColor3 = darkHue
                entry.HideBtn.TextColor3 = c
            end
            removeTagsContainer.BorderColor3 = c
            shareFavContainer.BorderColor3 = c
            shareRctContainer.BorderColor3 = c
            blacklistBtnContainer.BorderColor3 = c
            urlTestContainer.BorderColor3 = c
            settingsContainer.BorderColor3 = c
            destroyContainer.BorderColor3 = c
            removeTagsBtn.TextColor3 = c
            shareFavBtn.TextColor3 = c
            shareRctBtn.TextColor3 = c
            blacklistBtn.TextColor3 = c
            urlTestBtn.TextColor3 = c
            settingsBtn.TextColor3 = c
            destroyBtnMain.TextColor3 = c
            topBar.BorderColor3 = c
            topBarText.TextColor3 = c
            hideTopBtn.BackgroundColor3 = darkHue
            hideTopBtn.TextColor3 = c
            hideTopBtn.BorderColor3 = c
            dockButton.TextColor3 = c
            dockButton.BorderColor3 = c
            local sl = mainFrame:FindFirstChild("SizeLabel")
            if sl then sl.TextColor3 = c end
            local rh = mainFrame:FindFirstChild("ResizeHandle")
            if rh then rh.BackgroundColor3 = c end
        end
        task.wait(0.05)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode.Name == getgenv().XyqwSettings.autoHideBind then
            mainFrame.Visible = not mainFrame.Visible
            if mainFrame.Visible then dockButton.Visible = false end
        end
    end
end)

local resizeHandle = Instance.new("TextButton")
resizeHandle.Name = "ResizeHandle"
resizeHandle.Size = UDim2.new(0, 14, 0, 14)
resizeHandle.Position = UDim2.new(1, -14, 1, -14)
resizeHandle.BackgroundColor3 = RED_MAIN
resizeHandle.Text = ""
resizeHandle.BorderSizePixel = 0
resizeHandle.ZIndex = 10
resizeHandle.Parent = mainFrame
resizeHandle.AutoButtonColor = false

local sizeLabel = Instance.new("TextLabel")
sizeLabel.Name = "SizeLabel"
sizeLabel.Size = UDim2.new(0, 70, 0, 14)
sizeLabel.Position = UDim2.new(1, -88, 1, -16)
sizeLabel.BackgroundTransparency = 1
sizeLabel.TextColor3 = RED_MAIN
sizeLabel.Text = "280 x 340"
sizeLabel.TextSize = 10
sizeLabel.Font = Enum.Font.Gotham
sizeLabel.TextXAlignment = Enum.TextXAlignment.Right
sizeLabel.ZIndex = 10
sizeLabel.Parent = mainFrame

local resizing = false
local resizeStart, resizeStartSize

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = true
        resizeStart = input.Position
        resizeStartSize = mainFrame.Size
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - resizeStart
        local newX = math.clamp(resizeStartSize.X.Offset + delta.X, 280, 900)
        local newY = math.clamp(resizeStartSize.Y.Offset + delta.Y, 340, 1000)
        mainFrame.Size = UDim2.new(0, newX, 0, newY)
        sizeLabel.Text = math.floor(newX) .. " x " .. math.floor(newY)
        UpdateTabLayout()
        UpdateScriptButtonLayout()
        UpdateHeaderLayout()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        resizing = false
    end
end)

local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local mousePos = input.Position
        local function IsOverButton(btn)
            if not btn then return false end
            local p = btn.AbsolutePosition
            local s = btn.AbsoluteSize
            return mousePos.X >= p.X and mousePos.X <= p.X + s.X and mousePos.Y >= p.Y and mousePos.Y <= p.Y + s.Y
        end
        if IsOverButton(changelogButton) or IsOverButton(langButton) or IsOverButton(closeButton)
           or IsOverButton(themeBtn) or IsOverButton(customBtn) or IsOverButton(playerBtn) or IsOverButton(serverBtn)
           or IsOverButton(colorBtn) then
            return
        end
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    dockButton.Visible = true
end)

local function ShowWelcomeMessage()
    local frame = Instance.new("Frame")
    frame.Name = "WelcomeFrame"
    frame.Size = UDim2.new(0, 340, 0, 340)
    frame.Position = UDim2.new(0.5, -170, 0.5, -170)
    frame.BackgroundColor3 = RED_BG
    frame.BorderSizePixel = 2
    frame.BorderColor3 = RED_MAIN
    frame.ZIndex = 100
    frame.Active = true
    frame.Parent = screenGui

    local blocker = Instance.new("TextButton")
    blocker.Size = UDim2.new(1, 0, 1, 0)
    blocker.BackgroundTransparency = 1
    blocker.Text = ""
    blocker.Active = true
    blocker.AutoButtonColor = false
    blocker.ZIndex = 100
    blocker.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 22)
    title.Position = UDim2.new(0, 5, 0, 5)
    title.BackgroundTransparency = 1
    title.TextColor3 = RED_MAIN
    title.Text = _("WelcomeTitle")
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.ZIndex = 101
    title.Parent = frame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 22)
    closeBtn.Position = UDim2.new(1, -31, 0, 4)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = RED_MAIN
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 102
    closeBtn.Parent = frame
    closeBtn.AutoButtonColor = false
    closeBtn.MouseButton1Click:Connect(function() frame:Destroy() end)

    local shareBtn = Instance.new("TextButton")
    shareBtn.Size = UDim2.new(1, -20, 0, 24)
    shareBtn.Position = UDim2.new(0, 10, 0, 28)
    shareBtn.BackgroundColor3 = RED_DARK
    shareBtn.TextColor3 = RED_MAIN
    shareBtn.Text = _("ShareHub")
    shareBtn.TextScaled = true
    shareBtn.Font = Enum.Font.GothamBold
    shareBtn.BorderSizePixel = 1
    shareBtn.BorderColor3 = RED_MAIN
    shareBtn.ZIndex = 101
    shareBtn.Parent = frame
    shareBtn.AutoButtonColor = false
    shareBtn.MouseButton1Click:Connect(function()
        local ls = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Xyqwerq/XyqwHub/main/main.lua"))()'
        pcall(function() setclipboard(ls) end)
        ShowRobloxNotification(_("LoadstringCopied"), 4)
    end)

    local tiktok = Instance.new("TextLabel")
    tiktok.Size = UDim2.new(1, -10, 0, 16)
    tiktok.Position = UDim2.new(0, 5, 0, 58)
    tiktok.BackgroundTransparency = 1
    tiktok.TextColor3 = Color3.fromRGB(255, 255, 255)
    tiktok.Text = "TikTok: xyqwerq.tvink"
    tiktok.TextScaled = true
    tiktok.Font = Enum.Font.Gotham
    tiktok.ZIndex = 101
    tiktok.Parent = frame

    local tg = Instance.new("TextLabel")
    tg.Size = UDim2.new(1, -10, 0, 16)
    tg.Position = UDim2.new(0, 5, 0, 76)
    tg.BackgroundTransparency = 1
    tg.TextColor3 = Color3.fromRGB(255, 255, 255)
    tg.Text = "Telegram: t.me/xyqwsquad"
    tg.TextScaled = true
    tg.Font = Enum.Font.Gotham
    tg.ZIndex = 101
    tg.Parent = frame

    local dc = Instance.new("TextLabel")
    dc.Size = UDim2.new(1, -10, 0, 16)
    dc.Position = UDim2.new(0, 5, 0, 94)
    dc.BackgroundTransparency = 1
    dc.TextColor3 = Color3.fromRGB(255, 255, 255)
    dc.Text = "Discord: xyqwerqyt"
    dc.TextScaled = true
    dc.Font = Enum.Font.Gotham
    dc.ZIndex = 101
    dc.Parent = frame

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -150)
    scroll.Position = UDim2.new(0, 5, 0, 116)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.CanvasSize = UDim2.new(0, 0, 0, 620)
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = RED_MAIN
    scroll.ZIndex = 101
    scroll.Parent = frame

    local doc = Instance.new("TextLabel")
    doc.Size = UDim2.new(1, -10, 0, 610)
    doc.Position = UDim2.new(0, 5, 0, 0)
    doc.BackgroundTransparency = 1
    doc.TextColor3 = RED_MAIN
    doc.TextWrapped = true
    doc.TextXAlignment = Enum.TextXAlignment.Left
    doc.TextYAlignment = Enum.TextYAlignment.Top
    doc.TextSize = 10
    doc.Font = Enum.Font.Gotham
    doc.Text = "─── TITLE BAR ───\n" ..
        "Th  — Theme\n" ..
        "CC  — Custom Color\n" ..
        "CL  — ChangeLog\n" ..
        "C   — Custom Script\n" ..
        "P   — Players List\n" ..
        "S   — Server Info\n" ..
        "EN/RU/UK/BE/KK — Languages\n" ..
        "X   — Close\n" ..
        "\n─── BOTTOM BUTTONS (All tab) ───\n" ..
        "Remove Tags      — remove tags\n" ..
        "Manage Blacklist — hide scripts\n" ..
        "Test URLs       — check scripts\n" ..
        "Settings        — Auto-Hide bind\n" ..
        "Destroy XyqwHub — full unload\n" ..
        "\n─── Fav TAB ───\n" ..
        "Share Favorite Scripts\n" ..
        "\n─── Rct TAB ───\n" ..
        "Share Recent Scripts\n" ..
        "\n─── SCRIPT BUTTONS ───\n" ..
        "▶ / Auto  — Auto-Execute\n" ..
        "⊘ / Hide  — Add to Blacklist\n" ..
        "☆ / ★     — Favorites\n" ..
        "\n─── BLACKLIST ───\n" ..
        "Click × to unblacklist\n" ..
        "\n─── TOP BAR ───\n" ..
        "Executor | Username | FPS | Ping\n" ..
        "H — Hide / Show\n" ..
        "\n─── LANGUAGES ───\n" ..
        "EN, RU, UK, BE, KK\n" ..
        "Click EN/RU to cycle\n" ..
        "\n─── RESIZE ───\n" ..
        "Drag bottom-right corner\n" ..
        "\n─── FILES ───\n" ..
        "XyqwHub/FavScripts, RctScripts, CustomColor,\n" ..
        "AutoExecute, Blacklist, Settings"
    doc.ZIndex = 101
    doc.Parent = scroll

    local ver = Instance.new("TextLabel")
    ver.Size = UDim2.new(1, -10, 0, 16)
    ver.Position = UDim2.new(0, 5, 1, -20)
    ver.BackgroundTransparency = 1
    ver.TextColor3 = Color3.fromRGB(150, 150, 150)
    ver.Text = "Version: " .. VERSION .. "  |  " .. _("ClickXToClose")
    ver.TextScaled = true
    ver.Font = Enum.Font.Gotham
    ver.ZIndex = 101
    ver.Parent = frame
end

UpdateTabLayout()
UpdateScriptButtonLayout()
UpdateHeaderLayout()
SwitchTab("All")

task.spawn(function()
    task.wait(0.5)
    ShowRobloxNotification("XyqwHub Loaded!", 4)
    print("[XyqwHub] XyqwHub Loaded! Version: " .. VERSION)
end)

task.spawn(function()
    task.wait(1.2)
    ShowWelcomeMessage()
end)

task.spawn(function()
    task.wait(2.5)
    if IsOwner() then ShowRobloxNotification(_("OwnerWelcome"), 5)
    elseif IsBeta() then ShowRobloxNotification(_("BetaWelcome"), 5) end
end)
