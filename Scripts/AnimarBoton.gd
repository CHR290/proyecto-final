# BotonAnimado.gd
extends TextureButton
class_name BotonAnimado # <--- Esto permite que otros scripts hereden de este

@onready var original_scale = scale
@onready var original_pos = position

func _ready():
	pivot_offset = size / 2
	# Conectamos las señales por código para no tener que hacerlo a mano cada vez
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	animar_flotado()

func animar_flotado():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", original_pos.y - 5, 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:y", original_pos.y, 1.5).set_trans(Tween.TRANS_SINE)

func _on_mouse_entered():
	create_tween().tween_property(self, "scale", original_scale * 1.1, 0.1)

func _on_mouse_exited():
	create_tween().tween_property(self, "scale", original_scale, 0.1)