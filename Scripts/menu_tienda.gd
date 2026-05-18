extends Control
@export var fila: PackedScene
@export var menu_disponibles: Texture2D
@export var menu_comprados: Texture2D
var comprados: bool = false 
func _ready() -> void:
	configurar_menu()
	Global.money_changed.connect(configurar_menu)

func configurar_menu() -> void:
	var columna = false
	if comprados:
		$Fondo.texture = menu_comprados
	else:
		$Fondo.texture = menu_disponibles
	for hijo in $columna1.get_children():
		hijo.queue_free()
	for hijo in $columna2.get_children():
		hijo.queue_free()
	var lista = []
	if comprados:
		lista = Global.inventario
	else:
		lista = Global.objetos_disponibles
	for objeto in lista:
		var fila_nueva = fila.instantiate()
		if columna:
			$columna1.add_child(fila_nueva)
		else:
			$columna2.add_child(fila_nueva)
		columna = !columna
		fila_nueva.configurar(objeto, comprados)
		fila_nueva.get_node("Boton").pressed.connect(_on_fila_pressed.bind(objeto))

func _on_fila_pressed(objeto: ResourceObjeto) -> void:
	if comprados:
		match Global.pago_activo:
			0:
				Global.change_money(objeto.costo)
			1:
				Global.change_money_bank(objeto.costo)
			2:
				Global.change_money(objeto.costo)
		Global.inventario.erase(objeto)
		Global.objetos_disponibles.append(objeto)
		quitar_atributos(objeto)
	else:
		match Global.pago_activo:
			0:
				Global.change_money(-objeto.costo)
			1:
				Global.change_money_bank(-objeto.costo)
			2:
				Global.change_money(-objeto.costo)
		Global.inventario.append(objeto)
		Global.objetos_disponibles.erase(objeto)
		asignar_atributos(objeto)	
	configurar_menu()
		


func _on_disponibles_pressed() -> void:
	comprados = false
	configurar_menu()

func _on_comprados_pressed() -> void:
	comprados = true
	configurar_menu()

func asignar_atributos(objeto: ResourceObjeto) -> void:
	Global.multiplicador_cortisol += objeto.cortisol * 0.01
	Global.multiplicador_salud += objeto.salud * 0.01
	Global.multiplicador_felicidad += objeto.felicidad * 0.01
	for gamestate in objeto.gamestates:
		Global.gamestates[gamestate] = true
	
func quitar_atributos(objeto: ResourceObjeto) -> void:
	Global.multiplicador_cortisol -= objeto.cortisol * 0.01
	Global.multiplicador_salud -= objeto.salud * 0.01
	Global.multiplicador_felicidad -= objeto.felicidad * 0.01
	for gamestate in objeto.gamestates:
		Global.gamestates[gamestate] = false
