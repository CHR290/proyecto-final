extends TextureRect

@export var day_position: Array[float] = [168, 184, 200, 216, 232, 248, 264] 

var tween: Tween # Variable para guardar la animación actual

# Función para mover el indicador a un día específico 
func move_to_day(dia_index: int):
	dia_index = clamp(dia_index, 0, 6)	
	# Obtenemos la posición Y objetivo
	var y_objetivo = day_position[dia_index]
	if tween and tween.is_running():
		tween.kill()	
	# Creamos la nueva animación
	tween = create_tween()
	# Animamos la propiedad "position:y" desde donde esté ahora hasta la Y objetivo
	tween.tween_property(self, "position:y", y_objetivo, 0)