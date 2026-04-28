extends TextureButton
@export var efectivo: Texture2D
@export var debito: Texture2D
@export var credito: Texture2D
#lo mismo que AnimarBoton pero sin agrandarse con el mouse, solo flotando
@onready var original_scale = scale
@onready var original_pos = position

func _ready():
	cambiar_textura()
	pivot_offset = size / 2
	animar_flotado()
	self.mouse_entered.connect(_on_mouse_entered)	
	self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)
	self.pressed.connect(_on_pressed)

func animar_flotado():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", original_pos.y - 3, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", original_pos.y, 1).set_trans(Tween.TRANS_SINE)

func cambiar_textura():
	match Global.pago_activo:
		0:
			self.texture_normal = efectivo
		1:
			self.texture_normal = debito
		2:
			self.texture_normal = credito
	
func _on_mouse_entered():
	self.self_modulate = Color(1.2,1.2,1.2,1)

func _on_mouse_exited():
	self.self_modulate = Color(1,1,1,1)	

func _on_button_down():
	self.self_modulate = Color(0.8,0.8,0.8,1)

func _on_button_up():
	self.self_modulate = Color(1,1,1,1)

func _on_pressed():
	Global.pago_activo += 1
	if Global.pago_activo == 3:
		Global.pago_activo = 0
	cambiar_textura()
	Global.money_changed.emit()
	
