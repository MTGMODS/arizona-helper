---@diagnostic disable: undefined-global, need-check-nil, lowercase-global, cast-local-type, unused-local

script_name("Arizona Helper")
script_description('This is a Cross-platform Lua script-helper for Arizona Online players work in fractions')
script_author("MTG MODS")
script_version("BETA 3.1")

print('[Arizona Helper] Скрипт успешно запущен. Версия: ' .. thisScript().version)

require('lib.moonloader')
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local ffi = require('ffi')
local effil = require('effil')
local imgui = require('mimgui')
local fa = require('fAwesome6_solid')
local sampev = require('samp.events')
local sizeX, sizeY = getScreenResolution()

-------------------------------------------- JSON SETTINGS -------------------------------------------
local configDirectory = getWorkingDirectory():gsub('\\','/') .. "/Arizona Helper"
local settings = {}
local default_settings = {
	general = {
		version = thisScript().version,
        custom_dpi = 1.0,
		autofind_dpi = false,
        helper_theme = 1,
		message_color = 40703,
		moonmonet_theme_color = 40703,
		fraction_mode = '',
		mobile_fastmenu_button = true,
		mobile_stop_button = true,
		bind_mainmenu = '[113]',
		bind_fastmenu = '[69]',
		bind_leader_fastmenu = '[71]',
		bind_action = '[13]',
		bind_command_stop = '[123]',
        rp_gun = true,
		auto_uval = false,
		anti_trivoga = true,
		use_taser_menu = true,
		auto_notify_payday = true,
		auto_clicker_situation = true,
		auto_update_members = true,
		auto_accept_docs = true,
		probiv_api_key = ''
	},
	player_info = {
		name_surname = '',
		fraction = 'none',
		fraction_tag = 'none',
		fraction_rank = 'none',
		fraction_rank_number = 0,
		sex = 'Неизвестно',
		accent_enable = true,
		accent = '[Иностранный акцент]:',
		rp_chat = true,
	},
	deportament = {
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
		info_menu = {x = sizeX * 0.03, y = sizeY * 0.53},
		patrool_menu = {x = sizeX / 2, y = sizeY / 2},
		wanteds_menu = {x = sizeX / 1.2, y = sizeY / 2},
		mobile_fastmenu_button = {x = sizeX / 8.5, y = sizeY / 2.3},
		taser = {x = sizeX / 4.2, y = sizeY / 2.1},
	},
    mj = {
        auto_mask = true,
		auto_time = true,
		auto_doklad_patrool = true,
		auto_doklad_damage = true,
		auto_doklad_arrest = true,
		auto_change_code_siren = true,
		auto_update_wanteds = true,
		awanted = false,
		auto_documentation = true,
		mobile_meg_button = true,
		use_info_menu = true, 
    },
	md = {
		auto_doklad_patrool = true,
		auto_doklad_damage = true,
	},
	mh = {
		heal_in_chat = true,
		auto_heal = false,
		price = {
			ant = 50000,
			recept = 50000,
			heal = 100000,
			heal_vc = 100,
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
	},
	lc = {
		auto_clicker = true,
		auto_repair = true,
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
	},

}
function load_settings()
    if not doesDirectoryExist(configDirectory) then
        createDirectory(configDirectory)
    end
    if not doesFileExist(configDirectory .. "/Settings.json") then
        settings = default_settings
		print('[Arizona Helper] Файл с настройками не найден, использую стандартные настройки!')
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
						print('[Arizona Helper] Новая версия, сброс настроек!')
						settings = default_settings
						save_settings()
						reload_script = true
					else
						print('[Arizona Helper] Настройки успешно загружены!')
					end
				else
					print('[Arizona Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
				end
			else
                settings = default_settings
				print('[Arizona Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
			end
        else
            settings = default_settings
			print('[Arizona Helper] Не удалось открыть файл с настройками, использую стандартные настройки!')
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
			end
			local ok, encoded = pcall(encodeJson, array)
			if ok then return encoded else return {} end
		end
		local content = looklike(settings)
		if content and #content ~= 0 then
			file:write(content)
			print('[Arizona Helper] Настройки хелпера сохранены!')
		else
			print('[Arizona Helper] Не удалось сохранить настройки хелпера! Ошибка кодировки json')
		end
		file:close()
    else
        print('[Arizona Helper] Не удалось сохранить настройки хелпера, ошибка: ', errstr)
    end
end
load_settings()
-------------------------------------------- JSON MODULES ---------------------------------------------
local modules = {
	commands = {
		name = 'Команды',
		path = configDirectory .. "/Commands.json",
		data = {
			commands = {
				my = {
					{ cmd = 'time' , description = 'Посмотреть время' ,  text = '/me взглянул{sex} на свои часы с гравировкой Arizona Helper и посмотрел{sex} время&/time&/do На часах видно время {get_time}.' , arg = '' , enable = true, waiting = '1.5' , bind = "{}" },
					{ cmd = 'cure' , description = 'Поднять игрока из стадии' ,  text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека начало биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}"},
					},
				police = {
					{ cmd = '55', description = 'Проведение 10-55', text = '/r {my_doklad_nick} на CONTROL. Провожу 10-55 в районе {get_area} ({get_square}), СODE 4.&/m Водитель{get_storecar_model}, внимание!&/m Немедленно снизьте скорость и прижмитесь к обочине!&/m После остановки заглушите двигатель, держите руки на руле и не выходите из транспорта.&/m В случае неподчинения вы будете обьявлены в розыск, и по вам будет открыт огонь!', arg = '', enable = true, waiting = '1.5', bind = "[101]" },
					{ cmd = '66', description = 'Проведение 10-66', text = '/r {my_doklad_nick} на CONTROL. Провожу 10-66 в районе {get_area} ({get_square}), СODE 3!&/m Водитель{get_storecar_model}, внимание!&/m Немедленно снизьте скорость и прижмитесь к обочине!&/m В случае неподчинения вы будете обьявлены в розыск, и по вам будет открыт огонь!', arg = '', enable = true, waiting = '1.5', bind = "[102]" },
					{ cmd = 'zd' , description = 'Приветствие игрока' , text = 'Здраствуйте {get_ru_nick({arg_id})}&Я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}"},
					{ cmd = 'bk' , description = 'Запрос помощи с координатами' , text = '/r {my_doklad_nick} на CONTROL. Срочно нужна помощь, высылаю свои координаты. CODE 1&/me достаёт свой КПК и отправляет координаты в базу данных {fraction_tag}&/bk 10-20', arg = '' , enable = true , waiting = '1.5', bind = "{}" },
					{ cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}" },
					{ cmd = 'fara' , description = 'Оставить отпечаток на фаре' , text = '/me легким движеним руки ', arg = '' , enable = true , waiting = '1.5', bind = "{}" },
					{ cmd = 'pas' , description = 'Запросить документы' ,  text = 'Здраствуйте, управление {fraction_tag}, я {fraction_rank} {my_ru_nick}&/do Cлева на груди жетон полицейского, справа именная нашивка с именем.&/me  достаёт своё удостоверение из кармана&/showbadge {arg_id}&Прошу предъявить документ, удостоверяющий вашу личность.&/n {get_nick({arg_id})}, введите /showpass {my_id}' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{ cmd = 'ts' , description = 'Выписать штраф' ,  text = '/do Бланк протокола и ручка находяться в нагрудном кармане.&/me достаёт из нагрудного кармана бланк протокола и ручку.&/me вписывает в бланк данные нарушителя&/writeticket {arg_id} {arg2}&/do Бланк протокола заполнен.&/me передаёт бланк со штрафом нарушителю для дальнейшей оплаты' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'pr' , description = 'Погоня за игроком' ,  text = '/me достаёт свой КПК и заходит в базу данных {fraction_tag}&/me открывает дело гражданина N-{arg_id} и нажимает на кнопку отслеживание местоположения&/pursuit {arg_id}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'find' , description = 'Поиск игрока' ,  text = '/do КПК висит на поясном держателе.&/me достаёт свой КПК и включает его&/me заходит в базу данных {fraction_tag} и открывает дело гражданина N-{arg_id}&/do Данные успешно получены.&/me устанавливает в свой навигатор координаты гражданина N-{arg_id}&/do Навигатор получил координаты и построил ближайший путь.&/find {arg_id}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'su' , description = 'Выдать розыск' ,  text = '/me достаёт свой КПК и открывает базу данных преступников&/me вносит изменения в базу данных преступников&/do Преступник занесён в базу данных преступников.&/su {arg_id} {arg2} {arg3}&/z {arg_id}' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.5' , bind = "{}" },
					{ cmd = 'fsu' , description = 'Запросить выдачу розыска' ,  text = '/do Рация на тактическом поясе.&/me достаёт рацию и связавается с диспетчером&/me передаёт диспетчеру запрос на внесение человека в базу данных преступников&/r {my_doklad_nick} на CONTROL.&/r Прошу обьявить в розыск {arg2} степени дело N{arg_id}. Причина: {arg3}' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'givefsu' , description = 'Выдача розыска по запросу офицера' ,  text = '/do Рация на тактическом поясе.&/me достаёт рацию и связавается с офицером для уточнения данных&/r 10-4, выдаю розыск по запросу офицера {get_rp_nick({arg_id})}!&/me достаёт свой КПК и открывает базу данных преступников&/me вносит изменения в базу данных преступников&/do Преступник занесён в базу данных преступиков.&/su {get_form_su} (по запросу офицера {get_rp_nick({arg_id})})&' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'unsu' , description = 'Понизить розыск' ,  text = '/me достаёт свой КПК и открывает базу данных преступников&/me ищёт дело N{arg_id} и вносит изменения в базу данных преступников&/unsu {arg_id} {arg2} {arg3}&/do Преступику понижен степень розыска.' , arg = '{arg_id} {arg2} {arg3}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'clear' , description = 'Снять розыск' ,  text = '/me достаёт свой КПК и открывает базу данных преступников&/me ищёт дело N{arg_id} и вносит изменения в базу данных преступников&/clear {arg_id}&/do Дело N{arg_id} больше не находится в списке разыскиваемых преступников.' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'cuff' , description = 'Надеть наручники' ,  text = '/do Наручники на тактическом поясе.&/me снимает наручники с пояса и надевает их на задержанного&/cuff {arg_id}&/do Задержанный в наручниках.' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}" , in_fastmenu = true},
					{ cmd = 'uncuff' , description = 'Снять наручники' ,  text = '/do На тактическом поясе прикреплены ключи от наручников.&/me снимает с пояса ключ от наручников и вставляет их в наручники задержанного&/me прокручивает ключ в наручниках и снимает их с задержанного&/uncuff {arg_id}&/do Наручники сняты с задержанного&/me кладёт ключ и наручники обратно на тактический пояс', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },
					{ cmd = 'gtm' , description = 'Повести за собой' ,  text = '/me схватывает задержанного за руки и ведёт его за собой&/gotome {arg_id}&/do Задержанный идёт в конвое.', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },
					{ cmd = 'ungtm' , description = 'Перестать вести за собой' ,  text = '/me отпускает руки задержанного и перестаёт вести его за собой&/ungotome {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },
					{ cmd = 'gcuff' , description = 'Надеть наручники и вести за собой' ,  text = '/do Наручники на тактическом поясе.&/me снимает наручники с пояса и надевает их на задержанного&/cuff {arg_id}&/do Задержанный в наручниках.&/me схватывает задержанного за руки и ведёт его за собой&/do Задержанный идёт в конвое.&/gotome {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}" },
					{ cmd = 'bot' , description = 'Изьять скрепки у игрока (взлом наручников)' ,  text = '/me увидел что задержанный использует скрепки для взлома наручников&/todo Вы что себе позволяете?!*изымая скрепки у {get_rp_nick({arg_id})}&/bot {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true },
					{ cmd = 'ss' , description = 'Кричалка' ,  text = '/s Всем поднять руки вверх, работает {fraction_tag}!', arg = '', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 't' , description = 'Достать тазер' ,  text = '/taser', arg = '', enable = true, waiting = '1.5', bind = "[18,49]" },
					{ cmd = 'frl' , description = 'Первичный обыск' ,  text = 'Сейчас я проверю у вас наличие оружия или других острых предметов, не двигайтесь.&/me прощупывает тело задержанного человека&/me прощупывает карманы задержанного человека', arg = '', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 'fr' , description = 'Полный обыск' ,  text = '/do Резиновые перчатки на тактическом поясе.&/todo Сейчас я полностю обыщу вас, на наличие запрещенных предметов*надевая резиновые перчатки&/me прощупывает тело и карманы задержанного человека&/me достаёт из карманов задержанного все его вещи для изучения&/me внимательно осматривает все найденные вещи у задержанного человека&/frisk {arg_id}&/me снимает резиновые перчатки и убирает их на тактический пояск&/do Блокнот с ручкой в нагрудном кармане.&/me берет в руки блокнот с ручкой, и записывает всю информацию про обыск&/me сделав пометки, убирает блокнот с ручкой в нагрудный карман', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },
					{ cmd = 'take' , description = 'Изьятие предметов игрока' , text = '/do В подсумке находиться небольшой зип-пакет.&/me достаёт из подсумка зип-пакет и отрывает его&/me кладёт в зип-пакет изьятые предметы задержанного человека&/take {arg_id}&/do Изьятые предметы в зип-пакете.&/todo Отлично*убирая зип-пакет в подсумок', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true  },
					{ cmd = 'camon' , description = 'Включить cкрытую боди камеру' ,  text = '/do К форме прикреплена скрытая боди камера.&/me незаметным движением руки включил{sex} боди камеру.&/do Скрытая боди камера включена и снимает всё происходящее.', arg = '', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 'camoff' , description = 'Выключить cкрытую боди камеру' ,  text = '/do К форме прикреплена скрытая боди камера.&/me незаметным движением руки выключил{sex} боди камеру.&/do Скрытая боди камера выключена и больше не снимает всё происходящее.', arg = '', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 'inc' , description = 'Затащить в транспорт' ,  text = '/me открывает заднюю дверь транспорта&/todo Наклоните голову, здесь дверь*затаскивая задержанного в транспортное средство&/incar {arg_id} {arg2}&/me закрывает заднюю дверь транспорта&/do Задержанный в транспортном средстве.', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 'ej' , description = 'Выбросить из транспорта',  text = '/me открывает дверь транспорта&/me помогает человеку выйти из транспорта&/eject {arg_id}&/me закрывает дверь транспорта', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },	
					{ cmd = 'pl' , description = 'Выбросить игрока из его транспорта',  text = '/me резким ударом дубинки разбивает стело транспорта задержанного&/pull {arg_id}&/me выбрасывает задержанного из его транспорта и ударом дубинки оглушает его', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },	
					{ cmd = 'mr' , description = 'Зачитать правило Миранды',  text = 'Вы имеете право хранить молчание.&Всё, что вы скажете, может и будет использовано против вас в суде.&Вы имеете право на 1 телефонный звонок, например для вызова частного адвоката.&Ваш адвокат может присутствовать при допросе.&Если вы не можете оплатить услуги адвоката, он будет предоставлен вам государством.&Вам ясны Ваши права?', arg = '', enable = true, waiting = '1.5', bind = "{}" },	
					{ cmd = 'unmask' , description = 'Снять балаклаву с игрока',  text = '/do Задержанный в балаклаве.&/me стягивает балаклаву с головы задеражнного&/unmask {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}" , in_fastmenu = true},
					{ cmd = 'arr' , description = 'Арестовать (в участке)',  text = '/me включает свой бортовой компютер и вводит код доступа сотрудника&/me заходит в раздел оформления протоколов задержаний и указывает данные&/do Протокол задержания заполнен.&/me вызывает по рации дежурный наряд участка и передаёт им задержанного человека&/arrest', arg = '', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },
					{ cmd = 'drugs' , description = 'Провести Drugs Test' ,  text = '/do На тактическом поясе прикреплён подсумок.&/me открывает подсумок и достаёт из него набор Drugs Test&/me берёт из набора пробирку с этиловым спиром&/me засыпает найденное вещество в пробирку&/me достаёт из подсумка тест Имуно-Хром-10 и добавляет его в пробирку&/do В пробирке с этиловым спиртом находится неизвестное вещество и Имуно-Хром-10.&/me акуратными движениями взбалтывает пробирку&/do От теста Имуно-Хром-10 содержимое пробирки сменило цвет.&/todo Да, это точно наркотики*увидев что содержимое пробирки сменило цвет&/me убирает пробирку обратно в подсумок и закрывает его', arg = '', enable = true, waiting = '1.5', bind = "{}"},
					{ cmd = 'rbomb' , description = 'Деактивировать бомбу' ,  text = '/do На тактическом поясе прикреплён сапёрный набор.&/me снимает с пояса сапёрный набор и кладет его на землю, затем открывает его&/do Открытый сапёрный набор находится на земле.&/me достаёт из сапёрного набора пакет с жидким азотом и кладет его на землю&/me достаёт из сапёрного набора отвёртку&/do Отвертка в руках, а пакет с жидким азотом на земле.&/do На корпусе бомбы находится 2 болтика.&/me откручивает болтики с бомбы и убирает их вместе с отвёрткой в сторону&/me акуратным движением руки вскрывает крышку бомбы&/me внимательно осматривает бомбу&/do Внутри бомбы видна детонирующая часть.&/me достаёт из сапёрного набора кусачки&/do Кусачки в руках.&/me акуратным движением кусочок разрезает красный провод бомбы&/do Таймер остановился, тиканье со стороны бомбы не слышно.&/me берёт в руки охлаждающий пакет с жидким азотом и кладёт его детонирующую часть бомбы&/removebomb&/do Бомба обезврежена.&/me убирает кусачки и отвёртку обратно в саперный набор и закрывает его', arg = '', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 'delo' , description = 'Расследование убийства' ,  text = '/do Сотрудник прибыл на место убийства.&/todo Такс, что же здесь произошло*осматривая место убийства&/me осматривает и  изучает все улики&{pause}&/me достаёт из подсумка бланк для расследования и ручку&/me заполняет бланк расследования записывая все изученные улики&{pause}&/me записывает в бланк точную дату и время убийства&{pause}&/do Найдено орудие убийства.&/me записывает в бланк орудие убийства&{pause}&/do Бланк расследования убийства полностю заполнен.&/todo Отлично, расследование окончено*убирая бланк в карман', arg = '', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 'giveplate' , description = 'Выдача разрешений на номера' ,  text = '/do Бланк и ручка в нагрудном кармане.&/me достаёт ручку и бланк из нагрудного кармана&/me заполняет бланк для выдачу разрешения на номерной знак&/do Бланк полностю заполнен.&/todo Вот ваше разрешение, берите*убирая ручку в нагрудный карман&/giveplate {arg_id} {arg2}&/n {get_nick({arg_id})}, введите /offer и примите, чтобы получить разрешение на номерной знак.', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5', bind = "{}" },
					{ cmd = 'agenda' , description = 'Выдача повестки игроку' ,  text = '/do В папке с документами лежит ручка и пустой бланк с надписью Повестка.&/me достаёт из папки ручку с пустым бланком повестки&/me начинает заполнять все необходимые поля на бланке повестки&/do Все данные в повестке заполнены.&/me ставит на повестку штамп и печать {fraction_tag}&/do Готовый бланк повестки в руках.&/todo Не забудьте явиться в военкомат по указанному адресу и времени*передавая повестку&/agenda {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true },
				},
				fbi = { -- доп.команды для ФБР
					{ cmd = 'doc', description = 'Запросить документы (FBI)' ,  text = 'Здраствуйте, я {fraction_rank} {fraction_tag}&/do Cлева на груди спец-жетон ФБР.&/me указывает пальцем на свой спец-жетон на груди&Прошу предъявить документ, удостоверяющий вашу личность.&/n {get_nick({arg_id})}, введите /showpass {my_id} или /showbadge {my_id}' , arg = '{arg_id}' , enable = false , waiting = '1.5' , bind = "{}"},
					{ cmd = 'priton1', description = 'Обнаружен притон' ,  text = '/d ФБР - МЮ: В опасном районе найден наркопритон!&/d ФБР - МЮ: Желающие присоедениться к рейду - в гараж ЛСПД&/d ФБР - МЮ: Возьмите с собой оружие, бронижелет, и обязательно маску!' , arg = '' , enable = true , waiting = '1.5' , bind = "{}"},
					{ cmd = 'priton2', description = 'Прибытие на притон' ,  text = '/d ФБР - МЮ: Мы прибыли на територию наркопритона! Я куратор спец-операции.&/d ФБР - МЮ: Оцепляйте територию, и никого не вступайте на територию наркопритона.&/d ФБР - МЮ: Кусты срезают только агенты, остальные защищают!' , arg = '' , enable = true , waiting = '1.5' , bind = "{}"},
					{ cmd = 'priton3', description = 'Конец притона' ,  text = '/d ФБР - МЮ: Спец-операция "Притон" окончена!&/d ФБР - МЮ: Всем спасибо за участие, можете быть свободны!&/d ФБР - МЮ: Не забудьте убрать ограждения с территории.' , arg = '' , enable = true , waiting = '1.5' , bind = "{}"},
					{ cmd = 'dismiss' , description = 'Уволить госслужащего (1-4)' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me заходит в базу данных {fraction_tag} и переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/dismiss {arg_id} {arg2}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = false, waiting = '1.5', bind = "{}"},
				},
				army = {
					{ cmd = 'pas', description = 'Проверка документов (кпп)', text = 'Здравствуйте, я {fraction_rank} {fraction_tag} - {my_doklad_nick}.&/do Удостоверение находиться в левом кармане брюк.&/me достал{sex} удостоверение и раскрыл{sex} его перед человеком.&/do В удостоверении указано: {fraction} - {fraction_rank} {my_doklad_nick}.&Назовите причину прибытия на территорию на нашу базу.&И предоставьте мне свои документы для проверки!', arg = '', enable = true, waiting = '1.5', in_fastmenu = true  },
					{ cmd = 'agenda' , description = 'Выдача повестки игроку' ,  text = '/do В папке с документами лежит ручка и пустой бланк с надписью Повестка.&/me достаёт из папки ручку с пустым бланком повестки&/me начинает заполнять все необходимые поля на бланке повестки&/do Все данные в повестке заполнены.&/me ставит на повестку штамп и печать {fraction_tag}&/do Готовый бланк повестки в руках.&/todo Не забудьте явиться в военкомат по указанному адресу и времени*передавая повестку&/agenda {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{ cmd = 'cure', description = 'Поднять игрока из стадии', text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека началось биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь', arg = '{arg_id}', enable = true, waiting = '1.5' , in_fastmenu = true },
					{ cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}" },
				},
				prison = {
					{ cmd = 't' , description = 'Достать тазер' ,  text = '/taser', arg = '', enable = true, waiting = '1.5', },
					--  bind = "[18,49]"
					{ cmd = 'cuff', description = 'Надеть наручники', text = '/do Наручники на тактическом поясе.&/me снимает наручники с пояса и надевает их на задержанного&/cuff {arg_id}&/do Задержанный в наручниках.', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true },
					{ cmd = 'uncuff', description = 'Снять наручники', text = '/do На тактическом поясе прикреплены ключи от наручников.&/me снимает с пояса ключ от наручников и вставляет их в наручники задержанного&/me прокручивает ключ в наручниках и снимает их с задержанного&/uncuff {arg_id}&/do Наручники сняты с задержанного&/me кладёт ключ и наручники обратно на тактический пояс', arg = '{arg_id}', enable = true, waiting = '1.5' , in_fastmenu = true},
					{ cmd = 'gotome', description = 'Повести за собой', text = '/me схватывает задержанного за руки и ведёт его за собой&/gotome {arg_id}&/do Задержанный идёт в конвое.', arg = '{arg_id}', enable = true, waiting = '1.5' , in_fastmenu = true},
					{ cmd = 'ungotome', description = 'Перестать вести за собой', text = '/me отпускает руки задержанного и перестаёт вести его за собой&/ungotome {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5' , in_fastmenu = true},
					{ cmd = 'take', description = 'Изьятие предметов игрока', text = '/do В подсумке находиться небольшой зип-пакет.&/me достаёт из подсумка зип-пакет и отрывает его&/me кладёт в зип-пакет изьятые предметы задержанного человека&/take {arg_id}&/do Изьятые предметы в зип-пакете.&/todo Отлично*убирая зип-пакет в подсумок', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true },
					{cmd = 'carcer', description = 'Посадка игрока в карцер',text = '/do На поясе висит связка ключей.&/me прислонив заключённого к стене, снял ключ со связки, открыл дверцу камеры&/me лёгкими движениями рук затолкнул заключённого в камеру, после чего закрыл её&/me лёгкими движениями рук закрепил ключ к связке&/carcer {arg_id} {arg2} {arg3} {arg4}',arg = '{arg_id} {arg2} {arg3} {arg4}', enable = true, waiting = '1.5'},
					{cmd = 'setcarcer', description = 'Смена карцера игроку', text = '/do На поясе висит связка ключей.&/me лёгкими движениями рук снял ключ со связки, открыл свободную камеру и камеру заключённого&/me вытолкнул заключённого из первой камеры, затолкнул во вторую, закрыв двери обоих камер&/me лёгкими движениями рук закрепил ключ к связке&/setcarcer {arg_id} {arg2}', arg = '{arg_id}, {arg2}', enable = true, waiting = '1.5'},
					{ cmd = 'uncarcer', description = 'Выпуск игрока из карцера', text = '/do На поясе висит связка ключей.&/me движениями рук снял ключ со связки, открыл камеру и вытолкнул из неё заключённого&/me закрыл дверцу камеры, закрепил ключ к связке&/uncarcer {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5' },
					{ cmd = 'frisk', description = 'Обыск заключённого', text = '/do Перчатки на поясе.&/me схватил перчатки и одел&/do Перчатки одеты.&/me начал нащупывать человека напротив&/frisk {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true },
					{ cmd = 'punishsu', description = 'Повысить уровень наказания.', text ='/me достаёт свой КПК и открывает базу данных тюрьмы&/me вносит изменения в базу данных тюрьмы&/do Изменения занесены в базу данных тюрьмы.&/punish {arg_id} {arg2} 2 {arg3}', arg = '{arg_id} {arg2} {arg3}', enable = true, waiting = '1.5'},
					{cmd = 'punishclear', description = 'Понизить уровень наказания', text = '/me достаёт блокнот из нагрудного кармана&/do Блокнот в руке.&/me открывает его на странице с записями о поведении заключённых.&/do В блокноте видна запись: "{get_rp_nick({arg_id})}, примерное поведение...&/do ...участие в уборке территории, отсутствие нарушений."&/me берёт ручку и записывает новую информацию о заключённом.&/do В блокноте добавлена запись: "Рекомендация на сокращение срока...&/do ...на {arg2} года за добросовестное выполнение обязанностей."&/me закрывает блокнот и убирает его обратно в карман формы.&/do Данные о заключённом зафиксированы...&/do ...для последующего рассмотрения администрацией.', arg = '{arg_id} {arg2} {arg3}', enable = true, waiting = '1.5'},
				},
				hospital = {	
					{ cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}" },
					{ cmd = 'hme' , description = 'Лечение самого себя' ,  text = '/me достаёт из своего мед.кейса лекарство и принимает его&/heal {my_id} {price_heal}' , arg = '' , enable = true, waiting = '1.5', bind = "{}"},
					{ cmd = 'zd' , description = 'Привествие игрока' , text = 'Здраствуйте {get_ru_nick({arg_id})}&Я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{ cmd = 'go' , description = 'Позвать игрока за собой' , text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{ cmd = 'hl' , description = 'Обычное лечение игрока' , text = '/me достаёт из своего мед.кейса нужное лекарство и передаёт его человеку напротив&/todo Принимайте это лекарство, оно вам поможет*улыбаясь&/heal {arg_id} {price_heal}&/n {get_nick({arg_id})}, примите предложение в /offer чтобы вылечиться!', arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{ cmd = 'hla' , description = 'Лечение охранника игрока' ,  text = '/me достаёт из своего мед.кейса лекарство и передаёт его человеку напротив&/todo Давайте своему охраннику это лекарство, оно ему поможет*улыбаясь&/healactor {arg_id} {price_actorheal}&/n {get_nick({arg_id})}, примите предложение в /offer чтобы вылечить охранника!' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{ cmd = 'hlb' , description = 'Лечение игрока от наркозависимости' ,  text = '/me достаёт из своего мед.кейса таблетки от наркозависимости и передаёт их пациенту напротив&/todo Принимайте эти таблетки, и в скором времени Вы излечитесь от наркозависимости*улыбаясь&/healbad {arg_id}&/n {get_nick({arg_id})}, примите предложение в /offer чтобы вылечиться!' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},	
					{ cmd = 'cure' , description = 'Поднять игрока из стадии' ,  text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека началось биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь' , arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},	
					{ cmd = 'mt' , description = 'Мед.оcмотр для военного билета' ,  text = 'Хорошо, сейчас я проведу вам мед.осмотр для получения военного ... &... билета по стану здоровья, но шанс на успех всего 1 процент!&/mticket {arg_id} {price_mticket}&/n {get_nick({arg_id})}, примите предложение в /offer для начала мед.осмотра!' , arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}"},
					{ cmd = 'pilot' , description = 'Мед.осмотр для пилотов' ,  text = 'Хорошо, сейчас я проведу вам мед.осмотр для пилотов.&/medcheck {arg_id} {price_medosm}&/n {get_nick({arg_id})}, примите предложение в /offer для продолжения мед.осмотра!&/n Пока вы не примите предложение, мы не сможем начать!&{pause}&И так...&/me достаёт из мед.кейса стерильные перчатки и надевает их на руки&/do Перчатки на руках.&/todo Начнём мед.осмотр*улыбаясь.&Сейчас я проверю ваше горло, откройте рот и высуните язык.&/me достаёт из мед.кейса фонарик и включив его осматривает горло человека напротив&Хорошо, можете закрывать рот, сейчас я проверю ваши глаза.&/me проверяет реакцию человека на свет, посветив фонарик в глаза&/do Зрачки глаз обследуемого человека сузились.&/todo Отлично*выключая фонарик и убирая его в мед.кейс&Такс, сейчас я проверю ваше сердцебиение, поэтому приподнимите верхную одежду!&/me достаёт из мед.кейса стетоскоп и приложив его к груди человека проверяет сердцебиение&/do Сердцебиение в районе 65 ударов в минуту.&/todo С сердцебиением у вас все в порядке*убирая стетоскоп обратно в мед.кейс&/me снимает со своих рук использованные перчатки и выбрасывает их&Ну что-ж я могу вам сказать, со здоровьем у вас все в порядке, вы свободны!' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{ cmd = 'medin' , description = 'Оформление игроку мед.страховки' ,  text = 'Для оформления мед.страховки Вам необходимо оплатить определнную cумму.&Стоимость зависит от срока действия будущей мед.страховки.&На 1 неделю - $4ОО.ООО. На 2 недели - $8ОО.ООО. На 3 недели - $1.2ОО.ООО.&И так, скажите, на какой срок Вам оформить мед.страховку?&{pause}&/me достаёт из своего мед.кейса пустой бланк мед.страховки, ручку и печать {fraction_tag}&/me открывает бланк мед.страховки и начинает его заполнять, затем ставит печать {fraction_tag}&/me полностю заполнив бланк мед.страховки убирает ручку и печать обратно в свой мед.кейс&/givemedinsurance {arg_id}&/todo Вот ваша мед.страховка, берите*протягивая бланк с мед.страховкой человеку напротив себя&/n {get_nick({arg_id})}, примите предложение в /offer для получения' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{cmd = 'med' , description = 'Оформление игроку мед.карты' ,  text = 'Оформление мед. карты платное и зависит от её срока действия!&Мед. карта на 7 дней - ${price_med7}, на 14 дней - ${price_med14}.&Мед. карта на 30 дней - ${price_med30}, на 60 дней - ${price_med60}.&Скажите, вам на какой срок оформить мед. карту?&{show_medcard_menu}&Хорошо, тогда приступим к оформлению.&/me достаёт из своего мед.кейса пустую мед.карту, ручку и печать {fraction_tag}&/me открывает пустую мед.карту и начинает её заполнять, затем ставит печать {fraction_tag}&/me полностю заполнив мед.карту убирает ручку и печать обратно в свой мед.кейс&/todo Вот ваша мед.карта, берите*протягивая заполненную мед.карту человеку напротив себя&/medcard {arg_id} {get_medcard_status} {get_medcard_days} {get_medcard_price}&/n {get_nick({arg_id})}, примите предложение в /offer для получения медкарты' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{ cmd = 'recept' , description = 'Выдача игроку рецептов' ,  text = 'Стоимость одного рецепта составляет ${price_recept}&Скажите сколько Вам требуется рецептов, после чего мы продолжим.&/n Внимание! В течении часа выдаётся максимум 5 рецептов!&{show_recept_menu}&Хорошо, сейчас я выдам вам рецепты.&/me достаёт из своего мед.кейса бланк для оформления рецептов и начает его заполнять&/me ставит на бланк рецепта печать {fraction_tag}&/do Бланк успешно заполнен.&/todo Вот, держите!*передавая бланк  рецепта человеку напротив&/recept {arg_id} {get_recepts}' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{ cmd = 'ant' , description = 'Выдача игроку антибиотиков' ,  text = 'Стоимость одного антибиотика составляет ${price_ant}&Скажите сколько Вам требуется антибиотиков, после чего мы продолжим.&/n Внимание! Вы можете купить от 1 до 20 антибитиков за один раз!&{show_ant_menu}&Хорошо, сейчас я выдам вам антибиотики.&/me открывает свой мед.кейс и достаёт из него пачку антибиотиков, после чего закрывает мед.кейс&/do Антибиотики находятся в руках.&/todo Вот держите, употребляйте их строго по рецепту!*передавая антибиотики человеку напротив&/antibiotik {arg_id} {get_ants}' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{cmd = 'osm' , description = 'Полный мед.осмотр игрока (РП)' ,  text = 'Хорошо, сейчас я проведу вам мед.осмотр.&Дайте мне вашу мед.карту для проверки.&/n {get_nick({arg_id})}, введите /showmc {my_id} чтобы показать мне мед.карту.&{pause}&/me достаёт из мед.кейса стерильные перчатки и надевает их на руки&/do Перчатки на руках.&/todo Начнём мед.осмотр*улыбаясь.&Сейчас я проверю ваше горло, откройте рот и высуните язык.&/n Используйте /me открыл(-а) рот чтоб мы продолжили&{pause}&/me достаёт из мед.кейса фонарик и включив его осматривает горло человека напротив&Хорошо, можете закрывать рот, сейчас я проверю ваши глаза.&/me проверяет реакцию человека на свет, посветив фонарик в глаза&/do Зрачки глаз обследуемого человека сузились.&/todo Отлично*выключая фонарик и убирая его в мед.кейс&Такс, сейчас я проверю ваше сердцебиение, поэтому приподнимите верхную одежду!&/n {get_nick({arg_id})}, введите /showtatu чтобы снять одежду по РП&{pause}&/me достаёт из мед.кейса стетоскоп и приложив его к груди человека проверяет сердцебиение&/do Сердцебиение в районе 65 ударов в минуту.&/todo С сердцебиением у вас все в порядке*убирая стетоскоп обратно в мед.кейс&/me снимает со своих рук использованные перчатки и выбрасывает их&Ну что-ж я могу вам сказать...&Со здоровьем у вас все в порядке, вы свободны!' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"} , 
					{ cmd = 'gd' , description = 'Экстренный вызов (/godeath)' ,  text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me просматривает информацию и включает навигатор к выбранному месту экстренного вызова&/godeath {arg_id}' , arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'exp' , description = 'Выгнать игрока из больницы' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из больницы!&/me схватив человека ведёт к выходу из больницы и закрывает за ним дверь&/expel {arg_id} Н.П.Б.' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
				},
				smi = {
					{cmd = 'zd', description = 'Привествие игрока' , text = 'Здраствуйте {get_ru_nick({arg_id})}&Я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}" , in_fastmenu = true},
					{ cmd = 'go' , description = 'Позвать игрока за собой' , text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}' , enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true},
					
					{ cmd = 'expel' , description = 'Выгнать игрока из здания' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из здрания!&/me схватив человека ведёт к выходу из здания и закрывает за ним дверь&/expel {arg_id} Н.П.Р.' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{ cmd = 'cure' , description = 'Поднять игрока из стадии' ,  text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека началось биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}"},
				},
				fd = {
					{ cmd = 'siren' , description = 'Вкл/выкл мигалок в т/с' , text = '{switchCarSiren}', arg = '' , enable = true , waiting = '1.5', bind = "{}" },
					{ cmd = 'zd' , description = 'Привествие игрока' , text = 'Здраствуйте {get_ru_nick({arg_id})}&Я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}" , in_fastmenu = true},
					{ cmd = 'cure' , description = 'Поднять игрока из стадии' ,  text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека началось биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}" , in_fastmenu = true},
				},
				lc = {
					{cmd = 'zd' , description = 'Привествие игрока' , text = 'Здраствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь? Если нужна лицензия - скажите тип и срок', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Позвать игрока за собой', text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{ cmd = 'gl' , description = 'Выдача лицензии игроку' , text = '/me взял{sex} со стола бланк на получение лицензии и заполнил{sex} его&/do Спустя некоторое время бланк на получение лицензии был заполнен.&/me распечатав лицензию передал{sex} её человеку напротив&/givelicense {arg_id}&Вот ваша лицензия, всего Вам хорошего!&/n {get_nick({arg_id})}, введите команду /offer чтобы получить лицензию!', arg = '{arg_id}' , enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'prices' , description = 'Ознакомить игрока с ценами' , text = '/todo Сейчас я скажу вам цены на лицензии*доставая изпод стойки бланк с ценами&/do Бланк с ценами всех лицензий в руках.&/me подвинул{sex} бланк поближе к себе и начал{sex} читать цены&На автомобиль: 1 месяц - ${price_avto1}, 2 месяца - ${price_avto2}, 3 месяца - ${price_avto3}&На мото: 1 месяц - ${price_moto1}, 2 месяца - ${price_moto2}, 3 месяца - ${price_moto3}&На водный: 1 месяц - ${price_swim1}, 2 месяца - ${price_swim2}, 3 месяца - ${price_swim3}&На полёты: 1 месяц - ${price_fly1}&На оружие: 1 месяц - ${price_gun1}, 2 месяца - ${price_gun2}, 3 месяца - ${price_gun3}&На охоту: 1 месяц - ${price_hunt1}, 2 месяца - ${price_hunt2}, 3 месяца - ${price_hunt3}&На рыбалку: 1 месяц - ${price_fish1}, 2 месяца - ${price_fish2}, 3 месяца - ${price_fish3}&На клады: 1 месяц - ${price_klad1}, 2 месяца - ${price_klad2}, 3 месяца - ${price_klad3}&На такси: 1 месяц - ${price_taxi1}, 2 месяца - ${price_taxi2}, 3 месяца - ${price_taxi3}&На механика: 1 месяц - ${price_mexa1}, 2 месяца - ${price_mexa2}, 3 месяца - ${price_mexa3}&/todo Вот такие у нас цены*убирая бланк с ценами' , arg = '' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{cmd = 'medka' , description = 'Запросить медкарту для проверки' , text = 'Чтобы получить эту лицензию, покажите мне вашу мед.карту&/n {get_nick({arg_id})}, введите команду /showmc {my_id} чтобы показать мне медкарту&{pause}&/me берет от человека напротив медкарту и осматривает её&/todo Хорошо, забирайте*отдавая медкарту обратно владельцу' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{cmd = 'exp' , description = 'Выгнать игрока из ЦЛ' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из ЦЛ!&/me схватив человека ведёт к выходу из ЦЛ и закрывает за ним дверь&/expel {arg_id} Н.П.Ц.Л.' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{ cmd = 'cure' , description = 'Поднять игрока из стадии' ,  text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека началось биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}"  },
				},
				ins = {
					{cmd = 'zd' , description = 'Привествие игрока' , text = 'Здраствуйте, я {my_ru_nick} - {fraction_rank} {fraction_tag}&Чем я могу Вам помочь? Если нужна лицензия - скажите тип и срок', arg = '{arg_id}' , enable = true , waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'go', description = 'Позвать игрока за собой', text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true},
					{cmd = 'ins' , description = 'Предложить доп.услуги' ,  text = 'Я могу оформить "Семейный сертификат" или "Пенсионное страхование"&Что вам нужно? Страхование для депозита, сертификат для выплат&/insurance {arg_id}&/me достаёт нужные бумаги для оформления и передаёт их человеку напротив' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
					{cmd = 'exp' , description = 'Выгнать игрока из ЦЛ' ,  text = 'Вы больше не можете здесь находиться, я выгоняю вас из ЦЛ!&/me схватив человека ведёт к выходу из ЦЛ и закрывает за ним дверь&/expel {arg_id} Н.П.Ц.Л.' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}", in_fastmenu = true},
				},
				gov = {		
					{ cmd = 'zd' , description = 'Привествие игрока' , text = 'Здравствуйте, меня зовут {my_ru_nick}, чем я могу помочь?', arg = '{arg_id}' , enable = true , waiting = '1.5', in_fastmenu = true},
					{ cmd = 'go' , description = 'Позвать игрока за собой' , text = 'Хорошо {get_ru_nick({arg_id})}, следуйте за мной.', arg = '{arg_id}' , enable = true, waiting = '1.5', in_fastmenu = true},
					{ cmd = 'visit' , description = 'Показать визитку адвоката' ,  text = '/me вытащил{sex} из нагрудного кармана визитку адвоката&/do На визитке написано: "{my_ru_nick}, адвокат штата".&/showvisit {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', in_fastmenu = true} , 
					{ cmd = 'freely' , description = 'Предложить услуги адвоката' ,  text = '/do Папка с документами находится в левой руке.&/me открыв папку, вытащил{sex} из неё бланк для освобождения заключённого&/me достав из кармана ручку, заполнил{sex} документ и передал{sex} человеку напротив&/todo Впишите сюда свои данные и поставьте подпись снизу*передавая лист с ручкой&/free {arg_id} {arg2}' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.5'},
					{ cmd = 'visa' , description = 'Выдать рабочую визу для VC' ,  text = 'Стоимость услуги составляет 600 тысяч. Вы согласны?&Если да, то приступаем к оформлению&{pause}&/do Бланк для оформления визы находится в кармане.&/me засунув руку в карман, взял{sex} бланк, после чего протянул{sex} его человеку напротив&/todo Впишите сюда Ваши данные и поставьте подпись снизу*протягивая лист с ручкой&/givevisa {arg_id}', arg = '{arg_id}' , enable = true, waiting = '1.5', in_fastmenu = true},
					{ cmd = 'car' , description = 'Превратить личный т/c в сертификат' , text = 'Перед тем, как начать, попрошу полностью опустошить багажник и снять весь тюнинг&А также убедиться, что пробег меньше либо равен 200 км&Если Вы все сделали, то можем приступать&{pause}&Окей, приступаем&/do Бланк для получения сертификата находится под в кармане.&/me засунув руку в карман, взял{sex} бланк, после чего протянул{sex} его человеку напротив&/todo Впишите сюда Ваши данные и поставьте подпись снизу*протягивая лист с ручкой&/givepass {arg_id}', arg = '{arg_id}' , enable = true, waiting = '1.5', in_fastmenu = true},
					{ cmd = 'wed' , description = 'Заключение брака' ,  text = 'Добрый день, уважаемые новобрачные и гости!&Уважаемые невеста и жених!&Сегодня - самое прекрасное и незабываемое событие в вашей жизни.&Создание семьи – это начало доброго союза двух любящих сердец.&С этого дня вы пойдёте по жизни рука об руку, вместе переживая и радость счастливых дней, и огорчения.&Создавая семью, вы добровольно приняли на себя великий долг друг перед другом и перед будущим ваших детей.&Перед началом регистрации прошу вас ещё раз подтвердить, является ли ваше решение стать супругами, создать семью&{pause}&С вашего взаимного согласия, выраженного в присутствии свидетелей, ваш брак регистрируется.&Прошу вас в знак любви и преданности друг другу обменяться обручальными кольцами.&/wedding {arg_id} {arg2}' , arg = '{arg_id} {arg2}' , enable = true, waiting = '1.5'},
					{ cmd = 'pass' , description = 'Исправить дату рождения в паспорте' ,  text = '/do Бланк для замены информации в паспорте находится в кармане.&/me засунув руку в карман, взял{sex} бланк, после чего протянул{sex} его человеку напротив&/todo Впишите сюда новую дату и поставьте подпись снизу*протягивая лист с ручкой&/givepass {arg_id}' , arg = '{arg_id}' , enable = true , waiting = '1.5'},	
					{ cmd = 'frisk', description = 'Обыск (7+)', text = '/do Перчатки находяться в кармане.&/me взял{sex} перчатки с кармана и надел{sex} их&/do Перчатки одеты.&/me начал нащупывать человека напротив&/frisk {arg_id}&/me полностю прощупав человека убрал{sex} перчатки обратно в карман', arg = '{arg_id}', enable = false, waiting = '1.5' },
					{ cmd = 'exp' , description = 'Выгнать игрока из правительства' ,  text = 'Извините, но я вынужден{sex} выгнать вас из здания за неподобающее поведение.&/me схватил{sex} человека за руку и повел{sex} к выходу&/me открыв дверь рукой, вывел{sex} человека на улицу&/expel {arg_id} Неадекватное поведение' , arg = '{arg_id}' , enable = true , waiting = '1.5', in_fastmenu = true},
					{ cmd = 'cure' , description = 'Поднять игрока из стадии' ,  text = '/me наклоняется над человеком, и прощупывает его пульс на сонной артерии&/cure {arg_id}&/do Пульс отсутствует.&/me начинает делать человеку непрямой массаж сердца, время от времени проверяя пульс&/do Спустя несколько минут сердце человека началось биться.&/do Человек пришел в сознание.&/todo Отлично*улыбаясь' , arg = '{arg_id}' , enable = true , waiting = '1.5' , bind = "{}"  },
				},
				mafia = {
					{ cmd = 'tie', description = 'Связать жертву', text = '/do В кармане бронежилета лежит шпагат.&/me легким движением руки достал{sex} из кармана шпагат&/me обвязывает руки жертвы веревкой и стягивает её&/tie {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{ cmd = 'untie', description = 'Развязать жертву', text = '/do На правом бедре закреплено тактическое крепление для ножа.&/me движением правой руки открепив нож, берёт его в руки&/do В правой руке держит нож.&/me подойдя к жертве со спины, отрезал{sex} верёвку&/untie {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{ cmd = 'lead', description = 'Вести жертву за собой', text = '/me движением руки схватив за шкирку жертвы, ведёт его за собой&/lead {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{ cmd = 'unlead', description = 'Прекратить вести жертву', text = '/me расслабив схватку, перестаёт контролировать жертву&/unlead {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{ cmd = 'gag', description = 'Заткнуть рот жертве тряпкой', text = '/do На поясе закреплена сумка.&/me правой рукой отстегнув молнию, открывает сумку&/do Внутри сумки лежит тряпка.&/me подходя к жертве, попутно достал{sex} из сумки тряпку&/do Тряпка в руках в развёрнутом виде.&/me обеими руками завернув тряпку, запихнул{sex} в рот жертвы&/gag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true },
					{ cmd = 'ungag', description = 'Вытащить тряпку изо рта жертвы', text = '/me подойдя ближе к жертве, движением правой руки потянул{sex} за тряпку и забрал{sex} себе&/ungag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{ cmd = 'bag', description = 'Надеть пакет на голову жертвы', text = '/do В кармане куртки лежит мусорный пакет.&/me достал{sex} мусорный пакет из кармана, развернул{sex} его&/me надевает мусорный пакет на голову жертвы, не затягивая его&/bag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}' , in_fastmenu = true},
					{ cmd = 'unbag', description = 'Снять пакет с головы жертвы', text = '/me легким движением руки схватив за пакет, потянул{sex} его вверх, тем самым стянув пакет с головы жертвы&/unbag {arg_id}', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true },
					{ cmd = 'inсar', description = 'Затолкать жертву в фургон', text = '/me открывает двери фургона&/me берет жертву под руки и заталкивает вперёд головой в фургон&/me закрывает двери и садится в фургон&/incar {arg_id} 3', arg = '{arg_id}', enable = true, waiting = '1.5', bind = '{}', in_fastmenu = true},
				},
				ghetto = {}
			},
			commands_manage = {
				my = {},
				goss = {
					{ cmd = 'inv' , description = 'Принятие игрока в организацию' , text = '/do В кармане есть связка с ключами от раздевалки.&/me достаёт из кармана один ключ из связки ключей от раздевалки&/todo Возьмите, это ключ от нашей раздевалки*передавая ключ человеку напротив&/invite {arg_id}&/n {get_ru_nick({arg_id})} , примите предложение в /offer чтобы получить инвайт!' , arg = '{arg_id}', enable = true, waiting = '1.5'  , bind = "{}", in_fastmenu = true  },
					{ cmd = 'rp' , description = 'Выдача сотруднику /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true  },
					{ cmd = 'gr' , description = 'Повышение/понижение cотрудника' , text = '{show_rank_menu}&/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/giverank {arg_id} {get_rank}&/r Сотрудник {get_ru_nick({arg_id})} получил новую должность!' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true   },
					{ cmd = 'vize' , description = 'Управление Vice City визой сотрудника' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&{lmenu_vc_vize}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}", in_fastmenu = true    },
					{ cmd = 'cjob' , description = 'Посмотреть успешность сотрудника' , text = '/checkjobprogress {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true   },	
					{ cmd = 'fmutes' , description = 'Выдать мут сотруднику (10 min)' , text = '/fmutes {arg_id} Н.У.&/r Сотрудник {get_ru_nick({arg_id})} лишился права использовать рацию на 10 минут!' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}"   },
					{ cmd = 'funmute' , description = 'Снять мут сотруднику' , text = '/funmute {arg_id}&/r Сотрудник {get_ru_nick({arg_id})} теперь может пользоваться рацией!' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}", in_fastmenu = true   },
					{ cmd = 'vig' , description = 'Выдача выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/fwarn {arg_id} {arg2}&/r Сотруднику {get_ru_nick({arg_id})} выдан выговор! Причина: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5'  , bind = "{}"  },
					{ cmd = 'unvig' , description = 'Снятие выговора cотруднику' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает телефон обратно в карман&/unfwarn {arg_id}&/r Сотруднику {get_ru_nick({arg_id})} был снят выговор!' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}" , in_fastmenu = true  },
					{ cmd = 'unv' , description = 'Увольнение игрока из фракции' , text = '/me достаёт из кармана свой телефон и заходит в базу данных {fraction_tag}&/me изменяет информацию о сотруднике {get_ru_nick({arg_id})} в базе данных {fraction_tag}&/me выходит с базы данных и убирает свой телефон обратно в карман&/uninvite {arg_id} {arg2}&/r Сотрудник {get_ru_nick({arg_id})} был уволен по причине: {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5' , bind = "{}"   },
					{cmd = 'point' , description = 'Установить метку для сотрудников' , text = '/r Срочно выдвигайтесь ко мне, отправляю вам координаты...&/point' , arg = '', enable = true, waiting = '1.5' , bind = "{}"},
					{ cmd = 'govka' , description = 'Собеседование по госс.волне' , text = '/d [{fraction_tag}] - [Всем]: Занимаю государственную волну, просьба не перебивать!&/gov [{fraction_tag}]: Доброго времени суток, уважаемые жители нашего штата!&/gov [{fraction_tag}]: Сейчас проходит собеседование в организацию {fraction}}&/gov [{fraction_tag}]: Для вступления вам нужно иметь документы и приехать к нам в холл.&/d [{fraction_tag}] - [Всем]: Освобождаю  государственную волну, спасибо что не перебивали.' , arg = '', enable = true, waiting = '1.5', bind = "{}"  },
				},
				goss_fbi = {
					{ cmd = 'demoute' , description = 'Уволить госслужащего' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me заходит в базу данных {fraction_tag} и переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/demoute {arg_id} {arg2}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = false, waiting = '1.5', bind = "{}"},
				},
				goss_prison = {
					{cmd = 'unpunish', description = 'Выпуск заключённых из ТСР', text = '/me лёгкими движениями рук берёт дело заключённого с полки, кладёт его на стол&/do На столе лежит ручка и печать.&/me лёгким движением правой руки берёт ручку, заполняет поле в деле заключённого&/me лёгкими движениями рук кладёт ручку на стол, берёт печать и ставит её в деле&/me лёгкими движениями рук ставит печать на стол, после чего закрывает дело&Ваш срок укорочен, возвращайтесь в камеру и ожидайте ...&... транспортировки до ближайшего населённого пункта.&/unpunish {arg_id} {arg2}', arg = '{arg_id} {arg2}', enable = true, waiting = '1.5'},
					{cmd = 'rjailreklama', description = 'Реклама УДО', text = '/rjail Доброго времени суток заключенные.&/rjail В данный момент Вы можете покинуть тюрьму досрочно, через кабинет начальства тюрьмы.&/rjail Обратите внимание, УДО (условно дорочное освобожение) платное!&/rjail Спасибо за внимание.', arg = '', enable = true, waiting = '1.5'}
				},
				goss_gov = {
					{ cmd = 'lic' , description = 'Выдать лицензию адвоката' , text = '/do Бланк для выдачи лицензии находится под столом.&/me засунув руку под стол, взял{sex} бланк, после чего заполнил{sex} его нужной информацией&/todo Впишите сюда Ваши данные и поставьте подпись снизу*передавая бланк и ручку&/givelicadvokat {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5', },
					{ cmd = 'demoute' , description = 'Уволить госслужащего' ,  text = '/do КПК находиться на поясном держателе.&/me берёт в руки свой КПК и включает его&/me заходит в базу данных {fraction_tag} и переходит в раздел управление сотрудниками других организаций&/me открывает дело нужного сотрудника и вносит в него изменения&/do Изменения успешно сохранены.&/demoute {arg_id} {arg2}&/me выходит с базы данных {fraction_tag} и выключив КПК убирает его на поясной держатель', arg = '{arg_id} {arg2}', enable = false, waiting = '1.5', bind = "{}"},
				},
				mafia = {
					{ cmd = 'inv' , description = 'Принятие игрока в организацию' , text = '/do В кармане есть связка с ключами от раздевалки.&/me достаёт из кармана один ключ из связки ключей от раздевалки&/todo Возьмите, это ключ от нашей раздевалки*передавая ключ человеку напротив&/invite {arg_id}&/n {get_ru_nick({arg_id})} , примите предложение в /offer чтобы получить инвайт!' , arg = '{arg_id}', enable = true, waiting = '1.5'  , bind = "{}"  },
					{ cmd = 'rp' , description = 'Выдача сотруднику /fractionrp' , text = '/fractionrp {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}"  },
					{ cmd = 'gr' , description = 'Повышение/понижение cотрудника' , text = '{show_rank_menu}&/todo Вот тебе новая форма!*протягивая форму человеку напротив &/giverank {arg_id} {get_rank}' , arg = '{arg_id}', enable = true, waiting = '1.5', bind = "{}"   },
					{ cmd = 'fmutes' , description = 'Выдать мут сотруднику (10 min)' , text = '/fmutes {arg_id} Подумай о своём поведении' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}"   },
					{ cmd = 'funmute' , description = 'Снять мут сотруднику' , text = '/funmute {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}"   },
					{ cmd = 'vig' , description = 'Выдача выговора' , text = '/f {get_ru_nick({arg_id})}, ты провинился(-лась) в {arg2}!&/fwarn {arg_id} {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5'  , bind = "{}"  },
					{ cmd = 'unvig' , description = 'Снятие выговора cотруднику' , text = '/f {get_ru_nick({arg_id})}, ты прощён(-а)!&unfwarn {arg_id}' , arg = '{arg_id}', enable = true, waiting = '1.5' , bind = "{}"   },
					{ cmd = 'unv' , description = 'Увольнение игрока из фракции' , text = '/me забирает организационную форму у человека&/uninvite {arg_id} {arg2}' , arg = '{arg_id} {arg2}', enable = true, waiting = '1.5' , bind = "{}"   },
					{ cmd = 'point' , description = 'Установить метку для сотрудников' , text = '/f Срочно выдвигайтесь ко мне, отправляю вам координаты...&/point' , arg = '', enable = true, waiting = '1.5' , bind = "{}"  },
				},
				ghetto = {}
			}
		}
	},
	notes = {
		name = 'Заметки',
		path = configDirectory .. "/Notes.json",
		data = {
			{ note_name = 'Зарплата', note_text = 'Почему ваша зарплата может быть меньше, чем указано:&- Если у вас нету жилья (дом/отель) то у вас будет -20 процентов зп&- Если у вас есть выговор то у вас будет -20 процентов зп&- Из-за фикса экономики (от разрабов) у вас будет -10 процентов зп&&Как повысить свою зарплату:&- Вступите в фулл семью с флагом чтобы иметь +7 процентов зп &( на 20 сервере это наша семья Martelli )&- Получите \"Военный билет\" чтобы иметь +15 процентов зп&- Купите охранника на \"зп фракции\" чтобы иметь до +25 процентов зп&- Повышайтесь на ранг повыше'},
		}
	},
	rpgun = {
		name = 'RP Guns',
		path = configDirectory .. "/RP Guns.json",
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
				{id = 23, name = "электрошокер Taser-X26P", enable = true, rpTake = 4},
				{id = 24, name = 'пистолет Desert Eagle', enable = true, rpTake = 4},
				{id = 25, name = 'дробовик', enable = true, rpTake = 1},
				{id = 26, name = 'обрез', enable = true, rpTake = 4},
				{id = 27, name = 'улучшенный обрез', enable = false, rpTake = 1},
				{id = 28, name = 'ПП Micro Uzi', enable = true, rpTake = 4},
				{id = 29, name = 'ПП MP5', enable = true, rpTake = 4},
				{id = 30, name = 'автомат AK-47', enable = true, rpTake = 1},
				{id = 31, name = 'автомат M4', enable = true, rpTake = 1},
				{id = 32, name = 'ПП Tec-9', enable = true, rpTake = 4},
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
				{id = 44, name = 'прибор ночного видения', enable = false, rpTake = 2},
				{id = 45, name = 'тепловизор', enable = false, rpTake = 2},
				{id = 46, name = 'ручной парашут', enable = true, rpTake = 1},
				-- gta sa damage reason
				{id = 49, name = 'автомобиль', rpTake = 1},
				{id = 50, name = 'лопасти вертолёта', rpTake = 1},
				{id = 51, name = 'бомбу', rpTake = 1},
				{id = 54, name = 'коллизию', rpTake = 1},
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
				{id = 84, name = 'автомат AKS-74 камуфляжный', enable = true, rpTake = 1},
				{id = 85, name = 'автомат AK-47 камуфляжный', enable = true, rpTake = 1},
				{id = 86, name = 'дробовик Rebecca', enable = true, rpTake = 1},
				{id = 87, name = 'портальную пушку', enable = true, rpTake = 1},
				{id = 88, name = 'ледяной меч', enable = true, rpTake = 1},
				{id = 89, name = 'портальную пушку', enable = true, rpTake = 4},
				{id = 90, name = 'оглушающую гранату', enable = true, rpTake = 3},
				{id = 91, name = 'ослепляющую гранату', enable = true, rpTake = 3},
				{id = 92, name = 'снайперскую винтовку TAC-50', enable = true, rpTake = 1},
				{id = 93, name = 'оглушающий пистолет', enable = true, rpTake = 4},
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
		name = 'SmartUK',
		path = configDirectory .. "/SmartUK.json",
		data = {}
	},
    smart_pdd = {
		name = 'SmartPDD',
		path = configDirectory .. "/SmartPDD.json",
		data = {}
	},
    smart_rptp = {
		name = 'SmartRPTP',
		path = configDirectory .. "/SmartRPTP.json",
		data = {}
	},
	arz_veh = {
		name = 'ARZ VEHICLES',
		path = configDirectory .. "/Vehicles.json",
		data = {},
		cache = {}
	}
}
function load_module(key)
    local obj = modules[key]
	if not obj then
		print('[Arizona Helper] Ошибка: неизвестный модуль "' .. key .. '"!')
	else
		if doesFileExist(obj.path) then
			local file, errstr = io.open(obj.path, 'r')
			if file then
				local contents = file:read('*a')
				file:close()
				if #contents == 0 then
					print('[Arizona Helper] Не удалось открыть модуль "' .. obj.name .. '". Причина: файл пустой')
				else
					local result, loaded = pcall(decodeJson, contents)
					if result then
						obj.data = loaded
						print('[Arizona Helper] Модуль "' .. obj.name .. '" инициализирован! (есть ваши кастомные данные)')
					else
						print('[Arizona Helper] Не удалось открыть модуль "' .. obj.name .. '". Ошибка: decode json')
					end
				end
			else
				print('[Arizona Helper] Не удалось открыть модуль "' .. obj.name .. '". Ошибка: ' .. tostring(errstr or "неизвестная"))
			end
		else
			print('[Arizona Helper] Модуль "' .. obj.name .. '" инициализирован!')
		end
	end
end
function save_module(key)
    local obj = modules[key]
	if not obj then
		print('[Arizona Helper] Ошибка: неизвестный модуль "' .. key .. '"!')
	else
		local file, errstr = io.open(obj.path, 'w')
		if file then
			local function looklike(array)
				local dkok, dkjson = pcall(require, "dkjson")
				if dkok then
					local ok, encoded = pcall(dkjson.encode, array, {indent = true})
					if ok then return encoded end
				end
				local ok, encoded = pcall(encodeJson, array)
				if ok then return encoded else return {} end
			end
			local content = looklike(obj.data)
			if #content ~= 0 then
				file:write(content)
				print('[Arizona Helper] Модуль "' .. obj.name .. '" сохранён!')
			else
				print('[Arizona Helper] Не удалось сохранить модуль "' .. obj.name .. '" - ошибка кодировки json!')
			end
			file:close()
		else
			print('[Arizona Helper] Не удалось сохранить модуль "' .. obj.name .. '", ошибка: ' .. tostring(errstr or "неизвестная"))
		end
	end
end
------------------------------------------- MonetLoader --------------------------------------------------
function isMonetLoader() return MONET_VERSION ~= nil end
if isMonetLoader() then
	gta = ffi.load('GTASA') 
	ffi.cdef[[ void _Z12AND_OpenLinkPKc(const char* link); ]]
end
if not settings.general.autofind_dpi then
	print('[Arizona Helper] Применение авто-размера менюшек...')
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
	print('[Arizona Helper] Установлено значение: ' .. settings.general.custom_dpi)
	print('[Arizona Helper] Вы в любой момент можете изменить значение в настройках!')
	save_settings()
end
----------------------------------------------- Functions -----------------------------------------------------
function isMode(mode_type)
	return settings.general.fraction_mode == mode_type
end
function add_notes(module)
	local situate_codes = { note_name = 'Ситуационные коды', note_text = 'CODE 0 - Офицер ранен.&CODE 1 - Офицер в бедственном положении, нужна помощь всех юнитов.&CODE 2 - Обычный вызов [без сирен/стробоскопов/соблюдение ПДД].&CODE 2 HIGHT - Приоритетный вызов [без сирен/стробоскопов/соблюдение ПДД].&CODE 3 - Срочный вызов [сирены, стробоскопы, игнорирования ПДД].&CODE 4 - Стабильно, помощь не требуется.&Code 4 ADAM - Помощь не требуется, но офицеры поблизости должны быть готовы оказать помощь.&CODE 5 - Офицерам держаться подальше от опасного места.&CODE 6 - Задерживаюсь на месте [включая локацию и причину,например, 911].&CODE 7 - Перерыв на обед.&CODE 30 - Срабатывание "тихой" сигнализации на месте происшествия.&CODE 30 RINGER - Срабатывание "громкой сигнализации на месте происшествия.&CODE 37 - Обнаружение угнанного т/c.&Сode TOM - Офицеру требуется Тайзер.' }
	table.insert(modules.notes.data, situate_codes)

	local teen_codes = { note_name = 'Тен-коды', note_text = '10-1 - Сбор всех офицеров на дежурстве.&10-2 - Вышел в патруль.&10-2R - Закончил патруль.&10-3 - Радиомолчание.&10-4 - Принято.&10-5 - Повторите.&10-6 - Не принято/неверно/нет.&10-7 - Ожидайте.&10-8 - Не доступен/занят.&10-14 - Запрос транспортировки.&10-15 - Подозреваемые арестованы.&10-18 - Требуется поддержка дополнительных юнитов.&10-20 - Локация.&10-21 - Статус и местонахождение.&10-22 - Выдвигайтесь к локации.&10-27 - Меняю маркировку патруля.&10-30 - Дорожно-транспортное происшествие.&10-40 - Большое скопление людей (более 4).&10-41 - Нелегальная активность.&10-46 - Провожу обыск.&10-55 - Траффик стоп.&10-57 VICTOR - Погоня за автомобилем.&10-57 FOXTROT - Пешая погоня.&10-66 - Траффик стоп повышенного риска.&10-70 - Запрос поддержки.&10-71 - Запрос медицинской поддержки.&10-88 - Теракт/ЧС.&10-99 - Ситуация урегулирована.&10-100 Временно недоступен для вызовов.' }
	table.insert(modules.notes.data, teen_codes)
	if module ~= 'prison' then
		local markup_patrool = { note_name = 'Маркировки патруля', note_text = 'Основные:&ADAM [A] - Патруль из 2/3 офицеров на крузере.&LINCOLN [L] - Одиночный патруль на крузере.&MARY [M] - Одиночный патруль на мотоцикле.&HENRY [H] - Высокоскоростой патруль.&AIR [AIR] - Воздушный патруль.&Air Support Division [ASD] - Воздушная поддержка.&&Дополнительные:&CHARLIE [C] - Группа захвата.&ROBERT [R] - Отдел Детективов.&SUPERVISOR [SV] - Руководящий состав.&DAVID [D] - Cпециальный отдел SWAT.&EDWARD [E] - Эвакуатор полиции.&NORA [N] - немаркированная единица патруля.'}
		table.insert(modules.notes.data, markup_patrool)
	end
	save_module('notes')
end

------------------------------------------------ Mimgui -----------------------------------------------------
local InititalWindow = imgui.new.bool()

local MainWindow = imgui.new.bool()
local theme = imgui.new.int(tonumber(settings.general.helper_theme))
local slider_dpi = imgui.new.float(tonumber(settings.general.custom_dpi) or 1)
local input = imgui.new.char[256]()
local slider = imgui.new.int(0)

local checkbox_accent_enable = imgui.new.bool(settings.player_info.accent_enable or false)
local checkbox_mobile_stop_button = imgui.new.bool(settings.general.mobile_stop_button or false)
local checkbox_mobile_fastmenu_button = imgui.new.bool(settings.general.mobile_fastmenu_button or false)
-- MJ
local checkbox_patrool_autodoklad =  imgui.new.bool(settings.general.auto_doklad_patrool or false)
local checkbox_autodoklad_damage =  imgui.new.bool(settings.general.auto_doklad_damage or false)
local checkbox_autodoklad_arrest =  imgui.new.bool(settings.general.auto_doklad_arrest or false)
local checkbox_automask =  imgui.new.bool(settings.general.auto_mask or false)
local checkbox_change_code_siren = imgui.new.bool(settings.general.auto_change_code_siren or false)
local checkbox_update_members = imgui.new.bool(settings.general.auto_update_members or false)
local checkbox_auto_time = imgui.new.bool(settings.general.auto_time or false)
local checkbox_update_wanteds = imgui.new.bool(settings.mj.auto_update_wanteds or false)
local checkbox_autodocumentation = imgui.new.bool(settings.mj.auto_documentation or false)
local checkbox_notify_payday = imgui.new.bool(settings.general.auto_notify_payday or false)
local checkbox_auto_clicker = imgui.new.bool(settings.general.auto_clicker_situation or false)
local checkbox_auto_accept_docs = imgui.new.bool(settings.general.auto_accept_docs or false)
local checkbox_awanted = imgui.new.bool(settings.mj.awanted or false)
local checkbox_mobile_taser_button = imgui.new.bool(settings.general.use_taser_menu or false)
local checkbox_mobile_meg_button = imgui.new.bool(settings.general.mobile_meg_button or false)

-- dep
local checkbox_dep_anti_skobki = imgui.new.bool(settings.deportament.anti_skobki or false)

-- LC
local price_lc = {
    avto1 = imgui.new.char[256](u8(settings.lc.price.avto1) or 0),
    avto2 = imgui.new.char[256](u8(settings.lc.price.avto2) or 0),
    avto3 = imgui.new.char[256](u8(settings.lc.price.avto3) or 0),
    moto1 = imgui.new.char[256](u8(settings.lc.price.moto1) or 0),
    moto2 = imgui.new.char[256](u8(settings.lc.price.moto2) or 0),
    moto3 = imgui.new.char[256](u8(settings.lc.price.moto3) or 0),
    fish1 = imgui.new.char[256](u8(settings.lc.price.fish1) or 0),
    fish2 = imgui.new.char[256](u8(settings.lc.price.fish2) or 0),
    fish3 = imgui.new.char[256](u8(settings.lc.price.fish3) or 0),
    swim1 = imgui.new.char[256](u8(settings.lc.price.swim1) or 0),
    swim2 = imgui.new.char[256](u8(settings.lc.price.swim2) or 0),
    swim3 = imgui.new.char[256](u8(settings.lc.price.swim3) or 0),
    gun1 = imgui.new.char[256](u8(settings.lc.price.gun1) or 0),
    gun2 = imgui.new.char[256](u8(settings.lc.price.gun2) or 0),
    gun3 = imgui.new.char[256](u8(settings.lc.price.gun3) or 0),
    hunt1 = imgui.new.char[256](u8(settings.lc.price.hunt1) or 0),
    hunt2 = imgui.new.char[256](u8(settings.lc.price.hunt2) or 0),
    hunt3 = imgui.new.char[256](u8(settings.lc.price.hunt3) or 0),
    klad1 = imgui.new.char[256](u8(settings.lc.price.klad1) or 0),
    klad2 = imgui.new.char[256](u8(settings.lc.price.klad2) or 0),
    klad3 = imgui.new.char[256](u8(settings.lc.price.klad3) or 0),
    taxi1 = imgui.new.char[256](u8(settings.lc.price.taxi1) or 0),
    taxi2 = imgui.new.char[256](u8(settings.lc.price.taxi2) or 0),
    taxi3 = imgui.new.char[256](u8(settings.lc.price.taxi3) or 0),
    mexa1 = imgui.new.char[256](u8(settings.lc.price.mexa1) or 0),
    mexa2 = imgui.new.char[256](u8(settings.lc.price.mexa2) or 0),
    mexa3 = imgui.new.char[256](u8(settings.lc.price.mexa3) or 0),
    fly1 = imgui.new.char[256](u8(settings.lc.price.fly1) or 0),
    fly2 = imgui.new.char[256](u8(settings.lc.price.fly2) or 0),
    fly3 = imgui.new.char[256](u8(settings.lc.price.fly3) or 0)
}


-- MH
local price_mh = {
    heal = imgui.new.char[256](u8(settings.mh.price.heal)),
    heal_vc = imgui.new.char[256](u8(settings.mh.price.heal_vc)),
    healactor = imgui.new.char[256](u8(settings.mh.price.healactor)),
    healactor_vc = imgui.new.char[256](u8(settings.mh.price.healactor_vc)),
    medosm = imgui.new.char[256](u8(settings.mh.price.medosm)),
    mticket = imgui.new.char[256](u8(settings.mh.price.mticket)),
    recept = imgui.new.char[256](u8(settings.mh.price.recept)),
    ant = imgui.new.char[256](u8(settings.mh.price.ant)),
    healbad = imgui.new.char[256](u8(settings.mh.price.healbad)),
    med7 = imgui.new.char[256](u8(settings.mh.price.med7)),
    med14 = imgui.new.char[256](u8(settings.mh.price.med14)),
    med30 = imgui.new.char[256](u8(settings.mh.price.med30)),
    med60 = imgui.new.char[256](u8(settings.mh.price.med60))
}
local MedCardMenu = imgui.new.bool()
local medcard_days = imgui.new.int()
local medcard_status = imgui.new.int(3)

local ReceptMenu = imgui.new.bool()
local recepts = imgui.new.int(1)

local AntibiotikMenu = imgui.new.bool()
local antibiotiks = imgui.new.int(1)

local FastHealMenu = imgui.new.bool()
local heal_in_chat = {bool = false, player_id = nil, worlds = {'вылечи', 'лечи', 'хил', 'лек', 'heal', 'hil', 'lek', 'табл', 'болит', 'голова', 'лекни' , 'ktr', 'ktxb', 'ujkjdf'}}

local DeportamentWindow = imgui.new.bool()
local input_dep_fm = imgui.new.char[32](u8(settings.deportament.dep_fm))
local input_dep_text = imgui.new.char[256]()
local input_dep_tag1 = imgui.new.char[32](u8(settings.deportament.dep_tag1))
local input_dep_tag2 = imgui.new.char[32](u8(settings.deportament.dep_tag2))
local input_dep_new_tag = imgui.new.char[32]()

local MembersWindow = imgui.new.bool()
local updmembers = {}
local members = {}
local members_new = {}
local members_info = {fraction = '', check = false}

local GiveRankMenu = imgui.new.bool()
local giverank = imgui.new.int(5)

local CommandStopWindow = imgui.new.bool()
local CommandPauseWindow = imgui.new.bool()
local LeaderFastMenu = imgui.new.bool()
local FastMenu = imgui.new.bool()
local FastPieMenu = imgui.new.bool()
local FastMenuButton = imgui.new.bool()
local FastMenuPlayers = imgui.new.bool()

local SobesMenu = imgui.new.bool()

local NoteWindow = imgui.new.bool()

local UpdateWindow = imgui.new.bool()
local update = {
	is_need_update = false,
	version = "",
	url = "",
	info = ""
}
local download_file = ""

local BinderWindow = imgui.new.bool()
local waiting_slider = imgui.new.float(0)
local ComboTags = imgui.new.int()
local item_list = {
	u8('Без аргументов'),
	u8('{arg} - любой аргумент'),
	u8('{arg_id} - ID игрока - например /cure 429'),
	u8('{arg_id} {arg2} - ID игрока и любой аргумент - например /vig 429 Без бейджика'),
	u8('{arg_id} {arg2} {arg3} - ID игрока, число, и любой аргумент - например /su 429 2 Неподчинение'),
	u8('{arg_id} {arg2} {arg3} {arg4} - ID игрока, число и два любых аргумента - например /carcer 429 1 5 Н.У.')
}
local ImItems = imgui.new['const char*'][#item_list](item_list)
local binder_data = {change_waiting = nil, change_cmd = nil, change_text = nil, change_arg = nil, change_bind = nil, change_in_fastmenu = false, create_command_9_10 = false, input_description = nil}
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
{get_storecar_model} - Получить модель ближайшего к вам авто с водителем

{get_nick({arg_id})} - получить Никнейм из аргумента ID игрока
{get_rp_nick({arg_id})} - получить Никнейм без символа _ из аргумента ID игрока
{get_ru_nick({arg_id})} - получить Никнейм на кирилице из аргумента ID игрока 

{price_heal} - Цена лечения пациентов
{price_healbad} - Цена лечения от наркозависимости
{price_actorheal} - Цена лечения охранников
{price_medosm} - Цена мед.осмотра для пилота
{price_mticket} - Цена обследования военного билета
{price_ant} - Цена антибиотика   
{price_recept} - Цена рецепта
{price_med7} - Цена медккарты на 7 дней   
{price_med14} - Цена медккарты на 14 дней
{price_med30} - Цена медккарты на 30 дней   
{price_med60} - Цена медккарты на 60 дней

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

{pause} - Поставить отыгровку команды на паузу и ожидать действия]]

local RPWeaponWindow = imgui.new.bool()
local ComboTags2 = imgui.new.int()
local item_list2 = {u8'Спина', u8'Карман', u8'Пояс', u8'Кобура'}
local ImItems2 = imgui.new['const char*'][#item_list2](item_list2)

local MegafonWindow = imgui.new.bool()

local InformationWindow = imgui.new.bool()

local TaserWindow = imgui.new.bool()

local WantedWindow = imgui.new.bool()

local updwanteds = {}
local wanted = {}
local wanted_new = {}
local check_wanted = false
local search_awanted = false


local PostMenu = imgui.new.bool()
local PatroolMenu = imgui.new.bool()
local patrool = {
	start_time = 0,
	current_time = 0,
	time = 0,
	code = 'CODE 4',
	mark = 'ADAM',
	name = '',
	active = false
}
local ComboPatroolMark = imgui.new.int(0)
local combo_patrool_mark_list = {'ADAM', 'LINCOLN', 'MARY', 'HENRY', 'AIR', 'ASD', 'CHARLIE', 'ROBERT', 'SUPERVISOR', 'DAVID', 'EDWARD', 'NORA'}
local ImItemsPatroolMark = imgui.new['const char*'][#combo_patrool_mark_list](combo_patrool_mark_list)
local ComboPatroolCode = imgui.new.int(5)
local combo_patrool_code_list = {'CODE 0', 'CODE 1', 'CODE 2', 'CODE 2 HIGHT', 'CODE 3', 'CODE 4', 'CODE 4 ADAM', 'CODE 5', 'CODE 6', 'CODE 7', 'CODE 30', 'CODE 30 RINGER', 'CODE 37', 'CODE TOM'}
local ImItemsPatroolCode = imgui.new['const char*'][#combo_patrool_code_list](combo_patrool_code_list)

local SumMenuWindow = imgui.new.bool()
local form_su = ''
local TsmMenuWindow = imgui.new.bool()

local PuMenuWindow = imgui.new.bool()



local ProbivMenu = imgui.new.bool()
local input_probiv_key = imgui.new.char[128]()

-------------------------------------------- Init Colors (MoonMonet) ----------------------------------------------------
local monet_no_errors, moon_monet = pcall(require, 'MoonMonet')
function rgbToHex(rgb)
	local r = bit.band(bit.rshift(rgb, 16), 0xFF)
	local g = bit.band(bit.rshift(rgb, 8), 0xFF)
	local b = bit.band(rgb, 0xFF)
	local hex = string.format("%02X%02X%02X", r, g, b)
	return hex
end
if settings.general.helper_theme == 0 then
	if monet_no_errors then
		message_color = settings.general.moonmonet_theme_color
		message_color_hex = '{' ..  rgbToHex(settings.general.moonmonet_theme_color) .. '}'
		theme[0] = 0
	else
		print('[Arizona Helper] Ошибка: нету библиотеки MoonMonet! Ставлю Dark Theme по дефолту')
		settings.general.helper_theme = 1
		message_color = settings.general.message_color
		message_color_hex = '{' ..  rgbToHex(settings.general.message_color) .. '}'
		save_settings()
		theme[0] = 1
	end
else
	message_color = settings.general.message_color
	message_color_hex = '{' ..  rgbToHex(settings.general.message_color) .. '}'
	theme[0] = (settings.general.helper_theme == 1 and 1 or 2)
end
local tmp = imgui.ColorConvertU32ToFloat4(settings.general.moonmonet_theme_color)
local mmcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
tmp = imgui.ColorConvertU32ToFloat4(settings.general.message_color)
local msgcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
------------------------------------------- Mimgui Hotkey  ---------------------------------------------------
local hotkeys = {}
if not isMonetLoader() then
	hotkey_no_errors, hotkey = pcall(require, 'mimgui_hotkeys')
	if hotkey_no_errors and not isMode('') then
		hotkey.Text.NoKey = u8'< click and select keys >'
		hotkey.Text.WaitForKey = u8'< wait keys >'
		MainMenuHotKey = hotkey.RegisterHotKey('Open MainMenu', false, decodeJson(settings.general.bind_mainmenu), function()
			if not MainWindow[0] then
				MainWindow[0] = true
			end
		end)
		CommandStopHotKey = hotkey.RegisterHotKey('Stop Command', false, decodeJson(settings.general.bind_command_stop), function() 
			sampProcessChatInput('/stop')
		end)
		FastMenuHotKey = hotkey.RegisterHotKey('Open FastMenu', false, decodeJson(settings.general.bind_fastmenu), function() 
			local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
			if valid and doesCharExist(ped) then
				local result, id = sampGetPlayerIdByCharHandle(ped)
				if result and id ~= -1 and not LeaderFastMenu[0] then
					show_fast_menu(id)
				end
			end
		end)
		LeaderFastMenuHotKey = hotkey.RegisterHotKey('Open LeaderFastMenu', false, decodeJson(settings.general.bind_leader_fastmenu), function() 
			if settings.player_info.fraction_rank_number >= 9 then 
				local valid, ped = getCharPlayerIsTargeting(PLAYER_HANDLE)
				if valid and doesCharExist(ped) then
					local result, id = sampGetPlayerIdByCharHandle(ped)
					if result and id ~= -1 and not FastMenu[0] then
						show_leader_fast_menu(id)
					end
				end
			end
		end)
		
		ActionHotKey = hotkey.RegisterHotKey('Action Key', false, decodeJson(settings.general.bind_action), function() 
			if isMode('hospital') then 
				if heal_in_chat.bool and heal_in_chat.player_id ~= nil and not sampIsDialogActive() and not sampIsChatInputActive() and not isPauseMenuActive() and not isSampfuncsConsoleActive() then
					find_and_use_command("/heal {arg_id}", heal_in_chat.player_id)
					heal_in_chat.bool = false
					heal_in_chat.player_id = nil
				end
			end
		end)

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
			for _, command in ipairs(modules.commands.data.commands.my) do
				updateHotkeyForCommand(command)
			end
			for _, command in ipairs(modules.commands.data.commands_manage.my) do
				updateHotkeyForCommand(command)
			end
		end
		function updateHotkeyForCommand(command)
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
				print('[Arizona Helper] Создан хоткей для команды /' .. command.cmd .. ' на клавишу ' .. getNameKeysFrom(command.bind))
				sampAddChatMessage('[Arizona Helper] {ffffff}Создан хоткей для команды ' .. message_color_hex .. '/' .. command.cmd .. ' {ffffff}на клавишу '  .. message_color_hex .. getNameKeysFrom(command.bind), message_color)
			end
		end
		addEventHandler('onWindowMessage', function(msg, key, lparam)
			if msg == 641 or msg == 642 or lparam == -1073741809 then hotkey.ActiveKeys = {} end
			if msg == 0x0005 then hotkey.ActiveKeys = {} end
		end)
	end
end
-------------------------------------------- RP GUNS INIT ---------------------------------------------
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
        sampAddChatMessage('Ошибка отыгровки оружия', -1)
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
------------------------------------------ Variables ---------------------------------------------------------
local binderTags = {
	my_id = function() return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)) end,
    my_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) end,
    my_rp_nick = function() return sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))):gsub('_',' ') end,
    my_doklad_nick = function() 
		local nick
		if isMonetLoader() then
			nick = ReverseTranslateNick(settings.player_info.name_surname)
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
	my_ru_nick = function() return TranslateNick(settings.player_info.name_surname) end,
	fraction_rank_number = function() return settings.player_info.fraction_rank_number end,
	fraction_rank = function() return settings.player_info.fraction_rank end,
	fraction_tag = function() return settings.player_info.fraction_tag end,
	fraction = function() return settings.player_info.fraction end,
	sex = function() 
		return (settings.player_info.sex == 'Женщина') and 'a' or ''
	end,
	get_time = function ()
		return os.date("%H:%M:%S")
	end,
	get_rank = function ()
		return giverank[0]
	end,
	get_square = function ()
		return kvadrat()
	end,
	get_area = function ()
		local x,y,z = getCharCoordinates(PLAYER_PED)
		return calculateZoneRu(x,y,z)
	end,
	get_city = function ()
		local city = {
			[0] = "Вне города",
			[1] = "Лос Сантос",
			[2] = "Сан Фиерро",
			[3] = "Лас Вентурас"
		}
		return city[getCityPlayerIsIn(PLAYER_PED)]
	end,
	get_storecar_model = function ()
		local closest_car = nil
		local closest_distance = 75
		local my_pos = {getCharCoordinates(PLAYER_PED)}
		local my_car
		if isCharInAnyCar(PLAYER_PED) then
			my_car = storeCarCharIsInNoSave(PLAYER_PED)
		end
		for _, vehicle in ipairs(getAllVehicles()) do
			if doesCharExist(getDriverOfCar(vehicle)) and vehicle ~= my_car then
				local vehicle_pos = {getCarCoordinates(vehicle)}
				local distance = getDistanceBetweenCoords3d(my_pos[1], my_pos[2], my_pos[3], vehicle_pos[1], vehicle_pos[2], vehicle_pos[3])
				if distance < closest_distance and vehicle ~= my_car then
					--sampAddChatMessage(math.floor(distance),-1)
					closest_distance = distance
					closest_car = vehicle
				end
				--sampAddChatMessage(select(2, sampGetPlayerIdByCharHandle(getDriverOfCar(vehicle))), 0x009EFF)
			end
		end
		if closest_car then
			local clr1, clr2 = getCarColours(closest_car)
			local CarColorName = ""
			local colorNames = {
				[0] = "чёрного",
				[1] = "белого",
				[2] = "бирюзового",
				[3] = "бордового",
				[4] = "тёмно-зелёного",
				[5] = "красно-пурпурного",
				[6] = "золотисто-жёлтого",
				[7] = "синего",
				[8] = "светло-серого",
				[9] = "серо-зелёного",
				[10] = "тёмно-синего",
				[11] = "серо-синего",
				[12] = "голубино-синего",
				[13] = "графитово-серого",
				[14] = "очень светло-серого",
				[15] = "светло-серого",
				[16] = "тёмно-зелёного",
				[17] = "насыщенного красно-коричневого",
				[18] = "тёмно-розового",
				[19] = "серо-коричневого",
				[20] = "тёмно-синего",
				[21] = "светло-бурдового",
				[22] = "бордово-красного",
				[23] = "серого",
				[24] = "графитового",
				[25] = "тёмно-серого",
				[26] = "светло-серого",
				[27] = "тускло-серого",
				[28] = "тёмно-синего",
				[29] = "светло-серого",
				[30] = "черно-красного",
				[31] = "тёмно-красного",
				[32] = "светло-серого с голубым оттенком",
				[33] = "серой белки",
				[34] = "тускло-серого",
				[35] = "серо-коричневого",
				[36] = "серо-синего",
				[37] = "черно-зелёного",
				[38] = "серого",
				[39] = "серо-синего",
				[40] = "красновато-черного",
				[41] = "серо-коричневого",
				[42] = "коричнево-красного",
				[43] = "тёмно-бордового",
				[44] = "тёмно-зелёного",
				[45] = "тёмно-бордового",
				[46] = "серо-бежевого",
				[47] = "зеленовато-серого",
				[48] = "кварцевого",
				[49] = "серо-голубого",
				[50] = "серебристо-серого",
				[51] = "тёмно-зелёного",
				[52] = "серо-синего",
				[53] = "очень тёмного синего",
				[54] = "тёмно-синего",
				[55] = "тёмно-коричневого",
				[56] = "серо-голубого",
				[57] = "светло-коричневого",
				[58] = "тёмно-красного",
				[59] = "отдаленно-синего",
				[60] = "светло-серого",
				[61] = "тёмно-коричневого",
				[62] = "тёмно-красного",
				[63] = "серебристо-серого",
				[64] = "светло-серого",
				[65] = "оливкового",
				[66] = "тёмного серо-красно-коричневого",
				[67] = "аспидно-серого",
				[68] = "оливково-серого",
				[69] = "кварцевого",
				[70] = "тёмно-красного",
				[71] = "светло аспидно-серого",
				[72] = "серовато-зеленого",
				[73] = "оливково-зелёного",
				[74] = "тёмно-бордового",
				[75] = "очень тёмного синего",
				[76] = "светло-оливкового",
				[77] = "светло-коричневого",
				[78] = "тёмно-розового",
				[79] = "тёмно-синего",
				[80] = "тёмно-розового",
				[81] = "средне-серого",
				[82] = "тёмно-красного",
				[83] = "зелено-синего",
				[84] = "тёмно-коричневого",
				[85] = "тёмно-розового",
				[86] = "тёмно-зелёного",
				[87] = "тёмно-синего",
				[88] = "винно-красного",
				[89] = "светло-оливкового",
				[90] = "светло-серого",
				[91] = "пурпурно-синего",
				[92] = "тёмно-серого",
				[93] = "синего",
				[94] = "тёмно-синего",
				[95] = "тёмно-синего",
				[96] = "светло-серого",
				[97] = "аспидно-серого",
				[98] = "тёмно-серого",
				[99] = "бледно серо-коричневого",
				[100] = "брилиантово-синего",
				[101] = "кобальто-синего",
				[102] = "светло-коричневого",
				[103] = "синего",
				[104] = "светло-коричневого",
				[105] = "серовато-синего",
				[106] = "синего",
				[107] = "кварцевого",
				[108] = "брилиантово-синего",
				[109] = "серовато-синего",
				[110] = "светло оливково-серого",
				[111] = "серовато-голубого",
				[112] = "синевато-серого",
				[113] = "тёмно-коричневого",
				[114] = "серовато-зелёного",
				[115] = "тёмно-красного",
				[116] = "тёмно-синего",
				[117] = "тёмно-бордового",
				[118] = "светло-голубого",
				[119] = "красновато-коричневого",
				[120] = "кварцевого",
				[121] = "тёмно-бордового",
				[122] = "тёмно-серого",
				[123] = "тёмно-коричневого",
				[124] = "тёмно-красного",
				[125] = "тёмно-синего",
				[126] = "розового",
				[127] = "чёрного",
				[128] = "зелёного",
				[129] = "тёмного бордового",
				[130] = "синего",
				[131] = "тёмно-коричневого",
				[132] = "тёмно-красного",
				[133] = "чёрного с лёгким оттенком зелёного",
				[134] = "тёмно-синего",
				[135] = "ярко-синего",
				[136] = "аметистового",
				[137] = "травяного зелёного",
				[138] = "светло серого",
				[139] = "насыщенного пурпурно-синего",
				[140] = "светло-серого",
				[141] = "тёмно-серого",
				[142] = "оливкового",
				[143] = "тёмно-серого с фиолетовым оттенком",
				[144] = "тёмно-фиолетового",
				[145] = "светло-зелёного",
				[146] = "розовато-коричневого",
				[147] = "тёмно-фиолетового",
				[148] = "тёмного серо-оливково-зелёного",
				[149] = "очень тёмно-коричневого",
				[150] = "оливково-черного",
				[151] = "чёрного",
				[152] = "тёмно-зелёного",
				[153] = "светло-розового",
				[154] = "светло-серого",
				[155] = "тёмно-зелёного",
				[156] = "серо-коричневого",
				[157] = "чёрного",
				[158] = "тёмно-зелёного",
				[159] = "тёмно-коричневого",
				[160] = "тёмно-красного",
				[161] = "светло-коричневого",
				[162] = "тёмно-коричневого",
				[163] = "тёмно-розового",
				[164] = "тёмно-синего",
				[165] = "светло-коричневого",
				[166] = "тёмно-синего",
				[167] = "тёмно-оранжевого",
				[168] = "тёмно-синего",
				[169] = "тёмно-розового",
				[170] = "тёмно-оранжевого",
				[171] = "тёмно-оранжевого",
				[172] = "чёрного",
				[173] = "тёмно-синего",
				[174] = "синего",
				[175] = "тёмно-коричневого",
				[176] = "тёмно-оранжевого",
				[177] = "тёмно-коричневого",
				[178] = "тёмно-зелёного",
				[179] = "тёмно-синего",
				[180] = "светло-серого",
				[181] = "тёмно-зелёного",
				[182] = "тёмно-оранжевого",
				[183] = "светло-оливкового",
				[184] = "светло-синего",
				[185] = "чёрного",
				[186] = "тёмно-коричневого",
				[187] = "тёмно-синего",
				[188] = "тёмно-коричневого",
				[189] = "светло-оранжевого",
				[190] = "светло-зелёного",
				[191] = "чёрного",
				[192] = "тёмно-оранжевого",
				[193] = "тёмно-коричневого",
				[194] = "тёмно-зелёного",
				[195] = "тёмно-коричневого",
				[196] = "чёрного",
				[197] = "тёмно-синего",
				[198] = "тёмно-коричневого",
				[199] = "тёмно-оранжевого",
				[200] = "чёрного",
				[201] = "тёмно-коричневого",
				[202] = "светло-коричневого",
				[203] = "светло-коричневого",
				[204] = "чёрного",
				[205] = "тёмно-синего",
				[206] = "тёмно-зелёного",
				[207] = "чёрного",
				[208] = "тёмно-синего",
				[209] = "тёмно-зелёного",
				[210] = "чёрного",
				[211] = "тёмно-синего",
				[212] = "тёмно-зелёного",
				[213] = "чёрного",
				[214] = "тёмно-синего",
				[215] = "тёмно-коричневого",
				[216] = "тёмно-оранжевого",
				[217] = "тёмно-коричневого",
				[218] = "тёмно-синего",
				[219] = "чёрного",
				[220] = "тёмно-зелёного",
				[221] = "чёрного",
				[222] = "тёмно-коричневого",
				[223] = "чёрного",
				[224] = "тёмно-синего",
				[225] = "тёмно-зелёного",
				[226] = "чёрного",
				[227] = "тёмно-синего",
				[228] = "тёмно-коричневого",
				[229] = "тёмно-оранжевого",
				[230] = "чёрного",
				[231] = "тёмно-коричневого",
				[232] = "тёмно-синего",
				[233] = "чёрного",
				[234] = "тёмно-синего",
				[235] = "тёмно-коричневого",
				[236] = "тёмно-зелёного",
				[237] = "чёрного",
				[238] = "тёмно-оранжевого",
				[239] = "тёмно-коричневого",
				[240] = "тёмно-зелёного",
				[241] = "тёмно-синего",
				[242] = "тёмно-коричневого",
				[243] = "тёмно-синего",
				[244] = "чёрного",
				[245] = "тёмно-зелёного",
				[246] = "тёмно-коричневого",
				[247] = "тёмно-синего",
				[248] = "тёмно-зелёного",
				[249] = "чёрного",
				[250] = "тёмно-оранжевого",
				[251] = "тёмно-синего",
				[252] = "чёрного",
				[253] = "тёмно-коричневого",
				[254] = "тёмно-зелёного",
				[255] = "тёмно-синего"
			}
			if clr1 == clr2 then
				CarColorName = colorNames[clr1] .. " цвета"
			else
				CarColorName = colorNames[clr1] .. '-' .. colorNames[clr2] .. " цвета"
			end
			function getVehPlateNumberByCarHandle(car)
				for i, plate in pairs(modules.arz_veh.cache) do
					result, veh = sampGetCarHandleBySampVehicleId(plate.carID)
					if result and veh == car then
						return ' (' .. plate.number .. ') '
					end
				end
				return ' '
			end
			return "" .. getNameOfARZVehicleModel(getCarModel(closest_car)) .. getVehPlateNumberByCarHandle(closest_car) .. CarColorName
		else
			sampAddChatMessage("[Arizona Helper] {ffffff}Не удалось получить модель ближайшего т/c с водителем!", 0x009EFF)
			return ' транспортного средства'
		end
	end,
	get_form_su = function ()
		return form_su
	end,
	get_patrool_format_time = function ()
		local hours = math.floor(patrool.time / 3600)
		local minutes = math.floor((patrool.time % 3600) / 60)
		local secs = patrool.time % 60
		if hours > 0 then
			return string.format("%d часов %d минут %d секунд", hours, minutes, secs)
		elseif minutes > 0 then
			return string.format("%d минут %d секунд", minutes, secs)
		else
			return string.format("%d секунд(-ы)", secs)
		end
	end,
	get_patrool_time = function ()
		local hours = math.floor(patrool.time / 3600)
		local minutes = math.floor(( patrool.time % 3600) / 60)
		local secs = patrool.time % 60
		if hours > 0 then
			return string.format("%02d:%02d:%02d", hours, minutes, secs)
		else
			return string.format("%02d:%02d", minutes, secs)
		end
	end,
	get_patrool_code = function ()
		return patrool.code
	end,
	get_patrool_mark = function ()
		return patrool.mark .. '-' .. select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
	end,
	get_patrool_name = function ()
		return patrool.name
	end,
	get_car_units = function ()
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
							units = units .. nickname .. ' ' -- В случае, если нет подчеркивания
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
	switchCarSiren = function ()
		if isCharInAnyCar(PLAYER_PED) then
			local car = storeCarCharIsInNoSave(PLAYER_PED)
			if getDriverOfCar(car) == PLAYER_PED then
				switchCarSiren(car, not isCarSirenOn(car))
				return '/me ' .. ( isCarSirenOn(car) and 'включает' or 'выключает') .. ' мигалки в своём транспортном средстве'
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
	price_avto1 = function() return settings.lc.price.avto1 end,
	price_avto2 = function() return settings.lc.price.avto2 end,
	price_avto3 = function() return settings.lc.price.avto3 end,
	price_moto1 = function() return settings.lc.price.moto1 end,
	price_moto2 = function() return settings.lc.price.moto2 end,
	price_moto3 = function() return settings.lc.price.moto3 end,
	price_fish1 = function() return settings.lc.price.fish1 end,
	price_fish2 = function() return settings.lc.price.fish2 end,
	price_fish3 = function() return settings.lc.price.fish3 end,
	price_swim1 = function() return settings.lc.price.swim1 end,
	price_swim2 = function() return settings.lc.price.swim2 end,
	price_swim3 = function() return settings.lc.price.swim3 end,
	price_gun1 = function() return settings.lc.price.gun1 end,
	price_gun2 = function() return settings.lc.price.gun2 end,
	price_gun3 = function() return settings.lc.price.gun3 end,
	price_hunt1 = function() return settings.lc.price.hunt1 end,
	price_hunt2 = function() return settings.lc.price.hunt2 end,
	price_hunt3 = function() return settings.lc.price.hunt3 end,
	price_klad1 = function() return settings.lc.price.klad1 end,
	price_klad2 = function() return settings.lc.price.klad2 end,
	price_klad3 = function() return settings.lc.price.klad3 end,
	price_taxi1 = function() return settings.lc.price.taxi1 end,
	price_taxi2 = function() return settings.lc.price.taxi2 end,
	price_taxi3 = function() return settings.lc.price.taxi3 end,
	price_mexa1 = function() return settings.lc.price.mexa1 end,
	price_mexa2 = function() return settings.lc.price.mexa2 end,
	price_mexa3 = function() return settings.lc.price.mexa3 end,
	price_fly1 = function() return settings.lc.price.fly1 end,
	price_fly2 = function() return settings.lc.price.fly2 end,
	price_fly3 = function() return settings.lc.price.fly3 end,
	-- MH
	price_heal = function()
		if sampGetCurrentServerName():find("Vice City") then
			return settings.mh.price.heal_vc
		else
			return settings.mh.price.heal
		end
	end,
	price_actorheal = function()
		if u8(sampGetCurrentServerName()):find("Vice City") then
			return settings.mh.price.healactor_vc
		else
			return settings.mh.price.healactor
		end
	end,
	price_medosm = function() return settings.mh.price.medosm end,
	price_mticket = function() return settings.mh.price.mticket end,
	price_healbad = function() return settings.mh.price.healbad end,
	price_ant = function() return settings.mh.price.ant end,
	price_recept = function() return settings.mh.price.recept end,
	price_med7 = function() return settings.mh.price.med7 end,
	price_med14 = function() return settings.mh.price.med14 end,
	price_med30 = function() return settings.mh.price.med30 end,
	price_med60 = function() return settings.mh.price.med60 end,
	get_medcard_days = function() 
		return medcard_days[0]
	end,
	get_medcard_status = function() 
		return medcard_status[0]
	end,
	get_recepts = function ()
		return recepts[0]
	end,
	get_ants = function ()
		return antibiotiks[0]
	end,
	get_medcard_price = function ()
		if medcard_days[0] == 0 then
			return settings.mh.price.med7
		elseif medcard_days[0] == 1 then
			return settings.mh.price.med14
		elseif medcard_days[0] == 2 then
			return settings.mh.price.med30
		elseif medcard_days[0] == 3 then
			return settings.mh.price.med60
		else
			return 1000
		end
	end,
}
 
local PlayerID = nil
local player_id = nil
local check_stats = false
local clicked = false
local isActiveCommand = false
local debug_mode = false
local command_stop = false
local command_pause = false

-- only 9/10
local spawncar_bool = false

local vc_vize = {bool = false, player_id = nil}

local message1
local message2
local message3
local anti_flood_auto_uval = false
local auto_uval_checker = false
local platoon_check = false

-- MH
local godeath_player_id = nil
local godeath_locate = ''
local godeath_city = ''
local auto_healme = false

-- MJ
local awanted = false
local afind = false

-- LC
local givelic = {bool = false, time = 1, type = ''}

local InfraredVision = false
local NightVision = false


-- local asdebug = false
-- local as_debug = {
-- 	show_hit = {

-- 	},
-- 	clicked = {

-- 	},
-- }
-- local path_debug = configDirectory .. "/debug.json"
------------------------------------------- Functions -----------------------------------------------------
function welcome_message()
	if not sampIsLocalPlayerSpawned() then 
		sampAddChatMessage('[Arizona Helper] {ffffff}Инициализация хелпера прошла успешно!',message_color)
		sampAddChatMessage('[Arizona Helper] {ffffff}Для полной загрузки хелпера сначало заспавнитесь (войдите на сервер)',message_color)
		repeat wait(0) until sampIsLocalPlayerSpawned()
	end
	sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка хелпера прошла успешно!', message_color)
	print('[Arizona Helper] Полная загрузка хелпера прошла успешно!')
	show_arz_notify('info', 'Arizona Helper', "Загрузка хелпера прошла успешно!", 3000)
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
		if not isActiveCommand then
			if command_stop then
				command_stop = false
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
					isActiveCommand = true
					command_pause = false
					if modifiedText:find('&.+&') then
						info_stop_command()
					end
					local lines = {}
					for line in string.gmatch(modifiedText, "[^&]+") do
						table.insert(lines, line)
					end
					for line_index, line in ipairs(lines) do
						if command_stop then 
							command_stop = false 
							isActiveCommand = false
							if isMonetLoader() and settings.general.mobile_stop_button then
								CommandStopWindow[0] = false
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
								MedCardMenu[0] = true
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
								ReceptMenu[0] = true
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
								AntibiotikMenu[0] = true
								break
							elseif line == '{lmenu_vc_vize}' then
								if cmd_arg == '{arg_id}' then
									vc_vize.player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										vc_vize.player_id = tonumber(arg_id)
									end
								end
								vc_vize.bool = true
								sampSendChat("/lmenu")
								break
							elseif line == '{give_platoon}' then
								if cmd_arg == '{arg_id}' then
									player_id = arg
								elseif cmd_arg == '{arg_id} {arg2}' then
									local arg_id, arg2 = arg:match('(%d+) (.+)')
									if arg_id and arg2 and isParamSampID(arg_id) then
										player_id = arg_id
									end
								end
								platoon_check = true
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
								GiveRankMenu[0] = true
								break
							elseif line == "{pause}" then
								sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. chat_cmd .. ' поставлена на паузу!', message_color)
								command_pause = true
								CommandPauseWindow[0] = true
								while command_pause do
									wait(0)
								end
								if not command_stop then
									sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. chat_cmd, message_color)	
								end			
							else
								if not command_stop then
									if line_index ~= 1 then wait(cmd_waiting * 1000) end
									if not command_stop then 
										for tag, replacement in pairs(binderTags) do
											if line:find("{" .. tag .. "}") then
												local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
												if success then
													line = result
												end
											end
										end
										sampSendChat(line)
									end
								else
									command_stop = false 
									isActiveCommand = false
									if isMonetLoader() and settings.general.mobile_stop_button then
										CommandStopWindow[0] = false
									end
									sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. chat_cmd .. " успешно остановлена!", message_color) 	
									break
								end
							end
						end
					end
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
					end
				end)
			end
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)
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
	sampAddChatMessage('[Arizona Helper] {ffffff}Не могу найти бинд для выполнения этой команды! Попробуйте сбросить настройки', message_color)
	playNotifySound()
end
function initialize_commands()
	sampRegisterChatCommand("helper", function() MainWindow[0] = not MainWindow[0] end)
	sampRegisterChatCommand("hm", show_fast_menu)
	sampRegisterChatCommand("stop", function() 
		if isActiveCommand then command_stop = true else 
			sampAddChatMessage('[Arizona Helper] {ffffff}В данный момент нету никакой активной команды/отыгровки!', message_color) 
		end
	end)
	sampRegisterChatCommand("debug", function() debug_mode = not debug_mode sampAddChatMessage('[Arizona Helper] {ffffff}Отслеживание команд ' .. (debug_mode and 'включено!' or 'выключено!'), message_color) end)
	sampRegisterChatCommand("fixsize", function()
		settings.general.custom_dpi = 1.0
		settings.general.autofind_dpi = false
		sampAddChatMessage('[Arizona Helper] {ffffff}Размер менюшек хелпера сброшен к стандартным! Перезапуск...', message_color)
		save_settings()
		reload_script = true
		thisScript():reload()
	end)
	sampRegisterChatCommand("rpguns", function()
		imgui.StrCopy(input, '')
		RPWeaponWindow[0] = not RPWeaponWindow[0] 
	end)
	sampRegisterChatCommand('probiv', function (id)
		if isParamSampID(id) then
			probiv = nil
			imgui.StrCopy(input, sampGetPlayerNickname(id))
			imgui.StrCopy(input_probiv_key, u8(settings.general.probiv_api_key))
			ProbivMenu[0] = true
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте /probiv [ID игрока]', message_color)
		end
	end)
	sampRegisterChatCommand("pnv", function(arg)
		if not isActiveCommand then
			NightVision = not NightVision
			if NightVision then
				sampSendChat('/me достаёт из кармана очки ночного видения и надевает их')
			else
				sampSendChat('/me снимает с себя очки ночного видения и убирает их в карман')
			end
			setNightVision(NightVision)	
			InfraredVision = false
			setInfraredVision(InfraredVision)	
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)
	sampRegisterChatCommand("irv", function(arg)
		if not isActiveCommand then
			InfraredVision = not InfraredVision
			setInfraredVision(InfraredVision)	
			NightVision = false
			setNightVision(NightVision)	
			if InfraredVision then
				sampSendChat('/me достаёт из кармана инфакрасные очки и надевает их')
			else
				sampSendChat('/me снимает с себя инфакрасные очки и убирает их в карман')
			end
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)

	if not isMode('none') then
		sampRegisterChatCommand("mb", function(arg)
			if not isActiveCommand then
				if MembersWindow[0] then
					MembersWindow[0] = false
					updmembers.check = false
					sampAddChatMessage('[Arizona Helper] {ffffff}Меню списка сотрудников закрыто!', message_color)
				else
					members_new = {} 
					members_info.check = true 
					sampSendChat("/members")
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
		sampRegisterChatCommand("dep", function(arg)
			if not isActiveCommand then
				DeportamentWindow[0] = not DeportamentWindow[0]
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
		sampRegisterChatCommand("sob", function(arg)
			if not isActiveCommand then
				if isParamSampID(arg) then
					player_id = tonumber(arg)
					SobesMenu[0] = not SobesMenu[0]
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
			if not isActiveCommand then
				if isParamSampID(arg) then
					if #modules.smart_uk.data ~= 0 then
						player_id = tonumber(arg)
						SumMenuWindow[0] = true 
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сначало загрузите/заполните систему умного розыска в /helper - Функции ' .. binderTags.fraction_tag(), message_color)
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
			if not isActiveCommand then
				if isParamSampID(arg) then
					if #modules.smart_pdd.data ~= 0 then
						player_id = tonumber(arg)
						TsmMenuWindow[0] = true
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сначало загрузите/заполните систему умных штрафов в /helper - Функции ' .. binderTags.fraction_tag(), message_color)
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
		sampRegisterChatCommand("meg", function ()
			MegafonWindow[0] = not MegafonWindow[0]
		end)
		sampRegisterChatCommand("afind", function (arg)
			sampAddChatMessage('НЕДОСТУПНО В ФРИ ВЕРСИИ', -1)
		end)
		sampRegisterChatCommand("wanted", function(arg)
			sampSendChat('/wanted ' .. arg)
			sampAddChatMessage('[Arizona Helper] {ffffff}Лучше используйте /wanteds для автосканирования всего вантеда!', message_color)
		end)
		sampRegisterChatCommand("wanteds", function(arg)
			if WantedWindow[0] then
				WantedWindow[0] = false
				updwanteds.check = false
				sampAddChatMessage('[Arizona Helper] {ffffff}Меню списка преступников закрыто!', message_color)
			elseif not isActiveCommand then
				lua_thread.create(function()
					local max_lvl = isMode('fbi') and 7 or 6
					sampAddChatMessage('[Arizona Helper] {ffffff}Сканирование /wanted, ожидайте ' .. message_color_hex .. max_lvl .. ' {ffffff}секунд...', message_color)
					show_arz_notify('info', 'Arizona Helper', "Сканирование /wanted...", 2500)
					wanted_new = {}
					check_wanted = true
					for i = max_lvl, 1, -1 do
						--printStringNow('WANTED ' .. i, 1000)
						sampSendChat('/wanted ' .. i)
						wait(1000)
					end
					check_wanted = false
					if #wanted_new == 0 then
						sampAddChatMessage('[Arizona Helper] {ffffff}Сейчас на сервере нету игроков с розыском!', message_color)
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сканирование /wanted окончено! Для закрытия меню введите команду ещё раз', message_color)
						wanted = wanted_new
						updwanteds.time = 0
						updwanteds.last_time = os.time()
						updwanteds.check = true
						WantedWindow[0] = true
						
					end
				end)
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)

		sampRegisterChatCommand("patrool", function(arg)
			if not isActiveCommand then
				-- if isCharInAnyCar(PLAYER_PED) or PatroolMenu[0] then
				-- 	PatroolMenu[0] = not PatroolMenu[0]
				-- else
				-- 	sampAddChatMessage('[Arizona Helper] {ffffff}Нельзя начать патруль, вы должны быть за рулём транспорта!', message_color)
				-- end
				PatroolMenu[0] = not PatroolMenu[0]
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
				playNotifySound()
			end
		end)
	end

	sampRegisterChatCommand("post", function(arg)
		if not isActiveCommand then
			imgui.StrCopy(input, '')
			PostMenu[0] = not PostMenu[0]
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Дождитесь завершения отыгровки предыдущей команды!', message_color)
			playNotifySound()
		end
	end)

	if isMode('prison') then
		sampRegisterChatCommand("pum", function(arg) 
			if not isActiveCommand then
				if isParamSampID(arg) then
					if #modules.smart_rptp.data ~= 0 then
						player_id = tonumber(arg)
						PuMenuWindow[0] = true 
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Сначало загрузите/заполните систему умного срока в /helper - Функции ' .. binderTags.fraction_tag(), message_color)
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

	if isMode('army') or isMode('prison') then
		
		

	end
	
	
	-- /do Балаклава на голове.&/me стягивает балаклаву с головы и прицепляет её к тактичекому поясу&/mask&/do Балаклава прикреплена к тактическому поясу.
	-- /do Балаклава прикреплена к тактическому поясу.&/me достаёт балаклаву и натягивает её себе на голову&/mask&/do Балаклава на голове.

	registerCommandsFrom(modules.commands.data.commands.my)

	if settings.player_info.fraction_rank_number >= 9 then
		sampRegisterChatCommand("lm", show_leader_fast_menu)
		sampRegisterChatCommand("spcar", function()
			if not isActiveCommand then
				lua_thread.create(function()
					isActiveCommand = true
					if isMonetLoader() and settings.general.mobile_stop_button then
						sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
						CommandStopWindow[0] = true
					elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop then
						sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
					end
					sampSendChat("/rb Внимание! Через 15 секунд будет спавн транспорта организации.")
					wait(1500)
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
						return
					end
					sampSendChat("/rb Займите транспорт, иначе он будет заспавнен.")
					wait(13500)	
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /spcar успешно остановлена!', message_color) 
						return
					end
					spawncar_bool = true
					sampSendChat("/lmenu")
					isActiveCommand = false
					if isMonetLoader() and settings.general.mobile_stop_button then
						CommandStopWindow[0] = false
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
        for k, v in pairs({['ph'] = 'ф',['Ph'] = 'Ф',['Ch'] = 'Ч',['ch'] = 'ч',['Th'] = 'Т',['th'] = 'т',['Sh'] = 'Ш',['sh'] = 'ш', ['ea'] = 'и',['Ae'] = 'Э',['ae'] = 'э',['size'] = 'сайз',['Jj'] = 'Джейджей',['Whi'] = 'Вай',['lack'] = 'лэк',['whi'] = 'вай',['Ck'] = 'К',['ck'] = 'к',['Kh'] = 'Х',['kh'] = 'х',['hn'] = 'н',['Hen'] = 'Ген',['Zh'] = 'Ж',['zh'] = 'ж',['Yu'] = 'Ю',['yu'] = 'ю',['Yo'] = 'Ё',['yo'] = 'ё',['Cz'] = 'Ц',['cz'] = 'ц', ['ia'] = 'я', ['ea'] = 'и',['Ya'] = 'Я', ['ya'] = 'я', ['ove'] = 'ав',['ay'] = 'эй', ['rise'] = 'райз',['oo'] = 'у', ['Oo'] = 'У', ['Ee'] = 'И', ['ee'] = 'и', ['Un'] = 'Ан', ['un'] = 'ан', ['Ci'] = 'Ци', ['ci'] = 'ци', ['yse'] = 'уз', ['cate'] = 'кейт', ['eow'] = 'яу', ['rown'] = 'раун', ['yev'] = 'уев', ['Babe'] = 'Бэйби', ['Jason'] = 'Джейсон', ['liy'] = 'лий', ['ane'] = 'ейн', ['ame'] = 'ейм'}) do
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
        ['Джейсон'] = 'Jason', ['лий'] = 'liy', ['ейн'] = 'ein', ['ейм'] = 'ame'
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
        ['э'] = 'e', ['ю'] = 'yu', ['я'] = 'ya'
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
		sampAddChatMessage('[Arizona Helper] {ffffff}Добавить/убрать команду из FastMenu можно в /helper - RP команды - Изменение, аргумент {arg_id}, галочка', message_color)
		player_id = tonumber(id)
		FastMenu[0] = true
	else
		if isMonetLoader() or settings.general.bind_fastmenu == nil then
			if not FastMenuPlayers[0] then
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
		sampAddChatMessage('[Arizona Helper] {ffffff}Добавить/убрать команду из FastMenu можно в /helper - RP команды - Изменение, аргумент {arg_id}, галочка', message_color)
		LeaderFastMenu[0] = true
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
function show_arz_notify(type, title, text, time)
	if isMonetLoader() then
	-- 	if type == 'info' then
	-- 		type = 3
	-- 	elseif type == 'error' then
	-- 		type = 2
	-- 	elseif type == 'success' then
	-- 		type = 1
	-- 	end
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 62)
	-- 	raknetBitStreamWriteInt8(bs, 6)
	-- 	raknetBitStreamWriteBool(bs, true)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	-- 	local json = encodeJson({
	-- 		styleInt = type,
	-- 		title = title,
	-- 		text = text,
	-- 		duration = time
	-- 	})
	-- 	local interfaceid = 6
	-- 	local subid = 0
	-- 	local bs = raknetNewBitStream()
	-- 	raknetBitStreamWriteInt8(bs, 84)
	-- 	raknetBitStreamWriteInt8(bs, interfaceid)
	-- 	raknetBitStreamWriteInt8(bs, subid)
	-- 	raknetBitStreamWriteInt32(bs, #json)
	-- 	raknetBitStreamWriteString(bs, json)
	-- 	raknetEmulPacketReceiveBitStream(220, bs)
	-- 	raknetDeleteBitStream(bs)
	else

		local function escape_js(s)
        return s:gsub("\\", "\\\\"):gsub('"', '\\"')
    end

    local safe_type = escape_js(type)
    local safe_title = escape_js(title)
    local safe_text = escape_js(text)
    local safe_time = tostring(time)

    local str = ('window.executeEvent("event.notify.initialize", "[\\"%s\\", \\"%s\\", \\"%s\\", \\"%s\\"]");')
        :format(safe_type, safe_title, safe_text, safe_time)

    visualCEF(str, true)
	end
end
function run_code(code)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 17)
    raknetBitStreamWriteInt32(bs, 0)
    raknetBitStreamWriteInt32(bs, string.len(code))
    raknetBitStreamWriteString(bs, code)
    raknetEmulPacketReceiveBitStream(220, bs)
    raknetDeleteBitStream(bs)
end
function openLink(link)
	if isMonetLoader() then
		gta._Z12AND_OpenLinkPKc(link)
	else
		os.execute("explorer " .. link)
	end
end

-- MH
function fast_heal_in_chat(id)
	if isMonetLoader() then
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтоб вылечить игрока ' .. sampGetPlayerNickname(id) .. ', в течении 5-ти секунд нажмите кнопку',message_color)
		heal_in_chat.player_id = id
		heal_in_chat.bool = true
		FastHealMenu[0] = true
		lua_thread.create(function()
			wait(5000)
			if heal_in_chat.bool then
				FastHealMenu[0] = false
				heal_in_chat.bool = false
				sampAddChatMessage('[Arizona Helper] {ffffff}Вы не успели вылечить игрока ' .. sampGetPlayerNickname(id), message_color)
			end
		end)
	elseif hotkey_no_errors then
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы вылечить игрока ' .. sampGetPlayerNickname(id) .. ' нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_fastheal) .. ' {ffffff}в течении 5-ти секунд!',message_color)
		show_arz_notify('info', 'Arizona Helper', 'Нажмите ' .. getNameKeysFrom(settings.general.bind_fastheal) .. ' чтобы быстро вылечить игрока', 5000)
		heal_in_chat.player_id = id
		heal_in_chat.bool = true
		lua_thread.create(function()
			wait(5000)
			if heal_in_chat.bool then
				heal_in_chat.bool = false
				sampAddChatMessage('[Arizona Helper] {ffffff}Вы не успели вылечить игрока ' .. sampGetPlayerNickname(id), message_color)
			end
		end)
	end
end

function sampGetPlayerIdByNickname(nick)
	local id = nil
	nick = tostring(nick)
	local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
	if sampGetPlayerNickname(myid):find(nick) then return myid end
	for i = 0, 999 do
	    if sampIsPlayerConnected(i) and sampGetPlayerNickname(i):find(nick) then
		   id = i
		   break
	    end
	end
	if id == nil then
		sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка: не удалось получить ID игрока!', message_color)
		id = ''
	end
	return id
end
function getNameOfARZVehicleModel(id)
	local need_download_arzveh = false
	if doesFileExist(modules.arz_veh.path) then
		if modules.arz_veh.data and #modules.arz_veh.data ~= 0 then
			local check = false
			for _, vehicle in ipairs(modules.arz_veh.data) do
				if vehicle.model_id == id then
					check = true
					--sampAddChatMessage("[Arizona Helper] {ffffff}Самый ближайший транспорт к вам это " .. vehicle.name ..  " [ID " .. id .. "].", message_color)
					return " " .. vehicle.name
				end
			end
			if not check then
				need_download_arzveh = true
			end
		else
			sampAddChatMessage('[Arizona Helper] {ffffff}Не удалось получить модель т/c с ID ' .. id .. "! Ошибка инициализации VehiclesArizona.json", message_color)
			need_download_arzveh = true
		end
	else
		sampAddChatMessage('[Arizona Helper] {ffffff}Не удалось получить модель т/c с ID ' .. id .. "! Отсуствует файл VehiclesArizona.json", message_color)
		need_download_arzveh = true
	end
	if need_download_arzveh then
		sampAddChatMessage('[Arizona Helper] {ffffff}Пытаюсь скачать файл VehiclesArizona.json в папку ' .. modules.arz_veh.path, message_color)
		download_file = 'arz_veh'
		downloadFileFromUrlToPath('https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Vehicles/VehiclesArizona.json', modules.arz_veh.path)
		return ' транспортного средства'
	end
end
function kvadrat()
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
end
function calculateZoneRu(x, y, z)
    local streets = {
        {"Клуб Ависпа", -2667.810, -302.135, -28.831, -2646.400, -262.320, 71.169},
        {"Аэропорт", -1315.420, -405.388, 15.406, -1264.400, -209.543, 25.406},
        {"Клуб Ависпа", -2550.040, -355.493, 0.000, -2470.040, -318.493, 39.700},
        {"Аэропорт", -1490.330, -209.543, 15.406, -1264.400, -148.388, 25.406},
        {"Гарсия", -2395.140, -222.589, -5.3, -2354.090, -204.792, 200.000},
        {"Шейди-Кэбин", -1632.830, -2263.440, -3.0, -1601.330, -2231.790, 200.000},
        {"Восточный ЛС", 2381.680, -1494.030, -89.084, 2421.030, -1454.350, 110.916},
        {"Грузовое депо", 1236.630, 1163.410, -89.084, 1277.050, 1203.280, 110.916},
        {"Пересечение Блэкфилд", 1277.050, 1044.690, -89.084, 1315.350, 1087.630, 110.916},
        {"Клуб Ависпа", -2470.040, -355.493, 0.000, -2270.040, -318.493, 46.100},
        {"Темпл", 1252.330, -926.999, -89.084, 1357.000, -910.170, 110.916},
        {"Станция Юнити", 1692.620, -1971.800, -20.492, 1812.620, -1932.800, 79.508},
        {"Грузовое депо ЛВ", 1315.350, 1044.690, -89.084, 1375.600, 1087.630, 110.916},
        {"Лос-Флорес", 2581.730, -1454.350, -89.084, 2632.830, -1393.420, 110.916},
        {"Казино", 2437.390, 1858.100, -39.084, 2495.090, 1970.850, 60.916},
        {"Химзавод Истер-Бэй", -1132.820, -787.391, 0.000, -956.476, -768.027, 200.000},
        {"Деловой район", 1370.850, -1170.870, -89.084, 1463.900, -1130.850, 110.916},
        {"Восточная Эспаланда", -1620.300, 1176.520, -4.5, -1580.010, 1274.260, 200.000},
        {"Станция Маркет", 787.461, -1410.930, -34.126, 866.009, -1310.210, 65.874},
        {"Станция Линден", 2811.250, 1229.590, -39.594, 2861.250, 1407.590, 60.406},
        {"Пересечение Монтгомери", 1582.440, 347.457, 0.000, 1664.620, 401.750, 200.000},
        {"Мост Фредерик", 2759.250, 296.501, 0.000, 2774.250, 594.757, 200.000},
        {"Станция Йеллоу-Белл", 1377.480, 2600.430, -21.926, 1492.450, 2687.360, 78.074},
        {"Деловой район", 1507.510, -1385.210, 110.916, 1582.550, -1325.310, 335.916},
        {"Джефферсон", 2185.330, -1210.740, -89.084, 2281.450, -1154.590, 110.916},
        {"Малхолланд", 1318.130, -910.170, -89.084, 1357.000, -768.027, 110.916},
        {"Клуб Ависпа", -2361.510, -417.199, 0.000, -2270.040, -355.493, 200.000},
        {"Джефферсон", 1996.910, -1449.670, -89.084, 2056.860, -1350.720, 110.916},
        {"Западаное шоссе", 1236.630, 2142.860, -89.084, 1297.470, 2243.230, 110.916},
        {"Джефферсон", 2124.660, -1494.030, -89.084, 2266.210, -1449.670, 110.916},
        {"Северное шоссе", 1848.400, 2478.490, -89.084, 1938.800, 2553.490, 110.916},
        {"Родео", 422.680, -1570.200, -89.084, 466.223, -1406.050, 110.916},
        {"Станция Крэнберри", -2007.830, 56.306, 0.000, -1922.000, 224.782, 100.000},
        {"Деловой район", 1391.050, -1026.330, -89.084, 1463.900, -926.999, 110.916},
        {"Западный Рэдсэндс", 1704.590, 2243.230, -89.084, 1777.390, 2342.830, 110.916},
        {"Маленькая Мексика", 1758.900, -1722.260, -89.084, 1812.620, -1577.590, 110.916},
        {"Пересечение Блэкфилд", 1375.600, 823.228, -89.084, 1457.390, 919.447, 110.916},
        {"Аэропорт", 1974.630, -2394.330, -39.084, 2089.000, -2256.590, 60.916},
        {"Бекон-Хилл", -399.633, -1075.520, -1.489, -319.033, -977.516, 198.511},
        {"Родео", 334.503, -1501.950, -89.084, 422.680, -1406.050, 110.916},
        {"Ричман", 225.165, -1369.620, -89.084, 334.503, -1292.070, 110.916},
        {"Деловой район", 1724.760, -1250.900, -89.084, 1812.620, -1150.870, 110.916},
        {"Стрип-клуб", 2027.400, 1703.230, -89.084, 2137.400, 1783.230, 110.916},
        {"Деловой район", 1378.330, -1130.850, -89.084, 1463.900, -1026.330, 110.916},
        {"Пересечение Блэкфилд", 1197.390, 1044.690, -89.084, 1277.050, 1163.390, 110.916},
        {"Конференц Центр", 1073.220, -1842.270, -89.084, 1323.900, -1804.210, 110.916},
        {"Монтгомери", 1451.400, 347.457, -6.1, 1582.440, 420.802, 200.000},
        {"Долина Фостер", -2270.040, -430.276, -1.2, -2178.690, -324.114, 200.000},
        {"Часовня Блэкфилд", 1325.600, 596.349, -89.084, 1375.600, 795.010, 110.916},
        {"Аэропорт", 2051.630, -2597.260, -39.084, 2152.450, -2394.330, 60.916},
        {"Малхолланд", 1096.470, -910.170, -89.084, 1169.130, -768.027, 110.916},
        {"Поле для гольфа", 1457.460, 2723.230, -89.084, 1534.560, 2863.230, 110.916},
        {"Стрип", 2027.400, 1783.230, -89.084, 2162.390, 1863.230, 110.916},
        {"Джефферсон", 2056.860, -1210.740, -89.084, 2185.330, -1126.320, 110.916},
        {"Малхолланд", 952.604, -937.184, -89.084, 1096.470, -860.619, 110.916},
        {"Альдеа-Мальвада", -1372.140, 2498.520, 0.000, -1277.590, 2615.350, 200.000},
        {"Лас-Колинас", 2126.860, -1126.320, -89.084, 2185.330, -934.489, 110.916},
        {"Лас-Колинас", 1994.330, -1100.820, -89.084, 2056.860, -920.815, 110.916},
        {"Ричман", 647.557, -954.662, -89.084, 768.694, -860.619, 110.916},
        {"Грузовое депо", 1277.050, 1087.630, -89.084, 1375.600, 1203.280, 110.916},
        {"Северное шоссе", 1377.390, 2433.230, -89.084, 1534.560, 2507.230, 110.916},
        {"Уиллоуфилд", 2201.820, -2095.000, -89.084, 2324.000, -1989.900, 110.916},
        {"Северное шоссе", 1704.590, 2342.830, -89.084, 1848.400, 2433.230, 110.916},
        {"Темпл", 1252.330, -1130.850, -89.084, 1378.330, -1026.330, 110.916},
        {"Маленькая Мексика", 1701.900, -1842.270, -89.084, 1812.620, -1722.260, 110.916},
        {"Квинс", -2411.220, 373.539, 0.000, -2253.540, 458.411, 200.000},
        {"Аэропорт", 1515.810, 1586.400, -12.500, 1729.950, 1714.560, 87.500},
        {"Ричман", 225.165, -1292.070, -89.084, 466.223, -1235.070, 110.916},
        {"Темпл", 1252.330, -1026.330, -89.084, 1391.050, -926.999, 110.916},
        {"Восточный ЛС", 2266.260, -1494.030, -89.084, 2381.680, -1372.040, 110.916},
        {"Воссточное шоссе", 2623.180, 943.235, -89.084, 2749.900, 1055.960, 110.916},
        {"Уиллоуфилд", 2541.700, -1941.400, -89.084, 2703.580, -1852.870, 110.916},
        {"Лас-Колинас", 2056.860, -1126.320, -89.084, 2126.860, -920.815, 110.916},
        {"Воссточное шоссе", 2625.160, 2202.760, -89.084, 2685.160, 2442.550, 110.916},
        {"Родео", 225.165, -1501.950, -89.084, 334.503, -1369.620, 110.916},
        {"Лас-Брухас", -365.167, 2123.010, -3.0, -208.570, 2217.680, 200.000},
        {"Воссточное шоссе", 2536.430, 2442.550, -89.084, 2685.160, 2542.550, 110.916},
        {"Родео", 334.503, -1406.050, -89.084, 466.223, -1292.070, 110.916},
        {"Вайнвуд", 647.557, -1227.280, -89.084, 787.461, -1118.280, 110.916},
        {"Родео", 422.680, -1684.650, -89.084, 558.099, -1570.200, 110.916},
        {"Северное шоссе", 2498.210, 2542.550, -89.084, 2685.160, 2626.550, 110.916},
        {"Деловой район", 1724.760, -1430.870, -89.084, 1812.620, -1250.900, 110.916},
        {"Родео", 225.165, -1684.650, -89.084, 312.803, -1501.950, 110.916},
        {"Джефферсон", 2056.860, -1449.670, -89.084, 2266.210, -1372.040, 110.916},
        {"Хэмптон-Барнс", 603.035, 264.312, 0.000, 761.994, 366.572, 200.000},
        {"Темпл", 1096.470, -1130.840, -89.084, 1252.330, -1026.330, 110.916},
        {"Мост Кинкейд", -1087.930, 855.370, -89.084, -961.950, 986.281, 110.916},
        {"Пляж Верона", 1046.150, -1722.260, -89.084, 1161.520, -1577.590, 110.916},
        {"Коммерческий район", 1323.900, -1722.260, -89.084, 1440.900, -1577.590, 110.916},
        {"Малхолланд", 1357.000, -926.999, -89.084, 1463.900, -768.027, 110.916},
        {"Родео", 466.223, -1570.200, -89.084, 558.099, -1385.070, 110.916},
        {"Малхолланд", 911.802, -860.619, -89.084, 1096.470, -768.027, 110.916},
        {"Малхолланд", 768.694, -954.662, -89.084, 952.604, -860.619, 110.916},
        {"Южное шоссе", 2377.390, 788.894, -89.084, 2537.390, 897.901, 110.916},
        {"Айдлвуд", 1812.620, -1852.870, -89.084, 1971.660, -1742.310, 110.916},
        {"Океанские доки", 2089.000, -2394.330, -89.084, 2201.820, -2235.840, 110.916},
        {"Коммерческий район", 1370.850, -1577.590, -89.084, 1463.900, -1384.950, 110.916},
        {"Северное шоссе", 2121.400, 2508.230, -89.084, 2237.400, 2663.170, 110.916},
        {"Темпл", 1096.470, -1026.330, -89.084, 1252.330, -910.170, 110.916},
        {"Глен Парк", 1812.620, -1449.670, -89.084, 1996.910, -1350.720, 110.916},
        {"Аэропорт Истер-Бэй", -1242.980, -50.096, 0.000, -1213.910, 578.396, 200.000},
        {"Мост Мартин", -222.179, 293.324, 0.000, -122.126, 476.465, 200.000},
        {"Стрип", 2106.700, 1863.230, -89.084, 2162.390, 2202.760, 110.916},
        {"Уиллоуфилд", 2541.700, -2059.230, -89.084, 2703.580, -1941.400, 110.916},
        {"Канал Марина", 807.922, -1577.590, -89.084, 926.922, -1416.250, 110.916},
        {"Аэропорт", 1457.370, 1143.210, -89.084, 1777.400, 1203.280, 110.916},
        {"Айдлвуд", 1812.620, -1742.310, -89.084, 1951.660, -1602.310, 110.916},
        {"Восточная Эспаланда", -1580.010, 1025.980, -6.1, -1499.890, 1274.260, 200.000},
        {"Деловой район", 1370.850, -1384.950, -89.084, 1463.900, -1170.870, 110.916},
        {"Мост Мако", 1664.620, 401.750, 0.000, 1785.140, 567.203, 200.000},
        {"Родео", 312.803, -1684.650, -89.084, 422.680, -1501.950, 110.916},
        {"Площадь Першинг", 1440.900, -1722.260, -89.084, 1583.500, -1577.590, 110.916},
        {"Малхолланд", 687.802, -860.619, -89.084, 911.802, -768.027, 110.916},
        {"Мост Гант", -2741.070, 1490.470, -6.1, -2616.400, 1659.680, 200.000},
        {"Лас-Колинас", 2185.330, -1154.590, -89.084, 2281.450, -934.489, 110.916},
        {"Малхолланд", 1169.130, -910.170, -89.084, 1318.130, -768.027, 110.916},
        {"Северное шоссе", 1938.800, 2508.230, -89.084, 2121.400, 2624.230, 110.916},
        {"Коммерческий район", 1667.960, -1577.590, -89.084, 1812.620, -1430.870, 110.916},
        {"Родео", 72.648, -1544.170, -89.084, 225.165, -1404.970, 110.916},
        {"Рока-Эскаланте", 2536.430, 2202.760, -89.084, 2625.160, 2442.550, 110.916},
        {"Родео", 72.648, -1684.650, -89.084, 225.165, -1544.170, 110.916},
        {"Центральный Рынок", 952.663, -1310.210, -89.084, 1072.660, -1130.850, 110.916},
        {"Лас-Колинас", 2632.740, -1135.040, -89.084, 2747.740, -945.035, 110.916},
        {"Малхолланд", 861.085, -674.885, -89.084, 1156.550, -600.896, 110.916},
        {"Кингс", -2253.540, 373.539, -9.1, -1993.280, 458.411, 200.000},
        {"Восточный Рэдсэндс", 1848.400, 2342.830, -89.084, 2011.940, 2478.490, 110.916},
        {"Деловой район", -1580.010, 744.267, -6.1, -1499.890, 1025.980, 200.000},
        {"Конференц Центр", 1046.150, -1804.210, -89.084, 1323.900, -1722.260, 110.916},
        {"Ричман", 647.557, -1118.280, -89.084, 787.461, -954.662, 110.916},
        {"Оушен-Флэтс", -2994.490, 277.411, -9.1, -2867.850, 458.411, 200.000},
        {"Колледж Грингласс", 964.391, 930.890, -89.084, 1166.530, 1044.690, 110.916},
        {"Глен Парк", 1812.620, -1100.820, -89.084, 1994.330, -973.380, 110.916},
        {"Грузовое депо", 1375.600, 919.447, -89.084, 1457.370, 1203.280, 110.916},
        {"Регьюлар-Том", -405.770, 1712.860, -3.0, -276.719, 1892.750, 200.000},
        {"Пляж Верона", 1161.520, -1722.260, -89.084, 1323.900, -1577.590, 110.916},
        {"Восточный ЛС", 2281.450, -1372.040, -89.084, 2381.680, -1135.040, 110.916},
        {"Дворец Калигулы", 2137.400, 1703.230, -89.084, 2437.390, 1783.230, 110.916},
        {"Айдлвуд", 1951.660, -1742.310, -89.084, 2124.660, -1602.310, 110.916},
        {"Пилигрим", 2624.400, 1383.230, -89.084, 2685.160, 1783.230, 110.916},
        {"Айдлвуд", 2124.660, -1742.310, -89.084, 2222.560, -1494.030, 110.916},
        {"Квинс", -2533.040, 458.411, 0.000, -2329.310, 578.396, 200.000},
        {"Деловой район", -1871.720, 1176.420, -4.5, -1620.300, 1274.260, 200.000},
        {"Коммерческий район", 1583.500, -1722.260, -89.084, 1758.900, -1577.590, 110.916},
        {"Восточный ЛС", 2381.680, -1454.350, -89.084, 2462.130, -1135.040, 110.916},
        {"Канал Марина", 647.712, -1577.590, -89.084, 807.922, -1416.250, 110.916},
        {"Ричман", 72.648, -1404.970, -89.084, 225.165, -1235.070, 110.916},
        {"Вайнвуд", 647.712, -1416.250, -89.084, 787.461, -1227.280, 110.916},
        {"Восточный ЛС", 2222.560, -1628.530, -89.084, 2421.030, -1494.030, 110.916},
        {"Родео", 558.099, -1684.650, -89.084, 647.522, -1384.930, 110.916},
        {"Истерский Тоннель", -1709.710, -833.034, -1.5, -1446.010, -730.118, 200.000},
        {"Родео", 466.223, -1385.070, -89.084, 647.522, -1235.070, 110.916},
        {"Восточный Рэдсэндс", 1817.390, 2202.760, -89.084, 2011.940, 2342.830, 110.916},
        {"Казино", 2162.390, 1783.230, -89.084, 2437.390, 1883.230, 110.916},
        {"Айдлвуд", 1971.660, -1852.870, -89.084, 2222.560, -1742.310, 110.916},
        {"Пересечение Монтгомери", 1546.650, 208.164, 0.000, 1745.830, 347.457, 200.000},
        {"Уиллоуфилд", 2089.000, -2235.840, -89.084, 2201.820, -1989.900, 110.916},
        {"Темпл", 952.663, -1130.840, -89.084, 1096.470, -937.184, 110.916},
        {"Прикл-Пайн", 1848.400, 2553.490, -89.084, 1938.800, 2863.230, 110.916},
        {"Аэропорт", 1400.970, -2669.260, -39.084, 2189.820, -2597.260, 60.916},
        {"Мост Гарвер", -1213.910, 950.022, -89.084, -1087.930, 1178.930, 110.916},
        {"Мост Гарвер", -1339.890, 828.129, -89.084, -1213.910, 1057.040, 110.916},
        {"Мост Кинкейд", -1339.890, 599.218, -89.084, -1213.910, 828.129, 110.916},
        {"Мост Кинкейд", -1213.910, 721.111, -89.084, -1087.930, 950.022, 110.916},
        {"Пляж Верона", 930.221, -2006.780, -89.084, 1073.220, -1804.210, 110.916},
        {"Обсерватория", 1073.220, -2006.780, -89.084, 1249.620, -1842.270, 110.916},
        {"Гора Вайнвуд", 787.461, -1130.840, -89.084, 952.604, -954.662, 110.916},
        {"Гора Вайнвуд", 787.461, -1310.210, -89.084, 952.663, -1130.840, 110.916},
        {"Коммерческий район", 1463.900, -1577.590, -89.084, 1667.960, -1430.870, 110.916},
        {"Центральный Рынок", 787.461, -1416.250, -89.084, 1072.660, -1310.210, 110.916},
        {"Западный Рокшор", 2377.390, 596.349, -89.084, 2537.390, 788.894, 110.916},
        {"Северное шоссе", 2237.400, 2542.550, -89.084, 2498.210, 2663.170, 110.916},
        {"Восточный пляж", 2632.830, -1668.130, -89.084, 2747.740, -1393.420, 110.916},
        {"Мост Фаллоу", 434.341, 366.572, 0.000, 603.035, 555.680, 200.000},
        {"Уиллоуфилд", 2089.000, -1989.900, -89.084, 2324.000, -1852.870, 110.916},
        {"Чайнатаун", -2274.170, 578.396, -7.6, -2078.670, 744.170, 200.000},
        {"Скалистый массив", -208.570, 2337.180, 0.000, 8.430, 2487.180, 200.000},
        {"Океанские доки", 2324.000, -2145.100, -89.084, 2703.580, -2059.230, 110.916},
        {"Химзавод Истер-Бэй", -1132.820, -768.027, 0.000, -956.476, -578.118, 200.000},
        {"Казино Визаж", 1817.390, 1703.230, -89.084, 2027.400, 1863.230, 110.916},
        {"Оушен-Флэтс", -2994.490, -430.276, -1.2, -2831.890, -222.589, 200.000},
        {"Ричман", 321.356, -860.619, -89.084, 687.802, -768.027, 110.916},
        {"Нефтяной комплекс", 176.581, 1305.450, -3.0, 338.658, 1520.720, 200.000},
        {"Ричман", 321.356, -768.027, -89.084, 700.794, -674.885, 110.916},
        {"Казино", 2162.390, 1883.230, -89.084, 2437.390, 2012.180, 110.916},
        {"Восточный пляж", 2747.740, -1668.130, -89.084, 2959.350, -1498.620, 110.916},
        {"Джефферсон", 2056.860, -1372.040, -89.084, 2281.450, -1210.740, 110.916},
        {"Деловой район", 1463.900, -1290.870, -89.084, 1724.760, -1150.870, 110.916},
        {"Деловой район", 1463.900, -1430.870, -89.084, 1724.760, -1290.870, 110.916},
        {"Мост Гарвер", -1499.890, 696.442, -179.615, -1339.890, 925.353, 20.385},
        {"Южное шоссе", 1457.390, 823.228, -89.084, 2377.390, 863.229, 110.916},
        {"Восточный ЛС", 2421.030, -1628.530, -89.084, 2632.830, -1454.350, 110.916},
        {"Колледж Грингласс", 964.391, 1044.690, -89.084, 1197.390, 1203.220, 110.916},
        {"Лас-Колинас", 2747.740, -1120.040, -89.084, 2959.350, -945.035, 110.916},
        {"Малхолланд", 737.573, -768.027, -89.084, 1142.290, -674.885, 110.916},
        {"Океанские доки", 2201.820, -2730.880, -89.084, 2324.000, -2418.330, 110.916},
        {"Восточный ЛС", 2462.130, -1454.350, -89.084, 2581.730, -1135.040, 110.916},
        {"Гантон", 2222.560, -1722.330, -89.084, 2632.830, -1628.530, 110.916},
        {"Клуб Ависпа", -2831.890, -430.276, -6.1, -2646.400, -222.589, 200.000},
        {"Уиллоуфилд", 1970.620, -2179.250, -89.084, 2089.000, -1852.870, 110.916},
        {"Северная Эспланада", -1982.320, 1274.260, -4.5, -1524.240, 1358.900, 200.000},
        {"Казино Хай-Роллер", 1817.390, 1283.230, -89.084, 2027.390, 1469.230, 110.916},
        {"Океанские доки", 2201.820, -2418.330, -89.084, 2324.000, -2095.000, 110.916},
        {"Мотель", 1823.080, 596.349, -89.084, 1997.220, 823.228, 110.916},
        {"Бэйсайнд-Марина", -2353.170, 2275.790, 0.000, -2153.170, 2475.790, 200.000},
        {"Кингс", -2329.310, 458.411, -7.6, -1993.280, 578.396, 200.000},
        {"Эль-Корона", 1692.620, -2179.250, -89.084, 1812.620, -1842.270, 110.916},
        {"Часовня Блэкфилд", 1375.600, 596.349, -89.084, 1558.090, 823.228, 110.916},
        {"Розовый лебедь", 1817.390, 1083.230, -89.084, 2027.390, 1283.230, 110.916},
        {"Западное шоссе", 1197.390, 1163.390, -89.084, 1236.630, 2243.230, 110.916},
        {"Лос-Флорес", 2581.730, -1393.420, -89.084, 2747.740, -1135.040, 110.916},
        {"Казино Визаж", 1817.390, 1863.230, -89.084, 2106.700, 2011.830, 110.916},
        {"Прикл-Пайн", 1938.800, 2624.230, -89.084, 2121.400, 2861.550, 110.916},
        {"Пляж Верона", 851.449, -1804.210, -89.084, 1046.150, -1577.590, 110.916},
        {"Пересечение Робада", -1119.010, 1178.930, -89.084, -862.025, 1351.450, 110.916},
        {"Линден-Сайд", 2749.900, 943.235, -89.084, 2923.390, 1198.990, 110.916},
        {"Океанские доки", 2703.580, -2302.330, -89.084, 2959.350, -2126.900, 110.916},
        {"Уиллоуфилд", 2324.000, -2059.230, -89.084, 2541.700, -1852.870, 110.916},
        {"Кингс", -2411.220, 265.243, -9.1, -1993.280, 373.539, 200.000},
        {"Коммерческий район", 1323.900, -1842.270, -89.084, 1701.900, -1722.260, 110.916},
        {"Малхолланд", 1269.130, -768.027, -89.084, 1414.070, -452.425, 110.916},
        {"Канал Марина", 647.712, -1804.210, -89.084, 851.449, -1577.590, 110.916},
        {"Бэттери-Пойнт", -2741.070, 1268.410, -4.5, -2533.040, 1490.470, 200.000},
        {"Казино 4 Дракона", 1817.390, 863.232, -89.084, 2027.390, 1083.230, 110.916},
        {"Блэкфилд", 964.391, 1203.220, -89.084, 1197.390, 1403.220, 110.916},
        {"Северное шоссе", 1534.560, 2433.230, -89.084, 1848.400, 2583.230, 110.916},
        {"Поле для гольфа", 1117.400, 2723.230, -89.084, 1457.460, 2863.230, 110.916},
        {"Айдлвуд", 1812.620, -1602.310, -89.084, 2124.660, -1449.670, 110.916},
        {"Западный Рэдсэндс", 1297.470, 2142.860, -89.084, 1777.390, 2243.230, 110.916},
        {"Доэрти", -2270.040, -324.114, -1.2, -1794.920, -222.589, 200.000},
        {"Ферма Хиллтоп", 967.383, -450.390, -3.0, 1176.780, -217.900, 200.000},
        {"Лас-Барранкас", -926.130, 1398.730, -3.0, -719.234, 1634.690, 200.000},
        {"Казино Пираты", 1817.390, 1469.230, -89.084, 2027.400, 1703.230, 110.916},
        {"Сити Холл", -2867.850, 277.411, -9.1, -2593.440, 458.411, 200.000},
        {"Клуб Ависпа", -2646.400, -355.493, 0.000, -2270.040, -222.589, 200.000},
        {"Стрип", 2027.400, 863.229, -89.084, 2087.390, 1703.230, 110.916},
        {"Хашбери", -2593.440, -222.589, -1.0, -2411.220, 54.722, 200.000},
        {"Аэропорт", 1852.000, -2394.330, -89.084, 2089.000, -2179.250, 110.916},
        {"Уайтвуд-Истейтс", 1098.310, 1726.220, -89.084, 1197.390, 2243.230, 110.916},
        {"Водохранилище", -789.737, 1659.680, -89.084, -599.505, 1929.410, 110.916},
        {"Эль-Корона", 1812.620, -2179.250, -89.084, 1970.620, -1852.870, 110.916},
        {"Деловой район", -1700.010, 744.267, -6.1, -1580.010, 1176.520, 200.000},
        {"Долина Фостер", -2178.690, -1250.970, 0.000, -1794.920, -1115.580, 200.000},
        {"Лас-Паясадас", -354.332, 2580.360, 2.0, -133.625, 2816.820, 200.000},
        {"Долина Окультадо", -936.668, 2611.440, 2.0, -715.961, 2847.900, 200.000},
        {"Пересечение Блэкфилд", 1166.530, 795.010, -89.084, 1375.600, 1044.690, 110.916},
        {"Гантон", 2222.560, -1852.870, -89.084, 2632.830, -1722.330, 110.916},
        {"Аэропорт Истер-Бэй", -1213.910, -730.118, 0.000, -1132.820, -50.096, 200.000},
        {"Восточный Рэдсэндс", 1817.390, 2011.830, -89.084, 2106.700, 2202.760, 110.916},
        {"Восточная Эспаланда", -1499.890, 578.396, -79.615, -1339.890, 1274.260, 20.385},
        {"Дворец Калигулы", 2087.390, 1543.230, -89.084, 2437.390, 1703.230, 110.916},
        {"Казино Рояль", 2087.390, 1383.230, -89.084, 2437.390, 1543.230, 110.916},
        {"Ричман", 72.648, -1235.070, -89.084, 321.356, -1008.150, 110.916},
        {"Казино", 2437.390, 1783.230, -89.084, 2685.160, 2012.180, 110.916},
        {"Малхолланд", 1281.130, -452.425, -89.084, 1641.130, -290.913, 110.916},
        {"Деловой район", -1982.320, 744.170, -6.1, -1871.720, 1274.260, 200.000},
        {"Ханки-Панки-Пойнт", 2576.920, 62.158, 0.000, 2759.250, 385.503, 200.000},
        {"Военный склад топлива", 2498.210, 2626.550, -89.084, 2749.900, 2861.550, 110.916},
        {"Шоссе Гарри-Голд", 1777.390, 863.232, -89.084, 1817.390, 2342.830, 110.916},
        {"Тоннель Бэйсайд", -2290.190, 2548.290, -89.084, -1950.190, 2723.290, 110.916},
        {"Океанские доки", 2324.000, -2302.330, -89.084, 2703.580, -2145.100, 110.916},
        {"Ричман", 321.356, -1044.070, -89.084, 647.557, -860.619, 110.916},
        {"Промсклад Рэндольфа", 1558.090, 596.349, -89.084, 1823.080, 823.235, 110.916},
        {"Восточный пляж", 2632.830, -1852.870, -89.084, 2959.350, -1668.130, 110.916},
        {"Флинт-Уотер", -314.426, -753.874, -89.084, -106.339, -463.073, 110.916},
        {"Блуберри", 19.607, -404.136, 3.8, 349.607, -220.137, 200.000},
        {"Станция Линден", 2749.900, 1198.990, -89.084, 2923.390, 1548.990, 110.916},
        {"Глен Парк", 1812.620, -1350.720, -89.084, 2056.860, -1100.820, 110.916},
        {"Деловой район", -1993.280, 265.243, -9.1, -1794.920, 578.396, 200.000},
        {"Западный Рэдсэндс", 1377.390, 2243.230, -89.084, 1704.590, 2433.230, 110.916},
        {"Ричман", 321.356, -1235.070, -89.084, 647.522, -1044.070, 110.916},
        {"Мост Гант", -2741.450, 1659.680, -6.1, -2616.400, 2175.150, 200.000},
        {"Бар Probe Inn", -90.218, 1286.850, -3.0, 153.859, 1554.120, 200.000},
        {"Пересечение Флинт", -187.700, -1596.760, -89.084, 17.063, -1276.600, 110.916},
        {"Лас-Колинас", 2281.450, -1135.040, -89.084, 2632.740, -945.035, 110.916},
        {"Собелл-Рейл-Ярдс", 2749.900, 1548.990, -89.084, 2923.390, 1937.250, 110.916},
        {"Изумрудный остров", 2011.940, 2202.760, -89.084, 2237.400, 2508.230, 110.916},
        {"Скалистый массив", -208.570, 2123.010, -7.6, 114.033, 2337.180, 200.000},
        {"Санта-Флора", -2741.070, 458.411, -7.6, -2533.040, 793.411, 200.000},
        {"Плайя-дель-Севиль", 2703.580, -2126.900, -89.084, 2959.350, -1852.870, 110.916},
        {"Центральный Рынок", 926.922, -1577.590, -89.084, 1370.850, -1416.250, 110.916},
        {"Квинс", -2593.440, 54.722, 0.000, -2411.220, 458.411, 200.000},
        {"Пересечение Пилсон", 1098.390, 2243.230, -89.084, 1377.390, 2507.230, 110.916},
        {"Спинибед", 2121.400, 2663.170, -89.084, 2498.210, 2861.550, 110.916},
        {"Пилигрим", 2437.390, 1383.230, -89.084, 2624.400, 1783.230, 110.916},
        {"Блэкфилд", 964.391, 1403.220, -89.084, 1197.390, 1726.220, 110.916},
        {"Большое ухо", -410.020, 1403.340, -3.0, -137.969, 1681.230, 200.000},
        {"Диллимор", 580.794, -674.885, -9.5, 861.085, -404.790, 200.000},
        {"Эль-Кебрадос", -1645.230, 2498.520, 0.000, -1372.140, 2777.850, 200.000},
        {"Северная Эспланада", -2533.040, 1358.900, -4.5, -1996.660, 1501.210, 200.000},
        {"Аэропорт Истер-Бэй", -1499.890, -50.096, -1.0, -1242.980, 249.904, 200.000},
        {"Рыбацкая лагуна", 1916.990, -233.323, -100.000, 2131.720, 13.800, 200.000},
        {"Малхолланд", 1414.070, -768.027, -89.084, 1667.610, -452.425, 110.916},
        {"Восточный пляж", 2747.740, -1498.620, -89.084, 2959.350, -1120.040, 110.916},
        {"Сан-Андреас Саунд", 2450.390, 385.503, -100.000, 2759.250, 562.349, 200.000},
        {"Тенистые ручьи", -2030.120, -2174.890, -6.1, -1820.640, -1771.660, 200.000},
        {"Центральный Рынок", 1072.660, -1416.250, -89.084, 1370.850, -1130.850, 110.916},
        {"Западный Рокшор", 1997.220, 596.349, -89.084, 2377.390, 823.228, 110.916},
        {"Прикл-Пайн", 1534.560, 2583.230, -89.084, 1848.400, 2863.230, 110.916},
        {"Бухта Пасхи", -1794.920, -50.096, -1.04, -1499.890, 249.904, 200.000},
        {"Лифи-Холлоу", -1166.970, -1856.030, 0.000, -815.624, -1602.070, 200.000},
        {"Грузовое депо", 1457.390, 863.229, -89.084, 1777.400, 1143.210, 110.916},
        {"Прикл-Пайн", 1117.400, 2507.230, -89.084, 1534.560, 2723.230, 110.916},
        {"Блуберри", 104.534, -220.137, 2.3, 349.607, 152.236, 200.000},
        {"Скалистый массив", -464.515, 2217.680, 0.000, -208.570, 2580.360, 200.000},
        {"Деловой район", -2078.670, 578.396, -7.6, -1499.890, 744.267, 200.000},
        {"Восточный Рокшор", 2537.390, 676.549, -89.084, 2902.350, 943.235, 110.916},
        {"Залив Сан-Фиерро", -2616.400, 1501.210, -3.0, -1996.660, 1659.680, 200.000},
        {"Парадизо", -2741.070, 793.411, -6.1, -2533.040, 1268.410, 200.000},
        {"Казино", 2087.390, 1203.230, -89.084, 2640.400, 1383.230, 110.916},
        {"Олд-Вентурас-Стрип", 2162.390, 2012.180, -89.084, 2685.160, 2202.760, 110.916},
        {"Джанипер-Хилл", -2533.040, 578.396, -7.6, -2274.170, 968.369, 200.000},
        {"Джанипер-Холлоу", -2533.040, 968.369, -6.1, -2274.170, 1358.900, 200.000},
        {"Рока-Эскаланте", 2237.400, 2202.760, -89.084, 2536.430, 2542.550, 110.916},
        {"Воссточное шоссе", 2685.160, 1055.960, -89.084, 2749.900, 2626.550, 110.916},
        {"Пляж Верона", 647.712, -2173.290, -89.084, 930.221, -1804.210, 110.916},
        {"Долина Фостер", -2178.690, -599.884, -1.2, -1794.920, -324.114, 200.000},
        {"Арко-дель-Оэсте", -901.129, 2221.860, 0.000, -592.090, 2571.970, 200.000},
        {"Упавшее дерево", -792.254, -698.555, -5.3, -452.404, -380.043, 200.000},
        {"Ферма", -1209.670, -1317.100, 114.981, -908.161, -787.391, 251.981},
        {"Дамба Шермана", -968.772, 1929.410, -3.0, -481.126, 2155.260, 200.000},
        {"Северная Эспланада", -1996.660, 1358.900, -4.5, -1524.240, 1592.510, 200.000},
        {"Финансовый район", -1871.720, 744.170, -6.1, -1701.300, 1176.420, 300.000},
        {"Гарсия", -2411.220, -222.589, -1.14, -2173.040, 265.243, 200.000},
        {"Монтгомери", 1119.510, 119.526, -3.0, 1451.400, 493.323, 200.000},
        {"Крик", 2749.900, 1937.250, -89.084, 2921.620, 2669.790, 110.916},
        {"Аэропорт", 1249.620, -2394.330, -89.084, 1852.000, -2179.250, 110.916},
        {"Пляж Санта-Мария", 72.648, -2173.290, -89.084, 342.648, -1684.650, 110.916},
        {"Пересечение Малхолланд", 1463.900, -1150.870, -89.084, 1812.620, -768.027, 110.916},
        {"Эйнджел-Пайн", -2324.940, -2584.290, -6.1, -1964.220, -2212.110, 200.000},
        {"Вёрдант-Медоус", 37.032, 2337.180, -3.0, 435.988, 2677.900, 200.000},
        {"Октан-Спрингс", 338.658, 1228.510, 0.000, 664.308, 1655.050, 200.000},
        {"Казино Кам-э-Лот", 2087.390, 943.235, -89.084, 2623.180, 1203.230, 110.916},
        {"Западный Рэдсэндс", 1236.630, 1883.110, -89.084, 1777.390, 2142.860, 110.916},
        {"Пляж Санта-Мария", 342.648, -2173.290, -89.084, 647.712, -1684.650, 110.916},
        {"Обсерватория", 1249.620, -2179.250, -89.084, 1692.620, -1842.270, 110.916},
        {"Аэропорт", 1236.630, 1203.280, -89.084, 1457.370, 1883.110, 110.916},
        {"Округ Флинт", -594.191, -1648.550, 0.000, -187.700, -1276.600, 200.000},
        {"Обсерватория", 930.221, -2488.420, -89.084, 1249.620, -2006.780, 110.916},
        {"Паломино Крик", 2160.220, -149.004, 0.000, 2576.920, 228.322, 200.000},
        {"Океанские доки", 2373.770, -2697.090, -89.084, 2809.220, -2330.460, 110.916},
        {"Аэропорт Истер-Бэй", -1213.910, -50.096, -4.5, -947.980, 578.396, 200.000},
        {"Уайтвуд-Истейтс", 883.308, 1726.220, -89.084, 1098.310, 2507.230, 110.916},
        {"Калтон-Хайтс", -2274.170, 744.170, -6.1, -1982.320, 1358.900, 200.000},
        {"Бухта Пасхи", -1794.920, 249.904, -9.1, -1242.980, 578.396, 200.000},
        {"Залив ЛС", -321.744, -2224.430, -89.084, 44.615, -1724.430, 110.916},
        {"Доэрти", -2173.040, -222.589, -1.0, -1794.920, 265.243, 200.000},
        {"Гора Чилиад", -2178.690, -2189.910, -47.917, -2030.120, -1771.660, 576.083},
        {"Форт-Карсон", -376.233, 826.326, -3.0, 123.717, 1220.440, 200.000},
        {"Долина Фостер", -2178.690, -1115.580, 0.000, -1794.920, -599.884, 200.000},
        {"Оушен-Флэтс", -2994.490, -222.589, -1.0, -2593.440, 277.411, 200.000},
        {"Ферн-Ридж", 508.189, -139.259, 0.000, 1306.660, 119.526, 200.000},
        {"Бэйсайд", -2741.070, 2175.150, 0.000, -2353.170, 2722.790, 200.000},
        {"Аэропорт", 1457.370, 1203.280, -89.084, 1777.390, 1883.110, 110.916},
        {"Поместье Блуберри", -319.676, -220.137, 0.000, 104.534, 293.324, 200.000},
        {"Пэлисейдс", -2994.490, 458.411, -6.1, -2741.070, 1339.610, 200.000},
        {"Норт-Рок", 2285.370, -768.027, 0.000, 2770.590, -269.740, 200.000},
        {"Карьер Хантер", 337.244, 710.840, -115.239, 860.554, 1031.710, 203.761},
        {"Аэропорт", 1382.730, -2730.880, -89.084, 2201.820, -2394.330, 110.916},
        {"Миссионер-Хилл", -2994.490, -811.276, 0.000, -2178.690, -430.276, 200.000},
        {"Залив СФ", -2616.400, 1659.680, -3.0, -1996.660, 2175.150, 200.000},
        {"Тюрьма ЛВ", -91.586, 1655.050, -50.000, 421.234, 2123.010, 250.000},
        {"Гора Чилиад", -2997.470, -1115.580, -47.917, -2178.690, -971.913, 576.083},
        {"Гора Чилиад", -2178.690, -1771.660, -47.917, -1936.120, -1250.970, 576.083},
        {"Аэропорт Истер-Бэй", -1794.920, -730.118, -3.0, -1213.910, -50.096, 200.000},
        {"Паноптикум", -947.980, -304.320, -1.1, -319.676, 327.071, 200.000},
        {"Тенистые ручьи", -1820.640, -2643.680, -8.0, -1226.780, -1771.660, 200.000},
        {"Бэк-о-Бейонд", -1166.970, -2641.190, 0.000, -321.744, -1856.030, 200.000},
        {"Гора Чилиад", -2994.490, -2189.910, -47.917, -2178.690, -1115.580, 576.083},
        {"Тьерра Робада", -1213.910, 596.349, -242.990, -480.539, 1659.680, 900.000},
        {"Округ Флинт", -1213.910, -2892.970, -242.990, 44.615, -768.027, 900.000},
        {"Уэтстоун", -2997.470, -2892.970, -242.990, -1213.910, -1115.580, 900.000},
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
function info_stop_command()
	if isMonetLoader() and settings.general.mobile_stop_button then
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
		CommandStopWindow[0] = true
	elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop then
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
	else
		sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
	end
end
local servers = {
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
	{name = 'Mobile III', number = '103'},
	{name = 'Mobile II', number = '102'},
	{name = 'Mobile I', number = '101'},
	{name = 'Vice City', number = '200'},
}
function getARZServerNumber()
	local server = 0
	for _, s in ipairs(servers) do
		if sampGetCurrentServerName():gsub('%-', ' '):find(s.name) then
			server = s.number
			break
		end
	end
	return server
end
function getARZServerName(number)
	local server = ''
	for _, s in ipairs(servers) do
		if tostring(number) == tostring(s.number) then
			server = s.name
			break
		end
	end
	return server
end

if isMonetLoader() then
	function asyncHttpRequest(method, url, args, resolve, reject)
        local request_thread = effil.thread(function (method, url, args)
           	local requests = require 'requests'
			local result, response = pcall(requests.request, method, url, effil.dump(args))
			if result then
				response.json, response.xml = nil, nil
				return true, response
			else
				return false, response
			end
        end)(method, url, args)
        if not resolve then resolve = function() end end
        if not reject then reject = function() end end
        lua_thread.create(function()
            local runner = request_thread
            while true do
                local status, err = runner:status()
                if not err then
                    if status == 'completed' then
                        local result, response = runner:get()
                        if result then
                           resolve(response)
                        else
                           reject(response)
                        end
                        return
                    elseif status == 'canceled' then
                        return reject(status)
                    end
                else
                    return reject(err)
                end
                wait(0)
            end
        end)
    end
else
	function asyncHttpRequest(method, url, args, resolve, reject)
        local request_thread = effil.thread(function (method, url, args)
           	local requests = require 'requests'
			local result, response = pcall(requests.request, method, url, args)
			if result then
				response.json, response.xml = nil, nil
				return true, response
			else
				return false, response
			end
        end)(method, url, args)
        if not resolve then resolve = function() end end
        if not reject then reject = function() end end
        lua_thread.create(function()
            local runner = request_thread
            while true do
                local status, err = runner:status()
                if not err then
                    if status == 'completed' then
                        local result, response = runner:get()
                        if result then
                           resolve(response)
                        else
                           reject(response)
                        end
                        return
                    elseif status == 'canceled' then
                        return reject(status)
                    end
                else
                    return reject(err)
                end
                wait(0)
            end
        end)
    end
end
function downloadFileFromUrlToPath(url, path)
	print('[Arizona Helper] Начинаю скачивание файла в ' .. path)
	local function on_finish_download()
		if download_file == 'update' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Информация про наличие обновлений получена, проверка..',  message_color)
			local function check_need_update(updateInfo)
				local isVip = thisScript().version:find('VIP')
				local uVer = isVip and updateInfo.vip_current_version or updateInfo.current_version
				local uText = isVip and updateInfo.vip_update_info or updateInfo.update_info
				local uUrl = isVip and '' or updateInfo.update_url
				print("[Arizona Helper] Текущая установленная версия:", thisScript().version)
				print("[Arizona Helper] Текущая версия в облаке:", uVer)
				if thisScript().version ~= uVer then
					print('[Arizona Helper] Доступно обновление!')
					sampAddChatMessage('[Arizona Helper] {ffffff}Доступно обновление!', message_color)
					update.is_need_update = true
					update.url = uUrl
					update.version = uVer
					update.info = uText
					UpdateWindow[0] = true
				else
					print('[Arizona Helper] Обновление не нужно!')
					sampAddChatMessage('[Arizona Helper] {ffffff}Обновление не нужно, у вас актуальная версия!', message_color)
				end
			end
			local function readJsonFile(filePath)
				if not doesFileExist(filePath) then
					print("[Arizona Helper] Ошибка: Файл " .. filePath .. " не существует")
					return nil
				end
				local file = io.open(filePath, "r")
				local content = file:read("*a")
				file:close()
				local jsonData = decodeJson(content)
				if not jsonData then
					print("[Arizona Helper] Ошибка: Неверный формат JSON в файле " .. filePath)
					return nil
				end
				return jsonData
			end
			local ok, updateInfo = pcall(readJsonFile, path)
			if updateInfo then
				check_need_update(updateInfo)
			end
		elseif download_file == 'helper' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка новой версии хелпера успешно завершена! Перезагрузка..',  message_color)
			reload_script = true
			thisScript():unload()
		elseif download_file == 'smart_uk' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка системы умной выдачи розыска для сервера ' .. message_color_hex .. getARZServerName(getARZServerNumber()) .. ' [' .. getARZServerNumber() ..  '] {ffffff}завершена успешно!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Теперь вы можете использовать команду ' .. message_color_hex .. '/sum [ID игрока]', message_color)
			MainWindow[0] = false
			load_module('smart_uk')
		elseif download_file == 'smart_pdd' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка системы умной выдачи штрафов для сервера ' .. message_color_hex .. getARZServerName(getARZServerNumber()) .. ' [' .. getARZServerNumber() ..  '] {ffffff}завершена успешно!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Теперь вы можете использовать команду ' .. message_color_hex .. '/tsm [ID игрока]', message_color)
			MainWindow[0] = false
			load_module('smart_pdd')
		elseif download_file == 'smart_rptp' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка системы умного срока для сервера ' .. message_color_hex .. getARZServerName(getARZServerNumber()) .. ' [' .. getARZServerNumber() ..  '] {ffffff}завершена успешно!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Теперь вы можете использовать команду ' .. message_color_hex .. '/pum [ID игрока]', message_color)
			MainWindow[0] = false
			load_module('smart_rptp')
		elseif ddownload_file == 'arz_veh' then
			sampAddChatMessage('[Arizona Helper] {ffffff}Загрузка всех кастомных т/с аризоны успешно заверешена!',  message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Повторно используйте команду для определения модели т/c.',  message_color)
			load_module('arz_veh')
		elseif download_file == 'notify' then
			if doesFileExist(configDirectory .. "/Resourse_notify.mp3") then
				print('[Arizona Helper] Звук оповещений успешно загружен!')
				os.rename(configDirectory .. "/Resourse_notify.mp3", configDirectory .. "/Resourse/notify.mp3")
			end
		end
		download_file = ''
	end
	if isMonetLoader() then
		local function downloadToFile(url, path, callback, progressInterval)
			callback = callback or function() end
			progressInterval = progressInterval or 0.1
			local effil = require("effil")
			local progressChannel = effil.channel(0)
			local runner = effil.thread(function(url, path)
			local http = require("socket.http")
			local ltn = require("ltn12")
			local r, c, h = http.request({
				method = "HEAD",
				url = url,
			})
			if c ~= 200 then
				return false, c
			end
			local total_size = h["content-length"]
			local f = io.open(path, "wb")
			if not f then
				return false, "failed to open file"
			end
			local success, res, status_code = pcall(http.request, {
				method = "GET",
				url = url,
				sink = function(chunk, err)
				local clock = os.clock()
				if chunk and not lastProgress or (clock - lastProgress) >= progressInterval then
					progressChannel:push("downloading", f:seek("end"), total_size)
					lastProgress = os.clock()
				elseif err then
					progressChannel:push("error", err)
				end

				return ltn.sink.file(f)(chunk, err)
				end,
			})
			if not success then
				return false, res
			end
			if not res then
				return false, status_code
			end
			return true, total_size
			end)
			local thread = runner(url, path)
			local function checkStatus()
			local tstatus = thread:status()
			if tstatus == "failed" or tstatus == "completed" then
				local result, value = thread:get()
				if result then
					callback("finished", value)
				else
					callback("error", value)
				end
				return true
			end
			end
			lua_thread.create(function()
			if checkStatus() then
				return
			end
			while thread:status() == "running" do
				if progressChannel:size() > 0 then
					local type, pos, total_size = progressChannel:pop()
					callback(type, pos, total_size)
				end
				wait(0)
			end
			checkStatus()
			end)
		end
		downloadToFile(url, path, function(type, pos, total_size)
			if type == "downloading" then
				--print(("Скачивание %d/%d"):format(pos, total_size))
			elseif type == "finished" then
				on_finish_download()
			elseif type == "error" then
				sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка загрузки: ' .. pos,  message_color)
			end
		end)
	else
		downloadUrlToFile(url, path, function(id, status)
			if status == 6 then
				on_finish_download()
			end
		end)
	end
end
function check_update()
	-- if string.rupper(settings.general.version):find('VIP') then
	-- 	sampAddChatMessage('[Arizona Helper] {ffffff}Проверка наличия обновлений недоступна в VIP версии!', message_color)
	-- else
		print('[Arizona Helper] Начинаю проверку на наличие обновлений...')
		sampAddChatMessage('[Arizona Helper] {ffffff}Начинаю проверку на наличие обновлений...', message_color)
		download_file = 'update'
		downloadFileFromUrlToPath('https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Update_Info.json', configDirectory .. "/Update_Info.json")
	-- end
end
function check_resourses()
	if not doesFileExist(configDirectory .. '/Resourse/logo1.png') or not doesFileExist(configDirectory .. '/Resourse/logo2.png') then
		if not doesDirectoryExist(configDirectory .. '/Resourse') then
			createDirectory(configDirectory .. '/Resourse')
		end
		print('[Arizona Helper] Загружаю логотип хелпера (файл .png)...')
		downloadFileFromUrlToPath('https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Resourse/logo1.png', configDirectory .. '/Resourse/logo1.png')
		downloadFileFromUrlToPath('https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Resourse/logo2.png', configDirectory .. '/Resourse/logo2.png')
	end
	if not doesFileExist(configDirectory .. "/Resourse/notify.mp3") then
		print('[Arizona Helper] Загружаю звук для оповещений хелпера (файл .mp3)...')
		download_file = 'notify'
		downloadFileFromUrlToPath('https://raw.githubusercontent.com/MTGMODS/arizona-helper/main/Resourse/notify.mp3', configDirectory .. "/Resourse_notify.mp3")
	end
end
check_resourses()

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
function change_dpi()
	if not isMonetLoader() then
		imgui.SetWindowFontScale(settings.general.custom_dpi)
	end
end
function deleteHelperData(checker)
	os.remove(configDirectory .. "/Settings.json")
	os.remove(configDirectory .. "/Commands.json")
	os.remove(configDirectory .. "/Notes.json")
	os.remove(configDirectory .. "/Vehicles.json")
	os.remove(configDirectory .. "/RP Guns.json")
	os.remove(configDirectory .. "/SmartRPTP.json")
	os.remove(configDirectory .. "/SmartUK.json")
	os.remove(configDirectory .. "/SmartPDD.json")
	if checker == 'full' then
		os.remove(getWorkingDirectory():gsub('\\','/') .. "/Arizona Helper.lua")
		os.remove(configDirectory .. "/Resourse/notify.mp3")
		os.remove(configDirectory .. "/logo.png")
	end
end

-- MJ


-- Probiv
function getPlayerInfo(nickname, serverId)
    local url = string.format("https://api.depscian.tech/v2/player/find?nickname=%s&serverId=%s", nickname, serverId)
    asyncHttpRequest(
        "GET",
        url,
        { headers = { ["X-API-Key"] = settings.general.probiv_api_key } },
        function(response)
            if response.status_code == 200 then
                local ok, result = pcall(decodeJson, u8:decode(response.text))
                if ok and result then
                    sampAddChatMessage('[Arizona Helper] {ffffff}Игрок найден: ' .. (result.nickname or 'N/A'), message_color)
					probiv = result
                else
                    sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка декодирования ответа.', message_color)
                end
            elseif response.status_code == 422 then
                sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка 422: Никнейм не найден или введен с ошибкой.', message_color)
            elseif response.status_code == 401 then
                sampAddChatMessage('[Arizona Helper] {ffffff}Неверный API ключ.', message_color)
            elseif response.status_code == 429 then
                sampAddChatMessage('[Arizona Helper] {ffffff}Превышен лимит запросов. Повторите чуть позже.', message_color)
            else
                sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка API: ' .. tostring(response.status_code), message_color)
            end
        end,
        function(err)
            sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка запроса: ' .. tostring(err), message_color)
        end
    )
end
function comma_value(n) -- MoneySeparator by Royan_Millans and YarikVL
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function sampev.onShowTextDraw(id, data)
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~r~Sport!') then
		sampAddChatMessage('[Arizona Helper] {ffffff}Активирован режим езды Sport!', message_color)
		return false
	end
	if data.text:find('~n~~n~~n~~n~~n~~n~~n~~n~~w~Style: ~g~Comfort!') then
		sampAddChatMessage('[Arizona Helper] {ffffff}Активирован режим езды Comfort!', message_color)
		return false
	end

	

end

function sampev.onDisplayGameText(style,time,text)
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
	if playerId ~= 65535 then
		playerId2 = playerId1
		playerId1 = playerId
		if isParamSampID(playerId) and playerId1 ~= playerId2 and tonumber(playerId) ~= 0 and weapon then
			local weapon_name = get_name_weapon(weapon)
			if weapon_name then
				sampAddChatMessage('[Arizona Helper] {ffffff}Игрок ' .. sampGetPlayerNickname(playerId) .. '[' .. playerId .. '] напал на вас используя ' .. weapon_name .. '['.. weapon .. ']!', message_color)
			end
		end
	end
end
function sampev.onSendGiveDamage(playerId, damage, weapon, bodypart)
	if playerId ~= 65535 then
		local nick = sampGetPlayerNickname(playerId)
		if (nick:find('Bogdan_Martelli') and getARZServerNumber():find('20')) or nick:find('%[20%]Bogdan_Martelli') then
			sampAddChatMessage('[Arizona Helper] {ffffff}Bogdan_Martelli - это разработчик Arizona Helper!', message_color)
			sampAddChatMessage('[Arizona Helper] {ffffff}Не нужно наносить урон разработчику хелпера, АСТАНАВИТЕСЬ :sob: :sob: :sob:', message_color)
			playNotifySound()
		end
	end
end
function sampev.onServerMessage(color,text)

	if text:find("1%.{6495ED} 111 %- {FFFFFF}Проверить баланс телефона") or
		text:find("2%.{6495ED} 060 %- {FFFFFF}Служба точного времени") or
		text:find("3%.{6495ED} 911 %- {FFFFFF}Полицейский участок") or
		text:find("4%.{6495ED} 912 %- {FFFFFF}Скорая помощь") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}Такси") or
		text:find("5%.{6495ED} 914 %- {FFFFFF}Механик") or
		text:find("6%.{6495ED} 8828 %- {FFFFFF}Справочная центрального банка") or
		text:find("7%.{6495ED} 997 %- {FFFFFF}Служба по вопросам жилой недвижимости %(узнать владельца дома%)") then
		return false
	end
	if text:find("Номера телефонов государственных служб:") then
		sampAddChatMessage('[Arizona Helper] {ffffff}Номера телефонов государственных служб:', message_color)
		sampAddChatMessage('[Arizona Helper] {ffffff}111 Баланс | 60 Время | 911 МЮ | 912 МЗ | 913 Такси | 914 Мехи | 8828 Банк | 997 Дома', message_color)
		return false
	end

	if (text:find('@' .. binderTags.my_id()) or text:find('@' .. binderTags.my_nick())) then
		sampAddChatMessage('[Arizona Helper] {ffffff}Кто-то упомянул вас в чате!', message_color)
		playNotifySound()
	end

	if (settings.general.auto_uval and settings.player_info.fraction_rank_number >= 9) then
		if text:find("%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb или /r /rb без тега 
			local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			if ((not message:find(" отправьте (.+) +++ чтобы уволится ПСЖ!") and not message:find("Сотрудник (.+) был уволен по причине(.+)")) and (message:rupper():find("ПСЖ") or message:rupper():find("ПСЖ.") or message:rupper():find("УВОЛЬТЕ") or message:find("УВОЛЬТЕ.") or message:rupper():find("УВАЛ") or message:rupper():find("УВАЛ."))) then
				message3 = message2
				message2 = message1
				message1 = text
				PlayerID = playerID
				if message3 == text then
					auto_uval_checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Ожидайте...')
				elseif tag == "R" then
					sampSendChat("/rb "..name.." отправьте /rb +++ чтобы уволится ПСЖ!")
				elseif tag == "F" then
					sampSendChat("/fb "..name.." отправьте /fb +++ чтобы уволится ПСЖ!")
				end
			elseif ((message == "(( +++ ))" or message == "(( +++. ))") and (PlayerID == playerID)) then
				auto_uval_checker = true
				sampSendChat('/fmute ' .. PlayerID .. ' 1 [AutoUval] Ожидайте...')
			end
		elseif text:find("%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r или /f с тегом
			local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
			if not message:find(" отправьте (.+) +++ чтобы уволится ПСЖ!") and not message:find("Сотрудник (.+) был уволен по причине(.+)") and message:rupper():find("ПСЖ") or message:rupper():find("УВОЛЬТЕ") or message:rupper():find("УВАЛ") then
				message3 = message2
				message2 = message1
				message1 = text
				PlayerID = playerID
				if message3 == text then
					auto_uval_checker = true
					sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Ожидайте...')
				elseif tag == "R" then
					sampSendChat("/rb "..name.."["..playerID.."], отправьте /rb +++ чтобы уволится ПСЖ!")
				elseif tag == "F" then
					sampSendChat("/fb "..name.."["..playerID.."], отправьте /fb +++ чтобы уволится ПСЖ!")
				end
			elseif ((message == "(( +++ ))" or  message == "(( +++. ))") and (PlayerID == playerID)) then
				auto_uval_checker = true
				sampSendChat('/fmute ' .. playerID .. ' 1 [AutoUval] Ожидайте...')
			end
		end
		if text:find("(.+) заглушил%(а%) игрока (.+) на 1 минут. Причина: %[AutoUval%] Ожидайте...") and auto_uval_checker then
			local Name, PlayerName, Time, Reason = text:match("(.+) заглушил%(а%) игрока (.+) на (%d+) минут. Причина: (.+)")
			local MyName = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
			if Name == MyName then
				sampAddChatMessage('[Arizona Helper] {ffffff}Увольняю игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
				auto_uval_checker = false
				temp = PlayerID .. ' ПСЖ'
				find_and_use_command("/uninvite {arg_id} {arg2}", temp)
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Другой заместитель/лидер уже увольняет игрока ' .. sampGetPlayerNickname(PlayerID) .. '!', message_color)
				auto_uval_checker = false
			end
		end
	end

	if isMode('police') or isMode('fbi') then
		if settings.player_info.fraction_rank_number >= (isMode('fbi') and 4 or 5) then
			if text:find("%[(.-)%] (.-) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /f /fb или /r /rb без тега 
				local tag, rank, name, playerID, message = string.match(text, "%[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
				if message:find('Прошу обьявить в розыск (%d) степени дело N(%d+)%. Причина%: (.+)') and playerID ~= binderTags.my_id() then
					local lvl, id, reason = message:match('Прошу обьявить в розыск (%d) степени дело N(%d+)%. Причина%: (.+)')
					form_su = id .. ' ' .. lvl .. ' ' .. reason
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте /givefsu ' .. playerID .. ' чтобы выдать розыск по запросу офицера ' .. name, message_color)
				end
			elseif text:find("%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)") and color == 766526463 then -- /r или /f с тегом
				local tag, tag2, rank, name, playerID, message = string.match(text, "%[(.-)%] %[(.-)%] (.+) (.-)%[(.-)%]: (.+)")
				if message:find('Прошу обьявить в розыск (%d) степени дело N(%d+)%. Причина%: (.+)') and playerID ~= binderTags.my_id() then
					local lvl, id, reason = message:match('Прошу обьявить в розыск (%d) степени дело N(%d+)%. Причина%: (.+)')
					form_su = id .. ' ' .. lvl .. ' ' .. reason
					sampAddChatMessage('[Arizona Helper] {ffffff}Используйте /givefsu ' .. playerID .. ' чтобы выдать розыск по запросу офицера ' .. name, message_color)
				end
			end
		end
		
		if text:find('Местоположение (.+) отмечено на карте красным маркером') and afind then
			printStringNow('FIND', 500)
			return false
		end
		if text:find("Вы успешно надели маску") then
			maska = true
			sampAddChatMessage('[Arizona Helper] {ffffff}Вы надели маску', message_color)
			return false
		end
		if text:find("Теперь вы в маске") then
			return false
		end
		if text:find("Вы успешно выкинули маску") or text:find("Вы сняли маску") then
			sampAddChatMessage('[Arizona Helper] {ffffff}Вы сняли маску!', message_color)
			return false
		end
		if text:find('%[Ошибка%] %{FFFFFF%}Используй: %/wanted %[уровень розыска 1%-6%]') and check_wanted then
			return false
		end
		if text:find('%[Ошибка%].+Игроков с таким уровнем розыска нету') and check_wanted then 
			return false 
		end

		if text:find('На этом автомобиле уже установлена маркировка.') and patrool.active then
			sampSendChat('/delvdesc')
			lua_thread.create(function ()
				wait(5000)
				sampSendChat('/vdesc ' .. binderTags.get_patrool_mark())
			end)		
		end
		if text:find('Вам поступило предложение от игрока (.+)%/offer') and settings.general.auto_accept_docs then
			sampSendChat('/offer')
		end
	
	end
 	
	if isMode('hospital') then
		if ((settings.mh.heal_in_chat or settings.mh.auto_heal) and not heal_in_chat.bool and not isActiveCommand) then	
			if (text:find('(.+)%[(%d+)%] говорит:{B7AFAF} (.+)')) then
				local nick, id, message = text:match('(.+)%[(%d+)%] говорит:{B7AFAF} (.+)')
				if (nick and id and message and tonumber(id) ~= select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
					for pon, keyword in ipairs(heal_in_chat.worlds) do
						if (message:rupper():find(keyword:rupper())) then
							if settings.mh.heal_in_chat then
								fast_heal_in_chat(id)
							end
							break
						end
					end
				end
			end
			if (text:find('(.+)%[(%d+)%] кричит: (.+)')) then
				local nick, id, message = text:match('(.+)%[(%d+)%] кричит: (.+)')
				if (nick and id and message and tonumber(id) ~= select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))) then
					for pon, keyword in ipairs(heal_in_chat.worlds) do
						if (message:rupper():find(keyword:rupper())) then
							if settings.mh.heal_in_chat then
								fast_heal_in_chat(id)
							
							end
							break
						end
					end
				end
			end
		end
		if text:find('Очевидец сообщает о пострадавшем человеке в районе (.+) %((.+)%).') then
			godeath_locate, godeath_city = text:match('Очевидец сообщает о пострадавшем человеке в районе (.+) %((.+)%).')
			return false
		end
		if text:find('%(%( Чтобы принять вызов, введите /godeath (%d+). Оплата за вызов (.+) %)%)') then
			godeath_player_id = text:match('%(%( Чтобы принять вызов, введите /godeath (%d+). Оплата за вызов (.+) %)%)')
			godeath_player_id = tonumber(godeath_player_id)
			local cmd = '/godeath'
			for _, command in ipairs(modules.commands.data.commands.my) do
				if command.enable and command.text:find('/godeath {arg_id}') then
					cmd =  '/' .. command.cmd
				end
			end
			if godeath_locate == 'неизвестном' then
				sampAddChatMessage('[Arizona Helper] {ffffff}Из города ' .. message_color_hex .. godeath_city .. ' {ffffff}поступил вызов о пострадавшем ' .. message_color_hex .. sampGetPlayerNickname(godeath_player_id), message_color)
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Из города ' .. message_color_hex .. godeath_city .. ' (' .. godeath_locate .. ') {ffffff}поступил вызов о пострадавшем ' .. message_color_hex .. sampGetPlayerNickname(godeath_player_id), message_color)
			end
			sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы принять вызов, используйте команду ' .. message_color_hex .. cmd .. ' '.. godeath_player_id, message_color)
			return false
		end
		if text:find('$hme') then
			find_and_use_command("/heal {my_id}", "")
			return false
		end
		if ((auto_healme) and (text:find('%[Предложение%]') or text:find('%[Новое предложение%]'))) then
			return false
		end
		if (auto_healme and text:find('Вы отправили предложение о лечении')) then
			--sampAddChatMessage('[Arizona Helper] {ffffff}Самохил будет через 7 секунд, ожидайте...', message_color)
			sampSendChat('/offer')
			return false
		end
		if ((auto_healme) and (text:find('Вас вылечил медик ' .. tagReplacements.my_nick()))) then
			auto_healme = false
			return false
		end
		if text:find("Пациент (.+) вызывает врачей (.+)холл(.+)этаж") then
			local nick = text:match("Пациент (.+) вызывает врачей (.+)холл(.+)этаж")
			sampAddChatMessage('[Arizona Helper] {ffffff}Пациент ' .. nick .. ' вызывает врача в холл больницы!', message_color)
			return false
		end
	end	

	if isMode('lc') then
		if text:find('Ошибка(.+)У игрока уже есть такая лицензия сроком более чем (.+)') then
			local one, two = text:match('Ошибка(.+)У игрока уже есть такая лицензия сроком более чем (.+)')
			sampAddChatMessage('[AS Helper] {ffffff}У игрока уже есть такая лицензия сроком более чем ' .. two, message_color)
			sampSendChat('У вас уже такая лицензия сроком более чем ' .. two)
			return false
		end
		if (text:find('Ошибка(.+)Вы не можете продавать лицензии на такой срок')) and settings.general.auto_lic then
			sampAddChatMessage('[AS Helper] {ffffff}Ошибка, ваш ранг ниже, чем требуется для выдачи данной лицензии!', message_color)
			sampSendChat('Извините я не могу выдать данную лицензию из-за низкой должности.')
			return false
		end
		
	end	

	if (text:find('Bogdan_Martelli') and getARZServerNumber():find('20')) or text:find('%[20%]Bogdan_Martelli') then
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
	if debug_mode then
		sampAddChatMessage('[DEBUG] {ffffff}' .. text, message_color)
	end
	local ignore = {
		[";)"] = true,
		[":D"] = true,
		[":O"] = true,
		[":|"] = true,
		[")"] = true,
		["))"] = true,
		["("] = true,
		["(("] = true,
		["xD"] = true,
		["q"] = true,
		["(+)"] = true,
		["(-)"] = true,
		[":)"] = true,
		[":("] = true,
		["=)"] = true,
		[":p"] = true,
		[";p"] = true,
		["(rofl)"] = true,
		["XD"] = true,
		["(agr)"] = true,
		["O.o"] = true,
		[">.<"] = true,
		[">:("] = true,
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
	if debug_mode then
		sampAddChatMessage('[DEBUG] {ffffff}' .. text, message_color)
	end
	if isMode('hospital') and text == "/me достаёт из своего мед.кейса лекарство и принимает его" then
		auto_healme = true
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
	
	if title:find('Основная статистика') and check_stats then
		if text:find("{FFFFFF}Имя: {B83434}%[(.-)]") then
			settings.player_info.name_surname = TranslateNick(text:match("{FFFFFF}Имя: {B83434}%[(.-)]"))
			input_name_surname = imgui.new.char[256](u8(settings.player_info.name_surname))
			sampAddChatMessage('[Arizona Helper] {ffffff}Ваше имя и фамилия обнаружены: ' .. settings.player_info.name_surname, message_color)
		end
		if text:find("{FFFFFF}Пол: {B83434}%[(.-)]") then
			settings.player_info.sex = text:match("{FFFFFF}Пол: {B83434}%[(.-)]")
			sampAddChatMessage('[Arizona Helper] {ffffff}Ваш пол обнаружен: ' .. settings.player_info.sex, message_color)
		end
		if text:find("{FFFFFF}Организация: {B83434}%[(.-)]") then
			settings.player_info.fraction = text:match("{FFFFFF}Организация: {B83434}%[(.-)]")
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
					['Областная полиция'] = {'РКШД', 'police'},
					['FBI'] = {'ФБР', 'fbi'}, ['ФБР'] = {'ФБР', 'fbi'},
					['Тюрьма строгого режима LV'] = {'ТСР', 'prison'},
					['Армия SF'] = {'СФа', 'army'}, ['Армия СФ'] = {'СФа', 'army'},
					['Армия ЛС'] = {'ЛСа', 'army'}, ['Армия LS'] = {'ЛСа', 'army'},
					['СМИ ЛС'] = {'СМИ ЛС', 'smi'}, ['CNN LS'] = {'СМИ ЛС', 'smi'},
					['СМИ ЛВ'] = {'СМИ ЛВ', 'smi'}, ['CNN LV'] = {'СМИ ЛВ', 'smi'},
					['СМИ СФ'] = {'СМИ СФ', 'smi'}, ['CNN SF'] = {'СМИ СФ', 'smi'},
					['Больница ЛС'] = {'ЛСМЦ', 'hospital'}, ['Больница LS'] = {'ЛСМЦ', 'hospital'},
					['Больница ЛВ'] = {'ЛВМЦ', 'hospital'}, ['Больница LV'] = {'ЛВМЦ', 'hospital'},
					['Больница СФ'] = {'СФМЦ', 'hospital'}, ['Больница SF'] = {'СФМЦ', 'hospital'},
					['Больница Jefferson'] = {'ДМЦ', 'hospital'}, ['Больница Джефферсон'] = {'ДМЦ', 'hospital'},
					['Правительство LS'] = {'Пра-во', 'gov'}, ['Правительство ЛС'] = {'Пра-во', 'gov'},
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
				}
				local data = fraction_data[settings.player_info.fraction]
				if data then
					settings.player_info.fraction_tag = data[1]
					settings.general.fraction_mode = data[2]
					settings.deportament.dep_tag1 = '[' .. settings.player_info.fraction_tag .. ']'
					sampAddChatMessage('[Arizona Helper] {ffffff}Вашей организации присвоен тег '..settings.player_info.fraction_tag .. ". Но вы можете изменить его.", message_color)

					local fraction_cmds = get_fraction_cmds(settings.general.fraction_mode, false)
					for _, cmd in ipairs(fraction_cmds) do
						table.insert(modules.commands.data.commands.my, cmd)
					end
					local manage_cmds = get_fraction_cmds(settings.general.fraction_mode, true)
					for _, cmd in ipairs(manage_cmds) do
						table.insert(modules.commands.data.commands_manage.my, cmd)
					end
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
				if text:find("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)") then
					settings.player_info.fraction_rank, settings.player_info.fraction_rank_number = text:match("{FFFFFF}Должность: {B83434}(.+)%((%d+)%)(.+)Уровень розыска")
					settings.player_info.fraction_rank_number = tonumber(settings.player_info.fraction_rank_number)
					sampAddChatMessage('[Arizona Helper] {ffffff}Ваша должность обнаружена, это: '..settings.player_info.fraction_rank.." ("..settings.player_info.fraction_rank_number..")", message_color)
					if settings.player_info.fraction_rank_number >= 9 then
						settings.general.auto_uval = true
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
		if check_stats == 'reload' then
			reload_script = true
			thisScript():reload()
		end
		return false
	end

	if members_info.check and title:find('(.+)%(В сети: (%d+)%)') then
        local count = 0
        local next_page = false
        local next_page_i = 0
		members_info.fraction = string.match(title, '(.+)%(В сети')
		members_info.fraction = string.gsub(members_info.fraction, '{(.+)}', '')
        for line in text:gmatch('[^\r\n]+') do
            count = count + 1
            if not line:find('Ник') and not line:find('страница') then

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
						table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working, info = optional_info})
					end
				else
					local color, nickname, id, rank, rank_number, rank_time, warns, afk = string.match(line, "{(%x%x%x%x%x%x)}%s*([^%(]+)%((%d+)%)%s*([^%(]+)%((%d+)%)%s*([^{}]+){FFFFFF}%s*(%d+)%s*%[%d+%]%s*/%s*(%d+)%s*%d+ шт")
					if color ~= nil and nickname ~= nil and id ~= nil and rank ~= nil and rank_number ~= nil and warns ~= nil and afk ~= nil then
						local working = false
						if color:find('90EE90') then
							working = true
						end

						table.insert(members_new, { nick = nickname, id = id, rank = rank, rank_number = rank_number, warns = warns, afk = afk, working = working, info = optional_info})
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
		elseif #members_new ~= 0 then
            sampSendDialogResponse(dialogid, 0, 0, 0)
			members = members_new
			members_info.check = false
			MembersWindow[0] = true
			--sampAddChatMessage('[Arizona Helper] {ffffff}Сканирование /members окончено! Для закрытия меню введите команду ещё раз', message_color)
		else
			sampSendDialogResponse(dialogid, 0, 0, 0)
			sampAddChatMessage('[Arizona Helper]{ffffff} Список сотрудников пуст!', message_color)
			members_info.check = false
        end
        return false
    end

	if settings.player_info.fraction_rank_number >= 9 then
		if title:find('Выберите ранг для (.+)') and text:find('вакансий') then -- invite
			sampSendDialogResponse(dialogid, 1, 0, 0)
			return false
		end
		if spawncar_bool and title:find('$') and text:find('Спавн транспорта') then -- спавн транспорта 
			local count = 0
			for line in text:gmatch('[^\r\n]+') do
				if line:find('Спавн транспорта') then
					sampSendDialogResponse(dialogid, 1, count, 0)
					spawncar_bool = false
					return false
				else
					count = count + 1
				end
			end
		end
		if vc_vize.bool then -- виза для ВС
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
				vc_vize.bool = false
				sampSendChat("/r Сотруднику "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize.player_id))).." выдана виза Vice City!")
				sampSendDialogResponse(dialogid, 1, 0, tostring(vc_vize.player_id))
				return false 
			end	
			if title:find('Забрать разрешение на поездки Vice City') then
				vc_vize.bool = false
				sampSendChat("/r У сотрудника "..TranslateNick(sampGetPlayerNickname(tonumber(vc_vize.player_id))).." была изьята виза Vice City!")
				sampSendDialogResponse(dialogid, 1, 0, tostring(sampGetPlayerNickname(vc_vize.player_id)))
				return false 
			end
		end
		if (platoon_check) then
			if text:find('Назначить взвод игроку') and text:find('Участники взвода') then
				sampSendDialogResponse(dialogid, 1, 3, 0)
				return false 
			end
			if text:find('{FFFFFF}Введите {FB8654}ID{FFFFFF} игрока, которого хотите назначить') then
				sampSendDialogResponse(dialogid, 1, 0, player_id)
				platoon_check = false
				return false 
			end
		end
	end

	if title:find('Сущности рядом') then -- arz fastmenu
		sampSendDialogResponse(dialogid, 0, 2, 0)
		return false 
	end

	if text:find('Вы действительно хотите вызвать сотрудников полиции?') and settings.general.anti_trivoga then -- тревожная кнопка
		sampSendDialogResponse(dialogid, 0, 0, 0)
		return false
	end

	
	
	if isMode('police') or isMode('fbi') then
		if text:find('Ник') and text:find('Уровень розыска') and text:find('Расстояние') and check_wanted then
			local text = string.gsub(text, '%{......}', '')
			text = string.gsub(text, 'Ник%s+Уровень розыска%s+Расстояние\n', '')
			for line in string.gmatch(text, '[^\n]+') do
				local nick, id, lvl, dist = string.match(line, '(%w+_%w+)%((%d+)%)%s+(%d) уровень%s+%[(.+)%]')
				if nick and id and lvl and dist then
					if dist:find('в интерьере') then
						dist = 'В инте'
					end
					table.insert(wanted_new, {nick = nick, id = id, lvl = lvl, dist = dist})
				end
			end
			sampSendDialogResponse(dialogid, 0, 0, 0)
			return false
		end
		
	end
	
	if (isMode('hospital')) then
		
		if (auto_healme) then
			if title:find('Активные предложения') and text:find('Лечение') and text:find('Когда') and text:find(tagReplacements.my_nick()) then
				sampSendDialogResponse(dialogid, 1, 0, 0)
				return false
			end
			if title:find('Активные предложения') and text:find('Лечение') and not text:find('Когда') and text:find(tagReplacements.my_nick()) then
				sampSendDialogResponse(dialogid, 1, 2, 0)
				return false
			end
			if title:find('Подтверждение действия') and text:find('Лечение') and text:find(tagReplacements.my_nick()) then
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
	


end
function sampev.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text_3d)
   	if text_3d and text_3d:find('Тревожная кнопка') and settings.general.anti_trivoga then
		return false
	end
end


function deleteMjMdSet()
	-- for key, hObj in pairs(getAllObjects()) do
    --     if doesObjectExist(hObj) then
    --         local objModel = getObjectModel(hObj)
	-- 		if objModel == 19141 or objModel == 18978 then
	-- 			-- deleteObject(hObj)
	-- 			sampAddChatMessage('[Arizona Helper - Ассистент] {ffffff}Сет-модификация МЮ/МО удалена с персонажа!', message_color)
	-- 		end
	-- 	end
	-- end
end

-- by cef events wojciech?
function emulationCEF(str)
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
addEventHandler('onSendPacket', function(id, bs, priority, reliability, orderingChannel)
	if id == 220 then
		local id = raknetBitStreamReadInt8(bs)
		local packettype = raknetBitStreamReadInt8(bs)
		if isMonetLoader() then
			local strlen = raknetBitStreamReadInt8(bs)
			--print('SEND', packettype, strlen, str)
			if settings.general.auto_clicker_situation and packettype == 66 and (strlen == 25 or strlen == 8) then
				clicked = false
			end
		else
			local strlen = raknetBitStreamReadInt16(bs)
			local str = raknetBitStreamReadString(bs, strlen)
			if packettype ~= 0 and packettype ~= 1 and #str > 2 then
				-- sampAddChatMessage("SEND: " .. str, -1)	
				--print('SEND', packettype, strlen, str)
			end
		end
	end
end)
addEventHandler('onReceivePacket', function (id, bs)
	if id == 220 then
		local id = raknetBitStreamReadInt8(bs)
        local cmd = raknetBitStreamReadInt8(bs)

		if cmd == 153 then
			local carId = raknetBitStreamReadInt16(bs)
			raknetBitStreamIgnoreBits(bs, 8)
			local numberlen = raknetBitStreamReadInt8(bs) -- plate data
			raknetBitStreamIgnoreBits(bs, 24)
			local plate_number = raknetBitStreamReadString(bs, numberlen)
			local typelen = raknetBitStreamReadInt8(bs) -- plate type
			raknetBitStreamIgnoreBits(bs, 24)
			local numType = raknetBitStreamReadString(bs, typelen)
			modules.arz_veh.cache[carId] = {
            	carID = carId or 0,
				number = plate_number or "",
				type = numType or "",
        	}
		end

		if isMonetLoader() then 
			if cmd == 84 then
				local unk1 = raknetBitStreamReadInt8(bs)
				local unk2 = raknetBitStreamReadInt8(bs)
				local len = raknetBitStreamReadInt16(bs)
				local encoded = raknetBitStreamReadInt8(bs)
				local string = encoded == 0 and raknetBitStreamReadString(bs, len) or raknetBitStreamDecodeString(bs, len + encoded)
				if string:find('{"progress":%d+,"text":"Для взаимодействия, нажимайте на кнопку посередине"}') and settings.general.auto_clicker_situation then
					--sampAddChatMessage('GET: ' .. string, -1)
					print('GET', string)
					clicked = true
				end
			end
		else
			if cmd == 17 then
				raknetBitStreamIgnoreBits(bs, 32)
				local length = raknetBitStreamReadInt16(bs)
				local encoded = raknetBitStreamReadInt8(bs)
				local cmd = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)
				--sampAddChatMessage('GET: ' .. cmd, -1)
				local view = string.match(cmd, "^window.executeEvent%('event%.setActiveView', [`']%[[\"%s]?(.-)[\"%s]?%][`']%);$")
				if view ~= nil and settings.general.auto_clicker_situation then
					clicked = (view == "Clicker")
				end
			end
		end
		
		
	end
end)
addEventHandler('onReceiveRpc', function (id, bs)
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
				isActiveCommand = true
				if isMonetLoader() and settings.general.mobile_stop_button then
					sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
					CommandStopWindow[0] = true
				elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop then
					sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
				else
					sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
				end
				local lines = {}
				for line in string.gmatch(modifiedText, "[^&]+") do
					table.insert(lines, line)
				end
				for _, line in ipairs(lines) do 
					if command_stop then 
						command_stop = false 
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
						sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
						return 
					end
					if wait_tag then
						for tag, replacement in pairs(binderTags) do
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
				isActiveCommand = false
				if isMonetLoader() and settings.general.mobile_stop_button then
					CommandStopWindow[0] = false
				end
			end)
		end
	end
	if not command_find then
		sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для изменения ранга отсутствует либо отключён!', message_color)
		sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
		sampSendChat('/giverank ' .. player_id .. " " .. giverank[0])
	end
end

imgui.OnInitialize(function()
	imgui.GetIO().IniFilename = nil
	if isMonetLoader() then
		fa.Init(14 * settings.general.custom_dpi)
	else
		fa.Init(14)
	end
	if settings.general.helper_theme == 0 and monet_no_errors then
		apply_moonmonet_theme()
	elseif settings.general.helper_theme == 1 then
		apply_dark_theme()
	elseif settings.general.helper_theme == 2 then
		apply_white_theme()
	end
end)

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

local init = {step = 0, step1_result = 0, fraction_selector = 0, fraction_selector_text = 'Без организации'}
imgui.OnFrame(
    function() return InititalWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.GEARS .. u8' Первоначальная настройка Arizona Helper ' .. fa.GEARS, InititalWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
        change_dpi()
		if init.step == 0 then
			if doesFileExist(configDirectory .. '/Resourse/logo1.png') or doesFileExist(configDirectory .. '/Resourse/logo2.png') then
				if not helper_logo then
					local path = ''
					if doesFileExist(configDirectory .. '/Resourse/logo1.png') and doesFileExist(configDirectory .. '/Resourse/logo2.png') then
						math.randomseed(os.time())
						local random = math.random(1,2)
						path = configDirectory .. '/Resourse/logo' .. random .. '.png'
					elseif doesFileExist(configDirectory .. '/Resourse/logo1.png') then
						path = configDirectory .. '/Resourse/logo1.png'
					elseif doesFileExist(configDirectory .. '/Resourse/logo2.png') then
						path = configDirectory .. '/Resourse/logo2.png'
					end
					helper_logo = imgui.CreateTextureFromFile(path)
				else
					imgui.Image(helper_logo, imgui.ImVec2(520 * settings.general.custom_dpi, 150 * settings.general.custom_dpi))
				end
			else
				if imgui.BeginChild('##init1_1', imgui.ImVec2(520 * settings.general.custom_dpi, 150 * settings.general.custom_dpi), true) then
					imgui.Text("\n\n\n")
					imgui.CenterTextDisabled(u8(configDirectory .. '/Resourse/logo1.png'))
						imgui.CenterTextDisabled(u8("https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Resourse/logo1.png"))
						imgui.CenterTextDisabled(u8('(не удалось загрузить логотип хелпера)'))
					imgui.EndChild()
				end
			end
			imgui.CenterText(u8("Похоже вы впервые запустили этот замечательный хелпер"))
			imgui.CenterText(u8("Нужно произвести настройку скрипта для доступности команд и функций"))
			imgui.Separator()
			imgui.CenterText(u8("Выберите способ для настройки хелппера:"))
			if imgui.CenterButton(fa.CIRCLE_ARROW_RIGHT .. u8(' Автоматически, исходя из вашей /stats (статистики) ') .. fa.CIRCLE_ARROW_LEFT) then
				sampAddChatMessage('[Arizona Helper] {ffffff}Пытаюсь получить ваш /stats поскольку остуствуют данные про вас!', message_color)
				check_stats = "reload"
				sampSendChat('/stats')
				InititalWindow[0] = false
			end
			if imgui.CenterButton(fa.CIRCLE_ARROW_RIGHT .. u8(' Вручную пройти первоначальную настройку хелпера ') .. fa.CIRCLE_ARROW_LEFT) then
				init.step = 1
				sampAddChatMessage('[Arizona Helper] {ffffff}Выберите свою организацию для инициализации нужных команд скрипта...', message_color)
			end
			imgui.Separator()
			imgui.CenterText(u8("Если что, в любой момент вы сможете заново перепройти настройку хелпера"))
		elseif init.step == 1 then
			
			local function render_org_block(org_num, icon, name, factions, org_options)
				if imgui.BeginChild('##init1_'..org_num, imgui.ImVec2(160 * settings.general.custom_dpi, 45 * settings.general.custom_dpi), (init.fraction_selector == org_num)) then
					if not (init.fraction_selector == org_num) then
						imgui.SetCursorPos(imgui.ImVec2(0, 5 * settings.general.custom_dpi))
					end
					imgui.CenterText(icon .. u8(' '..name))
					imgui.CenterTextDisabled(factions)
					imgui.EndChild()
				end
				if imgui.IsItemClicked() then
					init.fraction_selector = org_num
					if #org_options > 1 then
						imgui.OpenPopup(fa.GEARS .. u8(' Подтверждение данных ') .. fa.GEARS .. '##init_step_'..org_num)
					elseif org_num == 0 then
						init.step1_result = 0
						init.fraction_selector_text = name
					else
						init.step1_result = (org_num * 10) + 1
						init.fraction_selector_text = name
					end
				end
				imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
				if imgui.BeginPopupModal(fa.GEARS .. u8(' Подтверждение данных ') .. fa.GEARS .. '##init_step_'..org_num, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
					for i, option in ipairs(org_options) do
						if i % 2 == 0 then imgui.SameLine() end
						local button_width = 125
						if (i == #org_options) and not (i % 2 == 0) then
							button_width = button_width * 2 + imgui.GetStyle().ItemSpacing.x
						end
						if imgui.Button(u8(option), imgui.ImVec2(button_width * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							init.step1_result = (org_num * 10) + i
							init.fraction_selector_text = name
							imgui.CloseCurrentPopup()
						end
					end
					imgui.EndPopup()
				end
			end
			render_org_block(1, fa.BUILDING_SHIELD, 'Мин.Юстиции', 'LSPD/LVPD/SFPD/RCSD/FBI', {"LSPD", "LVPD", "SFPD", "RCSD", "S.W.A.T.", "FBI"})
			imgui.SameLine()
			render_org_block(2, fa.HOSPITAL, 'Мин.Здрав.', 'LSMC/LVMC/SFMC/JMC', {"LSMC", "LVMC", "SFMC", "JMC"})
			imgui.SameLine()
			render_org_block(3, fa.BUILDING_NGO, 'Масс.Медиа', 'CNN LS/CNN LV/CNN SF', {"CNN LS", "CNN LV", "CNN SF"})

			render_org_block(4, fa.BUILDING_SHIELD, 'Мин.Обороны', 'LSa/SFa', {"LSa", "SFa"})
			imgui.SameLine()
			render_org_block(5, fa.BUILDING_LOCK, 'Тюрьма', 'MSP', {"MSP"})
			imgui.SameLine()
			render_org_block(6, fa.BUILDING, 'ГЦЛ (АШ)', 'LC', {"LC"})

			render_org_block(7, fa.BUILDING_COLUMNS, 'Правительство', 'GOV', {"GOV"})
			imgui.SameLine()
			render_org_block(8, fa.BUILDING, 'Страховая', 'INC', {"INC"})
			imgui.SameLine()
			render_org_block(9, fa.HOTEL, 'Пожарная', 'FD', {"FD"})

			render_org_block(10, fa.TORII_GATE, 'Мафии', 'YKZ/LCN/RM/WMC/TRB', {"Yakuza", "La Cosa Nostra", "Russian Mafia", "Warlock MC", "Tierra Robada Bikers"})
			imgui.SameLine()
			render_org_block(11, fa.BUILDING_WHEAT, 'Банды', 'Grove/Ballas/Rifa/Vagos', {"Grove Street", "East Side Ballas", "Los Santos Vagos", "The Rifa", "Varrios Los Aztecas", "Night Wolves"})
			imgui.SameLine()
			render_org_block(0, fa.BUILDING_CIRCLE_XMARK, 'Без организации', u8'Биндер & Заметки', {})

			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8(' Выбрать "' .. init.fraction_selector_text .. '" ') .. fa.CIRCLE_ARROW_LEFT, imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				slider[0] = 1
				if init.step1_result ~= 0 then
					init.step = 2
				else
					settings.player_info.fraction_rank = 'Нету'
					settings.player_info.fraction_rank_number = 0
					imgui.StrCopy(input, u8(TranslateNick(binderTags.my_nick())))
					init.step = 3
				end
			end
		elseif init.step == 2 then
			imgui.CenterText(u8('Укажите свою должность в организации'))
			imgui.PushItemWidth(320 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_fraction_rank', u8('Введите полное название вашей должности'), input, 256)
			imgui.PushItemWidth(320 * settings.general.custom_dpi)
			imgui.SliderInt('##fraction_rank_number', slider, 1, 10)
			imgui.Separator()
			if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить и продолжить ' .. fa.FLOPPY_DISK .. '##input_nick', imgui.ImVec2(320 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				settings.player_info.fraction_rank = u8:decode(ffi.string(input))
				settings.player_info.fraction_rank_number = slider[0]
				if settings.player_info.fraction_rank_number >= 9 then
					settings.general.auto_uval = true
				end
				init.step = 3
				imgui.StrCopy(input, u8(TranslateNick(binderTags.my_nick())))
			end
		elseif init.step == 3 then
			imgui.CenterText(u8('Укажите ваше Имя и Фамилию (из никнейма)'))
			imgui.PushItemWidth(300 * settings.general.custom_dpi)
			imgui.InputText(u8'##input_name_surname', input, 256) 
			imgui.Separator()
			if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить и продолжить ' .. fa.FLOPPY_DISK .. '##input_nick', imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				settings.player_info.name_surname = u8:decode(ffi.string(input))
				init.step = 4
			end
		elseif init.step == 4 then
			imgui.CenterText(u8('Укажите пол персонажа'))
			imgui.Separator()
			if imgui.Button(fa.PERSON .. u8' Мужчина ' .. fa.PERSON .. '##select_sex', imgui.ImVec2(160 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				settings.player_info.sex = 'Мужчина'
				init.step = 5
			end
			imgui.SameLine()
			if imgui.Button(fa.PERSON_DRESS .. u8' Женщина ' .. fa.PERSON_DRESS .. '##select_sex', imgui.ImVec2(160 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				settings.player_info.sex = 'Женщина'
				init.step = 5
			end
		elseif init.step == 5 then
			local fraction_modes = {
				{id = 0,  name = "Отсутствует",          mode = "none",      tag = "Нету"},
				{id = 11, name = "Полиция ЛС",           mode = "police",    tag = "LSPD"},
				{id = 12, name = "Полиция LV",           mode = "police",    tag = "LVPD"},
				{id = 13, name = "Полиция SF",           mode = "police",    tag = "SFPD"},
				{id = 14, name = "Областная полиция",    mode = "police",    tag = "RCSD"},
				{id = 15, name = "Депортамент S.W.A.T.", mode = "police",    tag = "SWAT"},
				{id = 16, name = "FBI",                  mode = "fbi",       tag = "FBI"},
				{id = 21, name = "Больница LS",          mode = "hospital",  tag = "LSMC"},
				{id = 22, name = "Больница LV",          mode = "hospital",  tag = "LVMC"},
				{id = 23, name = "Больница SF",          mode = "hospital",  tag = "SFMC"},
				{id = 24, name = "Больница Jefferson",   mode = "hospital",  tag = "JMC"},
				{id = 31, name = "Радиоцентр ЛС",        mode = "smi",       tag = "CNN LS"},
				{id = 32, name = "Радиоцентр ЛВ",        mode = "smi",       tag = "CNN LV"},
				{id = 33, name = "Радиоцентр СФ",        mode = "smi",       tag = "CNN SF"},
				{id = 41, name = "Армия LS",             mode = "army",      tag = "LSa"},
				{id = 42, name = "Армия SF",             mode = "army",      tag = "SFa"},
				{id = 51, name = "Тюрьма строгого режима", mode = "prison",  tag = "MSP"},
				{id = 61, name = "Центр лицензирования", mode = "lc",    	 tag = "LC"},
				{id = 71, name = "Правительство LS",     mode = "gov",       tag = "GOV"},
				{id = 81, name = "Страховая компания",   mode = "ins", 		 tag = "INC"},
				{id = 91, name = "Пожарный департамент", mode = "fd",        tag = "FD"},
				{id = 101, name = "Yakuza",              mode = "mafia",     tag = "YKZ"},
				{id = 102, name = "La Cosa Nostra",      mode = "mafia",     tag = "LCN"},
				{id = 103, name = "Russian Mafia",       mode = "mafia",     tag = "RM"},
				{id = 104, name = "Warlock MC",          mode = "mafia",     tag = "WMC"},
				{id = 105, name = "Tierra Robada Bikers",mode = "mafia",     tag = "TRB"},
				{id = 111, name = "Grove Street",        mode = "ghetto",    tag = "GROVE"},
				{id = 112, name = "East Side Ballas",    mode = "ghetto",    tag = "BALLAS"},
				{id = 113, name = "Los Santos Vagos",    mode = "ghetto",    tag = "VAGOS"},
				{id = 114, name = "Varrios Los Aztecas", mode = "ghetto",    tag = "AZTEC"},
				{id = 115, name = "The Rifa",            mode = "ghetto",    tag = "RIFA"},
				{id = 116, name = "Night Wolves",        mode = "ghetto",    tag = "NW"}
			}
			for index, value in ipairs(fraction_modes) do
				if value.id == init.step1_result then
					settings.general.fraction_mode = value.mode
					settings.player_info.fraction = value.name
					settings.player_info.fraction_tag = value.tag
					break
				end
			end
			local fraction_cmds = get_fraction_cmds(settings.general.fraction_mode, false)
			for _, cmd in ipairs(fraction_cmds) do
				table.insert(modules.commands.data.commands.my, cmd)
			end
			local manage_cmds = get_fraction_cmds(settings.general.fraction_mode, true)
			for _, cmd in ipairs(manage_cmds) do
				table.insert(modules.commands.data.commands_manage.my, cmd)
			end
			if settings.general.fraction_mode == 'police' or settings.general.fraction_mode == 'fbi' then
				add_notes()
			elseif settings.general.fraction_mode == 'prison' then
				add_notes('prison')
			end
			init.step = 6
		elseif init.step == 6 then
			imgui.CenterText(u8('Кастомизация размера/цвета интерфейса хелпера'))
			imgui.CenterText(u8('Можно настроить под себя в /helper - Настройки'))
			imgui.Separator()
			if imgui.Button(fa.FLAG_CHECKERED .. u8' Завершить настройку и перезапустить ' .. fa.FLAG_CHECKERED .. '##end', imgui.ImVec2(320 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				save_settings()
				save_module('commands')
				reload_script = true
				thisScript():reload()
			end
		end
        imgui.End()
    end
)

function renderSmartSystem(title, icon, downloadPath, editPopupTitle, data, saveFunction, usageText, pathDisplay, download_file_name)
	if imgui.BeginChild('##smart'..title, imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
		if #data ~= 0 then
			imgui.CenterText(u8("Активно - ") .. u8(usageText))
		else
			imgui.CenterText(u8("Неактивно - Загрузите из облака или заполните вручную"))
		end
		imgui.Separator()
		imgui.SetCursorPosY(90 * settings.general.custom_dpi)
		imgui.SetCursorPosX(207 * settings.general.custom_dpi)
		if imgui.Button(fa.DOWNLOAD .. u8' Загрузить из облака ' .. fa.DOWNLOAD .. '##smart'..title) then
			_G['download_'..title:lower()] = true
			download_file = download_file_name
			downloadFileFromUrlToPath(downloadPath, pathDisplay)
			imgui.OpenPopup(fa.CIRCLE_INFO .. u8' Оповещение ' .. fa.CIRCLE_INFO .. '##downloadsmart'..title)
		end
		imgui.CenterText(u8'Данные из облака устарели?')
		imgui.CenterText(u8'Сообщите SMART модерам на нашем Discord сервере.')
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.CIRCLE_INFO .. u8' Оповещение ' .. fa.CIRCLE_INFO .. '##downloadsmart'..title, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
			if _G['download_'..title:lower()] then
				change_dpi()
				imgui.CenterText(u8'Идёт скачивание ' .. u8(editPopupTitle) .. u8' для сервера ' .. getARZServerName(getARZServerNumber()) .. "[" .. getARZServerNumber() .. ']')
				imgui.CenterText(u8'После успешной загрузки менюшка пропадёт и вы увидите сообщение в чате про завершение.')
				imgui.Separator()
				imgui.CenterText(u8'Если прошло больше 10 секунд и ничего не происходит, значит произошла ошибка скачивания!')
				imgui.CenterText(u8'Способы решения ошибки автоматического скачивания:')
				imgui.CenterText(u8'1) Вы можете вручную заполнить данные по кнопке "Отредактировать"')
				imgui.CenterText(u8'2) Вы можете скачать готовый файлик из облака (кнопка) и закинуть его по по пути:')
				imgui.CenterText(u8(pathDisplay))
				imgui.Separator()
			else
				MainWindow[0] = false
				imgui.CloseCurrentPopup()
			end
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть ' .. fa.CIRCLE_XMARK .. '##close_smart' .. title, imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				imgui.CloseCurrentPopup()
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_PLAY .. u8' Открыть облако ' .. fa.CIRCLE_PLAY .. '##open_web_smart' .. title, imgui.ImVec2(300 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				openLink('https://github.com/MTGMODS/arizona-helper/tree/main')
				MainWindow[0] = false
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
					imgui.BulletText(u8(chapter.name))
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
									imgui.BulletText(u8(item.text))
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



function render_assist_items(name, config_ref, description, description_hovered)
    local config = config_ref.value

    imgui.Separator()
    imgui.Columns(3)
    imgui.CenterColumnText(u8(name))
    imgui.NextColumn()
    imgui.CenterColumnText(u8(description))
    if description_hovered then
		imgui.Tooltip(u8(description_hovered))
        -- imgui.SameLine(nil, 5)
        -- imgui.TextDisabled("[?]")
        -- if imgui.IsItemHovered() then
        --     imgui.SetTooltip(u8(description_hovered))
        -- end
    end
    imgui.NextColumn()
    if imgui.CenterColumnSmallButton(u8((config and 'Отключить' or 'Включить') .. '##' .. name)) then
        config_ref = not config
        save_settings()
    end
end


if isMode('police') or isMode('fbi') then
	function render_fractions_functions()
		if imgui.BeginTabItem(fa.GEARS .. u8' Функции ' .. u8(settings.player_info.fraction_tag)) then
			if imgui.BeginTabBar('Tabs3') then
				if imgui.BeginTabItem(fa.BARS..u8' Стандартные') then 
					imgui.CenterText(u8('В доработке...'))
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.ROBOT .. u8' Ваш Ассистент') then 
					imgui.CenterText(u8('В доработке...'))
					if imgui.ToggleButton("Test##1", checkbox_awanted) then
						sampAddChatMessage("You change status, new status: " .. tostring(checkbox_awanted[0]), -1)
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.STAR .. u8' Система умного розыска') then 
					renderSmartSystem(
						'Система умного розыска',
						fa.STAR,
						'https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/SmartUK/' .. getARZServerNumber() .. '/SmartUK.json', 
						'системы умного розыска', 
						modules.smart_uk.data, 
						function() save_module("smart_uk") end, 
						'Использование: /sum [ID игрока]', 
						modules.smart_uk.path,
						'smart_uk'
					)
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.TICKET .. u8' Система умных штрафов') then 
					renderSmartSystem(
						'Система умных штрафов', 
						fa.TICKET, 
						'https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/SmartPDD/' .. getARZServerNumber() .. '/SmartPDD.json', 
						'системы умных штрафов', 
						modules.smart_pdd.data, 
						function() save_module("smart_pdd") end, 
						'Использование: /tsm [ID игрока]', 
						modules.smart_pdd.path,
						'smart_pdd'
					)
					imgui.EndTabItem()
				end
				imgui.EndTabBar() 
			end
			imgui.EndTabItem()
		end
	end
elseif isMode('army') or isMode('prison') then
	function render_fractions_functions()
		if imgui.BeginTabItem(fa.GEARS .. u8' Функции ' .. u8(settings.player_info.fraction_tag)) then
			if imgui.BeginTabBar('Tabs3') then
				if imgui.BeginTabItem(fa.ROBOT .. u8' Личный помочник "Ассистент"') then 
					if imgui.BeginChild('##assist', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
						imgui.Columns(3)
						imgui.CenterColumnText(u8"Функция")
						imgui.SetColumnWidth(-1, 150 * settings.general.custom_dpi)
						imgui.NextColumn()
						imgui.CenterColumnText(u8"Описание")
						imgui.SetColumnWidth(-1, 330 * settings.general.custom_dpi)
						imgui.NextColumn()
						imgui.CenterColumnText(u8"Управление")
						imgui.SetColumnWidth(-1, 120 * settings.general.custom_dpi)
						imgui.Columns(1)
						render_assist_items("RP общение", { value = settings.player_info.rp_chat }, '...', "роавлІІІІІІІІІІІІІІІІІІІІми у5736423и461419")

						imgui.Separator()
						imgui.EndChild()	
					end
					imgui.EndTabItem()
				end
				if imgui.BeginTabItem(fa.STAR .. u8' Система умного продления срока') then 
					renderSmartSystem(
						'Система умного продления срока', 
						fa.TICKET, 
						'https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/SmartRPTP/' .. getARZServerNumber() .. '/SmartRPTP.json', 
						'системы умного срока', 
						modules.smart_rptp.data, 
						function() save_module("smart_rptp") end, 
						'Использование: /pum [ID игрока]', 
						modules.smart_rptp.path,
						'smart_rptp'
					)
					imgui.EndTabItem()
				end
				imgui.EndTabBar() 
			end
			imgui.EndTabItem()
		end
	end
else
	function render_fractions_functions()
		if imgui.BeginTabItem(fa.GEARS .. u8' Функции орги') then
			imgui.CenterText(u8('Для вашей организации временно не доступно!'))
			imgui.EndTabItem()
		end
	end
end
			
imgui.OnFrame(
    function() return MainWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 430	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(getHelperIcon() .. " Arizona Helper " .. getHelperIcon() .. "##main", MainWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize )
		change_dpi()
		if imgui.BeginTabBar('чё код смотришь, а?') then	
			if imgui.BeginTabItem(fa.HOUSE..u8' Главное меню') then
				if doesFileExist(configDirectory .. '/Resourse/logo1.png') or doesFileExist(configDirectory .. '/Resourse/logo2.png') then
					if not helper_logo then
						local path = ''
						if doesFileExist(configDirectory .. '/Resourse/logo1.png') and doesFileExist(configDirectory .. '/Resourse/logo2.png') then
							math.randomseed(os.time())
							local random = math.random(1,2)
							path = configDirectory .. '/Resourse/logo' .. random .. '.png'
						elseif doesFileExist(configDirectory .. '/Resourse/logo1.png') then
							path = configDirectory .. '/Resourse/logo1.png'
						elseif doesFileExist(configDirectory .. '/Resourse/logo2.png') then
							path = configDirectory .. '/Resourse/logo2.png'
						end
						helper_logo = imgui.CreateTextureFromFile(path)
					else
						imgui.Image(helper_logo, imgui.ImVec2(589 * settings.general.custom_dpi, 161 * settings.general.custom_dpi))
					end
				else
					if imgui.BeginChild('##1', imgui.ImVec2(589 * settings.general.custom_dpi, 161 * settings.general.custom_dpi), true) then
						imgui.Text("\n\n\n\n")
						imgui.CenterTextDisabled(u8(configDirectory .. '/Resourse/logo1.png'))
						imgui.CenterTextDisabled(u8("https://github.com/MTGMODS/arizona-helper/raw/refs/heads/main/Resourse/logo1.png"))
						imgui.CenterTextDisabled(u8('(не удалось загрузить логотип хелпера)'))
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
						imgui.StrCopy(input, u8(settings.player_info.name_surname))
						imgui.OpenPopup(getUserIcon() .. u8' Имя и Фамилия ' .. getUserIcon() .. '##name_surname')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getUserIcon() .. u8' Имя и Фамилия ' .. getUserIcon() .. '##name_surname', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##name_surname', u8('Введите Имя и Фамилию вашего персонажа...'), input, 256) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_name_surname', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
							imgui.StrCopy(input, '')
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_name_surname', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.name_surname = u8:decode(ffi.string(input))
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
					if checkbox_accent_enable[0] then
						imgui.CenterColumnText(u8(settings.player_info.accent))
					else 
						imgui.CenterColumnText(u8'Отключено')
					end
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##accent') then
						imgui.StrCopy(input, u8(settings.player_info.accent))
						imgui.OpenPopup(getUserIcon() .. u8' Акцент персонажа ' .. getUserIcon() .. '##accent')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getUserIcon() .. u8' Акцент персонажа ' .. getUserIcon() .. '##accent', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						if imgui.Checkbox('##checkbox_accent_enable', checkbox_accent_enable) then
							settings.player_info.accent_enable = checkbox_accent_enable[0]
							save_settings()
						end
						imgui.SameLine()
						imgui.PushItemWidth(375 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##accent_input', u8('Введите акцент вашего персонажа...'), input, 256) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_accent', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.StrCopy(input, '')
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_accent', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then 
							settings.player_info.accent = u8:decode(ffi.string(input))
							save_settings()
							imgui.StrCopy(input, '')
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
						imgui.StrCopy(input, u8(settings.player_info.fraction))
						imgui.OpenPopup(getHelperIcon() .. u8' Организация ' .. getHelperIcon() .. '##fraction')
					end
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Организация ' .. getHelperIcon() .. '##fraction', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_fraction_name', u8('Введите название вашей организации...'), input, 256)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_fraction_edit', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.StrCopy(input, '')
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_fraction_edit', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction = u8:decode(ffi.string(input))
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
						imgui.CenterText(u8('В случае смены все RP команды будут сброшены на другие!'))
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_new_fraction', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.StrCopy(input, '')
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.GEARS .. u8' Сбросить ' .. fa.GEARS .. '##reset_fraction', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							modules.commands.data.commands.my = {{ cmd = 'time' , description = 'Посмотреть время' ,  text = '/me взглянул{sex} на свои часы с гравировкой Arizona Helper и посмотрел{sex} время&/time&/do На часах видно время {get_time}.' , arg = '' , enable = true, waiting = '1.5' , bind = "{}" }}
							modules.commands.data.commands_manage.my = {}
							InititalWindow[0] = true
							MainWindow[0] = false
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
						imgui.StrCopy(input, u8(settings.player_info.fraction_rank))
						slider[0] = settings.player_info.fraction_rank_number
						imgui.OpenPopup(getHelperIcon() .. u8' Должность в организации ' .. getHelperIcon() .. '##fraction_rank')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Должность в организации ' .. getHelperIcon() .. '##fraction_rank', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputTextWithHint(u8'##input_fraction_rank', u8('Введите название вашей должности...'), input, 256)
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.SliderInt('##fraction_rank_number', slider, 1, 10) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_fraction_rank', imgui.ImVec2(132 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.StrCopy(input, '')
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.PASSPORT .. u8' Получить /stats ' .. fa.PASSPORT .. '##stats_fraction_rank', imgui.ImVec2(132 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							check_stats = true
							sampSendChat('/stats')
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_fraction_rank', imgui.ImVec2(132 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction_rank = u8:decode(ffi.string(input))
							imgui.StrCopy(input, '')
							settings.player_info.fraction_rank_number = slider[0]
							if settings.player_info.fraction_rank_number >= 9 then
								settings.general.auto_uval = true
								registerCommandsFrom(modules.commands.data.commands_manage.my)
							end	
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
					imgui.Columns(1)
					imgui.Columns(1)
					imgui.Separator()
					imgui.Columns(3)
					imgui.CenterColumnText(u8"Тег организации:")
					imgui.NextColumn()
					imgui.CenterColumnText(u8(settings.player_info.fraction_tag))
					imgui.NextColumn()
					if imgui.CenterColumnSmallButton(fa.PEN_TO_SQUARE .. '##fraction_tag') then
						imgui.StrCopy(input, u8(settings.player_info.fraction_tag))
						imgui.OpenPopup(getHelperIcon() .. u8' Тег организации ' .. getHelperIcon() .. '##fraction_tag')
					end
					imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
					if imgui.BeginPopupModal(getHelperIcon() .. u8' Тег организации ' .. getHelperIcon() .. '##fraction_tag', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
						change_dpi()
						imgui.PushItemWidth(405 * settings.general.custom_dpi)
						imgui.InputText(u8'##input_fraction_tag', input, 256)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##cancel_fraction_rank', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.StrCopy(input, '')
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##save_fraction_tag', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.player_info.fraction_tag = u8:decode(ffi.string(input))
							save_settings()
							imgui.CloseCurrentPopup()
						end
						imgui.End()
					end
				imgui.EndChild()
				end
				if imgui.BeginChild('##3', imgui.ImVec2(589 * settings.general.custom_dpi, 28 * settings.general.custom_dpi), true) then
					if thisScript().version:find('VIP') then
						imgui.CenterText(fa.CROWN .. u8" Вы VIP пользователь данного хелпера! MTG MODS благодарит вас за поддержку " .. fa.CROWN)
					else
						imgui.Columns(2)
						imgui.Text(fa.HAND_HOLDING_DOLLAR .. u8" Вы можете финансово поддержать автора скрипта (MTG MODS) донатом " .. fa.HAND_HOLDING_DOLLAR)
						imgui.SetColumnWidth(-1, 480 * settings.general.custom_dpi)
						imgui.NextColumn()
						if imgui.CenterColumnSmallButton(u8'Реквизиты') then
							imgui.OpenPopup(fa.SACK_DOLLAR .. u8' Поддержка разработчика')
						end
						if imgui.BeginPopupModal(fa.SACK_DOLLAR .. u8' Поддержка разработчика', _, imgui.WindowFlags.NoCollapse  + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar) then
							change_dpi()
							if not isMonetLoader() then imgui.SetWindowFontScale(settings.general.custom_dpi) end
							imgui.CenterText(u8'Свяжитесь с MTG MODS:')
							--imgui.SetCursorPosX(20*settings.general.custom_dpi)
							if imgui.Button(u8('Telegram'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
								openLink('https://t.me/MTGMODS')
							end
							imgui.SameLine()
							if imgui.Button(u8('Discord'), imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
								openLink('https://discordapp.com/users/514135796685602827')
							end
							imgui.End()
						end
						imgui.SetColumnWidth(-1, 100 * settings.general.custom_dpi)
						imgui.Columns(1)
					end
					
					imgui.EndChild()
				end
				imgui.EndTabItem()
			end
			if imgui.BeginTabItem(fa.RECTANGLE_LIST..u8' Команды и RP отыгровки') then 
				if imgui.BeginTabBar('Tabs2') then
					if imgui.BeginTabItem(fa.BARS..u8' Стандартные') then 
						if imgui.BeginChild('##99', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
							imgui.Columns(2)
							imgui.CenterColumnText(u8"Команда")
							imgui.SetColumnWidth(-1, 220 * settings.general.custom_dpi)
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Описание")
							imgui.SetColumnWidth(-1, 400 * settings.general.custom_dpi)
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/probiv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Узнать статистику другого игрока")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/pnv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Надеть/снять очки ночного видения")
							imgui.Columns(1)
							imgui.Separator()
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/irv")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Надеть/снять инфакрасные очки")
							imgui.Columns(1)
							imgui.Separator()
							if not isMode('none') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/mb")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню улучшенного /members")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/dep")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню рации депортамента")
								imgui.Columns(1)
								imgui.Separator()
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/sob")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню проведения собеседования")
								imgui.Columns(1)
								imgui.Separator()
							end
							imgui.Columns(2)
							imgui.CenterColumnText(u8"/rpguns")
							imgui.NextColumn()
							imgui.CenterColumnText(u8"Меню настройки RP отыгровок оружия")
							imgui.Columns(1)
							imgui.Separator()
							if isMode('army') or isMode('prison') then
								imgui.Columns(2)
								imgui.CenterColumnText(u8"/post")
								imgui.NextColumn()
								imgui.CenterColumnText(u8"Меню системы постов")
								imgui.Columns(1)
								imgui.Separator()
								if isMode('prison') then
									imgui.Columns(2)
									imgui.CenterColumnText(u8"/pum")
									imgui.NextColumn()
									imgui.CenterColumnText(u8"Меню умного повышения срока")
									imgui.Columns(1)
									imgui.Separator()
								end
							end
							if isMode('police') or isMode('fbi') then
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
								imgui.CenterColumnText(u8"Автоматический увал")
								imgui.SameLine(nil, 5) imgui.TextDisabled("[?]")
								if imgui.IsItemHovered() then
									imgui.SetTooltip(u8"Функция только для лидера или его заместителей!\nПозволяет автоматически увольнять тех кто просит ПСЖ\nС подверждением от игрока, путём отправки сообщения в /rb")
								end
								imgui.NextColumn()
								if settings.general.auto_uval then
									imgui.CenterColumnText(u8'Включено')
								else
									imgui.CenterColumnText(u8'Отключено')
								end
								imgui.NextColumn()
								if imgui.CenterColumnSmallButton(settings.general.auto_uval and u8('Отключить') or u8('Включить') .. '##auto_uval') then
									settings.general.auto_uval = not settings.general.auto_uval 
									save_settings()
								end
								imgui.Columns(1)
								imgui.Separator()
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
										ComboTags[0] = 0
									elseif command.arg == '{arg}' then	
										ComboTags[0] = 1
									elseif command.arg == '{arg_id}' then
										ComboTags[0] = 2
									elseif command.arg == '{arg_id} {arg2}' then
										ComboTags[0] = 3
									elseif command.arg == '{arg_id} {arg2} {arg3}' then
										ComboTags[0] = 4
									elseif command.arg == '{arg_id} {arg2} {arg3} {arg4}' then
										ComboTags[0] = 5
									end
									binder_data = {
										change_waiting = command.waiting,
										change_cmd = command.cmd,
										change_text = command.text:gsub('&', '\n'),
										change_arg = command.arg,
										change_bind = command.bind,
										change_in_fastmenu = command.in_fastmenu,
										create_command_9_10 = isManage
									}
									input_description = imgui.new.char[256](u8(command.description))
									input_cmd = imgui.new.char[256](u8(command.cmd))
									input_text = imgui.new.char[8192](u8(binder_data.change_text))
									waiting_slider = imgui.new.float(tonumber(command.waiting))	
									BinderWindow[0] = true
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
							local new_cmd = {cmd = '', description = '', text = '', arg = '', enable = true, waiting = '1.5', bind = "{}" }
							table.insert(cmd_array, new_cmd)
							binder_data = {
								change_waiting = new_cmd.waiting,
								change_cmd = new_cmd.cmd,
								change_text = new_cmd.text,
								change_arg = new_cmd.arg,
								change_bind = new_cmd.bind,
								change_in_fastmenu = false,
								create_command_9_10 = isManage
							}
							ComboTags[0] = 0
							input_description = imgui.new.char[256]("")
							input_cmd = imgui.new.char[256]("")
							input_text = imgui.new.char[8192]("")
							waiting_slider = imgui.new.float(1.5)
							BinderWindow[0] = true
						end
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP команды (общие)') then 
						render_cmds(false)
						imgui.EndTabItem()
					end
					if imgui.BeginTabItem(fa.BARS..u8' RP команды (для 9/10)') then 
						if settings.player_info.fraction_rank_number == 9 or settings.player_info.fraction_rank_number == 10 then
							render_cmds(true)
						else
							imgui.CenterText(fa.TRIANGLE_EXCLAMATION .. u8" Внимание " .. fa.TRIANGLE_EXCLAMATION)
							imgui.Separator()
							imgui.CenterText(u8"У вас нету доступа к данным командам!")
							imgui.CenterText(u8"Необходимо иметь 9 или 10 ранг, у вас же - "..settings.player_info.fraction_rank_number..u8" ранг!")
							imgui.Separator()
						end
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.COMPASS .. u8' Fast Menu') then 
						function render_fastmenu_item(name, use, text, text2)
							if imgui.BeginChild('##fastmenu'..name, imgui.ImVec2(194 * settings.general.custom_dpi, 339 * settings.general.custom_dpi), true) then
								imgui.CenterText(u8(name))
								imgui.Separator()
								imgui.CenterText(u8("Использование:"))
								imgui.CenterText(use)
								imgui.SetCursorPosY(110 * settings.general.custom_dpi)
								imgui.CenterText(u8("Описание:"))
								imgui.CenterText(u8(text))
								imgui.SetCursorPosY(200 * settings.general.custom_dpi)
								imgui.CenterText(u8("Требуемый аргумент команды:"))
								imgui.CenterText(u8(text2))
								imgui.SetCursorPosY(290 * settings.general.custom_dpi)
								imgui.CenterText(u8("Выборочно вкл/выкл команды"))
								if imgui.Button(fa.GEAR .. u8(' Настроить команды меню ') .. '##' .. name) then
									if name == 'PieMenu' then
										sampAddChatMessage('[Arizona Helper] {ffffff}PieMenu временно недоступен для редактирования', message_color)
									else
										imgui.OpenPopup(fa.COMPASS .. u8' Настройка команд в ' .. u8(name) .. ' ' .. fa.COMPASS .. "##" .. name)
									end
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
										elseif name == 'piemenu' then
											arr = modules.commands.data.commands_pie.my or {}
										end
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
							'Быстрый вызов RP команд',
							'{arg_id}'
						)
						imgui.SameLine()
						render_fastmenu_item(
							'Leader FastMenu',
							u8'/lm ID или ' .. fa.KEYBOARD .. (isMonetLoader() and u8' Кнопочки' or u8' Hotkeys'),
							'Быстрый вызов RP команд 9-10',
							'{arg_id}'
						)
						imgui.SameLine()
						render_fastmenu_item(
							'PieMenu',
							(isMonetLoader() and (fa.KEYBOARD .. u8' Кнопочки') or (fa.COMPUTER_MOUSE .. u8' СКМ (колёсико)')),
							'Быстрый вызов RP команд',
							'Без аргумента'
						)
						imgui.EndTabItem() 
					end
					if imgui.BeginTabItem(fa.KEYBOARD .. (isMonetLoader() and u8' Кнопочки' or u8' Hotkeys')) then 
						if imgui.BeginChild('##999', imgui.ImVec2(589 * settings.general.custom_dpi, 338 * settings.general.custom_dpi), true) then
							if isMonetLoader() then
								imgui.CenterText(u8('Наэкранные кнопочки для работы функций хелпера'))
								imgui.Separator()
								if imgui.Checkbox(u8(' Отображение кнопки "Взаимодействие" (аналог /hm ID)'), checkbox_mobile_fastmenu_button) then
									settings.general.mobile_fastmenu_button = checkbox_mobile_fastmenu_button[0]
									FastMenuButton[0] = checkbox_mobile_fastmenu_button[0]
									save_settings()
								end
								if imgui.Checkbox(u8(' Отображение кнопки "Остановить" (аналог /stop)'), checkbox_mobile_stop_button) then
									settings.general.mobile_stop_button = checkbox_mobile_stop_button[0]
									save_settings()
								end
								if imgui.Checkbox(u8(' Отображение кнопки "10-55 10-66"'), checkbox_mobile_meg_button) then
									settings.general.mobile_meg_button = checkbox_mobile_meg_button[0]
									MegafonWindow[0] = settings.general.mobile_meg_button
									save_settings()
								end
								if imgui.Checkbox(u8(' Отображение кнопки "Taser" (аналог /taser)'), checkbox_mobile_taser_button) then
									settings.general.use_taser_menu = checkbox_mobile_taser_button[0]
									TaserWindow[0] = settings.general.use_taser_menu
									save_settings()
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
						show_note_name = u8(note.note_name)
						show_note_text = u8(note.note_text)
						NoteWindow[0] = true
					end
					if imgui.IsItemHovered() then
						imgui.SetTooltip(u8'Открыть заметку "' .. u8(note.note_name) .. '"')
					end
					imgui.SameLine()
					if imgui.SmallButton(fa.PEN_TO_SQUARE .. '##' .. i) then
						local note_text = note.note_text:gsub('&','\n')
						input_text_note = imgui.new.char[16384](u8(note_text))
						input_name_note = imgui.new.char[256](u8(note.note_name))
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
							imgui.InputTextWithHint(u8'##note_name', u8('Введите название вашей заметки'),input_name_note, 256)
							if not isMonetLoader() then
								old_scale = imgui.GetFont().Scale
								imgui.GetFont().Scale = settings.general.custom_dpi
								imgui.PushFont(imgui.GetFont())
							end	
							imgui.InputTextMultiline("##note_text", input_text_note, 16384, imgui.ImVec2(578 * settings.general.custom_dpi, 329 * settings.general.custom_dpi))
							if not isMonetLoader() then
								imgui.GetFont().Scale = old_scale
								imgui.PopFont()
							end
							imgui.EndChild()
						end	
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить заметку ' .. fa.FLOPPY_DISK, imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
							note.note_name = u8:decode(ffi.string(input_name_note))
							local temp = u8:decode(ffi.string(input_text_note))
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
					table.insert(modules.notes.data, {note_name = "Новая заметка", note_text = "Текст вашей новой заметки"})
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
						if theme[0] == 0 then
							imgui.SetCursorPosX(55 * settings.general.custom_dpi)
							if imgui.RadioButtonIntPtr(u8" Custom", theme, 0) then
								local r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
								local argb = join_argb(0, r, g, b)
								settings.general.helper_theme = 0
								settings.general.moonmonet_theme_color = argb
								settings.general.message_color = argb
								message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
								message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
								local tmp = imgui.ColorConvertU32ToFloat4(settings.general.message_color)
								msgcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
								apply_moonmonet_theme()
								save_settings()
							end
							imgui.SameLine()
							if imgui.ColorEdit3('## COLOR1', mmcolor, imgui.ColorEditFlags.NoInputs) then
								local r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
								local argb = join_argb(0, r, g, b)
								settings.general.moonmonet_theme_color = argb
								settings.general.message_color = argb
								message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
								message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
								local tmp = imgui.ColorConvertU32ToFloat4(settings.general.message_color)
								msgcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
								if theme[0] == 0 then
									apply_moonmonet_theme()
									save_settings()
								end
							end
						else
							if imgui.CenterColumnRadioButtonIntPtr(u8" Custom", theme, 0) then
								local r,g,b = mmcolor[0] * 255, mmcolor[1] * 255, mmcolor[2] * 255
								local argb = join_argb(0, r, g, b)
								settings.general.helper_theme = 0
								settings.general.moonmonet_theme_color = argb
								settings.general.message_color = argb
								message_color = "0x" .. argbToHexWithoutAlpha(0, r, g, b)
								message_color_hex = '{' .. argbToHexWithoutAlpha(0, r, g, b) .. '}'
								local tmp = imgui.ColorConvertU32ToFloat4(settings.general.message_color)
								msgcolor = imgui.new.float[3](tmp.z, tmp.y, tmp.x)
								apply_moonmonet_theme()
								save_settings()
							end
						end

						
					else
						if imgui.CenterColumnRadioButtonIntPtr(u8" Сustom ", theme, 0) then
							theme[0] = settings.general.helper_theme
							sampAddChatMessage('[Arizona Helper] {ffffff}Установите библиотеку MoonMonet!', message_color)
						end
					end
					imgui.NextColumn()
					if imgui.CenterColumnRadioButtonIntPtr(" Dark Theme ", theme, 1) then	
						settings.general.helper_theme = 1
						save_settings()
						apply_dark_theme()
					end
					imgui.NextColumn()
					if imgui.CenterColumnRadioButtonIntPtr(" White Theme ", theme, 2) then	
						settings.general.helper_theme = 2
						save_settings()
						apply_white_theme()
					end
					imgui.Columns(1)
					imgui.EndChild()
				end
				if imgui.BeginChild("##2_2",imgui.ImVec2(589 * settings.general.custom_dpi, 53 * settings.general.custom_dpi),true, imgui.WindowFlags.NoScrollbar) then
					imgui.CenterText(fa.PALETTE .. u8(' Цвет сообщений от хелпера в чате ') .. fa.PALETTE)
					if theme[0] == 0 then
						imgui.Separator()
						imgui.CenterText(u8('Используется такой-же цвет как в MoonMonet'))
					else
						imgui.SetCursorPosX((imgui.GetWindowWidth() / 2) - (10 * settings.general.custom_dpi))
						if imgui.ColorEdit3('## COLOR2', msgcolor, imgui.ColorEditFlags.NoInputs) then
							local r,g,b = msgcolor[0] * 255, msgcolor[1] * 255, msgcolor[2] * 255
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
					if settings.general.custom_dpi ~= tonumber(string.format('%.3f', slider_dpi[0])) then
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
						local text = (settings.general.custom_dpi < slider_dpi[0]) and 'большой' or 'мелкий'
						imgui.CenterText(u8('Если интерфейс будет слишком ') .. u8(text) .. u8(', то используйте /fixsize'))
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK .. '##change_size', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' Да, изменить ' .. fa.CIRCLE_ARROW_LEFT .. "##change_size", imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							settings.general.custom_dpi = tonumber(string.format('%.3f', slider_dpi[0]))
							save_settings()
							sampAddChatMessage('[Arizona Helper] {ffffff}Перезагрузка скрипта для пременения размера окон...', message_color)
							reload_script = true
							thisScript():reload()
						end
						imgui.End()
					end
					imgui.PushItemWidth(578 * settings.general.custom_dpi)
					imgui.SliderFloat('##slider_helper_size', slider_dpi, 0.5, 3) 
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
						imgui.CenterText(u8'Вы действительно хотите сбросить все настройки хелпера?')
						imgui.Separator()
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Нет, отменить ' .. fa.CIRCLE_XMARK .. "##cancel_restore", imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.CLOCK_ROTATE_LEFT .. u8' Да, сбросить ' .. fa.CLOCK_ROTATE_LEFT .. '##restore', imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							deleteHelperData()
							reload_script = true
							thisScript():reload()
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
							deleteHelperData('full')
							sampAddChatMessage('[Arizona Helper] {ffffff}Хелпер полностю удалён из вашего устройства!', message_color)
							thisScript():unload()
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
    function() return DeportamentWindow[0] end,
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
									imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
									if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##dep_add_tag'..tag_type, 
										imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##dep_add_tag'..tag_type, 
										imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
										table.insert(settings.deportament.dep_tags_custom, u8:decode(ffi.string(input_dep_new_tag)))
										save_settings()
										imgui.CloseCurrentPopup()
									end
									imgui.End()
								end
							end
                            imgui.EndTabItem()
                        end
                    end
                    createTagTab(u8'Стандартные теги (ru)', settings.deportament.dep_tags)
					createTagTab(u8'Стандартные теги (en)', settings.deportament.dep_tags_en)
					createTagTab(u8'Ваши кастомные теги', settings.deportament.dep_tags_custom)
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
                for i, tag in ipairs(settings.deportament.dep_fms) do
                    imgui.SameLine()
                    if imgui.Button(' ' .. u8(tag) .. ' ##' .. i) then
                        input_dep_fm = imgui.new.char[256](u8(tag))
                        settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
                        save_settings()
                        imgui.CloseCurrentPopup()
                    end
                end
                imgui.Separator()
                if imgui.Button(fa.CIRCLE_PLUS .. u8' Добавить частоту', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
                    imgui.OpenPopup(fa.TAG .. u8' Добавление новой частоты##2')
                end
                if imgui.BeginPopupModal(fa.TAG .. u8' Добавление новой частоты##2', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize) then
                    imgui.PushItemWidth(215 * settings.general.custom_dpi)
                    imgui.InputText('##input_dep_new_tag', input_dep_new_tag, 256) 
                    imgui.Separator()
                    if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##dep_add_fm', 
                        imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
                        imgui.CloseCurrentPopup()
                    end
                    imgui.SameLine()
                    if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK .. '##dep_add_fm', 
                        imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
                        table.insert(settings.deportament.dep_fms, u8:decode(ffi.string(input_dep_new_tag)))
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
        imgui.Begin(fa.WALKIE_TALKIE .. u8" Рация депортамента " .. fa.WALKIE_TALKIE, DeportamentWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar)
        change_dpi()
        if imgui.BeginChild('##2', imgui.ImVec2(500 * settings.general.custom_dpi, 186 * settings.general.custom_dpi), true) then
            imgui.Columns(3)
            imgui.CenterColumnText(u8('Ваш тег:'))
            imgui.PushItemWidth(155 * settings.general.custom_dpi)
            if imgui.InputText('##input_dep_tag1', input_dep_tag1, 256) then
                settings.deportament.dep_tag1 = u8:decode(ffi.string(input_dep_tag1))
                save_settings()
            end
            if imgui.CenterColumnButton(u8('Выбрать тег##1')) then
                imgui.OpenPopup(fa.TAG .. u8' Теги организаций##1')
            end
            createTagPopup('1', input_dep_tag1, 'dep_tag1')
            
            imgui.NextColumn()
            imgui.CenterColumnText(u8('Частота рации:'))
            imgui.PushItemWidth(155 * settings.general.custom_dpi)
            if imgui.InputText('##input_dep_fm', input_dep_fm, 256) then
                settings.deportament.dep_fm = u8:decode(ffi.string(input_dep_fm))
                save_settings()
            end
            if imgui.CenterColumnButton(u8('Выбрать частоту##1')) then
                imgui.OpenPopup(fa.WALKIE_TALKIE .. u8' Частота для использования рации /d')
            end
            createFrequencyPopup()
            imgui.NextColumn()
            imgui.CenterColumnText(u8('Тег получателя:'))
            imgui.PushItemWidth(155 * settings.general.custom_dpi)
            if imgui.InputText('##input_dep_tag2', input_dep_tag2, 256) then
                settings.deportament.dep_tag2 = u8:decode(ffi.string(input_dep_tag2))
                save_settings()
            end
            if imgui.CenterColumnButton(u8('Выбрать тег##2')) then
                imgui.OpenPopup(fa.TAG .. u8' Теги организаций##2')
            end
            createTagPopup('2', input_dep_tag2, 'dep_tag2')
            imgui.Columns(1)
            imgui.Separator()
            imgui.CenterText(u8('Текст:'))
            imgui.PushItemWidth(405 * settings.general.custom_dpi)
            imgui.InputText(u8'##dep_input_text', input_dep_text, 256)
            imgui.SameLine()
            if imgui.Button(u8' Отправить ') then
                local tag1 = settings.deportament.anti_skobki and u8:decode(ffi.string(input_dep_tag1)):gsub("[%[%]]", "") or u8:decode(ffi.string(input_dep_tag1))
                local tag2 = settings.deportament.anti_skobki and u8:decode(ffi.string(input_dep_tag2)):gsub("[%[%]]", "") or u8:decode(ffi.string(input_dep_tag2))
                sampSendChat('/d ' .. tag1 .. ' ' .. u8:decode(ffi.string(input_dep_fm)) .. ' ' .. tag2 .. ': ' .. u8:decode(ffi.string(input_dep_text)))
            end
            local tag1 = ffi.string(input_dep_tag1)
			local tag2 = ffi.string(input_dep_tag2)
			local fm = ffi.string(input_dep_fm)
			local text = ffi.string(input_dep_text)
			if settings.deportament.anti_skobki then
				tag1 = tag1:gsub("[%[%]]", "")
				tag2 = tag2:gsub("[%[%]]", "")
			end
			local preview_text = ('/d ' .. tag1 .. ' ' .. fm .. ' ' .. tag2 .. ': ' .. text)
			imgui.CenterText(preview_text)
            imgui.Separator()
            if imgui.Checkbox(u8(' Отключить использование символов [] (скобок) в тегах организаций'), checkbox_dep_anti_skobki) then
                settings.deportament.anti_skobki = checkbox_dep_anti_skobki[0]
                save_settings()
            end
            imgui.EndChild()
        end
        imgui.End()
    end
)

imgui.OnFrame(
    function() return BinderWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425	* settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.PEN_TO_SQUARE .. u8' Редактирование команды /' .. binder_data.change_cmd, BinderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  )
		change_dpi()
		if imgui.BeginChild('##binder_edit', imgui.ImVec2(589 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
			imgui.CenterText(fa.FILE_LINES .. u8' Описание команды:')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			imgui.InputText("##input_description", input_description, 256)
			imgui.Separator()
			imgui.CenterText(fa.TERMINAL .. u8' Команда для использования в чате (без /):')
			imgui.PushItemWidth(579 * settings.general.custom_dpi)
			if imgui.InputText("##input_cmd", input_cmd, 256) then
				-- sampAddChatMessage(ffi.string(input_cmd), -1)
				-- if ffi.string(input_cmd):find('%/') then
				-- 	imgui.StrCopy(input_cmd, ffi.string(input_cmd):gsub('%/', ''))
				-- end
			end
			imgui.Separator()
			imgui.CenterText(fa.CODE .. u8' Аргументы которые принимает команда:')
	    	imgui.Combo(u8'',ComboTags, ImItems, #item_list)
	 	    imgui.Separator()
	        imgui.CenterText(fa.FILE_WORD .. u8' Текстовый бинд команды:')
			if not isMonetLoader() then
				old_scale = imgui.GetFont().Scale
				imgui.GetFont().Scale = settings.general.custom_dpi
				imgui.PushFont(imgui.GetFont())
			end
			imgui.InputTextMultiline("##text_multiple", input_text, 8192, imgui.ImVec2(579 * settings.general.custom_dpi, 173 * settings.general.custom_dpi))
			if not isMonetLoader() then
				imgui.GetFont().Scale = old_scale
				imgui.PopFont()
			end
		imgui.EndChild() end
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. "##binder_cancel", imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			BinderWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.CLOCK .. u8' Задержка ' .. fa.CLOCK .. "##binder_wait",imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			imgui.OpenPopup(fa.CLOCK .. u8' Задержка (в секундах) '  .. fa.CLOCK)
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.CLOCK .. u8' Задержка (в секундах) ' .. fa.CLOCK, _, imgui.WindowFlags.NoResize ) then
			imgui.PushItemWidth(250 * settings.general.custom_dpi)
			imgui.SliderFloat(u8'##waiting', waiting_slider, 0.3, 10)
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK .. '##binder_wait_menu', imgui.ImVec2(imgui.GetMiddleButtonX(2), 0)) then
				waiting_slider = imgui.new.float(tonumber(binder_data.change_waiting))
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
		if imgui.BeginPopupModal(fa.TAGS .. u8' Теги для использования в биндере', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize ) then
			imgui.Text(u8(binder_tags_text))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Закрыть', imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
				imgui.CloseCurrentPopup()
			end
			imgui.End()
		end
		imgui.SameLine()
		if imgui.Button(fa.KEYBOARD .. u8' Забиндить ' .. fa.KEYBOARD  .. '##binder_bind', imgui.ImVec2(imgui.GetMiddleButtonX(5), 0)) then
			if ComboTags[0] == 0 then
				if isMonetLoader() then
					sampAddChatMessage('[Arizona Helper] {ffffff}Данная функция доступа только на ПК!', message_color)
				else
					if hotkey_no_errors then
						imgui.OpenPopup(fa.KEYBOARD .. u8' Бинд для команды /' .. binder_data.change_cmd)
					else
						sampAddChatMessage('[Arizona Helper] {ffffff}Данная функция недоступа, причина отсуствуют файлы библиотеки mimgui_hotkeys!', message_color)
					end
				end
			else
				sampAddChatMessage('[Arizona Helper] {ffffff}Данная функция доступа только если команда "Без аргументов"', message_color)
			end
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.KEYBOARD .. u8' Бинд для команды /' .. binder_data.change_cmd, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize) then
			local hotkeyObject = hotkeys[binder_data.change_cmd .. "HotKey"]
			if hotkeyObject then
				imgui.CenterText(u8('Клавиша активации бинда:'))
				local calc
				if binder_data.change_bind == '{}' or binder_data.change_bind == '[]' then
					calc = imgui.CalcTextSize('< click and select keys >')
				elseif binder_data.change_bind == nil then
					binder_data.change_bind = {}
				else
					calc = imgui.CalcTextSize(getNameKeysFrom(binder_data.change_bind))
				end
				local width = imgui.GetWindowWidth()
				local temp = (calc and calc.x and calc.x / 2) or 0
				imgui.SetCursorPosX(width / 2 - temp)
				if hotkeyObject:ShowHotKey() then
					binder_data.change_bind = encodeJson(hotkeyObject:GetHotKey())
				end
			else
				if not binder_data.change_bind then
				 	binder_data.change_bind = {}
				end
				
				hotkeys[binder_data.change_cmd .. "HotKey"] = hotkey.RegisterHotKey(binder_data.change_cmd .. "HotKey", false, decodeJson(binder_data.change_bind), function()
					if (not (sampIsChatInputActive() or sampIsDialogActive() or isSampfuncsConsoleActive())) then
						sampProcessChatInput('/' .. binder_data.change_cmd)
					end
				end)
				hotkeyObject = hotkeys[binder_data.change_cmd .. "HotKey"]
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
			if ffi.string(input_cmd):find('%W') or ffi.string(input_cmd) == '' or ffi.string(input_description) == '' or ffi.string(input_text) == '' then
				imgui.OpenPopup(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды ' .. fa.TRIANGLE_EXCLAMATION)
			else
				local new_arg = ''
				if ComboTags[0] == 0 then
					new_arg = ''
				elseif ComboTags[0] == 1 then
					new_arg = '{arg}'
				elseif ComboTags[0] == 2 then
					new_arg = '{arg_id}'
				elseif ComboTags[0] == 3 then
					new_arg = '{arg_id} {arg2}'
                elseif ComboTags[0] == 4 then
					new_arg = '{arg_id} {arg2} {arg3}'
				elseif ComboTags[0] == 5 then
					new_arg = '{arg_id} {arg2} {arg3} {arg4}'
				end
				local new_command = u8:decode(ffi.string(input_cmd))
				local temp_array = (binder_data.create_command_9_10) and modules.commands.data.commands_manage.my or modules.commands.data.commands.my
				for _, command in ipairs(temp_array) do
					if command.cmd == binder_data.change_cmd and command.arg == binder_data.change_arg and command.text:gsub('&', '\n') == binder_data.change_text then
						command.cmd = new_command
						command.arg = new_arg
						command.description = u8:decode(ffi.string(input_description))
						command.text = u8:decode(ffi.string(input_text)):gsub('\n', '&')
						command.bind = binder_data.change_bind
						command.waiting = waiting_slider[0]
						command.in_fastmenu = binder_data.change_in_fastmenu
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
						sampUnregisterChatCommand(binder_data.change_cmd)
						register_command(command.cmd, command.arg, command.text, tonumber(command.waiting))
						if not isMonetLoader() then updateHotkeyForCommand(command) end
						break
					end
				end
				BinderWindow[0] = false
			end
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopupModal(fa.TRIANGLE_EXCLAMATION .. u8' Ошибка сохранения команды ' .. fa.TRIANGLE_EXCLAMATION, _, imgui.WindowFlags.AlwaysAutoResize) then
			if ffi.string(input_cmd):find('%W') then
				imgui.BulletText(u8" В команде можно использовать только англ.буквы и/или цифры!")
			elseif ffi.string(input_cmd) == '' then
				imgui.BulletText(u8" Текстовый бинд команды не может быть пустой!")
			end
			if ffi.string(input_description) == '' then
				imgui.BulletText(u8" Описание команды не может быть пустое!")
			end
			if ffi.string(input_text) == '' then
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
    function() return MembersWindow[0] end,
    function(player)
		if #members == 0 then
			sampAddChatMessage('[Arizona Helper] {ffffff}Ошибка, список сотрудников пустой!', message_color)
			MembersWindow[0] = false
		elseif #members >= 16 then 
			sizeYY = 413 + 21
		else
			sizeYY = 24.5 * (#members + 1) + 21
		end
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.SetNextWindowSize(imgui.ImVec2(730 * settings.general.custom_dpi, sizeYY * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(getHelperIcon() .. " " ..  u8(members_info.fraction) .. " - " .. #members .. u8' сотрудников онлайн ' .. getHelperIcon(), MembersWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
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
		for i, v in ipairs(members) do
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
				MembersWindow[0] = false
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


imgui.OnFrame(
    function() return WantedWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.wanteds_menu.x, settings.windows_pos.wanteds_menu.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.STAR .. u8" Список преступников (всего " .. #wanted .. u8') ' .. fa.STAR, WantedWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize + imgui.WindowFlags.NoScrollbar)
		change_dpi()
		
		if tonumber(#wanted) == 0 then 
			sampAddChatMessage('[Arizona Helper] {ffffff}Сейчас на сервере нету игроков с розыском!', message_color)
			WantedWindow[0] = false
		end

		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
		if imgui.Button(u8'Обновить список преступников', imgui.ImVec2(340 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				WantedWindow[0] = false
				sampAddChatMessage('[Arizona Helper] {ffffff}Вы можете включить авто-обновление /wanteds в настройках Ассистента!', message_color)
				sampProcessChatInput('/wanteds')
			end
			imgui.Separator()
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
		for i, v in ipairs(wanted) do
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
    function() return MegafonWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.megafon.x, settings.windows_pos.megafon.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .. " Arizona Helper##fast_meg_button", MegafonWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
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

-- if not settings.windows_pos.taser then
-- 	settings.windows_pos.taser = default_settings.windows_pos.taser
-- end

imgui.OnFrame(
    function() return TaserWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.taser.x, settings.windows_pos.taser.y), imgui.Cond.FirstUseEver)
		imgui.Begin(" Arizona Helper##TaserWindow", TaserWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
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

imgui.OnFrame(
    function() return SumMenuWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.STAR .. u8" Умная выдача розыска " .. fa.STAR .. "##sum_menu", SumMenuWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
		if modules.smart_uk.data ~= nil and isParamSampID(player_id) then
			imgui.PushItemWidth(580 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_sum', u8('Поиск статей (подпунктов) в главах (пунктах)'), input, 128) 
			imgui.Separator()
			local input_sum_decoded = u8:decode(ffi.string(input))
			for _, chapter in ipairs(modules.smart_uk.data) do
				local chapter_has_matching_item = false
				if chapter.item then
					for _, item in ipairs(chapter.item) do
						if item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
							chapter_has_matching_item = true
							break
						end
					end
				end
				if chapter_has_matching_item then
					if imgui.CollapsingHeader(u8(chapter.name)) then
						for _, item in ipairs(chapter.item) do
							if item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
								local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Перепроверьте данные перед выдачей розыска##' .. item.text .. item.lvl .. item.reason
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
								imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
								if imgui.Button(u8(split_text_into_lines(item.text, 85))..'##' .. item.text .. item.lvl .. item.reason, imgui.ImVec2(imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
									imgui.OpenPopup(popup_id)
								end
								imgui.PopStyleColor()
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
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
										SumMenuWindow[0] = false
										find_and_use_command('Прошу обьявить в розыск %{arg2%} степени дело N%{arg_id%}%. Причина%: %{arg3%}', player_id .. ' ' .. item.lvl .. ' ' .. item.reason)
										imgui.CloseCurrentPopup()
									end
									imgui.SameLine()
									local text_rank = ((settings.general.fraction == 'ФБР' or settings.general.fraction == 'FBI') and ' [4+]' or ' [5+]')
									if imgui.Button(fa.STAR .. u8' Выдать розыск' .. text_rank, imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
										SumMenuWindow[0] = false
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
            SumMenuWindow[0] = false
        end
        imgui.End()
    end
)

imgui.OnFrame(
    function() return PuMenuWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.STAR .. u8" Умная выдача повышенного срока " .. fa.STAR .. "##pum_menu", PuMenuWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
		if modules.smart_rptp.data ~= nil and isParamSampID(player_id) then
			imgui.PushItemWidth(580 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_sum', u8('Поиск статей (подпунктов) в главах (пунктах)'), input, 128) 
			imgui.Separator()
			local input_sum_decoded = u8:decode(ffi.string(input))
			for _, chapter in ipairs(modules.smart_rptp.data) do
				local chapter_has_matching_item = false
				if chapter.item then
					for _, item in ipairs(chapter.item) do
						if item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
							chapter_has_matching_item = true
							break
						end
					end
				end
				if chapter_has_matching_item then
					if imgui.CollapsingHeader(u8(chapter.name)) then
						for _, item in ipairs(chapter.item) do
							if item.text:rupper():find(input_sum_decoded:rupper()) or input_sum_decoded == '' then
								local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Перепроверьте данные перед повышением срока ' .. fa.TRIANGLE_EXCLAMATION .. '##' .. item.text .. item.lvl .. item.reason
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
								imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
								if imgui.Button(u8(split_text_into_lines(item.text, 85))..'##' .. item.text .. item.lvl .. item.reason, imgui.ImVec2(imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
									imgui.OpenPopup(popup_id)
								end
								imgui.PopStyleColor()
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
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
										PuMenuWindow[0] = false
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
            SumMenuWindow[0] = false
        end
        imgui.End()
    end
)

imgui.OnFrame(
    function() return TsmMenuWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 413 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.TICKET .. u8" Умная выдача штрафов " .. fa.TICKET .. "##tsm_menu", TsmMenuWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
		if modules.smart_pdd.data ~= nil and isParamSampID(player_id) then
			imgui.PushItemWidth(580 * settings.general.custom_dpi)
			imgui.InputTextWithHint(u8'##input_tsm', u8('Поиск статей (подпунктов) в главах (пунктах)'), input, 128) 
			imgui.Separator()
			local input_tsm_decoded = u8:decode(ffi.string(input))
			for _, chapter in ipairs(modules.smart_pdd.data) do
				local chapter_has_matching_item = false
				if chapter.item then
					for _, item in ipairs(chapter.item) do
						if item.text:rupper():find(input_tsm_decoded:rupper()) or input_tsm_decoded == '' then
							chapter_has_matching_item = true
							break
						end
					end
				end
				if chapter_has_matching_item then
					if imgui.CollapsingHeader(u8(chapter.name)) then
						for _, item in ipairs(chapter.item) do
							if item.text:rupper():find(input_tsm_decoded:rupper()) or input_tsm_decoded == '' then
								local popup_id = fa.TRIANGLE_EXCLAMATION .. u8' Перепроверьте данные перед выдачей штрафа##' .. item.text .. item.amount .. item.reason
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.0, 0.5)
								imgui.PushStyleColor(imgui.Col.ButtonHovered, imgui.ImVec4(1.00, 0.00, 0.00, 0.65))
								if imgui.Button(u8(split_text_into_lines(item.text,85))..'##' .. item.text .. item.amount .. item.reason, imgui.ImVec2( imgui.GetMiddleButtonX(1), (25 * count_lines_in_text(item.text, 85)) * settings.general.custom_dpi)) then
									imgui.OpenPopup(popup_id)
								end 
								imgui.PopStyleColor()
								imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
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
										TsmMenuWindow[0] = false
										find_and_use_command('/writeticket {arg_id}', player_id .. ' ' .. item.amount .. ' ' .. item.reason)
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
            TsmMenuWindow[0] = false
        end
        imgui.End()
    end
)


imgui.OnFrame(
    function() return NoteWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.Begin(fa.FILE_PEN .. ' '.. show_note_name .. ' ' .. fa.FILE_PEN, NoteWindow, imgui.WindowFlags.AlwaysAutoResize)
        change_dpi()
        imgui.Text(show_note_text:gsub('&','\n'))
        imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		--imgui.SetNextWindowSize(imgui.ImVec2(290 * settings.general.custom_dpi, 415 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.USER .. ' '..sampGetPlayerNickname(player_id)..' ['..player_id.. ']##FastMenu', FastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		local check = false
		for _, command in ipairs(modules.commands.data.commands.my) do
			if command.enable and command.arg == '{arg_id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					FastMenu[0] = false
				end
				check = true
			end
		end
		if not check then
			sampAddChatMessage('[Arizona Helper] {ffffff}Нету команд включенных на работу в FastMenu!', message_color)
			FastMenu[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenuButton[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.mobile_fastmenu_button.x, settings.windows_pos.mobile_fastmenu_button.y), imgui.Cond.FirstUseEver)
		imgui.Begin(fa.BUILDING_SHIELD .." Justice Helper##fast_menu_button", FastMenuButton, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoBackground  )
		change_dpi()
		if imgui.Button(fa.IMAGE_PORTRAIT..u8' Взаимодействие ') then
			if tonumber(#get_players()) == 1 then
				show_fast_menu(get_players()[1])
				FastMenuButton[0] = false
			elseif tonumber(#get_players()) > 1 then
				FastMenuPlayers[0] = true
				FastMenuButton[0] = false
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
    function() return LeaderFastMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getUserIcon() ..' '..sampGetPlayerNickname(player_id)..' ['..player_id..']##LeaderFastMenu', LeaderFastMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize  )
		change_dpi()
		local check = false
		for _, command in ipairs(modules.commands.data.commands_manage.my) do
			if command.enable and command.arg == '{arg_id}' and command.in_fastmenu then
				if imgui.Button(u8(command.description), imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
					sampProcessChatInput("/" .. command.cmd .. " " .. player_id)
					LeaderFastMenu[0] = false
				end
			end
		end
		if not isMonetLoader() then
			if imgui.Button(u8"Выдать выговор",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/vig '..player_id..' ')
				LeaderFastMenu[0] = false
			end
			if imgui.Button(u8"Уволить из организации",imgui.ImVec2(290 * settings.general.custom_dpi, 30 * settings.general.custom_dpi)) then
				sampSetChatInputEnabled(true)
				sampSetChatInputText('/unv '..player_id..' ')
				LeaderFastMenu[0] = false
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return GiveRankMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon().." Arizona Helper " .. getHelperIcon() .. "##rank", GiveRankMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.CenterText(u8'Выберите ранг для '.. sampGetPlayerNickname(player_id) .. ':')
		imgui.PushItemWidth(250 * settings.general.custom_dpi)
		imgui.SliderInt('', giverank, 1, (settings.player_info.fraction_rank_number == 9) and 8 or 9) -- зам не может дать 9 ранг
		imgui.Separator()
		local text = isMonetLoader() and " Выдать ранг" or " Выдать ранг [Enter]"
		if imgui.Button(fa.USER .. u8(text), imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			give_rank()
			GiveRankMenu[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return CommandStopWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .. " Arizona Helper " .. getHelperIcon() .. "##CommandStopWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if isMonetLoader() and isActiveCommand then
			if imgui.Button(fa.CIRCLE_STOP..u8' Остановить отыгровку ') then
				command_stop = true 
				CommandStopWindow[0] = false
			end
		else
			CommandStopWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return CommandPauseWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY - 50 * settings.general.custom_dpi), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .." Arizona Helper " .. getHelperIcon() .. "##CommandPauseWindow", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		if command_pause then
			if imgui.Button(fa.CIRCLE_ARROW_RIGHT .. u8' Продолжить ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				command_pause = false
				CommandPauseWindow[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Полный STOP ', imgui.ImVec2(150 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				command_stop = true 
				command_pause = false
				CommandPauseWindow[0] = false
			end
		else
			CommandPauseWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return FastMenuPlayers[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() ..u8" Выберите игрока " .. getHelperIcon() .. "##fast_menu_players", FastMenuPlayers, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		if tonumber(#get_players()) == 0 then
			show_fast_menu(get_players()[1])
			FastMenuPlayers[0] = false
		elseif tonumber(#get_players()) >= 1 then
			for _, playerId in ipairs(get_players()) do
				local id = tonumber(playerId)
				if imgui.Button(sampGetPlayerNickname(id), imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
					if tonumber(#get_players()) ~= 0 then show_fast_menu(id) end
					FastMenuPlayers[0] = false
				end
			end
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return UpdateWindow[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.CIRCLE_INFO .. u8" Оповещение " .. fa.CIRCLE_INFO .. "##update_window", _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		if not isMonetLoader() then change_dpi() end
		imgui.CenterText(u8'У вас сейчас установлена версия хелпера ' .. u8(tostring(thisScript().version)) .. ".")
		imgui.CenterText(u8'В базе данных найдена новая версия хелпера - ' .. u8(update.version) .. ".")
		imgui.CenterText(u8'Рекомендуется обновить скрипт для доступа к актуальному функционалу.')
		imgui.Separator()
		imgui.CenterText(u8('Что нового в версии ') .. u8(update.version) .. ':')
		imgui.Text(u8(update.info))
		imgui.Separator()
		if imgui.Button(fa.CIRCLE_XMARK .. u8' Не обновлять ',  imgui.ImVec2(250 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			UpdateWindow[0] = false
		end
		imgui.SameLine()
		if imgui.Button(fa.DOWNLOAD ..u8' Загрузить новую версию',  imgui.ImVec2(250 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
			if thisScript().version:find('VIP') then
				sampAddChatMessage('[Arizona Helper] {ffffff}Загрузите новую версию из VIP чата!', message_color)
			else
				download_file = 'helper'
				downloadFileFromUrlToPath(update.url, getWorkingDirectory():gsub('\\','/') .. "/Arizona Helper.lua")
			end
			UpdateWindow[0] = false
		end
		imgui.End()
    end
)

imgui.OnFrame(
    function() return SobesMenu[0] end,
    function(player)
		if player_id ~= nil and isParamSampID(player_id) then
			imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(fa.PERSON_CIRCLE_CHECK..u8' Проведение собеседования игроку ' .. sampGetPlayerNickname(player_id) .. ' ' .. fa.PERSON_CIRCLE_CHECK, SobesMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize)
			change_dpi()
			if imgui.BeginChild('sobes1', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
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
						sampSendChat("/n " .. sampGetPlayerNickname(player_id) .. ", используйте /showpass [ID] , /showmc [ID] , /showlic [ID]")
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
					SobesMenu[0] = false
				end
				imgui.EndChild()
			end
			imgui.SameLine()
			if imgui.BeginChild('sobes2', imgui.ImVec2(240 * settings.general.custom_dpi, 182 * settings.general.custom_dpi), true) then
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
			if imgui.BeginChild('sobes3', imgui.ImVec2(150 * settings.general.custom_dpi, -1), true) then
				imgui.CenterColumnText(fa.CIRCLE_XMARK .. u8" Отказы " .. fa.CIRCLE_XMARK)
				imgui.Separator()
				local function otkaz(reason)
					lua_thread.create(function ()
						SobesMenu[0] = false
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
			SobesMenu[0] = false
		end
    end
)

-- MJ
imgui.OnFrame(
    function() return RPWeaponWindow[0] end,
    function(player)
        imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(600 * settings.general.custom_dpi, 425 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
        imgui.Begin(fa.GUN .. u8" RP отыгровка оружия в чате " .. fa.GUN, RPWeaponWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
		change_dpi()
        imgui.PushItemWidth(385 * settings.general.custom_dpi)
        imgui.InputTextWithHint(u8'##inputsearch_weapon_name', u8('Вводите чтобы искать оружие по его ID или названию...'), input, 256) 
		imgui.SameLine()
		if imgui.Button(u8("Включить всё")) then
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				value.enable = true
			end
			save_module('rp_gun')
		end		
		imgui.SameLine()
		if imgui.Button(u8("Отключить всё")) then
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				value.enable = false
			end
			save_module('rp_gun')
		end		
		if imgui.BeginChild('rpguns1', imgui.ImVec2(588 * settings.general.custom_dpi, 361 * settings.general.custom_dpi), true) then
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
			for index, value in ipairs(modules.rpgun.data.rp_guns) do
				if u8:decode(ffi.string(input)) == '' or value.name:rupper():find(u8:decode(ffi.string(input)):rupper()) or value.id == tonumber(u8:decode(ffi.string(input)))  then
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
						imgui.StrCopy(input, u8(value.name))
						imgui.OpenPopup(fa.GUN .. u8' Название оружия ' .. fa.GUN .. '##weapon_name' .. index)
					end
					if imgui.BeginPopupModal(fa.GUN .. u8' Название оружия ' .. fa.GUN .. '##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.InputText(u8'##weapon_name', input, 256) 
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							sampAddChatMessage('НЕДОСТУПНО В ФРИ ВЕРСИИ', -1)
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
						ComboTags2[0] = value.rpTake - 1
						imgui.OpenPopup(fa.GUN .. u8' Расположение оружия##weapon_name' .. index)
					end
					if imgui.BeginPopupModal(fa.GUN .. u8' Расположение оружия##weapon_name' .. index, _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize ) then
						imgui.PushItemWidth(400 * settings.general.custom_dpi)
						imgui.Combo(u8'##' .. index, ComboTags2, ImItems2, #item_list2)
						if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ' .. fa.CIRCLE_XMARK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							imgui.CloseCurrentPopup()
						end
						imgui.SameLine()
						if imgui.Button(fa.FLOPPY_DISK .. u8' Сохранить ' .. fa.FLOPPY_DISK, imgui.ImVec2(200 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
							sampAddChatMessage('НЕДОСТУПНО В ФРИ ВЕРСИИ', -1)
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

-- MH
imgui.OnFrame(
    function() return MedCardMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##medcard", MedCardMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.CenterText(u8'Срок действия мед.карты:')
		if imgui.RadioButtonIntPtr(u8" 7 дней ##0",medcard_days,0) then
			medcard_days[0] = 0
		end
		if imgui.RadioButtonIntPtr(u8" 14 дней ##1",medcard_days,1) then
			medcard_days[0] = 1
		end
		if imgui.RadioButtonIntPtr(u8" 30 дней ##2",medcard_days,2) then
			medcard_days[0] = 2
		end
		if imgui.RadioButtonIntPtr(u8" 60 дней ##3",medcard_days,3) then
			medcard_days[0] = 3
		end
		imgui.Separator()
		imgui.CenterText(u8'Cтатус здоровья пациента:')
		if imgui.RadioButtonIntPtr(u8" Не определен ##0",medcard_status,0) then
			medcard_status[0] = 0
		end
		if imgui.RadioButtonIntPtr(u8" Психически не здоров ##1",medcard_status,1) then
			medcard_status[0] = 1
		end
		if imgui.RadioButtonIntPtr(u8" Наблюдаются отклонения ##2",medcard_status,2) then
			medcard_status[0] = 2
		end
		if imgui.RadioButtonIntPtr(u8" Полностью здоров ##3",medcard_status,3) then
			medcard_status[0] = 3
		end
		imgui.Separator()
		if imgui.Button(fa.ID_CARD_CLIP..u8" Выдать мед.карту", imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			local command_find = false
			for _, command in ipairs(settings.commands) do
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
						isActiveCommand = true
						command_pause = false
						if modifiedText:find('&.+&') then
							if isMonetLoader() and settings.general.mobile_stop_button then
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
								CommandStopWindow[0] = true
							elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
							else
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
							end
						end
						local lines = {}
						for line in string.gmatch(modifiedText, "[^&]+") do
							table.insert(lines, line)
						end
						for line_index, line in ipairs(lines) do 
							if command_stop then 
								command_stop = false 
								isActiveCommand = false
								if isMonetLoader() and settings.general.mobile_stop_button then
									CommandStopWindow[0] = false
								end
								sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
								return 
							end
							if wait_tag then
								for tag, replacement in pairs(tagReplacements) do
									if line:find("{" .. tag .. "}") then
										local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
										if success then
											line = result
										end
									end
								end
								if line == "{pause}" then
									sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. command.cmd .. ' поставлена на паузу!', message_color)
									command_pause = true
									CommandPauseWindow[0] = true
									while command_pause do
										wait(0)
									end
									if not command_stop then
										sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. command.cmd, message_color)	
									end					
								else
									sampSendChat(line)
									if debug_mode then sampAddChatMessage('[Arizona Helper DEBUG] SEND: ' .. line, message_color) end	
									wait(command.waiting * 1000)
								end
							end
							if not wait_tag then
								if line == '{show_medcard_menu}' then
									wait_tag = true
								end
							end
						end
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
					end)
				end
			end
			if not command_find then
				sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для выдачи мед.карты отсутствует либо отключён!', message_color)
				sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
			end
			MedCardMenu[0] = false
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return ReceptMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##recept", ReceptMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.CenterText(u8'Количество рецептов для выдачи:')
		imgui.PushItemWidth(250 * settings.general.custom_dpi)
		imgui.SliderInt('', recepts, 1, 5)
		imgui.Separator()
		if imgui.Button(fa.CAPSULES..u8" Выдать рецепты" , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			local command_find = false
			for _, command in ipairs(settings.commands) do
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
						isActiveCommand = true
						command_pause = false
						if modifiedText:find('&.+&') then
							if isMonetLoader() and settings.general.mobile_stop_button then
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
								CommandStopWindow[0] = true
							elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
							else
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
							end
						end
						local lines = {}
						for line in string.gmatch(modifiedText, "[^&]+") do
							table.insert(lines, line)
						end
						for line_index, line in ipairs(lines) do 
							if command_stop then 
								command_stop = false 
								isActiveCommand = false
								if isMonetLoader() and settings.general.mobile_stop_button then
									CommandStopWindow[0] = false
								end
								sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
								return 
							end
							if wait_tag then
								for tag, replacement in pairs(tagReplacements) do
									if line:find("{" .. tag .. "}") then
										local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
										if success then
											line = result
										end
									end
								end
								if line == "{pause}" then
									sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. command.cmd .. ' поставлена на паузу!', message_color)
									command_pause = true
									CommandPauseWindow[0] = true
									while command_pause do
										wait(0)
									end
									if not command_stop then
										sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. command.cmd, message_color)	
									end					
								else
									sampSendChat(line)
									if debug_mode then sampAddChatMessage('[Arizona Helper DEBUG] SEND: ' .. line, message_color) end	
									wait(command.waiting * 1000)
								end
							end
							if not wait_tag then
								if line == '{show_recept_menu}' then
									wait_tag = true
								end
							end
						end
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
					end)
				end
			end
			if not command_find then
				sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для выдачи рецептов отсутствует либо отключён!', message_color)
				sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
			end
			ReceptMenu[0] = false
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return AntibiotikMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##ant", AntibiotikMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		imgui.CenterText(u8'Количество антибиотиков для выдачи:')
		imgui.PushItemWidth(250 * settings.general.custom_dpi)
		imgui.SliderInt('', antibiotiks, 1, 20)
		imgui.Separator()
		if imgui.Button(fa.CAPSULES..u8" Выдать антибиотики" , imgui.ImVec2(imgui.GetMiddleButtonX(1), 0)) then
			local command_find = false
			for _, command in ipairs(settings.commands) do
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
						isActiveCommand = true
						command_pause = false
						if modifiedText:find('&.+&') then
							if isMonetLoader() and settings.general.mobile_stop_button then
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите кнопку внизу экрана', message_color)
								CommandStopWindow[0] = true
							elseif not isMonetLoader() and hotkey_no_errors and settings.general.bind_command_stop and settings.general.use_binds then
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop {ffffff}или нажмите ' .. message_color_hex .. getNameKeysFrom(settings.general.bind_command_stop), message_color)
							else
								sampAddChatMessage('[Arizona Helper] {ffffff}Чтобы остановить отыгровку команды используйте ' .. message_color_hex .. '/stop', message_color)
							end
						end
						local lines = {}
						for line in string.gmatch(modifiedText, "[^&]+") do
							table.insert(lines, line)
						end
						for line_index, line in ipairs(lines) do 
							if command_stop then 
								command_stop = false 
								isActiveCommand = false
								if isMonetLoader() and settings.general.mobile_stop_button then
									CommandStopWindow[0] = false
								end
								sampAddChatMessage('[Arizona Helper] {ffffff}Отыгровка команды /' .. command.cmd .. " успешно остановлена!", message_color) 
								return 
							end
							if wait_tag then
								for tag, replacement in pairs(tagReplacements) do
									if line:find("{" .. tag .. "}") then
										local success, result = pcall(string.gsub, line, "{" .. tag .. "}", replacement())
										if success then
											line = result
										end
									end
								end
								if line == "{pause}" then
									sampAddChatMessage('[Arizona Helper] {ffffff}Команда /' .. command.cmd .. ' поставлена на паузу!', message_color)
									command_pause = true
									CommandPauseWindow[0] = true
									while command_pause do
										wait(0)
									end
									if not command_stop then
										sampAddChatMessage('[Arizona Helper] {ffffff}Продолжаю отыгровку команды /' .. command.cmd, message_color)	
									end					
								else
									sampSendChat(line)
									if debug_mode then sampAddChatMessage('[Arizona Helper DEBUG] SEND: ' .. line, message_color) end	
									wait(command.waiting * 1000)
								end
							end
							if not wait_tag then
								if line == '{show_ant_menu}' then
									wait_tag = true
								end
							end
						end
						isActiveCommand = false
						if isMonetLoader() and settings.general.mobile_stop_button then
							CommandStopWindow[0] = false
						end
					end)
				end
			end
			if not command_find then
				sampAddChatMessage('[Arizona Helper] {ffffff}Бинд для выдачи антибиотиков отсутствует либо отключён!', message_color)
				sampAddChatMessage('[Arizona Helper] {ffffff}Попробуйте сбросить настройки хелпера!', message_color)
			end
			AntibiotikMenu[0] = false
		end
		imgui.End()
    end
)
imgui.OnFrame(
    function() return FastHealMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 8.5, sizeY / 1.9), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(fa.HOSPITAL.." Arizona Helper " .. fa.HOSPITAL .. "##fast_heal", FastHealMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoTitleBar +  imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if imgui.Button(fa.KIT_MEDICAL..u8' Вылечить '..sampGetPlayerNickname(heal_in_chat.player_id)) then
			find_and_use_command("/heal {arg_id}", heal_in_chat.player_id)
			heal_in_chat.bool = false
			heal_in_chat.player_id = nil
			FastHealMenu[0] = false
		end
		imgui.End()
    end
)

-- MJ
imgui.OnFrame(
    function() return PatroolMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.patrool_menu.x, settings.windows_pos.patrool_menu.y), imgui.Cond.FirstUseEver)
		--imgui.SetNextWindowSize(imgui.ImVec2(225 * settings.general.custom_dpi, 113 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(getHelperIcon() .. u8" Arizona Helper " .. getHelperIcon() .. '##patrool_info_menu', _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
		if patrool.active then
			imgui.Text(fa.CLOCK .. u8(' Время патрулирования: ') .. u8(binderTags.get_patrool_time()))
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' Ваше состояние: ') .. u8(binderTags.get_patrool_code()))
			imgui.SameLine()
			if imgui.SmallButton(fa.GEAR) then
				imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##patrool_select_code'))
			end
			imgui.Separator()
			if imgui.Button(fa.WALKIE_TALKIE .. u8(' Доклад'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function ()
					sampSendChat('/r ' .. binderTags.my_doklad_nick() .. ' на CONTROL.')
					wait(1500)
					sampSendChat('/r Продолжаю патруль, нахожусь в районе ' .. binderTags.get_area() .. " (" .. binderTags.get_square() .. ').')
					wait(1500)
					if binderTags.get_car_units() ~= 'Нету' then
						sampSendChat('/r Патрулирую уже ' .. binderTags.get_patrool_format_time() .. ' в составе юнита ' .. binderTags.get_car_units() .. ', состояние ' .. binderTags.get_patrool_code() .. '.')
					else
						sampSendChat('/r Патрулирую уже ' .. binderTags.get_patrool_format_time() .. ', состояние ' .. binderTags.get_patrool_code() .. '.')
					end
				end)
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_STOP .. u8(' Завершить'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function ()
					PatroolMenu[0] = false
					patrool.active = false
					sampSendChat('/r ' .. binderTags.my_doklad_nick() .. ' на CONTROL.')
					wait(1500)
					sampSendChat('/r Завершаю патруль, освобождаю маркировку ' .. binderTags.get_patrool_mark() .. ', состояние ' .. binderTags.get_patrool_code())
					wait(1500)
					sampSendChat('/r Патрулировал ' .. binderTags.get_patrool_format_time(), -1)
					patrool.time = 0
					patrool.start_time = 0
					patrool.current_time = 0
					patrool.code = 'CODE4'
					ComboPatroolCode[0] = 5
					wait(1500)
					sampSendChat('/delvdesc')
				end)
			end
		else
			player.HideCursor = false	
			imgui.CenterText(u8('Настройка данных перед началом патруля:'))
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' Ваша маркировка: '))
			imgui.SameLine()
			imgui.PushItemWidth(150 * settings.general.custom_dpi)
			if imgui.Combo('##patrool_mark', ComboPatroolMark, ImItemsPatroolMark, #combo_patrool_mark_list) then
				patrool.mark = combo_patrool_mark_list[ComboPatroolMark[0] + 1] 
			end
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' Ваше состояние: '))
			imgui.SameLine()
			imgui.PushItemWidth(150 * settings.general.custom_dpi)
			if imgui.Combo('##patrool_code', ComboPatroolCode, ImItemsPatroolCode, #combo_patrool_code_list) then
				patrool.code = combo_patrool_code_list[ComboPatroolCode[0] + 1]
			end
			imgui.Separator()
			imgui.Text(fa.CIRCLE_INFO .. u8(' Напарники: ') .. u8(binderTags.get_car_units()))
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена ', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				PatroolMenu[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.WALKIE_TALKIE .. u8' Начать патруль', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				patrool.time = 0
				patrool.start_time = os.time()
				patrool.active = true
				lua_thread.create(function ()
					sampSendChat('/r ' .. binderTags.my_doklad_nick() .. ' на CONTROL.')
					wait(1500)
					sampSendChat('/r Начинаю патруль, нахожусь в районе ' .. binderTags.get_area() .. " (" .. binderTags.get_square() .. ').')
					wait(1500)
					if binderTags.get_car_units() ~= 'Нету' then
						sampSendChat('/r Занимаю маркировку ' .. binderTags.get_patrool_mark() .. ', нахожусь в составе юнита ' .. binderTags.get_car_units() .. ', состояние ' .. binderTags.get_patrool_code() .. '.')
					else
						sampSendChat('/r Занимаю маркировку ' .. binderTags.get_patrool_mark() .. ', состояние ' .. binderTags.get_patrool_code() .. '.')
					end
					wait(1500)
					sampSendChat('/vdesc ' .. binderTags.get_patrool_mark())
				end)
				imgui.CloseCurrentPopup()
			end
		end
		if imgui.BeginPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##patrool_select_code'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
			change_dpi()
			player.HideCursor = false 
			imgui.PushItemWidth(150 * settings.general.custom_dpi)
			if imgui.Combo('##patrool_code', ComboPatroolCode, ImItemsPatroolCode, #combo_patrool_code_list) then
				patrool.code = combo_patrool_code_list[ComboPatroolCode[0] + 1]
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

-- MD
imgui.OnFrame(
    function() return PostMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(settings.windows_pos.patrool_menu.x, settings.windows_pos.patrool_menu.y), imgui.Cond.FirstUseEver)
		--imgui.SetNextWindowSize(imgui.ImVec2(225 * settings.general.custom_dpi, 113 * settings.general.custom_dpi), imgui.Cond.FirstUseEver)
		imgui.Begin(getHelperIcon() .. u8" Arizona Helper " .. getHelperIcon() .. '##post_info_menu', PostMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.AlwaysAutoResize )
		change_dpi()
		if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
		if patrool.active then
			imgui.Text(fa.MAP_LOCATION_DOT .. u8(' Пост: ') .. u8(binderTags.get_patrool_name()))
			imgui.Text(fa.CLOCK .. u8(' Время на посту: ') .. u8(binderTags.get_patrool_time()))
			imgui.Text(fa.CIRCLE_INFO .. u8(' Состояние: ') .. u8(binderTags.get_patrool_code()))
			imgui.SameLine()
			if imgui.SmallButton(fa.GEAR) then
				imgui.OpenPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##post_select_code'))
			end
			imgui.Separator()
			if imgui.Button(fa.WALKIE_TALKIE .. u8(' Доклад##post'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function ()
					sampSendChat('/r ' .. binderTags.my_doklad_nick() .. ' на CONTROL. Пост: ' .. binderTags.get_patrool_name() .. ', состояние ' .. binderTags.get_patrool_code() .. '.')
					wait(1500)
					sampSendChat('/r Нахожусь на посту уже ' .. binderTags.get_patrool_format_time(), -1)
				end)
			end
			imgui.SameLine()
			if imgui.Button(fa.CIRCLE_STOP .. u8(' Конец##post'), imgui.ImVec2(100 * settings.general.custom_dpi, 25 * settings.general.custom_dpi)) then
				lua_thread.create(function()
					PostMenu[0] = false
					patrool.active = false
					sampSendChat('/r ' .. binderTags.my_doklad_nick() .. ' на CONTROL. Пост: ' .. binderTags.get_patrool_name() .. ', состояние ' .. binderTags.get_patrool_code() .. '.')
					wait(1500)
					sampSendChat('/r Освобождаю пост! Простоял' .. binderTags.sex() .. ' на посту: ' .. binderTags.get_patrool_format_time() .. '.', -1)
					patrool.time = 0
					patrool.start_time = 0
					patrool.current_time = 0
					patrool.code = 'CODE4'
					ComboPatroolCode[0] = 5
				end)
			end
		else
			player.HideCursor = false	
			imgui.PushItemWidth(200 * settings.general.custom_dpi)
			if imgui.InputTextWithHint(u8'##post_name', u8('Укажите название вашего поста'), input, 256) then
				patrool.name = u8:decode(ffi.string(input))
			end
			imgui.Separator()
			if imgui.Button(fa.CIRCLE_XMARK .. u8' Отмена##post', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				PostMenu[0] = false
			end
			imgui.SameLine()
			if imgui.Button(fa.WALKIE_TALKIE .. u8' Заступить##post', imgui.ImVec2(imgui.GetMiddleButtonX(2), 25 * settings.general.custom_dpi)) then
				patrool.time = 0
				patrool.start_time = os.time()
				patrool.active = true
				sampSendChat('/r ' .. binderTags.my_doklad_nick() .. ' на CONTROL. Заступаю на пост ' .. binderTags.get_patrool_name() .. ', состояние ' .. binderTags.get_patrool_code() .. '.')
				imgui.CloseCurrentPopup()
			end
		end
		--imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		if imgui.BeginPopup(fa.BUILDING_SHIELD .. u8(' Arizona Helper##post_select_code'), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  ) then
			change_dpi()
			player.HideCursor = false 
			imgui.PushItemWidth(150 * settings.general.custom_dpi)
			if imgui.Combo('##post_code', ComboPatroolCode, ImItemsPatroolCode, #combo_patrool_code_list) then
				patrool.code = combo_patrool_code_list[ComboPatroolCode[0] + 1]
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
    function() return ProbivMenu[0] end,
    function(player)
		imgui.SetNextWindowPos(imgui.ImVec2(sizeX / 2, sizeY / 2), imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
		imgui.Begin(getHelperIcon() .." Arizona Helper " .. getHelperIcon() .. '##probiv', ProbivMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize  + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.AlwaysAutoResize)
		change_dpi()
		
		if probiv ~= nil then
			if imgui.BeginChild('##probiv_2', imgui.ImVec2(400 * settings.general.custom_dpi, 350 * settings.general.custom_dpi), true) then
				imgui.CenterText(u8" Игрок " .. u8(u8:decode(ffi.string(input))) .. " [UID " .. tostring(probiv.id or 'nil') .. u8"] из сервера " .. (probiv.server and probiv.server.name and probiv.server.id and (u8(probiv.server.name) .. " (" .. tostring(probiv.server.id) .. ")") or "nil"))
				imgui.Separator()
				imgui.Text(fa.SIGNAL .. u8(' Уровень: ') ..  (probiv.level and probiv.level.level or "nil") .. ' (' .. (probiv.level and probiv.level.current_exp or 0) .. '/' .. (probiv.level and probiv.level.next_exp or 0) .. ' exp)')
				imgui.Text(fa.CIRCLE .. u8' Отыграно всего: ' .. (probiv.hours_played or "nil") .. u8" часов")
				imgui.Text(fa.CROWN .. u8(' VIP статус: ') ..  (probiv.vip_info and u8(probiv.vip_info.level) or u8"Отсуствует"))
				imgui.Text(fa.VAULT .. u8(' AZ монеты: ') .. comma_value(probiv.money and probiv.money.donate_currency or "nil"))
				imgui.Text(fa.PHONE .. u8' Номер телефона: ' .. u8(probiv.phone_number or "nil"))			
				imgui.SameLine()
				if imgui.SmallButton(fa.PHONE .. '##probiv_call') then
					sampSendChat("/call "..probiv.phone_number)
				end
				imgui.SameLine()
				if imgui.SmallButton(fa.COMMENT .. '##probiv_sms') then
					sampSendChat("/sms "..probiv.phone_number)
				end
				imgui.Text(fa.STAR .. u8(' Уровень розыска: ') .. comma_value(probiv.wanted_level or "nil"))
				imgui.Text(fa.VAULT .. u8(' Варны: ') .. ((probiv.warnings .. "/3") or "nil"))
				imgui.Separator()
				imgui.CenterText(fa.MONEY_CHECK_DOLLAR .. u8(' Деньги ') .. fa.MONEY_CHECK_DOLLAR)
				imgui.Text(fa.HAND_HOLDING_DOLLAR .. u8(' На руках: $') .. comma_value(probiv.money and probiv.money.hand or "nil"))
				imgui.Text(fa.LANDMARK .. u8(' На банковском счету: $') .. comma_value(probiv.money and probiv.money.bank or "nil"))
				imgui.Text(fa.VAULT .. u8(' На депозите в банке: $') .. comma_value(probiv.money and probiv.money.deposit or "nil"))
				local function get_personal_money() 
					local money = 0
					if probiv.money and probiv.money.personal_accounts then
						for i = 1, 6 do
							local key = "bankAccount" .. i
							local money2 = probiv.money.personal_accounts[key]
							if money2 and money2 ~= "-1" then
								money = money + money2
							end
						end
						return comma_value(money)
					end
					return 0
				end
				imgui.Text(fa.VAULT .. u8(' На личных счетах в банке: $') .. (get_personal_money()))
				imgui.Separator()
				imgui.CenterText(fa.BUILDING .. u8(' Организация ') .. fa.BUILDING)
				imgui.Text(fa.CIRCLE .. u8" Название: " .. u8(probiv.organization and probiv.organization.name or "Нету"))
				imgui.Text(fa.CIRCLE .. u8" Должность: " .. u8(probiv.organization and probiv.organization.rank or "Нету"))
				imgui.Separator()
				imgui.CenterText(fa.HOUSE .. u8(' Личные дома ') .. fa.HOUSE)
				if probiv.property and probiv.property.houses and #probiv.property.houses > 0 then
					local house_ids = {}
					for i, house in ipairs(probiv.property.houses) do
						table.insert(house_ids, tostring(house.id))
					end
					imgui.TextWrapped(fa.CIRCLE .. u8(' ') .. table.concat(house_ids, ", "))
				else
					imgui.Text(fa.CIRCLE .. u8(' Нет домов'))
				end
				imgui.Separator()
				imgui.CenterText(fa.BUSINESS_TIME .. u8(' Личные бизнесы ') .. fa.BUSINESS_TIME)
				if probiv.property and probiv.property.businesses and #probiv.property.businesses > 0 then
					local business_ids = {}
					for i, biz in ipairs(probiv.property.businesses) do
						table.insert(business_ids, tostring(biz.id))
					end
					imgui.TextWrapped(fa.CIRCLE .. u8(' ') .. table.concat(business_ids, ", "))
				else
					imgui.Text(fa.CIRCLE .. u8(' Нет бизнесов'))
				end
				imgui.EndChild()
			end
		else
			if imgui.BeginChild('##probiv_1', imgui.ImVec2(300 * settings.general.custom_dpi, 205 * settings.general.custom_dpi), true) then
				imgui.CenterText(fa.KEY .. u8(' API key для пробива'))
				imgui.PushItemWidth(290 * settings.general.custom_dpi)
				if imgui.InputText(u8'##probiv_apikey', input_probiv_key, 256) then
					settings.general.probiv_api_key = u8:decode(ffi.string(input_probiv_key))
					save_settings()
				end
				imgui.Separator()
				imgui.CenterText(u8('Получение API ключа - БЕСПЛАТНОЕ!'))
				imgui.CenterText(u8('Отправьте боту команду /new'))
				if imgui.CenterButton(u8('https://t.me/DepsAPI_bot')) then
					openLink('https://t.me/DepsAPI_bot')
				end
				imgui.CenterText(fa.USER .. u8(' Ник игрока для пробива'))
				imgui.PushItemWidth(290 * settings.general.custom_dpi)
				imgui.InputText(u8'##probiv_nick', input, 256)
				imgui.Separator()
				if imgui.CenterButton(fa.CIRCLE_ARROW_RIGHT .. u8(' Узнать инфу об игроке ') .. fa.CIRCLE_ARROW_LEFT) then
					getPlayerInfo(u8:decode(ffi.string(input)), getARZServerNumber())
				end
				imgui.EndChild()
			end
		end
		imgui.End()
    end
)

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
function imgui.Tooltip(text)
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

function main()

	if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(0) end 

	if settings.general.fraction_mode == '' then
		repeat wait(0) until sampIsLocalPlayerSpawned()
		InititalWindow[0] = true
		return
	end

	load_module('commands')
	load_module('notes')
	load_module('rpgun')
	load_module('arz_veh')

	if (settings.general.fraction_mode == 'police' or settings.general.fraction_mode == 'fbi') then
		load_module('smart_uk')
		load_module('smart_pdd')
		if settings.general.use_taser_menu and isMonetLoader() then
			TaserWindow[0] = true
		end	
		if settings.general.mobile_meg_button and isMonetLoader() then
			MegafonWindow[0] = true
		end	
	elseif (settings.general.fraction_mode == 'prison') then
		load_module('smart_rptp')
		if settings.general.use_taser_menu and isMonetLoader() then
			TaserWindow[0] = true
		end	
	end
	
	initialize_guns()
	initialize_commands()

	if not isMonetLoader() then loadHotkeys() end

	welcome_message()
	
	check_update()

	while true do
		wait(0)

		if (isMonetLoader() and settings.general.mobile_fastmenu_button) then
			if tonumber(#get_players()) > 0 and not FastMenu[0] and not FastMenuPlayers[0] then
				FastMenuButton[0] = true
			else
				FastMenuButton[0] = false
			end
		end

		if (isMode('police') or isMode('fbi') or isMode('army') or isMode('prison')) then
			if patrool.active then
				patrool.time = os.difftime(os.time(), patrool.start_time)
				
			end
			
		end

		

		if (modules.rpgun.data.nowGun ~= getCurrentCharWeapon(PLAYER_PED)) then
            modules.rpgun.data.oldGun = modules.rpgun.data.nowGun
            modules.rpgun.data.nowGun = getCurrentCharWeapon(PLAYER_PED)
            if not isExistsWeapon(modules.rpgun.data.oldGun) then
                handleNewWeapon(modules.rpgun.data.oldGun)
            elseif not isExistsWeapon(modules.rpgun.data.nowGun) then
                handleNewWeapon(modules.rpgun.data.nowGun)
            end
            processWeaponChange(modules.rpgun.data.oldGun, modules.rpgun.data.nowGun)
        end


		if (settings.general.auto_notify_payday) then
			local currentMinute = os.date("%M", os.time())
			local currentSecond = os.date("%S", os.time())
			if ((currentMinute == "55" or currentMinute == "25") and currentSecond == "00") then
				if sampGetPlayerColor(binderTags.my_id()) == 368966908 then
					sampAddChatMessage('[Arizona Helper] {ffffff}Через 5 минут будет PAYDAY. Наденьте форму чтобы не пропустить зарплату!', message_color)
					playNotifySound()
					wait(1000)
				end
			end
		end

		
		
	end

end

-- PieMenu (PC)
function importPieMenuLibnary()
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
return defaultPieMenu]])
		file:close()
	end
end
if (not isMonetLoader()) then
	if (not doesFileExist(getWorkingDirectory():gsub('\\','/') .. "/lib/mimgui_piemenu.lua")) then 
		importPieMenuLibnary()
	end
	local pie = require("mimgui_piemenu")
	FastPieMenu[0] = true
	imgui.OnFrame(
		function() return FastPieMenu[0] end,
		function(player)
			if not isMonetLoader() and not sampIsChatInputActive() and not sampIsDialogActive() and not isSampfuncsConsoleActive() then player.HideCursor = true else player.HideCursor = false end
			imgui.Begin('##FastPieMenu', FastPieMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoBackground + imgui.WindowFlags.NoTitleBar)
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
					-- if pie.BeginPieMenu('Test 4') then 
						
					-- 	pie.EndPieMenu()
					-- end
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
end

function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit and not reload_script then
		if InfraredVision then setInfraredVision(false) end
		if NightVision then setNightVision(false) end
		playNotifySound()
		sampAddChatMessage('[Arizona Helper] {ffffff}Произошла неизвестная ошибка, хелпер приостановил свою работу!', message_color)
		if not isMonetLoader() then 
			sampAddChatMessage('[Arizona Helper] {ffffff}Используйте ' .. message_color_hex .. 'CTRL {ffffff}+ ' .. message_color_hex .. 'R {ffffff}чтобы перезапустить хелпер.', message_color)
		end
    end
end
