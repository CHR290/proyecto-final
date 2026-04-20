extends Control

func configurar(trabajo: ResourceTrabajo, activos: bool) -> void:
	$info/icono.texture = trabajo.icono
	$info/nombre.text = trabajo.nombre
	var horario_str = ""
	horario_str += str(trabajo.horario[0]) + ":00-" + str(trabajo.horario[1]) + ":00"
	$info/horario.text =horario_str
	var dias_str: Array
	for dia in trabajo.dias_semana:
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
	if trabajo.dias_semana[0] == trabajo.dias_semana[1]:
		$info/dias.text = dias_str[0]
	else:
		$info/dias.text = "-".join(dias_str)
	$info/pago.text = "$" + str(int(trabajo.paga_por_hora/1000.0)) + "k/h"
	if activos:
		$Button.disabled = false	
	else:	
		if not Global.horario_libre(trabajo.horario[0], trabajo.horario[1], trabajo.dias_semana):

			$info/horario.self_modulate = Color(1, 0.5, 0.5, 1)
			$info/dias.self_modulate = Color(1, 0.5, 0.5, 1)
			$Button.disabled = true
		else:
			$info/horario.add_theme_color_override("font_color", Color.WHITE)
			$Button.disabled = false
