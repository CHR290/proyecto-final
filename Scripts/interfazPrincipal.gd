extends Control
@onready var contenedor_eventos = $Contenido/Eventos
@onready var fondo = $Contenido/Fondo
func _ready():
	Global.event_triggered.connect(lanzar_evento)
	Global.menu_changed.connect(gestionar_menu)
	$Contenido/Fondo.play("default")

# Función para disparar cualquier evento
func lanzar_evento():
	#Cargar el archivo .tres
	var recurso = load(Global.evento) as EventResource
	if not recurso: return	
	#Instanciar la escena receptora
	var escena_evento= load("res://Scenes/Eventos.tscn")
	var instancia_evento = escena_evento.instantiate()
	#Añadirla al nodo de eventos
	contenedor_eventos.add_child(instancia_evento)
	instancia_evento.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	#Pasar los datos para que se dibuje
	instancia_evento.configurar_evento(recurso)

#funcion para abrir y cerrar menus
func gestionar_menu(menu_id: int):
	for n in $Contenido/menus.get_children():
		n.queue_free()
	if menu_id == Global.menu_actual:	
		Global.menu_actual = 0
		return	
	var nombre_menu: String
	match menu_id:
		1:
			nombre_menu = "menu_trabajo"
		2:
			nombre_menu = "menu_banco"
		3:
			nombre_menu = "menu_educacion"
		4:
			nombre_menu = "menu_tienda"
		5:
			nombre_menu = "menu_inversiones"
		6:
			nombre_menu = "menu_finanzas"
			Global.imprimir_horario()					
		7:
			nombre_menu = "menu_calendario"
	var ruta_menu = "res://Scenes/" + nombre_menu + ".tscn"
	var escena_menu = load(ruta_menu)
	var instancia_menu = escena_menu.instantiate()
	$Contenido/menus.add_child(instancia_menu)
	instancia_menu.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	Global.menu_actual = menu_id



	
