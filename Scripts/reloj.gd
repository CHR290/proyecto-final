extends HBoxContainer

@export var spritesheet: Texture2D # La imagen que contiene los números del reloj
@export var char_width: int = 6  # Ancho de cada número en píxeles
@export var char_height: int = 12 # Alto de cada número en píxeles
@onready var timer = $Timer # Referencia al nodo Timer

var hours: int = 22
var minutes: int = 30
var time_flow: bool = false
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
	if time_flow:
		advance_time(0, 1) 
# Función para iniciar el flujo del tiempo 
func start_clock():
	time_flow = true

# Función para detenerlo
func stop_clock():
	time_flow = false

func advance_time(h: int, m: int):
	minutes += m
	while minutes >= 60:
		minutes -= 60
		hours += 1
	hours += h
	while hours >= 24:
		hours -= 24
	update_clock_ui()

func update_clock_ui():
	# Esto extrae los dígitos
	var digits = [
		int(hours / 10.0),
		hours % 10,
		int(minutes / 10.0),
		minutes % 10
	]
	
	# Asignamos las texturas a los TextureRects
	$decena_hora.texture = get_digit_texture(digits[0])
	$unidad_hora.texture = get_digit_texture(digits[1])
	$decena_minuto.texture = get_digit_texture(digits[2])
	$unidad_minuto.texture = get_digit_texture(digits[3])
