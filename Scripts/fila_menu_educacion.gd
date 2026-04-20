extends Control

func configurar(curso: ResourceCurso, activos: bool) -> void:
	$info/nombre.text = curso.nombre
	var horario_str = ""
	horario_str += str(curso.horario[0]) + ":00-" + str(curso.horario[1]) + ":00"
	$info/horario.text =horario_str
	var dias_str: Array
	for dia in curso.dias_semana:
		match dia:
			1:
				dias_str.append( "Lun" )
			2:
				dias_str.append( "Mar" )	
			3:
				dias_str.append( "Mie" )
			4:
				dias_str.append( "Jue" )
			5:
				dias_str.append( "Vie" )
			6:
				dias_str.append( "Sab" )
			7:
				dias_str.append( "Dom" )
	if curso.dias_semana[0] == curso.dias_semana[1]:
		$info/dias.text = dias_str[0]
	else:
		$info/dias.text = "-".join(dias_str)
	$info/meses.text = str(curso.duracion_meses)
	var costo_round: String
	if curso.costo_semestre >= 1000000:
		costo_round = str(int(curso.costo_semestre/1000000.0)) + "M"
	else:
		costo_round = str(int(curso.costo_semestre/1000.0)) + "k"
	if curso.costo_semestre == 0:
		$info/costo.text = "Gratis"
	else:
		$info/costo.text = "$" + str(costo_round)
	if activos:
		if curso.nombre == "Secundaria":
			$Button.disabled = true
		else:
			$Button.disabled = false
			$info/meses/progreso.self_modulate = Color(1, 1, 1, 1)
	else:
		$info/meses/progreso.self_modulate = Color(1, 1, 1, 0)	
		if not Global.horario_libre(curso.horario[0], curso.horario[1], curso.dias_semana):
			$info/horario.self_modulate = Color(1, 0.5, 0.5, 1)
			$info/dias.self_modulate = Color(1, 0.5, 0.5, 1)
			$Button.disabled = true
		else:
			$Button.disabled = false
	$info/meses/progreso.value = curso.progeso