extends Control

var offset := Vector2(-80, -105) 

func _ready() -> void:
	self.hide()
func _process(_delta: float) -> void:
	global_position = get_viewport().get_mouse_position() + offset


func _on_boton_estado_mouse_entered() -> void:
	self.show()
	print("felicidad: ", Global.felicidad, " salud: ", Global.salud, " cortisol: ", Global.cortisol)
	print("multiplicadores - felicidad: ", Global.multiplicador_felicidad, " salud: ", Global.multiplicador_salud, " cortisol: ", Global.multiplicador_cortisol)
	actualizar_barras()


func _on_boton_estado_mouse_exited() -> void:
	self.hide()

func actualizar_barras() -> void:
	$felicidad.value = Global.felicidad
	$salud.value = Global.salud
	$cortisol.value = Global.cortisol