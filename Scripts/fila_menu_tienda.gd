extends Control

func configurar(objeto: ResourceObjeto, comprados: bool) -> void:
	var dinero_disponible: int
	match Global.pago_activo:
		0:
			dinero_disponible = Global.dinero_efectivo
		1:
			dinero_disponible = Global.dinero_banco
		2:
			dinero_disponible = Global.dinero_credito

	$info/Objeto.text = objeto.nombre
	var costo_round: String
	if objeto.costo >= 1000000:
		costo_round = str(int(objeto.costo/1000000.0)) + "M"
	else:
		costo_round = str(int(objeto.costo/1000.0)) + "k"
	if objeto.costo == 0:
		$info/Costo.text = "Gratis"
	else:
		$info/Costo.text = "$ " + str(costo_round)
	if !comprados:
		if objeto.costo > dinero_disponible:
			$Boton.disabled = true
		else:
			$Boton.disabled = false
	else:
		$Boton.disabled = false

func _on_boton_pressed() -> void:
	print("Boton presionado para objeto: " + $info/Objeto.text)
