extends HBoxContainer
@export_group("velocidad del tiempo")
@export_range(0, 4) var speed: int = 1:
	set(value):
		speed = value
@export_group("Configuración numeros")
@export var spritesheet: Texture2D # La imagen que contiene los números del reloj
@export var char_width: int = 6  # Ancho de cada número en píxeles
@export var char_height: int = 12 # Alto de cada número en píxeles
@export_group("Configuración Letras")
@export var alphabet_spritesheet: Texture2D# La imagen que contiene las letras del abecedario
@export var char_width_month: int = 7
@export var char_height_month: int = 7
const MONTHS = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"]
var hours: int = 12
var minutes: int = 00
var day: int = 1
var month: int = 2
var year: int = 2025
var weekday: int = 0 
var time_accumulator: float = 0.0
# Función para obtener la imagen de una letra
func get_char_texture(character: String) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = alphabet_spritesheet	
	# se convierten las letras a mayúsculas 
	var index = character.to_upper().unicode_at(0) - 65	
	atlas.region = Rect2(index * char_width_month, 0, char_width_month, char_height_month)
	return atlas
func _ready():
	update_clock_ui()
# Función para obtener la imagen de un número
func get_digit_texture(digit: int) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = spritesheet
	# Esto calcula el cuadro de recorte según el número
	atlas.region = Rect2(digit * char_width, 0, char_width, char_height)
	return atlas
# Avanza 1 minuto de juego
func _process(delta):
	if speed == 0:
		return
	
	# Definimos cuántos minutos de juego pasan por cada segundo real
	var minutes_per_second: float = 0.0
	match speed:
		1: minutes_per_second = 1.0     # 1 min/seg
		2: minutes_per_second = 10.0    # 10 min/seg
		3: minutes_per_second = 60.0    # 1 hora/seg
		4: minutes_per_second = 1440.0  # 1 día/seg
	
	# Acumulamos el tiempo transcurrido
	time_accumulator += delta * minutes_per_second
	
	# Mientras el acumulador tenga al menos 1 minuto entero...
	while time_accumulator >= 1.0:
		advance_time(0, 0, 0, 1) # Avanzamos de 1 en 1 minuto
		time_accumulator -= 1.0

func advance_time(mo: int, d: int, h: int, m: int):
	minutes += m
	while minutes >= 60:
		minutes -= 60
		hours += 1
	hours += h
	while hours >= 24:
		hours -= 24
		day += 1
		weekday += 1
		if weekday > 6:
			weekday = 0
	day += d
	$"/root/InterfazPrincipal/indicador_semana".move_to_day(weekday)
	if month == 2:
		while day > 28:
			day -= 28
			month += 1
	elif month in [4, 6, 9, 11]:
		while day > 30:
			day -= 30
			month += 1
			print(month)
	else:		
		while day > 31:
			day -= 31
			month += 1	
	
	month += mo
	while month > 12:
		month -= 12
		year += 1

	update_clock_ui()

func update_clock_ui():
	# Esto extrae los dígitos
	var digits = [
		int(hours / 10.0),
		hours % 10,
		int(minutes / 10.0),
		minutes % 10,
		int(day / 10.0),
		day % 10
	]
	var month_name = MONTHS[month - 1]	
	# Asignamos las texturas a los TextureRects
	$decena_hora.texture = get_digit_texture(digits[0])
	$unidad_hora.texture = get_digit_texture(digits[1])
	$decena_minuto.texture = get_digit_texture(digits[2])
	$unidad_minuto.texture = get_digit_texture(digits[3])
	$"/root/InterfazPrincipal/Calendario/dia/decena_dia".texture = get_digit_texture(digits[4])
	$"/root/InterfazPrincipal/Calendario/dia/unidad_dia".texture = get_digit_texture(digits[5])
	$"/root/InterfazPrincipal/Calendario/mes/letra_uno".texture = get_char_texture(month_name[0])
	$"/root/InterfazPrincipal/Calendario/mes/letra_dos".texture = get_char_texture(month_name[1])
	$"/root/InterfazPrincipal/Calendario/mes/letra_tres".texture = get_char_texture(month_name[2])
