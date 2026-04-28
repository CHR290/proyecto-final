extends TextureButton
class_name BotonAnimado
@export var menu: int = 0
@onready var original_scale = scale
@onready var original_pos = position

func _ready():
	pivot_offset = size / 2
	#Se conectan las señales de entrada al Script
	self.mouse_entered.connect(_on_mouse_entered)	
	self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)
	self.pressed.connect(_on_pressed)
	animar_flotado()
# Esta función hace que el botón se mueva
func animar_flotado():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", original_pos.y - 2, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", original_pos.y, 1.5).set_trans(Tween.TRANS_SINE)
	
# estas dos funciones hacen que el boton se agrande mientras el mouse esta encima
func _on_mouse_entered():
	create_tween().tween_property(self, "scale", original_scale * 1.1, 0.1)
func _on_mouse_exited():
	create_tween().tween_property(self, "scale", original_scale, 0.1)

#estas dos hacen que cambie de tamaño cuando se presiona
func _on_button_down():
	create_tween().tween_property(self, "scale", original_scale * 0.93, 0.05)
func _on_button_up():
	var target_scale = original_scale * 1.1 if is_hovered() else original_scale
	create_tween().tween_property(self, "scale", target_scale, 0.05)

func _on_pressed():
	Global.gestionar_menu(menu)
