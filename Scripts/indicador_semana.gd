extends TextureRect

# --- Configuración de Posiciones ---
var posiciones: Array[float] = [168.0, 184.0, 200.0, 216.0, 232.0, 248.0, 264.0]

# --- Configuración de Movimiento ---
var tween: Tween

func mover_indicador(dia_index: int):
	dia_index = clamp(dia_index, 0, 6)
	var y_objetivo = posiciones[dia_index]	
	if tween and tween.is_running():
		tween.kill()	
	tween = create_tween()
	tween.tween_property(self, "position:y", y_objetivo,0)




