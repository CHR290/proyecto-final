
extends TextureRect
#lo mismo que AnimarBoton pero sin agrandarse con el mouse, solo flotando
@onready var original_scale = scale
@onready var original_pos = position
func _ready():
	pivot_offset = size / 2
	animar_flotado()
func animar_flotado():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", original_pos.y - 3, 1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", original_pos.y, 1).set_trans(Tween.TRANS_SINE)


func _on_button_up() -> void:
	pass # Replace with function body.
