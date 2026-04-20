extends Control
@export var fila: PackedScene
@onready var contenedor_filas = $ScrollContainer/VBoxContainer
@onready var scroll = $ScrollContainer
var activos: bool = false # Estado de la pestaña actual

func _ready() -> void:
	actualizar_tabla()
	$switch.pressed.connect(on_switch_pressed)

func actualizar_tabla() -> void:
	for child in contenedor_filas.get_children():
		child.queue_free() 
	var lista = []
	if activos:
		lista = Global.trabajos_activos
	else:
		lista = Global.trabajos_disponibles
	for trabajo in lista:	
		if not activos and not Global.trabajo_cumple_requisitos(trabajo):
			continue
		var fila_nueva = fila.instantiate()
		contenedor_filas.add_child(fila_nueva)
		fila_nueva.configurar(trabajo, activos)
		fila_nueva.get_node("Button").pressed.connect(_on_fila_pressed.bind(trabajo))
func on_switch_pressed():
	activos = !activos
	actualizar_tabla()
	scroll.scroll_vertical = 0

func _on_fila_pressed(trabajo: ResourceTrabajo):
	if activos:
		Global.renunciar_trabajo(trabajo)
	else:
		Global.contratar_trabajo(trabajo)
	actualizar_tabla()

func _gui_input(event):
	var altura_fila = 36 	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			scroll.scroll_vertical -= altura_fila
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			scroll.scroll_vertical += altura_fila
