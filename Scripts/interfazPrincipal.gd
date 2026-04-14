extends Control
@onready var contenedor_eventos = $Contenido/Eventos

# Función para disparar cualquier evento
func lanzar_evento(ruta_recurso: String):
	#Cargar el archivo .tres
	var recurso = load(ruta_recurso) as EventResource
	if not recurso: return
	
	#Instanciar la escena receptora
	var escena_evento= load("res://Scenes/Eventos.tscn")
	var instancia_evento = escena_evento.instantiate()
	
	#Añadirla al nodo de eventos
	contenedor_eventos.add_child(instancia_evento)
	instancia_evento.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	#Pasar los datos para que se dibuje
	instancia_evento.configurar_evento(recurso)

# Ejemplo de uso (puedes llamarlo desde un botón o el reloj)
