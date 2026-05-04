extends Control
func _ready() -> void:
	actualizar_menu()
	Global.money_changed.connect(actualizar_menu)
	$tiempo_ahorro.hide()

func actualizar_menu():
	$dinero.text = "$"+str(Global.dinero_banco)
	actualizar_barra()

func _on_depositar_pressed() -> void:
	Global.lanzar_evento(1)

func _on_retirar_pressed() -> void:
	Global.lanzar_evento(2)

func actualizar_barra():
	var posicion = int((Global.score_crediticio/1000.0)*244)
	$score_crediticio/medidor.position = Vector2(posicion,0)


func _on_prestamos_pressed() -> void:
	pass # Replace with function body.


func _on_seguros_pressed() -> void:
	pass # Replace with function body.


func _on_tarjetas_pressed() -> void:
	pass # Replace with function body.


func _on_ahorros_pressed() -> void:
	if Global.gamestates["ahorro activo"] == false:
		Global.lanzar_evento(3)
	else:
		Global.lanzar_evento(5)
		$tiempo_ahorro.show()
		$tiempo_ahorro.text = "faltan " + str(Global.tiempo_ahorro) + " dias"
		await get_tree().create_timer(2).timeout
		$tiempo_ahorro.hide()
