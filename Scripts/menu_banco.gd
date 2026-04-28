extends Control
func _ready() -> void:
	actualizar_menu()
	Global.money_changed.connect(actualizar_menu)

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
