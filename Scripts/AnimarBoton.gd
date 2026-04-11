extends TextureButton
class_name BotonAnimado # Esto permite que otros scripts hereden de este

@onready var original_scale = scale
@onready var original_pos = position

func _ready():
	pivot_offset = size / 2
	# Se conectan las señales de entrada al Script
	if not mouse_entered.is_connected(_on_mouse_entered):
		self.mouse_entered.connect(_on_mouse_entered)	
	if not mouse_exited.is_connected(_on_mouse_exited):
		self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)
	animar_flotado()
# Esta función hace que el botón flote suavemente
func animar_flotado():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", original_pos.y - 2, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", original_pos.y, 1.5).set_trans(Tween.TRANS_SINE)
# estas dos funciones hacen que el botn se agrande mientras el mouse esta encima
func _on_mouse_entered():
	create_tween().tween_property(self, "scale", original_scale * 1.1, 0.1)
func _on_mouse_exited():
	create_tween().tween_property(self, "scale", original_scale, 0.1)
func _on_button_down():
	create_tween().tween_property(self, "scale", original_scale * 0.9, 0.05)
func _on_button_up():
	var target_scale = original_scale * 1.1 if is_hovered() else original_scale
	create_tween().tween_property(self, "scale", target_scale, 0.05)
