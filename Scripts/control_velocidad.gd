extends TextureRect

@export_group("Configuración de Pasos")
@export var posiciones: Array[float] = [0.0, 36.0, 72.0, 108.0, 144.0] 

var dragging: bool = false

func _gui_input(event: InputEvent):
	# Detectar inicio y fin del clic
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			if not dragging:
				actualizar_posicion(position.x)

	# Detectar movimiento mientras se arrastra
	if event is InputEventMouseMotion and dragging:
		# Calcular la posición relativa al padre
		var mouse_x = get_parent().get_local_mouse_position().x
		actualizar_posicion(mouse_x)

func actualizar_posicion(target_x: float):
	var mejor_distancia = 99999.0
	var mejor_indice = 0
	
	# Buscar cuál de las 5 posiciones está más cerca del mouse
	for i in range(posiciones.size()):
		var dist = abs(target_x - posiciones[i])
		if dist < mejor_distancia:
			mejor_distancia = dist
			mejor_indice = i
	
	# Salto instantáneo a la posición fija
	position.x = posiciones[mejor_indice]
	

	get_node("/root/InterfazPrincipal/Reloj").speed = mejor_indice
