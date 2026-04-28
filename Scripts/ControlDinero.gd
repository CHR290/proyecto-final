extends HBoxContainer

@export var digit_spritesheet: Texture2D
@onready var contenedor_sombras = $Control/sombras
@onready var contenedor_digitos = $digitos
var digit_w: int = 6
var digit_h: int = 12
var color_sombra: Color = Color(0, 0, 0, 0.6) 
var desplazamiento_sombra: Vector2 = Vector2(8, 4) 
func _ready():
	Global.money_changed.connect(_update_money_display)
	contenedor_sombras.modulate = color_sombra
	contenedor_sombras.position = desplazamiento_sombra
	_update_money_display()

func _update_money_display():
	for child in contenedor_digitos.get_children():
		child.queue_free()	
	for child in contenedor_sombras.get_children():
		child.queue_free()	
	# Se convierte el número a texto para recorrer cada dígito
	var money_string: String
	match Global.pago_activo:
		0:
			money_string = str(Global.dinero_efectivo)
		1:
			money_string = str(Global.dinero_banco)
		2:
			money_string = str(Global.dinero_banco)
	#Se crea un Sprite por cada número
	for char_digit in money_string:
		var digit_val = int(char_digit)
		var texture_recortada = get_digit_texture(digit_val)
		
		var rect_sombra = _create_rect_digit(texture_recortada)
		contenedor_sombras.add_child(rect_sombra)
		
		var rect_real = _create_rect_digit(texture_recortada)
		contenedor_digitos.add_child(rect_real)
	queue_sort()
	match Global.pago_activo:
		0:
			contenedor_digitos.modulate = Color8(104,175,85,255)
		1:
			contenedor_digitos.modulate = Color8(50,117,193,255)
		2:
			contenedor_digitos.modulate = Color8(171,71,64,255)

func _create_rect_digit(tex: Texture2D) -> TextureRect:
	var rect = TextureRect.new()
	rect.texture = tex
	# Configuraciones para Pixel Art
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	# Aplicacion de la escala
	rect.custom_minimum_size = Vector2(digit_w * 4, digit_h * 4)
	return rect

func get_digit_texture(digit: int) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = digit_spritesheet
	atlas.region = Rect2(digit * digit_w, 0, digit_w, digit_h)
	return atlas
