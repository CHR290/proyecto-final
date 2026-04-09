extends HBoxContainer

@export var spritesheet: Texture2D # La imagen que contiene los números del reloj
@export var char_width: int = 6  # Ancho de cada número en píxeles
@export var char_height: int = 12 # Alto de cada número en píxeles
@onready var timer = $Timer # Referencia al nodo Timer

var hours: int = 12
var minutes: int = 00
var day: int = 1
var month: int = 10
var year: int = 2025
var weekday: int = 1 
var speed: int = 0 # Velocidad a la que avanza el tiempo 
func _ready():
	update_clock_ui()
	timer.timeout.connect(_on_timer_timeout)

# Función para obtener la sub-imagen de un número
func get_digit_texture(digit: int) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = spritesheet
	# Esto calcula el cuadro de recorte según el número
	atlas.region = Rect2(digit * char_width, 0, char_width, char_height)
	return atlas
# Avanza 1 minuto de juego
func _on_timer_timeout():
	if $dos_puntos.self_modulate.a == 1.0:
		$dos_puntos.self_modulate.a = 0.0
	else:
		$dos_puntos.self_modulate.a = 1.0

		match speed:
			0:
				advance_time(0, 0, 0, 0)
			1:
				advance_time(0, 0, 0, 1) # Avanza 1 minuto
			2:
				advance_time(0, 0, 0, 10) # Avanza 10 minutos
			3:
				advance_time(0, 0, 1, 0) # Avanza 1 hora
			4:
				advance_time(0, 1, 0, 0) # Avanza 1 día

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
		if weekday > 7:
			weekday = 1
	day += d
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
	
	# Asignamos las texturas a los TextureRects
	$decena_hora.texture = get_digit_texture(digits[0])
	$unidad_hora.texture = get_digit_texture(digits[1])
	$decena_minuto.texture = get_digit_texture(digits[2])
	$unidad_minuto.texture = get_digit_texture(digits[3])
	$"/root/InterfazPrincipal/calendario/decena_dia".texture = get_digit_texture(digits[4])
	$"/root/InterfazPrincipal/calendario/unidad_dia".texture = get_digit_texture(digits[5])
