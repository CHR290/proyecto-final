extends HBoxContainer
@export_group("velocidad del tiempo")
var speed: int = 0:
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
@export var indicador: TextureRect
const MONTHS = ["ENE", "FEB", "MAR", "ABR", "MAY", "JUN", "JUL", "AGO", "SEP", "OCT", "NOV", "DIC"]
var hours: int = 12
var minutes: int = 00
var day: int = 1
var month: int = 10
var year: int = 2025
var weekday: int = 3

# Función para obtener la imagen de una letra
func get_char_texture(character: String) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = alphabet_spritesheet	
	# se convierten las letras a mayúsculas 
	var index = character.to_upper().unicode_at(0) - 65	
	atlas.region = Rect2(index * char_width_month, 0, char_width_month, char_height_month)
	return atlas
func _ready():
	Global.time_changed.connect(update_clock_ui)
	var y_inicial = indicador.posiciones[weekday - 1]
	indicador.position.y = y_inicial
	update_clock_ui()
# Función para obtener la imagen de un número
func get_digit_texture(digit: int) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = spritesheet
	# Esto calcula el cuadro de recorte según el número
	atlas.region = Rect2(digit * char_width, 0, char_width, char_height)
	return atlas
# Avanza 1 minuto de juego

func update_clock_ui():
	# Esto extrae los dígitos
	var digits = [
		int(Global.hours / 10.0),
		Global.hours % 10,
		int(Global.minutes / 10.0),
		Global.minutes % 10,
		int(Global.day / 10.0),
		Global.day % 10
	]
	$"/root/InterfazPrincipal/indicador_semana".mover_indicador(Global.weekday - 1)
	var month_name = MONTHS[Global.month - 1]	
	# Asignar las texturas a los TextureRects
	$decena_hora.texture = get_digit_texture(digits[0])
	$unidad_hora.texture = get_digit_texture(digits[1])
	$decena_minuto.texture = get_digit_texture(digits[2])
	$unidad_minuto.texture = get_digit_texture(digits[3])
	$"/root/InterfazPrincipal/Calendario/dia/decena_dia".texture = get_digit_texture(digits[4])
	$"/root/InterfazPrincipal/Calendario/dia/unidad_dia".texture = get_digit_texture(digits[5])
	$"/root/InterfazPrincipal/Calendario/mes/letra_uno".texture = get_char_texture(month_name[0])
	$"/root/InterfazPrincipal/Calendario/mes/letra_dos".texture = get_char_texture(month_name[1])
	$"/root/InterfazPrincipal/Calendario/mes/letra_tres".texture = get_char_texture(month_name[2])
