extends Control
@onready var contenedor_eventos = $Contenido/Eventos
func _ready():
	Global.event_triggered.connect(lanzar_evento)
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

