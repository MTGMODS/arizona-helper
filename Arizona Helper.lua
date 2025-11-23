---@diagnostic disable: undefined-global, lowercase-global

script_name("Arizona Helper")
script_description('Universal script for players Arizona Online')
script_author("MTG MODS")
script_version("BETA 12.9.1")
----------------------------------------------- INIT ---------------------------------------------
function isMonetLoader() return MONET_VERSION ~= nil end
print('Инициализация скрипта...')
print('Версия: ' .. thisScript().version)
print('Платформа: ' .. (isMonetLoader() and 'MOBILE' or 'PC'))
------------------------------------------ INIT CRASH INFO ---------------------------------------
if not doesFileExist(getWorkingDirectory():gsub('\\','/') .. "/.Arizona Helper Crash Message.lua") then
	local file_path = getWorkingDirectory():gsub('\\','/') .. "/.Arizona Helper Crash Message.lua"
	local content = [[
function onSystemMessage(msg, type, script)
	if type == 3 and script and script.name == 'Arizona Helper' and msg and not msg:find('Script died due to an error') then
		local errorMessage = ('{ffffff}Произошла непредусмотренная ошибка в работе скрипта, из-за чего он был отключён!\n\n' ..
		'Отправьте скриншот и log в {ff9900}тех.поддержку MTG MODS (Telegram/Discord/BlastHack){ffffff}.\n\n' ..
		'Детали возникшей ошибки:\n{ff6666}' .. msg)
		sampShowDialog(789789, '{009EFF}Arizona Helper [' .. script.version .. ']', errorMessage, '{009EFF}Закрыть', '', 0)
	end
end
	]]
	local file, errstr = io.open(file_path, 'w')
	if file then
		file:write(content)
		file:close()
		if not isMonetLoader() then
			os.execute('attrib +h "' .. file_path .. '"')
		end
	end
end
------------------------------------------- CONNECT LIBNARY ---------------------------------------
print('Подключение нужных библиотек...')
require('lib.moonloader')
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local ffi = require('ffi')
local effil = require('effil')
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sampev = require('samp.events')
local monet_no_errors, moon_monet = pcall(require, 'MoonMonet')
local hotkey_no_errors, hotkey = pcall(require, 'mimgui_hotkeys')
local pie_no_errors, pie = pcall(require, 'mimgui_piemenu')
local sizeX, sizeY = getScreenResolution()
print('Библиотеки успешно подключены!')
-------------------------------------------- JSON SETTINGS ---------------------------------------
local configDirectory = getWorkingDirectory():gsub('\\','/') .. "/Arizona Helper"
local settings = {}
local default_settings = {
	general = {
		version = thisScript().version,
        custom_dpi = 1.0,
		autofind_dpi = false,
        helper_theme = 0,
		message_color = 40703,
		moonmonet_theme_color = 40703,
		fraction_mode = '',
		bind_mainmenu = '[113]',
		bind_fastmenu = '[69]',
		bind_leader_fastmenu = '[71]',
		bind_action = '[13]',
		bind_command_stop = '[123]',
		piemenu = false,
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		payday_notify = true,
		cruise_control = true,
		auto_uninvite = false,
		ping = true,
		rp_guns = true,
	},
	player_info = {
		nick = '',
		name_surname = '',
		fraction = 'none',
		fraction_tag = '',
		fraction_rank = '',
		fraction_rank_number = 0,
		sex = 'Мужчина',
		accent_enable = true,
		accent = '[Иностранный акцент]:',
		rp_chat = true,
	},
	departament = {
		anti_skobki = false,
		dep_fm = '-',
		dep_tag1 = '',
		dep_tag2 = '[Всем]',
		dep_tags = {
			"[Всем]",
			"[Похитители]",
			"[Терористы]",
			"[Диспетчер]",
			'skip',
			"[МЮ]",
			"[Мин.Юст.]",
			"[ЛСПД]",
			"[СФПД]",
			"[ЛВПД]",
			"[РКШД]",
			"[СВАТ]",
			"[ФБР]",
			'skip',
			"[МО]",
			"[Мин.Обороны]",
			"[ЛСа]",
			"[СФа]",
			"[ТСР]",
			'skip',
			"[МЗ]",
			"[МЗП]",
			"[Мин.Здрав.]",
			"[ЛСМЦ]",
			"[СФМЦ]",
			"[ЛВМЦ]",
			"[ДМЦ]",
			"[ПД]",
			'skip',
			"[ЦА]",
			"[ЦЛ]",
			"[СК]",
			"[Пра-во]",
			"[Губернатор]",
			"[Прокурор]",
			"[Cудья]",
			'skip',
			"[СМИ]",
			"[СМИ ЛС]",
			"[СМИ СФ]",
			"[СМИ ЛВ]",
		},
		dep_tags_en = {
			"[ALL]",
			'skip',
			"[MJ]",
			"[Min.Just.]",
			"[LSPD]",
			"[SFPD]",
			"[LVPD]",
			"[RCSD]",
			"[SWAT]",
			"[FBI]",
			'skip',
			"[MD]",
			"[Mid.Def.]",
			"[LSa]",
			"[SFa]",
			"[MSP]",
			'skip',
			"[MH]",
			"[MHF]",
			"[Min.Healt]",
			"[LSMC]",
			"[SFMC]",
			"[LVMC]",
			"[JMC]",
			"[FD]",
			'skip',
			"[GOV]",
			'[Governor]',
			"[Prosecutor]",
			"[Judge]",
			"[LC]",
			"[INS]",
			'skip',
			"[CNN]",
			"[CNN LS]",
			"[CNN LV]",
			"[CNN SF]",
		},
		dep_tags_custom = {},
		dep_fms = {
			'-',
			'- з.к. -',
		},
	},
	windows_pos = {
		megafon = {x = sizeX / 8.5, y = sizeY / 2.1},
		patrool_menu = {x = sizeX / 2, y = sizeY / 2},
		post_menu = {x = sizeX / 2, y = sizeY / 2},
		wanteds_menu = {x = sizeX / 1.2, y = sizeY / 2},
		mobile_fastmenu_button = {x = sizeX / 8.5, y = sizeY / 2.3},
		taser = {x = sizeX / 4.2, y = sizeY / 2.1},
	},
    mj = {
		auto_doklad_damage = false,
		mobile_meg_button = true,
		mobile_taser_button = true,
		auto_change_code_siren = true,
    },
	md = {
		auto_doklad_damage = false,
		auto_doklad_patrool = true,
	},
	mh = {
		price = {
			ant = 50000,
			recept = 100000,
			heal = 100000,
			heal_vc = 1000,
			healactor = 800000,
			healactor_vc = 1000,
			healbad = 400000,
			medosm = 800000,
			mticket = 400000,
			med7 = 50000,
			med14 = 100000,
			med30 = 150000,
			med60 = 200000,
		},
		heal_in_chat = {
			enable = true,
		},
	},
	smi = {
		ads_history = true,
		use_ads_buttons = true,
	},
	lc = {
		price = {
			avto1 = 200000,
			avto2 = 360000,
			avto3 = 410000,
			moto1 = 300000,
			moto2 = 350000,
			moto3 = 450000,
			fish1 = 500000,
			fish2 = 550000,
			fish3 = 590000,
			swim1 = 500000,
			swim2 = 550000,
			swim3 = 590000,
			gun1 = 1000000,
			gun2 = 1090000,
			gun3 = 1150000,
			hunt1 = 1000000,
			hunt2 = 1100000,
			hunt3 = 1190000,
			klad1 = 1100000,
			klad2 = 1200000,
			klad3 = 1250000,
			taxi1 = 800000,
			taxi2 = 1150000,
			taxi3 = 1250000,
			mexa1 = 800000,
			mexa2 = 1150000,
			mexa3 = 1250000,
			fly1 = 1200000,
			fly2 = 1200000,
			fly3 = 1200000,
		},
		auto_find_clorest_repair_znak = true,
	},
	gov = {
		anti_trivoga = true,
		zeks_in_screen = true
	}
}
function load_settings()
    if not doesDirectoryExist(configDirectory) then createDirectory(configDirectory) end
    if not doesFileExist(configDirectory .. "/Settings.json") then
        settings = default_settings
		print('Файл с настройками не найден, использую стандартные настройки!')
    else
        local file = io.open(configDirectory .. "/Settings.json", 'r')
        if file then
            local contents = file:read('*a')
            file:close()
			if #contents ~= 0 then
				local result, loaded = pcall(decodeJson, contents)
				if result then	
					settings = loaded
					if settings.general.version ~= thisScript().version then
						print('Новая версия, сброс настроек!')
						local fraction_mode = settings.general.fraction_mode
						local player_info = settings.player_info
						settings = default_settings
						settings.player_info = player_info
						settings.general.fraction_mode = fraction_mode
						save_settings()
						reload_script = true
						thisScript():reload()
					else
						print('Настройки успешно загружены!')
					end
				else
					settings = default_settings
					print('Не удалось открыть файл с настройками, использую стандартные настройки!')
				end
			else
                settings = default_settings
				print('Не удалось открыть файл с настройками, использую стандартные настройки!')
			end
        else
            settings = default_settings
			print('Не удалось открыть файл с настройками, использую стандартные настройки!')
        end
    end
end
function save_settings()
    local file, errstr = io.open(configDirectory .. "/Settings.json", 'w')
    if file then
		local function looklike(array) 
			local dkok, dkjson = pcall(require, "dkjson") 
			if dkok then 
				local ok, encoded = pcall(dkjson.encode, array, {indent = true})
				if ok then return encoded end
			else
				local ok, encoded = pcall(encodeJson, array) 
				if ok then return encoded end 
			end
		end
		local content = looklike(settings)
		if content then
			file:write(content)
			print('Настройки хелпера сохранены!')
		else
			print('Не удалось сохранить настройки хелпера! Ошибка кодировки json')
		end
		file:close()
    else
        print('Не удалось сохранить настройки хелпера, ошибка: ', errstr)
    end
end
function isMode(mode_type)
	return settings.general.fraction_mode == mode_type
end
load_settings()
------------------------------------------- AUTO FIND DPI ----------------------------------------
if not settings.general.autofind_dpi then
	print('Применение авто-размера менюшек...')
	if isMonetLoader() then
		settings.general.custom_dpi = MONET_DPI_SCALE
	else
		local width_scale = sizeX / 1366
		local height_scale = sizeY / 768
		settings.general.custom_dpi = (width_scale + height_scale) / 2
	end
	settings.general.autofind_dpi = true
	local format_dpi = string.format('%.3f', settings.general.custom_dpi)
	settings.general.custom_dpi = tonumber(format_dpi)
	print('Установлено значение: ' .. settings.general.custom_dpi)
	print('Вы в любой момент можете изменить значение в настройках!')
	save_settings()
end
------------------------------------------ JSON & MODULES ----------------------------------------
local modules = {
	commands = {
		name = 'Команды',
		path = configDirectory .. "/Commands.json",
		data = {
			commands = {
				my = {
					{cmd = 'time' , description = 'Посмотреть время' ,  text = '/me взглянул{sex} на часы с гравировкой Arizona Helper и посмотрел{sex} время&/time&/do На часах видно время {get_time}.' , arg = '' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'cure' , description = 'Поднять игрока из стадии' ,  text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека начало биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}"},
					},
				police = {
					{cmd = '55', description = 'Проведение 10-55', text = '/r {my_doklad_nick} на CONTROL. Провожу 10-55 в районе {get_area} ({get_square}), СODE 4.&/m Водитель {get_drived_car} внимание!&/m Говорит {fraction}! Снизьте скорость и прижмитесь к обочине.&/m После остановки заглушите двигатель, и не выходите из транспорта.&/m В случае неподчинения вы будете объявлены в розыск!', arg = '', enable = true, waiting = '0.5', bind = "[101]"},
					{cmd = '66', description = 'Проведение 10-66', text = '/r {my_doklad_nick} на CONTROL. Провожу 10-66 в районе {get_area} ({get_square}), СODE 3!&/m Водитель {get_drived_car} внимание!&/m Говорит {fraction}! Немедленно прижмитесь к обочине!&/m В случае неподчинения по вам будет открыт огонь!', arg = '', enable = true, waiting = '0.5', bind = "[102]"},
					{cmd = 'zd' , description = 'Приветствие игрока (ПД)' , text = 'Здравствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'bk' , description = 'Запрос помощи с координатами' , text = '/me достал{sex} свой КПК и отправил{sex} координаты в базу данных {fraction_tag}&/bk 10-20&/r {my_doklad_nick} на CONTROL. Срочно нужна помощь, отправил{sex} свои координаты!', arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'fara' , description = 'Оставить отпечаток на фаре' , text = '/me коснулся левой фары {get_nearest_car}&/do Отпечаток успешно оставлен на левой фаре транспортного средства.', arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'pas' , description = 'Запрос документов (ПД)' ,  text = 'Здравствуйте, управление {fraction_tag}, я {fraction_rank} {my_ru_nick}&/do Cлева на груди жетон полицейского, справа именная нашивка с именем.&/me достаёт своё удостоверение из кармана&/showbadge {arg_id}&Прошу предъявить документ, удостоверяющий вашу личность.&/n @{get_nick({arg_id})}, введите /showpass {my_id}' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'ts' , description = 'Выписать штраф' ,  text = '/do Мини-плантет находиться в кармане формы.&/writeticket {arg_id} {arg2}&/me вносит изменения в базу штрафов&/todo Оплатите штраф*убирая мини-планшет обратно в карман' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'find' , description = 'Поиск игрока' ,  text = '/me достал{sex} свой КПК и зайдя в базу данных {fraction_tag} открыл{sex} дело гражданина N{arg_id}&/me нажал{sex} на кнопку GPS отслеживания местоположения гражданина&/find {arg_id}' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'pr' , description = 'Погоня за преступником' ,  text = '/me достал{sex} свой КПК и зайдя в базу данных {fraction_tag} открыл{sex} дело преступника N{arg_id}&/me нажал{sex} на кнопку GPS отслеживания местоположения гражданина&/pursuit {arg_id}' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'su' , description = 'Выдать розыск' ,  text = '/me достал{sex} свой КПК и открыл{sex} базу данных преступников&/me вносит изменения в базу данных преступников&/su {arg_id} {arg2} {arg3}&/z {arg_id}&/todo Отлично, преступник в розыске*убирая КПК' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'fsu' , description = 'Запросить выдачу розыска' ,  text = '/do Рация на тактическом поясе.&/me достал{sex} рацию c пояса, и связавашись с диспетчером, запросил{sex} обьявление человека в розыск&/r {my_doklad_nick} на CONTROL.&/r Прошу обьявить в розыск {arg2} степени дело N{arg_id}. Причина: {arg3}' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'givefsu' , description = 'Выдача розыска по запросу офицера' ,  text = '/r 10-4, обьявляю гражданина в розыск по запросу офицера {get_rp_nick({arg_id})}!&/me достал{sex} свой КПК и открыл{sex} базу данных преступников&/me вносит изменения в базу данных преступников&/su {get_form_su} (по запросу офицера {get_rp_nick({arg_id})})&/todo Отлично, розыск по запросу офицера {get_rp_nick({arg_id})} выдан*убирая КПК' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'unsu' , description = 'Понизить розыск' ,  text = '/me достал{sex} свой КПК и открыл{sex} базу данных преступников&/me найдя дело N{arg_id} вносит изменения в базу данных преступников&/unsu {arg_id} {arg2} {arg3}' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'clear' , description = 'Снять розыск' ,  text = '/me достаёт свой КПК и открывает базу данных преступников&/me найдя дело N{arg_id} вносит изменения в базу данных преступников&/clear {arg_id}&/do Дело N{arg_id} больше не находится в списке разыскиваемых преступников.' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					
					{cmd = 'gcuff' , description = 'Надеть наручники и вести за собой' ,  text = '/do Наручники на тактическом поясе.&/todo Я надену на вас наручники*снимая наручники с тактического пояса&/cuff {arg_id}&/todo Не двигайтесь*надевая наручники на человека&/me схватывает задержанного за руки и ведёт его за собой&/gotome {arg_id}&/do Задержанный идёт в конвое.' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}"},
		
					{cmd = 'cuff' , description = 'Надеть наручники' ,  text = '/do Наручники на тактическом поясе.&/todo Я надену на вас наручники*снимая наручники с тактического пояса&/cuff {arg_id}&/todo Не двигайтесь*надевая наручники на человека' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}" , in_fastmenu = true},
					{cmd = 'uncuff' , description = 'Снять наручники' ,  text = '/do На тактическом поясе прикреплены ключи от наручников.&/me взяв с пояса ключи от наручников прокрутил{sex} замок наручников задержанного&/uncuff {arg_id}&/todo Ваши руки свободны*убирая ключи от наручники обратно на пояс', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'gtm' , description = 'Повести за собой' ,  text = '/me крепко схватив задержанного, взял{sex} его за руки&/gotome {arg_id}&/do Задержанный идёт в конвое.', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'ungtm' , description = 'Перестать вести за собой' ,  text = '/me отпускает руки задержанного и перестаёт вести его за собой&/ungotome {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},

					{cmd = 'bot' , description = 'Изьять скрепки у игрока (взлом наручников)' ,  text = '/me увидел{sex} что задержанный использует скрепки для взлома наручников&/todo Вы что себе позволяете?!*изымая скрепки у {get_rp_nick({arg_id})}&/bot {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'ss' , description = 'Кричалка' ,  text = '/s Всем поднять руки вверх, работает {fraction_tag}!', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 't' , description = 'Достать тазер' ,  text = '/taser', arg = '', enable = true, waiting = '1.5', bind = "[18,49]" },
					{cmd = 'frl' , description = 'Первичный обыск' ,  text = 'Сейчас я проверю у вас наличие оружия или других острых предметов, не двигайтесь.&/me прощупывает тело задержанного человека&/me прощупывает карманы задержанного человека', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'fr' , description = 'Полный обыск' ,  text = '/do Резиновые перчатки на тактическом поясе.&/todo Сейчас я полностью обыщу вас, на наличие запрещенных предметов*надевая резиновые перчатки&/me прощупывает тело и карманы задержанного человека&/me достаёт из карманов задержанного все его вещи для изучения&/me внимательно осматривает все найденные вещи у задержанного человека&/frisk {arg_id}&/me снимает резиновые перчатки и убирает их на тактический пояск&/do Блокнот с ручкой в нагрудном кармане.&/me берет в руки блокнот с ручкой, и записывает всю информацию про обыск&/me сделав пометки, убирает блокнот с ручкой в нагрудный карман', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'take' , description = 'Изьятие предметов игрока' , text = '/do В подсумке находиться небольшой зип-пакет.&/me достаёт из подсумка зип-пакет и отрывает его&/me кладёт в зип-пакет изъятые предметы задержанного человека&/take {arg_id}&/do Изъятые предметы в зип-пакете.&/todo Отлично*убирая зип-пакет в подсумок', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true  },
					{cmd = 'camon' , description = 'Включить cкрытую боди камеру' ,  text = '/do К форме прикреплена скрытая боди камера.&/me незаметным движением руки включил{sex} боди камеру.&/do Скрытая боди камера включена и снимает всё происходящее.', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'camoff' , description = 'Выключить cкрытую боди камеру' ,  text = '/do К форме прикреплена скрытая боди камера.&/me незаметным движением руки выключил{sex} боди камеру.&/do Скрытая боди камера выключена и больше не снимает всё происходящее.', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'inc' , description = 'Затащить в транспорт' ,  text = '/me открывает заднюю дверь транспорта&/todo Наклоните голову, здесь дверь*заталкивая задержанного в транспортное средство&/incar {arg_id} {arg2}&/me закрывает заднюю дверь транспорта&/do Задержанный в транспортном средстве.', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'ej' , description = 'Выбросить из транспорта',  text = '/me открывает дверь транспорта&/me помогает человеку выйти из транспорта&/eject {arg_id}&/me закрывает дверь транспорта', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},	
					{cmd = 'pl' , description = 'Выбросить игрока из его транспорта',  text = '/me резким ударом дубинки разбивает стело транспорта задержанного&/pull {arg_id}&/me выбрасывает задержанного из его транспорта и ударом дубинки оглушает его', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},	
					{cmd = 'mr' , description = 'Зачитать правило Миранды',  text = 'Вы имеете право хранить молчание.&Всё, что вы скажете, может и будет использовано против вас в суде.&Вы имеете право на 1 телефонный звонок, например для вызова частного адвоката.&Ваш адвокат может присутствовать при допросе.&Если вы не можете оплатить услуги адвоката, он будет предоставлен вам государством.&Вам ясны Ваши права?', arg = '', enable = true, waiting = '1.5', bind = "{}"},	
					{cmd = 'unmask' , description = 'Снять балаклаву с игрока',  text = '/do Задержанный в балаклаве.&/me стягивает балаклаву с головы задеражнного&/unmask {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}" , in_fastmenu = true},
					{cmd = 'arr' , description = 'Арестовать (в участке)',  text = '/me включает свой бортовой компютер и вводит код доступа сотрудника&/me заходит в раздел оформления протоколов задержаний и указывает данные&/do Протокол задержания заполнен.&/me вызывает по рации дежурный наряд участка и передаёт им задержанного человека&/arrest', arg = '', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'bribe' , description = 'Получение взятки от игрока' ,  text = '/do Гражданин сейчас ведёт запись через аудио-видео устройства?&/n @{get_nick({arg_id})}, отвечайте на РП, например /do Нет.&{pause}&/do Телефон в кармане.&/me достал{sex} телефон, открыл{sex} заметки, и что-то туда написал{sex}&/do В заметках телефона написан такой текст: {arg2}$&/todo Что скажете?*показав телефон преступнику возле себя&{pause}&/bribe {arg_id} {arg2} 1&/n @{get_nick({arg_id})}, используйте /offer для принятия предложения', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'drugs' , description = 'Провести Drugs Test' ,  text = '/do На тактическом поясе прикреплён подсумок.&/me открывает подсумок и достаёт из него набор Drugs Test&/me берёт из набора пробирку с этиловым спиром&/me засыпает найденное вещество в пробирку&/me достаёт из подсумка тест Имуно-Хром-10 и добавляет его в пробирку&/do В пробирке с этиловым спиртом находится неизвестное вещество и Имуно-Хром-10.&/me аккуратными движениями взбалтывает пробирку&/do От теста Имуно-Хром-10 содержимое пробирки изменило цвет.&/todo Да, это точно наркотики*увидев что содержимое пробирки изменило цвет&/me убирает пробирку обратно в подсумок и закрывает его', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'rbomb' , description = 'Деактивировать бомбу' ,  text = '/do На тактическом поясе прикреплён сапёрный набор.&/me снимает с пояса сапёрный набор и кладет его на землю, затем открывает его&/do Открытый сапёрный набор находится на земле.&/me достаёт из сапёрного набора пакет с жидким азотом и кладет его на землю&/me достаёт из сапёрного набора отвёртку&/do Отвертка в руках, а пакет с жидким азотом на земле.&/do На корпусе бомбы находится 2 болтика.&/me откручивает болтики с бомбы и убирает их вместе с отвёрткой в сторону&/me аккуратным движением руки вскрывает крышку бомбы&/me внимательно осматривает бомбу&/do Внутри бомбы видна детонирующая часть.&/me достаёт из сапёрного набора кусачки&/do Кусачки в руках.&/me аккуратным движением кусочок разрезает красный провод бомбы&/do Таймер остановился, тиканье со стороны бомбы не слышно.&/me берёт в руки охлаждающий пакет с жидким азотом и кладёт его детонирующую часть бомбы&/removebomb&/do Бомба обезврежена.&/me убирает кусачки и отвёртку обратно в саперный набор и закрывает его', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'delo' , description = 'Расследование убийства' ,  text = '/do Сотрудник прибыл на место убийства.&/todo Такс, что же здесь произошло*осматривая место убийства&/me осматривает и  изучает все улики&{pause}&/me достаёт из подсумка бланк для расследования и ручку&/me заполняет бланк расследования записывая все изученные улики&{pause}&/me записывает в бланк точную дату и время убийства&{pause}&/do Найдено орудие убийства.&/me записывает в бланк орудие убийства&{pause}&/do Бланк расследования убийства полностью заполнен.&/todo Отлично, расследование окончено*убирая бланк в карман', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'giveplate' , description = 'Выдача разрешений на номера' ,  text = '/do Бланк и ручка в нагрудном кармане.&/me достаёт ручку и бланк из нагрудного кармана&/me заполняет бланк для выдачу разрешения на номерной знак&/do Бланк полностью заполнен.&/todo Вот ваше разрешение, берите*убирая ручку в нагрудный карман&/giveplate {arg_id} {arg2}&/n @{get_nick({arg_id})}, введите /offer и примите, чтобы получить разрешение на номерной знак.', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'agenda' , description = 'Выдача повестки игроку' ,  text = '/do В папке с документами лежит ручка и пустой бланк с надписью Повестка.&/me достаёт из папки ручку с пустым бланком повестки&/me начинает заполнять все необходимые поля на бланке повестки&/do Все данные в повестке заполнены.&/me ставит на повестку штамп и печать {fraction_tag}&/do Готовый бланк повестки в руках.&/todo Не забудьте явиться в военкомат по указанному адресу и времени*передавая повестку&/agenda {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
				},
				fbi = {
					{cmd = 'doc', description = 'Запросить документы (FBI)' ,  text = 'Здравствуйте, я {fraction_rank} {fraction_tag}&/do Cлева на груди спец-жетон ФБР.&/me указывает пальцем на свой спец-жетон на груди&Прошу предъявить документ, удостоверяющий вашу личность.&/n @{get_nick({arg_id})}, введите /showpass {my_id} или /showbadge {my_id}' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'priton1', description = 'Обнаружен притон' ,  text = '/d ФБР - МЮ: В опасном районе найден наркопритон!&/d ФБР - МЮ: Желающие присоедениться к рейду - в гараж ЛСПД&/d ФБР - МЮ: Возьмите с собой оружие, бронижелет, и обязательно маску!' , arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'priton2', description = 'Прибытие на притон' ,  text = '/d ФБР - МЮ: Мы прибыли на територию наркопритона! Я куратор спец-операции.&/d ФБР - МЮ: Оцепляйте територию, и никого не вступайте на територию наркопритона.&/d ФБР - МЮ: Кусты срезают только агенты, остальные защищают!' , arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'priton3', description = 'Конец притона' ,  text = '/d ФБР - МЮ: Спец-операция "Притон" окончена!&/d ФБР - МЮ: Всем спасибо за участие, можете быть свободны!&/d ФБР - МЮ: Не забудьте убрать ограждения с территории.' , arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'gwarn' , description = 'Выдать спец-выговор' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me открыв базу данных {fraction_tag} переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/gwarn {arg_id} {arg2}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'ungwarn' , description = 'Снять спец-выговор' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me открыв базу данных {fraction_tag} переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/ungwarn {arg_id}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'dismiss' , description = 'Уволить госслужащего (1-4)' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me открыв базу данных {fraction_tag} переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/dismiss {arg_id} {arg2}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'tie', description = 'Связать жертву', text = '/do В кармане бронежилета лежит шпагат.&/me легким движением руки достал{sex} из кармана шпагат&/me обвязывает руки жертвы веревкой и стягивает её&/tie {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'untie', description = 'Развязать жертву', text = '/do На правом бедре закреплено тактическое крепление для ножа.&/me движением правой руки открепив нож, берёт его в руки&/do В правой руке держит нож.&/me подойдя к жертве со спины, отрезал{sex} верёвку&/untie {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'lead', description = 'Вести жертву за собой', text = '/me движением руки схватив за шкирку жертвы, ведёт его за собой&/lead {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'unlead', description = 'Прекратить вести жертву', text = '/me расслабив схватку, перестаёт контролировать жертву&/unlead {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'gag', description = 'Заткнуть рот жертве тряпкой', text = '/do На поясе закреплена сумка.&/me правой рукой отстегнув молнию, открывает сумку&/do Внутри сумки лежит тряпка.&/me подходя к жертве, попутно достал{sex} из сумки тряпку&/do Тряпка в руках в развёрнутом виде.&/me обеими руками завернув тряпку, запихнул{sex} в рот жертвы&/gag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true},
					{cmd = 'ungag', description = 'Вытащить тряпку изо рта жертвы', text = '/me подойдя ближе к жертве, движением правой руки потянул{sex} за тряпку и забрал{sex} себе&/ungag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'bag', description = 'Надеть пакет на голову жертвы', text = '/do В кармане куртки лежит мусорный пакет.&/me достал{sex} мусорный пакет из кармана, развернул{sex} его&/me надевает мусорный пакет на голову жертвы, не затягивая его&/bag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'unbag', description = 'Снять пакет с головы жертвы', text = '/me легким движением руки схватив за пакет, потянул{sex} его вверх, тем самым стянув пакет с головы жертвы&/unbag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true},
				},
				army = {
					{cmd = 'pas', description = 'Проверка документов (кпп)', text = 'Здравствуйте, я {fraction_rank} {fraction_tag} - {my_doklad_nick}.&/do Удостоверение находиться в левом кармане брюк.&/me достал{sex} удостоверение и раскрыл{sex} его перед человеком.&/do В удостоверении указано: {fraction} - {fraction_rank} {my_doklad_nick}.&Назовите причину прибытия на территорию на нашу базу.&И предоставьте мне свои документы для проверки!', arg = '', enable = true, waiting = '1.5', in_fastmenu = true  },
					{cmd = 'agenda' , description = 'Выдача повестки игроку' ,  text = '/do В папке с документами лежит ручка и пустой бланк с надписью Повестка.&/me достаёт из папки ручку с пустым бланком повестки&/me начинает заполнять все необходимые поля на бланке повестки&/do Все данные в повестке заполнены.&/me ставит на повестку штамп и печать {fraction_tag}&/do Готовый бланк повестки в руках.&/todo Не забудьте явиться в военкомат по указанному адресу и времени*передавая повестку&/agenda {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}"},
				},
				prison = {
					{cmd = 't' , description = 'Достать тазер' ,  text = '/taser', arg = '', enable = true, waiting = '1.5', },
					{cmd = 'cuff', description = 'Надеть наручники', text = '/do Наручники на тактическом поясе.&/me снимает наручники с пояса и надевает их на задержанного&/cuff {arg_id}&/do Задержанный в наручниках.', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'uncuff', description = 'Снять наручники', text = '/do На тактическом поясе прикреплены ключи от наручников.&/me снимает с пояса ключ от наручников и вставляет их в наручники задержанного&/me прокручивает ключ в наручниках и снимает их с задержанного&/uncuff {arg_id}&/do Наручники сняты с задержанного&/me кладёт ключ и наручники обратно на тактический пояс', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'gotome', description = 'Повести за собой', text = '/me схватывает задержанного за руки и ведёт его за собой&/gotome {arg_id}&/do Задержанный идёт в конвое.', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'ungotome', description = 'Перестать вести за собой', text = '/me отпускает руки задержанного и перестаёт вести его за собой&/ungotome {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'take', description = 'Изьятие предметов игрока', text = '/do В подсумке находиться небольшой зип-пакет.&/me достаёт из подсумка зип-пакет и отрывает его&/me кладёт в зип-пакет изъятые предметы задержанного человека&/take {arg_id}&/do Изъятые предметы в зип-пакете.&/todo Отлично*убирая зип-пакет в подсумок', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'carcer', description = 'Посадка игрока в карцер',text = '/do На поясе висит связка ключей.&/me прислонив заключённого к стене, снял ключ со связки, открыл дверцу камеры&/me лёгкими движениями рук затолкнул заключённого в камеру, после чего закрыл её&/me лёгкими движениями рук закрепил ключ к связке&/carcer {arg_id} {arg2} {arg3} {arg4}',arg = '{arg_id} {arg2} {arg3} {arg4}', enable = true, waiting = '1.5'},
					{cmd = 'setcarcer', description = 'Смена карцера игроку', text = '/do На поясе висит связка ключей.&/me лёгкими движениями рук снял ключ со связки, открыл свободную камеру и камеру заключённого&/me вытолкнул заключённого из первой камеры, затолкнул во вторую, закрыв двери обоих камер&/me лёгкими движениями рук закрепил ключ к связке&/setcarcer {arg_id} {arg2}', arg = '{arg_id}, {arg2}', enable = true, waiting = '1.5'},
					{cmd = 'uncarcer', description = 'Выпуск игрока из карцера', text = '/do На поясе висит связка ключей.&/me движениями рук снял ключ со связки, открыл камеру и вытолкнул из неё заключённого&/me закрыл дверцу камеры, закрепил ключ к связке&/uncarcer {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5' },
					{cmd = 'frisk', description = 'Обыск заключённого', text = '/do Перчатки на поясе.&/me схватил перчатки и одел&/do Перчатки одеты.&/me начал нащупывать человека напротив&/frisk {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'punishsu', description = 'Повысить уровень наказания.', text ='/me достаёт свой КПК и открывает базу данных тюрьмы&/me вносит изменения в базу данных тюрьмы&/do Изменения занесены в базу данных тюрьмы.&/punish {arg_id} {arg2} 2 {arg3}', arg = '{arg_id} {arg2} {arg3}', enable = true, waiting = '1.5'},
					{cmd = 'punishclear', description = 'Понизить уровень наказания', text = '/me достаёт блокнот из нагрудного кармана&/do Блокнот в руке.&/me открывает его на странице с записями о поведении заключённых.&/do В блокноте видна запись: "{get_rp_nick({arg_id})}, примерное поведение...&/do ...участие в уборке территории, отсутствие нарушений."&/me берёт ручку и записывает новую информацию о заключённом.&/do В блокноте добавлена запись: "Рекомендация на сокращение срока...&/do ...на {arg2} года за добросовестное выполнение обязанностей."&/me закрывает блокнот и убирает его обратно в карман формы.&/do Данные о заключённом зафиксированы...&/do ...для последующего рассмотрения администрацией.&/punish {arg_id} {arg2} 1 {arg3}', arg = '{arg_id} {arg2} {arg3}', enable = true, waiting = '1.5'},
				},
				hospital = {	
					{cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'hme' , description = 'Лечение самого себя' ,  text = '/me достаёт из своего мед.кейса лекарство и принимает его&/heal {my_id} {get_price_heal}' , arg = '' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'zd' , description = 'Привествие игрока' , text = 'Здравствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'go' , description = 'Позвать игрока за собой' , text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'hl' , description = 'Обычное лечение игрока' , text = '/me достаёт из своего мед.кейса нужное лекарство и передаёт его человеку напротив&/todo Принимайте это лекарство, оно вам поможет*улыбаясь&/heal {arg_id} {get_price_heal}&/n @{get_nick({arg_id})}, примите предложение в /offer чтобы вылечиться!', arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'hla' , description = 'Лечение охранника игрока' ,  text = '/me достаёт из своего мед.кейса лекарство и передаёт его человеку напротив&/todo Давайте своему охраннику это лекарство, оно ему поможет*улыбаясь&/healactor {arg_id} {get_price_actorheal}&/n @{get_nick({arg_id})}, примите предложение в /offer чтобы вылечить охранника!' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'hlb' , description = 'Лечение игрока от наркозависимости' ,  text = '/me достаёт из своего мед.кейса таблетки от наркозависимости и передаёт их пациенту напротив&/todo Принимайте эти таблетки, и в скором времени Вы излечитесь от наркозависимости*улыбаясь&/healbad {arg_id}&/n @{get_nick({arg_id})}, примите предложение в /offer чтобы вылечиться!' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},	
					{cmd = 'mt' , description = 'Мед.оcмотр для военного билета' ,  text = 'Хорошо, сейчас я проведу вам мед.осмотр для получения военного ... &... билета по стану здоровья, но шанс на успех всего 1 процент!&/mticket {arg_id} {get_price_mticket}&/n @{get_nick({arg_id})}, примите предложение в /offer для начала мед.осмотра!' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'pilot' , description = 'Мед.осмотр для пилотов' ,  text = 'Хорошо, сейчас я проведу вам мед.осмотр для пилотов.&/medcheck {arg_id} {get_price_medosm}&/n @{get_nick({arg_id})}, примите предложение в /offer для продолжения мед.осмотра!&/n Пока вы не примите предложение, мы не сможем начать!&{pause}&И так...&/me достаёт из мед.кейса стерильные перчатки и надевает их на руки&/do Перчатки на руках.&/todo Начнём мед.осмотр*улыбаясь.&Сейчас я проверю ваше горло, откройте рот и высуните язык.&/me достаёт из мед.кейса фонарик и включив его осматривает горло человека напротив&Хорошо, можете закрывать рот, сейчас я проверю ваши глаза.&/me проверяет реакцию человека на свет, посветив фонарик в глаза&/do Зрачки глаз обследуемого человека сузились.&/todo Отлично*выключая фонарик и убирая его в мед.кейс&Такс, сейчас я проверю ваше сердцебиение, поэтому приподнимите верхную одежду!&/me достаёт из мед.кейса стетоскоп и приложив его к груди человека проверяет сердцебиение&/do Сердцебиение в районе 65 ударов в минуту.&/todo С сердцебиением у вас все в порядке*убирая стетоскоп обратно в мед.кейс&/me снимает со своих рук использованные перчатки и выбрасывает их&Ну что-ж я могу вам сказать, со здоровьем у вас все в порядке, вы свободны!' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'medin' , description = 'Оформление игроку мед.страховки' ,  text = 'Для оформления мед.страховки Вам необходимо оплатить определнную cумму.&Стоимость зависит от срока действия будущей мед.страховки.&На 1 неделю - $4ОО.ООО. На 2 недели - $8ОО.ООО. На 3 недели - $1.2ОО.ООО.&И так, скажите, на какой срок Вам оформить мед.страховку?&{pause}&/me достаёт из своего мед.кейса пустой бланк мед.страховки, ручку и печать {fraction_tag}&/me открывает бланк мед.страховки и начинает его заполнять, затем ставит печать {fraction_tag}&/me полностью заполнив бланк мед.страховки убирает ручку и печать обратно в свой мед.кейс&/givemedinsurance {arg_id}&/todo Вот ваша мед.страховка, берите*протягивая бланк с мед.страховкой человеку напротив себя&/n @{get_nick({arg_id})}, примите предложение в /offer для получения' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'med' , description = 'Оформление игроку мед.карты' ,  text = 'Оформление мед. карты платное и зависит от её срока действия!&Мед. карта на 7 дней - ${get_price_med7}, на 14 дней - ${get_price_med14}.&Мед. карта на 30 дней - ${get_price_med30}, на 60 дней - ${get_price_med60}.&Скажите, вам на какой срок оформить мед. карту?&{show_medcard_menu}&Хорошо, тогда приступим к оформлению.&/me достаёт из своего мед.кейса пустую мед.карту, ручку и печать {fraction_tag}&/me открывает пустую мед.карту и начинает её заполнять, затем ставит печать {fraction_tag}&/me полностью заполнив мед.карту убирает ручку и печать обратно в свой мед.кейс&/todo Вот ваша мед.карта, берите*протягивая заполненную мед.карту человеку напротив себя&/medcard {arg_id} {get_medcard_status} {get_medcard_days} {get_medcard_price}&/n @{get_nick({arg_id})}, примите предложение в /offer для получения медкарты' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'recept' , description = 'Выдача игроку рецептов' ,  text = 'Стоимость одного рецепта составляет ${get_price_recept}&Скажите сколько Вам требуется рецептов, после чего мы продолжим.&/n Внимание! В течении часа выдаётся максимум 5 рецептов!&{show_recept_menu}&Хорошо, сейчас я выдам вам рецепты.&/me достаёт из своего мед.кейса бланк для оформления рецептов и начает его заполнять&/me ставит на бланк рецепта печать {fraction_tag}&/do Бланк успешно заполнен.&/todo Вот, держите!*передавая бланк  рецепта человеку напротив&/recept {arg_id} {get_recepts}' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'ant' , description = 'Выдача игроку антибиотиков' ,  text = 'Стоимость одного антибиотика составляет ${get_price_ant}&Скажите сколько Вам требуется антибиотиков, после чего мы продолжим.&/n Внимание! Вы можете купить от 1 до 20 антибитиков за один раз!&{show_ant_menu}&Хорошо, сейчас я выдам вам антибиотики.&/me открывает свой мед.кейс и достаёт из него пачку антибиотиков, после чего закрывает мед.кейс&/do Антибиотики находятся в руках.&/todo Вот держите, употребляйте их строго по рецепту!*передавая антибиотики человеку напротив&/antibiotik {arg_id} {get_ants}' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'osm' , description = 'Полный мед.осмотр игрока (РП)' ,  text = 'Хорошо, сейчас я проведу вам мед.осмотр.&Дайте мне вашу мед.карту для проверки.&/n @{get_nick({arg_id})}, введите /showmc {my_id} чтобы показать мне мед.карту.&{pause}&/me достаёт из мед.кейса стерильные перчатки и надевает их на руки&/do Перчатки на руках.&/todo Начнём мед.осмотр*улыбаясь.&Сейчас я проверю ваше горло, откройте рот и высуните язык.&/n Используйте /me открыл(-а) рот чтоб мы продолжили&{pause}&/me достаёт из мед.кейса фонарик и включив его осматривает горло человека напротив&Хорошо, можете закрывать рот, сейчас я проверю ваши глаза.&/me проверяет реакцию человека на свет, посветив фонарик в глаза&/do Зрачки глаз обследуемого человека сузились.&/todo Отлично*выключая фонарик и убирая его в мед.кейс&Такс, сейчас я проверю ваше сердцебиение, поэтому приподнимите верхную одежду!&/n @{get_nick({arg_id})}, введите /showtatu чтобы снять одежду по РП&{pause}&/me достаёт из мед.кейса стетоскоп и приложив его к груди человека проверяет сердцебиение&/do Сердцебиение в районе 65 ударов в минуту.&/todo С сердцебиением у вас все в порядке*убирая стетоскоп обратно в мед.кейс&/me снимает со своих рук использованные перчатки и выбрасывает их&Ну что-ж я могу вам сказать...&Со здоровьем у вас все в порядке, вы свободны!' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"} , 
					{cmd = 'gd' , description = 'Экстренный вызов (/godeath)' ,  text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me просматривает информацию и включает навигатор к выбранному месту экстренного вызова&/godeath {arg_id}' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'exp' , description = 'Выгнать игрока из больницы' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из больницы!&/me схватив человека ведёт к выходу из больницы и закрывает за ним дверь&/expel {arg_id} Н.П.Б.' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
				},
				smi = {
					{cmd = 'zd', description = 'Привествие игрока' , text = 'Здравствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}" , in_fastmenu = true},
					{cmd = 'go' , description = 'Позвать игрока за собой' , text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'expel' , description = 'Выгнать игрока из здания' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из здания!&/me схватив человека ведёт к выходу из здания и закрывает за ним дверь&/expel {arg_id} Н.П.Р.' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'live_sobes' , description = 'Собеседование' , text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Собеседование]: Доброго времени суток, уважаемые граждане Штата!&/news [Собеседование]: С Вами - Я, {fraction_rank} - {my_ru_nick}.&/news [Собеседование]: Давно мечтали изменить свою жизнь в лучшую сторону?&/news [Собеседование]: Поставить новые и не запланированные цели?&/news [Собеседование]: Спешу Вас обрадовать! Ведь именно сейчас ...&/news [Собеседование]: ... проходит собеседование в Радиоцентр {fraction_tag}!&/news [Собеседование]: Что нужно иметь для прохождения собеседования?&/news [Собеседование]: Критерии очень просты, при себе необходимо иметь: ...&/news [Собеседование]: ... Паспорт, мед. карту с отметкой Полностью здоров&/news [Собеседование]: Ведь именно у нас: Доброе и отзывчивое начальство ...&/news [Собеседование]: ... достойный карьерный рост и высокие зарплаты!&/news [Собеседование]: Заинтересовавшихся пройти собеседование ожидаем в ...&/news [Собеседование]: ... холле главного офиса {fraction_tag}.&/news [Собеседование]: А на этом наш эфир подходит к концу!&/news [Собеседование]: С Вами был - Я, {my_ru_nick}. До скорых встреч!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место", arg = '' , enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_mp1' , description = 'Викторина "Столицы"' , text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю эфирную волну! Просьба не перебивать.&/news •°•°•°•° Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Викторина]: Добрый день, уважаемые радиослушатели!&/news [Викторина]: У микрофона - {my_ru_nick}!&/news [Викторина]: Сегодня мы проведём - Столицы.&/news [Викторина]: Суть викторины такова: Я говорю вам страну, А вы мне её столицу.&/news [Викторина]: Ответы присылать на номер студии, его вы можете найти...&/news [Викторина]: ...в своём телефоне, в разделе: Контакты.&/news [Викторина]: Призовой Фонд сегодня составляет целый 1 милион долларов!&/news [Викторина]: Ну что же, давайте начинать.&/news [Викторина]: Открывает сегодняшний марафон стран поистине прекрасное государство.&/news [Викторина]: Страна, которая подарила миру необычную поп культуру. И это...&/news [Викторина]: ...Республика Корея. Или как её называют еще - Южная Корея.&{pause}&/news [Викторина]: Стоп! Наша студия получила правильный ответ.&/news [Викторина]: Правильный ответ - Сеул...&/news [Викторина]: ...густо населённый город с миллионом развлечений на любой вкус.&/news [Викторина]: Первый правильный ответ мы получили от гражданина...&{pause}&/news [Викторина]: Продолжаем. Следующее Государство известно во всём мире как страна футбола...&/news [Викторина]: ...и самбы - Бразилия.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: Как бы абсурдно это не звучало, столица страны Бразилия - Бразилиа.&/news [Викторина]: Ответов было много... Но самым быстрым оказался гражданин...&{pause}&/news [Викторина]: Большую часть следующего государства занимают трудно проходимые Джунгли...&/news [Викторина]: Я говорю о Вьетнаме.&{pause}&/news [Викторина]: На студию поступил правильный ответ!&/news [Викторина]: Столицей Вьетнама является город Ханой.&/news [Викторина]: Правильный ответ нам дал гражданин...&{pause}&/news [Викторина]: Вы, уважаемый радиослушатель, и правда не прогуливали географию в школе.&/news [Викторина]: Именно в этой стране находится действующий вулкан 'Кракатау'.&/news [Викторина]: ...Индонезия.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: И... Правильный ответ... Джакарта.&/news [Викторина]: Город контрастов, в котором переплелись разные языки и культуры...&/news [Викторина]: ...богатство и бедность.&/news [Викторина]: Уверен с этим городом знаком наш слушатель под именем...&{pause}&/news [Викторина]: Ведь именно он и дал правильный ответ!&/news [Викторина]: Густые леса, скалистые острова, горнолыжные курорты. Это всё про...&/news [Викторина]: ...страну - Финляндия.&{pause}&/news [Викторина]: Стоп! Наша студия получила правильный ответ.&/news [Викторина]: Правильным ответом является - Хельсинки! И этот ответ дал штата с именем...&{pause}&/news [Викторина]: Больше всего об этой стране знают лыжники и сноубордисты...&/news [Викторина]: ...Австрия.&/news [Викторина]: На студию поступил правильный ответ!&/news [Викторина]: Любой разговор об Австрии всегда сводится к ее столице, и не спроста.&/news [Викторина]: Ведь 'Вена' - крупнейший культурно-исторический центр Европы.&/news [Викторина]: Первым правильный ответ в студию прислал гражданин с именем...&{pause}&/news [Викторина]: И так, сейчас я озвучу победителя нашей викторины, вы готовы?&{pause}&/news [Викторина]: Просим победителя приехать к нам за наградой...&/news [Викторина]: На этом наша викторина окончена, спасибо всем вам за участие!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю эфирную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место", arg = '' , enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_mp2' , description = 'Викторина "Математика"' , text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю эфирную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Викторина]: Добрый день, уважаемые радиослушатели!&/news [Викторина]: У микрофона - {my_ru_nick}!&/news [Викторина]: Сегодня мы проведём викторину - Математика.&/news [Викторина]: Суть викторины: Я говорю вам примеры, а вы мне ответы на них.&/news [Викторина]: В примерах могут использоваться такие операторы, как...&/news [Викторина]: ...сложение +, умножение *, вычитание -, деление /.&/news [Викторина]: Ответы присылать на номер студии, его вы можете найти...&/news [Викторина]: ...в своём телефоне, в разделе: Контакты.&/news [Викторина]: Призовой Фонд сегодня составляет аж целых 500.000$!&/news [Викторина]: Ну что же, давайте начинать.&/news [Викторина]: Первый пример...&/news [Викторина]: ... '3 + 3 * 3'.&{pause}&/news [Викторина]: Стоп! На студию поступил верный ответ.&/news [Викторина]: Правильный ответ - '12'.&/news [Викторина]: Верный ответ нам дал гражданин с именем ...&{pause}&/news [Викторина]: Мы только начинаем разгоняться...&/news [Викторина]: ... '66 - 44 + 1'.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: Корректным ответом является - '23'.&/news [Викторина]: Первый правильный ответ мы получили от граждана ...&{pause}&/news [Викторина]: Следующий пример...&/news [Викторина]: ... '35 + 75'.&/news [Викторина]: И... У нас есть корректный ответ!&/news [Викторина]: И так, правильный ответ '110', и мы получили этот ответ от гражданина ...&{pause}&/news [Викторина]: Без лишних слов, следующий пример...&/news [Викторина]: ... '25 - 28 + 1'.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: Не ожидали отрицательных чисел в ответе? Правильный ответ - '-2'.&/news [Викторина]: Этот ответ нам подарил граждинин с именем ...&{pause}&/news [Викторина]: Давайте добавим разнообразия. Я загадаю пример при помощи...&/news [Викторина]: ...римских чисел. Ответ должен быть в виде римского числа!&/news [Викторина]: ... 'X - IV'.&{pause}&/news [Викторина]: Стоп! На студию поступил правильный ответ!&/news [Викторина]: Корректным ответом является - 'VI'.&/news [Викторина]: Самым быстрым был граждинин ...&{pause}&/news [Викторина]: Опять римские числа.&/news [Викторина]: ... 'XV - VIII'.&{pause}&/news [Викторина]: Стоп!&/news [Викторина]: 'VII' - верный ответ.&/news [Викторина]: Этот ответ нам подарил гражданин штата -&{pause}&/news [Викторина]: И... Последний пример с римскими числами на сегодня.&/news [Викторина]: ... 'XII - III'.&{pause}&/news [Викторина]: Стоп! Наша студия получила правильный ответ.&/news [Викторина]: Верный ответ - 'IX'. А первый ответчик - гражданин ...&{pause}&/news [Викторина]: И так, сейчас я озвучу победителя нашей викторины, вы готовы?&{pause}&/news [Викторина]: Просим победителя приехать к нам за наградой...&/news [Викторина]: На этом наша викторина окончена, спасибо всем вам за участие!/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю эфирную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место", arg = '' , enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_weather1', description = 'Прогноз погоды (утренний дождь)', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news Доброе утро, уважаемые радиослушатели!&/news У микрофона {fraction_rank} - {my_ru_nick}.&/news Сегодняшний день начался с пасмурной погоды и дождя.&/news Синоптики сообщают, что осадки продлятся до полудня, так что не забудьте взять зонт!&/news Ветер северо-западный, умеренный, но может усиливаться порывами до 15 м/c.&/news Температура воздуха +16°C, однако ощущается как +13°C.&/news Внимание водителям: дороги могут быть скользкими, соблюдайте дистанцию!&/news Ближе к обеду тучи начнут рассеиваться, а дождь прекратится.&/news А пока держитесь теплее и не забывайте наслаждаться свежестью после дождя!&/news На этом наш утренний прогноз погоды завершается.&/news С вами был {fraction_rank} - {my_ru_nick}.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место", arg = '', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = false},
					{cmd = 'live_weather2', description = 'Прогноз погоды (дневной)', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news Добрый день, дорогие радиослушатели!&/news У микрофона {fraction_rank} - {my_ru_nick}.&/news Сейчас самое время узнать, какая погода ждёт нас днём.&/news Температура воздуха в данный момент составляет +22°C, солнечно, но возможна переменная облачность.&/news Ветер южный, слабый, около 5 м/с, комфортные условия для прогулок.&/news Осадков не ожидается, но к вечеру возможны лёгкие порывы ветра.&/news Если планировали провести день на свежем воздухе — отличная возможность!&/news На этом наш дневной прогноз завершается.&/news С вами был {fraction_rank} - {my_ru_nick}. До скорых встреч!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_weather3', description = 'Прогноз погоды (вечерний торнадо)', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю новостную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news Добрый вечер, дорогие радиослушатели!&/news У микрофона {fraction_rank} - {my_ru_nick}.&/news И в нашем вечернем эфире речь пойдёт о прогнозе погоды.&/news Сейчас я вам зачитаю, что говорят нам наши синоптики...&/news В 21:52 предполагается песчаная буря, которая продлится всего несколько минут.&/news В связи с этим просим вас остаться дома и плотно закрыть окна и двери.&/news Также в районе Паломино Крит замечено торнадо.&/news Призываем Вас избегать поездок в этот район Штата.&/news И уже в 22:10 нас ожидает спокойная, ночная погода.&/news Но не стоит так сильно радоваться, ближе к ночи чередование спокойной погоды и песчаной бури продолжится.&/news С чем это связано - неизвестно! Но мы попытаемся уведомить Вас об изменениях как можно скорее.&/news А на этом наш эфир подходит к концу.&/news С вами был {fraction_rank} - {my_ru_nick}.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю новостную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_int1', description = 'Интервью (начало)', text = "/me нажимает на необходимые кнопки в аппаратуре, тем самым включает ее&/do Аппаратура включена и работает исправно.&/me проверяет на исправность аппаратуру и микрофон&/me берет наушники со столика и надевает их на свою голову&/todo Раз, раз, раз*стуча по микрофону.&/do Микрофон исправен и готов к работе.&/d [{fraction_tag}] - [СМИ]: Занимаю эфирную волну.&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/news [Интервью]: Здравствуйте, уважаемые радиослушатели!&/news [Интервью]: У микрофона - {my_ru_nick}!&/news [Интервью]: Сегодня у нас в гостях особый гость на интервью...&/news [Интервью]: Возможно многие из вас даже знают его, и так, наш гость это ...", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
					{cmd = 'live_int2', description = 'Интервью (конец)', text = "/news [Интервью]: И наш эфир к сожалению подходит к концу.&/news [Префикс]: С вами был Я - {my_ru_nick}.&/news [Интервью]: До свидания, штат! Не переключайтесь!&/news •°•°•°•°• Музыкальная заставка радиостанции {fraction_tag} •°•°•°•°•&/d [{fraction_tag}] - [СМИ]: Освобождаю эфирную волну!&/me нажимает на необходимые клавиши и выходит из эфира, после чего отключает микрофон&/do Эфир окончен и микрофон отключен.&/me снимает с головы наушники и кладет их на место", arg = '', enable = true, waiting = '6', bind = "{}", in_fastmenu = false},
				},
				fd = {
					{cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}"},
					{cmd = 'zd' , description = 'Привествие игрока' , text = 'Здравствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}" , in_fastmenu = true},
				},
				lc = {
					{cmd = 'zd' , description = 'Привествие игрока' , text = 'Здравствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь? Если нужна лицензия - скажите тип и срок', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Позвать игрока за собой', text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'gl' , description = 'Выдача лицензии игроку' , text = '/me взял{sex} со стола бланк на получение лицензии и заполнил{sex} его&/do Спустя некоторое время бланк на получение лицензии был заполнен.&/me распечатав лицензию передал{sex} её человеку напротив&/givelicense {arg_id}&Вот ваша лицензия, всего Вам хорошего!', arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'prices' , description = 'Ознакомить игрока с ценами' , text = '/todo Сейчас я скажу вам цены на лицензии*доставая изпод стойки бланк с ценами&/do Бланк с ценами всех лицензий в руках.&/me подвинул{sex} бланк поближе к себе и начал{sex} читать цены&На автомобиль: 1 месяц - ${get_price_avto1}, 2 месяца - ${get_price_avto2}, 3 месяца - ${get_price_avto3}&На мото: 1 месяц - ${get_price_moto1}, 2 месяца - ${get_price_moto2}, 3 месяца - ${get_price_moto3}&На водный: 1 месяц - ${get_price_swim1}, 2 месяца - ${get_price_swim2}, 3 месяца - ${get_price_swim3}&На полёты: 1 месяц - ${get_price_fly1}&На оружие: 1 месяц - ${get_price_gun1}, 2 месяца - ${get_price_gun2}, 3 месяца - ${get_price_gun3}&На охоту: 1 месяц - ${get_price_hunt1}, 2 месяца - ${get_price_hunt2}, 3 месяца - ${get_price_hunt3}&На рыбалку: 1 месяц - ${get_price_fish1}, 2 месяца - ${get_price_fish2}, 3 месяца - ${get_price_fish3}&На клады: 1 месяц - ${get_price_klad1}, 2 месяца - ${get_price_klad2}, 3 месяца - ${get_price_klad3}&На такси: 1 месяц - ${get_price_taxi1}, 2 месяца - ${get_price_taxi2}, 3 месяца - ${get_price_taxi3}&На механика: 1 месяц - ${get_price_mexa1}, 2 месяца - ${get_price_mexa2}, 3 месяца - ${get_price_mexa3}&/todo Вот такие у нас цены*убирая бланк с ценами' , arg = '' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'medka' , description = 'Запросить медкарту для проверки' , text = 'Чтобы получить эту лицензию, покажите мне вашу мед.карту&/n @{get_nick({arg_id})}, введите команду /showmc {my_id} чтобы показать мне мед.карту' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'exp' , description = 'Выгнать игрока из ЦЛ' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из ЦЛ!&/me схватив человека ведёт к выходу из ЦЛ и закрывает за ним дверь&/expel {arg_id} Н.П.Ц.Л.' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
				},
				ins = {
					{cmd = 'zd' , description = 'Привествие игрока' , text = 'Здравствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь? Если нужна лицензия - скажите тип и срок', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Позвать игрока за собой', text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'ins' , description = 'Предложить доп.услуги' ,  text = 'Я могу оформить "Семейный сертификат" или "Пенсионное страхование"&Что вам нужно? Страхование для депозита, сертификат для выплат&/insurance {arg_id}&/me достаёт нужные бумаги для оформления и передаёт их человеку напротив' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'exp' , description = 'Выгнать игрока из СТК' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из СТК!&/me схватив человека ведёт к выходу из СТК и закрывает за ним дверь&/expel {arg_id} Н.П.С.К.' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
				},
				gov = {		
					{cmd = 'zd' , description = 'Привествие игрока' , text = 'Здравствуйте, меня зовут {my_ru_nick}, чем я могу помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', in_fastmenu = true},
					{cmd = 'go' , description = 'Позвать игрока за собой' , text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}' , enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'visit' , description = 'Показать визитку адвоката' ,  text = '/me вытащил{sex} из нагрудного кармана визитку адвоката&/do На визитке написано: "{my_ru_nick}, адвокат штата".&/showvisit {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true} , 
					{cmd = 'freely' , description = 'Предложить услуги адвоката' ,  text = '/do Папка с документами находится в левой руке.&/me открыв папку, вытащил{sex} из неё бланк для освобождения заключённого&/me достав из кармана ручку, заполнил{sex} документ и передал{sex} человеку напротив&/todo Впишите сюда свои данные и поставьте подпись снизу*передавая лист с ручкой&/free {arg_id} {arg2}' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.5'},
					{cmd = 'visa' , description = 'Выдать рабочую визу для VC' ,  text = 'Стоимость услуги составляет 600 тысяч. Вы согласны?&Если да, то приступаем к оформлению&{pause}&/do Бланк для оформления визы находится в кармане.&/me засунув руку в карман, взял{sex} бланк, после чего протянул{sex} его человеку напротив&/todo Впишите сюда Ваши данные и поставьте подпись снизу*протягивая лист с ручкой&/givevisa {arg_id}', arg = '{arg_id}' , enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'car' , description = 'Превратить личный т/c в сертификат' , text = 'Перед тем, как начать, попрошу полностью опустошить багажник и снять весь тюнинг&А также убедиться, что пробег меньше либо равен 200 км&Если Вы все сделали, то можем приступать&{pause}&Окей, приступаем&/do Бланк для получения сертификата находится под в кармане.&/me засунув руку в карман, взял{sex} бланк, после чего протянул{sex} его человеку напротив&/todo Впишите сюда Ваши данные и поставьте подпись снизу*протягивая лист с ручкой&/givepass {arg_id}', arg = '{arg_id}' , enable = true, waiting = '1.5', in_fastmenu = true},
					{cmd = 'wed' , description = 'Заключение брака' ,  text = 'Добрый день, уважаемые новобрачные и гости!&Уважаемые невеста и жених!&Сегодня - самое прекрасное и незабываемое событие в вашей жизни.&Создание семьи – это начало доброго союза двух любящих сердец.&С этого дня вы пойдёте по жизни рука об руку, вместе переживая и радость счастливых дней, и огорчения.&Создавая семью, вы добровольно приняли на себя великий долг друг перед другом и перед будущим ваших детей.&Перед началом регистрации прошу вас ещё раз подтвердить, является ли ваше решение стать супругами, создать семью&{pause}&С вашего взаимного согласия, выраженного в присутствии свидетелей, ваш брак регистрируется.&Прошу вас в знак любви и преданности друг другу обменяться обручальными кольцами.&/wedding {arg_id} {arg2}' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.5'},
					{cmd = 'pass' , description = 'Исправить дату рождения в паспорте' ,  text = '/do Бланк для замены информации в паспорте находится в кармане.&/me засунув руку в карман, взял{sex} бланк, после чего протянул{sex} его человеку напротив&/todo Впишите сюда новую дату и поставьте подпись снизу*протягивая лист с ручкой&/givepass {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.5'},	
					{cmd = 'frisk', description = 'Обыск (7+)', text = '/do Перчатки находятся в кармане.&/me взял{sex} перчатки с кармана и надел{sex} их&/do Перчатки одеты.&/me начал нащупывать человека напротив&/frisk {arg_id}&/me полностью прощупав человека убрал{sex} перчатки обратно в карман', arg = '{arg_id}', enable = false, waiting = '1.5' },
					{cmd = 'exp' , description = 'Выгнать игрока из правительства' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из Мэрии!&/me схватив человека ведёт к выходу из мэрии и закрывает за ним дверь&/expel {arg_id} Н.П.П.' , arg = '{arg_id}' , enable = true , waiting = '1.5', in_fastmenu = true},
				},
				mafia = {
					{cmd = 'tie', description = 'Связать жертву', text = '/do В кармане бронежилета лежит шпагат.&/me легким движением руки достал{sex} из кармана шпагат&/me обвязывает руки жертвы веревкой и стягивает её&/tie {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'untie', description = 'Развязать жертву', text = '/do На правом бедре закреплено тактическое крепление для ножа.&/me движением правой руки открепив нож, берёт его в руки&/do В правой руке держит нож.&/me подойдя к жертве со спины, отрезал{sex} верёвку&/untie {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'lead', description = 'Вести жертву за собой', text = '/me движением руки схватив за шкирку жертвы, ведёт его за собой&/lead {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'unlead', description = 'Прекратить вести жертву', text = '/me расслабив схватку, перестаёт контролировать жертву&/unlead {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'gag', description = 'Заткнуть рот жертве тряпкой', text = '/do На поясе закреплена сумка.&/me правой рукой отстегнув молнию, открывает сумку&/do Внутри сумки лежит тряпка.&/me подходя к жертве, попутно достал{sex} из сумки тряпку&/do Тряпка в руках в развёрнутом виде.&/me обеими руками завернув тряпку, запихнул{sex} в рот жертвы&/gag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true},
					{cmd = 'ungag', description = 'Вытащить тряпку изо рта жертвы', text = '/me подойдя ближе к жертве, движением правой руки потянул{sex} за тряпку и забрал{sex} себе&/ungag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'bag', description = 'Надеть пакет на голову жертвы', text = '/do В кармане куртки лежит мусорный пакет.&/me достал{sex} мусорный пакет из кармана, развернул{sex} его&/me надевает мусорный пакет на голову жертвы, не затягивая его&/bag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{cmd = 'unbag', description = 'Снять пакет с головы жертвы', text = '/me легким движением руки схватив за пакет, потянул{sex} его вверх, тем самым стянув пакет с головы жертвы&/unbag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true},
					{cmd = 'inсar', description = 'Затолкать жертву в фургон', text = '/me открывает двери фургона&/me берет жертву под руки и заталкивает вперёд головой в фургон&/me закрывает двери и садится в фургон&/incar {arg_id} 3', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true},
				},
				ghetto = {}
			},
			commands_manage = {
				my = {},
				goss = {
					{cmd = 'inv' , description = 'Принятие игрока в организацию' , text = '/do В кармане есть связка с ключами от раздевалки.&/me достаёт из кармана один ключ из связки ключей от раздевалки&/todo Возьмите, это ключ от нашей раздевалки*передавая ключ человеку напротив&/invite {arg_id}&/n @{get_nick({arg_id})} , примите предложение в /offer чтобы получить инвайт!' , arg = '{arg_id}', enable = true, waiting = '1.5'  , bind = "{}", in_fastmenu = true  },
					{cmd = 'rp' , description = 'Выдача сотруднику /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true  },
					{cmd = 'gr' , description = 'Повышение/понижение cотрудника' , text = '{show_rank_menu}&/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/giverank {arg_id} {get_rank}&/r Сотрудник {get_ru_nick({arg_id})} получил новую должность!' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true   },
					{cmd = 'vize' , description = 'Управление Vice City визой сотрудника' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&{lmenu_vc_vize}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true    },
					{cmd = 'cjob' , description = 'Посмотреть успешность сотрудника' , text = '/checkjobprogress {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true   },	
					{cmd = 'fmutes' , description = 'Выдать мут сотруднику (10 min)' , text = '/fmutes {arg_id} Н.У.&/r Сотрудник {get_ru_nick({arg_id})} лишился права использовать рацию на 10 минут!' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"   },
					{cmd = 'funmute' , description = 'Снять мут сотруднику' , text = '/funmute {arg_id}&/r Сотрудник {get_ru_nick({arg_id})} теперь может пользоваться рацией!' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true   },
					{cmd = 'vig' , description = 'Выдача выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/fwarn {arg_id} {arg2}&/r Сотруднику {get_ru_nick({arg_id})} выдан выговор! Причина: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5'  , bind = "{}"},
					{cmd = 'unvig' , description = 'Снятие выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/unfwarn {arg_id}&/r Сотруднику {get_ru_nick({arg_id})} был снят выговор!' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}" , in_fastmenu = true  },
					{cmd = 'unv' , description = 'Увольнение игрока из фракции' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает свой телефон обратно в карман&/uninvite {arg_id} {arg2}&/r Сотрудник {get_ru_nick({arg_id})} был уволен по причине: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"   },
					{cmd = 'point' , description = 'Установить метку для сотрудников' , text = '/r Срочно выдвигайтесь ко мне, отправляю вам координаты...&/point' , arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'govka' , description = 'Собеседование по госс.волне' , text = '/d [{fraction_tag}] - [Всем]: Занимаю государственную волну, просьба не перебивать!&/gov [{fraction_tag}]: Доброго времени суток, уважаемые жители нашего штата!&/gov [{fraction_tag}]: Сейчас проходит собеседование в организацию {fraction}&/gov [{fraction_tag}]: Для вступления вам нужно иметь документы и приехать к нам в холл.&/d [{fraction_tag}] - [Всем]: Освобождаю  государственную волну, спасибо что не перебивали.' , arg = '', enable = true, waiting = '1.5', bind = "{}"},
				},
				goss_fbi = {
					{cmd = 'demoute' , description = 'Уволить госслужащего' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me заходит в базу данных {fraction_tag} и переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/demoute {arg_id} {arg2}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = false, waiting = '1.5', bind = "{}"},
				},
				goss_prison = {
					{cmd = 'unpunish', description = 'Выпуск заключённых из ТСР', text = '/me лёгкими движениями рук берёт дело заключённого с полки, кладёт его на стол&/do На столе лежит ручка и печать.&/me лёгким движением правой руки берёт ручку, заполняет поле в деле заключённого&/me лёгкими движениями рук кладёт ручку на стол, берёт печать и ставит её в деле&/me лёгкими движениями рук ставит печать на стол, после чего закрывает дело&Ваш срок укорочен, возвращайтесь в камеру и ожидайте ...&... транспортировки до ближайшего населённого пункта.&/unpunish {arg_id} {arg2}', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5'},
					{cmd = 'rjailreklama', description = 'Реклама УДО', text = '/rjail Доброго времени суток заключенные.&/rjail В данный момент Вы можете покинуть тюрьму досрочно, через кабинет начальства тюрьмы.&/rjail Обратите внимание, УДО (условно дорочное освобожение) платное!&/rjail Спасибо за внимание.', arg = '', enable = true, waiting = '1.5'}
				},
				goss_gov = {
					{cmd = 'lic' , description = 'Выдать лицензию адвоката' , text = '/do Бланк для выдачи лицензии находится под столом.&/me засунув руку под стол, взял{sex} бланк, после чего заполнил{sex} его нужной информацией&/todo Впишите сюда Ваши данные и поставьте подпись снизу*передавая бланк и ручку&/givelicadvokat {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', },
					{cmd = 'demoute' , description = 'Уволить госслужащего' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me заходит в базу данных {fraction_tag} и переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/demoute {arg_id} {arg2}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = false, waiting = '1.5', bind = "{}"},
				},
				mafia = {
					{cmd = 'inv' , description = 'Принятие игрока в организацию' , text = '/do В кармане есть связка с ключами от раздевалки.&/me достаёт из кармана один ключ из связки ключей от раздевалки&/todo Возьмите, это ключ от нашей раздевалки*передавая ключ человеку напротив&/invite {arg_id}&/n @{get_nick({arg_id})} , примите предложение в /offer чтобы получить инвайт!' , arg = '{arg_id}', enable = true, waiting = '1.5'  , bind = "{}"},
					{cmd = 'rp' , description = 'Выдача сотруднику /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"},
					{cmd = 'gr' , description = 'Повышение/понижение cотрудника' , text = '{show_rank_menu}&/todo Вот тебе новая форма!*протягивая форму человеку напротив &/giverank {arg_id} {get_rank}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"   },
					{cmd = 'fmutes' , description = 'Выдать мут сотруднику (10 min)' , text = '/fmutes {arg_id} Подумай о своём поведении' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"   },
					{cmd = 'funmute' , description = 'Снять мут сотруднику' , text = '/funmute {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"   },
					{cmd = 'vig' , description = 'Выдача выговора' , text = '/f {get_ru_nick({arg_id})}, ты провинился(-лась) в {arg2}!&/fwarn {arg_id} {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5'  , bind = "{}"},
					{cmd = 'unvig' , description = 'Снятие выговора cотруднику' , text = '/f {get_ru_nick({arg_id})}, ты прощён(-а)!&unfwarn {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"   },
					{cmd = 'unv' , description = 'Увольнение игрока из фракции' , text = '/me забирает организационную форму у человека&/uninvite {arg_id} {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}"   },
					{cmd = 'point' , description = 'Установить метку для сотрудников' , text = '/f Срочно выдвигайтесь ко мне, отправляю вам координаты...&/point' , arg = '', enable = true, waiting = '1.5', bind = "{}"},
				},
				ghetto = {}
			}
		}
	},
	notes = {
		name = 'Заметки',
		path = configDirectory .. "/Notes.json",
		data = {
			{ note_name = 'Зарплата в фракции', note_text = 'Почему ваша зарплата может быть меньше, чем указано:&-20 процентов если нету жилья (дом/отель/трейлер)&-20/-40 процентов если у вас есть выговоры&-10 процентов из-за фикса экономики от разрабов&&Способы повысить свою зарплату во фракции:&+10 процентов если арендовать номер в отеле&+7 процентов если вступить в семью с фам.флагом&+15 процентов если есть \"Военный билет\"&+11 процентов если есть \"Грамота Ветерана\"&+3 процента если есть акс \"Оранжевая магическая шляпа\"&+10/+15/+20/+25/+26/+30/+35 процентов если купить охранника&- Повышайтесь на ранг повыше :)'},
		}
	},
	rpgun = {
		name = 'RP оружие',
		path = configDirectory .. "/Guns.json",
		data = {
            rp_guns = {
                {id = 0, name = 'кулаки', enable = true, rpTake = 2},
				{id = 1, name = 'кастеты', enable = false, rpTake = 2},
				{id = 2, name = 'клюшку для гольфа', enable = false, rpTake = 1},
				{id = 3, name = 'дубинку', enable = true, rpTake = 3},
				{id = 4, name = 'острый нож', enable = false, rpTake = 3},
				{id = 5, name = 'биту', enable = false, rpTake = 1},
				{id = 6, name = 'лопату', enable = true, rpTake = 1},
				{id = 7, name = 'кий', enable = false, rpTake = 1},
				{id = 8, name = 'катану', enable = false, rpTake = 1},
				{id = 9, name = 'бензопилу', enable = false, rpTake = 1},
				{id = 10, name = 'игрушку', enable = false, rpTake = 2},
				{id = 11, name = 'большую игрушку', enable = false, rpTake = 2},
				{id = 12, name = 'моторную игрушку', enable = false, rpTake = 2},
				{id = 13, name = 'большую игрушку', enable = false, rpTake = 2},
				{id = 14, name = 'букет цветов', enable = true, rpTake = 1},
				{id = 15, name = 'трость', enable = false, rpTake = 1},
				{id = 16, name = 'осколочную гранату', enable = false, rpTake = 3},
				{id = 17, name = 'дымовую гранату', enable = true, rpTake = 3},
				{id = 18, name = 'коктейль Молотова', enable = true, rpTake = 3},
				{id = 22, name = 'пистолет Colt45', enable = false, rpTake = 4},
				{id = 23, name = "электрошокер Taser X26P", enable = true, rpTake = 4},
				{id = 24, name = 'пистолет Desert Eagle', enable = true, rpTake = 4},
				{id = 25, name = 'дробовик', enable = true, rpTake = 1},
				{id = 26, name = 'обрез', enable = true, rpTake = 4},
				{id = 27, name = 'улучшенный обрез', enable = false, rpTake = 1},
				{id = 28, name = 'ПП Micro Uzi', enable = true, rpTake = 3},
				{id = 29, name = 'ПП MP5', enable = true, rpTake = 4},
				{id = 30, name = 'автомат AK47', enable = true, rpTake = 1},
				{id = 31, name = 'автомат M4', enable = true, rpTake = 1},
				{id = 32, name = 'ПП Tec9', enable = true, rpTake = 4},
				{id = 33, name = 'винтовку Rifle', enable = true, rpTake = 1},
				{id = 34, name = 'снайперскую винтовку', enable = true, rpTake = 1},
				{id = 35, name = 'РПГ', enable = false, rpTake = 1},
				{id = 36, name = 'ПТУР', enable = false, rpTake = 1},
				{id = 37, name = 'огнемёт', enable = false, rpTake = 1},
				{id = 38, name = 'миниган', enable = false, rpTake = 1},
				{id = 39, name = 'динамит', enable = false, rpTake = 3},
				{id = 40, name = 'детонатор', enable = false, rpTake = 3},
				{id = 41, name = 'перцовый балончик', enable = true, rpTake = 2},
				{id = 42, name = 'огнетушитель', enable = true, rpTake = 1},
				{id = 43, name = 'фотоапарат', enable = true, rpTake = 2},
				{id = 44, name = 'ПНВ', enable = false, rpTake = 3},
				{id = 45, name = 'тепловизор', enable = false, rpTake = 3},
				{id = 46, name = 'парашут', enable = true, rpTake = 1},
				-- gta sa damage reason
				{id = 49, name = 'т/с', enable = false, rpTake = 1},
				{id = 50, name = 'лопасти вертолёта', enable = false, rpTake = 1},
				{id = 51, name = 'гранату', enable = false, rpTake = 1},
				{id = 54, name = 'коллизию/тюнинг', enable = false, rpTake = 1},
				-- ARZ CUSTOM GUN
				{id = 71, name = 'пистолет Desert Eagle Steel', enable = true, rpTake = 4},
				{id = 72, name = 'пистолет Desert Eagle Gold', enable = true, rpTake = 4},
				{id = 73, name = 'пистолет Glock Gradient', enable = true, rpTake = 4},
				{id = 74, name = 'пистолет Desert Eagle Flame', enable = true, rpTake = 4},
				{id = 75, name = 'пистолет Python Royal', enable = true, rpTake = 4},
				{id = 76, name = 'пистолет Python Silver', enable = true, rpTake = 4},
				{id = 77, name = 'автомат AK-47 Roses', enable = true, rpTake = 1},
				{id = 78, name = 'автомат AK-47 Gold', enable = true, rpTake = 1},
				{id = 79, name = 'пулемёт M249 Graffiti', enable = true, rpTake = 1},
				{id = 80, name = 'золотую Сайгу', enable = true, rpTake = 1},
				{id = 81, name = 'ПП Standart', enable = true, rpTake = 4},
				{id = 82, name = 'пулемёт M249', enable = true, rpTake = 1},
				{id = 83, name = 'ПП Skorp', enable = true, rpTake = 4},
				{id = 84, name = 'автомат AKS74 камуфляжный', enable = true, rpTake = 1},
				{id = 85, name = 'автомат AK47 камуфляжный', enable = true, rpTake = 1},
				{id = 86, name = 'дробовик Rebecca', enable = true, rpTake = 1},
				{id = 87, name = 'портальную пушку', enable = true, rpTake = 1},
				{id = 88, name = 'ледяной меч', enable = true, rpTake = 1},
				{id = 89, name = 'портальную пушку', enable = true, rpTake = 4},
				{id = 90, name = 'оглушающую гранату', enable = true, rpTake = 3},
				{id = 91, name = 'ослепляющую гранату', enable = true, rpTake = 3},
				{id = 92, name = 'снайперскую винтовку TAC50', enable = true, rpTake = 1},
				{id = 93, name = 'оглушающий пистолет', enable = true, rpTake = 4},
				{id = 94, name = 'снежную пушку', enable = true, rpTake = 1},
				{id = 95, name = 'пиксельный бластер', enable = true, rpTake = 3},
				{id = 96, name = 'автомат M4 Gold', enable = true, rpTake = 1},
				{id = 97, name = 'бандитский дробовик', enable = true, rpTake = 1},
				{id = 98, name = 'ПП Uzi Graffiti', enable = true, rpTake = 4},
				{id = 99, name = 'золотую монтировку', enable = true, rpTake = 1},
				{id = 100, name = 'биту Compton', enable = true, rpTake = 1},
				{id = 101, name = 'пистолет SciFi Deagle', enable = true, rpTake = 4},
				{id = 102, name = 'автомат SciFi AK47', enable = true, rpTake = 1},
				{id = 103, name = 'дробовик SciFi', enable = true, rpTake = 1},
				{id = 104, name = 'нож SciFi', enable = true, rpTake = 3},
				{id = 105, name = 'сканер', enable = false, rpTake = 4},
				{id = 106, name = 'золотой нож', enable = true, rpTake = 3},
				{id = 107, name = 'катану Нир', enable = true, rpTake = 1},
            },
            rpTakeNames = {
				{"из-за спины", "за спину"},
				{"из кармана", "в карман"},
				{"из пояса", "на пояс"},
				{"из кобуры", "в кобуру"}
			},
            gunActions = {
                on = {},
                off = {},
                partOn = {},
                partOff = {}
            },
            oldGun = nil,
            nowGun = 0
        }
	},
    smart_uk = {
		name = 'Умный Розыск',
		path = configDirectory .. "/SmartUK.json",
		data = {}
	},
    smart_pdd = {
		name = 'Умные Штрафы',
		path = configDirectory .. "/SmartPDD.json",
		data = {}
	},
    smart_rptp = {
		name = 'Умный Срок',
		path = configDirectory .. "/SmartRPTP.json",
		data = {}
	},
	arz_veh = {
		name = 'Транспорт',
		path = configDirectory .. "/Vehicles.json",
		data = {},
		cache = {}
	},
	ads_history = {
		name = 'История Объявлений',
		path = configDirectory .. "/ADS.json",
		data = {}
	}
}
function load_module(key)
    local obj = modules[key]
	if not obj then
		print('Ошибка: неизвестный модуль "' .. key .. '"!')
	else
		if doesFileExist(obj.path) then
			local file, errstr = io.open(obj.path, 'r')
			if file then
				local contents = file:read('*a')
				file:close()
				if #contents == 0 then
					print('Не удалось открыть модуль "' .. obj.name .. '". Причина: файл пустой')
				else
					local result, loaded = pcall(decodeJson, contents)
					if result then
						obj.data = loaded
						print('Модуль "' .. obj.name .. '" инициализирован! (есть ваши кастомные данные)')
					else
						print('Не удалось открыть модуль "' .. obj.name .. '". Ошибка: decode json')
					end
				end
			else
				print('Не удалось открыть модуль "' .. obj.name .. '". Ошибка: ' .. tostring(errstr or "неизвестная"))
			end
		else
			print('Модуль "' .. obj.name .. '" инициализирован!')
		end
	end
end
function save_module(key)
    local obj = modules[key]
	if not obj then
		print('Ошибка: неизвестный модуль "' .. key .. '"!')
	else
		local file, errstr = io.open(obj.path, 'w')
		if file then
			local function looklike(array)
				local dkok, dkjson = pcall(require, "dkjson")
				if dkok then
					local ok, encoded = pcall(dkjson.encode, array, {indent = true})
					if ok then return encoded end
				else
					local ok, encoded = pcall(encodeJson, array)
					if ok then return encoded end
				end
			end
			local content = looklike(obj.data)
			if content then
				file:write(content)
				print('Модуль "' .. obj.name .. '" сохранён!')
			else
				print('Не удалось сохранить модуль "' .. obj.name .. '" - ошибка кодировки json!')
			end
			file:close()
		else
			print('Не удалось сохранить модуль "' .. obj.name .. '", ошибка: ' .. tostring(errstr or "неизвестная"))
		end
	end
end
------------------------------------------- GUI & MODULES ----------------------------------------
local MODULE = {
	Initial = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		slider = imgui.new.int(0),
		step = 0,
		fraction_type_selector = 0,
		fraction_type_selector_text = 'Без организации',
		fraction_type_icon = nil,
		step2_result = 0,
		fraction_selector = 0,
		fraction_selector_text = '',
	},
	Main = {
		Window = imgui.new.bool(),
		theme = imgui.new.int(tonumber(settings.general.helper_theme)),
		slider = imgui.new.int(),
		slider_dpi = imgui.new.float(tonumber(settings.general.custom_dpi)),
		input = imgui.new.char[256](),
		checkbox = {
			accent_enable = imgui.new.bool(settings.player_info.accent_enable or false),
			mobile_stop_button = imgui.new.bool(settings.general.mobile_stop_button or false),
			mobile_fastmenu_button = imgui.new.bool(settings.general.mobile_fastmenu_button or false),
			dep_anti_skobki = imgui.new.bool(settings.departament.anti_skobki or false),
			-- payday_notify = imgui.new.bool(settings.general.payday_notify or false),
			-- auto_accept_docs = imgui.new.bool(settings.general.auto_accept_docs or false),
			-- auto_update_members = imgui.new.bool(settings.general.auto_update_members or false),
			-- auto_mask = imgui.new.bool(settings.general.auto_mask or false),
			
			-- MJ 
			mobile_taser_button = imgui.new.bool(settings.mj.mobile_taser_button or false),
			mobile_meg_button = imgui.new.bool(settings.mj.mobile_meg_button or false),
			-- auto_change_code_siren = imgui.new.bool(settings.mj.auto_change_code_siren or false),
			-- auto_doklad_patrool = imgui.new.bool(settings.mj.auto_doklad_patrool or false),
			-- auto_doklad_damage = imgui.new.bool(settings.mj.auto_doklad_damage or false),
			-- auto_doklad_arrest = imgui.new.bool(settings.mj.auto_doklad_arrest or false),
			-- auto_time = imgui.new.bool(settings.mj.auto_time or false),
			-- auto_update_wanteds = imgui.new.bool(settings.mj.auto_update_wanteds or false),
			-- auto_case_documentation = imgui.new.bool(settings.mj.auto_case_documentation or false),
			-- awanted = imgui.new.bool(settings.mj.awanted or false),

			-- auto_clicker_situation = imgui.new.bool((isMode('police') or isMode('fbi')) and settings.mj.auto_clicker_situation or settings.mh.auto_clicker_situation)
			-- MD
			-- auto_doklad_patrool = imgui.new.bool(settings.md.auto_doklad_patrool or false),
			-- auto_doklad_damage = imgui.new.bool(settings.md.auto_doklad_damage or false),
		},
		mmcolor = imgui.new.float[3](),
		msgcolor = imgui.new.float[3](),
	},
	Binder = {
		Window = imgui.new.bool(),
		waiting_slider = imgui.new.float(0),
		ComboTags = imgui.new.int(),
		input_cmd = imgui.new.char[256](),
		input_description = imgui.new.char[256](),
		input_text = imgui.new.char[8192](),
		item_list = {
			u8('Без аргументов'),
			u8('{arg} Любое значение'),
			u8('{arg_id} ID игрока | Пример /cure 429'),
			u8('{arg_id} ID {arg2} любое значение | Пример /vig 429 Без бейджика'),
			u8('{arg_id} ID {arg2} число {arg3} любое | Пример /su 429 2 Неподчинение'),
			u8('{arg_id} ID {arg2} число {arg3} любое {arg4} любое | Пример /carcer 429 1 5 Н.П.Т')
		},
		ImItems = imgui.new['const char*'][6]({
			u8('Без аргументов'),
			u8('{arg} Любое значение'),
			u8('{arg_id} ID игрока | Пример /cure 429'),
			u8('{arg_id} ID {arg2} любое значение | Пример /vig 429 Без бейджика'),
			u8('{arg_id} ID {arg2} число {arg3} любое | Пример /su 429 2 Неподчинение'),
			u8('{arg_id} ID {arg2} число {arg3} любое {arg4} любое | Пример /carcer 429 1 5 Н.П.Т')
		}),
		data = {
			change_waiting = nil,
			change_cmd = nil,
			change_text = nil,
			change_arg = nil,
			change_bind = nil,
			change_in_fastmenu = false,
			create_command_9_10 = false,
			input_description = nil
		},
		state = {
			isActive = false,
			isStop = false,
			isPause = false
		},
		tags = {},
		tags_text = ''
	},
	Note = {
		Window = imgui.new.bool(),
		input_text = imgui.new.char[1048576](),
		input_name = imgui.new.char[256](),
		show_note_name = '',
		show_note_text = '',
	},
	Members = {
		Window = imgui.new.bool(),
		all = {},
		new = {},
		upd = {},
		info = {fraction = '', check = false},
	},
	RPWeapon = {
		Window = imgui.new.bool(),
		ComboTags = imgui.new.int(),
		item_list = {u8'Спина', u8'Карман', u8'Пояс', u8'Кобура'},
		ImItems = imgui.new['const char*'][4]({u8'Спина', u8'Карман', u8'Пояс', u8'Кобура'}),
		input_search = imgui.new.char[256]('')
	},
	CruiseControl = {
		enable = imgui.new.bool(settings.general.cruise_control),
		active = false,
		wait_point = false,
		point = {x = 0, y = 0, z = 0}
	},
	-- goss
	Departament = {
		Window = imgui.new.bool(),
		text = imgui.new.char[256](),
		fm = imgui.new.char[32](u8(settings.departament.dep_fm)),
		tag1 = imgui.new.char[32](u8(settings.departament.dep_tag1)),
		tag2 = imgui.new.char[32](u8(settings.departament.dep_tag2)),
		new_tag = imgui.new.char[32]()
	},
	Post = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		name = '',
		code = 'CODE 4',
		active = false,
		start_time = 0,
		current_time = 0,
		time = 0,
		process_doklad = false,
		ComboCode = imgui.new.int(5),
		combo_code_list = {'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'},
		ImItemsCode = imgui.new['const char*'][14]({'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'})
	},
	-- mj
	Wanted = {
		Window = imgui.new.bool(),
		updwanteds = {},
		wanted = {},
		wanted_new = {},
		check_wanted = false,
	},
	Megafon = {
		Window = imgui.new.bool()
	},
	Taser = {
		Window = imgui.new.bool()
	},
	Patrool = {
		Window = imgui.new.bool(),
		active = false,
		start_time = 0,
		current_time = 0,
		time = 0,
		process_doklad = false,
		code = 'CODE 4',
		mark = 'ADAM',
		ComboMark = imgui.new.int(1),
		combo_mark_list = {'ADAM', 'LINCOLN', 'MARY', 'HENRY', 'AIR', 'ASD', 'CHARLIE', 'ROBERT', 'SUPERVISOR', 'DAVID', 'EDWARD', 'NORA'},
		ImItemsMark = imgui.new['const char*'][12]({'ADAM', 'LINCOLN', 'MARY', 'HENRY', 'AIR', 'ASD', 'CHARLIE', 'ROBERT', 'SUPERVISOR', 'DAVID', 'EDWARD', 'NORA'}),
		ComboCode = imgui.new.int(5),
		combo_code_list = {'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'},
		ImItemsCode = imgui.new['const char*'][14]({'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'})
	},
	SumMenu = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
		form_su = '',
	},
	TsmMenu = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
	},
	-- prison
	PumMenu = {
		Window = imgui.new.bool(),
		input = imgui.new.char[256](),
	},
	-- hospital
	MedCard = {
		Window = imgui.new.bool(),
		days = imgui.new.int(3),
		status = imgui.new.int(3)
	},
	Recept = {
		Window = imgui.new.bool(),
		recepts = imgui.new.int(1)
	},
	Antibiotik = {
		Window = imgui.new.bool(),
		ants = imgui.new.int(1)
	},
	HealChat = {
		Window = imgui.new.bool(),
		bool = false,
		player_id = nil,
		worlds = {'вылечи', 'лечи', 'хил', 'лек', 'heal', 'hil', 'lek', 'табл', 'болит', 'голова', 'лекни' , 'ktr', 'ktxb', 'ujkjdf'},
		healme = false
	},
	GoDeath = {
		player_id = nil,
		locate = '',
		city = ''
	},
	MedicalPrice = {
		heal         = imgui.new.char[12](u8(settings.mh.price.heal)),
		heal_vc      = imgui.new.char[12](u8(settings.mh.price.heal_vc)),
		healactor    = imgui.new.char[12](u8(settings.mh.price.healactor)),
		healactor_vc = imgui.new.char[12](u8(settings.mh.price.healactor_vc)),
		medosm       = imgui.new.char[12](u8(settings.mh.price.medosm)),
		mticket      = imgui.new.char[12](u8(settings.mh.price.mticket)),
		healbad      = imgui.new.char[12](u8(settings.mh.price.healbad)),
		recept       = imgui.new.char[12](u8(settings.mh.price.recept)),
		ant          = imgui.new.char[12](u8(settings.mh.price.ant)),
		med7         = imgui.new.char[12](u8(settings.mh.price.med7)),
		med14        = imgui.new.char[12](u8(settings.mh.price.med14)),
		med30        = imgui.new.char[12](u8(settings.mh.price.med30)),
		med60        = imgui.new.char[12](u8(settings.mh.price.med60)),
	},
	-- SMI
	SmiEdit = {
		Window = imgui.new.bool(),
		input_edit_text = imgui.new.char[256](),
		input_ads_search = imgui.new.char[256](),
		ad_message = '',
		ad_from = '',
		ad_dialog_id = '',
		adshistory_orig = '',
		adshistory_input_text = imgui.new.char[512](),
		skip_dialogd = false,
		ad_repeat_count = 0,
		last_ad_text = "",
	},
	-- AS
	LicensePrice = {
		avto1 = imgui.new.char[12](u8(settings.lc.price.avto1)),
		avto2 = imgui.new.char[12](u8(settings.lc.price.avto2)),
		avto3 = imgui.new.char[12](u8(settings.lc.price.avto3)),
		moto1 = imgui.new.char[12](u8(settings.lc.price.moto1)),
		moto2 = imgui.new.char[12](u8(settings.lc.price.moto2)),
		moto3 = imgui.new.char[12](u8(settings.lc.price.moto3)),
		fish1 = imgui.new.char[12](u8(settings.lc.price.fish1)),
		fish2 = imgui.new.char[12](u8(settings.lc.price.fish2)),
		fish3 = imgui.new.char[12](u8(settings.lc.price.fish3)),
		swim1 = imgui.new.char[12](u8(settings.lc.price.swim1)),
		swim2 = imgui.new.char[12](u8(settings.lc.price.swim2)),
		swim3 = imgui.new.char[12](u8(settings.lc.price.swim3)),
		gun1 = imgui.new.char[12](u8(settings.lc.price.gun1)),
		gun2 = imgui.new.char[12](u8(settings.lc.price.gun2)),
		gun3 = imgui.new.char[12](u8(settings.lc.price.gun3)),
		hunt1 = imgui.new.char[12](u8(settings.lc.price.hunt1)),
		hunt2 = imgui.new.char[12](u8(settings.lc.price.hunt2)),
		hunt3 = imgui.new.char[12](u8(settings.lc.price.hunt3)),
		klad1 = imgui.new.char[12](u8(settings.lc.price.klad1)),
		klad2 = imgui.new.char[12](u8(settings.lc.price.klad2)),
		klad3 = imgui.new.char[12](u8(settings.lc.price.klad3)),
		taxi1 = imgui.new.char[12](u8(settings.lc.price.taxi1)),
		taxi2 = imgui.new.char[12](u8(settings.lc.price.taxi2)),
		taxi3 = imgui.new.char[12](u8(settings.lc.price.taxi3)),
		mexa1 = imgui.new.char[12](u8(settings.lc.price.mexa1)),
		mexa2 = imgui.new.char[12](u8(settings.lc.price.mexa2)),
		mexa3 = imgui.new.char[12](u8(settings.lc.price.mexa3)),
		fly1 = imgui.new.char[12](u8(settings.lc.price.fly1)),
		fly2 = imgui.new.char[12](u8(settings.lc.price.fly2)),
		fly3 = imgui.new.char[12](u8(settings.lc.price.fly3))
	},
	-- 9/10
	GiveRank = {
		Window = imgui.new.bool(),
		number = imgui.new.int(5)
	},
	Sobes = {
		Window = imgui.new.bool()
	},
	LeadTools = {
		vc_vize = {
			bool = false,
			player_id = nil
		},
		auto_uninvite = {
			checker = false,
			msg1 = '',
			msg2 = '',
			msg3 = ''
		},
		spawncar = false,
		platoon = {
			check = false,
			player_id = nil
		}
	},
	-- others
	Update = {
		Window = imgui.new.bool(),
		is_need_update = false,
		version = "",
		url = "",
		info = "",
		download_file = ""
	},
	CommandStop = {
		Window = imgui.new.bool()
	},
	CommandPause = {
		Window = imgui.new.bool()
	},
	LeaderFastMenu = {
		Window = imgui.new.bool()
	},
	FastMenu = {
		Window = imgui.new.bool()
	},
	FastPieMenu = {
		Window = imgui.new.bool()
	},
	FastMenuButton = {
		Window = imgui.new.bool()
	},
	FastMenuPlayers = {
		Window = imgui.new.bool()
	},
	InfraredVision = false,
	NightVision = false,
	FONT = nil,
	DEBUG = false
}
MODULE.Binder.tags = {
	my_id = function()
		if isMonetLoader() then
			local nick = settings.player_info.nick or ReverseTranslateNick(settings.player_info.name_surname)
			return sampGetPlayerIdByNickname(nick)
		else
			return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		end
	end,
    my_nick = function()
		if isMonetLoader() then
			return settings.player_info.nick or ReverseTranslateNick(settings.player_info.name_surname)
		else
			return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		end
	end,
	my_ru_nick = function() return settings.player_info.name_surname end,
    my_rp_nick = function()
		if isMonetLoader() then
			local nick = settings.player_info.nick or ReverseTranslateNick(settings.player_info.name_surname)
			return nick:gsub('_', ' ')
		else
			return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_',' ') 
		end
	end,
    my_doklad_nick = function()
		local nick
		if isMonetLoader() then
			nick = settings.player_info.nick or ReverseTranslateNick(settings.player_info.name_surname)
		else
			nick = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
		end
		if nick:find('(.+)%_(.+)') then
			local name, surname = nick:match('(.+)%_(.+)')
			return name:sub(1, 1)  .. '.' .. surname
		else
			return nick
		end
    end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	fraction = function() return settings.player_info.fraction end,
	sex = function() 
		return (settings.player_info.sex == 'Женщина') and 'a' or ''
	end,
	get_time = function()
		return os.date("%H:%M:%S")
	end,
	get_date = function()
		return os.date("%H:%M:%S")
	end,
	get_rank = function()
		return MODULE.GiveRank.number[0]
	end,
	get_square = function()
		local KV = {
			[1] = "А",
			[2] = "Б",
			[3] = "В",
			[4] = "Г",
			[5] = "Д",
			[6] = "Ж",
			[7] = "З",
			[8] = "И",
			[9] = "К",
			[10] = "Л",
			[11] = "М",
			[12] = "Н",
			[13] = "О",
			[14] = "П",
			[15] = "Р",
			[16] = "С",
			[17] = "Т",
			[18] = "У",
			[19] = "Ф",
			[20] = "Х",
			[21] = "Ц",
			[22] = "Ч",
			[23] = "Ш",
			[24] = "Я",
		}
		local X, Y, Z = getCharCoordinates(playerPed)
		X = math.ceil((X + 3000) / 250)
		Y = math.ceil((Y * - 1 + 3000) / 250)
		Y = KV[Y]
		if Y ~= nil then
			local KVX = (Y.."-"..X)
			return KVX
		else
			return X
		end
	end,
	get_area = function()
		local x,y,z = getCharCoordinates(PLAYER_PED)
		return getAreaRu(x,y,z)
	end,
	get_city = function()
		local city = {
			[0] = "Вне города",
			[1] = "Лос Сантос",
			[2] = "Сан Фиерро",
			[3] = "Лас Вентурас"
		}
		return city[getCityPlayerIsIn(PLAYER_PED)]
	end,
	get_drived_car = function()
		local closest_car = nil
		local closest_distance = 50
		local my_pos = {getCharCoordinates(PLAYER_PED)}
		local my_car
		if isCharInAnyCar(PLAYER_PED) then
			my_car = storeCarCharIsInNoSave(PLAYER_PED)
		end
		for _, vehicle in ipairs(getAllVehicles()) do
			if doesCharExist(getDriverOfCar(vehicle)) and vehicle ~= my_car then
				local vehicle_pos = {getCarCoordinates(vehicle)}
				local distance = getDistanceBetweenCoords3d(my_pos[1], my_pos[2], my_pos[3], vehicle_pos[1], vehicle_pos[2], vehicle_pos[3])
				if distance < closest_distance then
					closest_distance = distance
					closest_car = vehicle
				end
			end
		end
		if closest_car then
			local colorNames = {
				[0] = "чёрного",
				[1] = "белого",
				[2] = "бирюзового",
				[3] = "бордового",
				[4] = "хвойного",
				[5] = "пурпурного",
				[6] = "жёлтого",
				[7] = "голубого",
				[8] = "серого",
				[9] = "оливкового",
				[10] = "синего",
				[11] = "серого",
				[12] = "голубого",
				[13] = "графитового",
				[14] = "светлого",
				[15] = "светлого",
				[16] = "хвойного",
				[17] = "бордового",
				[18] = "бордового",
				[19] = "серого",
				[20] = "синего",
				[21] = "бордового",
				[22] = "бордового",
				[23] = "серого",
				[24] = "графитового",
				[25] = "серого",
				[26] = "светлого",
				[27] = "тусклого",
				[28] = "синего",
				[29] = "светлого",
				[30] = "бордового",
				[31] = "бордового",
				[32] = "голубоватого",
				[33] = "серого",
				[34] = "тусклого",
				[35] = "коричневого",
				[36] = "синего",
				[37] = "хвойного",
				[38] = "серого",
				[39] = "синего",
				[40] = "тёмного",
				[41] = "коричневого",
				[42] = "коричневого",
				[43] = "бордового",
				[44] = "хвойного",
				[45] = "бордового",
				[46] = "бежевого",
				[47] = "оливкового",
				[48] = "оливкового",
				[49] = "серого",
				[50] = "серебристого",
				[51] = "хвойного",
				[52] = "синего",
				[53] = "синего",
				[54] = "синего",
				[55] = "коричневого",
				[56] = "голубого",
				[57] = "оливкового",
				[58] = "тёмнокрасного",
				[59] = "синего",
				[60] = "светлого",
				[61] = "оранжевого",
				[62] = "тёмнокрасного",
				[63] = "серебристого",
				[64] = "светлого",
				[65] = "оливкового",
				[66] = "коричневого",
				[67] = "асфальтового",
				[68] = "оливкового",
				[69] = "кварцевого",
				[70] = "тёмнокрасного",
				[71] = "светлого",
				[72] = "тёмносерого",
				[73] = "оливкового",
				[74] = "бордового",
				[75] = "синего",
				[76] = "оливкового",
				[77] = "оранжевого",
				[78] = "бордового",
				[79] = "синего",
				[80] = "розового",
				[81] = "оливкового",
				[82] = "тёмнокрасного",
				[83] = "бирюзового",
				[84] = "коричневого",
				[85] = "розового",
				[86] = "хвойного",
				[87] = "синего",
				[88] = "винного",
				[89] = "оливкового",
				[90] = "светлого",
				[91] = "тёмносинего",
				[92] = "тёмносерого",
				[93] = "голубоватого",
				[94] = "синего",
				[95] = "синего",
				[96] = "светлого",
				[97] = "асфальтового",
				[98] = "голубоватого",
				[99] = "коричневого",
				[100] = "бриллиантового",
				[101] = "кобальтового",
				[102] = "коричневого",
				[103] = "синего",
				[104] = "коричневого",
				[105] = "серого",
				[106] = "синего",
				[107] = "оливкового",
				[108] = "бриллиантового",
				[109] = "серого",
				[110] = "оливкового",
				[111] = "серого",
				[112] = "серого",
				[113] = "коричневого",
				[114] = "зелёного",
				[115] = "тёмнокрасного",
				[116] = "синего",
				[117] = "бордового",
				[118] = "голубого",
				[119] = "коричневого",
				[120] = "оливкового",
				[121] = "бордового",
				[122] = "тёмносерого",
				[123] = "коричневого",
				[124] = "тёмнокрасного",
				[125] = "синего",
				[126] = "розового",
				[127] = "чёрного",
				[128] = "зелёного",
				[129] = "бордового",
				[130] = "синего",
				[131] = "коричневого",
				[132] = "тёмнокрасного",
				[133] = "чёрного",
				[134] = "фиолетового",
				[135] = "яркосинего",
				[136] = "аметистового",
				[137] = "зелёного",
				[138] = "серого",
				[139] = "пурпурного",
				[140] = "светлого",
				[141] = "тёмносерого",
				[142] = "оливкового",
				[143] = "фиолетового",
				[144] = "фиолетового",
				[145] = "зелёного",
				[146] = "пурпурного",
				[147] = "фиолетового",
				[148] = "оливкового",
				[149] = "тёмного",
				[150] = "тёмнозелёного",
				[151] = "зеленого",
				[152] = "синего",
				[153] = "зелёного",
				[154] = "салатового",
				[155] = "бирюзового",
				[156] = "коричневого",
				[157] = "светлого",
				[158] = "оранжевого",
				[159] = "коричневого",
				[160] = "тёмнозелёного",
				[161] = "винного",
				[162] = "синего",
				[163] = "графитового",
				[164] = "чёрного",
				[165] = "бирюзового",
				[166] = "бирюзового",
				[167] = "фиолетового",
				[168] = "бордового",
				[169] = "фиолетового",
				[170] = "фиолетового",
				[171] = "фиолетового",
				[172] = "хвойного",
				[173] = "коричневого",
				[174] = "коричневого",
				[175] = "коричневого",
				[176] = "пурпурного",
				[177] = "пурпурного",
				[178] = "пурпурного",
				[179] = "фиолетового",
				[180] = "коричневого",
				[181] = "красного",
				[182] = "оранжевого",
				[183] = "оливкового",
				[184] = "голубого",
				[185] = "чёрного",
				[186] = "чёрного",
				[187] = "зелёного",
				[188] = "зелёного",
				[189] = "зелёного",
				[190] = "пурпурного",
				[191] = "салатового",
				[192] = "светлого",
				[193] = "светлого",
				[194] = "оливкового",
				[195] = "оливкового",
				[196] = "серого",
				[197] = "оливкового",
				[198] = "синего",
				[199] = "оливкового",
				[200] = "странного",
				[201] = "синего",
				[202] = "зелёного",
				[203] = "синего",
				[204] = "голубого",
				[205] = "синего",
				[206] = "тёмносинего",
				[207] = "голубого",
				[208] = "синего",
				[209] = "синего",
				[210] = "синего",
				[211] = "фиолетового",
				[212] = "оранжевого",
				[213] = "светлого",
				[214] = "оливкового",
				[215] = "чёрного",
				[216] = "оранжевого",
				[217] = "бирюзового",
				[218] = "бледно-розового",
				[219] = "оранжевого",
				[220] = "розового",
				[221] = "оливкового",
				[222] = "оранжевого",
				[223] = "синего",
				[224] = "бордового",
				[225] = "хвойного",
				[226] = "салатового",
				[227] = "зелёного",
				[228] = "бледного",
				[229] = "салатового",
				[230] = "бордового",
				[231] = "коричневого",
				[232] = "розового",
				[233] = "пурпурного",
				[234] = "тёмнозелёного",
				[235] = "оливкового",
				[236] = "хвойного",
				[237] = "пурпурного",
				[238] = "оранжевого",
				[239] = "коричневого",
				[240] = "голубого",
				[241] = "зеленого",
				[242] = "фиолетового",
				[243] = "зелёного",
				[244] = "коричневого",
				[245] = "хвойного",
				[246] = "голубого",
				[247] = "синего",
				[248] = "бордового",
				[249] = "бордового",
				[250] = "серого",
				[251] = "серого",
				[252] = "чёрного",
				[253] = "серого",
				[254] = "коричневого",
				[255] = "синего"
			}
			local clr1, clr2 = getCarColours(closest_car)
			local CarColorName = " " .. colorNames[clr1] .. " цвета"
			local function getVehPlateNumberByCarHandle(car)
				for i, plate in pairs(modules.arz_veh.cache) do
					result, veh = sampGetCarHandleBySampVehicleId(plate.carID)
					if result and veh == car then
						return ' c номерами ' .. plate.number
					end
				end
				return ''
			end
			return (getNameOfARZVehicleModel(getCarModel(closest_car)) .. CarColorName .. getVehPlateNumberByCarHandle(closest_car))
		else
			--sampAddChatMessage("[Arizona Helper] {ffffff}Не удалось получить модель ближайшего т/c с водителем!", 0x009EFF)
			return 'транспортного средства'
		end
	end,
	get_nearest_car = function()
		local closest_car = nil
		local closest_distance = 50
		local my_pos = {getCharCoordinates(PLAYER_PED)}
		local my_car
		if isCharInAnyCar(PLAYER_PED) then
			my_car = storeCarCharIsInNoSave(PLAYER_PED)
		end
		for _, vehicle in ipairs(getAllVehicles()) do
			if vehicle ~= my_car then
				local vehicle_pos = {getCarCoordinates(vehicle)}
				local distance = getDistanceBetweenCoords3d(my_pos[1], my_pos[2], my_pos[3], vehicle_pos[1], vehicle_pos[2], vehicle_pos[3])
				if distance < closest_distance then
					closest_distance = distance
					closest_car = vehicle
				end
			end
		end
		if closest_car then
			local colorNames = {
				[0] = "чёрного",
				[1] = "белого",
				[2] = "бирюзового",
				[3] = "бордового",
				[4] = "хвойного",
				[5] = "пурпурного",
				[6] = "жёлтого",
				[7] = "голубого",
				[8] = "серого",
				[9] = "оливкового",
				[10] = "синего",
				[11] = "серого",
				[12] = "голубого",
				[13] = "графитового",
				[14] = "светлого",
				[15] = "светлого",
				[16] = "хвойного",
				[17] = "бордового",
				[18] = "бордового",
				[19] = "серого",
				[20] = "синего",
				[21] = "бордового",
				[22] = "бордового",
				[23] = "серого",
				[24] = "графитового",
				[25] = "серого",
				[26] = "светлого",
				[27] = "тусклого",
				[28] = "синего",
				[29] = "светлого",
				[30] = "бордового",
				[31] = "бордового",
				[32] = "голубоватого",
				[33] = "серого",
				[34] = "тусклого",
				[35] = "коричневого",
				[36] = "синего",
				[37] = "хвойного",
				[38] = "серого",
				[39] = "синего",
				[40] = "тёмного",
				[41] = "коричневого",
				[42] = "коричневого",
				[43] = "бордового",
				[44] = "хвойного",
				[45] = "бордового",
				[46] = "бежевого",
				[47] = "оливкового",
				[48] = "оливкового",
				[49] = "серого",
				[50] = "серебристого",
				[51] = "хвойного",
				[52] = "синего",
				[53] = "синего",
				[54] = "синего",
				[55] = "коричневого",
				[56] = "голубого",
				[57] = "оливкового",
				[58] = "тёмнокрасного",
				[59] = "синего",
				[60] = "светлого",
				[61] = "оранжевого",
				[62] = "тёмнокрасного",
				[63] = "серебристого",
				[64] = "светлого",
				[65] = "оливкового",
				[66] = "коричневого",
				[67] = "асфальтового",
				[68] = "оливкового",
				[69] = "кварцевого",
				[70] = "тёмнокрасного",
				[71] = "светлого",
				[72] = "тёмносерого",
				[73] = "оливкового",
				[74] = "бордового",
				[75] = "синего",
				[76] = "оливкового",
				[77] = "оранжевого",
				[78] = "бордового",
				[79] = "синего",
				[80] = "розового",
				[81] = "оливкового",
				[82] = "тёмнокрасного",
				[83] = "бирюзового",
				[84] = "коричневого",
				[85] = "розового",
				[86] = "хвойного",
				[87] = "синего",
				[88] = "винного",
				[89] = "оливкового",
				[90] = "светлого",
				[91] = "тёмносинего",
				[92] = "тёмносерого",
				[93] = "голубоватого",
				[94] = "синего",
				[95] = "синего",
				[96] = "светлого",
				[97] = "асфальтового",
				[98] = "голубоватого",
				[99] = "коричневого",
				[100] = "бриллиантового",
				[101] = "кобальтового",
				[102] = "коричневого",
				[103] = "синего",
				[104] = "коричневого",
				[105] = "серого",
				[106] = "синего",
				[107] = "оливкового",
				[108] = "бриллиантового",
				[109] = "серого",
				[110] = "оливкового",
				[111] = "серого",
				[112] = "серого",
				[113] = "коричневого",
				[114] = "зелёного",
				[115] = "тёмнокрасного",
				[116] = "синего",
				[117] = "бордового",
				[118] = "голубого",
				[119] = "коричневого",
				[120] = "оливкового",
				[121] = "бордового",
				[122] = "тёмносерого",
				[123] = "коричневого",
				[124] = "тёмнокрасного",
				[125] = "синего",
				[126] = "розового",
				[127] = "чёрного",
				[128] = "зелёного",
				[129] = "бордового",
				[130] = "синего",
				[131] = "коричневого",
				[132] = "тёмнокрасного",
				[133] = "чёрного",
				[134] = "фиолетового",
				[135] = "яркосинего",
				[136] = "аметистового",
				[137] = "зелёного",
				[138] = "серого",
				[139] = "пурпурного",
				[140] = "светлого",
				[141] = "тёмносерого",
				[142] = "оливкового",
				[143] = "фиолетового",
				[144] = "фиолетового",
				[145] = "зелёного",
				[146] = "пурпурного",
				[147] = "фиолетового",
				[148] = "оливкового",
				[149] = "тёмного",
				[150] = "тёмнозелёного",
				[151] = "зеленого",
				[152] = "синего",
				[153] = "зелёного",
				[154] = "салатового",
				[155] = "бирюзового",
				[156] = "коричневого",
				[157] = "светлого",
				[158] = "оранжевого",
				[159] = "коричневого",
				[160] = "тёмнозелёного",
				[161] = "винного",
				[162] = "синего",
				[163] = "графитового",
				[164] = "чёрного",
				[165] = "бирюзового",
				[166] = "бирюзового",
				[167] = "фиолетового",
				[168] = "бордового",
				[169] = "фиолетового",
				[170] = "фиолетового",
				[171] = "фиолетового",
				[172] = "хвойного",
				[173] = "коричневого",
				[174] = "коричневого",
				[175] = "коричневого",
				[176] = "пурпурного",
				[177] = "пурпурного",
				[178] = "пурпурного",
				[179] = "фиолетового",
				[180] = "коричневого",
				[181] = "красного",
				[182] = "оранжевого",
				[183] = "оливкового",
				[184] = "голубого",
				[185] = "чёрного",
				[186] = "чёрного",
				[187] = "зелёного",
				[188] = "зелёного",
				[189] = "зелёного",
				[190] = "пурпурного",
				[191] = "салатового",
				[192] = "светлого",
				[193] = "светлого",
				[194] = "оливкового",
				[195] = "оливкового",
				[196] = "серого",
				[197] = "оливкового",
				[198] = "синего",
				[199] = "оливкового",
				[200] = "странного",
				[201] = "синего",
				[202] = "зелёного",
				[203] = "синего",
				[204] = "голубого",
				[205] = "синего",
				[206] = "тёмносинего",
				[207] = "голубого",
				[208] = "синего",
				[209] = "синего",
				[210] = "синего",
				[211] = "фиолетового",
				[212] = "оранжевого",
				[213] = "светлого",
				[214] = "оливкового",
				[215] = "чёрного",
				[216] = "оранжевого",
				[217] = "бирюзового",
				[218] = "бледно-розового",
				[219] = "оранжевого",
				[220] = "розового",
				[221] = "оливкового",
				[222] = "оранжевого",
				[223] = "синего",
				[224] = "бордового",
				[225] = "хвойного",
				[226] = "салатового",
				[227] = "зелёного",
				[228] = "бледного",
				[229] = "салатового",
				[230] = "бордового",
				[231] = "коричневого",
				[232] = "розового",
				[233] = "пурпурного",
				[234] = "тёмнозелёного",
				[235] = "оливкового",
				[236] = "хвойного",
				[237] = "пурпурного",
				[238] = "оранжевого",
				[239] = "коричневого",
				[240] = "голубого",
				[241] = "зеленого",
				[242] = "фиолетового",
				[243] = "зелёного",
				[244] = "коричневого",
				[245] = "хвойного",
				[246] = "голубого",
				[247] = "синего",
				[248] = "бордового",
				[249] = "бордового",
				[250] = "серого",
				[251] = "серого",
				[252] = "чёрного",
				[253] = "серого",
				[254] = "коричневого",
				[255] = "синего"
			}
			local clr1, clr2 = getCarColours(closest_car)
			local CarColorName = " " .. colorNames[clr1] .. " цвета"
			local function getVehPlateNumberByCarHandle(car)
				for i, plate in pairs(modules.arz_veh.cache) do
					result, veh = sampGetCarHandleBySampVehicleId(plate.carID)
					if result and veh == car then
						return ' c номерами ' .. plate.number
					end
				end
				return ''
			end
			return (getNameOfARZVehicleModel(getCarModel(closest_car)) .. CarColorName .. getVehPlateNumberByCarHandle(closest_car))
		else
			return 'транспортного средства'
		end
	end,
	get_form_su = function()
		return MODULE.SumMenu.form_su
	end,
	get_patrool_format_time = function()
		local hours = math.floor(MODULE.Patrool.time / 3600)
		local minutes = math.floor((MODULE.Patrool.time % 3600) / 60)
		local secs = MODULE.Patrool.time % 60
		if hours > 0 then
			return string.format("%d часов %d минут %d секунд", hours, minutes, secs)
		elseif minutes > 0 then
			return string.format("%d минут %d секунд", minutes, secs)
		else
			return string.format("%d секунд(-ы)", secs)
		end
	end,
	get_patrool_time = function()
		local hours = math.floor(MODULE.Patrool.time / 3600)
		local minutes = math.floor(( MODULE.Patrool.time % 3600) / 60)
		local secs = MODULE.Patrool.time % 60
		if hours > 0 then
			return string.format("%02d:%02d:%02d", hours, minutes, secs)
		else
			return string.format("%02d:%02d", minutes, secs)
		end
	end,
	get_patrool_code = function()
		return MODULE.Patrool.code
	end,
	get_patrool_mark = function()
		return MODULE.Patrool.mark .. '-' .. select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
	end,
	get_post_format_time = function()
		local hours = math.floor(MODULE.Post.time / 3600)
		local minutes = math.floor((MODULE.Post.time % 3600) / 60)
		local secs = MODULE.Post.time % 60
		if hours > 0 then
			return string.format("%d часов %d минут %d секунд", hours, minutes, secs)
		elseif minutes > 0 then
			return string.format("%d минут %d секунд", minutes, secs)
		else
			return string.format("%d секунд(-ы)", secs)
		end
	end,
	get_post_time = function()
		local hours = math.floor(MODULE.Post.time / 3600)
		local minutes = math.floor(( MODULE.Post.time % 3600) / 60)
		local secs = MODULE.Post.time % 60
		if hours > 0 then
			return string.format("%02d:%02d:%02d", hours, minutes, secs)
		else
			return string.format("%02d:%02d", minutes, secs)
		end
	end,
	get_post_code = function()
		return MODULE.Post.code
	end,
	get_post_name = function()
		return MODULE.Post.name
	end,
	get_car_units = function()
		if isCharInAnyCar(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			local success, passengers = getNumberOfPassengers(car)
			if isMonetLoader() and success and passengers == nil then
				passengers = success
			end
			if success and passengers and tonumber(passengers) > 0 then
				local my_passengers = {}
				for k, v in ipairs(getAllChars()) do
					local res, id = sampGetPlayerIdByCharHandle(v)
					if res and id ~= select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
						if isCharInAnyCar(v) then
							if car == storeCarCharIsInNoSave(v) then
								table.insert(my_passengers, id)
							end
						end
					end
				end
				if #my_passengers ~= 0 then
					local units = ''
					for k, idd in ipairs(my_passengers) do
						local nickname = sampGetPlayerNickname(idd)
						local first_letter = nickname:sub(1, 1)
						local last_name = nickname:match(".*_(.*)")
						if last_name then
							units = units .. first_letter .. "." .. last_name .. ' '
						else
							units = units .. nickname .. ' '
						end
					end
					return units
				else
					--sampAddChatMessage('[Arizona Helper] В вашем авто нету ваших напарников!', -1)
					return 'Нету'
				end
			else
				return 'Нету'
			end
		else
			--sampAddChatMessage('[Arizona Helper] Вы не находитесь в авто, невозможно получить ваших напарников!', -1)
			return 'Нету'
		end
	end,
	switchCarSiren = function()
		if isCharInAnyCar(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			if getDriverOfCar(car) == PLAYER_PED then
				switchCarSiren(car, not isCarSirenOn(car))
				return '/me ' .. (isCarSirenOn(car) and 'включает' or 'выключает') .. ' мигалки в своём транспортном средстве'
			else
				--sampAddChatMessage('[Arizona Helper] {ffffff}Вы не за рулём!', 0x009EFF)
				return (isCarSirenOn(car) and 'Выключи' or 'Врубай') .. ' мигалки!'
			end
		else
			--sampAddChatMessage('[Arizona Helper] {ffffff}Вы не в автомобиле!', 0x009EFF)
			return "Кхм"
		end
	end,
	-- LC
	get_price_avto1 = function() return settings.lc.price.avto1 end,
	get_price_avto2 = function() return settings.lc.price.avto2 end,
	get_price_avto3 = function() return settings.lc.price.avto3 end,
	get_price_moto1 = function() return settings.lc.price.moto1 end,
	get_price_moto2 = function() return settings.lc.price.moto2 end,
	get_price_moto3 = function() return settings.lc.price.moto3 end,
	get_price_fish1 = function() return settings.lc.price.fish1 end,
	get_price_fish2 = function() return settings.lc.price.fish2 end,
	get_price_fish3 = function() return settings.lc.price.fish3 end,
	get_price_swim1 = function() return settings.lc.price.swim1 end,
	get_price_swim2 = function() return settings.lc.price.swim2 end,
	get_price_swim3 = function() return settings.lc.price.swim3 end,
	get_price_gun1 = function() return settings.lc.price.gun1 end,
	get_price_gun2 = function() return settings.lc.price.gun2 end,
	get_price_gun3 = function() return settings.lc.price.gun3 end,
	get_price_hunt1 = function() return settings.lc.price.hunt1 end,
	get_price_hunt2 = function() return settings.lc.price.hunt2 end,
	get_price_hunt3 = function() return settings.lc.price.hunt3 end,
	get_price_klad1 = function() return settings.lc.price.klad1 end,
	get_price_klad2 = function() return settings.lc.price.klad2 end,
	get_price_klad3 = function() return settings.lc.price.klad3 end,
	get_price_taxi1 = function() return settings.lc.price.taxi1 end,
	get_price_taxi2 = function() return settings.lc.price.taxi2 end,
	get_price_taxi3 = function() return settings.lc.price.taxi3 end,
	get_price_mexa1 = function() return settings.lc.price.mexa1 end,
	get_price_mexa2 = function() return settings.lc.price.mexa2 end,
	get_price_mexa3 = function() return settings.lc.price.mexa3 end,
	get_price_fly1 = function() return settings.lc.price.fly1 end,
	get_price_fly2 = function() return settings.lc.price.fly2 end,
	get_price_fly3 = function() return settings.lc.price.fly3 end,
	-- MH
	get_price_heal = function()
		if sampGetCurrentServerName():find("Vice City") then
			return settings.mh.price.heal_vc
		else
			return settings.mh.price.heal
		end
	end,
	get_price_actorheal = function()
		if u8(sampGetCurrentServerName()):find("Vice City") then
			return settings.mh.price.healactor_vc
		else
			return settings.mh.price.healactor
		end
	end,
	get_price_medosm = function() return settings.mh.price.medosm end,
	get_price_mticket = function() return settings.mh.price.mticket end,
	get_price_healbad = function() return settings.mh.price.healbad end,
	get_price_ant = function() return settings.mh.price.ant end,
	get_price_recept = function() return settings.mh.price.recept end,
	get_price_med7 = function() return settings.mh.price.med7 end,
	get_price_med14 = function() return settings.mh.price.med14 end,
	get_price_med30 = function() return settings.mh.price.med30 end,
	get_price_med60 = function() return settings.mh.price.med60 end,
	get_medcard_days = function() 
		return MODULE.MedCard.days[0]
	end,
	get_medcard_status = function() 
		return MODULE.MedCard.status[0]
	end,
	get_recepts = function()
		return MODULE.Recept.recepts[0]
	end,
	get_ants = function()
		return MODULE.Antibiotik.ants[0]
	end,
	get_medcard_price = function()
		if MODULE.MedCard.days[0] == 0 then
			return settings.mh.price.med7
		elseif MODULE.MedCard.days[0] == 1 then
			return settings.mh.price.med14
		elseif MODULE.MedCard.days[0] == 2 then
			return settings.mh.price.med30
		elseif MODULE.MedCard.days[0] == 3 then
			return settings.mh.price.med60
		else
			return 1000
		end
	end,
}
-- временно, позже вообще систему тегов поменяю
local binder_tags_text = [[
{my_id} - Ваш ID
{my_nick} - Ваш Никнейм 
{my_rp_nick} - Ваш Никнейм без _
{my_ru_nick} - Ваше Имя и Фамилия
{my_doklad_nick} - Первая буква вашего имени и фамилия

{fraction} - Ваша фракция
{fraction_rank} - Ваша фракционная должность
{fraction_tag} - Тег вашей фракции

{sex} - Добавляет букву "а" если в хелпере указан женский пол

{get_time} - Получить текущее время
{get_city} - Получить текущий город
{get_square} - Получить текущий квадрат
{get_area} - Получить текущий район
{get_nearest_car} - Получить модель ближайшего к вам авто
{get_drived_car} - Получить модель ближайшего к вам авто с водителем

{get_nick({arg_id})} - получить Никнейм из аргумента ID игрока
{get_rp_nick({arg_id})} - получить Никнейм без символа _ из аргумента ID игрока
{get_ru_nick({arg_id})} - получить Никнейм на кирилице из аргумента ID игрока 

{get_price_heal} - Цена лечения пациентов
{get_price_healbad} - Цена лечения от наркозависимости
{get_price_actorheal} - Цена лечения охранников
{get_price_medosm} - Цена мед.осмотра для пилота
{get_price_mticket} - Цена обследования военного билета
{get_price_ant} - Цена антибиотика   
{get_price_recept} - Цена рецепта
{get_price_med7} - Цена медккарты на 7 дней   
{get_price_med14} - Цена медккарты на 14 дней
{get_price_med30} - Цена медккарты на 30 дней   
{get_price_med60} - Цена медккарты на 60 дней

{show_medcard_menu} - Открыть меню мед.карты
{get_medcard_days} - Получить номер выбранного кол-ва дней
{get_medcard_status} - Получить номер выбранного статуса
{get_medcard_price} - Получить цену мед.карты исходя из дней
{show_recept_menu} - Открыть меню выдачи рецептов
{get_recepts} - Получить кол-во выбранных рецептов
{show_ant_menu} - Открыть меню выдачи антибиотиков 
{get_ants} - Получить кол-во выбранных антибиотиков
{lmenu_vc_vize} - Авто-выдача визы Vice City
{give_platoon} - Назначить взвод игроку
{show_rank_menu} - Открыть меню выдачи рангов
{get_rank} - Получить выбранный ранг

{pause} - Поставить отыгровку команды на паузу и ожидать действия
]]
----------------------------------------- MoonMonet & Colors -------------------------------------
function rgbToHex(rgb)
	local r = bit.band(bit.rshift(rgb, 16), 0xFF)
	local g = bit.band(bit.rshift(rgb, 8), 0xFF)
	local b = bit.band(rgb, 0xFF)
	local hex = string.format("%02X%02X%02X", r, g, b)
	return hex
end
function color_to_float3(u32color)
    local temp = imgui.ColorConvertU32ToFloat4(u32color)
    return temp.z, temp.y, temp.x
end
if settings.general.helper_theme == 0 and monet_no_errors then
	message_color = settings.general.moonmonet_theme_color
	message_color_hex = '{' ..  rgbToHex(settings.general.moonmonet_theme_color) .. '}'
	MODULE.Main.msgcolor[0], MODULE.Main.msgcolor[1], MODULE.Main.msgcolor[2] = color_to_float3(settings.general.moonmonet_theme_color)
	MODULE.Main.mmcolor[0], MODULE.Main.mmcolor[1], MODULE.Main.mmcolor[2] = color_to_float3(settings.general.moonmonet_theme_color)
else
	print('Библиотека MoonMonet отсуствует! Ставлю Dark Theme по дефолту')
	message_color = settings.general.message_color
	message_color_hex = '{' ..  rgbToHex(settings.general.message_color) .. '}'
	MODULE.Main.msgcolor[0], MODULE.Main.msgcolor[1], MODULE.Main.msgcolor[2] = color_to_float3(settings.general.message_color)
	settings.general.helper_theme = 1
	MODULE.Main.theme[0] = 1
	save_settings()
end
------------------------------------------- Mimgui PieMenu ---------------------------------------
if ((not pie_no_errors) and (not isMonetLoader())) then 
	local path = getWorkingDirectory():gsub('\\','/') .. "/lib/mimgui_piemenu.lua"
	if not doesFileExist(path) then
		local file, errstr = io.open(getWorkingDirectory():gsub('\\','/') .. "/lib/mimgui_piemenu.lua", 'w')
		if file then
			file:write([[		
local imgui = require 'mimgui'
local ImVec2 = imgui.ImVec2
local ImVec4 = imgui.ImVec4

local function ImRectAdd(rect, rhs)
local Min, Max = rect.Min, rect.Max
if Min.x > rhs.x then Min.x = rhs.x end
if Min.y > rhs.y then Min.y = rhs.y end
if Max.x < rhs.x then Max.x = rhs.x end
if Max.y < rhs.y then Max.y = rhs.y end
end

local function NewPieMenu(context)
	local obj = {
		m_iCurrentIndex = 0,
		m_fMaxItemSqrDiameter = 0,
		m_fLastMaxItemSqrDiameter = 0,
		m_iHoveredItem = 0,
		m_iLastHoveredItem = 0,
		m_iClickedItem = 0,
		m_oItemIsSubMenu = {}, -- [c_iMaxPieItemCount]
		m_oItemNames = {}, -- [c_iMaxPieItemCount]
		m_oItemSizes = {}, -- [c_iMaxPieItemCount]
	}
	return obj
end

local function NewPieMenuContext(MaxPieMenuStack, MaxPieItemCount, RadiusEmpty, RadiusMin, MinItemCount, MinItemCountPerLevel)
	local obj = {
		c_iMaxPieMenuStack = MaxPieMenuStack or 8,
		c_iMaxPieItemCount = MaxPieItemCount or 12,
		c_iRadiusEmpty = RadiusEmpty or 30,
		c_iRadiusMin = RadiusMin or 30,
		c_iMinItemCount = MinItemCount or 3,
		c_iMinItemCountPerLevel = MinItemCountPerLevel or 3,

		m_oPieMenuStack = {},
		m_iCurrentIndex = -1,
		m_iLastFrame = 0,
		m_iMaxIndex = 0,
		m_oCenter = ImVec2(0, 0),
		m_iMouseButton = 0,
		m_bClose = false,
	}
	for i = 0, obj.c_iMaxPieMenuStack - 1 do
		obj.m_oPieMenuStack[i] = NewPieMenu(obj)
	end
	return obj
end

local function BeginPieMenuEx(menuCtx)
	assert(menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieMenuStack)
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex + 1
	menuCtx.m_iMaxIndex = menuCtx.m_iMaxIndex + 1
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	oPieMenu.m_iCurrentIndex = 0
	oPieMenu.m_fMaxItemSqrDiameter = 0
	if not imgui.IsMouseReleased( menuCtx.m_iMouseButton ) then
		oPieMenu.m_iHoveredItem = -1
	end
	if menuCtx.m_iCurrentIndex > 0 then
		oPieMenu.m_fMaxItemSqrDiameter = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex - 1].m_fMaxItemSqrDiameter
	end
	end

	local function EndPieMenuEx(menuCtx)
	assert(menuCtx.m_iCurrentIndex >= 0)
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex - 1
	end

	local function BeginPiePopup(menuCtx, pName, iMouseButton)
	iMouseButton = iMouseButton or 0
	if imgui.IsPopupOpen(pName) then
		imgui.PushStyleColor(imgui.Col.WindowBg, ImVec4(0, 0, 0, 0))
		imgui.PushStyleColor(imgui.Col.Border, ImVec4(0, 0, 0, 0))
		imgui.PushStyleVarFloat(imgui.StyleVar.WindowRounding, 0.0)
		imgui.PushStyleVarFloat(imgui.StyleVar.Alpha, 1.0)
		menuCtx.m_iMouseButton = iMouseButton
		menuCtx.m_bClose = false
		imgui.SetNextWindowPos( ImVec2( -100, -100 ), imgui.Cond.Appearing )
		imgui.SetNextWindowSize(ImVec2(0, 0), imgui.Cond.Always)
		local bOpened = imgui.BeginPopup(pName)
		if bOpened then
			local iCurrentFrame = imgui.GetFrameCount()
			if menuCtx.m_iLastFrame < (iCurrentFrame - 1) then
				menuCtx.m_oCenter = ImVec2(imgui.GetIO().MousePos)
			end
			menuCtx.m_iLastFrame = iCurrentFrame
			menuCtx.m_iMaxIndex = -1
			BeginPieMenuEx(menuCtx)
			return true
		else
			imgui.End()
			imgui.PopStyleColor(2)
			imgui.PopStyleVar(2)
		end
	end
	return false
end

local function EndPiePopup(menuCtx)
	EndPieMenuEx(menuCtx)
	local oStyle = imgui.GetStyle()
	local pDrawList = imgui.GetWindowDrawList()
	pDrawList:PushClipRectFullScreen()
	local oMousePos = imgui.GetIO().MousePos
	local oDragDelta = ImVec2(oMousePos.x - menuCtx.m_oCenter.x, oMousePos.y - menuCtx.m_oCenter.y)
	local fDragDistSqr = oDragDelta.x*oDragDelta.x + oDragDelta.y*oDragDelta.y
	local fCurrentRadius = menuCtx.c_iRadiusEmpty
	-- ImRect
	local oArea = {Min = ImVec2(menuCtx.m_oCenter), Max = ImVec2(menuCtx.m_oCenter)}
	local bItemHovered = false
	local c_fDefaultRotate = -math.pi / 2
	local fLastRotate = c_fDefaultRotate
	for iIndex = 0, menuCtx.m_iMaxIndex do
		local oPieMenu = menuCtx.m_oPieMenuStack[iIndex]
		local fMenuHeight = math.sqrt(oPieMenu.m_fMaxItemSqrDiameter)
		local fMinRadius = fCurrentRadius
		local fMaxRadius = fMinRadius + (fMenuHeight * oPieMenu.m_iCurrentIndex) / 2
		local item_arc_span = 2 * math.pi / math.max(menuCtx.c_iMinItemCount + menuCtx.c_iMinItemCountPerLevel * iIndex, oPieMenu.m_iCurrentIndex)
		local drag_angle = math.atan2(oDragDelta.y, oDragDelta.x)
		local fRotate = fLastRotate - item_arc_span * ( oPieMenu.m_iCurrentIndex - 1 ) / 2
		local item_hovered = -1
		for item_n = 0, oPieMenu.m_iCurrentIndex - 1 do
			local item_label = oPieMenu.m_oItemNames[ item_n ]
			local inner_spacing = oStyle.ItemInnerSpacing.x / fMinRadius / 2
			local fMinInnerSpacing = oStyle.ItemInnerSpacing.x / ( fMinRadius * 2 )
			local fMaxInnerSpacing = oStyle.ItemInnerSpacing.x / ( fMaxRadius * 2 )
			local item_inner_ang_min = item_arc_span * ( item_n - 0.5 + fMinInnerSpacing ) + fRotate
			local item_inner_ang_max = item_arc_span * ( item_n + 0.5 - fMinInnerSpacing ) + fRotate
			local item_outer_ang_min = item_arc_span * ( item_n - 0.5 + fMaxInnerSpacing ) + fRotate
			local item_outer_ang_max = item_arc_span * ( item_n + 0.5 - fMaxInnerSpacing ) + fRotate
			local hovered = false
			if fDragDistSqr >= fMinRadius * fMinRadius and fDragDistSqr < fMaxRadius * fMaxRadius  then
				while (drag_angle - item_inner_ang_min) < 0 do
					drag_angle = drag_angle + (2 * math.pi)
				end
				while (drag_angle - item_inner_ang_min) > 2 * math.pi do
					drag_angle = drag_angle - (2 * math.pi)
				end
				if drag_angle >= item_inner_ang_min and drag_angle < item_inner_ang_max  then
					hovered = true
					bItemHovered = not oPieMenu.m_oItemIsSubMenu[ item_n ]
				end
			end
			-- draw segments
			local arc_segments = math.floor(( 32 * item_arc_span / ( 2 * math.pi ) ) + 1)
			local iColor = imgui.GetColorU32( hovered and imgui.Col.ButtonHovered or imgui.Col.Button )
			local fAngleStepInner = (item_inner_ang_max - item_inner_ang_min) / arc_segments
			local fAngleStepOuter = ( item_outer_ang_max - item_outer_ang_min ) / arc_segments
			pDrawList:PrimReserve(arc_segments * 6, (arc_segments + 1) * 2)
			for iSeg = 0, arc_segments do
				local fCosInner = math.cos(item_inner_ang_min + fAngleStepInner * iSeg)
				local fSinInner = math.sin(item_inner_ang_min + fAngleStepInner * iSeg)
				local fCosOuter = math.cos(item_outer_ang_min + fAngleStepOuter * iSeg)
				local fSinOuter = math.sin(item_outer_ang_min + fAngleStepOuter * iSeg)

				if iSeg < arc_segments then
					local VtxCurrentIdx = pDrawList._VtxCurrentIdx
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 0)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 2)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 1)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 3)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 2)
					pDrawList:PrimWriteIdx(VtxCurrentIdx + 1)
				end
				local pos = ImVec2(menuCtx.m_oCenter.x + fCosInner * (fMinRadius + oStyle.ItemInnerSpacing.x), menuCtx.m_oCenter.y + fSinInner * (fMinRadius + oStyle.ItemInnerSpacing.x))
				local pos2 = ImVec2(menuCtx.m_oCenter.x + fCosOuter * (fMaxRadius - oStyle.ItemInnerSpacing.x), menuCtx.m_oCenter.y + fSinOuter * (fMaxRadius - oStyle.ItemInnerSpacing.x))
				pDrawList:PrimWriteVtx(pos, ImVec2(0, 0), iColor)
				pDrawList:PrimWriteVtx(pos2, ImVec2(0, 0), iColor)
			end

			local fRadCenter = ( item_arc_span * item_n ) + fRotate
			local oOuterCenter = ImVec2( menuCtx.m_oCenter.x + math.cos( fRadCenter ) * fMaxRadius, menuCtx.m_oCenter.y + math.sin( fRadCenter ) * fMaxRadius )
			ImRectAdd(oArea, oOuterCenter)
			if oPieMenu.m_oItemIsSubMenu[item_n] then
				local oTrianglePos = {ImVec2(), ImVec2(), ImVec2()}
				local fRadLeft = fRadCenter - 5 / fMaxRadius
				local fRadRight = fRadCenter + 5 / fMaxRadius
				oTrianglePos[ 0+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadCenter ) * ( fMaxRadius - 5 )
				oTrianglePos[ 0+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadCenter ) * ( fMaxRadius - 5 )
				oTrianglePos[ 1+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadLeft ) * ( fMaxRadius - 10 )
				oTrianglePos[ 1+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadLeft ) * ( fMaxRadius - 10 )
				oTrianglePos[ 2+1 ].x = menuCtx.m_oCenter.x + math.cos( fRadRight ) * ( fMaxRadius - 10 )
				oTrianglePos[ 2+1 ].y = menuCtx.m_oCenter.y + math.sin( fRadRight ) * ( fMaxRadius - 10 )
				pDrawList:AddTriangleFilled(oTrianglePos[1], oTrianglePos[2], oTrianglePos[3], 0xFFFFFFFF)
			end
			local text_size = ImVec2(oPieMenu.m_oItemSizes[item_n])
			local text_pos = ImVec2(
				menuCtx.m_oCenter.x + math.cos((item_inner_ang_min + item_inner_ang_max) * 0.5) * (fMinRadius + fMaxRadius) * 0.5 - text_size.x * 0.5,
				menuCtx.m_oCenter.y + math.sin((item_inner_ang_min + item_inner_ang_max) * 0.5) * (fMinRadius + fMaxRadius) * 0.5 - text_size.y * 0.5)
			pDrawList:AddText(text_pos, imgui.GetColorU32(imgui.Col.Text), item_label)
			if hovered then
				item_hovered = item_n
			end
		end
		fCurrentRadius = fMaxRadius
		oPieMenu.m_fLastMaxItemSqrDiameter = oPieMenu.m_fMaxItemSqrDiameter
		oPieMenu.m_iHoveredItem = item_hovered
		if fDragDistSqr >= fMaxRadius * fMaxRadius then
			item_hovered = oPieMenu.m_iLastHoveredItem
		end
		oPieMenu.m_iLastHoveredItem = item_hovered
		fLastRotate = item_arc_span * oPieMenu.m_iLastHoveredItem + fRotate
		if item_hovered == -1 or not oPieMenu.m_oItemIsSubMenu[item_hovered] then
			break
		end
	end
	pDrawList:PopClipRect()
	if oArea.Min.x < 0  then
		menuCtx.m_oCenter.x = ( menuCtx.m_oCenter.x - oArea.Min.x )
	end
	if oArea.Min.y < 0  then
		menuCtx.m_oCenter.y = ( menuCtx.m_oCenter.y - oArea.Min.y )
	end
	local oDisplaySize = imgui.GetIO().DisplaySize
	if oArea.Max.x > oDisplaySize.x  then
		menuCtx.m_oCenter.x = ( menuCtx.m_oCenter.x - oArea.Max.x ) + oDisplaySize.x
	end
	if oArea.Max.y > oDisplaySize.y  then
		menuCtx.m_oCenter.y = ( menuCtx.m_oCenter.y - oArea.Max.y ) + oDisplaySize.y
	end
	if menuCtx.m_bClose or ( not bItemHovered and imgui.IsMouseReleased( menuCtx.m_iMouseButton ) ) then
		imgui.CloseCurrentPopup()
	end
	imgui.EndPopup()
	imgui.PopStyleColor(2)
	imgui.PopStyleVar(2)
end

local function BeginPieMenu(menuCtx, pName, bEnabled)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	bEnabled = bEnabled or true
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	local oTextSize = imgui.CalcTextSize(pName)
	oPieMenu.m_oItemSizes[oPieMenu.m_iCurrentIndex] = oTextSize
	local fSqrDiameter = (oTextSize.x * oTextSize.x / 2) + (oTextSize.y * oTextSize.y / 2)
	if fSqrDiameter > oPieMenu.m_fMaxItemSqrDiameter then
		oPieMenu.m_fMaxItemSqrDiameter = fSqrDiameter
	end
	oPieMenu.m_oItemIsSubMenu[oPieMenu.m_iCurrentIndex] = true
	oPieMenu.m_oItemNames[oPieMenu.m_iCurrentIndex] = pName
	if oPieMenu.m_iLastHoveredItem == oPieMenu.m_iCurrentIndex then
		oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
		BeginPieMenuEx(menuCtx)
		return true
	end
	oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
	return false
end

local function EndPieMenu(menuCtx)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	menuCtx.m_iCurrentIndex = menuCtx.m_iCurrentIndex - 1
end

local function PieMenuItem(menuCtx, pName, bEnabled)
	assert(menuCtx.m_iCurrentIndex >= 0 and menuCtx.m_iCurrentIndex < menuCtx.c_iMaxPieItemCount)
	bEnabled = bEnabled or true
	local oPieMenu = menuCtx.m_oPieMenuStack[menuCtx.m_iCurrentIndex]
	local oTextSize = imgui.CalcTextSize(pName)
	oPieMenu.m_oItemSizes[oPieMenu.m_iCurrentIndex] = oTextSize
	local fSqrDiameter = (oTextSize.x * oTextSize.x / 3) + (oTextSize.y * oTextSize.y / 3)
	if fSqrDiameter > oPieMenu.m_fMaxItemSqrDiameter then
		oPieMenu.m_fMaxItemSqrDiameter = fSqrDiameter
	end
	oPieMenu.m_oItemIsSubMenu[oPieMenu.m_iCurrentIndex] = false
	oPieMenu.m_oItemNames[oPieMenu.m_iCurrentIndex] = pName
	local bActive = oPieMenu.m_iCurrentIndex == oPieMenu.m_iHoveredItem
	oPieMenu.m_iCurrentIndex = oPieMenu.m_iCurrentIndex + 1
	if bActive then
		menuCtx.m_bClose = true
	end
	return bActive
end

local function New(...)
	local menuContext = NewPieMenuContext(...)
	return {
		_VERSION = '1.0',
		BeginPiePopup = function(name, mouseButton)
			return BeginPiePopup(menuContext, name, mouseButton)
		end,
		EndPiePopup = function()
			return EndPiePopup(menuContext)
		end,
		PieMenuItem = function(name, enabled)
			return PieMenuItem(menuContext, name, enabled)
		end,
		BeginPieMenu = function(name, enabled)
			return BeginPieMenu(menuContext, name, enabled)
		end,
		EndPieMenu = function()
			return EndPieMenu(menuContext)
		end
	}
end

local defaultPieMenu = New()
defaultPieMenu.New = New
return defaultPieMenu
			]])
			file:close()
			pie = require('mimgui_piemenu')
			pie_no_errors = true
		end
	end
end
if pie_no_errors then
	if settings.general.piemenu then
		MODULE.FastPieMenu.Window[0] = true
	end
end
------------------------------------------- Mimgui Hotkey ----------------------------------------
local hotkeys = {}
if ((not isMonetLoader()) and (hotkey_no_errors) and (not isMode(''))) then
	hotkey.Text.NoKey = u8'< click and select keys >'
	hotkey.Text.WaitForKey = u8'< wait keys >'
	function getNameKeysFrom(keys)
		local keys = decodeJson(keys)
		local keysStr = {}
		for _, keyId in ipairs(keys) do
			local keyName = require('vkeys').id_to_name(keyId) or ''
			table.insert(keysStr, keyName)
		end
		return tostring(table.concat(keysStr, ' + ')) or ''
	end
	function loadHotkeys()
		MainMenuHotKey = hotkey.RegisterHotKey('Open MainMenu', false, decodeJson(settings.general.bind_mainmenu), function()
			if not MODULE.Main.Window[0] then
				MODULE.Main.Window[0] = true
			end
		end)
		CommandStopHotKey = hotkey.RegisterHotKey('Stop Command', false, decodeJson(settings.general.bind_command_stop), function() 
			sampProcessChatInput('/stop')
		end)
		FastMenuHotKey = hotkey.RegisterHotKey('Open FastMenu', false, decodeJson(settings.general.bind_fastmenu), function() 
			local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(ped) then
				local result, id = sampGetPlayerIdByCharHandle(ped)
				if result and id ~= -1 and not MODULE.LeaderFastMenu.Window[0] then
					show_fast_menu(id)
				end
			end
		end)
		LeaderFastMenuHotKey = hotkey.RegisterHotKey('Open LeaderFastMenu', false, decodeJson(settings.general.bind_leader_fastmenu), function() 
			if settings.player_info.fraction_rank_number >= 9 then 
				local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
				if valid and doesCharExist(ped) then
					local result, id = sampGetPlayerIdByCharHandle(ped)
					if result and id ~= -1 and not MODULE.FastMenu.Window[0] then
						show_leader_fast_menu(id)
					end
				end
			end
		end)
		ActionHotKey = hotkey.RegisterHotKey('Action Key', false, decodeJson(settings.general.bind_action), function()
			if ((settings.player_info.fraction_rank_number >= 9) and (MODULE.GiveRank.Window[0])) then
				give_rank()
			elseif ((isMode('hospital')) and (MODULE.HealChat.bool)) then
				if (MODULE.HealChat.player_id ~= nil and not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive()) then
					find_and_use_command("/heal {arg_id}", MODULE.HealChat.player_id)
					MODULE.HealChat.bool = false
					MODULE.HealChat.player_id = nil
				end
			elseif ((isMode('smi')) and (MODULE.SmiEdit.Window[0])) then
				send_ad()
			end
		end)
		for _, command in ipairs(modules.commands.data.commands.my) do
			createHotkeyForCommand(command)
		end
		for _, command in ipairs(modules.commands.data.commands_manage.my) do
			createHotkeyForCommand(command)
		end
	end
	function createHotkeyForCommand(command)
		local hotkeyName = command.cmd .. "HotKey"
		if hotkeys[hotkeyName] then
			hotkey.RemoveHotKey(hotkeyName)
		end
		if command.arg == "" and command.bind ~= nil and command.bind ~= '{}' and command.bind ~= '[]' then
			hotkeys[hotkeyName] = hotkey.RegisterHotKey(hotkeyName, false, decodeJson(command.bind), function()
				if (not (sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive())) then
					sampProcessChatInput('/' .. command.cmd)
				end
			end)
			print('Создан хоткей для команды /' .. command.cmd .. ' на клавишу ' .. getNameKeysFrom(command.bind))
			sampAddChatMessage('[Arizona Helper] {ffffff}Создан хоткей для команды ' .. message_color_hex .. '/' .. command.cmd .. ' {ffffff}на клавишу '  .. message_color_hex .. getNameKeysFrom(command.bind), message_color)
		end
	end
	addEventHandler('onWindowMessage', function(msg, key, lparam)
		if msg == 641 or msg == 642 or lparam == -1073741809 then hotkey.ActiveKeys = {} end
		if msg == 0x0005 then hotkey.ActiveKeys = {} end
	end)
end
-------------------------------------------- RP GUNS INIT ----------------------------------------
function initialize_guns()
    for i, weapon in pairs(modules.rpgun.data.rp_guns) do
        local rpTakeType = modules.rpgun.data.rpTakeNames[weapon.rpTake]
		local id = weapon.id
        modules.rpgun.data.gunActions.partOn[id] = rpTakeType[1]
        modules.rpgun.data.gunActions.partOff[id] = rpTakeType[2]
        if id == 3 or (id > 15 and id < 19) or (id == 90 or id == 91) then
            modules.rpgun.data.gunActions.on[id] = (settings.player_info.sex == "Женщина") and "сняла" or "снял"
        else
            modules.rpgun.data.gunActions.on[id] = (settings.player_info.sex == "Женщина") and "достала" or "достал"
        end
        if id == 3 or (id > 15 and id < 19) or (id > 38 and id < 41) or (id == 90 or id == 91) then
            modules.rpgun.data.gunActions.off[id] = (settings.player_info.sex == "Женщина") and "повесила" or "повесил"
        else
            modules.rpgun.data.gunActions.off[id] = (settings.player_info.sex == "Женщина") and "убрала" or "убрал"
        end
    end
end
function get_name_weapon(id) 
    for _, weapon in ipairs(modules.rpgun.data.rp_guns) do
        if weapon.id == id then
            return weapon.name
        end
    end
    return "оружие"
end
function isExistsWeapon(id) 
    for _, weapon in ipairs(modules.rpgun.data.rp_guns) do
        if weapon.id == id then
            return true
        end
    end
    return false
end
function isEnableWeapon(id) 
    for _, weapon in ipairs(modules.rpgun.data.rp_guns) do
        if weapon.id == id then
            return weapon.enable
        end
    end
    return false
end
function handleNewWeapon(weaponId)
    sampAddChatMessage('[Arizona Helper] {ffffff}Обнаружено новое оружие с ID ' .. message_color_hex .. weaponId .. '{ffffff}, даю ему имя "оружие" и расположение "спина".', message_color)
    sampAddChatMessage('[Arizona Helper] {ffffff}Изменить имя или расположение оружия вы можете в /helper - Главное меню - Режим RP отыгровки оружия - Настроить', message_color)
    table.insert(modules.rpgun.data.rp_guns, {id = weaponId, name = "оружие", enable = true, rpTake = 1})
	save_module('rpgun')
    initialize_guns()
end
function processWeaponChange(oldGun, nowGun)
    if not modules.rpgun.data.gunActions.off[oldGun] or not modules.rpgun.data.gunActions.on[nowGun] then
        sampAddChatMessage('[Arizona Helper | Ассистент] {ffffff}Инициализация оружия...', message_color)
		initialize_guns()
		return
    end
    local actions = modules.rpgun.data.gunActions
    if oldGun == 0 and nowGun == 0 then
        return
    elseif oldGun == 0 and not isEnableWeapon(nowGun) then
        return
    elseif nowGun == 0 and not isEnableWeapon(oldGun) then
        return
    elseif not isEnableWeapon(oldGun) and isEnableWeapon(nowGun) then
        sampSendChat(string.format("/me %s %s %s",
            actions.on[nowGun],
            get_name_weapon(nowGun),
            actions.partOn[nowGun]
        ))
    elseif isEnableWeapon(oldGun) and not isEnableWeapon(nowGun) then
        sampSendChat(string.format("/me %s %s %s",
            actions.off[oldGun],
           	get_name_weapon(oldGun),
            actions.partOff[oldGun]
        ))
    elseif oldGun == 0 then
        sampSendChat(string.format("/me %s %s %s",
            actions.on[nowGun],
            get_name_weapon(nowGun),
            actions.partOn[nowGun]
        ))
    elseif nowGun == 0 then
        sampSendChat(string.format("/me %s %s %s",
            actions.off[oldGun],
            get_name_weapon(oldGun),
            actions.partOff[oldGun]
        ))
    else
		if isEnableWeapon(oldGun) and isEnableWeapon(nowGun) then
			sampSendChat(string.format("/me %s %s %s, после чего %s %s %s",
				actions.off[oldGun],
				get_name_weapon(oldGun),
				actions.partOff[oldGun],
				actions.on[nowGun],
				get_name_weapon(nowGun),
				actions.partOn[nowGun]
			))
		end
        
    end
end
-------------------------------------------- Variables ------------------------------------------
local PlayerID = nil
local player_id = nil
local clicked = false
------------------------------------------- Functions --------------------------------------------
function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end

	check_resourses()

	if settings.general.fraction_mode == '' then
		import_data_from_old_helpers()
		repeat wait(0) until sampIsLocalPlayerSpawned()
		MODULE.Initial.Window[0] = true
		return
	end
	
	load_modules()
	
	if settings.general.rp_guns then initialize_guns() end
	
	initialize_commands()

	if ((not isMonetLoader()) and hotkey_no_errors) then loadHotkeys() end

	welcome_message()
	
	check_update()

	while true do
		wait(0)

		if (isMonetLoader() and settings.general.mobile_fastmenu_button) then
			if tonumber(#get_players()) > 0 and not MODULE.FastMenu.Window[0] and not MODULE.FastMenuPlayers.Window[0] then
				MODULE.FastMenuButton.Window[0] = true
			else
				MODULE.FastMenuButton.Window[0] = false
			end
		end

		if MODULE.Post.active then
			MODULE.Post.time = os.difftime(os.time(), MODULE.Post.start_time)
		end

		if (isMode('police') or isMode('fbi')) then
			if MODULE.Patrool.active then
				MODULE.Patrool.time = os.difftime(os.time(), MODULE.Patrool.start_time)
			end
			if MODULE.Patrool.active and isCharInAnyCar(PLAYER_PED) and settings.mj.auto_change_code_siren then
				local currentSirenState = isCarSirenOn(storeCarCharIsInNoSave(PLAYER_PED))
				if firstCheck then
					lastSirenState = currentSirenState
					firstCheck = false
				end
				if currentSirenState ~= lastSirenState then
					lastSirenState = currentSirenState
					if currentSirenState then
						sampAddChatMessage("[Arizona Helper | Ассистент] {ffffff}В вашем т/с была включена сирена, изменяю ситуационный код на CODE 3!", message_color)
						MODULE.Patrool.ComboCode[0] = 4
						MODULE.Patrool.code = MODULE.Patrool.combo_code_list[MODULE.Patrool.ComboCode[0] + 1]
					else
						sampAddChatMessage("[Arizona Helper | Ассистент] {ffffff}В вашем т/с была отключена сирена, изменяю ситуационный код на CODE 4.", message_color)
						MODULE.Patrool.ComboCode[0] = 5
						MODULE.Patrool.code = MODULE.Patrool.combo_code_list[MODULE.Patrool.ComboCode[0] + 1]
					end
				end
			end
		end

		if (settings.general.rp_guns) and (modules.rpgun.data.nowGun ~= getCurrentCharWeapon(PLAYER_PED)) then
            modules.rpgun.data.oldGun = modules.rpgun.data.nowGun
            modules.rpgun.data.nowGun = getCurrentCharWeapon(PLAYER_PED)
            if not isExistsWeapon(modules.rpgun.data.oldGun) then
                handleNewWeapon(modules.rpgun.data.oldGun)
            elseif not isExistsWeapon(modules.rpgun.data.nowGun) then
                handleNewWeapon(modules.rpgun.data.nowGun)
            end
            processWeaponChange(modules.rpgun.data.oldGun, modules.rpgun.data.nowGun)
        end

		if (settings.general.payday_notify) then
			local currentMinute = os.date("%M", os.time())
			local currentSecond = os.date("%S", os.time())
			if ((currentMinute == "55" or currentMinute == "25") and currentSecond == "00") then
				if sampGetPlayerColor(MODULE.Binder.tags.my_id()) == 368966908 then
					sampAddChatMessage('[Arizona Helper] {ffffff}Через 5 минут будет PAYDAY. Наденьте форму чтобы не пропустить зарплату!', message_color)
					playNotifySound()
					wait(1000)
				end
			end
		end
		
		if (settings.general.cruise_control) then
			if (MODULE.CruiseControl.wait_point) then
				local bool, x, y, z = getTargetBlipCoordinates()
				if bool then
					MODULE.CruiseControl.point = {x = x, y = y, z = z}
					MODULE.CruiseControl.wait_point = false
					sampAddChatMessage('[Arizona Helper] {ffffff}Координаты места назначения успешно получены!', message_color)
					while (isGamePaused() or isPauseMenuActive()) do wait(0) end
					lua_thread.create(function()
						sampSendChat('/me включает в своём тс адаптивный CRUISE CONTROL и настраивает GPS навигатор')
						wait(1500)
						sampSendChat('/do На экране загорается надпись "GPS маршрут успешно проложен, можно ехать".')
						MODULE.CruiseControl.active = true 
						wait(2000)
						sampSendChat('/do ' .. MODULE.Binder.tags.my_ru_nick() .. ' держит руки на руле, CRUISE CONTROL поддерживает скорость тс.')
					end)
				end
			end
			if (MODULE.CruiseControl.active) then
				local function stop()
					MODULE.CruiseControl.active = false
					clearCharTasks(PLAYER_PED)
					if isCharInAnyCar(PLAYER_PED) then
						taskWarpCharIntoCarAsDriver(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED))
					end
				end
				if not isCharInAnyCar(PLAYER_PED) then
					sampAddChatMessage('[Arizona Helper] {ffffff}Вы должны находиться в транспортном средстве!', message_color)
					stop()
				elseif not (isCarEngineOn(storeCarCharIsInNoSave(PLAYER_PED))) then
					sampAddChatMessage('[Arizona Helper] {ffffff}Двигатель вашего транспортного средства заглох!', message_color)
					stop()
				elseif locateCharInCar2d(PLAYER_PED, MODULE.CruiseControl.point.x, MODULE.CruiseControl.point.y, 15, 15, false) then
					sampSendChat('/me приехав к пункту назначения отключает в тс адаптивный CRUISE CONTROL')
					stop()
				else
					taskCarDriveToCoord(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED), MODULE.CruiseControl.point.x, MODULE.CruiseControl.point.y, MODULE.CruiseControl.point.z, 28, 0, 0, 2)
				end
				
			end
		end

		if (not isMonetLoader()) and (sampIsLocalPlayerSpawned() and (getCurrentCharWeapon(PLAYER_PED) == 0)) then
			local url = 'https://mtgmods.github.io/logo.png'
			visualCEF(([[
				if (document.querySelector('.player-info__gun-image').src != '%s')
					document.querySelector('.player-info__gun-image').src = '%s';
            ]]):format(url, url), true)
        end

	end

end
function load_modules()
	load_module('commands')
	load_module('notes')
	load_module('rpgun')
	load_module('arz_veh')

	if isMode('police') or isMode('fbi') then
		load_module('smart_uk')
		load_module('smart_pdd')
		if (isMonetLoader()) then
			if (settings.mj.mobile_taser_button) then
				MODULE.Taser.Window[0] = true
			end
			if (settings.mj.mobile_meg_button) then
				MODULE.Megafon.Window[0] = true
			end
		end
	elseif isMode('prison') then
		load_module('smart_rptp')
		if ((isMonetLoader()) and (settings.md.mobile_taser_button)) then
			MODULE.Taser.Window[0] = true
		end	
	elseif isMode('smi') then
		load_module('ads_history')
	end
end
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[Arizona Helper] {ffffff}Инициализация хелпера прошла успешно!',message_color)
		sampAddChatMessage('[Arizona Helper] {ffffff}Для полной загрузки хелпера сначало заспавнитесь (войдите на сервер)',message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end

	sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка хелпера прошла успешно!', message_color)
	show_arz_notify('info', 'Arizona Helper', "Загрузка хелпера прошла успешно!", 3000)
	print('Полная загрузка хелпера прошла успешно!')

	if isMonetLoader() or settings.general.bind_mainmenu == nil then	
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтоб открыть меню хелпера введите команду ' .. message_color_hex .. '/helper', message_color)
	elseif hotkey_no_errors and settings.general.bind_mainmenu then
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтоб открыть меню хелпера нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_mainmenu) .. ' {ffffff}или введите команду ' .. message_color_hex .. '/helper', message_color)
	else
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтоб открыть меню хелпера введите команду ' .. message_color_hex .. '/helper', message_color)
	end
end
function registerCommandsFrom(array)
	for _, command in ipairs(array) do
		if command.enable then
			register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
		end
	end
end
function register_command(chat_cmd, cmd_arg, cmd_text, cmd_waiting)
	sampRegisterChatCommand(chat_cmd, function(arg)
		if not MODULE.Binder.state.isActive then
			if MODULE.Binder.state.isStop then
				MODULE.Binder.state.isStop = false
			end
			local arg_check = false
			local modifiedText = cmd_text
			if cmd_arg == '{arg}' then
				if arg and arg ~= '' then
					modifiedText = modifiedText:gsub('{arg}', arg or "")
					arg_check = true
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [аргумент]', message_color)
					playNotifySound()
				end
			elseif cmd_arg == '{arg_id}' then
				if isParamSampID(arg) then
					arg = tonumber(arg)
					modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg) or "")
					modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg):gsub('_',' ') or "")
					modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg)) or "")
					modifiedText = modifiedText:gsub('%{arg_id%}', arg or "")
					arg_check = true
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока]', message_color)
					playNotifySound()
				end
			elseif cmd_arg == '{arg_id} {arg2}' then
				if arg and arg ~= '' then
					local arg_id, arg2 = arg:match('(%d+) (.+)')
					if isParamSampID(arg_id) and arg2 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
						arg_check = true
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
						playNotifySound()
					end
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [аргумент]', message_color)
					playNotifySound()
				end
            elseif cmd_arg == '{arg_id} {arg2} {arg3}' then
				if arg and arg ~= '' then
					local arg_id, arg2, arg3 = arg:match('(%d+) (%d) (.+)')
					if isParamSampID(arg_id) and arg2 and arg3 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
                        modifiedText = modifiedText:gsub('%{arg3%}', arg3 or "")
						arg_check = true
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [число] [аргумент]', message_color)
						playNotifySound()
					end
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [число] [аргумент]', message_color)
					playNotifySound()
				end
			elseif cmd_arg == '{arg_id} {arg2} {arg3} {arg4}' then
				if arg and arg ~= '' then
					local arg_id, arg2, arg3, arg4 = arg:match('(%d+) (%d) (.+) (.+)')
					if isParamSampID(arg_id) and arg2 and arg3 and arg4 then
						arg_id = tonumber(arg_id)
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						modifiedText = modifiedText:gsub('%{arg2%}', arg2 or "")
                        modifiedText = modifiedText:gsub('%{arg3%}', arg3 or "")
						modifiedText = modifiedText:gsub('%{arg4%}', arg4 or "")
						arg_check = true
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [число] [аргумент] [аргумент]', message_color)
						playNotifySound()
					end
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/' .. chat_cmd .. ' [ID игрока] [число] [аргумент] [аргумент]', message_color)
					playNotifySound()
				end
			elseif cmd_arg == '' then
				arg_check = true
			end
			if arg_check then
				lua_thread.create(function()
					MODULE.Binder.state.isActive = true
					MODULE.Binder.state.isPause = false
					if modifiedText:find('&.+&') then
						info_stop_command()
					end
					local lines = {}
					for line in string.gmatch(modifiedText, "[^&]+") do
						table.insert(lines, line)
					end
					for line_index, line in ipairs(lines) do
						if MODULE.Binder.state.isStop then 
							MODULE.Binder.state.isStop = false 
							MODULE.Binder.state.isActive = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								MODULE.CommandStop.Window[0] = false
							end
							sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 
							break
						else
							if line == '{show_medcard_menu}' then
								if cmd_arg == '{arg_id}' then
									player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										player_id = tonumber(arg_id)
									end
								end
								MODULE.MedCard.Window[0] = true
								break
							elseif line == '{show_recept_menu}' then
								if cmd_arg == '{arg_id}' then
									player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										player_id = tonumber(arg_id)
									end
								end
								MODULE.Recept.Window[0] = true
								break
							elseif line == '{show_ant_menu}' then
								if cmd_arg == '{arg_id}' then
									player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										player_id = tonumber(arg_id)
									end
								end
								MODULE.Antibiotik.Window[0] = true
								break
							elseif line == '{lmenu_vc_vize}' then
								if cmd_arg == '{arg_id}' then
									MODULE.LeadTools.vc_vize.player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										MODULE.LeadTools.vc_vize.player_id = tonumber(arg_id)
									end
								end
								MODULE.LeadTools.vc_vize.bool = true
								sampSendChat("/lmenu")
								break
							elseif line == '{give_platoon}' then
								if cmd_arg == '{arg_id}' then
									MODULE.LeadTools.platoon.player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										MODULE.LeadTools.platoon.player_id = arg_id
									end
								end
								MODULE.LeadTools.platoon.check = true
								sampSendChat("/platoon")
								break
							elseif line == '{show_rank_menu}' then
								if cmd_arg == '{arg_id}' then
									player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										player_id = arg_id
									end
								end
								MODULE.GiveRank.Window[0] = true
								break
							elseif line == "{pause}" then
								sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. chat_cmd .. ' поставлена на паузу!', message_color)
								MODULE.Binder.state.isPause = true
								MODULE.CommandPause.Window[0] = true
								while MODULE.Binder.state.isPause do
									wait(0)
								end
								if not MODULE.Binder.state.isStop then
									sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. chat_cmd, message_color)	
								end			
							elseif line:find('{wait%[(%d+)%]}') then
								wait(tonumber(string.match(line, '{wait%[(%d+)%]}')))
							else
								if not MODULE.Binder.state.isStop then
									if line_index ~= 1 then wait(cmd_waiting * 1000) end
									if not MODULE.Binder.state.isStop then 
										for tag, replacement in pairs(MODULE.Binder.tags) do
											if line:find("{" .. tag .. "}") then
												local success, result = pcall(string.gsub, line, "{" .. tag .. "}", function() return replacement() end)
												if success then
													line = result
												end
											end
										end
										sampSendChat(line)
									end
								else
									MODULE.Binder.state.isStop = false 
									MODULE.Binder.state.isActive = false
									if isMonetLoader() and settings.general.mobile_stop_button then
										MODULE.CommandStop.Window[0] = false
									end
									sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 	
									break
								end
							end
						end
					end
					MODULE.Binder.state.isActive = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						MODULE.CommandStop.Window[0] = false
					end
				end)
			end
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)
end
function info_stop_command()
	if isMonetLoader() and settings.general.mobile_stop_button then
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
		MODULE.CommandStop.Window[0] = true
	elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop then
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
	else
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
	end
end
function find_and_use_command(cmd, cmd_arg)
	for _, command in ipairs(modules.commands.data.commands.my) do
		if command.enable and command.text:find(cmd) then
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
		end
	end
	for _, command in ipairs(modules.commands.data.commands_manage.my) do
		if command.enable and command.text:find(cmd) then
			sampProcessChatInput("/" .. command.cmd .. " " .. cmd_arg)
			return
		end
	end
	sampAddChatMessage('[Arizona Helper] {ffffff}Не могу найти бинд этой команды! Попробуйте сбросить настройки', message_color)
	playNotifySound()
end
function initialize_commands()
	sampRegisterChatCommand("helper", function() 
		MODULE.Main.Window[0] = not MODULE.Main.Window[0] 
	end)
	sampRegisterChatCommand("hm", show_fast_menu)
	sampRegisterChatCommand("stop", function() 
		if MODULE.Binder.state.isActive then 
			MODULE.Binder.state.isStop = true
		else 
			sampAddChatMessage('[Arizona Helper] {ffffff}В данный момент нету никакой активной команды/отыгровки!', message_color) 
		end
	end)
	sampRegisterChatCommand("fixsize", function()
		settings.general.custom_dpi = 1.0
		settings.general.autofind_dpi = false
		sampAddChatMessage('[Arizona Helper] {ffffff}Размер менюшек хелпера сброшен к стандартным! Перезапуск...', message_color)
		save_settings()
		reload_script = true
		thisScript():reload()
	end)
	sampRegisterChatCommand("rpguns", function()
		MODULE.RPWeapon.Window[0] = not MODULE.RPWeapon.Window[0] 
	end)
	sampRegisterChatCommand("pnv", function()
		if not MODULE.Binder.state.isActive then
			MODULE.NightVision = not MODULE.NightVision
			setNightVision(MODULE.NightVision)
			MODULE.InfraredVision = false
			setInfraredVision(MODULE.InfraredVision)
			if MODULE.NightVision then
				sampSendChat('/me достаёт из кармана очки ночного видения и надевает их')
			else
				sampSendChat('/me снимает с себя очки ночного видения и убирает их в карман')
			end	
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)
	sampRegisterChatCommand("irv", function()
		if not MODULE.Binder.state.isActive then
			MODULE.InfraredVision = not MODULE.InfraredVision
			setInfraredVision(MODULE.InfraredVision)
			MODULE.NightVision = false
			setNightVision(MODULE.NightVision)	
			if MODULE.InfraredVision then
				sampSendChat('/me достаёт из кармана инфракрасные очки и надевает их')
			else
				sampSendChat('/me снимает с себя инфракрасные очки и убирает их в карман')
			end
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)
	sampRegisterChatCommand("cruise", function()
		if not MODULE.Binder.state.isActive then
			if settings.general.cruise_control then
				if MODULE.CruiseControl.active then
					MODULE.CruiseControl.active = false
					if isCharInAnyCar(PLAYER_PED) then
						taskWarpCharIntoCarAsDriver(PLAYER_PED, storeCarCharIsInNoSave(PLAYER_PED))
					end
					sampAddChatMessage('[Arizona Helper] {ffffff} Режим "CRUISE CONTROL" отключен!', message_color)
				else
					if not isCharInAnyCar(PLAYER_PED) then
						sampAddChatMessage('[Arizona Helper] {ffffff}Вы должны находиться в транспортном средстве!', message_color)
						return
					end
					local car = storeCarCharIsInNoSave(PLAYER_PED)
					if not (isCarEngineOn(car)) then
						sampAddChatMessage('[Arizona Helper] {ffffff}Заведите двигатель вашего транспортного средства!', message_color)
						return
					end

					local driver = getDriverOfCar(car)
					if driver ~= PLAYER_PED then
						sampAddChatMessage('[Arizona Helper] {ffffff}Вы должны быть водителем транспортного средства!', message_color)
						return
					end

					local bool, x, y, z = getTargetBlipCoordinates()
					if bool then
						sampAddChatMessage('[Arizona Helper] {ffffff}Удалите свою старую метку с карты!', message_color)
						return
					end

					MODULE.CruiseControl.point = {x = 0, y = 0, z = 0}
					MODULE.CruiseControl.wait_point = true
					sampAddChatMessage('[Arizona Helper] {ffffff}Выберите пункт назнанения (поставьте метку на карте)', message_color)
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff} Данная функция отключена в настройках хелпера!', message_color)
			end
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)
	sampRegisterChatCommand("debug", function() 
		MODULE.DEBUG = not MODULE.DEBUG 
		sampAddChatMessage('[Arizona Helper] {ffffff}Отслеживание данных с сервера ' .. (MODULE.DEBUG and 'включено!' or 'выключено!'), message_color) 
	end)

	if not isMode('none') then
		sampRegisterChatCommand("mb", function(arg)
			if not MODULE.Binder.state.isActive then
				if MODULE.Members.Window[0] then
					MODULE.Members.Window[0] = false
					MODULE.Members.upd.check = false
					sampAddChatMessage('[Arizona Helper] {ffffff}Меню списка сотрудников закрыто!', message_color)
				else
					MODULE.Members.new = {} 
					MODULE.Members.info.check = true 
					sampSendChat("/members")
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
		sampRegisterChatCommand("dep", function(arg)
			if not MODULE.Binder.state.isActive then
				MODULE.Departament.Window[0] = not MODULE.Departament.Window[0]
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
		sampRegisterChatCommand("sob", function(arg)
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					player_id = tonumber(arg)
					MODULE.Sobes.Window[0] = not MODULE.Sobes.Window[0]
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/sob [ID игрока]', message_color)
					playNotifySound()
				end	
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
	end

	if isMode('police') or isMode('fbi') then
		sampRegisterChatCommand("sum", function(arg) 
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					if #modules.smart_uk.data ~= 0 then
						player_id = tonumber(arg)
						MODULE.SumMenu.Window[0] = true 
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сначало загрузите/заполните систему умного розыска в /helper - Функции орги', message_color)
						playNotifySound()
					end
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/sum [ID игрока]', message_color)
					playNotifySound()
				end	
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
		sampRegisterChatCommand("tsm", function(arg) 
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					if #modules.smart_pdd.data ~= 0 then
						player_id = tonumber(arg)
						MODULE.TsmMenu.Window[0] = true
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сначало загрузите/заполните систему умных штрафов в /helper - Функции орги', message_color)
						playNotifySound()
					end
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/tsm [ID игрока]', message_color)
					playNotifySound()
				end	
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
		sampRegisterChatCommand("meg", function()
			MODULE.Megafon.Window[0] = not MODULE.Megafon.Window[0]
		end)
		sampRegisterChatCommand("afind", function(arg)
			send_no_vip_msg()
		end)
		sampRegisterChatCommand("wanted", function(arg)
			sampSendChat('/wanted ' .. arg)
			sampAddChatMessage('[Arizona Helper] {ffffff}Лучше используйте /wanteds для автосканирования всего вантеда!', message_color)
		end)
		sampRegisterChatCommand("wanteds", function(arg)
			if MODULE.Wanted.Window[0] or MODULE.Wanted.updwanteds.stop then
				MODULE.Wanted.Window[0] = false
				MODULE.Wanted.check_wanted = false
				MODULE.Wanted.updwanteds.check = false
				sampAddChatMessage('[Arizona Helper] {ffffff}Меню списка преступников закрыто!', message_color)
			elseif not MODULE.Binder.state.isActive then
				lua_thread.create(function()
					local max_lvl = isMode('fbi') and 7 or 6
					sampAddChatMessage('[Arizona Helper] {ffffff}Сканирование /wanted, ожидайте ' .. message_color_hex .. max_lvl .. ' {ffffff}секунд...', message_color)
					show_arz_notify('info', 'Arizona Helper', "Сканирование /wanted...", 2500)
					MODULE.Wanted.wanted_new = {}
					MODULE.Wanted.check_wanted = true
					for i = max_lvl, 1, -1 do
						printStringNow("CHECK WANTED " .. i, 1000)
						sampSendChat('/wanted ' .. i)
						wait(1000)
					end
					MODULE.Wanted.check_wanted = false
					if #MODULE.Wanted.wanted_new == 0 then
						sampAddChatMessage('[Arizona Helper] {ffffff}Сейчас на сервере нету игроков с розыском!', message_color)
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сканирование /wanted окончено! Найдено преступников: ' .. #MODULE.Wanted.wanted_new, message_color)
						MODULE.Wanted.wanted = MODULE.Wanted.wanted_new
						MODULE.Wanted.updwanteds.stop = false
						MODULE.Wanted.updwanteds.time = 0
						MODULE.Wanted.updwanteds.last_time = os.time()
						MODULE.Wanted.updwanteds.check = true
						MODULE.Wanted.Window[0] = true
					end
				end)
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
		sampRegisterChatCommand("patrool", function(arg)
			if not MODULE.Binder.state.isActive then
				if isCharInAnyCar(PLAYER_PED) or MODULE.Patrool.Window[0] then
					MODULE.Patrool.Window[0] = not MODULE.Patrool.Window[0]
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Нельзя начать патруль, вы должны быть в т/с!', message_color)
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
	end

	if not (isMode('ghetto') or isMode('mafia') or isMode('judge')) then
		sampRegisterChatCommand("post", function(arg)
			if not MODULE.Binder.state.isActive then
				MODULE.Post.Window[0] = not MODULE.Post.Window[0]
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
	end

	if isMode('prison') then
		sampRegisterChatCommand("pum", function(arg) 
			if not MODULE.Binder.state.isActive then
				if isParamSampID(arg) then
					if #modules.smart_rptp.data ~= 0 then
						player_id = tonumber(arg)
						MODULE.PumMenu.Window[0] = true 
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сначало загрузите/заполните систему умного срока в /helper - Функции орги', message_color)
						playNotifySound()
					end
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/pum [ID игрока]', message_color)
					playNotifySound()
				end	
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
	end

	registerCommandsFrom(modules.commands.data.commands.my)

	if settings.player_info.fraction_rank_number >= 9 then
		sampRegisterChatCommand("lm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not MODULE.Binder.state.isActive then
				lua_thread.create(function()
					MODULE.Binder.state.isActive = true
					info_stop_command()
					sampSendChat("/rb Внимание! Через 15 секунд будет спавн транспорта организации.")
					wait(1500)
					if MODULE.Binder.state.isStop then 
						MODULE.Binder.state.isStop = false 
						MODULE.Binder.state.isActive = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							MODULE.CommandStop.Window[0] = false
						end
						sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
						return
					end
					sampSendChat("/rb Займите транспорт, иначе он будет заспавнен.")
					wait(13500)	
					if MODULE.Binder.state.isStop then 
						MODULE.Binder.state.isStop = false 
						MODULE.Binder.state.isActive = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							MODULE.CommandStop.Window[0] = false
						end
						sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
						return
					end
					MODULE.LeadTools.spawncar = true
					sampSendChat("/lmenu")
					MODULE.Binder.state.isActive = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						MODULE.CommandStop.Window[0] = false
					end
				end)
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			end
		end)
		registerCommandsFrom(modules.commands.data.commands_manage.my)
	end
end
function get_fraction_cmds(selected, is_manage)
    local cmds = {}
    local function append_commands(from_table)
        if from_table then
            for _, cmd in ipairs(from_table) do
                table.insert(cmds, cmd)
            end
        end
    end
	if is_manage then
		if selected == 'mafia' then
			append_commands(modules.commands.data.commands_manage.mafia)
		elseif selected == 'ghetto' then
			append_commands(modules.commands.data.commands_manage.ghetto)
		else
			append_commands(modules.commands.data.commands_manage.goss)
			if selected == 'fbi' then
				append_commands(modules.commands.data.commands_manage.goss_fbi)
			elseif selected == 'prison' then
				append_commands(modules.commands.data.commands_manage.goss_prison)
			elseif selected == 'gov' then
				append_commands(modules.commands.data.commands_manage.goss_gov)
			end
		end
	else
		if selected == 'police' then
			append_commands(modules.commands.data.commands.police)
		elseif selected == 'fbi' then
			append_commands(modules.commands.data.commands.police)
			append_commands(modules.commands.data.commands.fbi)
		elseif selected == 'hospital' then
			append_commands(modules.commands.data.commands.hospital)
		elseif selected == 'smi' then
			append_commands(modules.commands.data.commands.smi)
		elseif selected == 'army' then
			append_commands(modules.commands.data.commands.army)
		elseif selected == 'prison' then
			append_commands(modules.commands.data.commands.prison)
			append_commands(modules.commands.data.commands.army)
		elseif selected == 'lc' then
			append_commands(modules.commands.data.commands.lc)
		elseif selected == 'gov' then
			append_commands(modules.commands.data.commands.gov)
		elseif selected == 'ins' then
			append_commands(modules.commands.data.commands.ins)
		elseif selected == 'fd' then
			append_commands(modules.commands.data.commands.fd)
		elseif selected == 'mafia' then
			append_commands(modules.commands.data.commands.mafia)
		elseif selected == 'ghetto' then
			append_commands(modules.commands.data.commands.ghetto)
		end
	end
    return cmds
end
function delete_default_fraction_cmds(my_cmds, default_cmds)
	for i = #my_cmds, 1, -1 do
		for _, def in ipairs(default_cmds) do
			if my_cmds[i].cmd == def.cmd then
				table.remove(my_cmds, i)
				break
			end
		end
	end
end
function add_notes(module)
	local function add_unique(tbl, note)
		for _, v in ipairs(tbl) do
			if v.note_text == note.note_text then
				return
			end
		end
		table.insert(tbl, note)
	end

	local situate_codes = {note_name = 'Ситуационные коды', note_text = 'CODE 0 - Офицер ранен.&CODE 1 - Офицер в бедственном положении, нужна помощь всех юнитов.&CODE 2 - Обычный вызов [без сирен/стробоскопов/соблюдение ПДД].&CODE 2 HIGHT - Приоритетный вызов [без сирен/стробоскопов/соблюдение ПДД].&CODE 3 - Срочный вызов [сирены, стробоскопы, игнорирования ПДД].&CODE 4 - Стабильно, помощь не требуется.&Code 4 ADAM - Помощь не требуется, но офицеры поблизости должны быть готовы оказать помощь.&CODE 5 - Офицерам держаться подальше от опасного места.&CODE 6 - Задерживаюсь на месте [включая локацию и причину,например, 911].&CODE 7 - Перерыв на обед.&CODE 30 - Срабатывание "тихой" сигнализации на месте происшествия.&CODE 30 RINGER - Срабатывание "громкой сигнализации на месте происшествия.&CODE 37 - Обнаружение угнанного т/c.&Сode TOM - Офицеру требуется Тайзер.' }
	local teen_codes = { note_name = 'Тен-коды', note_text = '10-1 - Сбор всех офицеров на дежурстве.&10-2 - Вышел в патруль.&10-2R - Закончил патруль.&10-3 - Радиомолчание.&10-4 - Принято.&10-5 - Повторите.&10-6 - Не принято/неверно/нет.&10-7 - Ожидайте.&10-8 - Не доступен/занят.&10-14 - Запрос транспортировки.&10-15 - Подозреваемые арестованы.&10-18 - Требуется поддержка дополнительных юнитов.&10-20 - Локация.&10-21 - Статус и местонахождение.&10-22 - Выдвигайтесь к локации.&10-27 - Меняю маркировку патруля.&10-30 - Дорожно-транспортное происшествие.&10-40 - Большое скопление людей (более 4).&10-41 - Нелегальная активность.&10-46 - Провожу обыск.&10-55 - Траффик стоп.&10-57 VICTOR - Погоня за автомобилем.&10-57 FOXTROT - Пешая погоня.&10-66 - Траффик стоп повышенного риска.&10-70 - Запрос поддержки.&10-71 - Запрос медицинской поддержки.&10-88 - Теракт/ЧС.&10-99 - Ситуация урегулирована.&10-100 Временно недоступен для вызовов.' }
	add_unique(modules.notes.data, situate_codes)
	add_unique(modules.notes.data, teen_codes)

	if module ~= 'prison' then
		local markup_patrool = { note_name = 'Маркировки патруля', note_text = 'Основные:&ADAM [A] - Патруль из 2/3 офицеров на крузере.&LINCOLN [L] - Одиночный патруль на крузере.&MARY [M] - Одиночный патруль на мотоцикле.&HENRY [H] - Высокоскоростой патруль.&AIR [AIR] - Воздушный патруль.&Air Support Division [ASD] - Воздушная поддержка.&&Дополнительные:&CHARLIE [C] - Группа захвата.&ROBERT [R] - Отдел Детективов.&SUPERVISOR [SV] - Руководящий состав.&DAVID [D] - Cпециальный отдел SWAT.&EDWARD [E] - Эвакуатор полиции.&NORA [N] - немаркированная единица патруля.'}
		add_unique(modules.notes.data, markup_patrool)
	end

	save_module('notes')
end
local russian_characters = {
    [168] = 'Ё', [184] = 'ё', [192] = 'А', [193] = 'Б', [194] = 'В', [195] = 'Г', [196] = 'Д', [197] = 'Е', [198] = 'Ж', [199] = 'З', [200] = 'И', [201] = 'Й', [202] = 'К', [203] = 'Л', [204] = 'М', [205] = 'Н', [206] = 'О', [207] = 'П', [208] = 'Р', [209] = 'С', [210] = 'Т', [211] = 'У', [212] = 'Ф', [213] = 'Х', [214] = 'Ц', [215] = 'Ч', [216] = 'Ш', [217] = 'Щ', [218] = 'Ъ', [219] = 'Ы', [220] = 'Ь', [221] = 'Э', [222] = 'Ю', [223] = 'Я', [224] = 'а', [225] = 'б', [226] = 'в', [227] = 'г', [228] = 'д', [229] = 'е', [230] = 'ж', [231] = 'з', [232] = 'и', [233] = 'й', [234] = 'к', [235] = 'л', [236] = 'м', [237] = 'н', [238] = 'о', [239] = 'п', [240] = 'р', [241] = 'с', [242] = 'т', [243] = 'у', [244] = 'ф', [245] = 'х', [246] = 'ц', [247] = 'ч', [248] = 'ш', [249] = 'щ', [250] = 'ъ', [251] = 'ы', [252] = 'ь', [253] = 'э', [254] = 'ю', [255] = 'я',
}
function string.rlower(s)
    s = s:lower()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:lower()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 192 and ch <= 223 then -- upper russian characters
            output = output .. russian_characters[ch + 32]
        elseif ch == 168 then -- Ё
            output = output .. russian_characters[184]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function string.rupper(s)
    s = s:upper()
    local strlen = s:len()
    if strlen == 0 then return s end
    s = s:upper()
    local output = ''
    for i = 1, strlen do
        local ch = s:byte(i)
        if ch >= 224 and ch <= 255 then -- lower russian characters
            output = output .. russian_characters[ch - 32]
        elseif ch == 184 then -- ё
            output = output .. russian_characters[168]
        else
            output = output .. string.char(ch)
        end
    end
    return output
end
function TranslateNick(name)
	if name:match('%a+') then
        for k, v in pairs({['ph'] = 'ф',['Ph'] = 'Ф',['Ch'] = 'Ч',['ch'] = 'ч',['Th'] = 'Т',['th'] = 'т',['Sh'] = 'Ш',['sh'] = 'ш' ,['Ae'] = 'Э',['ae'] = 'э',['size'] = 'сайз',['Jj'] = 'Джейджей',['Whi'] = 'Вай',['lack'] = 'лэк',['whi'] = 'вай',['Ck'] = 'К',['ck'] = 'к',['Kh'] = 'Х',['kh'] = 'х',['hn'] = 'н',['Hen'] = 'Ген',['Zh'] = 'Ж',['zh'] = 'ж',['Yu'] = 'Ю',['yu'] = 'ю',['Yo'] = 'Ё',['yo'] = 'ё',['Cz'] = 'Ц',['cz'] = 'ц', ['ia'] = 'я', ['ea'] = 'и',['Ya'] = 'Я', ['ya'] = 'я', ['ove'] = 'ав',['ay'] = 'эй', ['rise'] = 'райз',['oo'] = 'у', ['Oo'] = 'У', ['Ee'] = 'И', ['ee'] = 'и', ['Un'] = 'Ан', ['un'] = 'ан', ['Ci'] = 'Ци', ['ci'] = 'ци', ['yse'] = 'уз', ['cate'] = 'кейт', ['eow'] = 'яу', ['rown'] = 'раун', ['yev'] = 'уев', ['Babe'] = 'Бэйби', ['Jason'] = 'Джейсон', ['Alexei'] = 'Алексей', ['Alex'] = 'Алекс', ['liy'] = 'лий', ['ane'] = 'ейн', ['ame'] = 'ейм'}) do
            name = name:gsub(k, v) 
        end
		for k, v in pairs({['B'] = 'Б',['Z'] = 'З',['T'] = 'Т',['Y'] = 'Й',['P'] = 'П',['J'] = 'Дж',['X'] = 'Кс',['G'] = 'Г',['V'] = 'В',['H'] = 'Х',['N'] = 'Н',['E'] = 'Е',['I'] = 'И',['D'] = 'Д',['O'] = 'О',['K'] = 'К',['F'] = 'Ф',['y`'] = 'ы',['e`'] = 'э',['A'] = 'А',['C'] = 'К',['L'] = 'Л',['M'] = 'М',['W'] = 'В',['Q'] = 'К',['U'] = 'А',['R'] = 'Р',['S'] = 'С',['zm'] = 'зьм',['h'] = 'х',['q'] = 'к',['y'] = 'и',['a'] = 'а',['w'] = 'в',['b'] = 'б',['v'] = 'в',['g'] = 'г',['d'] = 'д',['e'] = 'е',['z'] = 'з',['i'] = 'и',['j'] = 'ж',['k'] = 'к',['l'] = 'л',['m'] = 'м',['n'] = 'н',['o'] = 'о',['p'] = 'п',['r'] = 'р',['s'] = 'с',['t'] = 'т',['u'] = 'у',['f'] = 'ф',['x'] = 'x',['c'] = 'к',['``'] = 'ъ',['`'] = 'ь',['_'] = ' '}) do
            name = name:gsub(k, v) 
        end
        return name
    end
	return name
end
function ReverseTranslateNick(name)
    local translit_table = {
        ['ф'] = 'f', ['Ф'] = 'F', ['ч'] = 'ch', ['Ч'] = 'Ch',
        ['т'] = 't', ['Т'] = 'T', ['ш'] = 'sh', ['Ш'] = 'Sh',
        ['и'] = 'i', ['Э'] = 'E', ['э'] = 'e', ['с'] = 's',
        ['ж'] = 'zh', ['Ж'] = 'Zh', ['ю'] = 'yu', ['Ю'] = 'Yu',
        ['ё'] = 'yo', ['Ё'] = 'Yo', ['ц'] = 'ts', ['Ц'] = 'Ts',
        ['я'] = 'ya', ['Я'] = 'Ya', ['ав'] = 'ov', ['эй'] = 'ey',
        ['у'] = 'u', ['У'] = 'U', ['И'] = 'I', ['ан'] = 'an',
        ['ци'] = 'tsi', ['уз'] = 'uz', ['кейт'] = 'kate', ['яу'] = 'yau',
        ['раун'] = 'rown', ['уев'] = 'uev', ['Бэйби'] = 'Baby',
        ['Джейсон'] = 'Jason', ['Алексей'] = 'Alexei', ['Алекс'] = 'Alex', ['лий'] = 'liy', ['ейн'] = 'ein', ['ейм'] = 'ame'
    } 
    for k, v in pairs(translit_table) do
        name = name:gsub(k, v)
    end 
    local char_table = {
        ['А'] = 'A', ['Б'] = 'B', ['В'] = 'V', ['Г'] = 'G', ['Д'] = 'D',
        ['Е'] = 'E', ['Ё'] = 'Yo', ['Ж'] = 'Zh', ['З'] = 'Z', ['И'] = 'I',
        ['Й'] = 'Y', ['К'] = 'K', ['Л'] = 'L', ['М'] = 'M', ['Н'] = 'N',
        ['О'] = 'O', ['П'] = 'P', ['Р'] = 'R', ['С'] = 'S', ['Т'] = 'T',
        ['У'] = 'U', ['Ф'] = 'F', ['Х'] = 'H', ['Ц'] = 'Ts', ['Ч'] = 'Ch',
        ['Ш'] = 'Sh', ['Щ'] = 'Sch', ['Ъ'] = '', ['Ы'] = 'Y', ['Ь'] = '',
        ['Э'] = 'E', ['Ю'] = 'Yu', ['Я'] = 'Ya',
        ['а'] = 'a', ['б'] = 'b', ['в'] = 'v', ['г'] = 'g', ['д'] = 'd',
        ['е'] = 'e', ['ё'] = 'yo', ['ж'] = 'zh', ['з'] = 'z', ['и'] = 'i',
        ['й'] = 'y', ['к'] = 'k', ['л'] = 'l', ['м'] = 'm', ['н'] = 'n',
        ['о'] = 'o', ['п'] = 'p', ['р'] = 'r', ['с'] = 's', ['т'] = 't',
        ['у'] = 'u', ['ф'] = 'f', ['х'] = 'h', ['ц'] = 'ts', ['ч'] = 'ch',
        ['ш'] = 'sh', ['щ'] = 'sch', ['ъ'] = '', ['ы'] = 'y', ['ь'] = '',
        ['э'] = 'e', ['ю'] = 'yu', ['я'] = 'ya', [' '] = '_'
    }
    for k, v in pairs(char_table) do
        name = name:gsub(k, v)
    end
    return name
end
function isParamSampID(id)
	id = tonumber(id)
	if id ~= nil and tostring(id):find('%d') and not tostring(id):find('%D') and string.len(id) >= 1 and string.len(id) <= 3 then
		if id == select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) then
			return true
		elseif sampIsPlayerConnected(id) then
			return true
		end
	end
	return false
end
function playNotifySound()
	local path_audio = configDirectory .. "/Resourse/notify.mp3"
	if doesFileExist(path_audio) then
		local audio = loadAudioStream(path_audio)
		setAudioStreamState(audio, 1)
	end
end
function show_fast_menu(id)
	if isParamSampID(id) then 
		player_id = tonumber(id)
		MODULE.FastMenu.Window[0] = true
	else
		if isMonetLoader() or settings.general.bind_fastmenu == nil then
			if not MODULE.FastMenuPlayers.Window[0] then
				sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/hm [ID]', message_color)
			end
		elseif settings.general.bind_fastmenu and hotkey_no_errors then
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/hm [ID] {ffffff}или наведитесь на игрока через ' .. message_color_hex .. 'ПКМ + ' .. getNameKeysFrom(settings.general.bind_fastmenu), message_color) 
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/hm [ID]', message_color)
		end 
		playNotifySound()
	end 
end
function show_leader_fast_menu(id)
	if isParamSampID(id) then
		player_id = tonumber(id)
		MODULE.LeaderFastMenu.Window[0] = true
	else
		if isMonetLoader() or settings.general.bind_leader_fastmenu == nil then
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/lm [ID]', message_color)
		elseif settings.general.bind_leader_fastmenu and hotkey_no_errors then
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/lm [ID] {ffffff}или наведитесь на игрока через ' .. message_color_hex .. 'ПКМ + ' .. getNameKeysFrom(settings.general.bind_leader_fastmenu), message_color) 
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/lm [ID]', message_color)
		end 
		playNotifySound()
	end
end
function get_players()
	local myPlayerId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
	local playersInRange = {}
	for temp1, h in pairs(getAllChars()) do
		temp2, id = sampGetPlayerIdByCharHandle(h)
		temp3, m = sampGetPlayerIdByCharHandle(PLAYER_PED)
		id = tonumber(id)
		if id ~= -1 and id ~= m and doesCharExist(h) then
			local x, y, z = getCharCoordinates(h)
			local mx, my, mz = getCharCoordinates(PLAYER_PED)
			local dist = getDistanceBetweenCoords3d(mx, my, mz, x, y, z)
			if dist <= 5 then
				table.insert(playersInRange, id)
			end
		end
	end
	return playersInRange
end
function openLink(link)
	if isMonetLoader() then
		ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]]
		ffi.load('GTASA')._Z12AND_OpenLinkPKc(link)
	else
		os.execute("explorer " .. link)
	end
end
local servers = {
	{name = 'Unknown server', number = '00'},
	-- Arizona
	{name = 'Phoenix', number = '01'},
	{name = 'Tucson', number = '02'},
	{name = 'Scottdale', number = '03'},
	{name = 'Chandler', number = '04'},
	{name = 'Brainburg', number = '05'},
	{name = 'SaintRose', number = '06'},
	{name = 'Mesa', number = '07'},
	{name = 'Red Rock', number = '08'},
	{name = 'Yuma', number = '09'},
	{name = 'Surprise', number = '10'},
	{name = 'Prescott', number = '11'},
	{name = 'Glendale', number = '12'},
	{name = 'Kingman', number = '13'},
	{name = 'Winslow', number = '14'},
	{name = 'Payson', number = '15'},
	{name = 'Gilbert', number = '16'},
	{name = 'Show Low', number = '17'},
	{name = 'Casa Grande', number = '18'},
	{name = 'Page', number = '19'},
	{name = 'Sun City', number = '20'},
	{name = 'Queen Creek', number = '21'},
	{name = 'Sedona', number = '22'},
	{name = 'Holiday', number = '23'},
	{name = 'Wednesday', number = '24'},
	{name = 'Yava', number = '25'},
	{name = 'Faraway', number = '26'},
	{name = 'Bumble Bee', number = '27'},
	{name = 'Christmas', number = '28'},
	{name = 'Mirage', number = '29'},
	{name = 'Love', number = '30'},
	{name = 'Drake', number = '31'},
	{name = 'Space', number = '32'},
	-- Arizona Mobile
	{name = 'Mobile III', number = '103'},
	{name = 'Mobile II', number = '102'},
	{name = 'Mobile I', number = '101'},
	-- Arizona VC
	{name = 'Vice City'	, number = '200'},
	-- Rodina
	{name = 'Центральный округ'	, number = '301'},
	{name = 'Южный округ', number = '302'},
	{name = 'Северный округ', number = '303'},
	{name = 'Восточный округ', number = '304'},
	{name = 'Западный округ', number = '305'},
	{name = 'Приморский округ', number = '306'},
	{name = 'Федеральный округ', number = '307'},
	-- Rodina Mobile
	{name = 'Москва', number = '401'},
}
function getServerNumber()
	local server = "00"
	for _, s in ipairs(servers) do
		if sampGetCurrentServerName():gsub('%-', ' '):find(s.name) then
			server = s.number
			break
		end
	end
	return server
end
function getServerName(number)
	local server = ''
	for _, s in ipairs(servers) do
		if tostring(number) == tostring(s.number) then
			server = s.name
			break
		end
	end
	return server
end
function sampGetPlayerIdByNickname(nick)
	local id = -1

	if not isMonetLoader() then
		local myid = select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
		if sampGetPlayerNickname(myid) == (nick) then return myid end
	end

	for i = 0, 999 do
	    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):find(nick) then
		   id = i
		   break
	    end
	end
	return id
end
function getNameOfARZVehicleModel(id)
	local need_download_arzveh = false
	if doesFileExist(modules.arz_veh.path) and modules.arz_veh.data and #modules.arz_veh.data ~= 0 then
		local check = false
		for _, vehicle in ipairs(modules.arz_veh.data) do
			if vehicle.model_id == id then
				check = true
				--sampAddChatMessage("[Arizona Helper] {ffffff}Самый ближайший транспорт к вам это " .. vehicle.name ..  " [ID " .. id .. "].", message_color)
				return vehicle.name
			end
		end
		if not check then
			need_download_arzveh = true
		end
	else
		need_download_arzveh = true
	end
	if need_download_arzveh then
		sampAddChatMessage('[Arizona Helper] {ffffff}Нет названия модели т/c с ID ' .. id .. ", так как отсуствует файл Vehicles.json", message_color)
		sampAddChatMessage('[Arizona Helper] {ffffff}Использую просто "транспортного средства", и пытаюсь скачать файл...', message_color)
		download_file = 'arz_veh'
		if tonumber(getServerNumber()) > 300 then
			downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/SmartVEH/VehiclesRodina.json', modules.arz_veh.path)
		else
			downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/SmartVEH/Vehicles.json', modules.arz_veh.path)
		end
		return 'транспортного средства'
	end
end
function getAreaRu(x, y, z)
	local streets = {
		{"Гольф-клуб Ависпа", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
		{"Аэропорт СФ", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
		{"Гольф-клуб Ависпа", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
		{"Аэропорт СФ", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
		{"Гарсия", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
		{"Тенистые ручьи", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
		{"Восточный ЛС", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
		{"Грузовой склад ЛВ", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
		{"Блэкфилдский перекрёсток", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
		{"Гольф-клуб Ависпа", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
		{"Темпл драйв", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
		{"Вокзал ЛС", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
		{"Грузовой склад ЛВ", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
		{"Лос-Флорес", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
		{"Азартный район", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
		{"Истербэйский химзавод", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
		{"Центральный район СФ", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
		{"Восточная Эспаланда", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
		{"Станция Маркет", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
		{"Вокзал ЛВ", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
		{"Перекрёсток Монтгомери", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
		{"Мост Фредерик", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
		{"Станция Йеллоу-Белл", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
		{"Центральный район СФ", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
		{"Отель Ночные волки", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
		{"Гора Вайнвуд", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
		{"Гольф-клуб Ависпа", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
		{"Больница Джефферсон", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
		{"Западаное шоссе", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
		{"Джефферсон", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
		{"Северное шоссе ЛВ", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
		{"Родео драйв", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
		{"Вокзал СФ", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
		{"Центральный район СФ", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
		{"Западный Редсандс", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
		{"Маленькая Мексика", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
		{"Блэкфилдский перекрёсток", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
		{"Аэропорт ЛС", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
		{"Бекон-Хилл", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
		{"Родео драйв", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
		{"Гора Вайнвуд", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
		{"Центральный район СФ", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
		{"Стрип", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
		{"Центральный район СФ", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
		{"Блэкфилдский перекрёсток", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
		{"Автовокзал", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
		{"Монтгомери", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
		{"Фостерская долина", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
		{"Блэкфилд", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
		{"Аэропорт ЛС", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
		{"Гора Вайнвуд", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
		{"Гольф-корт Йеллоубелл", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
		{"Стрип", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
		{"Джефферсон", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
		{"Гора Вайнвуд", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
		{"Эль-Кебрадос", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
		{"Лас-Колинас", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
		{"Лас-Колинас", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
		{"Гора Вайнвуд", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
		{"Грузовой склад ЛВ", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
		{"Северное шоссе ЛВ", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
		{"Уиллоуфилд", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
		{"Северное шоссе ЛВ", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
		{"Темпл драйв", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
		{"Маленькая Мексика", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
		{"Квинс", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
		{"Аэропорт ЛВ", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
		{"Гора Вайнвуд", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
		{"Темпл драйв", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
		{"Восточный ЛС", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
		{"Восточное шоссе ЛВ", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
		{"Уиллоуфилд", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
		{"Лас-Колинас", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
		{"Восточное шоссе ЛВ", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
		{"Родео драйв", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
		{"Пустынный округ", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
		{"Восточное шоссе ЛВ", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
		{"Родео драйв", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
		{"Вайнвуд", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
		{"Родео драйв", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
		{"Северное шоссе ЛВ", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
		{"Центральный район СФ", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
		{"Родео драйв", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
		{"Джефферсон", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
		{"Туманный округ", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
		{"Темпл драйв", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
		{"Красный ж/д мост", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
		{"Пляж Верона", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
		{"Центральный банк ЛС", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
		{"Гора Вайнвуд", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
		{"Родео драйв", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
		{"Гора Вайнвуд", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
		{"Гора Вайнвуд", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
		{"Южное шоссе ЛВ", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
		{"Айдлвуд", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
		{"Порт ЛС", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
		{"Коммерческий район", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
		{"Северное шоссе ЛВ", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
		{"Темпл драйв", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
		{"Глен Парк", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
		{"Аэропорт ЛВ", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
		{"Мост Мартина", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
		{"Стрип", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
		{"Уиллоуфилд", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
		{"Канал Марина", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
		{"Аэропорт ЛВ", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
		{"Айдлвуд", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
		{"Восточная Эспаланда", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
		{"Центральный район СФ", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
		{"Мост Мако", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
		{"Родео драйв", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
		{"Площадь Першинг", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
		{"Гора Вайнвуд", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
		{"Мост Гант", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
		{"Лас-Колинас", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
		{"Гора Вайнвуд", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
		{"Северное шоссе ЛВ", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
		{"Коммерческий район", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
		{"КПП ЛС-СФ", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
		{"Рока Эскаланте", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
		{"КПП ЛС-СФ", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
		{"Центральный Рынок", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
		{"Лас-Колинас", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
		{"Гора Вайнвуд", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
		{"Кингс", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
		{"Восточный Редсандс", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
		{"Центральный район СФ", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
		{"Автовокзал", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
		{"Гора Вайнвуд", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
		{"Океанское побережье", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
		{"Грингласский колледж", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
		{"Глен Парк", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
		{"Грузовой склад ЛВ", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
		{"Пустынный округ", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
		{"Пляж Верона", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
		{"Восточный ЛС", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
		{"Дворец Калигулы", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
		{"Айдлвуд", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
		{"Пилигрим", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
		{"Айдлвуд", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
		{"Квинс", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
		{"Центральный район СФ", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
		{"Коммерческий район", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
		{"Восточный ЛС", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
		{"Канал Марина", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
		{"Гора Вайнвуд", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
		{"Вайнвуд", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
		{"Восточный ЛС", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
		{"Родео драйв", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
		{"Истерский Тоннель", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
		{"Родео драйв", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
		{"Восточный Редсандс", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
		{"Азартный район", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
		{"БК Рифа", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
		{"Перекрёсток Монтгомери", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
		{"Уиллоуфилд", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
		{"Темпл драйв", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
		{"Прикл Пайн", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
		{"Аэропорт ЛС", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
		{"Белый мост", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
		{"Белый мост", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
		{"Красный ж/д мост", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
		{"Красный ж/д мост", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
		{"Пляж Верона", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
		{"Зелёный утёс", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
		{"Гора Вайнвуд", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
		{"Гора Вайнвуд", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
		{"Коммерческий район", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
		{"Центральный Рынок", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
		{"Западный Рокшор", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
		{"Северное шоссе ЛВ", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
		{"Восточный пляж ЛС", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
		{"Мост Фаллоу", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
		{"Уиллоуфилд", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
		{"Чайнатаун", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
		{"Скалистый массив ЛВ", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
		{"БК Ацтеки", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
		{"Истербэйский химзавод", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
		{"Казино Висадж", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
		{"Океанское побережье", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
		{"Гора Вайнвуд", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
		{"Нефтяной комплекс", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
		{"Гора Вайнвуд", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
		{"Пилигрим", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
		{"БК Вагос", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
		{"Джефферсон", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
		{"Центральный район СФ", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
		{"Центральный район СФ", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
		{"Белый мост", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
		{"Южное шоссе ЛВ", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
		{"Восточный ЛС", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
		{"Грингласский колледж", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
		{"Лас-Колинас", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
		{"Гора Вайнвуд", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
		{"Порт ЛС", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
		{"Восточный ЛС", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
		{"Грув", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
		{"Гольф-клуб Ависпа", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
		{"Уиллоуфилд", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
		{"Северная Эспланада", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
		{"Казино Шулер", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
		{"Порт ЛС", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
		{"Мотель Последний грош", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
		{"Бэйсайнд-Марина", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
		{"Кингс", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
		{"Эль-Корона", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
		{"Блэкфилдская часовня", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
		{"Казино Розовый клюв", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
		{"Западное шоссе", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
		{"Лос-Флорес", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
		{"Казино Висадж", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
		{"Прикл Пайн", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
		{"Пляж Верона", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
		{"Перекрёсток Робада", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
		{"Линден-Сайд", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
		{"Порт ЛС", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
		{"Уиллоуфилд", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
		{"Кингс", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
		{"Коммерческий район", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
		{"Гора Вайнвуд", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
		{"Канал Марина", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
		{"Бэттери Пойнт", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
		{"Казино 4 Дракона", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
		{"Блэкфилд", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
		{"Северное шоссе ЛВ", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
		{"Гольф-корт Йеллоубелл", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
		{"Айдлвуд", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
		{"Западный Редсандс", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
		{"Автошкола", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
		{"Высокогорная лесопилка", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
		{"Лас-Барранкас", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
		{"Казино Пираты", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
		{"Зал суда", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
		{"Гольф-клуб Ависпа", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
		{"Стрип", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
		{"Хашбери", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
		{"Аренда авиатранспорта ЛС", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
		{"Комплекс Уайтвуд", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
		{"Водохранилище ЛВ", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
		{"Эль-Корона", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
		{"Центральный район СФ", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
		{"Фостерская долина", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
		{"Лас-Пайасадас", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
		{"Валле Окултадо", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
		{"Блэкфилдский перекрёсток", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
		{"Гэнтон", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
		{"АэроВокзал СФ СФ", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
		{"Восточный Редсандс", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
		{"Восточная Эспаланда", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
		{"Дворец Калигулы", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
		{"Казино Рояль", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
		{"Гора Вайнвуд", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
		{"Азартный район", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
		{"Гора Вайнвуд", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
		{"Центральный район СФ", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
		{"Хэнкипэнки поинт", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
		{"Военный склад ГСМ", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
		{"Шоссе Гарри-Голд", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
		{"Тоннель Бэйсайд", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
		{"Порт ЛС", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
		{"Гора Вайнвуд", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
		{"Промсклад Рэндольфа", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
		{"Восточный пляж ЛС", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
		{"Пролив Флинт-Уотер", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
		{"Блуберри", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
		{"Вокзал ЛВ", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
		{"Глен Парк", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
		{"Центральный район СФ", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
		{"Западный Редсандс", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
		{"Гора Вайнвуд", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
		{"Мост Гант", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
		{"Большой кратер ЛВ", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
		{"Пересечение Флинт", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
		{"Лас-Колинас", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
		{"Ж/Д депо ЛВ", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
		{"Казино Изумрудный остров", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
		{"Скалистый массив ЛВ", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
		{"Санта-Флора", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
		{"Севилльский бульвар", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
		{"Центральный Рынок", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
		{"Квинс", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
		{"Пересечение Пилсон", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
		{"Спальный район ЛВ", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
		{"Пилигрим", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
		{"Блэкфилд", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
		{"Радиотелескоп", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
		{"Диллимор", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
		{"Эль-Кебрадос", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
		{"Северная Эспланада", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
		{"Аэропорт СФ", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
		{"Изумрудная деревня", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
		{"КПП ЛС-ЛВ", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
		{"Восточный пляж ЛС", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
		{"Пролив Сан-Андреас", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
		{"Тенистые ручьи", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
		{"Больница ЛС", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
		{"Западный Рокшор", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
		{"Прикл Пайн", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
		{"Порт Истер Бейзин", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
		{"Конопляная долина", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
		{"Грузовой склад ЛВ", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
		{"Прикл Пайн", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
		{"Блуберри", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
		{"Скалистый массив ЛВ", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
		{"Центральный район СФ", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
		{"Восточный Рокшор", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
		{"Залив СФ", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
		{"Парадизо", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
		{"Азартный район", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
		{"Стрип-клуб ЛВ", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
		{"Джанипер Хилл", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
		{"Джанипер Холлоу", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
		{"Банковское отделение ЛВ", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
		{"Восточное шоссе ЛВ", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
		{"Пляж Верона", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
		{"Фостерская долина", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
		{"Арко-дель-оесте", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
		{"Автосалон ЛС", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
		{"Зловещий дворец", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
		{"Дамба Шермана", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
		{"Северная Эспланада", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
		{"Финансовый район", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
		{"Гарсия", -2411.220, -222.589, -1.14, 2173.040, 265.243, 200.000},
		{"Монтгомери", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
		{"Т/Ц Ручей", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
		{"Аэропорт ЛС", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
		{"Пляж Санта-Мария", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
		{"КПП ЛС-ЛВ", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
		{"Эйнджел-Пайн", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
		{"Заброшенный аэродром", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
		{"Октан-Спрингс", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
		{"Пилигрим Кам-э-Лот", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
		{"Западный Редсандс", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
		{"Пляж Санта-Мария", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
		{"Зелёный утёс", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
		{"Аэропорт ЛВ", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
		{"Округ Флинт", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
		{"Зелёный утёс", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
		{"Паломино Крик", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
		{"Военная база ЛС", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
		{"Аэропорт СФ", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
		{"Комплекс Уайтвуд", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
		{"Калтон Хейтс", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
		{"Военная база СФ", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
		{"Залив ЛС", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
		{"Доэрти", 2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
		{"Гора Чилиад", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
		{"Форт-Карсон", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
		{"Автобазар", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
		{"Океанское побережье", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
		{"Ферн-Ридж", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
		{"Бэйсайд", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
		{"Аэропорт ЛВ", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
		{"Ферма Блуберри", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
		{"Палисады", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
		{"Скала Норстар", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
		{"Карьер Хантер", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
		{"Аэропорт ЛС", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
		{"Поклонная гора", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
		{"Залив СФ", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
		{"Тюрьма строгого режима", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
		{"Гора Чилиад", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
		{"Гора Чилиад", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
		{"Аэропорт СФ", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
		{"Паноптикум", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
		{"Тенистые ручьи", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
		{"Бэк-о-Бейонд", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
		{"Гора Чилиад", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
		{"Тьерра Робада", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
		{"Округ Флинт", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
		{"Гора Чиллиад", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
		{"Пустынный округ", -480.539, 596.349, -242.990, 869.461, 2993.870, 900.000},
		{"Тьерра Робада", -2997.470, 1659.680, -242.990, -480.539, 2993.870, 900.000},
		{"Окружность СФ", -2997.470, -1115.580, -242.990, -1213.910, 1659.680, 900.000},
		{"Окружность ЛВ", 869.461, 596.349, -242.990, 2997.060, 2993.870, 900.000},
		{"Туманный округ", -1213.910, -768.027, -242.990, 2997.060, 596.349, 900.000},
		{"Окружность ЛС", 44.615, -2892.970, -242.990, 2997.060, -768.027, 900.000}
	}
    for i, v in ipairs(streets) do
        if (x >= v[2]) and (y >= v[3]) and (z >= v[4]) and (x <= v[5]) and (y <= v[6]) and (z <= v[7]) then
            return v[1]
        end
    end
    return 'Неизвестно'
end
function send_no_vip_msg()
	for i = 1, 10, 1 do
		sampAddChatMessage('[Arizona Helper] {ffffff}Ограничение FREE версии! Безлим в подписке MTGVIP (платной версии хелпера)!', message_color)
	end
end
function split_text_into_lines(text, max_length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local new_line = current_line .. (current_line == "" and "" or " ") .. word
		if #new_line > max_length then
			table.insert(lines, current_line)
			current_line = word
		else
			current_line = new_line
		end
	end
	if current_line ~= "" then
		table.insert(lines, current_line)
	end
	return table.concat(lines, "\n")
end
function count_lines_in_text(text, max_length)
	local lines = {}
	local current_line = ""
	for word in text:gmatch("%S+") do
		local new_line = current_line .. (current_line == "" and "" or " ") .. word
		if #new_line > max_length then
			table.insert(lines, current_line)
			current_line = word
		else
			current_line = new_line
		end
	end
	if current_line ~= "" then
		table.insert(lines, current_line)
	end
	return tonumber(#lines)
end
function getDeviceID() 
	if isMonetLoader() then
		local success, id = pcall(function()
			local envu = require("android.jnienv-util")
			envu.LooperPrepare()
			local activity = require("android.jni-raw").activity
			local contentResolver = envu.CallObjectMethod(
				activity,
				"getContentResolver",
				"()Landroid/content/ContentResolver;"
			)
			local ANDROID_ID = envu.GetStaticObjectField(
				"android/provider/Settings$Secure",
				"ANDROID_ID",
				"Ljava/lang/String;"
			)
			local jstr = envu.CallStaticObjectMethod(
				"android/provider/Settings$Secure",
				"getString",
				"(Landroid/content/ContentResolver;Ljava/lang/String;)Ljava/lang/String;",
				contentResolver,
				ANDROID_ID
			)
			local android_id = envu.FromJString(jstr)
			local model = envu.FromJString(envu.GetStaticObjectField("android/os/Build", "MODEL", "Ljava/lang/String;"))
			return android_id .. " (" .. model .. ")"
		end)
		if success and id then
			return id
		end
	else
		local success, id = pcall(function()
			ffi.cdef[[
				int __stdcall GetVolumeInformationA(
						const char* lpRootPathName,
						char* lpVolumeNameBuffer,
						uint32_t nVolumeNameSize,
						uint32_t* lpVolumeSerialNumber,
						uint32_t* lpMaximumComponentLength,
						uint32_t* lpFileSystemFlags,
						char* lpFileSystemNameBuffer,
						uint32_t nFileSystemNameSize
				);
				]]
			local serial = ffi.new("unsigned long[1]", 0)
			ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
			return serial[0]
		end)
		if success and id then 
			return string.format("%08X", id)
		end
	end
	return 'Unknown'
end
function downloadFileFromUrlToPath(url, path)
	print('Начинаю скачивание файла в ' .. path)
	local function on_finish_download()
		if download_file == 'update' then
			local function readJsonFile(filePath)
				if not doesFileExist(filePath) then
					print('Ошибка: Файл "' .. filePath .. ' не существует')
					return nil
				end
				local file, err = io.open(filePath, "r")
				if not file then
					print('Ошибка: Не удалось открыть файл "' .. filePath .. '": ' .. tostring(err))
					return nil
				end
				local content = file:read("*a")
				file:close()
				local jsonData = decodeJson(content)
				if not jsonData then
					print('Ошибка: Неверный формат JSON в файле ' .. filePath)
					return nil
				end
				return jsonData
			end
			local ok, updateInfo = pcall(readJsonFile, path)
			if updateInfo then
				local isVip = thisScript().version:find('VIP')
				local uVer = isVip and updateInfo.vip_current_version or updateInfo.current_version
				local uText = isVip and updateInfo.vip_update_info or updateInfo.update_info
				local uUrl = isVip and '' or updateInfo.update_url
				
				print('Текущая установленная версия:', thisScript().version)
				print('Текущая версия в облаке:', uVer)
				if uVer and thisScript().version ~= uVer then
					print('Доступно обновление!')
					sampAddChatMessage('[Arizona Helper] {ffffff}Доступно обновление!', message_color)
					MODULE.Update.is_need_update = true
					MODULE.Update.url = uUrl
					MODULE.Update.version = uVer
					MODULE.Update.info = uText
					MODULE.Update.Window[0] = true
				else
					print('Обновление не нужно!')
					sampAddChatMessage('[Arizona Helper] {ffffff}Обновление не нужно, у вас актуальная версия!', message_color)
				end
			end
		elseif download_file == 'helper' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка новой версии хелпера успешно завершена! Перезагрузка..',  message_color)
			-- удаление файла хелпера от дискорда с _ в названии, имя файла только с пробелом
			os.remove(getWorkingDirectory():gsub('\\','/') .. "Arizona_Helper.lua")
			reload_script = true
			thisScript():unload()
		elseif download_file == 'smart_uk' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка системы умной выдачи розыска для сервера ' .. message_color_hex .. getServerName(getServerNumber()) .. ' [' .. getServerNumber() ..  '] {ffffff}завершена успешно!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Теперь вы можете использовать команду ' .. message_color_hex .. '/sum [ID игрока]', message_color)
			MODULE.Main.Window[0] = false
			load_module('smart_uk')
		elseif download_file == 'smart_pdd' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка системы умной выдачи штрафов для сервера ' .. message_color_hex .. getServerName(getServerNumber()) .. ' [' .. getServerNumber() ..  '] {ffffff}завершена успешно!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Теперь вы можете использовать команду ' .. message_color_hex .. '/tsm [ID игрока]', message_color)
			MODULE.Main.Window[0] = false
			load_module('smart_pdd')
		elseif download_file == 'smart_rptp' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка системы умного срока для сервера ' .. message_color_hex .. getServerName(getServerNumber()) .. ' [' .. getServerNumber() ..  '] {ffffff}завершена успешно!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Теперь вы можете использовать команду ' .. message_color_hex .. '/pum [ID игрока]', message_color)
			MODULE.Main.Window[0] = false
			load_module('smart_rptp')
		elseif download_file == 'arz_veh' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка всех кастомных т/с аризоны успешно заверешена!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Повторно используйте команду которой нужно определение модели т/c.',  message_color)
			load_module('arz_veh')
		elseif download_file == 'notify' then
			if doesFileExist(configDirectory .. "/Resourse/notify.mp3") then
				print('Звук оповещений успешно загружен!')
			end
		end
		download_file = ''
	end
	if isMonetLoader() then
		local function downloadToFile(url, path)
			local http = require("socket.http")
			local ltn12 = require("ltn12")

			local f, ferr = io.open(path, "wb")
			if not f then
				return false, "Не удалось создать файл: " .. tostring(ferr)
			end

			local ok, code, headers, status = http.request{
				method = "GET",
				url = url,
				sink = ltn12.sink.file(f)
			}

			if not ok then
				return false, "Ошибка запроса: " .. tostring(code)
			end

			if tonumber(code) ~= 200 then
				return false, "HTTP код: " .. tostring(code)
			end

			return true
		end
		local ok, err = downloadToFile(url, path)
		if ok then
			on_finish_download()
		else
			sampAddChatMessage("[Arizona Helper] {ffffff}Ошибка загрузки файла: " .. tostring(err), message_color)
		end
	else
		downloadUrlToFile(url, path, function(id, status)
			if status == 6 then
				on_finish_download()
			end
		end)
	end
end
function check_update()
	print('Проверка на наличие обновлений...')
	sampAddChatMessage('[Arizona Helper] {ffffff}Проверка на наличие обновлений...', message_color)
	download_file = 'update'
	-- https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Update.json
	downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/Update.json', configDirectory .. "/Update.json")
end
function check_resourses()
	if not doesDirectoryExist(configDirectory .. '/Resourse') then
		createDirectory(configDirectory .. '/Resourse')
	end
	if not doesFileExist(configDirectory .. '/Resourse/logo.png') then
		print('Подгружаю логотип хелпера...')
		downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/Resourse/logo.png', configDirectory .. '/Resourse/logo.png')
		-- https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Resourse/logo.png
	end
	if not doesFileExist(configDirectory .. "/Resourse/notify.mp3") then
		print('Подгружаю звук для оповещений хелпера...')
		downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/Resourse/notify.mp3', configDirectory .. "/Resourse/notify.mp3")
	end
	if not doesFileExist(modules.arz_veh.path) then
		print('Подгружаю список всех кастомных т/с аризоны для определенения моделей...')
		download_file = 'arz_veh'
		if tonumber(getServerNumber()) >= 300 then
			downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/SmartVEH/VehiclesRodina.json', modules.arz_veh.path)
		else
			downloadFileFromUrlToPath('https://mtgmods.github.io/arizona-helper/SmartVEH/Vehicles.json', modules.arz_veh.path)
		end
	end
end
function import_data_from_old_helpers()
	local path = getWorkingDirectory():gsub('\\','/')
	if doesFileExist(path .. "/SMI Helper/Ads.json") then
		os.rename(path .. "/SMI Helper/Ads.json", modules.ads_history.path)
	end
	-- justice, hospital, smi, as, fd, gov, government, mafia, prison
end
function deleteOldHelpers()
	local path = getWorkingDirectory():gsub('\\','/')
	local helpers = {"Justice", "Hospital", "SMI", "AS", "FD", "GOV", "Government", "Mafia", "Prison"}
	for index, name in ipairs(helpers) do
		if doesFileExist(path .. "/" .. name .. " Helper.lua") then
			os.remove(path .. "/" .. name .. " Helper.lua")
		elseif doesFileExist(path .. "/" .. name .. "_Helper.lua") then
			os.remove(path .. "/" .. name .. "_Helper.lua")
		end
	end
end
function deleteHelperData(checker)
	os.remove(configDirectory .. "/Settings.json")
	os.remove(configDirectory .. "/Commands.json")
	os.remove(configDirectory .. "/Notes.json")
	os.remove(configDirectory .. "/Vehicles.json")
	os.remove(configDirectory .. "/Guns.json")
	os.remove(configDirectory .. "/Ads.json")
	os.remove(configDirectory .. "/Update.json")
	os.remove(configDirectory .. "/SmartUK.json")
	os.remove(configDirectory .. "/SmartPDD.json")
	os.remove(configDirectory .. "/SmartRPTP.json")
	if checker then
		os.remove(configDirectory .. "/Resourse/notify.mp3")
		os.remove(configDirectory .. "/Resourse/logo.png")
		os.remove(thisScript().path)
		sampAddChatMessage('[Arizona Helper] {ffffff}Хелпер полностью удалён из вашего устройства!', message_color)
		reload_script = true
		thisScript():unload()
	else
		sampAddChatMessage('[Arizona Helper] {ffffff}Перезагрузка хелпера...', message_color)
		reload_script = true
		thisScript():reload()
	end
end
if isMode('police') or isMode('fbi') then
	function form_su(name, playerID, message)
		local lvl, id, reason = message:match('Прошу обьявить в розыск (%d) степени дело N(%d+)%. Причина%: (.+)')
		MODULE.SumMenu.form_su = id .. ' ' .. lvl .. ' ' .. reason
		sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. '/givefsu ' .. playerID .. '{ffffff} чтобы выдать розыск по запросу офицера ' .. message_color_hex .. name, message_color)
		playNotifySound()
	end
end
if isMode('hospital') then
	function heal_handler(nick, id, message)
		if (nick and id and message and tonumber(id) ~= select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
			local function check_end_time()
				lua_thread.create(function()
					wait(5000)
					if MODULE.HealChat.bool then
						MODULE.HealChat.Window[0] = false
						MODULE.HealChat.bool = false
						sampAddChatMessage('[Arizona Helper] {ffffff}Вы не успели вылечить игрока ' .. sampGetPlayerNickname(id), message_color)
					end
				end)
			end
			for hello_bro, keyword in ipairs(MODULE.HealChat.worlds) do
				if (message:rupper():find(keyword:rupper())) then
					if isMonetLoader() then
						sampAddChatMessage('[Arizona Helper] {ffffff}Чтоб вылечить игрока ' .. sampGetPlayerNickname(id) .. ', в течении 5-ти секунд нажмите кнопку',message_color)
						MODULE.HealChat.player_id = id
						MODULE.HealChat.bool = true
						MODULE.HealChat.Window[0] = true
						check_end_time()
					elseif hotkey_no_errors then
						sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы вылечить игрока ' .. sampGetPlayerNickname(id) .. ' нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_action) .. ' {ffffff}в течении 5-ти секунд!',message_color)
						show_arz_notify('info', 'Arizona Helper', 'Нажмите ' .. getNameKeysFrom(settings.general.bind_action) .. ' чтобы быстро вылечить игрока', 5000)
						MODULE.HealChat.player_id = id
						MODULE.HealChat.bool = true
						check_end_time()
					end
					return
				end
			end
		end
	end
end
if isMode('smi') then
	function send_ad()
		local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))
		if text ~= '' then
			local exists = false
			for _, ad in ipairs(modules.ads_history.data) do
				if ad and ad.text and ad.text == MODULE.SmiEdit.ad_message then
					exists = true
					break
				end
			end
			if not exists then
				table.insert(modules.ads_history.data, 1, {text = MODULE.SmiEdit.ad_message, my_text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))})
				save_module('ads_history')
			end

			if text == MODULE.SmiEdit.last_ad_text then
				MODULE.SmiEdit.ad_repeat_count = MODULE.SmiEdit.ad_repeat_count + 1
			else
				MODULE.SmiEdit.ad_repeat_count = 0
				MODULE.SmiEdit.last_ad_text = text
			end
			if MODULE.SmiEdit.ad_repeat_count >= 51 then
				sampAddChatMessage('[Arizona Helper] {ffffff}Не удалось отправить обьяву, у вас слишком много спец.символов (цифры/точки/кавычки)!', message_color)
				MODULE.SmiEdit.last_ad_text = ''
				MODULE.SmiEdit.ad_repeat_count = 0
				for index, ad in ipairs(modules.ads_history.data) do
					if ad and ad.text and ad.text == MODULE.SmiEdit.ad_message then
						sampAddChatMessage('[Arizona Helper] {ffffff}Строка редактирования обьявления очищена, но ваше обьявление сохранено в истории обьявлений.', message_color)
						ad.text = ad.my_text
						save_module('ads_history')
						break
					end
				end
				return
			else
				sampSendDialogResponse(MODULE.SmiEdit.ad_dialog_id, 1, 0, text)
			end
			imgui.StrCopy(MODULE.SmiEdit.input_edit_text, '')
			MODULE.SmiEdit.Window[0] = false
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Нельзя отправить пустую обьяву!', message_color)
		end
	end
end
if (settings.player_info.fraction_rank_number >= 9) then
	function give_rank()
		local command_find = false
		for _, command in ipairs(modules.commands.data.commands_manage.my) do
			if command.enable and command.text:find('/giverank {arg_id}') then
				command_find = true
				local modifiedText = command.text
				local wait_tag = false
				local arg_id = player_id
				modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
				modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
				modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
				modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
				lua_thread.create(function()
					MODULE.Binder.state.isActive = true
					info_stop_command()
					local lines = {}
					for line in string.gmatch(modifiedText, "[^&]+") do
						table.insert(lines, line)
					end
					for _, line in ipairs(lines) do 
						if MODULE.Binder.state.isStop then 
							MODULE.Binder.state.isStop = false 
							MODULE.Binder.state.isActive = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								MODULE.CommandStop.Window[0] = false
							end
							sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
							return 
						end
						if wait_tag then
							for tag, replacement in pairs(MODULE.Binder.tags) do
								if line:find("{" .. tag .. "}") then
									local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
									if success then
										line = result
									end
								end
							end
							sampSendChat(line)
							wait(1500)	
						end
						if not wait_tag then
							if line == '{show_rank_menu}' then
								wait_tag = true
							end
						end
					end
					MODULE.Binder.state.isActive = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						MODULE.CommandStop.Window[0] = false
					end
				end)
			end
		end
		if not command_find then
			sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для изменения ранга отсутствует либо отключён!', message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
			sampSendChat('/giverank ' .. player_id .. " " .. MODULE.GiveRank.number[0])
		end
	end
end
function emulationCEF(str)
	-- by wojciech?
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt8(bs, 220)
	raknetBitStreamWriteInt8(bs, 18)
	raknetBitStreamWriteInt16(bs, #str)
	raknetBitStreamWriteString(bs, str)
	raknetBitStreamWriteInt32(bs, 0)
	raknetSendBitStream(bs)
	raknetDeleteBitStream(bs)
end
function visualCEF(str, is_encoded)
	-- by wojciech?
	local bs = raknetNewBitStream()
	raknetBitStreamWriteInt8(bs, 17)
	raknetBitStreamWriteInt32(bs, 0)
	raknetBitStreamWriteInt16(bs, #str)
	raknetBitStreamWriteInt8(bs, is_encoded and 1 or 0)
	if is_encoded then
		raknetBitStreamEncodeString(bs, str)
	else
		raknetBitStreamWriteString(bs, str)
	end
	raknetEmulPacketReceiveBitStream(220, bs)
	raknetDeleteBitStream(bs)
end
function show_arz_notify(type, title, text, time)
	if isMonetLoader() then
		--[[
		if type == 'info' then
			type = 3
		elseif type == 'error' then
			type = 2
		elseif type == 'success' then
			type = 1
		end
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, 62)
		raknetBitStreamWriteInt8(bs, 6)
		raknetBitStreamWriteBool(bs, true)
		raknetEmulPacketReceiveBitStream(220, bs)
		raknetDeleteBitStream(bs)
		local json = encodeJson({
			styleInt = type,
			title = title,
			text = text,
			duration = time
		})
		local interfaceid = 6
		local subid = 0
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, 84)
		raknetBitStreamWriteInt8(bs, interfaceid)
		raknetBitStreamWriteInt8(bs, subid)
		raknetBitStreamWriteInt32(bs, #json)
		raknetBitStreamWriteString(bs, json)
		raknetEmulPacketReceiveBitStream(220, bs)
		raknetDeleteBitStream(bs)
		]]
	else
		local function escape_js(s)
			return s:gsub("\\", "\\\\"):gsub('"', '\\"')
		end
		local safe_type = escape_js(type)
		local safe_title = escape_js(title)
		local safe_text = escape_js(text)
		local safe_time = tostring(time)
		local str = ('window.executeEvent("event.notify.initialize", "[\\"%s\\", \\"%s\\", \\"%s\\", \\"%s\\"]");'):format(safe_type, safe_title, safe_text, safe_time)
		visualCEF(str, true)
	end
end
--------------------------------------------- Events ---------------------------------------------
function sampev.onShowTextDraw(id, data)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[ShowTextDraw] {ffffff}ID ' .. id .. " | Text " .. data.text .. ' | ModelID ' .. data.modelId .. " |", message_color)
		print("[ShowTextDraw] ID " .. id .. " | Text " .. data.text .. ' | ModelID ' .. data.modelId .. " |")
	end
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Arizona Helper] {ffffff}Активирован режим езды Sport!', message_color)
		return false
	end
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Arizona Helper] {ffffff}Активирован режим езды Comfort!', message_color)
		return false
	end
end
function sampev.onSendClickTextDraw(textdrawId)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[ClickTextDraw] {ffffff}ID ' .. textdrawId, message_color)
		print('[ClickTextDraw] ID ' .. textdrawId)
	end
end
function sampev.onDisplayGameText(style,time,text)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[GameText] {ffffff}Style ' .. style .. " | Time " .. time .. " | Text " .. text, message_color)
		print('[GameText] Style ' .. style .. " | Time " .. time .. " | Text " .. text)
	end
	if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Arizona Helper] {ffffff}Активирован режим езды Sport!', message_color)
		return false
	end
	if text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Arizona Helper] {ffffff}Активирован режим езды Comfort!', message_color)
		return false
	end
end
function sampev.onSendTakeDamage(playerId,damage,weapon)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[TakeDamage] {ffffff}ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon, message_color)
		print('[TakeDamage] ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon)
	end
	if playerId ~= 65535 then
		playerId2 = playerId1
		playerId1 = playerId
		if isParamSampID(playerId) and playerId1 ~= playerId2 and tonumber(playerId) ~= 0 and weapon then
			local weapon_name = get_name_weapon(weapon)
			if weapon_name then
				sampAddChatMessage('[Arizona Helper] {ffffff}Игрок ' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. '] напал на вас используя ' .. weapon_name .. '['.. weapon .. ']!', message_color)
				if isMode('police') or isMode('fbi') or isMode('army') or isMode('prison') then
					if ((MODULE.Patrool.Window[0]) and (MODULE.Patrool.ComboCode[0] ~= 1)) then
						sampAddChatMessage('[Arizona Helper | Ассистент] {ffffff}Ваш ситуационный код изменён на CODE 0.', message_color)
						MODULE.Patrool.ComboCode[0] = 1
						MODULE.Patrool.code = MODULE.Patrool.combo_code_list[MODULE.Patrool.ComboCode[0] + 1]
					end
					if ((MODULE.Post.Window[0]) and (MODULE.Post.ComboCode[0] ~= 1)) then
						sampAddChatMessage('[Arizona Helper | Ассистент] {ffffff}Ваш ситуационный код изменён на CODE 0.', message_color)
						MODULE.Post.ComboCode[0] = 1
						MODULE.Post.code = MODULE.Post.combo_code_list[MODULE.Post.ComboCode[0] + 1]
					end
					if (settings.mj.auto_doklad_damage or settings.md.auto_doklad_damage) then
						lua_thread.create(function()
							sampSendChat('/r ' .. MODULE.Binder.tags.my_doklad_nick() .. ' на CONTROL. ' .. (weapon ~= 0 and 'Нахожусь под огнём' or 'На меня напали') .. ' в районе ' .. MODULE.Binder.tags.get_area() .. ' (' .. MODULE.Binder.tags.get_square() .. '), состояние CODE 0!')
							wait(1500)
							sampSendChat('/rb Нападающий: ' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. '], он(-а) использует ' .. weapon_name .. '!')
						end)
					end
				end
			end
		end
	end
end
function sampev.onSendGiveDamage(playerId, damage, weapon, bodypart)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[GiveDamage] {ffffff}ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon .. " | Body " .. bodypart, message_color)
		print('[GiveDamage] ID ' .. playerId .. " | Damage " .. damage .. " | Weapon " .. weapon .. " | Body " .. bodypart)
	end
	if playerId ~= 65535 then
		if (sampGetPlayerNickname(playerId) == 'Bogdan_Martelli' and getServerNumber() == '20') or sampGetPlayerNickname(playerId):find('%[20%]Bogdan_Martelli') then
			sampAddChatMessage('[Arizona Helper] {ffffff}Bogdan_Martelli - это разработчик Arizona Helper!', message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Не нужно наносить урон разработчику хелпера, АСТАНАВИТЕСЬ :sob: :sob: :sob:', message_color)
			playNotifySound()
		end
	end
end
function sampev.onServerMessage(color, text)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[ServerMessage] {ffffff}Color ' .. color .. " | Text " .. text, message_color)
		print('[ServerMessage] Color ' .. color .. " | Text " .. text)
	end

	if (text:find("^1%.{......} 111 %- {......}Проверить баланс телефона")) or
		text:find("^2%.{......} 060 %- {......}Служба точного времени") or
		text:find("^3%.{......} 911 %- {......}Полицейский участок") or
		text:find("^4%.{......} 912 %- {......}Скорая помощь") or
		text:find("^5%.{......} 914 %- {......}Такси") or
		text:find("^5%.{......} 914 %- {......}Механик") or
		text:find("^6%.{......} 8828 %- {......}Справочная центрального банка") or
		text:find("^7%.{......} 997 %- {......}Служба по вопросам жилой недвижимости %(узнать владельца дома%)") then
		return false
	end
	if (text:find("^%[Подсказка%] {......}Номера телефонов государственных служб:")) then
		sampAddChatMessage('[Arizona Helper] {ffffff}Номера телефонов государственных служб:', message_color)
		sampAddChatMessage('[Arizona Helper] {ffffff}111 Баланс | 60 Время | 911 МЮ | 912 МЗ | 913 Такси | 914 Мехи | 8828 Банк | 997 Дома', message_color)
		return false
	end

	if ((settings.general.ping) and (not isMonetLoader()) and (text:find('@' .. MODULE.Binder.tags.my_nick()) or text:find('@' .. MODULE.Binder.tags.my_id() .. ' '))) then
		sampAddChatMessage('[Arizona Helper] {ffffff}Кто-то упомянул вас в чате!', message_color)
		playNotifySound()
	end

	if ((settings.general.auto_uninvite) and (settings.player_info.fraction_rank_number >= 9)) then
		local function auto_uninvite_handler(name, playerID, message)
			if not message:find(" отправьте (.+) +++ чтобы уволится ПСЖ!") and not message:find("Сотрудник (.+) был уволен по причине(.+)") and message:rupper():find("ПСЖ") or message:rupper():find("УВОЛЬТЕ") or message:rupper():find("УВАЛ") then
				MODULE.LeadTools.msg3 = MODULE.LeadTools.msg2
				MODULE.LeadTools.msg2 = MODULE.LeadTools.msg1
				MODULE.LeadTools.msg1 = text
				PlayerID = playerID
				if MODULE.LeadTools.msg3 == text then
					MODULE.LeadTools.checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval]')
				elseif tag == "R" then
					sampSendChat("/rb "..name.."["..playerID.."], отправьте /rb +++ чтобы уволится ПСЖ!")
				elseif tag == "F" then
					sampSendChat("/fb "..name.."["..playerID.."], отправьте /fb +++ чтобы уволится ПСЖ!")
				end
			elseif ((message == "(( +++ ))" or  message == "(( +++. ))") and (PlayerID == playerID)) then
				MODULE.LeadTools.checker = true
				sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval]')
			end
		end
		if text:find("^%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb /r /rb без тега 
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			auto_uninvite_handler(name, playerID, message)
		elseif text:find("^%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r /f с тегом
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			auto_uninvite_handler(name, playerID, message)
		elseif text:find("(.+) заглушил%(а%) игрока (.+) на 1 минут. Причина: %[AutoUval%]") and MODULE.LeadTools.checker then
			local text2 = text:gsub('{......}', '')
			local DATA = text2:match("(.+) заглушил")
			local Name = DATA:match(" ([A-Za-z0-9_]+)%[")
			local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			if Name == MyName then
				sampAddChatMessage('[Arizona Helper] {ffffff}Увольняю игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
				MODULE.LeadTools.checker = false
				temp = PlayerID .. ' ПСЖ'
				find_and_use_command("/uninvite {arg_id} {arg2}", temp)
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Другой заместитель/лидер уже увольняет игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
				MODULE.LeadTools.checker = false
			end
		end
	end

	if (isMode('police') or isMode('fbi')) then
		if (settings.player_info.fraction_rank_number >= (isMode('fbi') and 4 or 5)) then
			if ((text:find("^%[(.-)%] (.-) (.-)%[(.-)%]: Прошу обьявить в розыск (%d) степени дело N(%d+)%. Причина%: (.+)")) and (color == 766526463)) then -- /f /fb /r /rb без тега 
				local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
				form_su(name, playerID, message)
			elseif ((text:find("^%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: Прошу обьявить в розыск (%d) степени дело N(%d+)%. Причина%: (.+)")) and (color == 766526463)) then -- /r /f с тегом
				local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
				form_su(name, playerID, message)
			end
		end
		if (text:find('^Местоположение (.+) отмечено на карте красным маркером')) then
			printStringNow(MODULE.Wanted.afind and 'AUTO FIND' or 'FIND', 500)
			return false
		end
		if ((MODULE.Wanted.check_wanted) and (text:find('^%[Ошибка%] %{FFFFFF%}Используй: %/wanted %[уровень розыска 1%-6%]') or text:find('^%[Ошибка%] %{FFFFFF%}Используйте: %/wanted %[уровень розыска 1%-6%]'))) then
			return false
		end
		if ((MODULE.Wanted.check_wanted) and (text:find('^%[Ошибка%].+Игроков с таким уровнем розыска нету'))) then 
			return false 
		end
		if ((MODULE.Patrool.active) and (text:find('^На этом автомобиле уже установлена маркировка.'))) then
			sampAddChatMessage('[Arizona Helper] {ffffff}Меняю макрировку в транспорте...', message_color)
			sampSendChat('/delvdesc')
			lua_thread.create(function()
				wait(5000)
				sampSendChat('/vdesc ' .. MODULE.Binder.tags.get_patrool_mark())
			end)		
		end
		if (text:find('^%[Информация%] {ffffff}Вы подобрали обломок, теперь вам нужно отнести его и {ff0000}положить в общую кучу')) then
			sampAddChatMessage('[Arizona Helper] {ffffff}Вы подобрали завал, теперь вам нужно отнести его в общую кучу!', message_color)
			return false
		end
		if (text:find('^%[Информация%] {ffffff}Вы положили обломок в общую кучу, отправляйтесь к следующему завалу.')) then
			sampAddChatMessage('[Arizona Helper] {ffffff}Вы положили завал в общую кучу, теперь отправляйтесь к следующему завалу.', message_color)
			return false
		end
	end
 	
	if isMode('hospital') then
		if (text:find('^Очевидец сообщает о пострадавшем человеке в районе (.+) %((.+)%).')) then
			MODULE.GoDeath.locate, MODULE.GoDeath.city = text:match('Очевидец сообщает о пострадавшем человеке в районе (.+) %((.+)%).')
			return false
		elseif (text:find('^Очевидец сообщает о пострадавшем человеке%, геолокация%: (.+)')) then -- rodina
			MODULE.GoDeath.locate, MODULE.GoDeath.city = "неизвестном", text:match('геолокация%: (.+)')
			return false
		end
		if (text:find('^%(%( Чтобы принять вызов, введите /godeath (%d+). Оплата за вызов (.+) %)%)')) then
			local price_godeath = ''
			MODULE.GoDeath.player_id, price_godeath = text:match('%(%( Чтобы принять вызов, введите /godeath (%d+). Оплата за вызов (.+) %)%)')
			MODULE.GoDeath.player_id = tonumber(MODULE.GoDeath.player_id)
			local cmd = '/godeath'
			for _, command in ipairs(modules.commands.data.commands.my) do
				if command.enable and command.text:find('/godeath {arg_id}') then
					cmd =  '/' .. command.cmd
				end
			end
			if MODULE.GoDeath.locate == 'неизвестном' then
				sampAddChatMessage('[Arizona Helper] {ffffff}Из города ' .. message_color_hex .. MODULE.GoDeath.city .. ' {ffffff}поступил вызов о пострадавшем ' .. message_color_hex .. sampGetPlayerNickname(MODULE.GoDeath.player_id), message_color)
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Из города ' .. message_color_hex .. MODULE.GoDeath.city .. ' (' .. MODULE.GoDeath.locate .. ') {ffffff}поступил вызов о пострадавшем ' .. message_color_hex .. sampGetPlayerNickname(MODULE.GoDeath.player_id), message_color)
			end
			sampAddChatMessage('[Arizona Helper] {ffffff}Вылечив его вы получите ' .. price_godeath .. '! Чтобы принять вызов, используйте команду ' .. message_color_hex .. cmd .. ' ' .. MODULE.GoDeath.player_id, message_color)
			return false
		end
		if (text:find("^Пациент (.+) вызывает врачей .+холл.+этаж")) then
			sampAddChatMessage('[Arizona Helper] {ffffff}Пациент ' .. text:match("Пациент (.+) вызывает") .. ' вызывает врача в холл больницы!', message_color)
			return false
		end
		if (text:find('$hme')) then
			find_and_use_command("/heal {my_id}", "")
			return false
		end
		if ((MODULE.HealChat.healme) and (text:find('^%[Предложение%]') or text:find('^%[Новое предложение%]'))) then
			return false
		end
		if (MODULE.HealChat.healme and text:find('^%[Информация%] {FFFFFF}Вы отправили предложение о лечении.')) then
			sampSendChat('/offer')
			return false
		end
		if ((MODULE.HealChat.healme) and (text:find('^%[Информация%] {FFFFFF}Вас вылечил медик ' .. MODULE.Binder.tags.my_nick()))) then
			MODULE.HealChat.healme = false
			return false
		end
		if ((settings.mh.heal_in_chat.enable) and not MODULE.HealChat.bool and not MODULE.Binder.state.isActive) then	
			if (text:find('^(.+)%[(%d+)%] говорит:{B7AFAF} (.+)')) then
				local nick, id, message = text:match('^(.+)%[(%d+)%] говорит:{B7AFAF} (.+)')
				heal_handler(nick, id, message)
			elseif (text:find('^(.+)%[(%d+)%] кричит: (.+)')) then
				local nick, id, message = text:match('^(.+)%[(%d+)%] кричит: (.+)')
				heal_handler(nick, id, message)
			end
		end
	end	

	if isMode('lc') then
		if text:find('^Вы отремонтировали дорожный знак: (.+) Ваша зарплата%: (.+)') then
			local money = text:match('Ваша зарплата%: (.+)')
			sampAddChatMessage('[Arizona Helper] {ffffff}За ремонт дорожного знака вы заработали ' .. money, message_color)
			return false
		end
		if text:find('^Вы установили дорожный знак: (.+) Ваша зарплата%: (.+)') then
			local money = text:match('Ваша зарплата%: (.+)')
			sampAddChatMessage('[Arizona Helper] {ffffff}За установку дорожного знака вы заработали ' .. money, message_color)
			return false
		end
		if text:find('^Вы взяли инструменты для ремонта дорожного знака.') then
			sampAddChatMessage('[Arizona Helper] {ffffff}Вы взяли инструменты для ремонта дорожного знака.', message_color)
			return false
		end
		if text:find('^%[Ошибка%](.+)У игрока уже есть такая лицензия сроком более чем (.+)') then
			local days = text:match('сроком более чем (.+)')
			sampAddChatMessage('[Arizona Helper] {ffffff}У игрока уже есть такая лицензия сроком более чем ' .. days, message_color)
			sampSendChat('У вас уже есть такая лицензия сроком более чем ' .. days)
			return false
		end
		if (text:find('^%[Ошибка%](.+)Вы не можете продавать лицензии на такой срок')) then
			sampAddChatMessage('[Arizona Helper] {ffffff}Ваш ранг ниже, чем требуется для выдачи данной лицензии!', message_color)
			sampSendChat('Извините, я не могу выдать данную лицензию из-за низкой должности.')
			return false
		end
	end	

	if isMode('smi') then
		if text:find('^На обработку объявлений пришло VIP сообщение от: (.+){FFA500}%(Автоматически%)') then
			local nick = text:match('На обработку объявлений пришло VIP сообщение от: (.+){FFA500}%(Автоматически%)')
			if nick == nil then
				nick = ''
			end
			if sampGetPlayerIdByNickname(nick) == -1 then
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое VIP авто-обьявление от игрока ' .. message_color_hex .. nick, message_color)
			else
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое VIP авто-обьявление от игрока ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
			end
			return false
		elseif text:find('^На обработку объявлений пришло сообщение от: (.+){FFA500}%(Автоматически%)') then
			local nick = text:match('На обработку объявлений пришло сообщение от: (.+){FFA500}%(Автоматически%)')
			if nick == nil then
				nick = ''
			end
			if sampGetPlayerIdByNickname(nick) == -1 then
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое авто-обьявление от игрока ' .. message_color_hex .. nick, message_color)
			else
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое авто-обьявление от игрока ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
			end
			return false
		elseif text:find('^На обработку объявлений пришло сообщение от%: (.+)') then
			local nick = text:match('пришло сообщение от%: (.+)')
			if nick == nil then
				nick = ''
			end
			if sampGetPlayerIdByNickname(nick) == -1 then
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое обьявление от игрока ' .. message_color_hex .. nick, message_color)
			else
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое обьявление от игрока ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
			end
			return false
		elseif text:find('^На обработку объявлений пришло VIP сообщение от%: (.+)') then
			local nick = text:match('пришло VIP сообщение от%: (.+)')
			if nick == nil then
				nick = ''
			end
			if sampGetPlayerIdByNickname(nick) == -1 then
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое VIP обьявление от игрока ' .. message_color_hex .. nick, message_color)
			else
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое VIP обьявление от игрока ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
			end
			return false
		elseif text:find('^На обработку объявлений пришло сообщение о рекламе бизнеса от%: (.+)') then
			local nick = text:match('пришло сообщение о рекламе бизнеса от%: (.+)')
			if nick == nil then
				nick = ''
			end
			if sampGetPlayerIdByNickname(nick) == -1 then
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое обьявление от маркетолога ' .. message_color_hex .. nick, message_color)
			else
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое обьявление от маркетолога ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
			end
			return false
		elseif text:find('^{C17C2D}На обработку объявлений пришло сообщение от руководства страховой компании%: (.+)') then
			local nick = text:match('На обработку объявлений пришло сообщение от руководства страховой компании%: (.+)')
			if nick == nil then
				nick = ''
			end
			if sampGetPlayerIdByNickname(nick) == -1 then
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое обьявление от руководства СТК, а именно игрок ' .. message_color_hex .. nick, message_color)
			else
				sampAddChatMessage('[Arizona Helper]{ffffff} Поступило новое обьявление от руководства СТК, а именно игрок ' .. message_color_hex .. nick .. '[' .. sampGetPlayerIdByNickname(nick) .. ']', message_color)
			end
			return false
		elseif text:find('^%[Ошибка%] %{ffffff%}Это объявление уже редактирует (.+).') then
			local nick = text:match('редактирует (.+).')
			sampAddChatMessage('[Arizona Helper] {ffffff}Это обьявление уже редактирует игрок ' .. message_color_hex  .. nick, message_color)
			return false
		end
	end

	if (text:find('Bogdan_Martelli') and getServerNumber() == '20') or text:find('%[20%]Bogdan_Martelli') then
		local lastColor = text:match("(.+){%x+}$")
   		if not lastColor then
			lastColor = "{" .. rgba_to_hex(color) .. "}"
		end
		if text:find('%[VIP ADV%]') or text:find('%[FOREVER%]') then
			lastColor = "{FFFFFF}"
		end
		if text:find('%[20%]Bogdan_Martelli%[%d+%]') then
			local id = text:match('%[20%]Bogdan_Martelli%[(%d+)%]') or ''
			text = string.gsub(text, '%[20%]Bogdan_Martelli%[%d+%]', message_color_hex .. '[20]MTGMODS[' .. id .. ']' .. lastColor)
		elseif text:find('%[20%]Bogdan_Martelli') then
			text = string.gsub(text, '%[20%]Bogdan_Martelli', message_color_hex .. '[20]MTGMODS' .. lastColor)
		elseif text:find('Bogdan_Martelli%[%d+%]') then
			local id = text:match('Bogdan_Martelli%[(%d+)%]') or ''
			text = string.gsub(text, 'Bogdan_Martelli%[%d+%]', message_color_hex .. 'MTGMODS[' .. id .. ']' .. lastColor)
		elseif text:find('Bogdan_Martelli') then
			text = string.gsub(text, 'Bogdan_Martelli', message_color_hex .. 'MTGMODS' .. lastColor)
		end
		return {color,text}
	end
end
function sampev.onSendChat(text)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[SendChat] {ffffff}Text ' .. text, message_color)
		print('[SendChat] ' .. text)
	end
	local ignore = {
		[")"] = true,
		["))"] = true,
		["("] = true,
		["(("] = true,
		["q"] = true,
		["<3"] = true,
	}
	if ignore[text] then
		return {text}
	end
	if settings.player_info.rp_chat then
		text = text:sub(1, 1):rupper()..text:sub(2, #text) 
		if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
			text = text .. '.'
		end
	end
	if settings.player_info.accent_enable then
		text = settings.player_info.accent .. ' ' .. text 
	end
	return {text}
end
function sampev.onSendCommand(text)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[SendCommand] {ffffff}CMD ' .. text, message_color)
		print('[SendCommand] CMD ' .. text)
	end
	if isMode('hospital') and text == "/me достаёт из своего мед.кейса лекарство и принимает его" then
		MODULE.HealChat.healme = true
	end
	if settings.player_info.rp_chat then
		local chats =  { '/vr', '/fam', '/al', '/s', '/b', '/n', '/r', '/rb', '/f', '/fb', '/j', '/jb', '/m', '/do'} 
		for _, cmd in ipairs(chats) do
			if text:find('^'.. cmd .. ' ') then
				local cmd_text = text:match('^'.. cmd .. ' (.+)')
				if cmd_text ~= nil then
					cmd_text = cmd_text:sub(1, 1):rupper()..cmd_text:sub(2, #cmd_text)
					text = cmd .. ' ' .. cmd_text
					if not text:find('(.+)%.') and not text:find('(.+)%!') and not text:find('(.+)%?') then
						text = text .. '.'
					end
				end
			end
		end
	end
	return {text}
end
function sampev.onShowDialog(dialogid, style, title, button1, button2, text)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[ShowDialog] {ffffff}ID ' .. dialogid .. ' | Style ' .. style .. ' | Title ' .. title .. ' | Btn1 ' .. button1 .. ' | Btn2 ' .. button2 .. ' | Text ' .. text, message_color)
		print('[ShowDialog] ID ' .. dialogid .. ' | Style ' .. style .. ' | Title ' .. title .. ' | Btn1 ' .. button1 .. ' | Btn2 ' .. button2 .. ' | Text ' .. text)
	end

	if ((check_stats) and (title:find('Основная статистика') or title:find('Статистика игрока'))) then
		-- Arizona & Rodina Stats
		if text:find("Имя") then
			settings.player_info.nick = text:match("{FFFFFF}Имя: {B83434}%[(.-)]") or text:match("{ffffff}Имя %(en%.%):%s+{BE433D}([^\n\r]+)")
			settings.player_info.name_surname = text:match("{ffffff}Имя %(рус%.%):%s+{BE433D}([^\n\r]+)") or TranslateNick(settings.player_info.nick)
			sampAddChatMessage('[Arizona Helper] {ffffff}Ваше имя и фамилия обнаружены: ' .. settings.player_info.name_surname, message_color)
        end
		if text:find("Пол:") then
			settings.player_info.sex = text:match("{FFFFFF}Пол: {B83434}%[(.-)]") or text:match("{ffffff}Пол:%s+{BE433D}([^\n\r]+)")
			sampAddChatMessage('[Arizona Helper] {ffffff}Ваш пол обнаружен: ' .. settings.player_info.sex, message_color)
		end
		if text:find("Организация:") then
			settings.player_info.fraction = text:match("{FFFFFF}Организация: {B83434}%[(.-)]") or text:match("{ffffff}Организация:%s+{BE433D}([^\n\r]+)")
			if settings.player_info.fraction == 'Не имеется' then
				sampAddChatMessage('[Arizona Helper] {ffffff}Вы не состоите в организации!', message_color)
				settings.player_info.fraction_tag = "none"
				settings.general.fraction_mode = "none"
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Ваша организация обнаружена, это: '..settings.player_info.fraction, message_color)
				local fraction_data = {
					['Полиция ЛС'] = {'ЛСПД', 'police'}, ['Полиция LS'] = {'ЛСПД', 'police'},
					['Полиция ЛВ'] = {'ЛВПД', 'police'}, ['Полиция LV'] = {'ЛВПД', 'police'},
					['Полиция СФ'] = {'СФПД', 'police'}, ['Полиция SF'] = {'СФПД', 'police'},
					['Полиция ВС'] = {'ВСПД', 'police'}, ['Полиция VC'] = {'ВСПД', 'police'},
					['Областная полиция'] = {'РКШД', 'police'}, ['FBI'] = {'ФБР', 'fbi'}, ['ФБР'] = {'ФБР', 'fbi'},
					['Тюрьма строгого режима LV'] = {'ТСР', 'prison'}, ['Тюрьма строгого режима ЛВ'] = {'ТСР', 'prison'},
					['Армия СФ'] = {'СФа', 'army'}, ['Армия SF'] = {'СФа', 'army'},
					['Армия ЛС'] = {'ЛСа', 'army'}, ['Армия LS'] = {'ЛСа', 'army'},
					['TV студия'] = {'СМИ ЛС', 'smi'},
					['TV студия ЛС'] = {'СМИ ЛС', 'smi'}, ['TV студия LS'] = {'СМИ ЛС', 'smi'},
					['TV студия ЛВ'] = {'СМИ ЛВ', 'smi'}, ['TV студия LV'] = {'СМИ ЛВ', 'smi'},
					['TV студия СФ'] = {'СМИ СФ', 'smi'}, ['TV студия SF'] = {'СМИ СФ', 'smi'},
					['TV студия ВС'] = {'СМИ ВС', 'smi'}, ['TV студия VC'] = {'СМИ ВС', 'smi'},
					['Больница ЛС'] = {'ЛСМЦ', 'hospital'}, ['Больница LS'] = {'ЛСМЦ', 'hospital'},
					['Больница ЛВ'] = {'ЛВМЦ', 'hospital'}, ['Больница LV'] = {'ЛВМЦ', 'hospital'},
					['Больница СФ'] = {'СФМЦ', 'hospital'}, ['Больница SF'] = {'СФМЦ', 'hospital'},
					['Больница ВС'] = {'ВСМЦ', 'hospital'}, ['Больница VC'] = {'ВСМЦ', 'hospital'},
					['Больница Jefferson'] = {'ДМЦ', 'hospital'}, ['Больница Джефферсон'] = {'ДМЦ', 'hospital'},
					['Правительство LS'] = {'Право', 'gov'}, ['Правительство ЛС'] = {'Право', 'gov'},
					['Судья'] = {'Судья', 'judge'},
					['Центр лицензирования'] = {'ГЦЛ', 'lc'},
					['Пожарный департамент'] = {'ПД', 'fd'},
					['Страховая компания'] = {'IC', 'ins'},
					['Russian Mafia'] = {'RM', 'mafia'},
					['Yakuza'] = {'YKZ', 'mafia'},
					['La Cosa Nostra'] = {'LCN', 'mafia'},
					['Warlock MC'] = {'WMC', 'mafia'},
					['Tierra Robada Bikers'] = {'TRB', 'mafia'},
					['Grove Street'] = {'Грув', 'ghetto'},
					['Los Santos Vagos'] = {'Вагос', 'ghetto'},
					['East Side Ballas'] = {'Баллас', 'ghetto'},
					['Varrios Los Aztecas'] = {'Ацтек', 'ghetto'},
					['The Rifa'] = {'Рифа', 'ghetto'},
					['Night Wolves'] = {'НВ', 'ghetto'},
					-- Rodina
					['ФСБ'] = {'ФСБ', 'fbi'},
					['Армия'] = {'ВС', 'army'},
					['Тюрьма Строгого Режима'] = {'ФСИН', 'prison'},
					['Полиция округа'] = {'ГИБДД', 'police'},
					['Городская полиция'] = {'ГУВД', 'police'},
					['Больница округа'] = {'МУСС', 'hospital'},
					['Городская больница'] = {'СМП', 'hospital'},
					['Центр Лицензирования'] = {'МРЭО', 'lc'},
					['Правительство'] = {'Право', 'gov'},
					['Новостное агенство'] = {'НА', 'smi'},
				}
				local data = fraction_data[settings.player_info.fraction]
				if data then
					local old_fraction_mode = settings.general.fraction_mode 
					settings.player_info.fraction_tag = data[1]
					settings.general.fraction_mode = data[2]
					settings.departament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
					sampAddChatMessage('[Arizona Helper] {ffffff}Вашей организации присвоен тег '..settings.player_info.fraction_tag .. ". Но вы можете изменить его.", message_color)

					if old_fraction_mode ~= '' and old_fraction_mode ~= settings.general.fraction_mode then
						sampAddChatMessage('[Arizona Helper] {ffffff}Вы теперь в другой фракции, поэтому удаляю стандартные RP команды ' .. old_fraction_mode, message_color)
						delete_default_fraction_cmds(modules.commands.data.commands.my, get_fraction_cmds(old_fraction_mode, false))
						delete_default_fraction_cmds(modules.commands.data.commands_manage.my, get_fraction_cmds(old_fraction_mode, true))
					end

					local function add_unique(tbl, cmds)
						for _, cmd in ipairs(cmds) do
							local exists = false
							for _, v in ipairs(tbl) do
								if v.cmd == cmd.cmd then exists = true break end
							end
							if not exists then table.insert(tbl, cmd) end
						end
					end
					add_unique(modules.commands.data.commands.my, get_fraction_cmds(settings.general.fraction_mode, false))
					add_unique(modules.commands.data.commands_manage.my, get_fraction_cmds(settings.general.fraction_mode, true))

					save_module('commands')
					
					if settings.general.fraction_mode == 'police' or settings.general.fraction_mode == 'fbi' then
						add_notes()
					elseif settings.general.fraction_mode == 'prison' then
						add_notes('prison')
					end
				else
					settings.general.fraction_mode = 'none'
					settings.player_info.fraction_rank = "none"
					settings.player_info.fraction_rank_number = 0
					sampAddChatMessage('[Arizona Helper] {ffffff}Ваша организация пока что не поддерживается в хелпере!', message_color)
					sampAddChatMessage('[Arizona Helper] {ffffff}Пройдите ручную настройку хелпера для инициализации...', message_color)
				end
				if text:find("Должность:") then
					local rank, rank_number = text:match("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)(.+)Уровень розыска")
					if not rank or not rank_number then
						rank, rank_number = text:match("{ffffff}Должность:%s+{BE433D}([^(]+)%((%d+)%)")
					end
					settings.player_info.fraction_rank = rank
					settings.player_info.fraction_rank_number = tonumber(rank_number)
					sampAddChatMessage('[Arizona Helper] {ffffff}Ваша должность обнаружена, это: ' .. settings.player_info.fraction_rank .. " (" .. settings.player_info.fraction_rank_number .. ")", message_color)
					if settings.player_info.fraction_rank_number >= 9 then
						settings.general.auto_uninvite = true
					end
				else
					settings.player_info.fraction_rank = "none"
					settings.player_info.fraction_rank_number = 0
					sampAddChatMessage('[Arizona Helper] {ffffff}Не могу получить ваш ранг!',message_color)
				end
			end
		end
		save_settings()
		sampSendDialogResponse(dialogid, 0, 0, 0)
		reload_script = true
		thisScript():reload()
		return false
	end

	if ((MODULE.Members.info.check) and (title:find('(.+)%(В сети: (%d+)%)') or title:find('В сети всего .+ членов'))) then
        local count = 0
        local next_page = false
        local next_page_i = 0
		MODULE.Members.info.fraction = string.match(title, '(.+)%(В сети')
		if MODULE.Members.info.fraction then
			MODULE.Members.info.fraction = string.gsub(MODULE.Members.info.fraction, '{(.+)}', '')
		else
			MODULE.Members.info.fraction = settings.player_info.fraction -- rodina
		end
        for line in text:gmatch('[^\r\n]+') do
            count = count + 1
            if not line:find('страница') and (not line:find('Ник') or not line:find('Имя')) then

				local optional_info = ''
				if line:find('{FFA500}%(Вы%)') then
					line = line:gsub("{FFA500}%(Вы%)", "")
					optional_info = '(Вы)'
				end
				if line:find(' %/ В деморгане') then
					line = line:gsub(" %/ В деморгане", "")
					optional_info = optional_info .. ' (JAIL)'
				end
				if line:find(' %/ MUTED') then
					line = line:gsub(" %/ MUTED", "")
					optional_info = optional_info .. ' (MUTE)'
				end
				if optional_info == '' then
					optional_info = '-'
				end

				

				if line:find('{FFA500}%(%d+.+%)') then
					local color, nickname, id, rank, rank_number, color2, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}([%w_]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*{(%x%x%x%x%x%x)}%(([^%)]+)%)%s*{FFFFFF}(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ шт")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end
						if rank_time then
							rank_number = rank_number .. ') (' .. rank_time
						end
						table.insert(MODULE.Members.new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working, info = optional_info})
					end
				else
					local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}%s*([^%(]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*([^{}]+){FFFFFF}%s*(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ шт")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end
						table.insert(MODULE.Members.new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working, info = optional_info})
					end
				end

				-- rodina
				if not rank or not nickname then
					local nickname, id, rank, rank_number, warns = line:match("(.+)%((%d+)%)%s+(.+)%((%d+)%).+(%d) / 3")
					if nickname and id and rank and rank_number and warns then
						table.insert(MODULE.Members.new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = 0, working = true, info = optional_info})
					end
				end
            end
            if line:match('Следующая страница') then
                next_page = true
                next_page_i = count - 2
            end
        end
        if next_page then
            sampSendDialogResponse(dialogid, 1, next_page_i, 0)
            next_page = false
            next_pagei = 0
		elseif #MODULE.Members.new ~= 0 then
            sampSendDialogResponse(dialogid, 0, 0, 0)
			MODULE.Members.all = MODULE.Members.new
			MODULE.Members.info.check = false
			MODULE.Members.Window[0] = true
		else
			sampSendDialogResponse(dialogid, 0, 0, 0)
			sampAddChatMessage('[Arizona Helper]{ffffff} Список сотрудников пуст!', message_color)
			MODULE.Members.info.check = false
        end
        return false
    end

	if settings.player_info.fraction_rank_number >= 9 then
		if title:find('Выберите ранг для (.+)') and text:find('вакансий') then -- invite
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
		if MODULE.LeadTools.spawncar and title:find('$') and text:find('Спавн транспорта') then -- спавн транспорта 
			local count = 0
			for line in text:gmatch('[^\r\n]+') do
				if line:find('Спавн транспорта') then
					sampSendDialogResponse(dialogid, 1, count, 0)
					MODULE.LeadTools.spawncar = false
					return false
				else
					count = count + 1
				end
			end
		end
		if MODULE.LeadTools.vc_vize.bool then -- виза для ВС
			if text:find('Управление разрешениями на командировку в Vice City') then
				local count = 0
				for line in text:gmatch('[^\r\n]+') do
					if line:find('Управление разрешениями на командировку в Vice City') then
						sampSendDialogResponse(dialogid, 1, count, 0)
						return false 
					else
						count = count + 1
					end
				end
			end
			if title:find('Выдача разрешений на поездки Vice City') then
				MODULE.LeadTools.vc_vize.bool = false
				sampSendChat("/r Сотруднику "..TranslateNick(sampGetPlayerNickname(tonumber(MODULE.LeadTools.vc_vize.player_id))).." выдана виза Vice City!")
				sampSendDialogResponse(dialogid, 1, 0, tostring(MODULE.LeadTools.vc_vize.player_id))
				return false 
			end	
			if title:find('Забрать разрешение на поездки Vice City') then
				MODULE.LeadTools.vc_vize.bool = false
				sampSendChat("/r У сотрудника "..TranslateNick(sampGetPlayerNickname(tonumber(MODULE.LeadTools.vc_vize.player_id))).." была изьята виза Vice City!")
				sampSendDialogResponse(dialogid, 1, 0, tostring(sampGetPlayerNickname(MODULE.LeadTools.vc_vize.player_id)))
				return false 
			end
		end
		if (MODULE.LeadTools.platoon.check) then
			if text:find('Назначить взвод игроку') and text:find('Участники взвода') then
				sampSendDialogResponse(dialogid, 1, 3, 0)
				return false 
			end
			if text:find('{FFFFFF}Введите {FB8654}ID{FFFFFF} игрока, которого хотите назначить') then
				sampSendDialogResponse(dialogid, 1, 0, MODULE.LeadTools.platoon.player_id)
				MODULE.LeadTools.platoon.check = false
				return false 
			end
		end
	end

	if title:find('Сущности рядом') then -- arz fastmenu
		sampSendDialogResponse(dialogid, 0, 2, 0)
		return false 
	end

	if settings.gov.anti_trivoga and text:find('Вы действительно хотите вызвать сотрудников полиции?')  then -- анти тревожная кнопка
		sampSendDialogResponse(dialogid, 0, 0, 0)
		return false
	end
	
	if isMode('police') or isMode('fbi') then
		if text:find('Ник') and text:find('Уровень розыска') and text:find('Расстояние') and MODULE.Wanted.check_wanted then
			local text = string.gsub(text, '%{......}', '')
			text = string.gsub(text, 'Ник%s+Уровень розыска%s+Расстояние\n', '')
			for line in string.gmatch(text, '[^\n]+') do
				local nick, id, lvl, dist = string.match(line, '(%w+_%w+)%((%d+)%)%s+(%d) уровень%s+%[(.+)%]')
				if nick and id and lvl and dist then
					if dist:find('в интерьере') then
						dist = 'В инте'
					end
					table.insert(MODULE.Wanted.wanted_new, {nick = nick, id = id, lvl = lvl, dist = dist})
				end
			end
			sampSendDialogResponse(dialogid, 0, 0, 0)
			return false
		end
	end
	
	if (isMode('hospital')) then	
		if (MODULE.HealChat.healme) then
			if title:find('Активные предложения') and text:find('Лечение') and text:find('Когда') and text:find(MODULE.Binder.tags.my_nick()) then
				sampSendDialogResponse(dialogid, 1, 0, 0)
				return false
			end
			if title:find('Активные предложения') and text:find('Лечение') and not text:find('Когда') and text:find(MODULE.Binder.tags.my_nick()) then
				sampSendDialogResponse(dialogid, 1, 2, 0)
				return false
			end
			if title:find('Подтверждение действия') and text:find('Лечение') and text:find(MODULE.Binder.tags.my_nick()) then
				sampSendDialogResponse(dialogid, 1, 2, 0)
				return false
			end
		end
		if (text:find('{FFFFFF}Медик {DAD540}(.+){FFFFFF} хочет вылечить вас за {DAD540}') and text:find(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('%[%d+%]',''))) then -- /hme
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
		if text:find("Проверьте и подтвердите данные перед выдачей мед карты") and text:find("Полностью здоров") then  -- автовыдача мед.карты
			sampAddChatMessage('[Arizona Helper] {ffffff}Ожидайте пока игрок подтвердит получение мед. карты', message_color)
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
	end

	if (isMode('smi')) then
		if MODULE.SmiEdit.skip_dialog then
			sampSendDialogResponse(dialogid, 0, 0, 0)
			MODULE.SmiEdit.skip_dialog = false
			sampSendChat('/newsredak')
			return false
		end
		if title:find('Редактирование') and text:find('Объявление от') and text:find('Сообщение') then
			MODULE.SmiEdit.ad_dialog_id = dialogid
			for line in text:gmatch("[^\n]+") do
				if line:find('^{FFFFFF}Объявление от {FFD700}маркетолога (.+) %(бизнес') then
					MODULE.SmiEdit.ad_from = line:match('{FFFFFF}Объявление от {FFD700}маркетолога (.+) %(бизнес')
				elseif line:find('^{FFFFFF}Объявление от {FFD700}руководства страховой компании (.+),') then
					MODULE.SmiEdit.ad_from = line:match('{FFFFFF}Объявление от {FFD700}руководства страховой компании (.+),')
				elseif line:find('^{FFFFFF}Объявление от {FFD700}(.+),') then
					MODULE.SmiEdit.ad_from = line:match('{FFFFFF}Объявление от {FFD700}(.+),')
				end
				if line:find('{FFFFFF}Сообщение:%s+{33AA33}(.+)') then
					MODULE.SmiEdit.ad_message = line:match('{FFFFFF}Сообщение:%s+{33AA33}(.+)')
				end
			end
			local exits = false
			-- VIP
			
			if not exits then
				MODULE.SmiEdit.Window[0] = true
			end
			return false
		end
		if (title:find('Редактирование') and text:find('обычных') and text:find('автоматических') and settings.player_info.fraction_rank_number < 9) then
			sampSendDialogResponse(dialogid, 1,0,0)
			return false
		end
		if title:find('Редакция') then
			if text:find('На данный момент сообщений нет') then
				sampSendDialogResponse(dialogid, 1,0,0)
				sampAddChatMessage('[Arizona Helper] {ffffff}На данный момент нету обьявлений для редактирования!', message_color)
				return false
			end
		end 
	end
	
	if (isMode('lc')) then
		if title:find("Дорожные знаки") and (title:find("Los Santos") or title:find("San Fierro") or title:find("Las Venturas") or title:find("Lav Venturas")) and settings.lc.auto_find_clorest_repair_znak then
			-- за основу взято https://www.blast.hk/threads/231943/ by безликий
			local count = 0
			local znaks = {}
			for line in text:gmatch('[^\r\n]+') do
				count = count + 1
				if not line:find('Название знака') and not line:find('Установлен') then
					line = string.gsub(line, "%%", "")
					line = string.gsub(line, "{[0-9a-fA-F]+}", "")
					local num, name, dist, damage, status = string.match(line, '%[(%d+)%] ([^\t]+)\t([0-9%.]+)..м\t(%d*)\t(.*)')
					if name == nil then
						num, name, dist, status = string.match(line, '%[(%d+)%] ([^\t]+)\t([0-9%.]+)..м\t.*\t(.*)')
						damage = 100
					end
					table.insert(znaks, {number = num, name = name, distance = dist, health = damage, status = status})
				end
			end
			local min_dist = 999999
			local nearest = nil
			for i, znak in ipairs(znaks) do
				local dist = tonumber(znak.distance)
				if dist and dist < min_dist then
					min_dist = dist
					nearest = znak
				end
			end
			if not nearest then
				sampAddChatMessage("[Arizona Helper | Ассистент] {ffffff}В данном городе все дорожные знаки в норме!", message_color)
				sampSendDialogResponse(dialogid, 0, 0, "")
			else
				sampAddChatMessage("[Arizona Helper | Ассистент] {ffffff}Ближайший к вам знак " .. message_color_hex .. "№" .. nearest.number .. " {ffffff}(дистанция " .. message_color_hex .. nearest.distance .. "м{ffffff}, статус " .. message_color_hex .. nearest.status .. "{ffffff})", message_color)
				sampSendDialogResponse(dialogid, 1, nearest.number-1, "")
			end
			return false
		end
	end

end
function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text_3d)
   	if (MODULE.DEBUG) then
		
	end
	if settings.gov.anti_trivoga and text_3d and text_3d:find('Тревожная кнопка') then
		return false
	end
end
function sampev.onPlayerChatBubble(player_id, color, distance, duration, message)
	if (MODULE.DEBUG) then
		sampAddChatMessage('[ChatBubble] {ffffff}ID ' .. player_id .. ' | Color ' .. color .. ' | Dist ' .. distance .. ' | Duration ' .. duration .. ' | MSG ' .. message, message_color)
		print('[ChatBubble] {ffffff}ID ' .. player_id .. ' | Color ' .. color .. ' | Dist ' .. distance .. ' | Duration ' .. duration .. ' | MSG ' .. message)
	end
	if isMode('police') or isMode('fbi') then
		if message:find(" (.+) достал скрепки для взлома наручников") then
			local nick = message:match(' (.+) достал скрепки для взлома наручников')
			local id = sampGetPlayerIdByNickname(nick)
			local result, handle = sampGetCharHandleBySampPlayerId(id)
			if result then
				sampAddChatMessage('[Arizona Helper] {ffffff}Внимание! ' .. nick .. '[' .. id .. '] использует скрепки и начинает взламывать наручники!', message_color)
			end
		end
	end
end
addEventHandler('onSendPacket', function(id, bs, priority, reliability, orderingChannel)
	if id == 220 then
		local id = raknetBitStreamReadInt8(bs)
		local packettype = raknetBitStreamReadInt8(bs)
		if isMonetLoader() then
			local strlen = raknetBitStreamReadInt8(bs)
			if (MODULE.DEBUG) then
				local str = raknetBitStreamReadString(bs, strlen)
				sampAddChatMessage('[SendPacket] {ffffff}' .. str, message_color)
				print("[SendPacket] " .. str)
			end
		else
			local strlen = raknetBitStreamReadInt16(bs)
			local str = raknetBitStreamReadString(bs, strlen)
			if packettype ~= 0 and packettype ~= 1 and #str > 2 then
				if (MODULE.DEBUG) then
					sampAddChatMessage('[SendPacket] {ffffff}' .. str, message_color)
					print("[SendPacket] " .. str)
				end
			end
		end
	end
end)
addEventHandler('onReceivePacket', function(id, bs)
	if id == 220 then
		local id = raknetBitStreamReadInt8(bs)
        local cmd = raknetBitStreamReadInt8(bs)
		local function dumpFullBitStream(bs)
			local bitsLeft = raknetBitStreamGetNumberOfUnreadBits(bs)
			if not bitsLeft then
				print("dumpFullBitStream: raknetBitStreamGetNumberOfUnreadBits ошибка!")
				return
			end
			local bytesLeft = math.floor(bitsLeft / 8)
			if bytesLeft == 0 then
				print("dumpFullBitStream: нету доступных байтов для чтения")
				return
			end
			local bytes = {}
			for i = 1, bytesLeft do
				bytes[i] = raknetBitStreamReadInt8(bs)
			end
			local hexStrParts = {}
			for i, b in ipairs(bytes) do
				hexStrParts[i] = string.format("%02X", b)
			end
			return(table.concat(hexStrParts, " "))
		end
		-- if (MODULE.DEBUG) then
		-- 	local dump = dumpFullBitStream(bs)
		-- 	sampAddChatMessage('[ReceivePacket] {ffffff}' .. dump, message_color)
		-- 	print("[ReceivePacket] " .. dump)
		-- end
		if cmd == 153 then
            local carId = raknetBitStreamReadInt16(bs)
            raknetBitStreamIgnoreBits(bs, 8)
            local numberlen = raknetBitStreamReadInt8(bs)
            local plate_number = raknetBitStreamReadString(bs, numberlen)
            local typelen = raknetBitStreamReadInt8(bs)
            local numType = raknetBitStreamReadString(bs, typelen)
            modules.arz_veh.cache[carId] = {
                carID = carId or 0,
                number = plate_number or "",
                region = numType or "",
            }
        end
		if isMonetLoader() then 
			if cmd == 84 then
				local unk1 = raknetBitStreamReadInt8(bs)
				local unk2 = raknetBitStreamReadInt8(bs)
				local len = raknetBitStreamReadInt16(bs)
				local encoded = raknetBitStreamReadInt8(bs)
				local string = encoded == 0 and raknetBitStreamReadString(bs, len) or raknetBitStreamDecodeString(bs, len + encoded)
				if (MODULE.DEBUG) then
					sampAddChatMessage('[ReceivePacket] {ffffff}' .. string, message_color)
					print("[ReceivePacket] " .. string)
				end
			end
		else
			if cmd == 17 then
				raknetBitStreamIgnoreBits(bs, 32)
				local length = raknetBitStreamReadInt16(bs)
				local encoded = raknetBitStreamReadInt8(bs)
				local cmd = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
				if (MODULE.DEBUG) then
					sampAddChatMessage('[ReceivePacket] {ffffff}' .. cmd, message_color)
					print("[ReceivePacket] " .. cmd)
				end
				if cmd:find('"Проверка документов","Найдите') then
					local find = cmd:match('%[.+%[(.+)%]%]')
					sampAddChatMessage("[Arizona Helper | Ассистент] {ffffff}Правильные конверты: " .. find:gsub(',', ' '), message_color)
					sampShowDialog(897124, 'Arizona Helper - Ассистент', "Правильные конверты: " .. find:gsub(',', ' '), '{009EFF}Закрыть', '', 0)
				end
			end
		end
	end
end)
addEventHandler('onReceiveRpc', function(id, bs)
	if id == 123 then
        local carId = raknetBitStreamReadInt16(bs)
        local numLen = raknetBitStreamReadInt8(bs)
		local plate_number = raknetBitStreamReadString(bs, numLen)
		modules.arz_veh.cache[carId] = {
			carID = carId or 0,
			number = plate_number or "",
			type = "ARZ"
		}
	end
end)
--------------------------------------------- INIT GUI --------------------------------------------
imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	imgui.GetIO().Fonts:Clear()

	local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
	if isMonetLoader() then
		MODULE.FONT = imgui.GetIO().Fonts:AddFontFromFileTTF(getWorkingDirectory():gsub('\\','/') .. '/lib/mimgui/trebucbd.ttf', 14 * settings.general.custom_dpi, _, glyph_ranges)
	else
		MODULE.FONT = imgui.GetIO().Fonts:AddFontFromFileTTF(getFolderPath(0x14)..'\\trebucbd.ttf', 14 * settings.general.custom_dpi, _, glyph_ranges)
	end

	fa.Init(14 * settings.general.custom_dpi)

	if settings.general.helper_theme == 0 and monet_no_errors then
		apply_moonmonet_theme()
	elseif settings.general.helper_theme == 1 then
		apply_dark_theme()
	elseif settings.general.helper_theme == 2 then
		apply_white_theme()
	end

	imgui.GetIO().ConfigFlags = imgui.ConfigFlags.NoMouseCursorChange

end)

imgui.OnFrame(
    function() return MODULE.Initial.Window[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.GEARS .. u8' Первоначальная настройка Arizona Helper ' .. fa.GEARS, MODULE.Initial.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        change_dpi()
		if MODULE.Initial.step == 0 then
			if (doesFileExist(configDirectory .. '/Resourse/logo.png')) then
				if (not _G.helper_logo) then
					local path = configDirectory .. '/Resourse/logo.png'
					_G.helper_logo = imgui.CreateTextureFromFile(path)
				else
					imgui.Image(_G.helper_logo, imgui.ImVec2(520 * settings.general.custom_dpi, 150 * settings.general.custom_dpi))
				end
			else
				if imgui.BeginChild('##init1_1', imgui.ImVec2(520 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then
					imgui.Text("\n\n\n")
					imgui.CenterTextDisabled(u8('Не удалось автоматически загрузить логотип и другие файлы хелпера!\n\n'))
					imgui.CenterTextDisabled(u8('На время включите VPN для подгрузки нужных файлов, либо скачайте вручную'))
					imgui.CenterTextDisabled(u8('https://github.com/MTGMODS/arizona-helper'))
					imgui.EndChild()
				end
			end
			imgui.CenterText(u8("Похоже вы впервые запустили хелпер, или сбросили настройки"))
			imgui.CenterText(u8("Необходимо произвести настройку для доступности команд и функций"))
			imgui.Separator()
			imgui.CenterText(u8("Выберите способ для настройки хелпера:"))
			if imgui.CenterButton(fa.CIRCLE_ARROW_RIGHT .. u8(' Автоматически через /stats (рекомендовано) ') .. fa.CIRCLE_ARROW_LEFT) then
				check_stats = true
				sampSendChat('/stats')
				MODULE.Initial.Window[0] = false
			end
			if imgui.CenterButton(fa.CIRCLE_ARROW_RIGHT .. u8(' Указать данные вручную (на всякий случай) ') .. fa.CIRCLE_ARROW_LEFT) then
				MODULE.Initial.fraction_type_selector = 0
				MODULE.Initial.step = 1
			end
			imgui.Separator()
			imgui.CenterText(u8("Если что, в любой момент вы сможете заново перепройти настройку хелпера"))
		elseif MODULE.Initial.step == 1 then
			imgui.CenterText(u8('Выберите тип вашей организации для импорта команд и функций:'))

			local function render_org_block(org_num, icon, name, fractions, tags)
				if imgui.BeginChild('##init1_'..org_num, imgui.ImVec2(170 * settings.general.custom_dpi, 45 * settings.general.custom_dpi), (MODULE.Initial.fraction_type_selector == org_num)) then
					if not (MODULE.Initial.fraction_type_selector == org_num) then
						imgui.SetCursorPos(imgui.ImVec2(0, 5 * settings.general.custom_dpi))
					end
					imgui.CenterText(icon .. u8(' '..name))
					imgui.CenterTextDisabled(u8(fractions))
					imgui.EndChild()
				end
				if imgui.IsItemClicked() then
					MODULE.Initial.fraction_type_selector = org_num
					MODULE.Initial.fraction_type_selector_text = name
					MODULE.Initial.fraction_type_icon = icon
				end
			end
			render_org_block(1, fa.BUILDING_SHIELD, 'Мин.Юстиции', 'ЛСПД/ЛВПД/СФПД/ФБР/РКШ')
			imgui.SameLine()
			render_org_block(2, fa.HOSPITAL, 'Мин.Здрав.', 'ЛСМЦ/ЛВМЦ/СФМЦ/ДМЦ')
			imgui.SameLine()
			render_org_block(3, fa.BUILDING_SHIELD, 'Мин.Обороны', 'ЛСа/СФА/ВС/ТСР/ФСИН')
			render_org_block(4, fa.BUILDING_NGO, 'Масс.Медиа', 'СМИ ЛС/ЛВ/СФ/ВС/АЗ')
			imgui.SameLine()
			render_org_block(5, fa.BUILDING_COLUMNS, 'Центральный аппарат', 'Право/ГЦЛ/СТК/МРЭО')
			imgui.SameLine()
			render_org_block(6, fa.HOTEL, 'Пожарная часть', 'ПД')
			render_org_block(7, fa.TORII_GATE, 'Мафия', 'YKZ/LCN/RM/WMC/TRB')
			imgui.SameLine()
			render_org_block(8, fa.BUILDING_WHEAT, 'Банда', 'Грув/Балас/Рифа/Вагос')
			imgui.SameLine()
			render_org_block(0, fa.BUILDING_CIRCLE_XMARK, 'Без организации', 'Биндер & Заметки')

			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Назад'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Initial.step = 0
			end
			imgui.SameLine()
			if imgui.Button(u8('Выбрать "' .. MODULE.Initial.fraction_type_selector_text .. '" ') .. fa.CIRCLE_ARROW_RIGHT, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Initial.slider[0] = 1
				if MODULE.Initial.fraction_type_selector ~= 0 then
					MODULE.Initial.step = 2
				else
					settings.player_info.fraction_rank = 'Нету'
					settings.player_info.fraction_rank_number = 0
					MODULE.Initial.step = 4
				end
			end
		elseif MODULE.Initial.step == 2 then
    		imgui.CenterText(u8('Выберите свою организацию из категории "' .. MODULE.Initial.fraction_type_selector_text .. '":'))

			local function render_fraction_block(org_num, name, fraction_tag)
				if imgui.BeginChild('##init2_'..org_num, imgui.ImVec2(170 * settings.general.custom_dpi, 45 * settings.general.custom_dpi), (MODULE.Initial.fraction_selector == org_num)) then
					if not (MODULE.Initial.fraction_selector == org_num) then
						imgui.SetCursorPos(imgui.ImVec2(0, 5 * settings.general.custom_dpi))
					end
					imgui.CenterText(u8(name))
					imgui.CenterTextDisabled(u8(fraction_tag))
					imgui.EndChild()
				end
				if imgui.IsItemClicked() then
					MODULE.Initial.fraction_selector = org_num
					MODULE.Initial.fraction_selector_text = name
					MODULE.Initial.step2_result = (MODULE.Initial.fraction_type_selector * 10) + org_num
				end
			end
			local orgs = {
				[1] = {
					{name = "Полиция Лос-Сантоса", 			tag = "ЛСПД"},
					{name = "Полиция Лас-Вентураса",		tag = "ЛВПД"},
					{name = "Полиция Сан-Фиерро", 			tag = "СФПД"},
					{name = "Областная полиция", 			tag = "РКШД"},
					{name = "S.W.A.T.", 					tag = "СВАТ"},
					{name = "Фед.Бюро Расследований", 		tag = "ФБР"},
					{name = "Городская полиция", 			tag = "ГУВД"},
					{name = "Полиция округа", 				tag = "КТЦ"},
					{name = "Фед.Служба Безопасности", 		tag = "ФСБ"},
				},
				[2] = {
					{name = "Больница Лос-Сантоса",   		tag = "ЛСМЦ"},
					{name = "Больница Лас-Вентураса", 		tag = "ЛВМЦ"},
					{name = "Больница Сан-Фиерро", 			tag = "СФМЦ"},
					{name = "Больница Джефферсон", 			tag = "ДМЦ"},
					{name = "Больница Вайс-Сити", 			tag = "ВСМЦ"},
					{name = "Городская больница", 			tag = "СМП"},
					{name = "Больница округа", 				tag = "МУСС"},
				},
				[3] = {
					{name = "Армия Лос-Сантоса", 			tag = "ЛСа"},
					{name = "Армия Сан-Фиерро", 			tag = "СФа"},
					{name = "Армия Арзамаса", 				tag = "ВС"},
					{name = "Тюрьма Строго Режима LV", 		tag = "ТСР"},
					{name = "Фед.Служба Исп.Наказаний", 	tag = "ФСИН"},
				},
				[4] = {
					{name = "СМИ Лос-Сантоса", 				tag = "СМИ ЛС"},
					{name = "СМИ Лас-Вентураса", 			tag = "СМИ ЛВ"},
					{name = "СМИ Сан-Фиерро", 				tag = "СМИ СФ"},
					{name = "СМИ Вайс-Сити", 				tag = "СМИ ВС"},
					{name = "СМИ Арзамаса", 				tag = "НА"},
				},
				[5] = {
					{name = "Правительство", 				tag = "Право"},
					{name = "Центр лицензирования", 		tag = "ГЦЛ"},
					{name = "Страховая компания", 			tag = "СТК"},
					{name = "Судья", 						tag = "Судья"},
					{name = "МРЭО ГИБДД", 					tag = "МРЭО"},
				},
				[6] = {
					{name = "Пожарный департамент", 		tag = "ПД"},
				},
				[7] = {
					{name = "Yakuza", 						tag = "YKZ"},
					{name = "La Cosa Nostra", 				tag = "LCN"},
					{name = "Russian Mafia", 				tag = "RM"},
					{name = "Warlock MC", 					tag = "WMC"},
					{name = "Tierra Robada Bikers", 		tag = "TRB"},
					{name = "Украинская мафия", 			tag = "УМ"},
					{name = "Кавказкая мафия", 				tag = "КМ"},
					{name = "Русская мафия", 				tag = "РМ"},
				},
				[8] = {
					{name = "Grove Street", 				tag = "Грув"},
					{name = "East Side Ballas", 			tag = "Балас"},
					{name = "Los Santos Vagos", 			tag = "Вагос"},
					{name = "The Rifa", 					tag = "Рифа"},
					{name = "Varrios Los Aztecas", 			tag = "Ацтек"},
					{name = "Night Wolves", 				tag = "Волки"},
				},
			}
			local org_list = orgs[MODULE.Initial.fraction_type_selector]
			for i, org in ipairs(org_list) do
				render_fraction_block(i, org.name, org.tag)
				if ((i % 3 ~= 0) and i ~= #org_list) then imgui.SameLine() end
			end

			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Назад'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Initial.step = 1
			end
			imgui.SameLine()
			if imgui.Button(u8('Выбрать "' .. MODULE.Initial.fraction_selector_text .. '" ') .. fa.CIRCLE_ARROW_RIGHT, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				if MODULE.Initial.step2_result ~= 0 then
					MODULE.Initial.step = 3
				end
			end
		elseif MODULE.Initial.step == 3 then
			imgui.CenterText(u8('Укажите вашу должность в организации (полное название и порядковый номер ранга):'))
			imgui.PushItemWidth(520 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_fraction_rank', u8('Введите полное название вашей должности в организации...'), MODULE.Initial.input, 256)
			imgui.PushItemWidth(520 * settings.general.custom_dpi)
			imgui.SliderInt('##fraction_rank_number', MODULE.Initial.slider, 1, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Назад'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.StrCopy(MODULE.Initial.input, "")
				MODULE.Initial.step = 2
			end
			imgui.SameLine()
			if imgui.Button(u8('Продолжить ') .. fa.CIRCLE_ARROW_RIGHT, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				settings.player_info.fraction_rank = u8:decode(ffi.string(MODULE.Initial.input))
				settings.player_info.fraction_rank_number = MODULE.Initial.slider[0]
				if settings.player_info.fraction_rank_number >= 9 then
					settings.general.auto_uninvite = true
				end
				imgui.StrCopy(MODULE.Initial.input, "")
				MODULE.Initial.step = 4
			end
		elseif MODULE.Initial.step == 4 then
			imgui.CenterText(u8('Введите ваш полный игровой никнейм (на английском):'))
			imgui.PushItemWidth(520 * settings.general.custom_dpi)
			imgui.InputText(u8'##input_nick', MODULE.Initial.input, 256)
			imgui.CenterTextDisabled(u8(TranslateNick(u8:decode(ffi.string(MODULE.Initial.input)))))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_ARROW_LEFT .. u8(' Назад'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.StrCopy(MODULE.Initial.input, "")
				MODULE.Initial.step = 3
			end
			imgui.SameLine()
			if imgui.Button(u8('Завершить настройку ') .. fa.FLAG_CHECKERED, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				settings.player_info.nick = u8:decode(ffi.string(MODULE.Initial.input))
				settings.player_info.name_surname = TranslateNick(settings.player_info.nick)
				MODULE.Initial.step = 5
			end
		elseif MODULE.Initial.step == 5 then
			local fraction_modes = {
				{id = 0,  name = "Отсутствует",         	   mode = "none",       tag = "Нету"},
				{id = 11, name = "Полиция Лос-Сантоса",        mode = "police", 	tag = "ЛСПД"},
				{id = 12, name = "Полиция Лас-Вентураса",      mode = "police", 	tag = "ЛВПД"},
				{id = 13, name = "Полиция Сан-Фиерро",         mode = "police", 	tag = "СФПД"},
				{id = 14, name = "Областная полиция",          mode = "police", 	tag = "РКШД"},
				{id = 15, name = "S.W.A.T.",                   mode = "police", 	tag = "СВАТ"},
				{id = 16, name = "Фед. Бюро Расследований",    mode = "fbi",    	tag = "ФБР"},
				{id = 17, name = "Городская полиция",          mode = "police",	 	tag = "ГУВД"},
				{id = 18, name = "Полиция округа",             mode = "police", 	tag = "КТЦ"},
				{id = 19, name = "Фед. Служба Безопасности",   mode = "fbi",    	tag = "ФСБ"},
				{id = 21, name = "Больница Лос-Сантоса",       mode = "hospital", 	tag = "ЛСМЦ"},
				{id = 22, name = "Больница Лас-Вентураса",     mode = "hospital", 	tag = "ЛВМЦ"},
				{id = 23, name = "Больница Сан-Фиерро",        mode = "hospital", 	tag = "СФМЦ"},
				{id = 24, name = "Больница Джефферсон",        mode = "hospital", 	tag = "ДМЦ"},
				{id = 25, name = "Больница Вайс-Сити",         mode = "hospital", 	tag = "ВСМЦ"},
				{id = 26, name = "Городская больница",         mode = "hospital", 	tag = "СМП"},
				{id = 27, name = "Больница округа",            mode = "hospital", 	tag = "МУСС"},
				{id = 31, name = "Армия Лос-Сантоса",          mode = "army", 		tag = "ЛСа"},
				{id = 32, name = "Армия Сан-Фиерро",           mode = "army", 		tag = "СФа"},
				{id = 33, name = "Армия Арзамаса",             mode = "army", 		tag = "ВС"},
				{id = 34, name = "Тюрьма Строгого Режима LV",  mode = "prison", 	tag = "ТСР"},
				{id = 35, name = "Фед. Служба Исп. Наказаний", mode = "prison", 	tag = "ФСИН"},
				{id = 41, name = "СМИ Лос-Сантоса",            mode = "smi",	 	tag = "СМИ ЛС"},
				{id = 42, name = "СМИ Лас-Вентураса",          mode = "smi", 		tag = "СМИ ЛВ"},
				{id = 43, name = "СМИ Сан-Фиерро",             mode = "smi", 		tag = "СМИ СФ"},
				{id = 44, name = "СМИ Вайс-Сити",              mode = "smi", 		tag = "СМИ ВС"},
				{id = 45, name = "СМИ Арзамаса",               mode = "smi", 		tag = "НА"},
				{id = 51, name = "Правительство",              mode = "gov", 		tag = "Право"},
				{id = 52, name = "Центр лицензирования",       mode = "lc", 		tag = "ГЦЛ"},
				{id = 53, name = "Страховая компания",         mode = "inc", 		tag = "СТК"},
				{id = 54, name = "Судья",                      mode = "judge", 		tag = "Судья"},
				{id = 55, name = "МРЭО ГИБДД",                 mode = "lc", 		tag = "МРЭО"},
				{id = 61, name = "Пожарный департамент",       mode = "fd", 		tag = "ПД"},
				{id = 71, name = "Yakuza",                     mode = "mafia",		tag = "YKZ"},
				{id = 72, name = "La Cosa Nostra",             mode = "mafia", 		tag = "ЛКН"},
				{id = 73, name = "Russian Mafia",              mode = "mafia", 		tag = "РМ"},
				{id = 74, name = "Warlock MC",                 mode = "mafia", 		tag = "WMC"},
				{id = 75, name = "Tierra Robada Bikers",       mode = "mafia", 		tag = "ТРБ"},
				{id = 76, name = "Украинская мафия",           mode = "mafia", 		tag = "УМ"},
				{id = 77, name = "Кавказская мафия",           mode = "mafia", 		tag = "КМ"},
				{id = 78, name = "Русская мафия",              mode = "mafia", 		tag = "РМ"},
				{id = 81, name = "Grove Street",               mode = "ghetto", 	tag = "Грув"},
				{id = 82, name = "East Side Ballas",           mode = "ghetto", 	tag = "Балас"},
				{id = 83, name = "Los Santos Vagos",           mode = "ghetto", 	tag = "Вагос"},
				{id = 84, name = "The Rifa",                   mode = "ghetto", 	tag = "Рифа"},
				{id = 85, name = "Varrios Los Aztecas",        mode = "ghetto", 	tag = "Ацтек"},
				{id = 86, name = "Night Wolves",               mode = "ghetto", 	tag = "Волки"},
			}	
			for index, value in ipairs(fraction_modes) do
				if value.id == MODULE.Initial.step2_result then
					settings.general.fraction_mode = value.mode
					settings.player_info.fraction = value.name
					settings.player_info.fraction_tag = value.tag
					break
				end
			end

			local function add_unique(tbl, cmds)
				for _, cmd in ipairs(cmds) do
					local exists = false
					for _, v in ipairs(tbl) do
						if v.cmd == cmd.cmd then exists = true break end
					end
					if not exists then table.insert(tbl, cmd) end
				end
			end
			add_unique(modules.commands.data.commands.my, get_fraction_cmds(settings.general.fraction_mode, false))
			add_unique(modules.commands.data.commands_manage.my, get_fraction_cmds(settings.general.fraction_mode, true))

			if settings.general.fraction_mode == 'police' or settings.general.fraction_mode == 'fbi' then
				add_notes()
			elseif settings.general.fraction_mode == 'prison' then
				add_notes('prison')
			end
	
			save_settings()
			save_module('commands')
			reload_script = true
			thisScript():reload()
		end
        imgui.End()
    end
)
--------------------------------------------- MAIN GUI --------------------------------------------
imgui.OnFrame(
    function() return MODULE.Main.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 430	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(getHelperIcon() .. " Arizona Helper " .. getHelperIcon() .. "##main", MODULE.Main.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		if imgui.BeginTabBar('Привет! Зачем код смотришь?') then	
			if imgui.BeginTabItem(fa.HOUSE..u8' Главное меню') then
				if (doesFileExist(configDirectory .. '/Resourse/logo.png')) then
					if (not _G.helper_logo) then
						local path = configDirectory .. '/Resourse/logo.png'
						_G.helper_logo = imgui.CreateTextureFromFile(path)
					else
						imgui.Image(_G.helper_logo, imgui.ImVec2(589 * settings.general.custom_dpi, 161 * settings.general.custom_dpi))
					end
				else
					if imgui.BeginChild('##1000000000000', imgui.ImVec2(589 * settings.general.custom_dpi, 161 * settings.general.custom_dpi), true) then
						imgui.Text("\n\n\n")
						imgui.CenterTextDisabled(u8('Не удалось автоматически загрузить логотип и другие файлы хелпера!\n\n'))
						imgui.CenterTextDisabled(u8('На время включите VPN для подгрузки нужных файлов, либо скачайте вручную'))
						imgui.CenterTextDisabled(u8('https://github.com/MTGMODS/arizona-helper'))
						imgui.EndChild()
					end
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 169 * settings.general.custom_dpi), true) then
					imgui.CenterText(getUserIcon() .. u8' Информация про вашего персонажа ' .. getUserIcon())
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Имя и Фамилия:")
					imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.name_surname))
					imgui.SetColumnWidth(-1, 250 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##name_surname') then
						settings.player_info.name_surname = TranslateNick(sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))))
						imgui.StrCopy(MODULE.Main.input, u8(settings.player_info.name_surname))
						imgui.StrCopy(MODULE.Initial.input, u8(settings.player_info.nick))
						imgui.OpenPopup(getUserIcon() .. u8' Имя и Фамилия ' .. getUserIcon() .. '##name_surname')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getUserIcon() .. u8' Имя и Фамилия ' .. getUserIcon() .. '##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##name_surname', u8('Введите имя и фамилию вашего персонажа...'), MODULE.Main.input, 256)
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						if imgui.InputTextWithHint(u8'##nickname', u8('Введите ваш игровой никнейм...'), MODULE.Initial.input, 256) then
							imgui.StrCopy(MODULE.Main.input, u8(TranslateNick(u8:decode(ffi.string(MODULE.Initial.input)))))
						end
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_name_surname', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_name_surname', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.name_surname = u8:decode(ffi.string(MODULE.Main.input))
							settings.player_info.nick = u8:decode(ffi.string(MODULE.Initial.input))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Акцент персонажа:")
					imgui.NextColumn()
					if MODULE.Main.checkbox.accent_enable[0] then
						imgui.CenterColumnText(u8(settings.player_info.accent))
					else 
						imgui.CenterColumnText(u8'Отключено')
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##accent') then
						imgui.StrCopy(MODULE.Main.input, u8(settings.player_info.accent))
						imgui.OpenPopup(getUserIcon() .. u8' Акцент персонажа ' .. getUserIcon() .. '##accent')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getUserIcon() .. u8' Акцент персонажа ' .. getUserIcon() .. '##accent', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						if imgui.Checkbox('##MODULE.Main.checkbox.accent_enable', MODULE.Main.checkbox.accent_enable) then
							settings.player_info.accent_enable = MODULE.Main.checkbox.accent_enable[0]
							save_settings()
						end
						imgui.SameLine()
						imgui.PushItemWidth(375 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##accent_input', u8('Введите акцент вашего персонажа...'), MODULE.Main.input, 256) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_accent', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_accent', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then 
							settings.player_info.accent = u8:decode(ffi.string(MODULE.Main.input))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Пол персонажа:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.sex))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##sex') then
						settings.player_info.sex = (settings.player_info.sex ~= 'Мужчина') and 'Мужчина' or 'Женщина'
						save_settings()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Организация:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction))
					imgui.NextColumn()
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. "##fraction") then
						imgui.StrCopy(MODULE.Main.input, u8(settings.player_info.fraction))
						imgui.OpenPopup(getHelperIcon() .. u8' Организация ' .. getHelperIcon() .. '##fraction')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Организация ' .. getHelperIcon() .. '##fraction', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_fraction_name', u8('Введите название вашей организации...'), MODULE.Main.input, 256)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_fraction_edit', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_fraction_edit', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction = u8:decode(ffi.string(MODULE.Main.input))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.GEAR .. '##fraction') then
						imgui.OpenPopup(getHelperIcon() .. u8' Смена организации ' .. getHelperIcon() .. '##fraction')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Смена организации ' .. getHelperIcon() .. '##fraction', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8('Вы действительно хотите изменить организацию?'))
						imgui.CenterText(u8('Все стандартные фракционные RP команды будут сброшены!'))
						imgui.CenterText(u8('Но ваши личные RP команды, которые вы добавляли, сохраняться'))
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_new_fraction', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.GEARS .. u8' Сбросить ' .. fa.GEARS .. '##reset_fraction', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							delete_default_fraction_cmds(modules.commands.data.commands.my, get_fraction_cmds(settings.general.fraction_mode, false))
							delete_default_fraction_cmds(modules.commands.data.commands_manage.my, get_fraction_cmds(settings.general.fraction_mode, true))
							MODULE.Initial.Window[0] = true
							MODULE.Main.Window[0] = false
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Должность:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_rank) .. " (" .. settings.player_info.fraction_rank_number .. ")")
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. "##rank") then
						imgui.StrCopy(MODULE.Main.input, u8(settings.player_info.fraction_rank))
						MODULE.Main.slider[0] = settings.player_info.fraction_rank_number
						imgui.OpenPopup(getHelperIcon() .. u8' Должность в организации ' .. getHelperIcon() .. '##fraction_rank')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Должность в организации ' .. getHelperIcon() .. '##fraction_rank', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_fraction_rank', u8('Введите название вашей должности...'), MODULE.Main.input, 256)
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.SliderInt('##fraction_rank_number', MODULE.Main.slider, 1, 10) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_fraction_rank', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_fraction_rank', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction_rank = u8:decode(ffi.string(MODULE.Main.input))
							settings.player_info.fraction_rank_number = MODULE.Main.slider[0]
							if settings.player_info.fraction_rank_number >= 9 then
								settings.general.auto_uninvite = true
								registerCommandsFrom(modules.commands.data.commands_manage.my)
							end	
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PASSPORT .. '##stats') then
						check_stats = true
						sampSendChat('/stats')
					end
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Тег организации:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##fraction_tag') then
						imgui.StrCopy(MODULE.Main.input, u8(settings.player_info.fraction_tag))
						imgui.OpenPopup(getHelperIcon() .. u8' Тег организации ' .. getHelperIcon() .. '##fraction_tag')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Тег организации ' .. getHelperIcon() .. '##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##input_fraction_tag', MODULE.Main.input, 256)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_fraction_rank', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_fraction_tag', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction_tag = u8:decode(ffi.string(MODULE.Main.input))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
				imgui.EndChild()
				end
				if imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 28 * settings.general.custom_dpi), true) then
					imgui.Columns(2)
					imgui.Text(fa.HAND_HOLDING_DOLLAR .. u8" Вы можете финансово поддержать автора скрипта (MTG MODS) донатом " .. fa.HAND_HOLDING_DOLLAR)
					imgui.SetColumnWidth(-1, 480 * settings.general.custom_dpi)
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(u8'Реквизиты') then
						imgui.OpenPopup(fa.SACK_DOLLAR .. u8' Поддержка разработчика ' .. fa.SACK_DOLLAR)
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.SACK_DOLLAR .. u8' Поддержка разработчика ' .. fa.SACK_DOLLAR, _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Свяжитесь с MTG MODS:')
						if imgui.Button(u8('Telegram'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							openLink('https://t.me/MTGMODS')
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(u8('Discord'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							openLink('https://discordapp.com/users/514135796685602827')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
					imgui.Columns(1)
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8' Команды и RP отыгровки') then 
				if imgui.BeginTabBar('Список всех команд') then
					if imgui.BeginTabItem(fa.BARS..u8' Стандартные команды') then 
						if imgui.BeginChild('##99', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
							imgui.Columns(2)
							imgui.CenterColumnText(u8"Команда")
							imgui.SetColumnWidth(-1, 220 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Описание")
							imgui.SetColumnWidth(-1, 400 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							if settings.general.rp_guns then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/rpguns")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Настройка RP отыгровок оружия")
								imgui.Columns(1)
								imgui.Separator()
								end
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/pnv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Надеть/снять очки ночного видения")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/irv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Надеть/снять инфракрасные очки")
							imgui.Columns(1)
							imgui.Separator()
							if settings.general.cruise_control then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/cruise")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Адаптивный круиз-контроль")
								imgui.Columns(1)
								imgui.Separator()
							end
							if not isMode('none') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/mb")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Кастомный /members")
								imgui.Columns(1)
								imgui.Separator()
							end
							if not (isMode('ghetto') or isMode('mafia')) then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/dep")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Рация департамента")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/sob")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Проведения собеседования")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/post")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню системы постов")
								imgui.Columns(1)
								imgui.Separator()
							end
							if isMode('prison') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/pum")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню умного повышения срока")
								imgui.Columns(1)
								imgui.Separator()
							elseif isMode('police') or isMode('fbi') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/wanteds")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню общего списка /wanted")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/patrool")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню патрулирования")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/sum")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню умной выдачи розыска")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/tsm")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню умной выдачи штрафов")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/afind")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Флудер /find для поиска игрока по ID")
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.EndChild()
						end
						imgui.EndTabItem()
					end
					function render_cmds(isManage)
						local cmd_array = (isManage and modules.commands.data.commands_manage.my or modules.commands.data.commands.my)
						if imgui.BeginChild('##' .. (isManage and 1 or 2), imgui.ImVec2(589 * settings.general.custom_dpi, 308 * settings.general.custom_dpi), true) then
							imgui.Columns(3)
							imgui.CenterColumnText(u8"Команда")
							imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Описание")
							imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Действие")
							imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							if isManage then
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/spcar")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Заспавнить транспорт организации")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Недоступно")
								imgui.Columns(1)
								imgui.Separator()	
							else
								imgui.Columns(3)
								imgui.CenterColumnText(u8"/stop")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Остановить отыгровку любой RP команды")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Недоступно")
								imgui.Columns(1)
								imgui.Separator()
							end
							for index, command in ipairs(cmd_array) do
								imgui.Columns(3)
								if command.enable then imgui.CenterColumnText('/' .. u8(command.cmd)) else imgui.CenterColumnTextDisabled('/' .. u8(command.cmd)) end
								imgui.NextColumn()
								if command.enable then imgui.CenterColumnText(u8(command.description)) else imgui.CenterColumnTextDisabled(u8(command.description)) end
								imgui.NextColumn()
								imgui.Text('  ')
								imgui.SameLine()
								if imgui.SmallButton((command.enable and fa.TOGGLE_ON or fa.TOGGLE_OFF) .. '##' .. command.cmd) then
									command.enable = not command.enable
									save_module('commands')
									if command.enable then
										register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
									else
										sampUnregisterChatCommand(command.cmd)
									end
								end
								if imgui.IsItemHovered() then
									local tooltip = command.enable and "Отключение команды /" or "Включение команды /"
									imgui.SetTooltip(u8(tooltip .. command.cmd))
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##'..command.cmd) then
									if command.arg == '' then
										MODULE.Binder.ComboTags[0] = 0
									elseif command.arg == '{arg}' then	
										MODULE.Binder.ComboTags[0] = 1
									elseif command.arg == '{arg_id}' then
										MODULE.Binder.ComboTags[0] = 2
									elseif command.arg == '{arg_id} {arg2}' then
										MODULE.Binder.ComboTags[0] = 3
									elseif command.arg == '{arg_id} {arg2} {arg3}' then
										MODULE.Binder.ComboTags[0] = 4
									elseif command.arg == '{arg_id} {arg2} {arg3} {arg4}' then
										MODULE.Binder.ComboTags[0] = 5
									end
									MODULE.Binder.data = {
										change_waiting = command.waiting,
										change_cmd = command.cmd,
										change_text = command.text:gsub('&', '\n'),
										change_arg = command.arg,
										change_bind = command.bind,
										change_in_fastmenu = command.in_fastmenu,
										create_command_9_10 = isManage
									}
									MODULE.Binder.input_description = imgui.new.char[256](u8(command.description))
									MODULE.Binder.input_cmd = imgui.new.char[256](u8(command.cmd))
									MODULE.Binder.input_text = imgui.new.char[8192](u8(MODULE.Binder.data.change_text))
									MODULE.Binder.waiting_slider = imgui.new.float(tonumber(command.waiting))	
									MODULE.Binder.Window[0] = true
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"Изменение команды /"..command.cmd)
								end
								imgui.SameLine()
								if imgui.SmallButton(fa.TRASH_CAN .. '##'..command.cmd) then
									imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION ..  '##' .. command.cmd)
								end
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"Удаление команды /"..command.cmd)
								end
								imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
								if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION ..  '##' .. command.cmd, _, imgui.WindowFlags.NoResize ) then
									change_dpi()
									imgui.CenterText(u8'Вы действительно хотите удалить команду /' .. u8(command.cmd) .. '?')
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK .. '##delete_cmd' .. index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить ' .. fa.TRASH_CAN .. '##delete_cmd' .. index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										sampUnregisterChatCommand(command.cmd)
										table.remove(cmd_array, index)
										save_module('commands')
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.EndChild()
						end
						if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новую команду ' .. fa.CIRCLE_PLUS .. '##new_cmd' .. (isManage and 1 or 2), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							local my_cmds = isManage and #modules.commands.data.commands_manage.my or #modules.commands.data.commands.my
							local max_cmds = #get_fraction_cmds(settings.general.fraction_mode, isManage) + 10
							if my_cmds > max_cmds then
							 	send_no_vip_msg()
								return
							end
							local new_cmd = {cmd = '', description = '', text = '', arg = '', enable = true, waiting = '1.5', bind = "{}" }
							table.insert(cmd_array, new_cmd)
							MODULE.Binder.data = {
								change_waiting = new_cmd.waiting,
								change_cmd = new_cmd.cmd,
								change_text = new_cmd.text,
								change_arg = new_cmd.arg,
								change_bind = new_cmd.bind,
								change_in_fastmenu = false,
								create_command_9_10 = isManage
							}
							MODULE.Binder.ComboTags[0] = 0
							MODULE.Binder.input_description = imgui.new.char[256]("")
							MODULE.Binder.input_cmd = imgui.new.char[256]("")
							MODULE.Binder.input_text = imgui.new.char[8192]("")
							MODULE.Binder.waiting_slider = imgui.new.float(1.5)
							MODULE.Binder.Window[0] = true
						end
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP команды') then 
						render_cmds(false)
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP команды (9/10)') then 
						if settings.player_info.fraction_rank_number == 9 or settings.player_info.fraction_rank_number == 10 then
							render_cmds(true)
						else
							if imgui.BeginChild('##no_rank_access', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
								imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8" Внимание " .. fa.TRIANGLE_EXCLAMATION)
								imgui.Separator()
								imgui.CenterText(u8"У вас нету доступа к данным командам!")
								imgui.CenterText(u8"Необходимо иметь 9 или 10 ранг, у вас же - " .. settings.player_info.fraction_rank_number .. u8" ранг!")
								imgui.Separator()
								imgui.EndChild()
							end
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.COMPASS .. u8' Fast Menu') then 
						function render_fastmenu_item(name, use, text, text2)
							if imgui.BeginChild('##fastmenu'..name, imgui.ImVec2(194 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
								imgui.CenterText(u8(name))
								imgui.Separator()
								imgui.CenterText(u8("Использование:"))
								imgui.CenterText(use)
								imgui.SetCursorPosY(110 * settings.general.custom_dpi)
								imgui.CenterText(u8("Описание:"))
								imgui.CenterText(u8(text))
								imgui.SetCursorPosY(200 * settings.general.custom_dpi)
								imgui.CenterText(u8("Требуется аргумент:"))
								imgui.CenterText(u8(text2))
								imgui.SetCursorPosY(290 * settings.general.custom_dpi)
								imgui.CenterText(u8("Выборочно вкл/выкл команды"))
								if imgui.Button(fa.GEAR .. u8(' Настроить команды меню ') .. '##' .. name) then
									imgui.OpenPopup(fa.COMPASS .. u8' Настройка команд в ' .. u8(name) .. ' ' .. fa.COMPASS .. "##" .. name)
								end
								imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
								if imgui.BeginPopupModal(fa.COMPASS .. u8' Настройка команд в ' .. u8(name) .. ' ' .. fa.COMPASS .. "##" .. name, _, imgui.WindowFlags.NoResize ) then
									change_dpi()
									if imgui.BeginChild('##fastmenu_configurige'..name, imgui.ImVec2(589 * settings.general.custom_dpi, 366 * settings.general.custom_dpi), true) then
										local arr = {}
										if name == 'FastMenu' then
											arr = modules.commands.data.commands.my
										elseif name == 'Leader FastMenu' then
											arr = modules.commands.data.commands_manage.my
										elseif name == 'PieMenu' then
											
										end
										if name:find('Fast') then
											imgui.Columns(3)
											imgui.CenterColumnText(u8"Нахождение в меню")
											imgui.SetColumnWidth(-1, 160 * settings.general.custom_dpi)
											imgui.NextColumn()
											imgui.CenterColumnText(u8"Команда")
											imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
											imgui.NextColumn()
											imgui.CenterColumnText(u8"Описание")
											imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
											imgui.Columns(1)
											for index, value in ipairs(arr) do
												if (value.arg == "{arg_id}") then
													imgui.Separator()
													imgui.Columns(3)
													local btn = (value.in_fastmenu) and (fa.SQUARE_CHECK .. u8'  (есть)') or (fa.SQUARE .. u8'  (нету)')
													if imgui.CenterColumnSmallButton(btn .. '##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
														value.in_fastmenu = not value.in_fastmenu
														save_module('commands')
													end
													imgui.NextColumn()
													imgui.CenterColumnText('/' .. value.cmd)
													imgui.NextColumn()
													imgui.CenterColumnText(u8(value.description))
													imgui.Columns(1)
												end
											end
											imgui.Separator()
										elseif name == 'PieMenu' then
											imgui.CenterText(u8('PieMenu временно недоступен для редактирования!'))
											imgui.Separator()
											imgui.CenterText(u8('Работоспособность PieMenu (вызов на колёсико): ' .. tostring(settings.general.piemenu)))
											if imgui.CenterButton(settings.general.piemenu and u8('Отключить') or u8('Включить')) then
												settings.general.piemenu = not settings.general.piemenu
												MODULE.FastPieMenu.Window[0] = settings.general.piemenu
												save_settings()
											end
										end
										imgui.EndChild()
									end
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть ' .. fa.CIRCLE_XMARK .. '##close_fast', imgui.ImVec2(591 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
								imgui.EndChild()
							end
						end
						render_fastmenu_item(
							'FastMenu',
							u8'/hm ID или ' .. fa.KEYBOARD .. (isMonetLoader() and u8' Кнопочки' or u8' Hotkeys'),
							'Быстрые RP команды',
							'{arg_id}'
						)
						imgui.SameLine()
						render_fastmenu_item(
							'Leader FastMenu',
							u8'/lm ID или ' .. fa.KEYBOARD .. (isMonetLoader() and u8' Кнопочки' or u8' Hotkeys'),
							'Быстрые RP команды 9-10',
							'{arg_id}'
						)
						imgui.SameLine()
						render_fastmenu_item(
							'PieMenu',
							(isMonetLoader() and (fa.KEYBOARD .. u8' Кнопочки') or (fa.COMPUTER_MOUSE .. u8' СКМ (колёсико)')),
							'Быстрый вызов команд',
							'Без аргумента'
						)
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.KEYBOARD .. (isMonetLoader() and u8' Кнопочки' or u8' Hotkeys')) then 
						if imgui.BeginChild('##999', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
							if isMonetLoader() then
								imgui.CenterText(u8('Наэкранные кнопочки для работы функций хелпера'))
								imgui.Separator()
								if imgui.Checkbox(u8(' Отображение кнопки "Взаимодействие" (аналог /hm ID)'), MODULE.Main.checkbox.mobile_fastmenu_button) then
									settings.general.mobile_fastmenu_button = MODULE.Main.checkbox.mobile_fastmenu_button[0]
									MODULE.FastMenuButton.Window[0] = MODULE.Main.checkbox.mobile_fastmenu_button[0]
									save_settings()
								end
								if imgui.Checkbox(u8(' Отображение кнопки "Остановить" (аналог /stop)'), MODULE.Main.checkbox.mobile_stop_button) then
									settings.general.mobile_stop_button = MODULE.Main.checkbox.mobile_stop_button[0]
									save_settings()
								end
								if isMode('police') or isMode('fbi') then
									if imgui.Checkbox(u8(' Отображение кнопки "10-55 10-66"'), MODULE.Main.checkbox.mobile_meg_button) then
										settings.general.mobile_meg_button = MODULE.Main.checkbox.mobile_meg_button[0]
										MODULE.Megafon.Window[0] = settings.general.mobile_meg_button
										save_settings()
									end
								end
								if isMode('police') or isMode('fbi') or isMode('prison') then
									if imgui.Checkbox(u8(' Отображение кнопки "Taser" (аналог /taser)'), MODULE.Main.checkbox.mobile_taser_button) then
										settings.mj.mobile_taser_button = MODULE.Main.checkbox.mobile_taser_button[0]
										MODULE.Taser.Window[0] = settings.mj.mobile_taser_button
										save_settings()
									end
								end
								imgui.Separator()
								if imgui.CenterButton(u8('[DEBUG] Добавить свою кастомную кнопочку')) then
									sampAddChatMessage('[DEBUG] ВРЕМЕННО НЕДОСТУПНО, БУДЕТ КОГДА-ТО ПОЗЖЕ', -1)
								end
							else
								imgui.CenterText(fa.KEYBOARD .. u8' Главные бинды для работы хелпера (бинды для RP команд в редакторе команд) ' .. fa.KEYBOARD)
								--imgui.CenterText(u8'Бинды RP команд по клавише нужно делать в разделе редактирования RP команды')	
								if hotkey_no_errors then
									imgui.Separator()
									imgui.CenterText(u8'Открытие главного меню хелпера (аналог /helper):')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_mainmenu))
									imgui.SetCursorPosX( width / 2 - calc.x / 2 )
									if MainMenuHotKey:ShowHotKey() then
										settings.general.bind_mainmenu = encodeJson(MainMenuHotKey:GetHotKey())
										save_settings()
									end

									imgui.Separator()
									imgui.CenterText(u8'Открытие быстрого меню взаимодействия с игроком (аналог /hm):')
									imgui.CenterText(u8'Навестись на игрока через ПКМ и нажать')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_fastmenu))
									imgui.SetCursorPosX(width / 2 - calc.x / 2)
									if FastMenuHotKey:ShowHotKey() then
										settings.general.bind_fastmenu = encodeJson(FastMenuHotKey:GetHotKey())
										save_settings()
									end

									imgui.Separator()
									imgui.CenterText(u8'Открытие быстрого меню управления игроком (аналог /lm для 9/10):')
									imgui.CenterText(u8'Навестись на игрока через ПКМ и нажать')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_leader_fastmenu))
									imgui.SetCursorPosX(width / 2 - calc.x / 2)
									if LeaderFastMenuHotKey:ShowHotKey() then
										settings.general.bind_leader_fastmenu = encodeJson(LeaderFastMenuHotKey:GetHotKey())
										save_settings()
									end

									imgui.Separator()
									imgui.CenterText(u8'Выполнить действие (например функции "Хил из чата" / "Розыск по запросу" и т.д.):')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_action))
									imgui.SetCursorPosX(width / 2 - calc.x / 2)
									if ActionHotKey:ShowHotKey() then
										settings.general.bind_action = encodeJson(ActionHotKey:GetHotKey())
										save_settings()
									end

									imgui.Separator()
									imgui.CenterText(u8'Приостановить отыгровку команды (аналог /stop):')
									local width = imgui.GetWindowWidth()
									local calc = imgui.CalcTextSize(getNameKeysFrom(settings.general.bind_command_stop))
									imgui.SetCursorPosX(width / 2 - calc.x / 2)
									if CommandStopHotKey:ShowHotKey() then
										settings.general.bind_command_stop = encodeJson(CommandStopHotKey:GetHotKey())
										save_settings()
									end
									imgui.Separator()
								else
									imgui.Separator()
									imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка: у вас отсуствует библиотека mimgui_hotkeys.lua ' .. fa.TRIANGLE_EXCLAMATION)
								end
							end
							imgui.EndChild()
						end
						imgui.EndTabItem() 
					end
					imgui.EndTabBar() 
				end
				imgui.EndTabItem()
			end
			render_fractions_functions()
			if imgui.BeginTabItem(fa.FILE_PEN..u8' Заметки') then 
			 	imgui.BeginChild('##notes1', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true)
				imgui.Columns(2)
				imgui.CenterColumnText(u8"Список всех ваших заметок/шпаргалок:")
				imgui.SetColumnWidth(-1, 495 * settings.general.custom_dpi)
				imgui.NextColumn()
				imgui.CenterColumnText(u8"Действие")
				imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
				imgui.Columns(1)
				imgui.Separator()
				for i, note in ipairs(modules.notes.data) do
					imgui.Columns(2)
					imgui.CenterColumnText(u8(note.note_name))
					imgui.NextColumn()
					if imgui.SmallButton(fa.UP_RIGHT_FROM_SQUARE .. '##' .. i) then
						MODULE.Note.show_note_name = u8(note.note_name)
						MODULE.Note.show_note_text = u8(note.note_text)
						MODULE.Note.Window[0] = true
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Открыть заметку "' .. u8(note.note_name) .. '"')
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
						local note_text = note.note_text:gsub('&','\n')
						MODULE.Note.input_text = imgui.new.char[1048576](u8(note_text))
						MODULE.Note.input_name = imgui.new.char[256](u8(note.note_name))
						imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8' Редактирование заметки ' .. fa.PEN_TO_SQUARE .. '##' .. i)	
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Редактирование заметки "' .. u8(note.note_name) .. '"')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8' Редактирование заметки ' .. fa.PEN_TO_SQUARE .. '##' .. i, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						change_dpi()
						if imgui.BeginChild('##node_edit_window', imgui.ImVec2(589 * settings.general.custom_dpi, 369 * settings.general.custom_dpi), true) then	
							imgui.PushItemWidth(578 * settings.general.custom_dpi)
							imgui.InputText(u8'##note_name', MODULE.Note.input_name, 6256)
							imgui.InputTextMultiline("##note_text", MODULE.Note.input_text, 1048576, imgui.ImVec2(578 * settings.general.custom_dpi, 329 * settings.general.custom_dpi))
							imgui.EndChild()
						end	
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить заметку ' .. fa.FLOPPY_DISK, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							note.note_name = u8:decode(ffi.string(MODULE.Note.input_name))
							local temp = u8:decode(ffi.string(MODULE.Note.input_text))
							note.note_text = temp:gsub('\n', '&')
							save_module('notes')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.TRASH_CAN .. '##' .. i) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. i .. note.note_name)
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Удаление заметки "' .. u8(note.note_name) .. '"')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. i .. note.note_name, _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Вы действительно хотите удалить заметку "' .. u8(note.note_name) .. '" ?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK .. "##delete_note", imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить ' ..  fa.TRASH_CAN.. "##delete_note", imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							table.remove(modules.notes.data, i)
							save_module('notes')
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()
				end
				imgui.EndChild()
				if imgui.Button(fa.CIRCLE_PLUS .. u8' Создать новую заметку ' .. fa.CIRCLE_PLUS, imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
					if #modules.notes.data > 7 then
						send_no_vip_msg()
						return
					end
					table.insert(modules.notes.data, {note_name = "Новая заметка " .. #modules.notes.data + 1, note_text = "Текст вашей новой заметки"})
					save_module('notes')
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.GEAR..u8' Настройки') then 
				if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 145 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.CIRCLE_INFO .. u8' Дополнительная информация про хелпер ' .. fa.CIRCLE_INFO)
					imgui.Separator()
					imgui.Text(fa.CIRCLE_USER..u8" Разработчик данного хелпера: MTG MODS")
					imgui.Separator()
					imgui.Text(fa.CIRCLE_INFO..u8" Установленная версия хелпера: " .. u8(thisScript().version))
					-- imgui.SameLine()
					-- if imgui.SmallButton(u8'Проверить наличие обновлений') then
					-- 	check_update()
					-- end
					imgui.Separator()
					imgui.Text(fa.BOOK ..u8" Гайд по использованию хелпера:")
					imgui.SameLine()
					if imgui.SmallButton(u8'YouTube') then
						openLink('https://youtu.be/dvTe0A61Hjw')
					end
					imgui.Separator()
					imgui.Text(fa.HEADSET..u8" Тех.поддержка по хелперу:")
					imgui.SameLine()
					if imgui.SmallButton(u8'Discord') then
						openLink('https://discord.gg/qBPEYjfNhv')
					end
					imgui.SameLine()
					imgui.Text('/')
					imgui.SameLine()
					if imgui.SmallButton(u8'Telegram') then
						openLink('https://t.me/mtgmods')
					end
					imgui.SameLine()
					imgui.Text('/')
					imgui.SameLine()
					if imgui.SmallButton(u8'BlastHack') then
						--openLink('https://www.blast.hk/threads/216130/')
					end
					imgui.Separator()
					imgui.Text(fa.GLOBE..u8" Другие скрипты от MTG MODS:")
					imgui.SameLine()
					imgui.Text(u8"Ищите там-же в Discord / Telegram / BlastHack")
					imgui.EndChild()
				end
				if imgui.BeginChild('##2', imgui.ImVec2(589 * settings.general.custom_dpi, 60 * settings.general.custom_dpi), true) then
					imgui.CenterText(fa.PALETTE .. u8(' Цветовая тема интерфейса хелпера ') .. fa.PALETTE)
					imgui.Separator()
					imgui.Columns(3)
					if monet_no_errors then
						imgui.SetCursorPosX(55 * settings.general.custom_dpi)
						function moon_monet_edit()
							local r,g,b = MODULE.Main.mmcolor[0] * 255, MODULE.Main.mmcolor[1] * 255, MODULE.Main.mmcolor[2] * 255
							local argb = join_argb(0, r, g, b)
							settings.general.helper_theme = 0
							settings.general.moonmonet_theme_color = argb
							settings.general.message_color = argb
							message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
							message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
							MODULE.Main.msgcolor[0], MODULE.Main.msgcolor[1], MODULE.Main.msgcolor[2] = color_to_float3(settings.general.message_color)
						end
						if imgui.RadioButtonIntPtr(u8" Custom", MODULE.Main.theme, 0) then
							moon_monet_edit()
							apply_moonmonet_theme()
							save_settings()
						end
						imgui.SameLine()
						if imgui.ColorEdit3('## COLOR1', MODULE.Main.mmcolor, imgui.ColorEditFlags.NoInputs) then
							if MODULE.Main.theme[0] == 0 then
								moon_monet_edit()
								apply_moonmonet_theme()
								save_settings()
							end
						end
					else
						if imgui.CenterColumnRadioButtonIntPtr(u8" Сustom ", MODULE.Main.theme, 0) then
							MODULE.Main.theme[0] = settings.general.helper_theme
							sampAddChatMessage('[Arizona Helper] {ffffff}Установите библиотеку MoonMonet!', message_color)
						end
					end
					imgui.NextColumn()
					if imgui.CenterColumnRadioButtonIntPtr(" Dark Theme ", MODULE.Main.theme, 1) then	
						settings.general.helper_theme = 1
						save_settings()
						apply_dark_theme()
					end
					imgui.NextColumn()
					if imgui.CenterColumnRadioButtonIntPtr(" White Theme ", MODULE.Main.theme, 2) then	
						settings.general.helper_theme = 2
						save_settings()
						apply_white_theme()
					end
					imgui.Columns(1)
					imgui.EndChild()
				end
				if imgui.BeginChild("##2_2",imgui.ImVec2(589 * settings.general.custom_dpi, 53 * settings.general.custom_dpi),true, imgui.WindowFlags.NoScrollbar) then
					imgui.CenterText(fa.PALETTE .. u8(' Цвет сообщений от хелпера в чате ') .. fa.PALETTE)
					if MODULE.Main.theme[0] == 0 then
						imgui.Separator()
						imgui.CenterText(u8('Используется такой-же цвет как в MoonMonet'))
					else
						imgui.SetCursorPosX((imgui.GetWindowWidth() / 2) - (10 * settings.general.custom_dpi))
						if imgui.ColorEdit3('## COLOR2', MODULE.Main.msgcolor, imgui.ColorEditFlags.NoInputs) then
							local r,g,b = MODULE.Main.msgcolor[0] * 255, MODULE.Main.msgcolor[1] * 255, MODULE.Main.msgcolor[2] * 255
							local argb = join_argb(0, r, g, b)
							settings.general.message_color = argb
							settings.general.moonmonet_theme_color = argb
							message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
							message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
							save_settings()
						end
					end
					imgui.EndChild()
				end
				if imgui.BeginChild("##3",imgui.ImVec2(589 * settings.general.custom_dpi, 55 * settings.general.custom_dpi),true) then
					imgui.CenterText(fa.MAXIMIZE .. u8' Размер менюшек скрипта ' .. fa.MAXIMIZE)
					if settings.general.custom_dpi ~= tonumber(string.format('%.3f', MODULE.Main.slider_dpi[0])) then
						imgui.SameLine(0, 15 * settings.general.custom_dpi)
						if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT .. u8' Применить размер ' .. fa.CIRCLE_ARROW_LEFT) then
							imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##change_size')
						end
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##change_size', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Вы действительно хотите изменить размер менюшек?')
						imgui.Separator()
						imgui.CenterText(u8('Если менюшки "плавают" по экрану, подбирайте другой размер'))
						local text = (settings.general.custom_dpi < MODULE.Main.slider_dpi[0]) and 'большой' or 'мелкий'
						imgui.CenterText(u8('Если интерфейс будет слишком ') .. u8(text) .. u8(', то используйте /fixsize'))
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK .. '##change_size', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' Да, изменить ' .. fa.CIRCLE_ARROW_LEFT .. "##change_size", imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							local new_dpi = tonumber(string.format('%.3f', MODULE.Main.slider_dpi[0]))
							if isMonetLoader() and new_dpi < MONET_DPI_SCALE then
								sampAddChatMessage('[Arizona Helper] {ffffff}Для вашего дисплея нельзя сделать размер меньше ' .. MONET_DPI_SCALE, message_color)
								imgui.CloseCurrentPopup()
							else
								settings.general.custom_dpi = new_dpi
								save_settings()
								sampAddChatMessage('[Arizona Helper] {ffffff}Перезагрузка скрипта для пременения размера окон...', message_color)
								reload_script = true
								thisScript():reload()
							end
						end
						imgui.End()
					end
					imgui.PushItemWidth(578 * settings.general.custom_dpi)
					imgui.SliderFloat('##slider_helper_size', MODULE.Main.slider_dpi, 0.5, 3) 
					imgui.EndChild()
				end
				if imgui.BeginChild("##4",imgui.ImVec2(589 * settings.general.custom_dpi, 35 * settings.general.custom_dpi),true) then
					if imgui.Button(fa.POWER_OFF .. u8" Выключение хелпера " .. fa.POWER_OFF, imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						reload_script = true
						sampAddChatMessage('[Arizona Helper] {ffffff}Хелпер приостановил свою работу до следущего входа в игру!', message_color)
						if not isMonetLoader() then 
							sampAddChatMessage('[Arizona Helper] {ffffff}Либо используйте ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}чтобы запустить хелпер.', message_color)
						end
						thisScript():unload()
					end
					imgui.SameLine()
					if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8" Сброс всех настроек " .. fa.CLOCK_ROTATE_LEFT, imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##reset')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##reset', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Вы действительно хотите сбросить все данныые хелпера?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK .. "##cancel_restore", imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8' Да, сбросить ' .. fa.CLOCK_ROTATE_LEFT .. '##restore', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							deleteHelperData()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.TRASH_CAN .. u8" Удаление хелпера " .. fa.TRASH_CAN, imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##delete')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##delete', _, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.CenterText(u8'Вы действительно хотите удалить Arizona Helper?')
						imgui.CenterText(u8'Так-же будут удалены все настройки, команды и заметки хелпера')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK.. '##cancel_delete_helper', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить ' .. fa.TRASH_CAN .. '##delete_helper', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							reload_script = true
							deleteHelperData(true)
						end
						imgui.End()
					end
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
		imgui.EndTabBar() end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.Binder.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8' Редактирование команды /' .. MODULE.Binder.data.change_cmd, MODULE.Binder.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' Описание команды:')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##MODULE.Binder.data.input_description", MODULE.Binder.input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' Команда для использования в чате (без /):')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##MODULE.Binder.input_cmd", MODULE.Binder.input_cmd, 256)
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' Аргументы которые принимает команда:')
	    	imgui.Combo(u8'', MODULE.Binder.ComboTags, MODULE.Binder.ImItems, #MODULE.Binder.item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' Текстовый бинд команды:')
			imgui.InputTextMultiline("##text_multiple", MODULE.Binder.input_text, 8192, imgui.ImVec2(579 * settings.general.custom_dpi, 173 * settings.general.custom_dpi))
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. "##binder_cancel", imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			MODULE.Binder.Window[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' Задержка ' .. fa.CLOCK .. "##binder_wait", imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' Задержка (в секундах) '  .. fa.CLOCK)
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.CLOCK .. u8' Задержка (в секундах) ' .. fa.CLOCK, _, imgui.WindowFlags.NoResize ) then
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderFloat(u8'##waiting', MODULE.Binder.waiting_slider, 0.3, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##binder_wait_menu', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				MODULE.Binder.waiting_slider = imgui.new.float(tonumber(MODULE.Binder.data.change_waiting))
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##binder_wait_menu', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.TAGS .. u8' Теги ' .. fa.TAGS  .. "##binder_tags", imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.TAGS .. u8' Теги для использования в биндере')
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.TAGS .. u8' Теги для использования в биндере', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			imgui.CenterText(u8('СИСТЕМА ТЕГОВ БУДЕТ ИЗМЕНЕНА'))
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.KEYBOARD .. u8' Забиндить ' .. fa.KEYBOARD  .. '##binder_bind', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			if MODULE.Binder.ComboTags[0] == 0 then
				if isMonetLoader() then
					sampAddChatMessage('[Arizona Helper] {ffffff}Данная функция доступа только на ПК!', message_color)
				else
					if hotkey_no_errors then
						imgui.OpenPopup(fa.KEYBOARD .. u8' Бинд для команды /' .. MODULE.Binder.data.change_cmd)
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Данная функция недоступна, отсуствуют файлы библиотеки mimgui_hotkeys!', message_color)
					end
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Данная функция доступа только если команда "Без аргументов"', message_color)
			end
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.KEYBOARD .. u8' Бинд для команды /' .. MODULE.Binder.data.change_cmd, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			local hotkeyObject = hotkeys[MODULE.Binder.data.change_cmd .. "HotKey"]
			if hotkeyObject then
				imgui.CenterText(u8('Клавиша активации бинда:'))
				local calc
				if MODULE.Binder.data.change_bind == '{}' or MODULE.Binder.data.change_bind == '[]' then
					calc = imgui.CalcTextSize('< click and select keys >')
				elseif MODULE.Binder.data.change_bind == nil then
					MODULE.Binder.data.change_bind = {}
				else
					calc = imgui.CalcTextSize(getNameKeysFrom(MODULE.Binder.data.change_bind))
				end
				local width = imgui.GetWindowWidth()
				local temp = (calc and calc.x and calc.x / 2) or 0
				imgui.SetCursorPosX(width / 2 - temp)
				if hotkeyObject:ShowHotKey() then
					MODULE.Binder.data.change_bind = encodeJson(hotkeyObject:GetHotKey())
				end
			else
				if not MODULE.Binder.data.change_bind then
				 	MODULE.Binder.data.change_bind = {}
				end
				
				hotkeys[MODULE.Binder.data.change_cmd .. "HotKey"] = hotkey.RegisterHotKey(MODULE.Binder.data.change_cmd .. "HotKey", false, decodeJson(MODULE.Binder.data.change_bind), function()
					if (not (sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive())) then
						sampProcessChatInput('/' .. MODULE.Binder.data.change_cmd)
					end
				end)
				hotkeyObject = hotkeys[MODULE.Binder.data.change_cmd .. "HotKey"]
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть ' .. fa.CIRCLE_XMARK .. "##binder_bind_close", imgui.ImVec2(300 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				hotkeyObject:RemoveHotKey()
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##binder_save', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then	
			if ffi.string(MODULE.Binder.input_cmd):find('%W') or ffi.string(MODULE.Binder.input_cmd) == '' or ffi.string(MODULE.Binder.input_description) == '' or ffi.string(MODULE.Binder.input_text) == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды ' .. fa.TRIANGLE_EXCLAMATION)
			else
				local new_arg = ''
				if MODULE.Binder.ComboTags[0] == 0 then
					new_arg = ''
				elseif MODULE.Binder.ComboTags[0] == 1 then
					new_arg = '{arg}'
				elseif MODULE.Binder.ComboTags[0] == 2 then
					new_arg = '{arg_id}'
				elseif MODULE.Binder.ComboTags[0] == 3 then
					new_arg = '{arg_id} {arg2}'
                elseif MODULE.Binder.ComboTags[0] == 4 then
					new_arg = '{arg_id} {arg2} {arg3}'
				elseif MODULE.Binder.ComboTags[0] == 5 then
					new_arg = '{arg_id} {arg2} {arg3} {arg4}'
				end
				local new_command = u8:decode(ffi.string(MODULE.Binder.input_cmd))
				local temp_array = (MODULE.Binder.data.create_command_9_10) and modules.commands.data.commands_manage.my or modules.commands.data.commands.my
				for _, command in ipairs(temp_array) do
					if command.cmd == MODULE.Binder.data.change_cmd and command.arg == MODULE.Binder.data.change_arg and command.text:gsub('&', '\n') == MODULE.Binder.data.change_text then
						command.cmd = new_command
						command.arg = new_arg
						command.description = u8:decode(ffi.string(MODULE.Binder.input_description))
						command.text = u8:decode(ffi.string(MODULE.Binder.input_text)):gsub('\n', '&')
						command.bind = MODULE.Binder.data.change_bind
						command.waiting = MODULE.Binder.waiting_slider[0]
						command.in_fastmenu = MODULE.Binder.data.change_in_fastmenu
						command.enable = true
						save_module('commands')
						if command.arg == '' then
							sampAddChatMessage('[Arizona Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg}' then
							sampAddChatMessage('[Arizona Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [аргумент] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id}' then
							sampAddChatMessage('[Arizona Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id} {arg2}' then
							sampAddChatMessage('[Arizona Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [аргумент] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3}' then
							sampAddChatMessage('[Arizona Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [число] [аргумент] {ffffff}успешно сохранена!', message_color)
						elseif command.arg == '{arg_id} {arg2} {arg3} {arg4}' then
							sampAddChatMessage('[Arizona Helper] {ffffff}Команда ' .. message_color_hex .. '/' .. new_command .. ' [ID игрока] [число] [аргумент] [аргумент] {ffffff}успешно сохранена!', message_color)
						end
						sampUnregisterChatCommand(MODULE.Binder.data.change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						if not isMonetLoader() then createHotkeyForCommand(command) end
						break
					end
				end
				MODULE.Binder.Window[0] = false
			end
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды ' .. fa.TRIANGLE_EXCLAMATION, _, imgui.WindowFlags.AlwaysAutoResize) then
			if ffi.string(MODULE.Binder.input_cmd):find('%W') then
				imgui.BulletText(u8" В команде можно использовать только англ.буквы и/или цифры!")
			elseif ffi.string(MODULE.Binder.input_cmd) == '' then
				imgui.BulletText(u8" Текстовый бинд команды не может быть пустой!")
			end
			if ffi.string(MODULE.Binder.input_description) == '' then
				imgui.BulletText(u8" Описание команды не может быть пустое!")
			end
			if ffi.string(MODULE.Binder.input_text) == '' then
				imgui.BulletText(u8" Бинд команды не может быть пустой!")
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть ' .. fa.CIRCLE_XMARK .. '##binder_error_save_close', imgui.ImVec2(350 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end	
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.Note.Window[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(400 * settings.general.custom_dpi, 300 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.FILE_PEN .. ' '.. MODULE.Note.show_note_name .. ' ' .. fa.FILE_PEN, MODULE.Note.Window)
        change_dpi()
		for line in MODULE.Note.show_note_text:gsub("&", "\n"):gmatch("[^\r\n]+") do -- by Milky
			imgui.TextUnformatted(line) 
		end
        imgui.End()
    end
)
------------------------------------------ FRACTION GUI -------------------------------------------
function render_fractions_functions()
	local function render_assist_item(name, description, tbl, key, isVip, func)
		imgui.Separator()
		imgui.Columns(3)
		imgui.CenterColumnText(u8(name))
		imgui.NextColumn()
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.CIRCLE_INFO .. ' ' .. u8(name) .. ' ' .. fa.CIRCLE_INFO, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			change_dpi()
			imgui.TextWrapped(u8(description))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(500 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.EndPopup()
		end
		if imgui.CenterColumnSmallButton(u8('Посмотреть##' .. name .. key)) then
			imgui.OpenPopup(fa.CIRCLE_INFO .. ' ' .. u8(name) .. ' ' .. fa.CIRCLE_INFO)
		end
		imgui.NextColumn()
		if imgui.CenterColumnSmallButton(u8((tbl and tbl[key] and 'Отключить' or 'Включить') .. '##' .. name .. key)) then
			if (isVip) then 
				send_no_vip_msg()
			else
				tbl[key] = not tbl[key]
				save_settings()
			end
		end
		if func and tbl and tbl[key] then
			imgui.SameLine()
			if imgui.SmallButton(fa.GEAR .. '##' .. key) then
				func()
			end
		end
		imgui.Columns(1)
	end
	local function firs_render_assist_gui()
		imgui.Columns(3)
		imgui.CenterColumnText(u8("Название функции"))
		imgui.SetColumnWidth(-1, 270 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8("Описание функции"))
		imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.CenterColumnText(u8("Управление"))
		imgui.SetColumnWidth(-1, 170 * settings.general.custom_dpi)
		imgui.NextColumn()
		imgui.Columns(1)
		render_assist_item(
			"RP общение в чатах",
			"Ваши сообщения в чат будут отправляться с заглавной буквы и точкой в конце.\nТак-же работает и в таких чатах как: /s /do /f /fb /r /rb /j /jb /fam /al",
			settings.player_info,
			"rp_chat"
		)
		render_assist_item(
			"RP отыгровка оружия",
			"При использовании или скролле оружия, в чате будут RP отыгровки.\nНастроить можно через команду /rpguns или кнопкой шестеренки справа.",
			settings.general,
			"rp_guns",
			false,
			function()
				MODULE.RPWeapon.Window[0] = true
			end
		)
		if isMode('police') or isMode('fbi') or settings.player_info.fraction_rank_number >= 9 then 
			render_assist_item(
				"RP проверка документов",
				"Автоматически принимает документы из /offer\nТак-же через RP отыгровку проверяет их, затем возвращает.",
				settings.general,
				"auto_accept_docs",
				true
			)
		end
		render_assist_item(
			"Автоматическая маска",
			"Если ваша маска слетает, сразу же автоматически надевает новую\nВаш цветной клист даже не успеет появиться на карте",
			settings.general,
			"auto_mask",
			true
		)
		render_assist_item(
			"Авто-обновление меню /mb",
			"Автоматически обновляет список сотрудников каждые 3 секунды.",
			settings.mj,
			"auto_update_members",
			true
		)
		render_assist_item(
			"Авто-доклад на посту",
			"Автоматически отправляет доклад в рацию каждые 5 минут на посту.",
			settings.general,
			"auto_doklad_post",
			true
		)
		if settings.player_info.fraction_rank_number >= 9 then
			render_assist_item(
				"Автотический увал ПСЖ [9/10]",
				"Автоматическое увольнение сотрудников, которые просят увал ПСЖ в /r /rb /f /fb\nПример ситуации как это работает:\n1) Игрок пишет в /r Увольте меня по псж\n2) Cкрипт отвечает: /rb Nick_Name, отправьте /rb +++ чтобы уволиться ПСЖ!\n3) Игрок отправляет /rb +++ и скрипт его увольняет по ПСЖ\n\nP.S. Если игрок флудит просьбами об увале, скрипт САМ его уволит, без +++\nP.S.S. Данная функция работает только если вы одеты в рабочую форму.",
				settings.general,
				"перезалил"
			)
			-- render_assist_item(
			-- 	"Автоматический инвайт [9/10]",
			-- 	'Автоматически инвайтит игроков, которые просят инвайт в чате.\nЕсли у игрока варн, или нету жилья/законки, ответит в чат.',
			-- 	settings.general,
			-- 	"auto_invite",
			-- 	true
			-- )
		end
	end
	local fraction = settings.player_info.fraction_tag:sub(1, 5)
	if isMode('smi') then fraction = 'СМИ' end

	if imgui.BeginTabItem(fa.GEARS .. u8' Функции ' .. u8(fraction)) then
		if isMode('police') or isMode('fbi') then 
			if imgui.BeginTabBar('FractinFunctions') then
				if imgui.BeginTabItem(fa.ROBOT .. u8' Личный помочник "Ассистент"') then 
					if imgui.BeginChild('##mj_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						firs_render_assist_gui()
						render_assist_item(
							"Кликер на ГРП",
							"Автокликер в менюшках на серверных ГРП (завалы, хил, носилки).",
							settings.mj,
							"auto_clicker_situation",
							true
						)
						render_assist_item(
							"Авто-доклад в патруле",
							"Автоматически отправляет доклад в рацию каждые 5 минут патруля.",
							settings.mj,
							"auto_doklad_patrool",
							true
						)
						render_assist_item(
							"Смена CODE 3/4 от мигалок",
							"Автоматически меняет ситуационный код при управлении мигалками.",
							settings.mj,
							"auto_change_code_siren"
						)
						render_assist_item(
							"Авто-доклад CODE 0",
							"При получении урона автоматически отправляет доклад CODE 0 с указанием ника нападавшего.",
							settings.mj,
							"auto_doklad_damage"
						)
						render_assist_item(
							"Авто-доклад после ареста",
							"После завершения ареста автоматически отправляет доклад в рацию с именем арестованного.",
							settings.mj,
							"auto_doklad_arrest",
							true
						)
						render_assist_item(
							"/time на обыск/розыск/арест",
							"Автоматически делает /time для скриншотов при важных действиях.",
							settings.mj,
							"auto_time",
							true
						)
						render_assist_item(
							"Авто-заполнение расследований",
							"Автоматически заполняет все необходимые данные в диалогах расследования убийств.",
							settings.mj,
							"auto_documentation",
							true
						)
						render_assist_item(
							"Авто-обновление /wanteds",
							"Автоматически обновляет список преступников каждые 10 секунд.",
							settings.mj,
							"auto_update_wanteds",
							true
						)
						render_assist_item(
							"Оповещение про преступников",
							"Оповещает вас, если преступник появляется в зоне прорисовки.",
							settings.mj,
							"awanted",
							true
						)
						imgui.Separator()
						imgui.EndChild()
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.STAR .. u8' Система умного розыска') then 
					renderSmartGUI(
						'Система умного розыска',
						fa.STAR,
						'https://mtgmods.github.io/arizona-helper/SmartUK/' .. getServerNumber() .. '/SmartUK.json', 
						'системы умного розыска', 
						modules.smart_uk.data, 
						function() save_module("smart_uk") end, 
						'Использование: /sum [ID игрока]', 
						modules.smart_uk.path,
						'smart_uk',
						'умный розыск'
					)
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.TICKET .. u8' Система умных штрафов') then 
					renderSmartGUI(
						'Система умных штрафов', 
						fa.TICKET, 
						'https://mtgmods.github.io/arizona-helper/SmartPDD/' .. getServerNumber() .. '/SmartPDD.json', 
						'системы умных штрафов', 
						modules.smart_pdd.data, 
						function() save_module("smart_pdd") end, 
						'Использование: /tsm [ID игрока]', 
						modules.smart_pdd.path,
						'smart_pdd',
						'умные штрафы'
					)
					imgui.EndTabItem()
				end
				imgui.EndTabBar() 
			end
		elseif isMode('army') then
			if imgui.BeginChild('##army_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
				firs_render_assist_gui()
				imgui.Separator()
				imgui.EndChild()
			end
		elseif isMode('prison') then
			if imgui.BeginTabBar('FractinFunctions') then
				if imgui.BeginTabItem(fa.ROBOT .. u8' Личный помочник "Ассистент"') then 
					if imgui.BeginChild('##assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						firs_render_assist_gui()
						imgui.Separator()
						imgui.EndChild()	
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.STAR .. u8' Система умного продления срока') then 
					renderSmartGUI(
						'Система умного продления срока', 
						fa.TICKET, 
						'https://mtgmods.github.io/arizona-helper/SmartRPTP/' .. getServerNumber() .. '/SmartRPTP.json', 
						'системы умного срока', 
						modules.smart_rptp.data, 
						function() save_module("smart_rptp") end, 
						'Использование: /pum [ID игрока]', 
						modules.smart_rptp.path,
						'smart_rptp',
						'умный срок'
					)
					imgui.EndTabItem()
				end
				imgui.EndTabBar() 
			end
		elseif isMode('smi') then
			if imgui.BeginTabBar('FractinFunctions') then
				if imgui.BeginTabItem(fa.ROBOT .. u8' Личный помочник "Ассистент"') then 
					if imgui.BeginChild('##smi_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then	
						firs_render_assist_gui()
						render_assist_item(
							"Копирка обьяв коллег",
							"Сохрание в историю обьяв, которые отредактировали ваши коллеги.\nТаким образом, у вас будет возможность быстрой отправки такого обьявления",
							settings.smi,
							"steal_other_ads"
						)
						render_assist_item(
							"Авто-редакт (из истории)",
							"Скрипт запоминает объявления игроков, которые вы редактируете.\nЭта функция автоматически отправит сохранённую объяву от того же игрока.\n\nВНИМАНИЕ!\nФункция может быть запрещена на некоторых серверах. Уточняйте в /report.",
							settings.smi,
							"auto_send_old"
						)
						render_assist_item(
							"Авто-ловля объявлений",
							"При поступлении нового объявления автоматически прописывает /newsredak вместо вас.\n\nВНИМАНИЕ!\nФункция может быть запрещена на некоторых серверах. Уточняйте в /report.",
							settings.smi,
							"auto_lovlya_ads"
						)
						imgui.Separator()
						imgui.EndChild()
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.CLOCK_ROTATE_LEFT .. u8' Управление историей обьявявлений') then
					if imgui.BeginChild('##ads_history_menu', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						if #modules.ads_history.data == 0 then
							imgui.CenterText(u8('История обьявлений пуста'))
							imgui.CenterText(u8('Отредактированные обьявления будут отображаться здесь'))
						else
							imgui.PushItemWidth(580 * settings.general.custom_dpi)
							imgui.InputTextWithHint(u8'##input_ads_search', u8'Поиск обьявлений по нужной фразе, начинайте вводить её сюда...', MODULE.SmiEdit.input_ads_search, 128)
							imgui.Separator()
							imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
							if imgui.BeginPopupModal(fa.CLOCK_ROTATE_LEFT .. u8' Обьявление из истории отредаченных обьяв', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
								change_dpi()
								imgui.CenterText(u8(MODULE.SmiEdit.adshistory_orig))
								imgui.PushItemWidth(500 * settings.general.custom_dpi)
								imgui.InputTextWithHint(u8'##input_ads_my_edit', u8'Введите ваш вариант редакции данного обьяаления...', MODULE.SmiEdit.adshistory_input_text, 128)
								imgui.Separator()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
									imgui.CloseCurrentPopup()
								end
								
								imgui.SameLine()
								if imgui.Button(fa.TRASH_CAN .. u8' Удалить', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
									for id, ad in ipairs(modules.ads_history.data) do
										if ad.text == MODULE.SmiEdit.adshistory_orig then
											table.remove(modules.ads_history.data, id)
											save_module('ads_history')
											sampAddChatMessage("[Arizona Helper] {ffffff}Обьявление из истории успешно удалено!", message_color)
											break
										end
									end
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.CIRCLE_XMARK .. u8' Сохранить', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
									for id, ad in ipairs(modules.ads_history.data) do
										if ad.text == MODULE.SmiEdit.adshistory_orig then
											ad.my_text = u8:decode(ffi.string(MODULE.SmiEdit.adshistory_input_text))
											save_module('ads_history')
											sampAddChatMessage("[Arizona Helper] {ffffff}Обьявление из истории успешно изменено и сохранено!", message_color)
											break
										end
									end
									imgui.CloseCurrentPopup()
								end
								imgui.EndPopup()
							end
							local input_ads_decoded = u8:decode(ffi.string(MODULE.SmiEdit.input_ads_search))
							for id, ad in ipairs(modules.ads_history.data) do
								if input_ads_decoded == '' or ad.my_text:rupper():find(input_ads_decoded:rupper()) then
									if imgui.Button(u8(ad.my_text .. '##' .. id), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
										MODULE.SmiEdit.adshistory_orig = ad.text
										imgui.StrCopy(MODULE.SmiEdit.adshistory_input_text, u8(ad.my_text))
										imgui.OpenPopup(fa.CLOCK_ROTATE_LEFT .. u8' Обьявление из истории отредаченных обьяв')
									end
								end
							end
						end
						imgui.EndChild()
					end
					imgui.EndTabItem()
				end
				imgui.EndTabBar() 
			end
		elseif isMode('hospital') then
			if imgui.BeginTabBar('FractinFunctions') then
				if imgui.BeginTabItem(fa.ROBOT .. u8' Личный помочник "Ассистент"') then 
					if imgui.BeginChild('##hospital_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						firs_render_assist_gui()

						render_assist_item(
							"Хил из чата",
							"Позволяет быстро лечить пациентов которые просят хил.\nЕсть два режима работы хила из чата:\n1) По нажатию кнопки\n2) Автоматический\nДля смены режима используйте кнопочку шестерёнки справа\n\nПо дефолту работает режим по нажатию кнопки.",
							settings.mh.heal_in_chat,
							"enable",
							false,
							function() send_no_vip_msg() end
						)
	
						render_assist_item(
							"Кликер на ГРП",
							"Автокликер в менюшках на серверных ГРП (завалы, хил, носилки).",
							settings.general,
							"auto_clicker_situation",
							true
						)
						imgui.Separator()
						imgui.EndChild()	
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.SACK_DOLLAR .. u8' Ценовая политика больницы') then 
					if imgui.BeginChild('##hospital_price', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						local med_price_fields = {
							{label = '  Лечение игрока (SA $)',              key = 'heal', same_line = true},
							{label = '  Лечение игрока (VC $)',              key = 'heal_vc'},
							{label = '  Лечение охранника (SA $)',           key = 'healactor', same_line = true},
							{label = '  Лечение охранника (VC $)',           key = 'healactor_vc'},
							{label = '  Проведение мед. осмотра для пилотов', key = 'medosm'},
							{label = '  Проведение мед. осмотра для военного билета', key = 'mticket'},
							{label = '  Проведение сеанса лечения наркозависимости', key = 'healbad'},
							{label = '  Выдача рецепта',                     key = 'recept'},
							{label = '  Выдача антибиотика',                 key = 'ant'},
							{label = '  Выдача мед.карты на 7 дней',         key = 'med7', same_line = true},
							{label = '  Выдача мед.карты на 14 дней',        key = 'med14'},
							{label = '  Выдача мед.карты на 30 дней',        key = 'med30', same_line = true},
							{label = '  Выдача мед.карты на 60 дней',        key = 'med60'},
						}
						for i, field in ipairs(med_price_fields) do
							imgui.PushItemWidth(65 * settings.general.custom_dpi)
							local buf = MODULE.MedicalPrice[field.key]
							if imgui.InputText(u8(field.label), buf, 8) then
								local str = u8:decode(ffi.string(buf)):gsub("%D", "")
								local num = tonumber(str)
								if num then
									settings.mh.price[field.key] = num
									save_settings()
								end
							end
							if field.same_line then 
								imgui.SameLine()
								imgui.SetCursorPosX((320 * settings.general.custom_dpi))
							else 
								imgui.Separator() 
							end
						end
						imgui.EndChild()
					end
					imgui.EndTabItem()
				end
				imgui.EndTabBar() 
			end
		elseif isMode('lc') then
			if imgui.BeginTabBar('FractinFunctions') then
				if imgui.BeginTabItem(fa.ROBOT .. u8' Личный помочник "Ассистент"') then 
					if imgui.BeginChild('##assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						firs_render_assist_gui()
						
						render_assist_item(
							"Ближайший дорожный знак",
							"Автоматически определяет и выбирает ближайший дорожный знак для обслуживания.",
							settings.lc,
							"auto_find_clorest_repair_znak"
						)

						render_assist_item(
							"Кликер на ремонт знаков",
							"Автокликер в менюшке ремонта дорожного знака",
							settings.lc,
							"auto_repair_znak"
						)
						render_assist_item(
							"Кликер на установку знака",
							"Автокликер в менюшке установки дорожного знака",
							settings.lc,
							"auto_install_znak"
						)
						
						render_assist_item(
							"Авто-выдача лицензий",
							"Автоматечески выдаёт лицензии игрокам пока вы стоите за стойкой.\nИгроки должны написать в чат тип лицензии (частоиспользуемые фразы) и срок.\nЕсли срок не написан, например просто \"права\", то автовыдача выдаст на 3 месяца.\n\nЕсть два режима работы авто-выдачи лицензий:\n1) Без RP отыгровок\nИспользуя RP отыгровку\nДля смены режима используйте кнопочку шестерёнки справа",
							settings.lc.auto_lic,
							"enable",
							true,
							function()
								settings.lc.auto_lic.use_rp = not settings.lc.auto_lic.use_rp
								save_settings()
								if settings.lc.auto_lic.use_rp then
									sampAddChatMessage('[Arizona Helper | Ассистент] {ffffff}Режим с RP отыгровкой. Для смены режима нажмите ещё раз!', message_color)
								else
									sampAddChatMessage('[Arizona Helper | Ассистент] {ffffff}Режим без RP отыгровок. Для смены режима нажмите ещё раз!', message_color)
								end
							end
						)

						imgui.Separator()
						imgui.EndChild()	
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.SACK_DOLLAR .. u8' Ценовая политика лицензий') then 
					if imgui.BeginChild('##license_price', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						local license_types = {
							{name = 'Авто', key = 'avto'},
							{name = 'Мото', key = 'moto'},
							{name = 'Лодки', key = 'swim'},
							{name = 'Полеты', key = 'fly'},
							{name = 'Оружие', key = 'gun'},
							{name = 'Рыбалка', key = 'fish'},
							{name = 'Охота', key = 'hunt'},
							{name = 'Раскопки', key = 'klad'},
							{name = 'Такси', key = 'taxi'},
							{name = 'Механик', key = 'mexa'},
						}
						for i, license in ipairs(license_types) do
							for month = 1, 3 do
								local month_label = (month == 1) and " %s (месяц)" or string.format(" %%s (%d месяца)", month)
								local label = string.format(month_label, license.name)
								local key = license.key .. month
								local buf = MODULE.LicensePrice[key]
								imgui.PushItemWidth(65 * settings.general.custom_dpi)
								if imgui.InputText(u8(label), buf, 9) then
									local str = u8:decode(ffi.string(buf))
									str = str:gsub("%D","")
									local num = tonumber(str)
									if num then
										settings.lc.price[key] = num
										save_settings()
									end
								end
								if month == 1 then
									imgui.SameLine()
									imgui.SetCursorPosX(195 * settings.general.custom_dpi)
								elseif month == 2 then
									imgui.SameLine()
									imgui.SetCursorPosX(395 * settings.general.custom_dpi)
								elseif i ~= #license_types then
									imgui.Separator()
								end
							end
						end
						imgui.EndChild()
					end
					imgui.EndTabItem()
				end
				imgui.EndTabBar() 
			end
		elseif isMode('gov') then
			if imgui.BeginChild('##gov_assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
				firs_render_assist_gui()
				render_assist_item(
					"Анти Тревожная Кнопка",
					"Убирает тревожную кнопку которая находится на 2 этаже.\nТем самым вы не будете случайно вызывать МЮ из-за этой кнопки.",
					settings.gov,
					"anti_trivoga"
				)	
				imgui.Separator()
				imgui.EndChild()
			end
		else
			if imgui.BeginChild('##assist', imgui.ImVec2(589 * settings.general.custom_dpi, 367 * settings.general.custom_dpi), true) then
				firs_render_assist_gui()
				imgui.Separator()
				imgui.CenterText(u8('Ваша фракция временно не поддерживаеться!'))
				imgui.TextWrapped(u8(configDirectory .. "/Settings.json"))
				imgui.EndChild()
			end
		end
		imgui.EndTabItem()
	end
end
if (not isMode('none')) then
	imgui.OnFrame(
		function() return MODULE.Members.Window[0] end,
		function(player)
			if #MODULE.Members.all == 0 then
				sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка, список сотрудников пустой!', message_color)
				MODULE.Members.Window[0] = false
			elseif #MODULE.Members.all >= 16 then 
				sizeYY = 413 + 21
			else
				sizeYY = 24.5 * (#MODULE.Members.all + 1) + 21
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(730 * settings.general.custom_dpi, sizeYY * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(getHelperIcon() .. " " ..  u8(MODULE.Members.info.fraction) .. " - " .. #MODULE.Members.all .. u8' сотрудников онлайн ' .. getHelperIcon(), MODULE.Members.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			imgui.Columns(4)
			imgui.CenterColumnText(getUserIcon() .. u8(" Cотрудник"))
			imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(fa.RANKING_STAR .. u8(" Должность"))
			imgui.SetColumnWidth(-1, 230 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(fa.TRIANGLE_EXCLAMATION .. u8(" Выговоры"))
			imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(fa.INFO .. u8(" Инфо"))
			imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
			imgui.Columns(1)
			for i, v in ipairs(MODULE.Members.all) do
				imgui.Separator()
				imgui.Columns(4)
				if v.working then
					imgui_RGBA = (settings.general.helper_theme ~= 2) and imgui.ImVec4(1, 1, 1, 1) or imgui.ImVec4(0, 0, 0, 1)
				else
					imgui_RGBA = imgui.ImVec4(1, 0.231, 0.231, 1)
				end
				local text = u8(v.nick) .. ' [' .. v.id .. ']'
				if tonumber(v.afk) then
					local afk = tonumber(v.afk)
					if afk > 0 then
						if afk < 60 then
							text = text .. ' [AFK ' .. afk .. 's]'
						else
							text = text .. ' [AFK ' .. math.floor(afk / 60) .. 'm]'
						end
					end
				end
				imgui.CenterColumnColorText(imgui_RGBA, text)
				if (imgui.IsItemClicked() and settings.player_info.fraction_rank_number >= 9) then 
					show_leader_fast_menu(v.id)
					MODULE.Members.Window[0] = false
				end
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.rank) .. ' (' .. u8(v.rank_number) .. ')')
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.warns .. '/3'))
				imgui.NextColumn()
				if v.info == '-' then
					imgui.CenterColumnText(u8(v.info))
				else
					imgui_RGBA = imgui.ImVec4(1, 0.231, 0.231, 1)
					imgui.CenterColumnColorText(imgui_RGBA, u8(v.info))
				end
				imgui.Columns(1)
			end
			imgui.End()
		end
	)
end
if not (isMode('ghetto') or isMode('mafia')) then
	imgui.OnFrame(
		function() return MODULE.Sobes.Window[0] end,
		function(player)
			if player_id ~= nil and isParamSampID(player_id) then
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
				imgui.Begin(fa.PERSON_CIRCLE_CHECK..u8' Проведение собеседования игроку ' .. u8(sampGetPlayerNickname(player_id)) .. ' ' .. fa.PERSON_CIRCLE_CHECK, MODULE.Sobes.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
				change_dpi()
				if imgui.BeginChild('sobes1', imgui.ImVec2(240 * settings.general.custom_dpi, 180 * settings.general.custom_dpi), true) then
					imgui.CenterColumnText(fa.BOOKMARK .. u8" Основное " .. fa.BOOKMARK)
					imgui.Separator()
					if imgui.Button(fa.PLAY .. u8" Начать собеседование", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						lua_thread.create(function()
							sampSendChat("Здравствуйте, я " .. settings.player_info.name_surname .. " - " .. settings.player_info.fraction_rank .. ' ' .. settings.player_info.fraction_tag)
							wait(1500)
							sampSendChat("Вы пришли к нам на собеседование?")
						end)
					end
					if imgui.Button(fa.PASSPORT .. u8" Попросить документы", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						lua_thread.create(function()
							sampSendChat("Хорошо, предоставьте мне все ваши документы для проверки.")
							wait(1500)
							sampSendChat("Мне нужен ваш Паспорт, Мед.карта и Лицензии.")
							wait(1500)
							sampSendChat("/n " .. sampGetPlayerNickname(player_id) .. ", используйте /showpass")
							wait(1500)
							sampSendChat("/n Обязательно с RP отыгровками!")
						end)
					end
					if imgui.Button(fa.USER .. u8" Расскажите о себе", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Немного расскажите о себе.")
					end		
					if imgui.Button(fa.CHECK .. u8" Собеседование пройдено", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("/todo Поздравляю! Вы успешно прошли собеседование!*улыбаясь")
					end
					if imgui.Button(fa.USER_PLUS .. u8" Пригласить в организацию", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						find_and_use_command('/invite {arg_id}', player_id)
						MODULE.Sobes.Window[0] = false
					end
					imgui.EndChild()
				end
				imgui.SameLine()
				if imgui.BeginChild('sobes2', imgui.ImVec2(240 * settings.general.custom_dpi, 180 * settings.general.custom_dpi), true) then
					imgui.CenterColumnText(fa.BOOKMARK..u8" Дополнительно " .. fa.BOOKMARK)
					imgui.Separator()
					if imgui.Button(fa.GLOBE .. u8" Наличие спец.рации Discord", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Имеется ли у Вас спец. рация Discord?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" Наличие опыта работы", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Имеется ли у Вас опыт работы в нашей сфере?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" Почему именно мы?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Скажите почему Вы выбрали именно нас?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" Что такое адекватность?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Скажите что по вашему значит \"Адекватность\"?")
					end
					if imgui.Button(fa.CIRCLE_QUESTION .. u8" Что такое ДМ?", imgui.ImVec2(-1, 25 * settings.general.custom_dpi)) then
						sampSendChat("Скажите как вы думаете, что такое \"ДМ\"?")
					end
				imgui.EndChild()
				end
				imgui.SameLine()
				if imgui.BeginChild('sobes3', imgui.ImVec2(150 * settings.general.custom_dpi, -1), true, imgui.WindowFlags.NoScrollbar) then
					imgui.CenterColumnText(fa.CIRCLE_XMARK .. u8" Отказы " .. fa.CIRCLE_XMARK)
					imgui.Separator()
					local function otkaz(reason)
						lua_thread.create(function()
							MODULE.Sobes.Window[0] = false
							sampSendChat("/todo К сожалению, вы нам не подходите*с разочарованием на лице")
							wait(1500)
							sampSendChat(reason)
						end)
					end
					if imgui.Selectable(u8"Законопослушность") then
						otkaz("У вас плохая законопослушность.")
					end
					if imgui.Selectable(u8"Наркозависимость") then
						otkaz("Вам необходимо вылечиться в любой больнице, в отделе наркологии!")
					end
					if imgui.Selectable(u8"Активная повестка") then
						otkaz("У вас повестка, отслужите либо пройдите обследования в больнице.")
					end
					if imgui.Selectable(u8"Нету мед.карты") then
						otkaz("У вас нету мед.карты, получите её в любой больнице.")
					end
					if imgui.Selectable(u8"Нету военного билета") then
						otkaz("У вас нету военного билета!")
					end
					if imgui.Selectable(u8"Нету жилья") then
						otkaz("У вас нету жилья! Найдите себе дом/отель/трейлер.")
					end
					if imgui.Selectable(u8"Состоит в ЧС") then
						otkaz("Вы состоите в Чёрном Списке нашей организации!")
					end
					if imgui.Selectable(u8"Проф.непригодность") then
						otkaz("Вы не подходите для нашей работы по профессиональным качествам.")
					end
				end
				imgui.EndChild()
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Прозиошла ошибка, ID игрока недействителен!', message_color)
				MODULE.Sobes.Window[0] = false
			end
		end
	)
	imgui.OnFrame(
		function() return MODULE.Departament.Window[0] end,
		function(player)
			local function createTagPopup(tag_type, input_var, setting_key)
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
				if imgui.BeginPopupModal(fa.TAG .. u8' Теги организаций##'..tag_type, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
					change_dpi()
					if imgui.BeginTabBar('TabTags') then
						local function createTagTab(title, tags)
							if imgui.BeginTabItem(fa.BARS..u8' '..title..' ') then 
								local line_started = false
								for i, tag in ipairs(tags) do
									if tag ~= 'skip' then
										if line_started then
											imgui.SameLine()
										else
											line_started = true
										end
										if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
											imgui.StrCopy(input_var, u8(tag))
											imgui.CloseCurrentPopup()
										end
									else
										line_started = false
									end
								end
								imgui.Separator()
								if title:find(u8'кастом') then
									imgui.Separator()
									if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить тег ' .. fa.CIRCLE_PLUS, imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
										imgui.OpenPopup(fa.TAG .. u8' Добавление нового тега ' .. fa.TAG .. '##'..tag_type)
									end
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(fa.TAG .. u8' Добавление нового тега ' .. fa.TAG .. '##'..tag_type, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
										imgui.CenterText(u8('Если нужен переход на следущую'))
										imgui.CenterText(u8('строку, вместо тега укажите skip'))
										imgui.PushItemWidth(215 * settings.general.custom_dpi)
										imgui.InputText('##MODULE.Departament.new_tag', MODULE.Departament.new_tag, 256) 
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##dep_add_tag'..tag_type, 
											imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##dep_add_tag'..tag_type, 
											imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
											table.insert(settings.departament.dep_tags_custom, u8:decode(ffi.string(MODULE.Departament.new_tag)))
											save_settings()
											imgui.CloseCurrentPopup()
										end
										imgui.End()
									end
								end
								imgui.EndTabItem()
							end
						end
						createTagTab(u8'Стандартные теги (ru)', settings.departament.dep_tags)
						createTagTab(u8'Стандартные теги (en)', settings.departament.dep_tags_en)
						createTagTab(u8'Ваши кастомные теги', settings.departament.dep_tags_custom)
						imgui.EndTabBar()
					end
					imgui.End()
				end
			end
			local function createFrequencyPopup()
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
				if imgui.BeginPopupModal(fa.WALKIE_TALKIE .. u8' Частота для использования рации /d', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
					imgui.SetWindowSizeVec2(imgui.ImVec2(400 * settings.general.custom_dpi, 95 * settings.general.custom_dpi))
					change_dpi()
					for i, tag in ipairs(settings.departament.dep_fms) do
						imgui.SameLine()
						if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
							MODULE.Departament.fm = imgui.new.char[256](u8(tag))
							settings.departament.dep_fm = u8:decode(ffi.string(MODULE.Departament.fm))
							save_settings()
							imgui.CloseCurrentPopup()
						end
					end
					imgui.Separator()
					if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить частоту', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.OpenPopup(fa.TAG .. u8' Добавление новой частоты##2')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.TAG .. u8' Добавление новой частоты##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						imgui.PushItemWidth(215 * settings.general.custom_dpi)
						imgui.InputText('##MODULE.Departament.new_tag', MODULE.Departament.new_tag, 256) 
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##dep_add_fm', 
							imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##dep_add_fm', 
							imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
							table.insert(settings.departament.dep_fms, u8:decode(ffi.string(MODULE.Departament.new_tag)))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.WALKIE_TALKIE .. u8" Рация департамента " .. fa.WALKIE_TALKIE, MODULE.Departament.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
			change_dpi()
			if imgui.BeginChild('##2', imgui.ImVec2(500 * settings.general.custom_dpi, 186 * settings.general.custom_dpi), true) then
				imgui.Columns(3)
				imgui.CenterColumnText(u8('Ваш тег:'))
				imgui.PushItemWidth(155 * settings.general.custom_dpi)
				if imgui.InputText('##MODULE.Departament.tag1', MODULE.Departament.tag1, 256) then
					settings.departament.dep_tag1 = u8:decode(ffi.string(MODULE.Departament.tag1))
					save_settings()
				end
				if imgui.CenterColumnButton(u8('Выбрать тег##1')) then
					imgui.OpenPopup(fa.TAG .. u8' Теги организаций##1')
				end
				createTagPopup('1', MODULE.Departament.tag1, 'dep_tag1')
				
				imgui.NextColumn()
				imgui.CenterColumnText(u8('Частота рации:'))
				imgui.PushItemWidth(155 * settings.general.custom_dpi)
				if imgui.InputText('##MODULE.Departament.fm', MODULE.Departament.fm, 256) then
					settings.departament.dep_fm = u8:decode(ffi.string(MODULE.Departament.fm))
					save_settings()
				end
				if imgui.CenterColumnButton(u8('Выбрать частоту##1')) then
					imgui.OpenPopup(fa.WALKIE_TALKIE .. u8' Частота для использования рации /d')
				end
				createFrequencyPopup()
				imgui.NextColumn()
				imgui.CenterColumnText(u8('Тег получателя:'))
				imgui.PushItemWidth(155 * settings.general.custom_dpi)
				if imgui.InputText('##MODULE.Departament.tag2', MODULE.Departament.tag2, 256) then
					settings.departament.dep_tag2 = u8:decode(ffi.string(MODULE.Departament.tag2))
					save_settings()
				end
				if imgui.CenterColumnButton(u8('Выбрать тег##2')) then
					imgui.OpenPopup(fa.TAG .. u8' Теги организаций##2')
				end
				createTagPopup('2', MODULE.Departament.tag2, 'dep_tag2')
				imgui.Columns(1)
				imgui.Separator()
				imgui.CenterText(u8('Текст:'))
				imgui.PushItemWidth(405 * settings.general.custom_dpi)
				imgui.InputText(u8'##dep_input_text', MODULE.Departament.text, 256)
				imgui.SameLine()
				if imgui.Button(u8' Отправить ') then
					local tag1 = settings.departament.anti_skobki and u8:decode(ffi.string(MODULE.Departament.tag1)):gsub("[%[%]]", "") or u8:decode(ffi.string(MODULE.Departament.tag1))
					local tag2 = settings.departament.anti_skobki and u8:decode(ffi.string(MODULE.Departament.tag2)):gsub("[%[%]]", "") or u8:decode(ffi.string(MODULE.Departament.tag2))
					sampSendChat('/d ' .. tag1 .. ' ' .. u8:decode(ffi.string(MODULE.Departament.fm)) .. ' ' .. tag2 .. ': ' .. u8:decode(ffi.string(MODULE.Departament.text)))
				end
				local tag1 = ffi.string(MODULE.Departament.tag1)
				local tag2 = ffi.string(MODULE.Departament.tag2)
				local fm = ffi.string(MODULE.Departament.fm)
				local text = ffi.string(MODULE.Departament.text)
				if settings.departament.anti_skobki then
					tag1 = tag1:gsub("[%[%]]", "")
					tag2 = tag2:gsub("[%[%]]", "")
				end
				local preview_text = ('/d ' .. tag1 .. ' ' .. fm .. ' ' .. tag2 .. ': ' .. text)
				imgui.CenterText(preview_text)
				imgui.Separator()
				if imgui.Checkbox(u8(' Отключить использование символов [] (скобок) в тегах организаций'), MODULE.Main.checkbox.dep_anti_skobki) then
					settings.departament.anti_skobki = MODULE.Main.checkbox.dep_anti_skobki[0]
					save_settings()
				end
				imgui.EndChild()
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Post.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.patrool_menu.x, settings.windows_pos.patrool_menu.y), imgui.Cond.FirstUseEver)
			imgui.Begin(getHelperIcon() .. u8" Arizona Helper " .. getHelperIcon() .. '##post_info_menu', MODULE.Post.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
			change_dpi()
			safery_disable_cursor(player)
			if MODULE.Post.active then
				imgui.Text(fa.MAP_LOCATION_DOT .. u8(' Пост: ') .. u8(MODULE.Binder.tags.get_post_name()))
				imgui.Text(fa.CLOCK .. u8(' Время на посту: ') .. u8(MODULE.Binder.tags.get_post_time()))
				imgui.Text(fa.CIRCLE_INFO .. u8(' Состояние: ') .. u8(MODULE.Binder.tags.get_post_code()))
				imgui.SameLine()
				if imgui.SmallButton(fa.GEAR) then
					imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##post_select_code'))
				end
				imgui.Separator()
				if imgui.Button(fa.WALKIE_TALKIE .. u8(' Доклад##post'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if (not MODULE.Post.process_doklad) then
						MODULE.Post.process_doklad = true
						lua_thread.create(function()
							MODULE.Binder.state.isActive = true
							sampSendChat('/r Докладывает ' .. MODULE.Binder.tags.my_doklad_nick() .. '. Пост: ' .. MODULE.Binder.tags.get_post_name() .. ', состояние ' .. MODULE.Binder.tags.get_post_code())
							wait(1500)
							sampSendChat('/r Нахожусь на посту уже ' .. MODULE.Binder.tags.get_post_format_time())
							MODULE.Binder.state.isActive = false
							MODULE.Post.process_doklad = false
						end)
					end
				end	
				imgui.SameLine()
				if imgui.Button(fa.CIRCLE_STOP .. u8(' Конец##post'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					lua_thread.create(function()
						MODULE.Post.Window[0] = false
						MODULE.Post.active = false
						MODULE.Binder.state.isActive = true
						sampSendChat('/r ' .. MODULE.Binder.tags.my_doklad_nick() .. ' на CONTROL. Пост: ' .. MODULE.Binder.tags.get_post_name() .. ', состояние ' .. MODULE.Binder.tags.get_post_code() .. '.')
						wait(1500)
						sampSendChat('/r Освобождаю пост! Простоял' .. MODULE.Binder.tags.sex() .. ' на посту: ' .. MODULE.Binder.tags.get_post_format_time() .. '.', -1)
						MODULE.Binder.state.isActive = false
						MODULE.Post.time = 0
						MODULE.Post.start_time = 0
						MODULE.Post.current_time = 0
						MODULE.Post.code = 'CODE4'
						MODULE.Post.ComboCode[0] = 5
					end)
				end
			else
				player.HideCursor = false
				imgui.PushItemWidth(200 * settings.general.custom_dpi)
				if imgui.InputTextWithHint(u8'##post_name', u8('Укажите название вашего поста'), MODULE.Post.input, 256) then
					MODULE.Post.name = u8:decode(ffi.string(MODULE.Post.input))
				end
				imgui.Separator()
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена##post', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Post.Window[0] = false
				end
				imgui.SameLine()
				if imgui.Button(fa.WALKIE_TALKIE .. u8' Заступить##post', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Post.time = 0
					MODULE.Post.start_time = os.time()
					MODULE.Post.active = true
					MODULE.Binder.state.isActive = true
					sampSendChat('/r Докладывает ' .. MODULE.Binder.tags.my_doklad_nick() .. '. Заступаю на пост ' .. MODULE.Binder.tags.get_post_name() .. ', состояние ' .. MODULE.Binder.tags.get_post_code() .. '.')
					MODULE.Binder.state.isActive = false
					imgui.CloseCurrentPopup()
				end
			end
			if imgui.BeginPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##post_select_code'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
				change_dpi()
				player.HideCursor = false 
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##post_code', MODULE.Post.ComboCode, MODULE.Patrool.ImItemsCode, #MODULE.Post.combo_code_list) then
					MODULE.Post.code = MODULE.Post.combo_code_list[MODULE.Post.ComboCode[0] + 1]
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.post_menu.x or posY ~= settings.windows_pos.post_menu.y then
				settings.windows_pos.post_menu = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)

end
if isMode('police') or isMode('fbi') or isMode('prison') then
	imgui.OnFrame(
		function() return MODULE.Taser.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.taser.x, settings.windows_pos.taser.y), imgui.Cond.FirstUseEver)
			imgui.Begin(" Arizona Helper##MODULE.Taser.Window", MODULE.Taser.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
			change_dpi()
			safery_disable_cursor(player)
			if imgui.Button(fa.GUN .. u8' Taser ',  imgui.ImVec2(75 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				sampSendChat('/taser')
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.taser.x or posY ~= settings.windows_pos.taser.y then
				settings.windows_pos.taser = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
end
if isMode('police') or isMode('fbi') or isMode('prison') then
	function renderSmartGUI(title, icon, downloadPath, editPopupTitle, data, saveFunction, usageText, pathDisplay, download_file_name, download_item)
		if imgui.BeginChild('##smart'..title, imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
			if #data ~= 0 then
				imgui.CenterText(u8("Активно - ") .. u8(usageText))
			else
				imgui.CenterText(u8("Неактивно - Загрузите ") .. u8(download_item) .. u8(" из облака или заполните вручную"))
			end
			imgui.Separator()
			imgui.SetCursorPosY(90 * settings.general.custom_dpi)
			imgui.SetCursorPosX(207 * settings.general.custom_dpi)

			if imgui.Button(fa.DOWNLOAD .. (#data ~= 0 and u8' Обновить из облака 'or u8' Загрузить из облака ') .. fa.DOWNLOAD .. '##smart'..title) then
				_G['download_'..title:lower()] = true
				download_file = download_file_name
				downloadFileFromUrlToPath(downloadPath, pathDisplay)
				imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Оповещение ' .. fa.CIRCLE_INFO .. '##downloadsmart'..title)
			end
			imgui.CenterText(u8'Данные из облака устарели или неактуальные?')
			imgui.CenterText(u8'Сообщите SMART модерам на нашем Discord сервере.')
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Оповещение ' .. fa.CIRCLE_INFO .. '##downloadsmart'..title, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
				if _G['download_'..title:lower()] then
					change_dpi()
					imgui.CenterText(u8'Идёт скачивание ' .. u8(editPopupTitle) .. u8' для сервера ' .. u8(getServerName(getServerNumber())) .. " [" .. getServerNumber() .. ']')
					imgui.CenterText(u8'После успешной загрузки менюшка пропадёт и вы увидите сообщение в чате про завершение.')
					imgui.Separator()
					imgui.CenterText(u8'Если прошло больше 10 секунд и ничего не происходит, значит произошла ошибка скачивания!')
					imgui.CenterText(u8'Способы решения ошибки автоматического скачивания:')
					imgui.CenterText(u8'1) Вы можете вручную заполнить данные по кнопке "Отредактировать"')
					imgui.CenterText(u8'2) Вы можете скачать готовый файлик из облака (кнопка) и закинуть его по по пути:')
					imgui.CenterText(u8(pathDisplay))
					imgui.Separator()
				else
					MODULE.Main.Window[0] = false
					imgui.CloseCurrentPopup()
				end
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть ' .. fa.CIRCLE_XMARK .. '##close_smart' .. title, imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					imgui.CloseCurrentPopup()
				end
				imgui.SameLine()
				if imgui.Button(fa.CIRCLE_PLAY .. u8' Открыть облако ' .. fa.CIRCLE_PLAY .. '##open_web_smart' .. title, imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					openLink(downloadPath)
					MODULE.Main.Window[0] = false
				end
				imgui.EndPopup()
			end
			imgui.SetCursorPosY(220 * settings.general.custom_dpi)
			imgui.SetCursorPosX(190 * settings.general.custom_dpi)
			if imgui.Button(fa.PEN_TO_SQUARE .. u8' Отредактировать вручную ' .. fa.PEN_TO_SQUARE .. '##smart'..title) then
				imgui.OpenPopup(icon .. ' ' .. u8(title) .. ' ' .. icon .. '##smart'..title)
			end
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			if imgui.BeginPopupModal(icon .. ' ' .. u8(title) .. ' ' .. icon .. '##smart'..title, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
				change_dpi()
				if imgui.BeginChild('##smart'..title..'edit', imgui.ImVec2(589 * settings.general.custom_dpi, 368 * settings.general.custom_dpi), true) then
					for chapter_index, chapter in ipairs(data) do
						imgui.Columns(2)
						imgui.Text("> " .. u8(chapter.name))
						imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
						imgui.NextColumn()
						if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. title .. chapter_index) then
							imgui.OpenPopup(u8(chapter.name).. '##' .. title .. chapter_index)
						end
						imgui.SameLine()
						if imgui.Button(fa.TRASH_CAN .. '##' .. title .. chapter_index) then
							imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index)
						end
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index, _, imgui.WindowFlags.NoResize) then
							change_dpi()
							imgui.CenterText(u8'Вы действительно хотите удалить пункт?')
							if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK .. '##cancel_delete_item_smart' .. chapter_index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить ' .. fa.TRASH_CAN .. '##delete_item_smart' .. chapter_index, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
								table.remove(data, chapter_index)
								saveFunction()
								imgui.CloseCurrentPopup()
							end
							imgui.End()
						end
						imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
						imgui.Columns(1)
						imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
						if imgui.BeginPopupModal(u8(chapter.name).. '##' .. title .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
							change_dpi()
							if imgui.BeginChild('##smart'..title..'edititem', imgui.ImVec2(589 * settings.general.custom_dpi, 368 * settings.general.custom_dpi), true) then
								if chapter.item then
									for index, item in ipairs(chapter.item) do
										imgui.Columns(2)
										imgui.Text("> " .. u8(item.text))
										imgui.SetColumnWidth(-1, 515 * settings.general.custom_dpi)
										imgui.NextColumn()
										if imgui.Button(fa.PEN_TO_SQUARE .. '##' .. chapter_index .. '##' .. title .. index) then
											_G['input_'..title:lower()..'_text'] = imgui.new.char[8192](u8(item.text))
											_G['input_'..title:lower()..'_value'] = imgui.new.char[256](u8(item[title:find('умного') and 'lvl' or 'amount']))
											_G['input_'..title:lower()..'_reason'] = imgui.new.char[1024](u8(item.reason))
											imgui.OpenPopup(fa.PEN_TO_SQUARE .. u8(" Редактирование подпункта##") .. title .. chapter.name .. index .. chapter_index)
										end
										imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
										if imgui.BeginPopupModal(fa.PEN_TO_SQUARE .. u8(" Редактирование подпункта##") .. title .. chapter.name .. index .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
											change_dpi()
											if imgui.BeginChild('##smart'..title..'edititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then    
												imgui.CenterText(u8'Название подпункта:')
												imgui.PushItemWidth(478 * settings.general.custom_dpi)
												imgui.InputText(u8'##input_'..title:lower()..'_text', _G['input_'..title:lower()..'_text'], 8192)
												if title == 'Система умного розыска' then
													imgui.CenterText(u8'Уровень розыска для выдачи (от 1 до 6):')
												elseif title == 'Система умных штрафов' then
													imgui.CenterText(u8'Сумма штрафа (цифры без каких либо символов):')
												elseif title == 'Система умного продления срока' then
													imgui.CenterText(u8'Уровень срока для выдачи (от 1 до 10):')
												end
												imgui.PushItemWidth(478 * settings.general.custom_dpi)
												imgui.InputText(u8'##input_'..title:lower()..'_value', _G['input_'..title:lower()..'_value'], 256)
												imgui.CenterText(u8'Причина:')
												imgui.PushItemWidth(478 * settings.general.custom_dpi)
												imgui.InputText(u8'##input_'..title:lower()..'_reason', _G['input_'..title:lower()..'_reason'], 1024)
												imgui.EndChild()
											end    
											
											if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
												imgui.CloseCurrentPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
												local text = u8:decode(ffi.string(_G['input_'..title:lower()..'_text']))
												local value = u8:decode(ffi.string(_G['input_'..title:lower()..'_value']))
												local reason = u8:decode(ffi.string(_G['input_'..title:lower()..'_reason']))
												local isValid = false
												if title == 'Система умного розыска' then
													isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 6 and text ~= '' and reason ~= ''
												elseif title == 'Система умных штрафов' then
													isValid = value ~= '' and value:find('%d') and not value:find('%D') and text ~= '' and reason ~= ''
												elseif title == 'Система умного продления срока' then
													isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 10 and text ~= '' and reason ~= ''
												end
												if isValid then
													item.text = text
													item[title:find('умного') and 'lvl' or 'amount'] = value
													item.reason = reason
													saveFunction()
													imgui.CloseCurrentPopup()
												else
													sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка в указанных данных, исправьте!', message_color)
												end
											end
											imgui.EndPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TRASH_CAN .. '##' .. chapter_index .. '##' .. title .. index) then
											imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index .. '##' .. index)
										end
										imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
										if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Предупреждение ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. title .. chapter_index .. '##' .. index, _, imgui.WindowFlags.NoResize) then
											change_dpi()
											imgui.CenterText(u8'Вы действительно хотите удалить подпункт?')
											imgui.Separator()
											if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
												imgui.CloseCurrentPopup()
											end
											imgui.SameLine()
											if imgui.Button(fa.TRASH_CAN .. u8' Да, удалить ' .. fa.TRASH_CAN, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
												table.remove(chapter.item, index)
												saveFunction()
												imgui.CloseCurrentPopup()
											end
											imgui.End()
										end
										
										imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
										imgui.Columns(1)
										imgui.Separator()
									end
								end
								imgui.EndChild()
							end
							if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить новый подпункт ' .. fa.CIRCLE_PLUS .. "##smart_add_subitem" .. chapter_index, imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
								_G['input_'..title:lower()..'_text'] = imgui.new.char[8192](u8(''))
								_G['input_'..title:lower()..'_value'] = imgui.new.char[256](u8(''))
								_G['input_'..title:lower()..'_reason'] = imgui.new.char[8192](u8(''))
								imgui.OpenPopup(fa.CIRCLE_PLUS .. u8(' Добавление нового подпункта ') .. fa.CIRCLE_PLUS .. '##smart_add_subitem' .. chapter_index)
							end
							imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
							if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8(' Добавление нового подпункта ') .. fa.CIRCLE_PLUS .. '##smart_add_subitem' .. chapter_index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
								if imgui.BeginChild('##smart'..title..'edititeminput', imgui.ImVec2(489 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then   
									change_dpi() 
									imgui.CenterText(u8'Название подпункта:')
									imgui.PushItemWidth(478 * settings.general.custom_dpi)
									imgui.InputText(u8'##input_'..title:lower()..'_text', _G['input_'..title:lower()..'_text'], 8192)
									if title == 'Система умного розыска' then
										imgui.CenterText(u8'Уровень розыска для выдачи (от 1 до 6):')
									elseif title == 'Система умных штрафов' then
										imgui.CenterText(u8'Сумма штрафа (цифры без каких либо символов):')
									elseif title == 'Система умного продления срока' then
										imgui.CenterText(u8'Уровень срока для выдачи (от 1 до 10):')
									end
									imgui.PushItemWidth(478 * settings.general.custom_dpi)
									imgui.InputText(u8'##input_'..title:lower()..'_value', _G['input_'..title:lower()..'_value'], 256)
									imgui.CenterText(u8'Причина:')
									imgui.PushItemWidth(478 * settings.general.custom_dpi)
									imgui.InputText(u8'##input_'..title:lower()..'_reason', _G['input_'..title:lower()..'_reason'], 8192)
									imgui.EndChild()
								end    
								if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. "##" .. chapter_index .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
									imgui.CloseCurrentPopup()
								end
								imgui.SameLine()
								if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. "##" .. chapter_index .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
									local text = u8:decode(ffi.string(_G['input_'..title:lower()..'_text']))
									local value = u8:decode(ffi.string(_G['input_'..title:lower()..'_value']))
									local reason = u8:decode(ffi.string(_G['input_'..title:lower()..'_reason']))
									local isValid = false
									if title == 'Система умного розыска' then
										isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 6 and text ~= '' and reason ~= ''
									elseif title == 'Система умных штрафов' then
										isValid = value ~= '' and value:find('%d') and not value:find('%D') and text ~= '' and reason ~= ''
									elseif title == 'Система умного продления срока' then
										isValid = value ~= '' and not value:find('%D') and tonumber(value) >= 1 and tonumber(value) <= 10 and text ~= '' and reason ~= ''
									end
									if isValid then
										local temp = { 
											text = text, 
											[title:find('умного') and 'lvl' or 'amount'] = value,
											reason = reason 
										}
										table.insert(chapter.item, temp)
										saveFunction()
										imgui.CloseCurrentPopup()
									else
										sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка в указанных данных, исправьте!', message_color)
									end
								end
								imgui.EndPopup()
							end
							imgui.SameLine()
							if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть ' .. fa.CIRCLE_XMARK .. "##close" .. chapter_index .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
								imgui.CloseCurrentPopup()
							end
							imgui.EndPopup()
						end
						imgui.Separator()
					end
					imgui.EndChild()	
					if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить пункт ' .. fa.CIRCLE_PLUS .. "##smart_add" .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						_G['input_'..title:lower()..'_name'] = imgui.new.char[512](u8(''))
						imgui.OpenPopup(fa.CIRCLE_PLUS .. u8' Добавление нового пункта ' .. fa.CIRCLE_PLUS)
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.CIRCLE_PLUS .. u8' Добавление нового пункта ' .. fa.CIRCLE_PLUS, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_'..title:lower()..'_name', u8("Введите ваш новый пункт..."), _G['input_'..title:lower()..'_name'], 512)
						--imgui.CenterText(u8'Обратите внимание, вы не сможете изменить его в дальнейшем!')
						if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить ' .. fa.CIRCLE_PLUS .. "##smart_add" .. title, imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
							local temp = u8:decode(ffi.string(_G['input_'..title:lower()..'_name']))
							table.insert(data, {name = temp, item = {}})
							saveFunction()
							imgui.CloseCurrentPopup()
						end
						imgui.EndPopup()
					end
					imgui.SameLine()
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть ' .. fa.CIRCLE_XMARK .. '##smart_close' .. title, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
						imgui.CloseCurrentPopup()
					end
					imgui.EndPopup()
				end
			end
			imgui.CenterText(u8'На случай отсуствия данных под ваш сервер')
			imgui.CenterText(u8'Для продвинутых пользователей')
			imgui.EndChild()
		end
	end
end
if isMode('prison') then
	imgui.OnFrame(
		function() return MODULE.PumMenu.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.STAR .. u8" Умная выдача повышенного срока " .. fa.STAR .. "##pum_menu", MODULE.PumMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			if modules.smart_rptp.data ~= nil and isParamSampID(player_id) then
				imgui.PushItemWidth(580 * settings.general.custom_dpi)
				imgui.InputTextWithHint(u8'##input_sum', u8('Поиск статей (подпунктов) в главах (пунктах)'), MODULE.PumMenu.input, 128) 
				imgui.Separator()
				local input_sum_decoded = u8:decode(ffi.string(MODULE.PumMenu.input))
				for _, chapter in ipairs(modules.smart_rptp.data) do
					local chapter_has_matching_item = false
					if chapter.item then
						for _, item in ipairs(chapter.item) do
							if item.text and item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
								chapter_has_matching_item = true
								break
							end
						end
					end
					if chapter_has_matching_item then
						if imgui.CollapsingHeader(u8(chapter.name)) then
							for _, item in ipairs(chapter.item) do
								if item.text and item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
									local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Перепроверьте данные перед повышением срока ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. item.text .. item.lvl .. item.reason
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
									imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
									if imgui.Button(u8(split_text_into_lines(item.text, 85))..'##' .. item.text .. item.lvl .. item.reason, imgui.ImVec2(imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
										imgui.OpenPopup(popup_id)
									end
									imgui.PopStyleColor()
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
										imgui.Text(fa.USER .. u8' Игрок: ' .. u8(sampGetPlayerNickname(player_id)) .. '[' .. player_id .. ']')
										imgui.Text(fa.STAR .. u8' Уровень срока: ' .. item.lvl)
										imgui.Text(fa.COMMENT .. u8' Причина повышения срока: ' .. u8(item.reason))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.STAR .. u8' Повысить срок ' .. fa.STAR, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.PumMenu.Window[0] = false
											find_and_use_command('/punish {arg_id} {arg2} 2 {arg3}', player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
								end
							end
						end
					end
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Произошла ошибка умного срока (нету данных либо игрок офнулся)!', message_color)
				MODULE.SumMenu.Window[0] = false
			end
			imgui.End()
		end
	)
end
if isMode('police') or isMode('fbi') then
	imgui.OnFrame(
		function() return MODULE.Patrool.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.patrool_menu.x, settings.windows_pos.patrool_menu.y), imgui.Cond.FirstUseEver)
			imgui.Begin(getHelperIcon() .. u8" Arizona Helper " .. getHelperIcon() .. '##patrool_info_menu', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
			change_dpi()
			safery_disable_cursor(player)
			if MODULE.Patrool.active then
				imgui.Text(fa.CLOCK .. u8(' Время патрулирования: ') .. u8(MODULE.Binder.tags.get_patrool_time()))
				imgui.Text(fa.CIRCLE_INFO .. u8(' Ваша маркировка: ') .. u8(MODULE.Binder.tags.get_patrool_mark()))
				imgui.Text(fa.CIRCLE_INFO .. u8(' Ваше состояние: ') .. u8(MODULE.Binder.tags.get_patrool_code()))
				imgui.SameLine()
				if imgui.SmallButton(fa.GEAR) then
					imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##patrool_select_code'))
				end
				imgui.Separator()
				if imgui.Button(fa.WALKIE_TALKIE .. u8(' Доклад'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if (not MODULE.Patrool.process_doklad) then
						MODULE.Patrool.process_doklad = true
						lua_thread.create(function()
							MODULE.Binder.state.isActive = true
							sampSendChat('/r ' .. MODULE.Binder.tags.my_doklad_nick() .. ' на CONTROL.')
							wait(1500)
							sampSendChat('/r Продолжаю патруль, нахожусь в районе ' .. MODULE.Binder.tags.get_area() .. " (" .. MODULE.Binder.tags.get_square() .. ').')
							wait(1500)
							if MODULE.Binder.tags.get_car_units() ~= 'Нету' then
								sampSendChat('/r Патрулирую уже ' .. MODULE.Binder.tags.get_patrool_format_time() .. ' в составе юнита ' .. MODULE.Binder.tags.get_car_units() .. ', состояние ' .. u8(MODULE.Binder.tags.get_patrool_code()) .. '.')
							else
								sampSendChat('/r Патрулирую уже ' .. MODULE.Binder.tags.get_patrool_format_time() .. ', состояние ' .. u8(MODULE.Binder.tags.get_patrool_code()) .. '.')
							end
							MODULE.Binder.state.isActive = false
							MODULE.Patrool.process_doklad = false
						end)
					end
				end
				imgui.SameLine()
				if imgui.Button(fa.CIRCLE_STOP .. u8(' Завершить'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					lua_thread.create(function()
						MODULE.Patrool.Window[0] = false
						MODULE.Patrool.active = false
						MODULE.Binder.state.isActive = true
						sampSendChat('/r ' .. MODULE.Binder.tags.my_doklad_nick() .. ' на CONTROL.')
						wait(1500)
						sampSendChat('/r Завершаю патруль, освобождаю маркировку ' .. MODULE.Binder.tags.get_patrool_mark() .. ', состояние ' .. MODULE.Binder.tags.get_patrool_code())
						wait(1500)
						sampSendChat('/r Патрулировал' .. MODULE.Binder.tags.sex() .. ' ' .. MODULE.Binder.tags.get_patrool_format_time())
						MODULE.Patrool.time = 0
						MODULE.Patrool.start_time = 0
						MODULE.Patrool.current_time = 0
						MODULE.Patrool.code = 'CODE4'
						MODULE.Patrool.ComboCode[0] = 5
						wait(1500)
						sampSendChat('/delvdesc')
						MODULE.Binder.state.isActive = false
					end)
				end
			else
				player.HideCursor = false	
				imgui.CenterText(u8('Настройка данных перед началом патруля:'))
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO .. u8(' Ваша маркировка: '))
				imgui.SameLine()
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##patrool_mark', MODULE.Patrool.ComboMark, MODULE.Patrool.ImItemsMark, #MODULE.Patrool.combo_mark_list) then
					MODULE.Patrool.mark = MODULE.Patrool.combo_mark_list[MODULE.Patrool.ComboMark[0] + 1] 
				end
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO .. u8(' Ваше состояние: '))
				imgui.SameLine()
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##patrool_code', MODULE.Patrool.ComboCode, MODULE.Patrool.ImItemsCode, #MODULE.Patrool.combo_code_list) then
					MODULE.Patrool.code = MODULE.Patrool.combo_code_list[MODULE.Patrool.ComboCode[0] + 1]
				end
				imgui.Separator()
				imgui.Text(fa.CIRCLE_INFO .. u8(' Напарники: ') .. u8(MODULE.Binder.tags.get_car_units()))
				imgui.Separator()
				if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Patrool.Window[0] = false
				end
				imgui.SameLine()
				if imgui.Button(fa.WALKIE_TALKIE .. u8' Начать патруль', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
					MODULE.Patrool.time = 0
					MODULE.Patrool.start_time = os.time()
					MODULE.Patrool.active = true
					lua_thread.create(function()
						MODULE.Binder.state.isActive = true
						sampSendChat('/r ' .. MODULE.Binder.tags.my_doklad_nick() .. ' на CONTROL.')
						wait(1500)
						sampSendChat('/r Начинаю патруль, нахожусь в районе ' .. MODULE.Binder.tags.get_area() .. " (" .. MODULE.Binder.tags.get_square() .. ').')
						wait(1500)
						if MODULE.Binder.tags.get_car_units() ~= 'Нету' then
							sampSendChat('/r Занимаю маркировку ' .. MODULE.Binder.tags.get_patrool_mark() .. ', нахожусь в составе юнита ' .. MODULE.Binder.tags.get_car_units() .. ', состояние ' .. MODULE.Binder.tags.get_patrool_code() .. '.')
						else
							sampSendChat('/r Занимаю маркировку ' .. MODULE.Binder.tags.get_patrool_mark() .. ', состояние ' .. MODULE.Binder.tags.get_patrool_code() .. '.')
						end
						wait(1500)
						sampSendChat('/vdesc ' .. MODULE.Binder.tags.get_patrool_mark())
						MODULE.Binder.state.isActive = false
					end)
					imgui.CloseCurrentPopup()
				end
			end
			if imgui.BeginPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##patrool_select_code'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
				change_dpi()
				player.HideCursor = false 
				imgui.PushItemWidth(150 * settings.general.custom_dpi)
				if imgui.Combo('##patrool_code', MODULE.Patrool.ComboCode, MODULE.Patrool.ImItemsCode, #MODULE.Patrool.combo_code_list) then
					MODULE.Patrool.code = MODULE.Patrool.combo_code_list[MODULE.Patrool.ComboCode[0] + 1]
					imgui.CloseCurrentPopup()
				end
				imgui.EndPopup()
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.patrool_menu.x or posY ~= settings.windows_pos.patrool_menu.y then
				settings.windows_pos.patrool_menu = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Wanted.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.wanteds_menu.x, settings.windows_pos.wanteds_menu.y), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.STAR .. u8" Список преступников (всего " .. #MODULE.Wanted.wanted .. u8') ' .. fa.STAR, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar)
			change_dpi()
			
			if tonumber(#MODULE.Wanted.wanted) == 0 then 
				sampAddChatMessage('[Arizona Helper] {ffffff}Сейчас на сервере нету игроков с розыском!', message_color)
				MODULE.Wanted.Window[0] = false
			end

			safery_disable_cursor(player)
			if settings.mj.auto_update_wanteds then
				local text_time_wait = tostring(15 - tonumber(MODULE.Wanted.updwanteds.time))
				if tonumber(text_time_wait) < 10 then
					text_time_wait = '0' .. text_time_wait
				end
				imgui.Text(u8('Обновление списка преступников будет через ') .. tostring(text_time_wait) .. u8(' секунд'))
				imgui.Separator()
			else
				if imgui.Button(u8'Обновить список преступников', imgui.ImVec2(340 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					MODULE.Wanted.Window[0] = false
					sampAddChatMessage('[Arizona Helper] {ffffff}Вы можете включить авто-обновление /wanteds в настройках Ассистента!', message_color)
					sampProcessChatInput('/wanteds')
				end
				imgui.Separator()
			end	
			imgui.Columns(3)
			imgui.CenterColumnText(u8("Никнейм"))
			imgui.SetColumnWidth(-1, 200 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8("Розыск"))
			imgui.SetColumnWidth(-1, 65 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8("Расстояние"))
			imgui.SetColumnWidth(-1, 80 * settings.general.custom_dpi)
			imgui.Columns(1)
			for i, v in ipairs(MODULE.Wanted.wanted) do
				imgui.Separator()
				imgui.Columns(3)
				if sampGetPlayerColor(v.id) == 368966908 then
					imgui_RGBA = (settings.general.helper_theme ~= 2) and imgui.ImVec4(1, 1, 1, 1) or imgui.ImVec4(0, 0, 0, 1)
					imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
				else
					local rgbNormalized = argbToRgbNormalized(sampGetPlayerColor(v.id))
					local imgui_RGBA = imgui.ImVec4(rgbNormalized[1], rgbNormalized[2], rgbNormalized[3], 1)
					imgui.CenterColumnColorText(imgui_RGBA, u8(v.nick) .. ' [' .. v.id .. ']')
				end
				if imgui.IsItemClicked() and not v.dist:find('В интерьере') then
					sampSendChat('/pursuit ' .. v.id)
				end
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.lvl) .. ' ' .. fa.STAR)
				imgui.NextColumn()
				imgui.CenterColumnText(u8(v.dist))
				imgui.NextColumn()
				imgui.Columns(1)
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.wanteds_menu.x or posY ~= settings.windows_pos.wanteds_menu.y then
				settings.windows_pos.wanteds_menu = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Megafon.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.megafon.x, settings.windows_pos.megafon.y), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.BUILDING_SHIELD .. " Arizona Helper##fast_meg_button", MODULE.Megafon.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
			change_dpi()
			safery_disable_cursor(player)
			if imgui.Button(fa.BULLHORN .. u8' 10-55 ',  imgui.ImVec2(75 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				sampProcessChatInput('/55')
			end
			imgui.SameLine()
			if imgui.Button(fa.BULLHORN .. u8' 10-66 ',  imgui.ImVec2(75 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				sampProcessChatInput('/66')
			end
			local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
			if posX ~= settings.windows_pos.megafon.x or posY ~= settings.windows_pos.megafon.y then
				settings.windows_pos.megafon = {x = posX, y = posY}
				save_settings()
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.SumMenu.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.STAR .. u8" Умная выдача розыска " .. fa.STAR .. "##sum_menu", MODULE.SumMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			if modules.smart_uk.data ~= nil and isParamSampID(player_id) then
				imgui.PushItemWidth(580 * settings.general.custom_dpi)
				imgui.InputTextWithHint(u8'##input_sum', u8('Поиск статей (подпунктов) в главах (пунктах)'), MODULE.SumMenu.input, 128) 
				imgui.Separator()
				local input_sum_decoded = u8:decode(ffi.string(MODULE.SumMenu.input))
				for _, chapter in ipairs(modules.smart_uk.data) do
					local chapter_has_matching_item = false
					if chapter.item then
						for _, item in ipairs(chapter.item) do
							if item.text and item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
								chapter_has_matching_item = true
								break
							end
						end
					end
					if chapter_has_matching_item then
						if imgui.CollapsingHeader(u8(chapter.name)) then
							for _, item in ipairs(chapter.item) do
								if item.text and item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
									local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Перепроверьте данные перед выдачей розыска##' .. item.text .. item.lvl .. item.reason
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
									imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
									if imgui.Button("> " .. u8(split_text_into_lines(item.text, 85))..'##' .. item.text .. item.lvl .. item.reason, imgui.ImVec2(imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
										imgui.OpenPopup(popup_id)
									end
									imgui.PopStyleColor()
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
										imgui.Text(fa.USER .. u8' Игрок: ' .. u8(sampGetPlayerNickname(player_id)) .. '[' .. player_id .. ']')
										imgui.Text(fa.STAR .. u8' Уровень розыска: ' .. item.lvl)
										imgui.Text(fa.COMMENT .. u8' Причина выдачи розыска: ' .. u8(item.reason))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.WALKIE_TALKIE .. u8' Запросить розыск ' .. fa.WALKIE_TALKIE, imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.SumMenu.Window[0] = false
											find_and_use_command('Прошу обьявить в розыск %{arg2%} степени дело N%{arg_id%}%. Причина%: %{arg3%}', player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										local text_rank = ((settings.general.fraction == 'ФБР' or settings.general.fraction == 'FBI') and ' [4+]' or ' [5+]')
										if imgui.Button(fa.STAR .. u8' Выдать розыск' .. text_rank, imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.SumMenu.Window[0] = false
											find_and_use_command('/su {arg_id} {arg2} {arg3}', player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
								end
							end
						end
					end
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Произошла ошибка умного розыска (нету данных либо игрок офнулся)!', message_color)
				MODULE.SumMenu.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.TsmMenu.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.TICKET .. u8" Умная выдача штрафов " .. fa.TICKET .. "##tsm_menu", MODULE.TsmMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			change_dpi()
			if modules.smart_pdd.data ~= nil and isParamSampID(player_id) then
				imgui.PushItemWidth(580 * settings.general.custom_dpi)
				imgui.InputTextWithHint(u8'##input_tsm', u8('Поиск статей (подпунктов) в главах (пунктах)'), MODULE.TsmMenu.input, 128) 
				imgui.Separator()
				local input_tsm_decoded = u8:decode(ffi.string(MODULE.TsmMenu.input))
				for _, chapter in ipairs(modules.smart_pdd.data) do
					local chapter_has_matching_item = false
					if chapter.item then
						for _, item in ipairs(chapter.item) do
							if item.text and item.text:rupper():find(input_tsm_decoded:rupper()) or input_tsm_decoded == '' then
								chapter_has_matching_item = true
								break
							end
						end
					end
					if chapter_has_matching_item then
						if imgui.CollapsingHeader(u8(chapter.name)) then
							for _, item in ipairs(chapter.item) do
								if item.text and item.text:rupper():find(input_tsm_decoded:rupper()) or input_tsm_decoded == '' then
									local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Перепроверьте данные перед выдачей штрафа##' .. item.text .. item.amount .. item.reason
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
									imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
									if imgui.Button(u8(split_text_into_lines(item.text,85))..'##' .. item.text .. item.amount .. item.reason, imgui.ImVec2( imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
										imgui.OpenPopup(popup_id)
									end 
									imgui.PopStyleColor()
									imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
									imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
									if imgui.BeginPopupModal(popup_id, nil, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
										imgui.Text(fa.USER .. u8' Игрок: ' .. u8(sampGetPlayerNickname(player_id)) .. '[' .. player_id .. ']')
										imgui.Text(fa.MONEY_CHECK_DOLLAR .. u8' Сумма штрафа: $' .. item.amount)
										imgui.Text(fa.COMMENT .. u8' Причина выдачи штрафа: ' .. u8(item.reason))
										imgui.Separator()
										if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											imgui.CloseCurrentPopup()
										end
										imgui.SameLine()
										if imgui.Button(fa.TICKET .. u8' Выписать штраф ' .. fa.TICKET, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
											MODULE.TsmMenu.Window[0] = false
											find_and_use_command('ticket {arg_id}', player_id .. ' ' .. item.amount .. ' ' .. item.reason)
											imgui.CloseCurrentPopup()
										end
										imgui.EndPopup()
									end
								end
							end
						end
					end
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Произошла ошибка умных штрафов (нету данных либо игрок офнулся)!', message_color)
				MODULE.TsmMenu.Window[0] = false
			end
			imgui.End()
		end
	)
end
if isMode('hospital') then
	imgui.OnFrame(
		function() return MODULE.MedCard.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##medcard", MODULE.MedCard.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Срок действия мед.карты:')
			if imgui.RadioButtonIntPtr(u8" 7 дней ##0",MODULE.MedCard.days,0) then
				MODULE.MedCard.days[0] = 0
			end
			if imgui.RadioButtonIntPtr(u8" 14 дней ##1",MODULE.MedCard.days,1) then
				MODULE.MedCard.days[0] = 1
			end
			if imgui.RadioButtonIntPtr(u8" 30 дней ##2",MODULE.MedCard.days,2) then
				MODULE.MedCard.days[0] = 2
			end
			if imgui.RadioButtonIntPtr(u8" 60 дней ##3",MODULE.MedCard.days,3) then
				MODULE.MedCard.days[0] = 3
			end
			imgui.Separator()
			imgui.CenterText(u8'Cтатус здоровья пациента:')
			if imgui.RadioButtonIntPtr(u8" Не определен ##0", MODULE.MedCard.status,0) then
				MODULE.MedCard.status[0] = 0
			end
			if imgui.RadioButtonIntPtr(u8" Психически не здоров ##1", MODULE.MedCard.status,1) then
				MODULE.MedCard.status[0] = 1
			end
			if imgui.RadioButtonIntPtr(u8" Наблюдаются отклонения ##2", MODULE.MedCard.status,2) then
				MODULE.MedCard.status[0] = 2
			end
			if imgui.RadioButtonIntPtr(u8" Полностью здоров ##3", MODULE.MedCard.status,3) then
				MODULE.MedCard.status[0] = 3
			end
			imgui.Separator()
			if imgui.Button(fa.ID_CARD_CLIP..u8" Выдать мед.карту", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				local command_find = false
				for _, command in ipairs(modules.commands.data.commands.my) do
					if command.enable and command.text:find('/medcard') then
						command_find = true
						local modifiedText = command.text
						local wait_tag = false
						local arg_id = player_id
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						lua_thread.create(function()
							MODULE.Binder.state.isActive = true
							MODULE.Binder.state.isPause = false
							if modifiedText:find('&.+&') then
								info_stop_command()
							end
							local lines = {}
							for line in string.gmatch(modifiedText, "[^&]+") do
								table.insert(lines, line)
							end
							for line_index, line in ipairs(lines) do 
								if MODULE.Binder.state.isStop then 
									MODULE.Binder.state.isStop = false 
									MODULE.Binder.state.isActive = false
									if isMonetLoader() and settings.general.mobile_stop_button then
										MODULE.CommandStop.Window[0] = false
									end
									sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
									return 
								end
								if wait_tag then
									for tag, replacement in pairs(MODULE.Binder.tags) do
										if line:find("{" .. tag .. "}") then
											local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
											if success then
												line = result
											end
										end
									end
									if line == "{pause}" then
										sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. command.cmd .. ' поставлена на паузу!', message_color)
										MODULE.Binder.state.isPause = true
										MODULE.CommandPause.Window[0] = true
										while MODULE.Binder.state.isPause do
											wait(0)
										end
										if not MODULE.Binder.state.isStop then
											sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. command.cmd, message_color)	
										end					
									else
										sampSendChat(line)
										if (MODULE.DEBUG) then sampAddChatMessage('[DEBUG] SEND: ' .. line, message_color) end	
										wait(command.waiting * 1000)
									end
								end
								if not wait_tag then
									if line == '{show_medcard_menu}' then
										wait_tag = true
									end
								end
							end
							MODULE.Binder.state.isActive = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								MODULE.CommandStop.Window[0] = false
							end
						end)
					end
				end
				if not command_find then
					sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для выдачи мед.карты отсутствует либо отключён!', message_color)
					sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
				end
				MODULE.MedCard.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Recept.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##recept", MODULE.Recept.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Количество рецептов для выдачи:')
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderInt('', MODULE.Recept.recepts, 1, 5)
			imgui.Separator()
			if imgui.Button(fa.CAPSULES .. u8" Выдать рецепты " .. fa.CAPSULES, imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				local command_find = false
				for _, command in ipairs(modules.commands.data.commands.my) do
					if command.enable and command.text:find('/recept') then
						command_find = true
						local modifiedText = command.text
						local wait_tag = false
						local arg_id = player_id
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						lua_thread.create(function()
							MODULE.Binder.state.isActive = true
							MODULE.Binder.state.isPause = false
							if modifiedText:find('&.+&') then
								info_stop_command()
							end
							local lines = {}
							for line in string.gmatch(modifiedText, "[^&]+") do
								table.insert(lines, line)
							end
							for line_index, line in ipairs(lines) do 
								if MODULE.Binder.state.isStop then 
									MODULE.Binder.state.isStop = false 
									MODULE.Binder.state.isActive = false
									if isMonetLoader() and settings.general.mobile_stop_button then
										MODULE.CommandStop.Window[0] = false
									end
									sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
									return 
								end
								if wait_tag then
									for tag, replacement in pairs(MODULE.Binder.tags) do
										if line:find("{" .. tag .. "}") then
											local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
											if success then
												line = result
											end
										end
									end
									if line == "{pause}" then
										sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. command.cmd .. ' поставлена на паузу!', message_color)
										MODULE.Binder.state.isPause = true
										MODULE.CommandPause.Window[0] = true
										while MODULE.Binder.state.isPause do
											wait(0)
										end
										if not MODULE.Binder.state.isStop then
											sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. command.cmd, message_color)	
										end					
									else
										sampSendChat(line)
										if (MODULE.DEBUG) then sampAddChatMessage('[DEBUG] SEND: ' .. line, message_color) end	
										wait(command.waiting * 1000)
									end
								end
								if not wait_tag then
									if line == '{show_recept_menu}' then
										wait_tag = true
									end
								end
							end
							MODULE.Binder.state.isActive = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								MODULE.CommandStop.Window[0] = false
							end
						end)
					end
				end
				if not command_find then
					sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для выдачи рецептов отсутствует либо отключён!', message_color)
					sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
				end
				MODULE.Recept.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.Antibiotik.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##ant", MODULE.Antibiotik.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Количество антибиотиков для выдачи:')
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderInt('', MODULE.Antibiotik.ants, 1, 20)
			imgui.Separator()
			if imgui.Button(fa.CAPSULES..u8" Выдать антибиотики" , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				local command_find = false
				for _, command in ipairs(modules.commands.data.commands.my) do
					if command.enable and command.text:find('/antibiotik') then
						command_find = true
						local modifiedText = command.text
						local wait_tag = false
						local arg_id = player_id
						modifiedText = modifiedText:gsub('%{get_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id) or "")
						modifiedText = modifiedText:gsub('%{get_rp_nick%(%{arg_id%}%)%}', sampGetPlayerNickname(arg_id):gsub('_',' ') or "")
						modifiedText = modifiedText:gsub('%{get_ru_nick%(%{arg_id%}%)%}', TranslateNick(sampGetPlayerNickname(arg_id)) or "")
						modifiedText = modifiedText:gsub('%{arg_id%}', arg_id or "")
						lua_thread.create(function()
							MODULE.Binder.state.isActive = true
							MODULE.Binder.state.isPause = false
							if modifiedText:find('&.+&') then
								info_stop_command()
							end
							local lines = {}
							for line in string.gmatch(modifiedText, "[^&]+") do
								table.insert(lines, line)
							end
							for line_index, line in ipairs(lines) do 
								if MODULE.Binder.state.isStop then 
									MODULE.Binder.state.isStop = false 
									MODULE.Binder.state.isActive = false
									if isMonetLoader() and settings.general.mobile_stop_button then
										MODULE.CommandStop.Window[0] = false
									end
									sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
									return 
								end
								if wait_tag then
									for tag, replacement in pairs(MODULE.Binder.tags) do
										if line:find("{" .. tag .. "}") then
											local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
											if success then
												line = result
											end
										end
									end
									if line == "{pause}" then
										sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. command.cmd .. ' поставлена на паузу!', message_color)
										MODULE.Binder.state.isPause = true
										MODULE.CommandPause.Window[0] = true
										while MODULE.Binder.state.isPause do
											wait(0)
										end
										if not MODULE.Binder.state.isStop then
											sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. command.cmd, message_color)	
										end					
									else
										sampSendChat(line)
										if (MODULE.DEBUG) then sampAddChatMessage('[DEBUG] SEND: ' .. line, message_color) end	
										wait(command.waiting * 1000)
									end
								end
								if not wait_tag then
									if line == '{show_ant_menu}' then
										wait_tag = true
									end
								end
							end
							MODULE.Binder.state.isActive = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								MODULE.CommandStop.Window[0] = false
							end
						end)
					end
				end
				if not command_find then
					sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для выдачи антибиотиков отсутствует либо отключён!', message_color)
					sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
				end
				MODULE.Antibiotik.Window[0] = false
			end
			imgui.End()
		end
	)
	imgui.OnFrame(
		function() return MODULE.HealChat.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 1.9), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##fast_heal", MODULE.HealChat.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar +  imgui.WindowFlags.AlwaysAutoResize )
			change_dpi()
			if imgui.Button(fa.KIT_MEDICAL..u8' Вылечить '.. u8(sampGetPlayerNickname(MODULE.HealChat.player_id))) then
				find_and_use_command("/heal {arg_id}", MODULE.HealChat.player_id)
				MODULE.HealChat.bool = false
				MODULE.HealChat.player_id = nil
				MODULE.HealChat.Window[0] = false
			end
			imgui.End()
		end
	)
end
if isMode('smi') then
	imgui.OnFrame(
		function() return MODULE.SmiEdit.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			local size_window_y = settings.smi.use_ads_buttons and 302 or 140
			imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, size_window_y * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
			imgui.Begin(fa.BUILDING_SHIELD.." Arizona Helper##MODULE.SmiEdit.Window", MODULE.SmiEdit.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar )
			change_dpi()
			imgui.Text(fa.CIRCLE_INFO .. u8" Объявление подал игрок: " .. u8(MODULE.SmiEdit.ad_from) .. '[' .. (sampGetPlayerIdByNickname(MODULE.SmiEdit.ad_from) and sampGetPlayerIdByNickname(MODULE.SmiEdit.ad_from) or 'OFF') .. ']')
			imgui.Text(fa.CIRCLE_INFO .. u8" Текст: " .. (u8(MODULE.SmiEdit.ad_message)))
			imgui.SameLine()
			if imgui.SmallButton(fa.CIRCLE_ARROW_RIGHT) then
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(MODULE.SmiEdit.ad_message))
			end
			imgui.Separator()
			local window_size = imgui.GetWindowSize()
			local size_item_width = settings.smi.ads_history and 100 or 70
			imgui.PushItemWidth(window_size.x - size_item_width * settings.general.custom_dpi)
			imgui.InputTextWithHint('##smi_edit_ad', u8'Отредактируйте объявление либо введите причину для отклонения', MODULE.SmiEdit.input_edit_text, 256)
			imgui.SameLine()
			if imgui.Button(fa.DELETE_LEFT, imgui.ImVec2(27 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))
				if #text > 0 then
					imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text:sub(1, -2)))
				end
			end
			imgui.SameLine()
			if imgui.Button(fa.TRASH_CAN, imgui.ImVec2(25 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, "")
			end
			if settings.smi.ads_history then
				imgui.SameLine()
				if imgui.Button(fa.CLOCK_ROTATE_LEFT, imgui.ImVec2(25 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					imgui.OpenPopup(fa.CLOCK_ROTATE_LEFT .. u8' История обьявлений')	
				end
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
				if imgui.BeginPopupModal(fa.CLOCK_ROTATE_LEFT .. u8' История обьявлений', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
					imgui.SetWindowSizeVec2(imgui.ImVec2(610 * settings.general.custom_dpi, 350 * settings.general.custom_dpi))
					if imgui.BeginChild('##99999999', imgui.ImVec2(600 * settings.general.custom_dpi, 285 * settings.general.custom_dpi), true) then	
						change_dpi()
						imgui.PushItemWidth(580 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_ads_search', u8'Поиск обьявлений по нужной фразе, начинайте вводить её сюда...', MODULE.SmiEdit.input_ads_search, 128)
						imgui.Separator()
						local input_ads_decoded = u8:decode(ffi.string(MODULE.SmiEdit.input_ads_search))
						for id, ad in ipairs(modules.ads_history.data) do
							if input_ads_decoded == '' or ad.my_text:rupper():find(input_ads_decoded:rupper()) then
								if imgui.Button(u8(ad.my_text .. '##' .. id), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
									imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(ad.my_text))
									imgui.CloseCurrentPopup()
									break
								end
							end
						end
						imgui.EndChild()
					end		
					if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						imgui.CloseCurrentPopup()
					end
					imgui.End()
				end
			end
			imgui.Separator()
			if settings.smi.use_ads_buttons then
				if imgui.BeginChild('##1', imgui.ImVec2(125 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
					if imgui.Button(u8('Куплю'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'Куплю '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Продам'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'Продам '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Обменяю'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'Обменяю '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Сдам в аренду'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'Сдам в аренду '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Арендую'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'Арендую '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.EndChild()
				end	
				imgui.SameLine()
				if imgui.BeginChild('##2', imgui.ImVec2(200 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
					if imgui.Button(u8('а/м'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'а/м '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('т/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'т/с '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('л/д'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'л/д '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('г/ф'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'г/ф '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end

					if imgui.Button(u8('в/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'в/т '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('м/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'м/т '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('с/м'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'с/м '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('в/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'в/с '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end

					if imgui.Button(u8('д/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'д/т '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('р/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'р/с '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('о/п'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'о/п '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('п/м'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'п/м '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end

					if imgui.Button(u8('а/с'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'а/с '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('п/т'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'п/т '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('б/з'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'б/з '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('н/з'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'н/з '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end

					if imgui.Button(u8('л/о'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'л/о '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('м/ф'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'м/ф '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('ч/д'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'ч/д '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
					if imgui.Button(u8('в/о'), imgui.ImVec2(imgui.GetMiddleButtonX(4), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'в/о '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.EndChild()
				end	
				imgui.SameLine()
				if imgui.BeginChild('##3', imgui.ImVec2(100 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then	
					if imgui.Button(u8('Цена:'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. ' Цена: '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Цена за шт:'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. ' Цена за шт: '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Договорная'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'Договорная'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Бюджет:'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. ' Бюджет: '
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					if imgui.Button(u8('Свободный'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. 'Свободный'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.EndChild()
				end	
				imgui.SameLine()
				if imgui.BeginChild('##4', imgui.ImVec2(150 * settings.general.custom_dpi, 155 * settings.general.custom_dpi), true) then
					-- Перший рядок
					if imgui.Button(u8('1'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '1'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('2'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '2'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('3'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '3'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
				
					-- Другий рядок
					if imgui.Button(u8('4'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '4'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('5'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '5'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('6'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '6'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
				
					-- Третій рядок
					if imgui.Button(u8('7'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '7'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('8'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '8'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('9'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '9'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
				
					-- Четвертий рядок
					if imgui.Button(u8('.'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '.'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('0'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '0'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
					imgui.SameLine()
				
					if imgui.Button(u8('$'), imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. '$'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end
				
					if imgui.Button(u8(' с гравировкой +'), imgui.ImVec2(imgui.GetMiddleButtonX(1), 25 * settings.general.custom_dpi)) then
						local text = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) .. ' с гравировкой +'
						imgui.StrCopy(MODULE.SmiEdit.input_edit_text, u8(text))
					end

					imgui.EndChild()
				end
				imgui.Separator()
			end
			if isMonetLoader() then
				if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8" Опубликовать", imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					send_ad()
				end
			else
				if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8" Опубликовать [" .. getNameKeysFrom(settings.general.bind_action) .. "]", imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
					send_ad()
				end
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Отклонить', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
				if u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text)) == '' then
					reason_cancel = 'Отказ ПРО'
				else
					reason_cancel = u8:decode(ffi.string(MODULE.SmiEdit.input_edit_text))
				end
				sampSendDialogResponse(MODULE.SmiEdit.ad_dialog_id, 0, 0, reason_cancel)
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, '')
				MODULE.SmiEdit.Window[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Пропустить', imgui.ImVec2(imgui.GetMiddleButtonX(3), 25 * settings.general.custom_dpi)) then
				MODULE.SmiEdit.skip_dialog = true
				sampSendChat('/mm')
				imgui.StrCopy(MODULE.SmiEdit.input_edit_text, '')
				MODULE.SmiEdit.Window[0] = false
			end
			imgui.End()
		end
	)
end
if (settings.player_info.fraction_rank_number >= 9) then
	imgui.OnFrame(
		function() return MODULE.GiveRank.Window[0] end,
		function(player)
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(getHelperIcon().." Arizona Helper " .. getHelperIcon() .. "##rank", MODULE.GiveRank.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			imgui.CenterText(u8'Выберите ранг для '.. u8(sampGetPlayerNickname(player_id)) .. ':')
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderInt('', MODULE.GiveRank.number, 1, (settings.player_info.fraction_rank_number == 9) and 8 or 9) -- зам не может дать 9 ранг
			imgui.Separator()
			local text = isMonetLoader() and " Выдать ранг" or " Выдать ранг [" .. getNameKeysFrom(settings.general.bind_action) .. "]"
			if imgui.Button(fa.USER .. u8(text), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				give_rank()
				MODULE.GiveRank.Window[0] = false
			end
			imgui.End()
		end
	)
end
----------------------------------------- FAST MENU GUI -------------------------------------------
imgui.OnFrame(
    function() return MODULE.FastMenu.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.USER .. ' '.. u8(sampGetPlayerNickname(player_id)) ..' ['..player_id.. ']##FastMenu', MODULE.FastMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		local check = false
		for _, command in ipairs(modules.commands.data.commands.my) do
			if command.enable and command.arg == '{arg_id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					MODULE.FastMenu.Window[0] = false
				end
				check = true
			end
		end
		if not check then
			sampAddChatMessage('[Arizona Helper] {ffffff}Настройте FastMenu в /helper - Команды и отыгровки!', message_color)
			MODULE.FastMenu.Window[0] = false
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.FastMenuButton.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.mobile_fastmenu_button.x, settings.windows_pos.mobile_fastmenu_button.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .." Arizona Helper##fast_menu_button", MODULE.FastMenuButton.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBackground  )
		change_dpi()
		if imgui.Button(fa.IMAGE_PORTRAIT..u8' Взаимодействие ') then
			local players = get_players()
			if #players == 1 then
				show_fast_menu(players[1])
				MODULE.FastMenuButton.Window[0] = false
			elseif #players > 1 then
				MODULE.FastMenuPlayers.Window[0] = true
				MODULE.FastMenuButton.Window[0] = false
			end
		end
		local posX, posY = imgui.GetWindowPos().x, imgui.GetWindowPos().y
		if posX ~= settings.windows_pos.mobile_fastmenu_button.x or posY ~= settings.windows_pos.mobile_fastmenu_button.y then
			settings.windows_pos.mobile_fastmenu_button = {x = posX, y = posY}
			save_settings()
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.FastMenuPlayers.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .. u8" Выберите игрока " .. getHelperIcon() .. "##fast_menu_players", MODULE.FastMenuPlayers.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		local players = get_players()
		if #players == 0 then
			show_fast_menu(players[1])
			MODULE.FastMenuPlayers.Window[0] = false
		elseif #players >= 1 then
			for _, player in ipairs(players) do
				local id = tonumber(player)
				if imgui.Button(u8(sampGetPlayerNickname(id)), imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if #players ~= 0 then show_fast_menu(id) end
					MODULE.FastMenuPlayers.Window[0] = false
				end
			end
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.LeaderFastMenu.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getUserIcon() .. ' ' .. u8(sampGetPlayerNickname(player_id)) .. ' [' .. player_id .. ']##LeaderFastMenu', MODULE.LeaderFastMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize  )
		change_dpi()
		local check = false
		for _, command in ipairs(modules.commands.data.commands_manage.my) do
			if command.enable and command.arg == '{arg_id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					MODULE.LeaderFastMenu.Window[0] = false
				end
				check = true
			end
		end
		if isMonetLoader() and not check then
			sampAddChatMessage('[Arizona Helper] {ffffff}Настройте LeaderFastMenu в /helper - Команды и отыгровки!', message_color)
			MODULE.FastMenu.Window[0] = false
		elseif not isMonetLoader() then
			if imgui.Button(u8"Выдать выговор",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig '..player_id..' ')
				MODULE.LeaderFastMenu.Window[0] = false
			end
			if imgui.Button(u8"Уволить из организации",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/unv '..player_id..' ')
				MODULE.LeaderFastMenu.Window[0] = false
			end
		end
		imgui.End()
    end
)
imgui.OnFrame(
	function() return MODULE.FastPieMenu.Window[0] end,
	function(player)
		imgui.Begin('##MODULE.FastPieMenu.Window', MODULE.FastPieMenu.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
		safery_disable_cursor(player)
		if imgui.IsMouseClicked(2) then
			imgui.OpenPopup('PieMenu')
		end
		if pie.BeginPiePopup('PieMenu', 2) then
			player.HideCursor = false
			
			if pie.PieMenuItem(u8' Миранда') then
				if imgui.IsMouseReleased(2) then 
					find_and_use_command('Вы имеете право', "")
				end
			end

			if pie.PieMenuItem(u8' Миранда') then
				if imgui.IsMouseReleased(2) then 
					find_and_use_command('Вы имеете право', "")
				end
			end
			
			if pie.BeginPieMenu(u8'Траффик стоп') then
				if pie.PieMenuItem('10-55') then 
					if imgui.IsMouseReleased(2) then
						find_and_use_command('Провожу 10%-55', "")
					end
				end
				if pie.PieMenuItem('10-66') then 
					if imgui.IsMouseReleased(2) then
						find_and_use_command('Провожу 10%-66', "")
					end
				end
				pie.EndPieMenu()
			end
			
			if pie.PieMenuItem(u8'Тайзер', false) then 
				if imgui.IsMouseReleased(2) then
					sampSendChat('/taser')
				end
			end

			if pie.BeginPieMenu('Test', false) then 
				if pie.BeginPieMenu('Test 1') then 
					
					pie.EndPieMenu()
				end
				if pie.BeginPieMenu('Test 2') then 
					
					pie.EndPieMenu()
				end
				if pie.BeginPieMenu('Test 3') then 
					if pie.PieMenuItem(u8'Круговое меню') then 
						if imgui.IsMouseReleased(2) then
							find_and_use_command('Провожу 10%-55', "")
						end
					end
					if pie.PieMenuItem(u8'Красиво?') then 
						if imgui.IsMouseReleased(2) then
							find_and_use_command('Провожу 10%-55', "")
						end
					end
					pie.EndPieMenu()
				end
				if pie.BeginPieMenu('Test 4') then 
					
					pie.EndPieMenu()
				end
				-- if pie.BeginPieMenu('Test 5') then 
					
				-- 	pie.EndPieMenu()
				-- end
				-- if pie.BeginPieMenu('Test 6') then 
					
				-- 	pie.EndPieMenu()
				-- end
				-- if pie.BeginPieMenu('Test 7') then 
					
				-- 	pie.EndPieMenu()
				-- end
				pie.EndPieMenu()
			end
			
			pie.EndPiePopup()
		end
		imgui.End()
	end
)
----------------------------------- UPDATE GUI -----------------------------
imgui.OnFrame(
    function() return MODULE.Update.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.CIRCLE_INFO .. u8" Доступно обновление хелпера ".. fa.CIRCLE_INFO .. "##update_window", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		if not isMonetLoader() then change_dpi() end
		imgui.CenterText(u8("Список изменений в новой версии:"))
		imgui.Text(u8(MODULE.Update.info))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Не обновлять ' .. fa.CIRCLE_XMARK, imgui.ImVec2(250 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			MODULE.Update.Window[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.DOWNLOAD ..u8' Загрузить ' .. u8(MODULE.Update.version) .. ' ' .. fa.DOWNLOAD, imgui.ImVec2(250 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			if thisScript().version:find('VIP') then
				sampAddChatMessage('[Arizona Helper] {ffffff}Используйте команду /helper в нашем Telegram/Discord VIP боте!', message_color)
			else
				download_file = 'helper'
				downloadFileFromUrlToPath(MODULE.Update.url, getWorkingDirectory():gsub('\\','/') .. "/Arizona Helper.lua")
			end
			MODULE.Update.Window[0] = false
		end
		imgui.End()
    end
)
----------------------------------- Other GUI -----------------------------
imgui.OnFrame(
    function() return MODULE.RPWeapon.Window[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.GUN .. u8" RP отыгровка оружия в чате " .. fa.GUN, MODULE.RPWeapon.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
        imgui.PushItemWidth(385 * settings.general.custom_dpi)
        imgui.InputTextWithHint(u8'##inputsearch_weapon_name', u8('Вводите чтобы искать оружие по его ID или названию...'), MODULE.RPWeapon.input_search, 256) 
		imgui.SameLine()
		if imgui.Button(u8("Включить всё")) then
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				value.enable = true
			end
			save_module('rpgun')
		end		
		imgui.SameLine()
		if imgui.Button(u8("Отключить всё")) then
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				value.enable = false
			end
			save_module('rpgun')
		end		
		if imgui.BeginChild('##rpguns1', imgui.ImVec2(588 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.Columns(3)
			imgui.CenterColumnText(u8"Работоспособность")
			imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8"ID и название оружия")
			imgui.SetColumnWidth(-1, 300 * settings.general.custom_dpi)
			imgui.NextColumn()
			imgui.CenterColumnText(u8"Расположение")
			imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
			imgui.Columns(1)
			imgui.Separator()
			local decoded_input = u8:decode(ffi.string(MODULE.RPWeapon.input_search))
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				if decoded_input == '' or (value.name and value.name:upper():find(decoded_input:upper())) or value.id == tonumber(decoded_input) then
					imgui.Columns(3)
					if value.enable then
						if imgui.CenterColumnSmallButton(fa.SQUARE_CHECK .. u8'  (работает)##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
							value.enable = not value.enable
							save_module('rpgun')
						end
					else
						if imgui.CenterColumnSmallButton(fa.SQUARE .. u8' (отключён)##' .. index, imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
							value.enable = not value.enable
							save_module('rpgun')
						end
					end
					imgui.NextColumn()
					imgui.CenterColumnText('[' .. value.id .. '] ' .. u8(value.name))
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##weapon_name' .. index) then
						_G.weapon_input = imgui.new.char[256]()
						imgui.StrCopy(_G.weapon_input, u8(value.name))
						imgui.OpenPopup(fa.GUN .. u8' Название оружия ' .. fa.GUN .. '##weapon_name' .. index)
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.GUN .. u8' Название оружия ' .. fa.GUN .. '##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
						change_dpi()
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.InputText(u8'##weapon_name', _G.weapon_input, 256) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							value.name = u8:decode(ffi.string(_G.weapon_input))
							save_module('rpgun')
							initialize_guns()
							_G.weapon_input = nil
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.NextColumn()
					local position = ''
					if value.rpTake == 1 then
						position = 'Спина'
					elseif value.rpTake == 2 then
						position = 'Карман'
					elseif value.rpTake == 3 then
						position = 'Пояс'
					elseif value.rpTake == 4 then
						position = 'Кобура'
					end
					imgui.CenterColumnText(u8(position))
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##weapon_position' .. index) then
						MODULE.RPWeapon.ComboTags[0] = value.rpTake - 1
						imgui.OpenPopup(fa.GUN .. u8' Расположение оружия##weapon_name' .. index)
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(fa.GUN .. u8' Расположение оружия##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
						change_dpi()
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.Combo(u8'##' .. index, MODULE.RPWeapon.ComboTags, MODULE.RPWeapon.ImItems, 4)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							send_no_vip_msg()
							value.rpTake = MODULE.RPWeapon.ComboTags[0] + 1
							save_module('rpgun')
							initialize_guns()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Separator()

				end
			end
			imgui.EndChild()
		end
        imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.CommandStop.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .. " Arizona Helper " .. getHelperIcon() .. "##MODULE.CommandStop.Window", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if isMonetLoader() and MODULE.Binder.state.isActive then
			if imgui.Button(fa.CIRCLE_STOP..u8' Остановить отыгровку ') then
				MODULE.Binder.state.isStop = true 
				MODULE.CommandStop.Window[0] = false
			end
		else
			MODULE.CommandStop.Window[0] = false
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return MODULE.CommandPause.Window[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .." Arizona Helper " .. getHelperIcon() .. "##MODULE.CommandPause.Window", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		if MODULE.Binder.state.isPause then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' Продолжить ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				MODULE.Binder.state.isPause = false
				MODULE.CommandPause.Window[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Полный STOP ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				MODULE.Binder.state.isStop = true 
				MODULE.Binder.state.isPause = false
				MODULE.CommandPause.Window[0] = false
			end
		else
			MODULE.CommandPause.Window[0] = false
		end
		imgui.End()
    end
)
---------------------------------- GUI ITEMS -----------------------------
function imgui.ToggleButton(str_id, bool)
    local rBool = false

    if LastActiveTime == nil then
        LastActiveTime = {}
    end
    if LastActive == nil then
        LastActive = {}
    end

    local function ImSaturate(f)
        return f < 0.0 and 0.0 or (f > 1.0 and 1.0 or f)
    end

    local p = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()

    local height = imgui.GetTextLineHeightWithSpacing()
    local width = height * 1.75
    local radius = height * 0.50
    local ANIM_SPEED = 0.25
    local butPos = imgui.GetCursorPos()

    if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
        bool[0] = not bool[0]
        rBool = true
        LastActiveTime[tostring(str_id)] = os.clock()
        LastActive[tostring(str_id)] = true
    end

    imgui.SetCursorPos(imgui.ImVec2(butPos.x + width + 8, butPos.y + 2.5))
    imgui.Text( str_id:gsub('##.+', '') )

    local t = bool[0] and 1.0 or 0.0

    if LastActive[tostring(str_id)] then
        local time = os.clock() - LastActiveTime[tostring(str_id)]
        if time <= ANIM_SPEED then
            local t_anim = ImSaturate(time / ANIM_SPEED)
            t = bool[0] and t_anim or 1.0 - t_anim
        else
            LastActive[tostring(str_id)] = false
        end
    end

	local toggle_bg = (settings.general.helper_theme ~= 2) and imgui.GetStyle().Colors[imgui.Col.FrameBg] or imgui.ImVec4(0.85, 0.85, 0.85, 1.0)
    local col_circle = bool[0] and imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.ButtonActive])) or imgui.ColorConvertFloat4ToU32(imgui.ImVec4(imgui.GetStyle().Colors[imgui.Col.TextDisabled]))
	dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), imgui.ColorConvertFloat4ToU32(toggle_bg), height * 0.6)
    dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2.0), p.y + radius), radius - 1.5, col_circle)
    return rBool
end
function imgui.TextQuestion(text)
    imgui.SameLine()
    imgui.TextDisabled('(?)')
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(text)
        imgui.EndTooltip()
    end
end
function imgui.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.Text(text)
end
function imgui.CenterTextDisabled(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
    imgui.TextDisabled(text)
end
function imgui.CenterColumnText(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.Text(text)
end
function imgui.CenterColumnTextDisabled(text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
    imgui.TextDisabled(text)
end
function imgui.CenterColumnColorText(imgui_RGBA, text)
    imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	imgui.TextColored(imgui_RGBA, text)
end
function imgui.CenterButton(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX( width / 2 - calc.x / 2 )
	if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.Button(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnSmallButton(text)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.SmallButton(text) then
		return true
	else
		return false
	end
end
function imgui.CenterColumnRadioButtonIntPtr(text, arg1, arg2)
	if text:find('(.+)##(.+)') then
		local text1, text2 = text:match('(.+)##(.+)')
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text1).x / 2)
	else
		imgui.SetCursorPosX((imgui.GetColumnOffset() + (imgui.GetColumnWidth() / 2)) - imgui.CalcTextSize(text).x / 2)
	end
    if imgui.RadioButtonIntPtr(text, arg1, arg2) then
		return true
	else
		return false
	end
end
function imgui.GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth() 
    local space = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or width/count - ((space * (count-1)) / count)
end
function safery_disable_cursor(gui)
	if not isMonetLoader() and not sampIsChatInputActive() and isSampAvailable() and not sampIsCursorActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then gui.HideCursor = true else gui.HideCursor = false end
end
function apply_dark_theme()
	imgui.SwitchContext()
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().Colors[imgui.Col.Text]                   = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextDisabled]           = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    imgui.GetStyle().Colors[imgui.Col.WindowBg]               = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ChildBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PopupBg]                = imgui.ImVec4(0.07, 0.07, 0.07, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Border]                 = imgui.ImVec4(0.25, 0.25, 0.26, 0.54)
    imgui.GetStyle().Colors[imgui.Col.BorderShadow]           = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered]         = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive]          = imgui.ImVec4(0.25, 0.25, 0.26, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBg]                = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive]          = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg]            = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab]          = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered]   = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive]    = imgui.ImVec4(0.51, 0.51, 0.51, 1.00)
    imgui.GetStyle().Colors[imgui.Col.CheckMark]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrab]             = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive]       = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Button]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered]          = imgui.ImVec4(0.21, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ButtonActive]           = imgui.ImVec4(0.41, 0.41, 0.41, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Header]                 = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered]          = imgui.ImVec4(0.20, 0.20, 0.20, 1.00)
    imgui.GetStyle().Colors[imgui.Col.HeaderActive]           = imgui.ImVec4(0.47, 0.47, 0.47, 1.00)
    imgui.GetStyle().Colors[imgui.Col.Separator]              = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered]       = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive]        = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip]             = imgui.ImVec4(1.00, 1.00, 1.00, 0.25)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered]      = imgui.ImVec4(1.00, 1.00, 1.00, 0.67)
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive]       = imgui.ImVec4(1.00, 1.00, 1.00, 0.95)
    imgui.GetStyle().Colors[imgui.Col.Tab]                    = imgui.ImVec4(0.12, 0.12, 0.12, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabHovered]             = imgui.ImVec4(0.28, 0.28, 0.28, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabActive]              = imgui.ImVec4(0.30, 0.30, 0.30, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused]           = imgui.ImVec4(0.07, 0.10, 0.15, 0.97)
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive]     = imgui.ImVec4(0.14, 0.26, 0.42, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLines]              = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered]       = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram]          = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered]   = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg]         = imgui.ImVec4(1.00, 0.00, 0.00, 0.35)
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget]         = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
    imgui.GetStyle().Colors[imgui.Col.NavHighlight]           = imgui.ImVec4(0.26, 0.59, 0.98, 1.00)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight]  = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg]      = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg]       = imgui.ImVec4(0.12, 0.12, 0.12, 0.95)
end
function apply_white_theme()
	imgui.SwitchContext()
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().Colors[imgui.Col.Text] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00);
    imgui.GetStyle().Colors[imgui.Col.WindowBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ChildBg] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
    imgui.GetStyle().Colors[imgui.Col.PopupBg] = imgui.ImVec4(0.94, 0.94, 0.94, 0.78);
    imgui.GetStyle().Colors[imgui.Col.Border] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
    imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00);
    imgui.GetStyle().Colors[imgui.Col.FrameBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
    imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TitleBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00) --imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00) --imgui.ImVec4(0.30, 0.29, 0.28, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.94, 0.94, 0.94, 0.70) --imgui.ImVec4(0.00, 0.00, 0.00, 0.51);
    imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.94, 0.94, 0.94, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.02, 0.02, 0.02, 0.00);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.31, 0.31, 0.31, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.41, 0.41, 0.41, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.51, 0.51, 0.51, 1.00);
    imgui.GetStyle().Colors[imgui.Col.CheckMark] = imgui.ImVec4(0.20, 0.20, 0.20, 1.00);
    imgui.GetStyle().Colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.00, 0.48, 0.85, 1.00);
    imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.80, 0.80, 0.80, 1.00);
    imgui.GetStyle().Colors[imgui.Col.Button] = imgui.ImVec4(0.88, 0.88, 0.88, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ButtonActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
    imgui.GetStyle().Colors[imgui.Col.Header] = imgui.ImVec4(0.88, 0.88, 0.88, 1.00);
    imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
    imgui.GetStyle().Colors[imgui.Col.Separator] = imgui.ImVec4(0.43, 0.43, 0.50, 0.50);
    imgui.GetStyle().Colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.10, 0.40, 0.75, 0.78);
    imgui.GetStyle().Colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.10, 0.40, 0.75, 1.00);
    imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = imgui.ImVec4(0.00, 0.00, 0.00, 0.25);
    imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(0.00, 0.00, 0.00, 0.67);
    imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(0.00, 0.00, 0.00, 0.95);
    imgui.GetStyle().Colors[imgui.Col.Tab] = imgui.ImVec4(0.88, 0.88, 0.88, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TabHovered] = imgui.ImVec4(0.88, 1.00, 1.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TabActive] = imgui.ImVec4(0.80, 0.89, 0.97, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.07, 0.10, 0.15, 0.97);
    imgui.GetStyle().Colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.14, 0.26, 0.42, 1.00);
    imgui.GetStyle().Colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1.00);
    imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1.00, 0.43, 0.35, 1.00);
    imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00);
    imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(0.00, 0.47, 0.84, 1.00);
    imgui.GetStyle().Colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90);
    imgui.GetStyle().Colors[imgui.Col.NavHighlight] = imgui.ImVec4(0.26, 0.59, 0.98, 1.00);
    imgui.GetStyle().Colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70);
    imgui.GetStyle().Colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20);
    imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.8);
end
function apply_moonmonet_theme()
	local generated_color = moon_monet.buildColors(settings.general.moonmonet_theme_color, 1.0, true)
	imgui.SwitchContext()
	imgui.GetStyle().WindowPadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5 * settings.general.custom_dpi, 5 * settings.general.custom_dpi)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2 * settings.general.custom_dpi, 2 * settings.general.custom_dpi)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().GrabMinSize = 10 * settings.general.custom_dpi
    imgui.GetStyle().WindowBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().ChildBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().PopupBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().FrameBorderSize = 1 * settings.general.custom_dpi
    imgui.GetStyle().TabBorderSize = 1 * settings.general.custom_dpi
	imgui.GetStyle().WindowRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ChildRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().FrameRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().PopupRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().ScrollbarRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().GrabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().TabRounding = 8 * settings.general.custom_dpi
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)
	imgui.GetStyle().Colors[imgui.Col.Text] = ColorAccentsAdapter(generated_color.accent2.color_50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextDisabled] = ColorAccentsAdapter(generated_color.neutral1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.WindowBg] = ColorAccentsAdapter(generated_color.accent2.color_900):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ChildBg] = ColorAccentsAdapter(generated_color.accent2.color_800):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PopupBg] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Border] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Separator] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
	imgui.GetStyle().Colors[imgui.Col.FrameBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x60):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x70):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.FrameBgActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x50):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBg] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgCollapsed] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0x7f):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TitleBgActive] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.MenuBarBg] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x91):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0,0,0,0)
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x85):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ScrollbarGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.CheckMark] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.SliderGrabActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0x80):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Button] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ButtonActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Tab] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabActive] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TabHovered] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.Header] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.HeaderActive] = ColorAccentsAdapter(generated_color.accent1.color_600):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGrip] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xcc):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripHovered] = ColorAccentsAdapter(generated_color.accent2.color_700):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ResizeGripActive] = ColorAccentsAdapter(generated_color.accent2.color_700):apply_alpha(0xb3):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLines] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotLinesHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogram] = ColorAccentsAdapter(generated_color.accent2.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.PlotHistogramHovered] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.TextSelectedBg] = ColorAccentsAdapter(generated_color.accent1.color_600):as_vec4()
	imgui.GetStyle().Colors[imgui.Col.ModalWindowDimBg] = ColorAccentsAdapter(generated_color.accent1.color_200):apply_alpha(0x99):as_vec4()
end
function argbToRgbNormalized(argb)
    local a = math.floor(argb / 0x1000000) % 0x100
    local r = math.floor(argb / 0x10000) % 0x100
    local g = math.floor(argb / 0x100) % 0x100
    local b = argb % 0x100
    local normalizedR = r / 255.0
    local normalizedG = g / 255.0
    local normalizedB = b / 255.0
    return {normalizedR, normalizedG, normalizedB}
end
function argbToHexWithoutAlpha(alpha, red, green, blue)
    return string.format("%02X%02X%02X", red, green, blue)
end
function rgba_to_argb(rgba_color)
    local r = bit32.band(bit32.rshift(rgba_color, 24), 0xFF)
    local g = bit32.band(bit32.rshift(rgba_color, 16), 0xFF)
    local b = bit32.band(bit32.rshift(rgba_color, 8), 0xFF)
    local a = bit32.band(rgba_color, 0xFF)
    local argb_color = bit32.bor(bit32.lshift(a, 24), bit32.lshift(r, 16), bit32.lshift(g, 8), b)
    return argb_color
end
function join_argb(a, r, g, b)
    local argb = b 
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))    
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end
function explode_argb(argb)
    local a = bit.band(bit.rshift(argb, 24), 0xFF)
    local r = bit.band(bit.rshift(argb, 16), 0xFF)
    local g = bit.band(bit.rshift(argb, 8), 0xFF)
    local b = bit.band(argb, 0xFF)
    return a, r, g, b
end
function rgba_to_hex(rgba)
    local r = bit.rshift(rgba, 24) % 256
    local g = bit.rshift(rgba, 16) % 256
    local b = bit.rshift(rgba, 8) % 256
    local a = rgba % 256
    return string.format("%02X%02X%02X", r, g, b)
end
function ARGBtoRGB(color) 
	return bit.band(color, 0xFFFFFF) 
end
function ColorAccentsAdapter(color)
    local a, r, g, b = explode_argb(color)
    local ret = {a = a, r = r, g = g, b = b}
    function ret:apply_alpha(alpha)
        self.a = alpha
        return self
    end
    function ret:as_u32()
        return join_argb(self.a, self.b, self.g, self.r)
    end
    function ret:as_vec4()
        return imgui.ImVec4(self.r / 255, self.g / 255, self.b / 255, self.a / 255)
    end
    function ret:as_argb()
        return join_argb(self.a, self.r, self.g, self.b)
    end
    function ret:as_rgba()
        return join_argb(self.r, self.g, self.b, self.a)
    end
    function ret:as_chat()
        return string.format("%06X", ARGBtoRGB(join_argb(self.a, self.r, self.g, self.b)))
    end  
    return ret
end
function change_dpi()
	imgui.PushFont(MODULE.FONT) 
end
function getHelperIcon()
	local modes = {
		{'police', fa.BUILDING_SHIELD},
		{'fbi', fa.BUILDING_SHIELD},
		{'army', fa.BUILDING_SHIELD},
		{'prison', fa.BUILDING_SHIELD},
		{'hospital', fa.HOSPITAL},
		{'smi', fa.BUILDING_NGO},
		{'gov', fa.BUILDING_COLUMNS},
		{'fd', fa.HOTEL},
		{'mafia', fa.TORII_GATE},
		{'ghetto', fa.BUILDING_WHEAT},
		{'none', fa.BUILDING_CIRCLE_XMARK}
	}
	for index, value in ipairs(modes) do
		if isMode(value[1]) then
			return value[2]
		end
	end
	return fa.BUILDING
end
function getUserIcon()
	local modes = {
		{'police', fa.USER_NURSE},
		{'fbi', fa.USER_NURSE},
		{'army', fa.PERSON_MILITARY_RIFLE},
		{'prison', fa.PERSON_MILITARY_RIFLE},
		{'hospital', fa.USER_DOCTOR},
		{'fd', fa.USER_ASTRONAUT},
		{'lc', fa.USER_TIE},
		{'ins', fa.USER_TIE},
		{'mafia', fa.USER_NINJA},
		{'ghetto', fa.USER_NINJA}
	}
	for index, value in ipairs(modes) do
		if isMode(value[1]) then
			return value[2]
		end
	end
	return fa.USER
end

function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		if MODULE.InfraredVision then setInfraredVision(false) end
		if MODULE.NightVision then setNightVision(false) end
		sampAddChatMessage('[Arizona Helper] {ffffff}Произошла неизвестная ошибка, хелпер приостановил свою работу!', message_color)
		if not isMonetLoader() then 
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}чтобы перезапустить хелпер.', message_color)
		end
    end
end
